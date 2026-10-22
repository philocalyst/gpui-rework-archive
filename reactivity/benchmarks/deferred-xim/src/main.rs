//! Correctness probe, deliberately not a startup benchmark. Runs on an isolated X server.
use std::{
    fs::{self, File, OpenOptions},
    process::{Child, Command},
    sync::Arc,
    time::{Duration, Instant},
};
use winit::{
    event::{ElementState, Event, Ime, WindowEvent},
    event_loop::EventLoop,
    platform::{pump_events::EventLoopExtPumpEvents, x11::EventLoopBuilderExtX11},
    window::Window,
};
use x11rb::{
    connection::Connection,
    protocol::{
        xproto::{self, ConnectionExt as _, InputFocus},
        xtest::ConnectionExt as _,
    },
    rust_connection::RustConnection,
    CURRENT_TIME, NONE,
};

#[derive(Debug)]
struct Observed {
    window: u32,
    kind: &'static str,
    text: String,
}
struct Probe {
    windows: Vec<Option<Arc<Window>>>,
    events: Vec<Observed>,
    focused: Option<u32>,
    create_late: bool,
    redraws: usize,
    enable_on_focus: Option<(usize, u8)>,
    modifiers: winit::keyboard::ModifiersState,
}
impl Probe {
    fn xid(&self, index: usize) -> u32 {
        u64::from(self.windows[index].as_ref().unwrap().id()) as u32
    }
    #[allow(deprecated)]
    fn pump(&mut self, el: &mut EventLoop<()>) {
        self.pump_timeout(el, Some(Duration::from_millis(10)));
    }
    #[allow(deprecated)]
    fn pump_timeout(&mut self, el: &mut EventLoop<()>, timeout: Option<Duration>) {
        el.pump_events(timeout, |event, target| match event {
            Event::Resumed => {
                for label in ["W1", "W2"] {
                    let w = target
                        .create_window(Window::default_attributes().with_title(label))
                        .unwrap();
                    println!("CREATE {label} xid={}", u64::from(w.id()));
                    self.windows.push(Some(Arc::new(w)));
                }
            }
            Event::AboutToWait if self.create_late => {
                let w = target
                    .create_window(Window::default_attributes().with_title("W3"))
                    .unwrap();
                println!("CREATE W3 xid={}", u64::from(w.id()));
                self.windows.push(Some(Arc::new(w)));
                self.create_late = false;
            }
            Event::WindowEvent { window_id, event } => {
                let window = u64::from(window_id) as u32;
                match event {
                    WindowEvent::Focused(value) => {
                        if value {
                            self.focused = Some(window)
                        } else if self.focused == Some(window) {
                            self.focused = None
                        }
                        println!("FOCUS window={window} value={value}");
                        if value {
                            if let Some((index, code)) = self.enable_on_focus {
                                if self.xid(index) == window {
                                    self.enable_on_focus = None;
                                    self.windows[index].as_ref().unwrap().set_ime_allowed(true);
                                    let (conn, _) = x11rb::connect(None).unwrap();
                                    first_key(&conn, code, window);
                                }
                            }
                        }
                    }
                    WindowEvent::ModifiersChanged(modifiers) => {
                        self.modifiers = modifiers.state();
                        println!("MODIFIERS window={window} {:?}", self.modifiers);
                    }
                    WindowEvent::RedrawRequested => self.redraws += 1,
                    WindowEvent::Ime(event) => {
                        println!("IME window={window} {event:?}");
                        match event {
                            Ime::Enabled => self.events.push(Observed {
                                window,
                                kind: "enabled",
                                text: String::new(),
                            }),
                            Ime::Commit(text) => self.events.push(Observed {
                                window,
                                kind: "commit",
                                text,
                            }),
                            Ime::Preedit(text, _) => self.events.push(Observed {
                                window,
                                kind: "preedit",
                                text,
                            }),
                            _ => {}
                        }
                    }
                    WindowEvent::KeyboardInput {
                        event,
                        is_synthetic: false,
                        ..
                    } if event.state == ElementState::Released
                        && event.logical_key.to_text() == Some("q") =>
                    {
                        self.events.push(Observed {
                            window,
                            kind: "release",
                            text: "release-q".into(),
                        });
                    }
                    WindowEvent::KeyboardInput {
                        event,
                        is_synthetic: false,
                        ..
                    } if event.state == ElementState::Pressed => {
                        println!(
                            "KEY window={window} logical={:?} text={:?}",
                            event.logical_key, event.text
                        );
                        if event.logical_key.to_text() == Some("q") && self.modifiers.control_key()
                        {
                            self.events.push(Observed {
                                window,
                                kind: "shortcut",
                                text: "Ctrl+q".into(),
                            });
                        }
                        if let Some(text) = event.text {
                            self.events.push(Observed {
                                window,
                                kind: "key",
                                text: text.to_string(),
                            });
                        }
                    }
                    _ => {}
                }
            }
            _ => {}
        });
    }
    fn settle(&mut self, el: &mut EventLoop<()>) {
        for _ in 0..12 {
            self.pump(el)
        }
    }
    fn focus(&mut self, el: &mut EventLoop<()>, conn: &RustConnection, index: usize) {
        let xid = self.xid(index);
        conn.set_input_focus(InputFocus::PARENT, xid, CURRENT_TIME)
            .unwrap()
            .check()
            .unwrap();
        conn.flush().unwrap();
        self.settle(el);
        assert_eq!(self.focused, Some(xid));
    }
    fn expect(&mut self, el: &mut EventLoop<()>, window: u32, kind: &str, text: &str) {
        self.settle(el);
        let matching: Vec<_> = self.events.iter().filter(|v| v.text == text).collect();
        assert_eq!(
            matching.len(),
            1,
            "expected exactly one {text:?}: {:?}",
            self.events
        );
        assert_eq!((matching[0].window, matching[0].kind), (window, kind));
    }
}
struct Server {
    child: Option<Child>,
    log: String,
    binary: String,
    name: String,
    qcode: u8,
    pcode: u8,
    escape: u8,
}
impl Server {
    #[allow(clippy::disallowed_methods)] // Isolated synchronous native fixture owns this child.
    fn start(&mut self) {
        let file = OpenOptions::new()
            .create(true)
            .append(true)
            .open(&self.log)
            .unwrap();
        self.child = Some(
            Command::new(&self.binary)
                .args([
                    self.qcode.to_string(),
                    self.pcode.to_string(),
                    self.escape.to_string(),
                    self.name.clone(),
                ])
                .stdout(file.try_clone().unwrap())
                .stderr(file)
                .spawn()
                .unwrap(),
        );
        let start = Instant::now();
        while !fs::read_to_string(&self.log)
            .unwrap_or_default()
            .contains("SERVER READY")
        {
            assert!(
                start.elapsed() < Duration::from_secs(3),
                "server did not become ready"
            );
            assert!(
                self.child.as_mut().unwrap().try_wait().unwrap().is_none(),
                "server exited"
            );
            std::thread::sleep(Duration::from_millis(10));
        }
    }
    fn stop(&mut self) {
        if let Some(mut child) = self.child.take() {
            let _ = child.kill();
            let _ = child.wait();
        }
    }
    fn require_spot(&self, window: u32, x: i16, y: i16) {
        let text = self.read();
        let prefix = format!("SERVER opcode=60 window={window} ");
        let line = text
            .lines()
            .find(|line| line.starts_with(&prefix))
            .expect("first forwarded key missing");
        assert!(
            line.ends_with(&format!("spot={x},{y}")),
            "wrong first-key cursor spot: {line}"
        );
    }
    fn read(&self) -> String {
        fs::read_to_string(&self.log).unwrap_or_default()
    }
}
impl Drop for Server {
    fn drop(&mut self) {
        self.stop();
    }
}
fn key(conn: &RustConnection, code: u8) {
    for ty in [xproto::KEY_PRESS_EVENT, xproto::KEY_RELEASE_EVENT] {
        conn.xtest_fake_input(ty, code, CURRENT_TIME, NONE, 0, 0, 0)
            .unwrap()
            .check()
            .unwrap();
    }
    conn.flush().unwrap();
    conn.get_input_focus().unwrap().reply().unwrap(); // Server has queued both real events before the pump.
}
fn shortcut(p: &mut Probe, el: &mut EventLoop<()>, conn: &RustConnection, control: u8, q: u8) {
    conn.xtest_fake_input(
        xproto::KEY_PRESS_EVENT,
        control,
        CURRENT_TIME,
        NONE,
        0,
        0,
        0,
    )
    .unwrap()
    .check()
    .unwrap();
    if std::env::var_os("PROBE_BURST_SHORTCUT").is_none() {
        p.settle(el);
    }
    key(conn, q);
    if std::env::var_os("PROBE_BURST_SHORTCUT").is_none() {
        p.settle(el);
    }
    conn.xtest_fake_input(
        xproto::KEY_RELEASE_EVENT,
        control,
        CURRENT_TIME,
        NONE,
        0,
        0,
        0,
    )
    .unwrap()
    .check()
    .unwrap();
    conn.flush().unwrap();
}
fn prepare_stock(p: &mut Probe, el: &mut EventLoop<()>, conn: &RustConnection, index: usize) {
    if std::env::var_os("PROBE_STOCK_PREPARE").is_some() {
        // This control bypasses known stock enable-order/focus defects solely to
        // reach the independent modifier replay adversary. Never used as first-key proof.
        p.settle(el);
        p.focus(el, conn, if index == 0 { 1 } else { 0 });
        p.focus(el, conn, index);
    }
}
fn first_key(conn: &RustConnection, code: u8, window: u32) {
    if std::env::var_os("PROBE_CORE_FIRST_KEY").is_none() {
        key(conn, code);
        return;
    }
    // Core delivery deliberately excludes XI raw/XKB events that could accidentally
    // admit the request first. This is an ordering adversary in addition to XTest.
    for ty in [xproto::KEY_PRESS_EVENT, xproto::KEY_RELEASE_EVENT] {
        let ev = xproto::KeyPressEvent {
            response_type: ty,
            detail: code,
            sequence: 0,
            time: CURRENT_TIME,
            root: conn.setup().roots[0].root,
            event: window,
            child: NONE,
            root_x: 0,
            root_y: 0,
            event_x: 0,
            event_y: 0,
            state: xproto::KeyButMask::default(),
            same_screen: true,
        };
        conn.send_event(
            false,
            window,
            xproto::EventMask::KEY_PRESS | xproto::EventMask::KEY_RELEASE,
            ev,
        )
        .unwrap()
        .check()
        .unwrap();
    }
    conn.flush().unwrap();
    conn.get_input_focus().unwrap().reply().unwrap();
}
fn main() {
    let mode = std::env::args().nth(1).unwrap_or_else(|| "active".into());
    let late = mode == "late";
    let (conn, _) = x11rb::connect(None).unwrap();
    let setup = conn.setup();
    let mapping = conn
        .get_keyboard_mapping(setup.min_keycode, setup.max_keycode - setup.min_keycode + 1)
        .unwrap()
        .reply()
        .unwrap();
    let code = |sym| {
        mapping
            .keysyms
            .chunks(mapping.keysyms_per_keycode as usize)
            .position(|v| v.first() == Some(&sym))
            .unwrap() as u8
            + setup.min_keycode
    };
    let (q, e, o) = (code(b'q' as u32), code(b'e' as u32), code(b'o' as u32));
    conn.change_keyboard_mapping(1, 248, 1, &[0xfe51])
        .unwrap()
        .check()
        .unwrap(); // dead_acute
    conn.change_keyboard_mapping(1, 249, 1, &[0xff20])
        .unwrap()
        .check()
        .unwrap(); // Multi_key
    let compose = format!("/tmp/gpui-deferred-xim-compose-{}", std::process::id());
    fs::write(
        &compose,
        "<dead_acute> <e> : \"é\" U00E9\n<Multi_key> <o> <e> : \"œ\" U0153\n",
    )
    .unwrap();
    std::env::set_var("XCOMPOSEFILE", &compose);
    let name = format!("deferred_probe_{}", std::process::id());
    std::env::set_var("XMODIFIERS", format!("@im={name}"));
    let mut server = Server {
        child: None,
        log: format!("/tmp/gpui-deferred-xim-server-{}.log", std::process::id()),
        binary: std::env::var("XIM_SERVER").unwrap(),
        name,
        qcode: q,
        pcode: code(b'p' as u32),
        escape: code(0xff1b),
    };
    File::create(&server.log).unwrap();
    if !late {
        server.start();
    }
    let mut el = EventLoop::builder().with_x11().build().unwrap();
    let mut p = Probe {
        windows: vec![],
        events: vec![],
        focused: None,
        create_late: false,
        redraws: 0,
        enable_on_focus: None,
        modifiers: winit::keyboard::ModifiersState::empty(),
    };
    p.settle(&mut el);
    p.focus(&mut el, &conn, 0);
    p.windows[0].as_ref().unwrap().set_ime_allowed(false);
    p.windows[1].as_ref().unwrap().set_ime_allowed(false);
    p.settle(&mut el);
    println!("PHASE plain-before-enable");
    key(&conn, q);
    p.expect(&mut el, p.xid(0), "key", "q");
    p.events.clear();
    key(&conn, 248);
    key(&conn, e);
    p.expect(&mut el, p.xid(0), "key", "é");
    p.events.clear();
    key(&conn, 249);
    key(&conn, o);
    key(&conn, e);
    p.expect(&mut el, p.xid(0), "key", "œ");
    p.events.clear();
    shortcut(&mut p, &mut el, &conn, code(0xffe3), q);
    p.expect(&mut el, p.xid(0), "shortcut", "Ctrl+q");
    assert!(p.modifiers.is_empty());
    p.events.clear();
    let eager = std::env::var_os("PROBE_EXPECT_EAGER").is_some();
    if !late {
        assert_eq!(
            server.read().contains("opcode=30 "),
            eager,
            "XIM open before enable: {}",
            server.read()
        );
    }
    println!("PHASE enable-W1-first-q-same-pump");
    p.windows[0].as_ref().unwrap().set_ime_cursor_area(
        winit::dpi::PhysicalPosition::new(31, 47),
        winit::dpi::PhysicalSize::new(1, 1),
    );
    if mode == "focus" {
        p.focus(&mut el, &conn, 1);
        p.enable_on_focus = Some((0, q));
        p.focus(&mut el, &conn, 0);
    } else {
        p.windows[0].as_ref().unwrap().set_ime_allowed(true);
        prepare_stock(&mut p, &mut el, &conn, 0);
        first_key(&conn, q, p.xid(0));
    }
    if !late {
        p.expect(&mut el, p.xid(0), "commit", "Ω");
        assert!(!p.events.iter().any(|v| v.text == "q"));
    } else {
        p.settle(&mut el);
        server.start();
        p.settle(&mut el);
        p.events.clear();
        key(&conn, q);
        p.expect(&mut el, p.xid(0), "commit", "Ω");
    }
    p.events.clear();
    server.require_spot(p.xid(0), 31, 47);
    println!("PHASE W2-independent-disabled");
    p.focus(&mut el, &conn, 1);
    key(&conn, q);
    p.expect(&mut el, p.xid(1), "key", "q");
    p.events.clear();
    println!("PHASE W2-enable-first-q-same-pump");
    p.windows[1].as_ref().unwrap().set_ime_cursor_area(
        winit::dpi::PhysicalPosition::new(73, 89),
        winit::dpi::PhysicalSize::new(1, 1),
    );
    p.windows[1].as_ref().unwrap().set_ime_allowed(true);
    prepare_stock(&mut p, &mut el, &conn, 1);
    first_key(&conn, q, p.xid(1));
    p.expect(&mut el, p.xid(1), "commit", "Ω");
    assert!(!p.events.iter().any(|v| v.text == "q"));
    p.events.clear();
    server.require_spot(p.xid(1), 73, 89);
    println!("PHASE shortcut-after-enable");
    shortcut(&mut p, &mut el, &conn, code(0xffe3), q);
    p.expect(&mut el, p.xid(1), "shortcut", "Ctrl+q");
    assert!(p.modifiers.is_empty());
    assert!(p
        .events
        .iter()
        .any(|v| v.kind == "release" && v.text == "release-q"));
    assert!(!p.events.iter().any(|v| v.kind == "commit"));
    p.events.clear();
    println!("PHASE burst-shift-one-event-time-translation");
    conn.xtest_fake_input(
        xproto::KEY_PRESS_EVENT,
        code(0xffe1),
        CURRENT_TIME,
        NONE,
        0,
        0,
        0,
    )
    .unwrap()
    .check()
    .unwrap();
    key(&conn, code(b'1' as u32));
    conn.xtest_fake_input(
        xproto::KEY_RELEASE_EVENT,
        code(0xffe1),
        CURRENT_TIME,
        NONE,
        0,
        0,
        0,
    )
    .unwrap()
    .check()
    .unwrap();
    conn.flush().unwrap();
    p.expect(&mut el, p.xid(1), "key", "!");
    assert!(p.modifiers.is_empty());
    p.events.clear();
    println!("PHASE preedit-cancel-commit-focus");
    key(&conn, code(b'p' as u32));
    p.expect(&mut el, p.xid(1), "preedit", "x");
    p.events.clear();
    key(&conn, code(0xff1b));
    p.settle(&mut el);
    assert!(p
        .events
        .iter()
        .any(|v| v.kind == "preedit" && v.text.is_empty()));
    assert!(!p.events.iter().any(|v| v.kind == "commit"));
    p.events.clear();
    key(&conn, code(b'p' as u32));
    p.expect(&mut el, p.xid(1), "preedit", "x");
    p.events.clear();
    key(&conn, q);
    p.expect(&mut el, p.xid(1), "commit", "Ω");
    p.events.clear();
    key(&conn, code(b'p' as u32));
    p.expect(&mut el, p.xid(1), "preedit", "x");
    p.events.clear();
    p.focus(&mut el, &conn, 0);
    key(&conn, q);
    p.expect(&mut el, p.xid(0), "commit", "Ω");
    p.events.clear();
    p.focus(&mut el, &conn, 1);
    println!("PHASE server-destroy-reinstantiate");
    server.stop();
    p.settle(&mut el);
    // Truncate only after old server has exited so READY belongs to the new instance.
    let old_log = server.read();
    fs::write(&server.log, "").unwrap();
    server.start();
    p.settle(&mut el);
    p.events.clear();
    key(&conn, q);
    p.expect(&mut el, p.xid(1), "commit", "Ω");
    p.events.clear();
    for i in [0, 1] {
        p.focus(&mut el, &conn, i);
        key(&conn, q);
        p.expect(&mut el, p.xid(i), "commit", "Ω");
        p.events.clear();
    }
    server.require_spot(p.xid(0), 31, 47);
    server.require_spot(p.xid(1), 73, 89);
    println!("PHASE late-window-W3");
    p.create_late = true;
    p.settle(&mut el);
    p.focus(&mut el, &conn, 2);
    p.windows[2].as_ref().unwrap().set_ime_allowed(true);
    prepare_stock(&mut p, &mut el, &conn, 2);
    first_key(&conn, q, p.xid(2));
    p.expect(&mut el, p.xid(2), "commit", "Ω");
    p.events.clear();
    println!("PHASE queued-enable-closed-window");
    p.windows[2].as_ref().unwrap().set_ime_allowed(true);
    p.windows[2].take();
    p.settle(&mut el);
    println!("PHASE rapid-toggle-W1");
    p.focus(&mut el, &conn, 0);
    for allowed in [false, true, false, true] {
        p.windows[0].as_ref().unwrap().set_ime_allowed(allowed);
    }
    key(&conn, q);
    p.expect(&mut el, p.xid(0), "commit", "Ω");
    p.events.clear();
    p.windows[0].as_ref().unwrap().set_ime_allowed(false);
    p.settle(&mut el);
    p.events.clear();
    println!("PHASE cross-thread-allow-wakes-without-redraw");
    let window = Arc::clone(p.windows[0].as_ref().unwrap());
    let redraws = p.redraws;
    let worker = std::thread::spawn(move || {
        std::thread::sleep(Duration::from_millis(30));
        window.set_ime_allowed(true);
    });
    el.set_control_flow(winit::event_loop::ControlFlow::Wait);
    while !p.events.iter().any(|v| v.kind == "enabled") {
        p.pump_timeout(&mut el, None);
    }
    worker.join().unwrap();
    assert_eq!(p.redraws, redraws);
    key(&conn, q);
    p.expect(&mut el, p.xid(0), "commit", "Ω");
    p.events.clear();
    println!("PHASE ordinary-compose-after-disable");
    p.windows[0].as_ref().unwrap().set_ime_allowed(false);
    p.settle(&mut el);
    p.events.clear();
    key(&conn, 248);
    key(&conn, e);
    p.expect(&mut el, p.xid(0), "key", "é");
    p.events.clear();
    key(&conn, 249);
    key(&conn, o);
    key(&conn, e);
    p.expect(&mut el, p.xid(0), "key", "œ");
    p.events.clear();
    p.focus(&mut el, &conn, 1);
    key(&conn, q);
    p.expect(&mut el, p.xid(1), "commit", "Ω");
    println!(
        "SERVER TRACE BEFORE RESTART\n{old_log}SERVER TRACE AFTER RESTART\n{}",
        server.read()
    );
    p.windows.clear();
    p.settle(&mut el);
    drop(el);
    server.stop();
    fs::remove_file(compose).unwrap();
    println!("PASS mode={mode}");
}
