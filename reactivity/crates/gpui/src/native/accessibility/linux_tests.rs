//! Actual AT-SPI/D-Bus client proof; not direct invocation of ingress handlers.
use super::super::{NativeHost, RendererPolicy, Window, test_todos::Todos};
use super::*;
use gpui_reactivity_host::native::{Callback, Driver, Host, winit};
use std::{
    collections::VecDeque,
    thread,
    time::{Duration, Instant},
};
use winit::{
    event_loop::{ActiveEventLoop, ControlFlow, EventLoop},
    platform::x11::EventLoopBuilderExtX11,
};
use zbus::{Connection, OwnedObjectPath, Proxy, connection::Builder};
use zruntime::{SharedRuntime, mpmc};

mod lifecycle;

const TITLE: &str = "GPUI native AT-SPI Todo proof";
const CONTENT: &str = "Read Ω א ع through AT-SPI";
const HEADING: &str = "Task collection";
type Address = (String, OwnedObjectPath);

async fn proxy<'a>(
    bus: &Connection,
    address: &'a Address,
    interface: &'a str,
) -> zbus::Result<Proxy<'a>> {
    Proxy::new(bus, address.0.as_str(), address.1.as_str(), interface).await
}
async fn descendants(bus: &Connection, root: Address) -> zbus::Result<Vec<Address>> {
    let mut queue = VecDeque::from([root]);
    let mut result = Vec::new();
    while let Some(address) = queue.pop_front() {
        assert!(result.len() < 5000, "unexpected unbounded AT tree");
        let children: Vec<Address> = proxy(bus, &address, "org.a11y.atspi.Accessible")
            .await?
            .call("GetChildren", &())
            .await?;
        queue.extend(children);
        result.push(address);
    }
    Ok(result)
}
async fn wait_for<T>(
    runtime: &SharedRuntime,
    deadline: Instant,
    mut predicate: impl AsyncFnMut() -> Option<T>,
) -> T {
    loop {
        if let Some(value) = predicate().await {
            return value;
        }
        assert!(Instant::now() < deadline, "AT-SPI client deadline");
        // Discovery yields on the same runtime that serves the fixture's bus
        // objects. Production has no polling/redraw timer.
        runtime.sleep(Duration::from_millis(10)).await;
    }
}
async fn named(bus: &Connection, roots: Vec<Address>, name: &str) -> Option<Address> {
    for root in roots {
        for address in descendants(bus, root).await.ok()? {
            let current: String = proxy(bus, &address, "org.a11y.atspi.Accessible")
                .await
                .ok()?
                .get_property("Name")
                .await
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
    Destroyed,
}
fn client(
    deadline: Instant,
    evidence: mpmc::Sender<Result<Evidence, String>>,
    gate: mpmc::Receiver<()>,
    wake: Wake,
    lifecycle: bool,
) {
    // One client thread drives every connection, fixture task, timer and UI
    // gate for the entire scenario. A synchronous wait here would stop zbus6.
    let run = zbus::block_on(async {
        let runtime = SharedRuntime::current()?;
        runtime
            .timeout_at(
                deadline,
                run_client(&runtime, deadline, &evidence, &gate, &wake, lifecycle),
            )
            .await?
    });
    if let Err(error) = run {
        let _ = evidence.try_send(Err(error.to_string()));
        wake.signal();
    }
}

async fn run_client(
    runtime: &SharedRuntime,
    deadline: Instant,
    evidence: &mpmc::Sender<Result<Evidence, String>>,
    gate: &mpmc::Receiver<()>,
    wake: &Wake,
    lifecycle: bool,
) -> Result<(), Box<dyn std::error::Error>> {
    let session = Builder::session()
        .method_timeout(Duration::from_secs(3))
        .build()
        .await?;
    let mut fixture = if lifecycle {
        Some(lifecycle::Fixture::start(&session).await?)
    } else {
        None
    };
    let status = Proxy::new(&session, "org.a11y.Bus", "/org/a11y/bus", "org.a11y.Status").await?;
    status.set_property("IsEnabled", true).await?;
    assert!(status.get_property::<bool>("IsEnabled").await?);
    let address: String = Proxy::new(&session, "org.a11y.Bus", "/org/a11y/bus", "org.a11y.Bus")
        .await?
        .call("GetAddress", &())
        .await?;
    let bus = Builder::address(address.as_str())
        .method_timeout(Duration::from_secs(3))
        .build()
        .await?;
    let desktop = (
        "org.a11y.atspi.Registry".to_owned(),
        "/org/a11y/atspi/accessible/root".try_into()?,
    );
    let roots = async || -> Option<Vec<Address>> {
        proxy(&bus, &desktop, "org.a11y.atspi.Accessible")
            .await
            .ok()?
            .call("GetChildren", &())
            .await
            .ok()
    };
    eprintln!("AT-SPI client enabled; waiting for native window");
    let window = wait_for(runtime, deadline, async || {
        named(&bus, roots().await?, TITLE).await
    })
    .await;
    eprintln!("AT-SPI found window {window:?}");
    let mut input = None;
    for node in descendants(&bus, window.clone()).await? {
        let interfaces: Vec<String> = proxy(&bus, &node, "org.a11y.atspi.Accessible")
            .await?
            .call("GetInterfaces", &())
            .await?;
        if interfaces
            .iter()
            .any(|name| name == "org.a11y.atspi.EditableText")
        {
            input = Some(node);
            break;
        }
    }
    let input = input.ok_or("no native EditableText interface")?;
    let notify = |item| {
        evidence.try_send(Ok(item)).unwrap();
        wake.signal();
    };
    notify(Evidence::Activated);
    gate.recv().await?;
    let heading = wait_for(runtime, deadline, async || {
        named(&bus, vec![window.clone()], HEADING).await
    })
    .await;
    let children: Vec<Address> = proxy(&bus, &heading, "org.a11y.atspi.Accessible")
        .await?
        .call("GetChildren", &())
        .await?;
    assert!(
        named(&bus, children, "Todos").await.is_some(),
        "native name override must preserve actual text in a separate child"
    );
    notify(Evidence::Renamed);
    gate.recv().await?;
    assert!(
        proxy(&bus, &input, "org.a11y.atspi.Component")
            .await?
            .call::<_, _, bool>("GrabFocus", &())
            .await?
    );
    assert!(
        proxy(&bus, &input, "org.a11y.atspi.EditableText")
            .await?
            .call::<_, _, bool>("SetTextContents", &(CONTENT,))
            .await?
    );
    wait_for(runtime, deadline, async || {
        let value: String = proxy(&bus, &input, "org.a11y.atspi.Text")
            .await
            .ok()?
            .call("GetText", &(0i32, -1i32))
            .await
            .ok()?;
        (value == CONTENT).then_some(())
    })
    .await;
    notify(Evidence::Edited);
    gate.recv().await?;
    let add = named(&bus, vec![window.clone()], "Add")
        .await
        .ok_or("missing native Add button")?;
    assert!(
        proxy(&bus, &add, "org.a11y.atspi.Action")
            .await?
            .call::<_, _, bool>("DoAction", &(0i32,))
            .await?
    );
    wait_for(runtime, deadline, async || {
        named(&bus, vec![window.clone()], CONTENT).await
    })
    .await;
    notify(Evidence::Invoked);
    gate.recv().await?;
    status.set_property("IsEnabled", false).await?;
    wait_for(runtime, deadline, async || {
        named(&bus, roots().await?, TITLE)
            .await
            .is_none()
            .then_some(())
    })
    .await;
    status.set_property("IsEnabled", true).await?;
    wait_for(runtime, deadline, async || {
        named(&bus, roots().await?, CONTENT).await
    })
    .await;
    if let Some(fixture) = fixture.as_mut() {
        let before = wait_for(runtime, deadline, async || {
            named(&bus, roots().await?, TITLE).await
        })
        .await;
        fixture.replace().await?;
        let after = wait_for(runtime, deadline, async || {
            let window = named(&bus, roots().await?, TITLE).await?;
            (window.0 != before.0).then_some(window)
        })
        .await;
        wait_for(runtime, deadline, async || {
            named(&bus, vec![after.clone()], CONTENT).await
        })
        .await;
        fixture.stale_old_properties(&session).await?;
        // Keep querying the new actual provider while old-owner signals
        // are processed; stale-owner retirement loses this address.
        for _ in 0..20 {
            assert_eq!(
                proxy(&bus, &after, "org.a11y.atspi.Accessible")
                    .await?
                    .get_property::<String>("Name")
                    .await?,
                TITLE
            );
            runtime.sleep(Duration::from_millis(5)).await;
        }
        assert!(named(&bus, vec![after.clone()], CONTENT).await.is_some());
        eprintln!("GPUI_NATIVE_LIFECYCLE full tree restored; stale old-owner properties ignored");
    }
    if lifecycle {
        notify(Evidence::Reactivated);
        gate.recv().await?;
        wait_for(runtime, deadline, async || {
            let mut found = false;
            for root in roots().await? {
                let children: Vec<Address> = proxy(&bus, &root, "org.a11y.atspi.Accessible")
                    .await
                    .ok()?
                    .call("GetChildren", &())
                    .await
                    .ok()?;
                found |= !children.is_empty();
            }
            (!found).then_some(())
        })
        .await;
        eprintln!("GPUI_NATIVE_LIFECYCLE NativeAdapter destroy removed provider window");
    }
    bus.close().await?;
    if let Some(fixture) = fixture {
        fixture.close().await?;
    }
    session.close().await?;
    // Terminal evidence also acknowledges teardown. An asynchronous close error
    // must reach the UI while it is still reading the evidence channel.
    notify(if lifecycle {
        Evidence::Destroyed
    } else {
        Evidence::Reactivated
    });
    Ok(())
}

struct Script {
    host: NativeHost<Todos>,
    deadline: Instant,
    receiver: mpmc::Receiver<Result<Evidence, String>>,
    sender: Option<mpmc::Sender<Result<Evidence, String>>>,
    gate: mpmc::Sender<()>,
    gate_receiver: Option<mpmc::Receiver<()>>,
    client: Option<thread::JoinHandle<()>>,
    baseline: Option<(crate::Counters, u64)>,
    after_invoke_frames: u64,
    before_threads: usize,
    complete: bool,
    lifecycle: bool,
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
            let lifecycle = self.lifecycle;
            self.client = Some(thread::spawn(move || {
                client(deadline, sender, gate, wake, lifecycle)
            }));
        }
        while let Ok(event) = self.receiver.try_recv() {
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
                    self.gate.try_send(()).unwrap();
                }
                Evidence::Renamed => {
                    let (before, frames) = self.baseline.unwrap();
                    assert_eq!(owner.counters().descriptions, before.descriptions);
                    assert_eq!(owner.counters().layout_runs, before.layout_runs);
                    assert_eq!(owner.counters().paint_passes, before.paint_passes);
                    assert_eq!(self.host.presented_frames, frames);
                    assert_eq!(owner.accessibility_state().unwrap().epoch, 1);
                    self.gate.try_send(()).unwrap();
                }
                Evidence::Edited => {
                    assert_eq!(owner.focused().unwrap(), Some(owner.input()));
                    let data: serde_json::Value =
                        serde_json::from_str(&owner.source_json().unwrap()).unwrap();
                    assert_eq!(data["draft"], CONTENT);
                    assert!(owner.accessibility_state().unwrap().token.is_some());
                    assert_eq!(owner.accessibility_state().unwrap().epoch, 2);
                    self.gate.try_send(()).unwrap();
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
                    self.gate.try_send(()).unwrap();
                }
                Evidence::Reactivated => {
                    assert_eq!(owner.accessibility_state().unwrap().epoch, 3);
                    assert_eq!(owner.counters().source_operations, 3);
                    assert_eq!(self.host.presented_frames, self.after_invoke_frames);
                    assert!(owner.contains_text(CONTENT).unwrap());
                    if self.lifecycle {
                        self.host.accessibility.take();
                        self.gate.try_send(()).unwrap();
                    } else {
                        self.complete = true;
                        event_loop.exit();
                    }
                }
                Evidence::Destroyed => {
                    assert!(self.host.accessibility.is_none());
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
    run_native_script(false);
}

#[test]
#[ignore = "requires X11 and an isolated session bus initially lacking org.a11y.Bus"]
fn native_atspi_late_service_owner_replacement_and_destroy() {
    run_native_script(true);
}

fn run_native_script(lifecycle: bool) {
    let event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let (sender, receiver) = mpmc::bounded(4.try_into().unwrap());
    let (gate, gate_receiver) = mpmc::bounded(1.try_into().unwrap());
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
        lifecycle,
    };
    let (mut driver, wake) = Driver::new(&event_loop, host);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app(&mut driver).unwrap();
    driver.host_mut().client.take().unwrap().join().unwrap();
    assert!(driver.host().receiver.is_closed());
    assert!(driver.host().gate.is_closed());
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
