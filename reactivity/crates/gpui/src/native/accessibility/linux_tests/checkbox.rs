//! The provider, D-Bus actions/state/events and native presentation are real.
//! Only org.a11y.Bus/registry transport is supplied by the existing test fixture.
use super::*;
use zbus::export::futures_core::Stream;

const CHECK_TITLE: &str = "GPUI native checkbox proof";
const CHECK_NAME: &str = "Keep this preference";
#[derive(Default)]
struct Check {
    checked: bool,
    calls: u32,
}
impl Check {
    fn toggle(&mut self) {
        self.checked = !self.checked;
        self.calls += 1;
    }
}
impl View for Check {
    fn view(&self) -> crate::El<'_> {
        crate::checkbox(CHECK_NAME, self.checked)
            .w(220)
            .h(32)
            .on_click(Self::toggle)
    }
}
async fn checked(bus: &Connection, node: &Address) -> zbus::Result<bool> {
    let states: Vec<u32> = proxy(bus, node, "org.a11y.atspi.Accessible")
        .await?
        .call("GetState", &())
        .await?;
    // AT-SPI State::Checked is bit4 in the protocol's two-word state set.
    assert_eq!(states.len(), 2);
    Ok(states[0] & (1 << 4) != 0)
}
async fn exercise(deadline: Instant) -> Result<(), Box<dyn std::error::Error>> {
    let runtime = SharedRuntime::current()?;
    let session = Builder::session()
        .method_timeout(Duration::from_secs(3))
        .build()
        .await?;
    let fixture = lifecycle::Fixture::start(&session).await?;
    let desktop = (
        "org.a11y.atspi.Registry".to_owned(),
        "/org/a11y/atspi/accessible/root".try_into()?,
    );
    let window = wait_for(&runtime, deadline, async || {
        let roots = proxy(&session, &desktop, "org.a11y.atspi.Accessible")
            .await
            .ok()?
            .call("GetChildren", &())
            .await
            .ok()?;
        named(&session, roots, CHECK_TITLE).await
    })
    .await;
    let node = named(&session, vec![window], CHECK_NAME)
        .await
        .ok_or("checkbox missing")?;
    let accessible = proxy(&session, &node, "org.a11y.atspi.Accessible").await?;
    // AT-SPI Role::CheckBox is protocol value7.
    assert_eq!(accessible.call::<_, _, u32>("GetRole", &()).await?, 7);
    assert!(!checked(&session, &node).await?);
    let event = proxy(&session, &node, "org.a11y.atspi.Event.Object").await?;
    let mut signals = event.receive_signal("StateChanged").await?;
    let action = proxy(&session, &node, "org.a11y.atspi.Action").await?;
    for expected in [true, false] {
        assert!(action.call::<_, _, bool>("DoAction", &(0i32,)).await?);
        loop {
            let message = std::future::poll_fn(|cx| std::pin::Pin::new(&mut signals).poll_next(cx))
                .await
                .ok_or("state event stream ended")?;
            type Body = (
                String,
                i32,
                i32,
                zbus::OwnedVariant,
                std::collections::HashMap<String, zbus::OwnedVariant>,
            );
            let (kind, value, _, _, _) = message.body().deserialize::<Body>()?;
            if kind == "checked" {
                assert_eq!(value, i32::from(expected));
                break;
            }
        }
        wait_for(&runtime, deadline, async || {
            (checked(&session, &node).await.ok()? == expected).then_some(())
        })
        .await;
        assert_eq!(accessible.get_property::<String>("Name").await?, CHECK_NAME);
        eprintln!(
            "GPUI_NATIVE_CHECKBOX role=7 action=DoAction(0) checked={expected} StateChanged:checked={}",
            i32::from(expected)
        );
    }
    drop(signals);
    fixture.close().await?;
    session.close().await?;
    Ok(())
}
struct Script {
    host: NativeHost<Check>,
    deadline: Instant,
    sender: Option<mpmc::Sender<Result<(), String>>>,
    receiver: mpmc::Receiver<Result<(), String>>,
    client: Option<thread::JoinHandle<()>>,
    complete: bool,
}
impl Host for Script {
    fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
        let about = matches!(callback, Callback::AboutToWait);
        self.host.dispatch(event_loop, callback);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        if !about {
            return;
        }
        assert!(Instant::now() < self.deadline, "checkbox native deadline");
        if self.client.is_none()
            && self
                .host
                .owner
                .as_ref()
                .is_some_and(|owner| owner.accessibility_state().unwrap().valid)
        {
            let sender = self.sender.take().unwrap();
            let wake = self.host.wake.clone().unwrap();
            let deadline = self.deadline;
            self.client = Some(thread::spawn(move || {
                let result = zbus::block_on(async {
                    SharedRuntime::current()?
                        .timeout_at(deadline, exercise(deadline))
                        .await?
                });
                sender
                    .try_send(result.map_err(|error: Box<dyn std::error::Error>| error.to_string()))
                    .unwrap();
                wake.signal();
            }));
        }
        if let Ok(result) = self.receiver.try_recv() {
            result.expect("actual checkbox AT-SPI client failed");
            let owner = self.host.owner.as_ref().unwrap();
            assert_eq!(owner.root().unwrap().calls, 2);
            assert!(!owner.root().unwrap().checked);
            owner
                .visit(|part| {
                    assert_eq!(part.role(), Role::CheckBox);
                    assert_eq!(part.checked(), Some(false));
                })
                .unwrap();
            assert!(owner.accessibility_state().unwrap().token.is_some());
            self.complete = true;
            event_loop.exit();
        }
        event_loop.set_control_flow(ControlFlow::WaitUntil(self.deadline));
    }
}
#[test]
#[ignore = "requires X11 and an isolated session bus initially lacking org.a11y.Bus"]
fn native_atspi_checkbox_action_state_and_events() {
    let event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let (sender, receiver) = mpmc::bounded(1.try_into().unwrap());
    let host = Script {
        host: NativeHost::new(
            Window::document(Check::default())
                .title(CHECK_TITLE)
                .size(280, 120)
                .renderer(RendererPolicy::ReferenceCpu),
        ),
        deadline: Instant::now() + Duration::from_secs(30),
        sender: Some(sender),
        receiver,
        client: None,
        complete: false,
    };
    let (mut driver, wake) = Driver::new(&event_loop, host);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app(&mut driver).unwrap();
    let script = driver.host_mut();
    assert!(script.complete);
    script.client.take().unwrap().join().unwrap();
}
