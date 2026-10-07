//! Loopback-only compiler companion for the WASM guide. Trunk proxies /api/.
#[cfg(not(target_family = "wasm"))]
mod native {
    use gpui_ce_codepen::{
        runtime::Runtime,
        session::{Reply, Request},
    };
    use std::{
        collections::HashMap,
        io::Read,
        sync::{
            Arc,
            atomic::{AtomicU64, Ordering},
            mpsc,
        },
        time::{Duration, Instant},
    };
    use tiny_http::{Header, Method, Response, Server, StatusCode};

    struct Worker {
        latest: Arc<AtomicU64>,
        seen: u64,
        send: mpsc::SyncSender<(Request, tiny_http::Request)>,
        used: Instant,
    }
    impl Worker {
        fn new() -> Self {
            let (send, receive) = mpsc::sync_channel::<(Request, tiny_http::Request)>(8);
            let latest = Arc::new(AtomicU64::new(0));
            let generation = latest.clone();
            std::thread::spawn(move || {
                let mut runtime = Runtime::new();
                while let Ok((input, http)) = receive.recv() {
                    if input.generation != generation.load(Ordering::Relaxed) {
                        respond(http, 409, "Superseded by a newer edit".into());
                        continue;
                    }
                    let reply = match &mut runtime {
                        Ok(runtime) => runtime.evaluate(input, &generation),
                        Err(error) => Reply {
                            generation: input.generation,
                            frame: None,
                            diagnostics: error.to_string(),
                            elapsed_ms: 0,
                        },
                    };
                    if http.headers().iter().any(|h| {
                        h.field.equiv("Accept")
                            && h.value.as_str() == gpui_ce_codepen::transport::CONTENT_TYPE
                    }) {
                        let response =
                            Response::from_data(gpui_ce_codepen::transport::encode(&reply))
                                .with_header(
                                    Header::from_bytes(
                                        "Content-Type",
                                        gpui_ce_codepen::transport::CONTENT_TYPE,
                                    )
                                    .unwrap(),
                                );
                        let _ = http.respond(response);
                    } else {
                        respond(http, 200, serde_json::to_string(&reply).unwrap());
                    }
                }
            });
            Self {
                latest,
                seen: 0,
                send,
                used: Instant::now(),
            }
        }
    }
    impl Drop for Worker {
        fn drop(&mut self) {
            self.latest.store(u64::MAX, Ordering::Relaxed);
        }
    }
    fn respond(request: tiny_http::Request, status: u16, body: String) {
        let response = Response::from_string(body)
            .with_status_code(StatusCode(status))
            .with_header(Header::from_bytes("Content-Type", "application/json").unwrap());
        let _ = request.respond(response);
    }
    #[derive(serde::Deserialize)]
    #[serde(deny_unknown_fields)]
    struct Cancel {
        session_id: String,
        generation: u64,
    }
    enum Operation {
        Render(Request),
        Cancel(Cancel),
    }
    fn allowed_origin(origin: &str, extra: &str) -> bool {
        ["http://127.0.0.1:8080", "http://localhost:8080"].contains(&origin)
            || extra.split(',').map(str::trim).any(|candidate| {
                candidate == origin && ["http://127.0.0.1:", "http://localhost:"]
                    .iter().any(|prefix| candidate.strip_prefix(prefix)
                        .is_some_and(|port| port.parse::<u16>().is_ok_and(|port| port > 0)))
            })
    }
    fn decode(request: &mut tiny_http::Request, port: u16) -> anyhow::Result<Operation> {
        if request.method() != &Method::Post
            || !["/api/render", "/api/cancel"].contains(&request.url())
        {
            anyhow::bail!("POST /api/render or /api/cancel required");
        }
        let header = |name| {
            request
                .headers()
                .iter()
                .find(|h| h.field.equiv(name))
                .map(|h| h.value.as_str())
        };
        // Trunk replaces Host with the upstream hostname without its port.
        let hosts = [
            "127.0.0.1".to_owned(),
            "localhost".to_owned(),
            format!("127.0.0.1:{port}"),
            format!("localhost:{port}"),
        ];
        if !header("Host").is_some_and(|host| hosts.iter().any(|allowed| host == allowed)) {
            anyhow::bail!("invalid Host header");
        }
        if header("Content-Type") != Some("application/json") {
            anyhow::bail!("application/json required");
        }
        if let Some(origin) = header("Origin") {
            let configured = std::env::var("GPUI_CODEPEN_ALLOWED_ORIGINS")
                .or_else(|_| std::env::var("GPUI_CODEPEN_ORIGINS"))
                .unwrap_or_default();
            if !allowed_origin(origin, &configured) {
                anyhow::bail!("local guide origin required");
            }
        }
        // A 64 KiB source can expand sixfold when JSON escapes control bytes.
        const MAX_REQUEST: usize = 512 * 1024;
        if request.body_length().is_some_and(|n| n > MAX_REQUEST) {
            anyhow::bail!("request too large");
        }
        let mut bytes = Vec::new();
        request
            .as_reader()
            .take((MAX_REQUEST + 1) as u64)
            .read_to_end(&mut bytes)?;
        if bytes.len() > MAX_REQUEST {
            anyhow::bail!("request too large");
        }
        if request.url() == "/api/cancel" {
            let cancel: Cancel = serde_json::from_slice(&bytes)?;
            uuid::Uuid::parse_str(&cancel.session_id)?;
            Ok(Operation::Cancel(cancel))
        } else {
            let input: Request = serde_json::from_slice(&bytes)?;
            uuid::Uuid::parse_str(&input.session_id)?;
            Ok(Operation::Render(input))
        }
    }
    pub fn run() -> anyhow::Result<()> {
        let port: u16 = std::env::var("GPUI_CODEPEN_PORT")
            .unwrap_or_else(|_| "8092".into())
            .parse()?;
        let server = Server::http(format!("127.0.0.1:{port}"))
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;
        println!(
            "GPUI compiler listening on http://127.0.0.1:{port}/api/render (Trunk local proxy)"
        );
        let mut workers: HashMap<String, Worker> = HashMap::new();
        // The receive loop never waits for a compiler. A new generation updates
        // the watchdog immediately; each view has its own serialized state flow.
        for mut http in server.incoming_requests() {
            workers.retain(|_, worker| worker.used.elapsed() < Duration::from_secs(15 * 60));
            let input = match decode(&mut http, port) {
                Ok(Operation::Render(input)) => input,
                Ok(Operation::Cancel(cancel)) => {
                    if let Some(worker) = workers.get(&cancel.session_id) {
                        if worker.seen == cancel.generation {
                            worker
                                .latest
                                .store(cancel.generation.wrapping_add(1), Ordering::Relaxed);
                        }
                    }
                    respond(http, 204, String::new());
                    continue;
                }
                Err(error) => {
                    respond(http, 400, error.to_string());
                    continue;
                }
            };
            if !workers.contains_key(&input.session_id) && workers.len() >= 16 {
                respond(http, 429, "Too many workbenches".into());
                continue;
            }
            let worker = workers
                .entry(input.session_id.clone())
                .or_insert_with(Worker::new);
            worker.used = Instant::now();
            if input.generation <= worker.seen {
                respond(http, 409, "Superseded by a newer edit".into());
                continue;
            }
            worker.seen = input.generation;
            worker.latest.store(input.generation, Ordering::Relaxed);
            if let Err(
                mpsc::TrySendError::Full((_, http)) | mpsc::TrySendError::Disconnected((_, http)),
            ) = worker.send.try_send((input, http))
            {
                respond(http, 429, "Compiler queue is full".into());
            }
        }
        Ok(())
    }
    #[cfg(test)]
    mod tests {
        #[test]
        fn configured_documentation_origins_are_explicit_local_ports() {
            let extra = "http://127.0.0.1:1111, http://localhost:1111";
            assert!(super::allowed_origin("http://127.0.0.1:1111", extra));
            assert!(super::allowed_origin("http://localhost:1111", extra));
            assert!(super::allowed_origin("http://localhost:8080", ""));
            assert!(!super::allowed_origin("http://localhost:1111", ""));
            assert!(!super::allowed_origin("https://example.com:1111", "https://example.com:1111"));
            assert!(!super::allowed_origin("http://localhost:1111/path", "http://localhost:1111/path"));
        }
    }
}
#[cfg(not(target_family = "wasm"))]
fn main() -> anyhow::Result<()> {
    native::run()
}
#[cfg(target_family = "wasm")]
fn main() {}
