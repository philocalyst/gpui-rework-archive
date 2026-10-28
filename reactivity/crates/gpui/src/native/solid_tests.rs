use super::*;
use crate::{El, div};
use winit::{dpi::PhysicalSize, platform::run_on_demand::EventLoopExtRunOnDemand};

struct Empty;
impl View for Empty {
    fn view(&self) -> El<'_> {
        div()
    }
}

// Only the client's named softbuffer mappings, not total application/server PSS.
fn backing(phase: &str) -> usize {
    let (mut mapped, mut rss, mut pss) = (0, 0, 0);
    let mut matching = false;
    for line in std::fs::read_to_string("/proc/self/smaps").unwrap().lines() {
        if let Some((left, right)) = line
            .split_whitespace()
            .next()
            .and_then(|s| s.split_once('-'))
            && let (Ok(left), Ok(right)) = (
                usize::from_str_radix(left, 16),
                usize::from_str_radix(right, 16),
            )
        {
            matching = line.contains("softbuffer-x11-");
            if matching {
                mapped += right - left;
            }
        }
        if matching {
            for (name, total) in [("Rss:", &mut rss), ("Pss:", &mut pss)] {
                if let Some(value) = line.strip_prefix(name) {
                    *total += value
                        .split_whitespace()
                        .next()
                        .unwrap()
                        .parse::<usize>()
                        .unwrap();
                }
            }
        }
    }
    eprintln!("GPUI_SOLID_MEMORY,{phase},{mapped},{rss},{pss}");
    mapped
}

struct Script {
    host: NativeHost<Empty>,
    stage: u8,
    complete: bool,
    started: Instant,
}
impl Script {
    fn step(&mut self, event_loop: &ActiveEventLoop) {
        assert!(
            self.started.elapsed() < Duration::from_secs(15),
            "solid stage{}",
            self.stage
        );
        let Some(owner) = &mut self.host.owner else {
            return;
        };
        if !owner.snapshot().unwrap().presentation_valid {
            return;
        }
        match self.stage {
            0 => {
                assert!(self.host.presented_frames > 0);
                assert_eq!(
                    owner
                        .with_scene(|scene, _| scene.solid_bgrx().unwrap())
                        .unwrap(),
                    Some(0x00ff_ffff)
                );
                assert_eq!(
                    backing("initial_solid"),
                    0,
                    "logical resize must not allocate pixels"
                );
                let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics else {
                    panic!("CPU surface")
                };
                assert!(surface.fetch().unwrap().iter().all(|&p| p == 0x00ff_ffff));
                for color in [0, 0x0012_3456, 0x00ab_cdef, 0x00ff_ffff] {
                    assert!(surface.present_solid(color).unwrap());
                    assert!(surface.fetch().unwrap().iter().all(|&p| p == color));
                }
                {
                    let mut buffer = surface.buffer_mut().unwrap();
                    assert_eq!(buffer.len(), 800 * 600);
                    assert_eq!(buffer.age(), 0);
                    for (i, pixel) in buffer.iter_mut().enumerate() {
                        *pixel = (i as u32 * 31) & 0x00ff_ffff;
                    }
                    buffer.present().unwrap();
                }
                assert!(
                    surface
                        .fetch()
                        .unwrap()
                        .iter()
                        .enumerate()
                        .all(|(i, &p)| p == (i as u32 * 31) & 0x00ff_ffff)
                );
                // Fetch is a server barrier; measure only named SHM mappings,
                // not the diagnostic readback allocation.
                let buffered = backing("normal_buffer");
                // SHM is optional. A qualified MIT-SHM run records a 2MiB VMA;
                // the same functional oracle also covers the wire fallback.
                assert!(buffered == 0 || buffered == 2 * 1024 * 1024);
                assert!(surface.present_solid(0xff12_3456).is_err());
                assert!(
                    surface
                        .resize(
                            NonZeroU32::new(65_536).unwrap(),
                            NonZeroU32::new(600).unwrap()
                        )
                        .is_err()
                );
                {
                    let mut buffer = surface.buffer_mut().unwrap();
                    assert_eq!(buffer.age(), 1, "invalid color must not change history");
                    buffer[0] = 0x0001_0203;
                    buffer
                        .present_with_damage(&[softbuffer::Rect {
                            x: 0,
                            y: 0,
                            width: NonZeroU32::new(1).unwrap(),
                            height: NonZeroU32::new(1).unwrap(),
                        }])
                        .unwrap();
                }
                let pixels = surface.fetch().unwrap();
                assert_eq!(pixels[0], 0x0001_0203);
                assert!(
                    pixels[1..]
                        .iter()
                        .enumerate()
                        .all(|(i, &p)| p == ((i + 1) as u32 * 31) & 0x00ff_ffff)
                );
                assert!(surface.present_solid(0x0032_5476).unwrap());
                assert_eq!(backing("solid_after_buffer"), 0);
                assert!(surface.fetch().unwrap().iter().all(|&p| p == 0x0032_5476));
                {
                    let mut buffer = surface.buffer_mut().unwrap();
                    assert_eq!(buffer.age(), 0, "solid invalidates stale pixels");
                    buffer.fill(0x00ab_cdef);
                    buffer.present().unwrap();
                }
                assert!(surface.fetch().unwrap().iter().all(|&p| p == 0x00ab_cdef));
                // Queue another SHM read and immediately replace it with a
                // solid frame, without an intervening fetch/server barrier.
                {
                    let mut buffer = surface.buffer_mut().unwrap();
                    buffer.fill(0x0011_2233);
                    buffer.present().unwrap();
                }
                assert!(surface.present_solid(0x0044_5566).unwrap());
                assert!(surface.fetch().unwrap().iter().all(|&p| p == 0x0044_5566));
                owner.presentation_lost().unwrap();
                assert!(!owner.snapshot().unwrap().presentation_valid);
                self.stage = 1;
                self.host.request_redraw();
            }
            1 => {
                assert!(self.host.presented_frames >= 2);
                assert_eq!(backing("native_redraw"), 0);
                let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics else {
                    panic!("CPU surface")
                };
                assert!(surface.fetch().unwrap().iter().all(|&p| p == 0x00ff_ffff));
                self.stage = 2;
                let _ = self
                    .host
                    .window
                    .as_ref()
                    .unwrap()
                    .request_inner_size(PhysicalSize::new(400, 300));
            }
            2 => {
                if owner
                    .with_scene(|scene, _| [scene.width, scene.height])
                    .unwrap()
                    != [400, 300]
                {
                    return;
                }
                let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics else {
                    panic!("CPU surface")
                };
                let pixels = surface.fetch().unwrap();
                assert_eq!(pixels.len(), 400 * 300);
                assert!(pixels.iter().all(|&p| p == 0x00ff_ffff));
                assert_eq!(backing("resized"), 0);
                self.stage = 3;
                self.host.dispatch(event_loop, Callback::Suspended);
                assert!(self.host.graphics.is_none());
                assert!(
                    !self
                        .host
                        .owner
                        .as_ref()
                        .unwrap()
                        .snapshot()
                        .unwrap()
                        .presentation_valid
                );
                self.host.dispatch(event_loop, Callback::Resumed);
            }
            3 => {
                assert_eq!(backing("resumed"), 0);
                let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics else {
                    panic!("CPU surface")
                };
                assert!(surface.fetch().unwrap().iter().all(|&p| p == 0x00ff_ffff));
                assert!(self.host.presented_frames >= 4);
                self.complete = true;
                event_loop.exit();
            }
            _ => unreachable!(),
        }
    }
}
impl Host for Script {
    fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
        let idle = matches!(callback, Callback::AboutToWait);
        if self.host.presented_frames == 0
            && matches!(
                &callback,
                Callback::Window {
                    event: WindowEvent::RedrawRequested,
                    ..
                }
            )
        {
            assert!(
                !self
                    .host
                    .owner
                    .as_ref()
                    .unwrap()
                    .snapshot()
                    .unwrap()
                    .presentation_valid
            );
        }
        self.host.dispatch(event_loop, callback);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        if idle {
            self.step(event_loop);
            event_loop.set_control_flow(winit::event_loop::ControlFlow::WaitUntil(
                Instant::now() + Duration::from_millis(20),
            ));
        }
    }
}
pub(super) fn run(event_loop: &mut EventLoop<()>) {
    let host = NativeHost::new(
        Window::document(Empty)
            .size(800, 600)
            .renderer(RendererPolicy::ReferenceCpu),
    );
    let script = Script {
        host,
        stage: 0,
        complete: false,
        started: Instant::now(),
    };
    let (mut driver, wake) = Driver::new(event_loop, script);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app_on_demand(&mut driver).unwrap();
    assert!(driver.host().complete);
}
