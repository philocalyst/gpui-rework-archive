//! Real X11 pointer/presentation and AT-SPI point queries over one frozen tree.
use super::*;
use winit::{
    dpi::{PhysicalPosition, Position},
    event::{DeviceId, ElementState, MouseButton, WindowEvent},
};

const TITLE: &str = "GPUI rounded clip point proof";
const CHILD: &str = "Rounded clip child";
#[derive(Default)]
struct Page {
    calls: u32,
}
impl View for Page {
    fn view(&self) -> crate::El<'_> {
        crate::div()
            .size(64)
            .rounded(32.)
            .clipped(self.calls < 2)
            .child(
                crate::button(CHILD)
                    .size(96)
                    .bg(crate::Color::BLACK)
                    .on_click(|page: &mut Self| page.calls += 1),
            )
    }
}
async fn at_point(
    bus: &Connection,
    node: &Address,
    x: i32,
    y: i32,
    kind: u32,
) -> zbus::Result<Address> {
    proxy(bus, node, "org.a11y.atspi.Component")
        .await?
        .call("GetAccessibleAtPoint", &(x, y, kind))
        .await
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
        named(&session, roots, TITLE).await
    })
    .await;
    let child = named(&session, vec![window.clone()], CHILD)
        .await
        .ok_or("clip child missing")?;
    let component = proxy(&session, &window, "org.a11y.atspi.Component").await?;
    let (sx, sy, width, height): (i32, i32, i32, i32) = wait_for(&runtime, deadline, async || {
        let bounds: (i32, i32, i32, i32) = component.call("GetExtents", &(0u32,)).await.ok()?;
        (bounds.0 < 0 && bounds.1 < 0).then_some(bounds)
    })
    .await;
    // Native extents remain rectangular. DPI is already in these physical units.
    let center = (width / 3, height / 3);
    let overflow = (width * 5 / 6, height / 6);
    let members = descendants(&session, child.clone()).await?;
    assert!(members.contains(&at_point(&session, &window, center.0, center.1, 1).await?));
    eprintln!(
        "GPUI_NATIVE_CLIP initial point checks source-qualified subtree={}",
        members.len()
    );
    assert!(members.contains(&at_point(&session, &window, sx + center.0, sy + center.1, 0).await?));
    assert!(!members.contains(&at_point(&session, &window, 1, 1, 1).await?));
    assert!(
        !members.contains(&at_point(&session, &child, 1, 1, 1).await?),
        "subtree entry must obey its rounded clipping ancestor"
    );
    assert!(!members.contains(&at_point(&session, &window, overflow.0, overflow.1, 1).await?));
    let child_component = proxy(&session, &child, "org.a11y.atspi.Component").await?;
    let before: (i32, i32, i32, i32) = child_component.call("GetExtents", &(1u32,)).await?;
    assert!(before.2 >= width && before.3 >= height);
    assert!(
        proxy(&session, &child, "org.a11y.atspi.Action")
            .await?
            .call::<_, _, bool>("DoAction", &(0i32,))
            .await?
    );
    wait_for(&runtime, deadline, async || {
        let current_members = descendants(&session, child.clone()).await.ok()?;
        current_members
            .contains(&at_point(&session, &window, 1, 1, 1).await.ok()?)
            .then_some(())
    })
    .await;
    // Text geometry cohort IDs retire when clip geometry changes. Resolve the
    // current subtree after ACK instead of treating those old IDs as authority.
    let members = descendants(&session, child.clone()).await?;
    assert!(
        members.contains(&at_point(&session, &window, overflow.0, overflow.1, 1).await?),
        "overflow children remain reachable when clipping is disabled"
    );
    let after: (i32, i32, i32, i32) = child_component.call("GetExtents", &(1u32,)).await?;
    assert_eq!(
        before, after,
        "native extents are conservative, not rounded masks"
    );
    eprintln!(
        "GPUI_NATIVE_CLIP native_point_negative=true screen_origin={sx},{sy} physical={width},{height} overflow_after_ack=true"
    );
    fixture.close().await?;
    session.close().await?;
    Ok(())
}
struct Script {
    host: NativeHost<Page>,
    deadline: Instant,
    sender: Option<mpmc::Sender<Result<(), String>>>,
    receiver: mpmc::Receiver<Result<(), String>>,
    client: Option<thread::JoinHandle<()>>,
    complete: bool,
    pointer_checked: bool,
}
impl Script {
    fn event(&mut self, event_loop: &ActiveEventLoop, event: WindowEvent) {
        let id = self.host.window.as_ref().unwrap().id();
        self.host
            .dispatch(event_loop, Callback::Window { id, event: &event });
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
    }
    fn click(&mut self, event_loop: &ActiveEventLoop, x: f64, y: f64) {
        self.event(
            event_loop,
            WindowEvent::CursorMoved {
                device_id: DeviceId::dummy(),
                position: PhysicalPosition::new(x, y),
            },
        );
        for state in [ElementState::Pressed, ElementState::Released] {
            self.event(
                event_loop,
                WindowEvent::MouseInput {
                    device_id: DeviceId::dummy(),
                    state,
                    button: MouseButton::Left,
                },
            );
        }
    }
}
impl Host for Script {
    fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
        let about = matches!(callback, Callback::AboutToWait);
        self.host.dispatch(event_loop, callback);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        if !about {
            return;
        }
        assert!(Instant::now() < self.deadline, "clip native deadline");
        let ready = self.host.owner.as_ref().is_some_and(|owner| {
            let sheet = owner.snapshot().unwrap();
            sheet.presentation_valid && sheet.prepared_epoch.is_none()
        });
        if ready && !self.pointer_checked {
            self.host
                .window
                .as_ref()
                .unwrap()
                .set_outer_position(Position::Physical(PhysicalPosition::new(-40, -30)));
            self.click(event_loop, 0.5, 0.5);
            assert_eq!(self.host.owner.as_ref().unwrap().root().unwrap().calls, 0);
            let scale = self.host.window.as_ref().unwrap().scale_factor();
            self.click(event_loop, 32. * scale, 32. * scale);
            assert_eq!(self.host.owner.as_ref().unwrap().root().unwrap().calls, 1);
            self.host.redraw().unwrap();
            self.pointer_checked = true;
        }
        if ready && self.pointer_checked && self.client.is_none() {
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
                    .try_send(result.map_err(|e: Box<dyn std::error::Error>| e.to_string()))
                    .unwrap();
                wake.signal();
            }));
        }
        if let Ok(result) = self.receiver.try_recv() {
            result.expect("actual rounded-clip AT-SPI client failed");
            let owner = self.host.owner.as_mut().unwrap();
            assert_eq!(owner.root().unwrap().calls, 2);
            assert!(owner.snapshot().unwrap().presentation_valid);
            let expected = owner
                .with_pixels(|pixels, _, _| {
                    pixels
                        .as_chunks::<4>()
                        .0
                        .iter()
                        .map(|p| u32::from(p[0]) << 16 | u32::from(p[1]) << 8 | u32::from(p[2]))
                        .collect::<Vec<_>>()
                })
                .unwrap();
            let Some(crate::native::Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics
            else {
                panic!("reference CPU surface");
            };
            assert_eq!(surface.fetch().unwrap(), expected);
            self.complete = true;
            event_loop.exit();
        }
        event_loop.set_control_flow(ControlFlow::WaitUntil(self.deadline));
    }
}
#[test]
#[ignore = "requires X11 and an isolated session bus initially lacking org.a11y.Bus"]
fn native_atspi_rounded_clip_point_queries_pointer_and_ack() {
    let event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let (sender, receiver) = mpmc::bounded(1.try_into().unwrap());
    let host = Script {
        host: NativeHost::new(
            Window::document(Page::default())
                .title(TITLE)
                .size(96, 96)
                .renderer(RendererPolicy::ReferenceCpu),
        ),
        deadline: Instant::now() + Duration::from_secs(30),
        sender: Some(sender),
        receiver,
        client: None,
        complete: false,
        pointer_checked: false,
    };
    let (mut driver, wake) = Driver::new(&event_loop, host);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app(&mut driver).unwrap();
    let script = driver.host_mut();
    assert!(script.complete);
    script.client.take().unwrap().join().unwrap();
}
