//! The interpreter's platform services use the existing compiled GPUI backend.
//! This stream is independent of the component's frame and event transport.
#![allow(clippy::disallowed_methods, reason = "worker platform transport")]
use anyhow::{Context, Result};
use std::{
    io::{Read, Write},
    net::{TcpListener, TcpStream},
    sync::{
        Arc, Mutex,
        atomic::{AtomicBool, AtomicU64, AtomicUsize, Ordering},
    },
    thread,
    time::Duration,
};

pub struct PlatformService {
    pub address: String,
    stop: Arc<AtomicBool>,
    connections: Arc<Connections>,
    thread: Option<thread::JoinHandle<()>>,
}
#[derive(Default)]
struct Connections {
    latest: AtomicU64,
    active: AtomicUsize,
    failure: Mutex<Option<String>>,
    idle: Mutex<Vec<gpui_codepen_guest::rpc::TextService>>,
}
impl Connections {
    fn report(&self, id: u64, error: Option<String>) {
        let mut failure = self.failure.lock().unwrap();
        if self.latest.load(Ordering::Acquire) == id {
            *failure = error;
        }
    }
}
struct ActiveConnection(Arc<Connections>);
impl Drop for ActiveConnection {
    fn drop(&mut self) {
        self.0.active.fetch_sub(1, Ordering::AcqRel);
    }
}
impl PlatformService {
    #[cfg(test)]
    pub fn new() -> Result<Self> {
        Self::with_factory(gpui_codepen_guest::rpc::TextService::portable_factory())
    }
    pub fn with_factory(factory: gpui_codepen_guest::rpc::TextSystemFactory) -> Result<Self> {
        let listener = TcpListener::bind("127.0.0.1:0")?;
        listener.set_nonblocking(true)?;
        let address = listener.local_addr()?.to_string();
        let stop = Arc::new(AtomicBool::new(false));
        let stopped = stop.clone();
        let connections = Arc::new(Connections::default());
        connections
            .idle
            .lock()
            .unwrap()
            .push(gpui_codepen_guest::rpc::TextService::with_factory(
                factory.clone(),
            )?);
        let incoming = connections.clone();
        let thread = thread::spawn(move || {
            while !stopped.load(Ordering::Relaxed) {
                match listener.accept() {
                    Ok((mut stream, _)) => {
                        // A previous interpreter may have been cancelled inside a
                        // native shaping operation. Its backend belongs to its
                        // connection; the next edit never waits for that call.
                        let id = incoming.latest.fetch_add(1, Ordering::AcqRel) + 1;
                        incoming.report(id, None);
                        if incoming.active.load(Ordering::Acquire) >= 4 {
                            let message = "GPUI text service is busy with previous revisions. Run again in a moment.";
                            incoming.report(id, Some(message.into()));
                            if let Ok(reply) = gpui_codepen_guest::wire::encode_value(
                                &Err::<(), _>(message.to_owned()),
                            ) {
                                // Fail explicitly without waiting for another
                                // backend or retaining a fifth native operation.
                                let _ = stream.set_write_timeout(Some(Duration::from_millis(100)));
                                let _ = stream.write_all(&(reply.len() as u32).to_le_bytes());
                                let _ = stream.write_all(&reply);
                            }
                            continue;
                        }
                        incoming.active.fetch_add(1, Ordering::AcqRel);
                        let active = ActiveConnection(incoming.clone());
                        let stopped = stopped.clone();
                        let factory = factory.clone();
                        thread::spawn(move || {
                            let connections = &active.0;
                            let cached = connections.idle.lock().unwrap().pop();
                            let text = cached.map(Ok).unwrap_or_else(|| {
                                gpui_codepen_guest::rpc::TextService::with_factory(factory.clone())
                            });
                            match text {
                                Ok(mut text) => {
                                    let result =
                                        serve(&mut stream, &stopped, &mut text, connections, id);
                                    if let Err(error) = result {
                                        connections.report(id, Some(format!("{error:#}")));
                                    }
                                    if !stopped.load(Ordering::Relaxed) {
                                        // Keep one warm backend, without accumulating
                                        // font collections after rapid revisions.
                                        let mut idle = connections.idle.lock().unwrap();
                                        if idle.is_empty() {
                                            idle.push(text);
                                        }
                                    }
                                }
                                Err(error) => connections.report(id, Some(format!("{error:#}"))),
                            }
                        });
                    }
                    Err(error) if error.kind() == std::io::ErrorKind::WouldBlock => {
                        thread::sleep(Duration::from_millis(5));
                    }
                    Err(error) => {
                        *incoming.failure.lock().unwrap() =
                            Some(format!("accept platform connection: {error}"));
                        break;
                    }
                }
            }
        });
        Ok(Self {
            address,
            stop,
            connections,
            thread: Some(thread),
        })
    }
    pub fn failure(&self) -> Option<String> {
        self.connections.failure.lock().unwrap().clone()
    }
}
fn serve(
    stream: &mut TcpStream,
    stop: &AtomicBool,
    text: &mut gpui_codepen_guest::rpc::TextService,
    connections: &Connections,
    id: u64,
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
        let mut reply = text.handle(&request);
        if reply.len() > gpui_codepen_guest::MAX_FRAME_BYTES {
            reply = gpui_codepen_guest::wire::encode_value(&Err::<(), _>(
                "platform response exceeds transport budget".to_owned(),
            ))
            .map_err(anyhow::Error::msg)?;
        }
        let mut packet = (reply.len() as u32).to_le_bytes().to_vec();
        packet.extend_from_slice(&reply);
        stream
            .write_all(&packet)
            .with_context(|| format!("write platform response ({} bytes)", reply.len()))?;
        connections.report(id, None);
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

    #[test]
    fn stalled_previous_connection_does_not_block_a_new_interpreter() {
        let service = PlatformService::new().unwrap();
        let mut previous = TcpStream::connect(&service.address).unwrap();
        // Leave the old stream within a request. The serial implementation
        // would never accept the second interpreter until this stream closed.
        previous.write_all(&[4]).unwrap();
        let mut current = TcpStream::connect(&service.address).unwrap();
        current
            .set_read_timeout(Some(Duration::from_secs(5)))
            .unwrap();
        generation(&mut current, false);
        assert!(service.failure().is_none());
        let start = std::time::Instant::now();
        drop(service);
        assert!(
            start.elapsed() < Duration::from_secs(1),
            "service shutdown must not wait for an abandoned backend"
        );
    }
}
