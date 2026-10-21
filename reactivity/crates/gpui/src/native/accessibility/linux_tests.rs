//! Actual AT-SPI/D-Bus client proof; not direct invocation of ingress handlers.
use super::super::{NativeHost, RendererPolicy, Window, test_todos::Todos};
use super::*;
use gpui_reactivity_host::native::{Callback, Driver, Host, winit};
use std::{
    collections::VecDeque,
    sync::mpsc,
    thread,
    time::{Duration, Instant},
};
use winit::{
    event_loop::{ActiveEventLoop, ControlFlow, EventLoop},
    platform::x11::EventLoopBuilderExtX11,
};
use zbus::{
    blocking::{Connection, Proxy},
    zvariant::OwnedObjectPath,
};

const TITLE: &str = "GPUI native AT-SPI Todo proof";
const CONTENT: &str = "Read Ω א ع through AT-SPI";
const HEADING: &str = "Task collection";
type Address = (String, OwnedObjectPath);

fn proxy<'a>(
    bus: &Connection,
    address: &'a Address,
    interface: &'a str,
) -> zbus::Result<Proxy<'a>> {
    Proxy::new(bus, address.0.as_str(), address.1.as_str(), interface)
}
fn descendants(bus: &Connection, root: Address) -> zbus::Result<Vec<Address>> {
    let mut queue = VecDeque::from([root]);
    let mut result = Vec::new();
    while let Some(address) = queue.pop_front() {
        assert!(result.len() < 5000, "unexpected unbounded AT tree");
        let children: Vec<Address> =
            proxy(bus, &address, "org.a11y.atspi.Accessible")?.call("GetChildren", &())?;
        queue.extend(children);
        result.push(address);
    }
    Ok(result)
}
fn wait_for<T>(deadline: Instant, mut predicate: impl FnMut() -> Option<T>) -> T {
    loop {
        if let Some(value) = predicate() {
            return value;
        }
        assert!(Instant::now() < deadline, "AT-SPI client deadline");
        // Test-client discovery only; production has no polling/redraw timer.
        thread::sleep(Duration::from_millis(10));
    }
}
fn named(bus: &Connection, roots: Vec<Address>, name: &str) -> Option<Address> {
    for root in roots {
        for address in descendants(bus, root).ok()? {
            let current: String = proxy(bus, &address, "org.a11y.atspi.Accessible")
                .ok()?
                .get_property("Name")
                .ok()?;
            if current == name {
                return Some(address);
            }
        }
    }
    None
}
#[derive(Debug)]
enum Evidence {
    Activated,
    Renamed,
    Edited,
    Invoked,
    Reactivated,
}
fn client(
    deadline: Instant,
    evidence: mpsc::SyncSender<Result<Evidence, String>>,
    gate: mpsc::Receiver<()>,
    wake: Wake,
) {
    let run = || -> Result<(), Box<dyn std::error::Error>> {
        let session = zbus::blocking::connection::Builder::session()?
            .method_timeout(Duration::from_secs(3))
            .build()?;
        let status = Proxy::new(&session, "org.a11y.Bus", "/org/a11y/bus", "org.a11y.Status")?;
        status.set_property("IsEnabled", true)?;
        assert!(status.get_property::<bool>("IsEnabled")?);
        let address: String =
            Proxy::new(&session, "org.a11y.Bus", "/org/a11y/bus", "org.a11y.Bus")?
                .call("GetAddress", &())?;
        let bus = zbus::blocking::connection::Builder::address(address.as_str())?
            .method_timeout(Duration::from_secs(3))
            .build()?;
        let desktop = (
            "org.a11y.atspi.Registry".to_owned(),
            "/org/a11y/atspi/accessible/root".try_into()?,
        );
        let roots = || -> Option<Vec<Address>> {
            proxy(&bus, &desktop, "org.a11y.atspi.Accessible")
                .ok()?
                .call("GetChildren", &())
                .ok()
        };
        eprintln!("AT-SPI client enabled; waiting for native window");
        let window = wait_for(deadline, || named(&bus, roots()?, TITLE));
        eprintln!("AT-SPI found window {window:?}");
        let all = descendants(&bus, window.clone())?;
        let input = all
            .into_iter()
            .find(|node| {
                let interfaces: zbus::Result<Vec<String>> =
                    proxy(&bus, node, "org.a11y.atspi.Accessible")
                        .and_then(|p| p.call("GetInterfaces", &()));
                interfaces.is_ok_and(|names| {
                    names
                        .iter()
                        .any(|name| name == "org.a11y.atspi.EditableText")
                })
            })
            .ok_or("no native EditableText interface")?;
        let notify = |item| {
            evidence.send(Ok(item)).unwrap();
            wake.signal();
        };
        notify(Evidence::Activated);
        gate.recv_timeout(deadline.saturating_duration_since(Instant::now()))?;
        let heading = wait_for(deadline, || named(&bus, vec![window.clone()], HEADING));
        let children: Vec<Address> =
            proxy(&bus, &heading, "org.a11y.atspi.Accessible")?.call("GetChildren", &())?;
        assert!(
            named(&bus, children, "Todos").is_some(),
            "native name override must preserve actual text in a separate child"
        );
        notify(Evidence::Renamed);
        gate.recv_timeout(deadline.saturating_duration_since(Instant::now()))?;
        assert!(
            proxy(&bus, &input, "org.a11y.atspi.Component")?
                .call::<_, _, bool>("GrabFocus", &())?
        );
        assert!(
            proxy(&bus, &input, "org.a11y.atspi.EditableText")?
                .call::<_, _, bool>("SetTextContents", &(CONTENT,))?
        );
        wait_for(deadline, || {
            let value: String = proxy(&bus, &input, "org.a11y.atspi.Text")
                .ok()?
                .call("GetText", &(0i32, -1i32))
                .ok()?;
            (value == CONTENT).then_some(())
        });
        notify(Evidence::Edited);
        gate.recv_timeout(deadline.saturating_duration_since(Instant::now()))?;
        let add = named(&bus, vec![window.clone()], "Add").ok_or("missing native Add button")?;
        assert!(
            proxy(&bus, &add, "org.a11y.atspi.Action")?.call::<_, _, bool>("DoAction", &(0i32,))?
        );
        wait_for(deadline, || named(&bus, vec![window.clone()], CONTENT));
        notify(Evidence::Invoked);
        gate.recv_timeout(deadline.saturating_duration_since(Instant::now()))?;
        status.set_property("IsEnabled", false)?;
        wait_for(deadline, || {
            named(&bus, roots()?, TITLE).is_none().then_some(())
        });
        status.set_property("IsEnabled", true)?;
        wait_for(deadline, || named(&bus, roots()?, CONTENT));
        notify(Evidence::Reactivated);
        Ok(())
    };
    if let Err(error) = run() {
        let _ = evidence.send(Err(error.to_string()));
        wake.signal();
    }
}

struct Script {
    host: NativeHost<Todos>,
    deadline: Instant,
    receiver: mpsc::Receiver<Result<Evidence, String>>,
    sender: Option<mpsc::SyncSender<Result<Evidence, String>>>,
    gate: mpsc::SyncSender<()>,
    gate_receiver: Option<mpsc::Receiver<()>>,
    client: Option<thread::JoinHandle<()>>,
    baseline: Option<(crate::Counters, u64)>,
    after_invoke_frames: u64,
    before_threads: usize,
    complete: bool,
}
impl Script {
    fn step(&mut self, event_loop: &ActiveEventLoop) {
        assert!(Instant::now() < self.deadline, "native AT-SPI deadline");
        let owner = self.host.owner.as_mut().unwrap();
        if !owner.accessibility_state().unwrap().valid {
            return;
        }
        if self.client.is_none() {
            let bridge = self.host.accessibility.as_mut().unwrap();
            assert_eq!(bridge.conversions, 0, "initial tree must remain lazy");
            assert!(bridge.published.is_none());
            let inactive = allocation_counter::measure(|| {
                for _ in 0..1000 {
                    bridge.sync(owner).unwrap();
                }
            });
            assert_eq!(inactive.count_total, 0);
            assert_eq!(bridge.conversions, 0);
            assert!(self.host.instance.is_none());
            self.baseline = Some((owner.counters(), self.host.presented_frames));
            let threads = std::fs::read_dir("/proc/self/task").unwrap().count();
            eprintln!(
                "GPUI_ACCESSKIT_IDLE threads_before={} threads_after={} conversions=0",
                self.before_threads, threads
            );
            let sender = self.sender.take().unwrap();
            let gate = self.gate_receiver.take().unwrap();
            let wake = self.host.wake.clone().unwrap();
            let deadline = self.deadline;
            self.client = Some(thread::spawn(move || client(deadline, sender, gate, wake)));
        }
        for event in self.receiver.try_iter() {
            let evidence = event.expect("actual AT-SPI client failed");
            match evidence {
                Evidence::Activated => {
                    let (counters, frames) = self.baseline.unwrap();
                    assert_eq!(
                        owner.counters(),
                        counters,
                        "activation must not call view/layout/paint"
                    );
                    assert_eq!(self.host.presented_frames, frames);
                    assert!(self.host.accessibility.as_ref().unwrap().conversions > 0);
                    let heading = owner.role(Role::Text).text("Todos").one().unwrap();
                    owner
                        .set_semantic(
                            heading,
                            crate::semantic::NAME,
                            crate::property::Contribution::Set(Some(HEADING.into())),
                        )
                        .unwrap();
                    // A semantic-only public operation has no redraw. Its
                    // normal owner wake must still publish the changed P epoch.
                    self.host.wake.as_ref().unwrap().signal();
                    self.gate.send(()).unwrap();
                }
                Evidence::Renamed => {
                    let (before, frames) = self.baseline.unwrap();
                    assert_eq!(owner.counters().descriptions, before.descriptions);
                    assert_eq!(owner.counters().layout_runs, before.layout_runs);
                    assert_eq!(owner.counters().paint_passes, before.paint_passes);
                    assert_eq!(self.host.presented_frames, frames);
                    assert_eq!(owner.accessibility_state().unwrap().epoch, 1);
                    self.gate.send(()).unwrap();
                }
                Evidence::Edited => {
                    assert_eq!(owner.focused().unwrap(), Some(owner.input()));
                    let data: serde_json::Value =
                        serde_json::from_str(&owner.source_json().unwrap()).unwrap();
                    assert_eq!(data["draft"], CONTENT);
                    assert!(owner.accessibility_state().unwrap().token.is_some());
                    assert_eq!(owner.accessibility_state().unwrap().epoch, 2);
                    self.gate.send(()).unwrap();
                }
                Evidence::Invoked => {
                    let data: serde_json::Value =
                        serde_json::from_str(&owner.source_json().unwrap()).unwrap();
                    assert_eq!(data["draft"], "");
                    assert_eq!(data["todos"][0]["title"], CONTENT);
                    assert_eq!(data["todos"].as_array().unwrap().len(), 1);
                    assert!(owner.contains_text(CONTENT).unwrap());
                    assert_eq!(owner.accessibility_state().unwrap().epoch, 3);
                    assert_eq!(owner.counters().source_operations, 3);
                    self.after_invoke_frames = self.host.presented_frames;
                    self.gate.send(()).unwrap();
                }
                Evidence::Reactivated => {
                    assert_eq!(owner.accessibility_state().unwrap().epoch, 3);
                    assert_eq!(owner.counters().source_operations, 3);
                    assert_eq!(self.host.presented_frames, self.after_invoke_frames);
                    assert!(owner.contains_text(CONTENT).unwrap());
                    self.complete = true;
                    event_loop.exit();
                }
            }
        }
    }
}
impl Host for Script {
    fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
        let about = matches!(callback, Callback::AboutToWait);
        if matches!(callback, Callback::Resumed) && self.before_threads == 0 {
            self.before_threads = std::fs::read_dir("/proc/self/task").unwrap().count();
        }
        self.host.dispatch(event_loop, callback);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        if about {
            self.step(event_loop);
            event_loop.set_control_flow(ControlFlow::WaitUntil(self.deadline));
        }
    }
}

#[test]
#[ignore = "requires X11 and an isolated session bus with org.a11y.Bus/AT-SPI registry"]
fn native_atspi_todo_activation_edit_invoke_and_reactivation() {
    let event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let (sender, receiver) = mpsc::sync_channel(4);
    let (gate, gate_receiver) = mpsc::sync_channel(1);
    let host = Script {
        host: NativeHost::new(
            Window::document(Todos::default())
                .title(TITLE)
                .size(540, 620)
                .renderer(RendererPolicy::ReferenceCpu),
        ),
        deadline: Instant::now() + Duration::from_secs(30),
        receiver,
        sender: Some(sender),
        gate,
        gate_receiver: Some(gate_receiver),
        client: None,
        baseline: None,
        after_invoke_frames: 0,
        before_threads: 0,
        complete: false,
    };
    let (mut driver, wake) = Driver::new(&event_loop, host);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app(&mut driver).unwrap();
    driver.host_mut().client.take().unwrap().join().unwrap();
    assert!(driver.host().complete);
}

#[test]
#[ignore = "requires X11 and DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/gpui-no-session-bus"]
fn native_accessible_profile_without_session_bus_still_presents() {
    assert_eq!(
        std::env::var("DBUS_SESSION_BUS_ADDRESS").unwrap(),
        "unix:path=/tmp/gpui-no-session-bus"
    );
    assert!(!std::path::Path::new("/tmp/gpui-no-session-bus").exists());
    struct Idle {
        host: NativeHost<Todos>,
        deadline: Instant,
        complete: bool,
    }
    impl Host for Idle {
        fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
            let idle = matches!(callback, Callback::AboutToWait);
            self.host.dispatch(event_loop, callback);
            assert!(self.host.error.is_none(), "{:?}", self.host.error);
            if idle {
                assert!(Instant::now() < self.deadline);
                event_loop.set_control_flow(ControlFlow::WaitUntil(self.deadline));
                if self.host.presented_frames > 0 {
                    let owner = self.host.owner.as_ref().unwrap();
                    assert!(owner.accessibility_state().unwrap().valid);
                    assert_eq!(self.host.accessibility.as_ref().unwrap().conversions, 0);
                    assert!(self.host.instance.is_none());
                    assert!(owner.contains_text("Todos").unwrap());
                    self.complete = true;
                    event_loop.exit();
                }
            }
        }
    }
    let event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let host = Idle {
        host: NativeHost::new(
            Window::document(Todos::default()).renderer(RendererPolicy::ReferenceCpu),
        ),
        deadline: Instant::now() + Duration::from_secs(30),
        complete: false,
    };
    let (mut driver, wake) = Driver::new(&event_loop, host);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app(&mut driver).unwrap();
    assert!(driver.host().complete);
}
