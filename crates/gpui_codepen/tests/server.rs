#![cfg(not(target_family = "wasm"))]
#![allow(
    clippy::disallowed_methods,
    reason = "integration tests control a real compiler companion"
)]
use gpui_ce_codepen::{
    guest::PreviewContext,
    lessons::LESSONS,
    session::{Backend, Reply, Request},
};
use serde_json::json;
use gpui::{PlatformInput, MouseDownEvent, MouseUpEvent, point, px};
use std::{
    io::{Read, Write},
    net::{TcpListener, TcpStream},
    process::{Child, Command, Stdio},
    time::{Duration, Instant},
};

struct Companion(Child);
impl Drop for Companion {
    fn drop(&mut self) {
        let _ = self.0.kill();
        let _ = self.0.wait();
    }
}
fn post(port: u16, input: &Request, origin: &str) -> (u16, String) {
    post_body(
        port,
        "/api/render",
        &serde_json::to_string(input).unwrap(),
        origin,
    )
}
fn post_body(port: u16, path: &str, body: &str, origin: &str) -> (u16, String) {
    let mut socket = TcpStream::connect(("127.0.0.1", port)).unwrap();
    socket
        .set_read_timeout(Some(Duration::from_secs(60)))
        .unwrap();
    write!(socket, "POST {path} HTTP/1.0\r\nHost: 127.0.0.1\r\nContent-Type: application/json\r\nOrigin: {origin}\r\nContent-Length: {}\r\n\r\n{body}", body.len()).unwrap();
    let mut output = String::new();
    socket.read_to_string(&mut output).unwrap();
    let (headers, body) = output.split_once("\r\n\r\n").unwrap();
    (
        headers.split_whitespace().nth(1).unwrap().parse().unwrap(),
        body.into(),
    )
}
fn request(id: &str, generation: u64, source: &str, backend: Backend) -> Request {
    Request {
        session_id: id.into(),
        generation,
        source: source.into(),
        backend,
        restart: false,
        input: PreviewContext::default(),
    }
}

#[test]
#[ignore = "requires setup.py"]
fn browser_companion_cancels_edits_and_separates_sessions() {
    let port = TcpListener::bind(("127.0.0.1", 0))
        .unwrap()
        .local_addr()
        .unwrap()
        .port();
    let _server = Companion(
        Command::new(env!("CARGO_BIN_EXE_gpui-codepen-server"))
            .env("GPUI_CODEPEN_PORT", port.to_string())
            .stdout(Stdio::null())
            .spawn()
            .unwrap(),
    );
    let start = Instant::now();
    while TcpStream::connect(("127.0.0.1", port)).is_err() {
        assert!(start.elapsed() < Duration::from_secs(10));
        std::thread::sleep(Duration::from_millis(25));
    }
    let a = uuid::Uuid::new_v4().to_string();
    let b = uuid::Uuid::new_v4().to_string();
    let valid = request(&a, 1, LESSONS[0].source, Backend::Miri);
    assert_eq!(post(port, &valid, "https://unrelated.example").0, 400);
    let invalid = request("invalid-id", 1, LESSONS[0].source, Backend::Miri);
    assert_eq!(post(port, &invalid, "http://127.0.0.1:8080").0, 400);
    let spin = request(
        &a,
        1,
        &COUNTER.replace("cx.new(|_|Counter{count:0})", "{loop {std::hint::black_box(1);} }"),
        Backend::Miri,
    );
    let previous = std::thread::spawn(move || post(port, &spin, "http://127.0.0.1:8080"));
    std::thread::sleep(Duration::from_millis(500));
    let other = request(&b, 1, COUNTER, Backend::Miri);
    let independent = std::thread::spawn(move || post(port, &other, "http://127.0.0.1:8080"));
    let next = request(&a, 2, LESSONS[0].source, Backend::Miri);
    let (status, body) = post(port, &next, "http://127.0.0.1:8080");
    assert_eq!(status, 200);
    let reply: Reply = serde_json::from_str(&body).unwrap();
    assert!(reply.frame.is_some(), "{}", reply.diagnostics);
    let (status, body) = previous.join().unwrap();
    assert!(
        status == 409
            || serde_json::from_str::<Reply>(&body)
                .unwrap()
                .diagnostics
                .contains("Superseded")
    );
    let (status, body) = independent.join().unwrap();
    assert_eq!(status, 200);
    let reply: Reply = serde_json::from_str(&body).unwrap();
    let before = reply.frame.unwrap();
    assert_eq!(post(port, &valid, "http://127.0.0.1:8080").0, 409);
    let mut click = request(&b, 2, COUNTER, Backend::Miri);
    click.input.events = vec![
        PlatformInput::MouseDown(MouseDownEvent { position: point(px(20.),px(20.)), ..Default::default() }),
        PlatformInput::MouseUp(MouseUpEvent { position: point(px(20.),px(20.)), ..Default::default() }),
    ].into_iter().map(Into::into).collect();
    let (_, body) = post(port, &click, "http://127.0.0.1:8080");
    let reply: Reply = serde_json::from_str(&body).unwrap();
    assert_ne!(before, reply.frame.expect("actual GPUI callback paints a new scene"));
    let spin = request(
        &a,
        3,
        &COUNTER.replace("cx.new(|_|Counter{count:0})", "{loop {std::hint::black_box(1);} }"),
        Backend::Miri,
    );
    let cancelled = std::thread::spawn(move || post(port, &spin, "http://127.0.0.1:8080"));
    std::thread::sleep(Duration::from_millis(500));
    let cancel = json!({"session_id": a, "generation": 3}).to_string();
    assert_eq!(
        post_body(port, "/api/cancel", &cancel, "http://127.0.0.1:8080").0,
        204
    );
    let (status, body) = cancelled.join().unwrap();
    assert!(
        status == 409
            || serde_json::from_str::<Reply>(&body)
                .unwrap()
                .diagnostics
                .contains("Superseded")
    );
    let source = format!("{}\n/*{}*/", LESSONS[0].source, "\0".repeat(35_000));
    let large = request(&a, 4, &source, Backend::Miri);
    assert!(serde_json::to_vec(&large).unwrap().len() > 128 * 1024);
    assert_eq!(post(port, &large, "http://127.0.0.1:8080").0, 200);
}

const COUNTER: &str = r#"use gpui::{*, prelude::*};
struct Counter { count: u32 }
impl Render for Counter {
 fn render(&mut self,_:&mut Window,cx:&mut Context<Self>)->impl IntoElement {
  div().id("counter").w(px(200.)).h(px(100.)).bg(rgb(0x100000+self.count))
   .on_click(cx.listener(|this,_,_,cx|{this.count+=1;cx.notify();}))
 }
}
fn component(_:&mut Window,cx:&mut App)->Entity<Counter>{cx.new(|_|Counter{count:0})}
"#;
