//! Actual native submit and input delivery; no replacement presentation engine.
use super::*;
use crate::{AlphaMode, El, Image, ImageProfile, ImageSampling, Role, image};
use winit::{
    dpi::{PhysicalPosition, PhysicalSize},
    event::DeviceId,
    event_loop::ControlFlow,
    platform::{run_on_demand::EventLoopExtRunOnDemand, x11::EventLoopBuilderExtX11},
};
struct Gallery {
    covers: [Image; 2],
    selected: usize,
}
impl Gallery {
    fn next(&mut self) {
        self.selected ^= 1;
    }
}
impl View for Gallery {
    fn view(&self) -> El<'_> {
        image(&self.covers[self.selected])
            .sampling(ImageSampling::Linear)
            .w(96)
            .h(64)
            .name("Next cover")
            .on_click(Self::next)
    }
}
struct Script {
    host: NativeHost<Gallery>,
    stage: u8,
    deadline: Instant,
    complete: bool,
    target: Option<Target>,
    minimum_frames: u64,
}
impl Script {
    fn step(&mut self, event_loop: &ActiveEventLoop) {
        assert!(
            Instant::now() < self.deadline,
            "image native deadline stage{}",
            self.stage
        );
        let Some(owner) = self.host.owner.as_ref() else {
            return;
        };
        let sheet = owner.snapshot().unwrap();
        if !sheet.presentation_valid
            || sheet.prepared_epoch.is_some()
            || sheet.source_epoch != sheet.presentation_epoch
            || self.host.presented_frames < self.minimum_frames
        {
            return;
        }
        assert!(
            self.host.instance.is_none(),
            "explicit CPU must not initialize Wgpu"
        );
        match self.stage {
            0 => {
                let target = owner.role(Role::Image).one().unwrap();
                self.target = Some(target);
                let bounds = owner.bounds(target).unwrap();
                let device_id = DeviceId::dummy();
                self.host
                    .window_event(
                        event_loop,
                        &WindowEvent::CursorMoved {
                            device_id,
                            position: PhysicalPosition::new(
                                f64::from(bounds.x + bounds.width / 2.),
                                f64::from(bounds.y + bounds.height / 2.),
                            ),
                        },
                    )
                    .unwrap();
                for state in [ElementState::Pressed, ElementState::Released] {
                    self.host
                        .window_event(
                            event_loop,
                            &WindowEvent::MouseInput {
                                device_id,
                                state,
                                button: MouseButton::Left,
                            },
                        )
                        .unwrap();
                }
                let owner = self.host.owner.as_ref().unwrap();
                assert_eq!(owner.root().unwrap().selected, 1);
                let pending = owner.snapshot().unwrap();
                assert_eq!((pending.source_epoch, pending.presentation_epoch), (1, 0));
                self.minimum_frames = self.host.presented_frames + 1;
                self.host.request_redraw();
            }
            1 => {
                assert_eq!(owner.role(Role::Image).one().unwrap(), self.target.unwrap());
                self.minimum_frames = self.host.presented_frames + 1;
                let _ = self
                    .host
                    .window
                    .as_ref()
                    .unwrap()
                    .request_inner_size(PhysicalSize::new(151, 113));
            }
            2 => {
                if sheet.size != [151, 113] {
                    return;
                }
                self.minimum_frames = self.host.presented_frames + 1;
                self.host.dispatch(event_loop, Callback::Suspended);
                assert!(self.host.graphics.is_none());
                assert_eq!(
                    self.host
                        .owner
                        .as_ref()
                        .unwrap()
                        .bounds(self.target.unwrap()),
                    Err(Error::PresentationStale)
                );
                self.host.dispatch(event_loop, Callback::Resumed);
            }
            3 => {
                let owner = self.host.owner.as_mut().unwrap();
                assert_eq!(owner.root().unwrap().selected, 1);
                assert_eq!(owner.role(Role::Image).one().unwrap(), self.target.unwrap());
                let expected = owner
                    .with_pixels(|bytes, _, _| {
                        bytes
                            .as_chunks::<4>()
                            .0
                            .iter()
                            .map(|p| {
                                (u32::from(p[0]) << 16) | (u32::from(p[1]) << 8) | u32::from(p[2])
                            })
                            .collect::<Vec<_>>()
                    })
                    .unwrap();
                let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics else {
                    unreachable!()
                };
                assert_eq!(
                    surface.fetch().unwrap(),
                    expected,
                    "complete X11 image framebuffer after resume"
                );
                assert!(expected.iter().any(|&p| p != 0xffffff));
                self.complete = true;
                event_loop.exit();
            }
            _ => unreachable!(),
        }
        self.stage += 1;
    }
}
impl Host for Script {
    fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
        let waiting = matches!(callback, Callback::AboutToWait);
        self.host.dispatch(event_loop, callback);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        if waiting {
            self.step(event_loop);
            event_loop.set_control_flow(ControlFlow::WaitUntil(self.deadline));
        }
    }
}
#[test]
#[ignore = "requires real X11; exact CPU submit, pointer event, resize and resume"]
fn native_image_pointer_resize_resume_matches_complete_surface() {
    let covers = [ImageProfile::Srgb, ImageProfile::DisplayP3].map(|profile| {
        Image::rgba8(
            2,
            2,
            profile,
            AlphaMode::Straight,
            vec![
                255, 0, 0, 255, 0, 255, 0, 127, 0, 0, 255, 63, 255, 0, 255, 0,
            ]
            .into_boxed_slice(),
        )
        .unwrap()
    });
    let mut event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let script = Script {
        host: NativeHost::new(
            Window::document(Gallery {
                covers,
                selected: 0,
            })
            .size(128, 96)
            .renderer(RendererPolicy::ReferenceCpu),
        ),
        stage: 0,
        deadline: Instant::now() + Duration::from_secs(20),
        complete: false,
        target: None,
        minimum_frames: 1,
    };
    let (mut driver, wake) = Driver::new(&event_loop, script);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app_on_demand(&mut driver).unwrap();
    assert!(driver.host().complete);
}
