//! The interpreter's platform services use the existing compiled GPUI backend.
//! This stream is independent of the component's frame and event transport.
#![allow(clippy::disallowed_methods, reason = "worker platform transport")]
use anyhow::{Context, Result};
use std::{
    io::{Read, Write},
    net::{TcpListener, TcpStream},
    sync::{
        Arc, Mutex,
        atomic::{AtomicBool, Ordering},
    },
    thread,
    time::Duration,
};

pub struct PlatformService {
    pub address: String,
    stop: Arc<AtomicBool>,
    failure: Arc<Mutex<Option<String>>>,
    thread: Option<thread::JoinHandle<()>>,
}
impl PlatformService {
    pub fn new() -> Result<Self> {
        let listener = TcpListener::bind("127.0.0.1:0")?;
        listener.set_nonblocking(true)?;
        let address = listener.local_addr()?.to_string();
        let stop = Arc::new(AtomicBool::new(false));
        let stopped = stop.clone();
        let failure = Arc::new(Mutex::new(None));
        let failed = failure.clone();
        let mut text = gpui_codepen_guest::rpc::TextService::new()?;
        let thread = thread::spawn(move || {
            while !stopped.load(Ordering::Relaxed) {
                match listener.accept() {
                    Ok((mut stream, _)) => {
                        let result = serve(&mut stream, &stopped, &mut text, &failed);
                        if let Err(error) = result {
                            *failed.lock().unwrap() = Some(format!("{error:#}"));
                        }
                    }
                    Err(error) if error.kind() == std::io::ErrorKind::WouldBlock => {
                        thread::sleep(Duration::from_millis(5));
                    }
                    Err(error) => {
                        *failed.lock().unwrap() =
                            Some(format!("accept platform connection: {error}"));
                        break;
                    }
                }
            }
        });
        Ok(Self {
            address,
            stop,
            failure,
            thread: Some(thread),
        })
    }
    pub fn failure(&self) -> Option<String> {
        self.failure.lock().unwrap().clone()
    }
}
fn serve(
    stream: &mut TcpStream,
    stop: &AtomicBool,
    text: &mut gpui_codepen_guest::rpc::TextService,
    failure: &Mutex<Option<String>>,
) -> Result<()> {
    stream.set_nodelay(true)?;
    stream.set_read_timeout(Some(Duration::from_millis(100)))?;
    stream.set_write_timeout(Some(Duration::from_secs(5)))?;
    while !stop.load(Ordering::Relaxed) {
        let mut header = [0; 4];
        let mut received = 0;
        while received < header.len() && !stop.load(Ordering::Relaxed) {
            match stream.read(&mut header[received..]) {
                Ok(0) if received == 0 => return Ok(()),
                Ok(0) => anyhow::bail!(
                    "platform request ended within length header ({received}/4 bytes)"
                ),
                Ok(n) => received += n,
                Err(error)
                    if matches!(
                        error.kind(),
                        std::io::ErrorKind::TimedOut | std::io::ErrorKind::WouldBlock
                    ) => {}
                Err(error) => return Err(error).context("read platform request length"),
            }
        }
        if stop.load(Ordering::Relaxed) {
            return Ok(());
        }
        let len = u32::from_le_bytes(header) as usize;
        anyhow::ensure!(
            len <= gpui_codepen_guest::MAX_FRAME_BYTES,
            "platform request exceeds budget ({len} bytes)"
        );
        let mut request = vec![0; len];
        let mut received = 0;
        while received < len && !stop.load(Ordering::Relaxed) {
            match stream.read(&mut request[received..]) {
                Ok(0) => {
                    anyhow::bail!("platform request ended within body ({received}/{len} bytes)")
                }
                Ok(n) => received += n,
                Err(error)
                    if matches!(
                        error.kind(),
                        std::io::ErrorKind::TimedOut
                            | std::io::ErrorKind::WouldBlock
                            | std::io::ErrorKind::Interrupted
                    ) => {}
                Err(error) => {
                    return Err(error).with_context(|| {
                        format!("read platform request body ({received}/{len} bytes)")
                    });
                }
            }
        }
        if stop.load(Ordering::Relaxed) {
            return Ok(());
        }
        if std::env::var_os("GPUI_CODEPEN_PROFILE").is_some() {
            eprintln!("GPUI RPC received {received} bytes");
        }
        let reply = text.handle(&request);
        anyhow::ensure!(
            reply.len() <= gpui_codepen_guest::MAX_FRAME_BYTES,
            "platform response exceeds budget ({} bytes)",
            reply.len()
        );
        let mut packet = (reply.len() as u32).to_le_bytes().to_vec();
        packet.extend_from_slice(&reply);
        stream
            .write_all(&packet)
            .with_context(|| format!("write platform response ({} bytes)", reply.len()))?;
        *failure.lock().unwrap() = None;
    }
    Ok(())
}
impl Drop for PlatformService {
    fn drop(&mut self) {
        self.stop.store(true, Ordering::Relaxed);
        if let Some(thread) = self.thread.take() {
            let _ = thread.join();
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn generation(stream: &mut TcpStream, split_header: bool) -> u64 {
        // Generation is an ordinary platform call; exercise the actual bridge
        // without fonts or layout changes obscuring stream behavior.
        let request =
            gpui_codepen_guest::wire::encode_value(&gpui_codepen_guest::rpc::Call::Generation {})
                .unwrap();
        let header = (request.len() as u32).to_le_bytes();
        if split_header {
            stream.write_all(&header[..2]).unwrap();
            thread::sleep(Duration::from_millis(130));
            stream.write_all(&header[2..]).unwrap();
        } else {
            stream.write_all(&header).unwrap();
        }
        stream.write_all(&request).unwrap();
        let mut header = [0; 4];
        stream.read_exact(&mut header).unwrap();
        let mut reply = vec![0; u32::from_le_bytes(header) as usize];
        stream.read_exact(&mut reply).unwrap();
        let result: Result<u64, String> = gpui_codepen_guest::wire::decode_value(&reply).unwrap();
        result.unwrap()
    }
    #[test]
    fn partial_headers_and_reconnections_preserve_platform_calls() {
        let mut service = PlatformService::new().unwrap();
        let first = {
            let mut stream = TcpStream::connect(&service.address).unwrap();
            stream
                .set_read_timeout(Some(Duration::from_secs(5)))
                .unwrap();
            let generation = generation(&mut stream, true);
            assert_eq!(generation, self::generation(&mut stream, false));
            generation
        };
        let mut stream = TcpStream::connect(&service.address).unwrap();
        stream
            .set_read_timeout(Some(Duration::from_secs(5)))
            .unwrap();
        assert_eq!(first, generation(&mut stream, false));
        assert!(service.failure().is_none());
        service.stop.store(true, Ordering::Relaxed);
        service.thread.take().unwrap().join().unwrap();
    }
}
