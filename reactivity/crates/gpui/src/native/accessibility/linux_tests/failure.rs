//! Real provider actions and public model routes across a failed presentation.
use super::*;
use crate::{El, FieldId, Signal, Source, Sources, button, column, text_input};
use std::sync::{
    Arc,
    atomic::{AtomicUsize, Ordering},
};

const FAILURE_TITLE: &str = "GPUI native failed presentation repair";
struct Page {
    value: Signal<String>,
}
impl Page {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(&self.value).name("Draft").w(240).h(40),
            button("Repair").w(120).h(40).on_click(|m: &mut Self| {
                assert_eq!(
                    &**m.value, "bad\u{1f680}",
                    "old-provider edit must not overwrite the failed logical source"
                );
                *m.value = "repaired".into();
            }),
        ))
    }
}
async fn exercise(
    deadline: Instant,
    failures: &AtomicUsize,
) -> Result<(), Box<dyn std::error::Error>> {
    let runtime = SharedRuntime::current()?;
    let session = Builder::session()
        .method_timeout(Duration::from_secs(3))
        .build()
        .await?;
    let status = Proxy::new(&session, "org.a11y.Bus", "/org/a11y/bus", "org.a11y.Status").await?;
    status.set_property("IsEnabled", true).await?;
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
    let window = wait_for(&runtime, deadline, async || {
        let roots = proxy(&bus, &desktop, "org.a11y.atspi.Accessible")
            .await
            .ok()?
            .call("GetChildren", &())
            .await
            .ok()?;
        named(&bus, roots, FAILURE_TITLE).await
    })
    .await;
    eprintln!("NATIVE_FAILURE_STAGE window discovered");
    let input = named(&bus, vec![window.clone()], "Draft")
        .await
        .ok_or("missing input")?;
    let repair = named(&bus, vec![window.clone()], "Repair")
        .await
        .ok_or("missing Repair action")?;
    assert_eq!(
        proxy(&bus, &repair, "org.a11y.atspi.Accessible")
            .await?
            .call::<_, _, u32>("GetRole", &())
            .await?,
        43
    );
    let bounds: (i32, i32, i32, i32) = proxy(&bus, &input, "org.a11y.atspi.Component")
        .await?
        .call("GetExtents", &(0u32,))
        .await?;
    assert!(
        proxy(&bus, &input, "org.a11y.atspi.EditableText")
            .await?
            .call::<_, _, bool>("SetTextContents", &("bad\u{1f680}",))
            .await?
    );
    eprintln!("NATIVE_FAILURE_STAGE failing edit queued");
    wait_for(&runtime, deadline, async || {
        (failures.load(Ordering::Acquire) == 1).then_some(())
    })
    .await;
    eprintln!("NATIVE_FAILURE_STAGE presentation error observed");
    // A failed candidate does not publish a replacement provider: the original
    // P text and geometry remain visible while source actions are revoked.
    let old_value: String = proxy(&bus, &input, "org.a11y.atspi.Text")
        .await?
        .call("GetText", &(0i32, -1i32))
        .await?;
    assert_eq!(old_value, "seed");
    let old_bounds: (i32, i32, i32, i32) = proxy(&bus, &input, "org.a11y.atspi.Component")
        .await?
        .call("GetExtents", &(0u32,))
        .await?;
    assert_eq!(
        old_bounds, bounds,
        "failed candidate must not alter P geometry"
    );
    assert!(
        proxy(&bus, &input, "org.a11y.atspi.EditableText")
            .await?
            .call::<_, _, bool>("SetTextContents", &("blocked overwrite",))
            .await?
    );
    // FIFO admission processes that old-provider attempt before Repair.
    // Repair asserts the failed logical value is still intact.
    // Use the original stable actionable parent, with no provider reacquisition
    // or owner-side mutation to repair the model.
    assert!(
        proxy(&bus, &repair, "org.a11y.atspi.Action")
            .await?
            .call::<_, _, bool>("DoAction", &(0i32,))
            .await?
    );
    eprintln!("NATIVE_FAILURE_STAGE original repair action queued");
    let repaired = wait_for(&runtime, deadline, async || {
        let current = named(&bus, vec![window.clone()], "Draft").await?;
        let value: String = proxy(&bus, &current, "org.a11y.atspi.Text")
            .await
            .ok()?
            .call("GetText", &(0i32, -1i32))
            .await
            .ok()?;
        (value == "repaired").then_some(current)
    })
    .await;
    eprintln!("NATIVE_FAILURE_STAGE repair acknowledged");
    assert_ne!(repaired, input);
    assert!(
        proxy(&bus, &input, "org.a11y.atspi.EditableText")
            .await?
            .call::<_, _, bool>("SetTextContents", &("retired overwrite",))
            .await
            .is_err()
    );
    assert!(
        proxy(&bus, &repaired, "org.a11y.atspi.Text")
            .await?
            .call::<_, _, bool>("SetCaretOffset", &(2i32,))
            .await?
    );
    wait_for(&runtime, deadline, async || {
        let caret: i32 = proxy(&bus, &repaired, "org.a11y.atspi.Text")
            .await
            .ok()?
            .get_property("CaretOffset")
            .await
            .ok()?;
        (caret == 2).then_some(())
    })
    .await;
    assert!(
        proxy(&bus, &repaired, "org.a11y.atspi.EditableText")
            .await?
            .call::<_, _, bool>("SetTextContents", &("done",))
            .await?
    );
    wait_for(&runtime, deadline, async || {
        let current = named(&bus, vec![window.clone()], "Draft").await?;
        let value: String = proxy(&bus, &current, "org.a11y.atspi.Text")
            .await
            .ok()?
            .call("GetText", &(0i32, -1i32))
            .await
            .ok()?;
        (value == "done").then_some(())
    })
    .await;
    assert_eq!(failures.load(Ordering::Acquire), 1);
    eprintln!(
        "GPUI_NATIVE_FAILURE old-P seed+extents preserved; old-provider source edit rejected; original Repair Action restored source; caret2+value done acknowledged"
    );
    bus.close().await?;
    session.close().await?;
    Ok(())
}
struct Script {
    host: NativeHost<Page>,
    deadline: Instant,
    failures: Arc<AtomicUsize>,
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
        assert!(
            Instant::now() < self.deadline,
            "native failure/repair watchdog"
        );
        if self.client.is_none()
            && self
                .host
                .owner
                .as_ref()
                .is_some_and(|owner| owner.accessibility_state().unwrap().valid)
        {
            let sender = self.sender.take().unwrap();
            let failures = self.failures.clone();
            let wake = self.host.wake.clone().unwrap();
            let deadline = self.deadline;
            self.client = Some(thread::spawn(move || {
                let result = zbus::block_on(async {
                    SharedRuntime::current()?
                        .timeout_at(deadline, exercise(deadline, &failures))
                        .await?
                });
                sender
                    .try_send(result.map_err(|error: Box<dyn std::error::Error>| error.to_string()))
                    .unwrap();
                wake.signal();
            }));
        }
        if let Ok(result) = self.receiver.try_recv() {
            result.expect("actual failed-presentation AT-SPI client");
            assert_eq!(
                &**self.host.owner.as_ref().unwrap().root().unwrap().value,
                "done"
            );
            assert_eq!(self.failures.load(Ordering::Acquire), 1);
            self.complete = true;
            event_loop.exit();
        }
        event_loop.set_control_flow(ControlFlow::WaitUntil(self.deadline));
    }
}
#[test]
#[ignore = "requires private X11/session with a real AT-SPI Registry and status service"]
fn native_atspi_failed_source_keeps_old_p_and_public_action_repairs() {
    let event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let failures = Arc::new(AtomicUsize::new(0));
    let observer = failures.clone();
    let (sender, receiver) = mpmc::bounded(1.try_into().unwrap());
    let host = Script {
        host: NativeHost::new(
            Window::document(Page {
                value: Signal::new("seed".into()),
            })
            .title(FAILURE_TITLE)
            .size(300, 140)
            .renderer(RendererPolicy::ReferenceCpu)
            .on_presentation_error(move |error| {
                assert!(matches!(error, Error::Canvas(_)));
                eprintln!("NATIVE_FAILURE_ERROR {error:?}");
                observer.fetch_add(1, Ordering::Release);
            }),
        ),
        deadline: Instant::now() + Duration::from_secs(30),
        failures,
        sender: Some(sender),
        receiver,
        client: None,
        complete: false,
    };
    let (mut driver, wake) = Driver::new(&event_loop, host);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app(&mut driver).unwrap();
    driver.host_mut().client.take().unwrap().join().unwrap();
    assert!(driver.host().complete);
}
