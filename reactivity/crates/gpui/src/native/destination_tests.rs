//! Actual X11/RECORD proofs; each test requires its declared SHM profile.
use super::*;
use crate::{Color, El, column, div};
use winit::{
    dpi::PhysicalSize,
    platform::{run_on_demand::EventLoopExtRunOnDemand, x11::EventLoopBuilderExtX11},
};
use x11rb::{
    connection::Connection,
    protocol::xproto::{self, ConnectionExt as _},
};
mod record;
use record::{Record, Transfer};

struct Patch {
    tone: bool,
    solid: bool,
}
impl View for Patch {
    fn view(&self) -> El<'_> {
        if self.solid {
            div()
        } else {
            column((
                div().w(32).h(32).bg(if self.tone {
                    Color::rgb(31, 149, 219)
                } else {
                    Color::rgb(213, 47, 79)
                }),
                div().w(32).h(32).bg(Color::rgb(79, 113, 37)),
            ))
        }
    }
}
struct Script {
    host: NativeHost<Patch>,
    stage: u8,
    deadline: Instant,
    complete: bool,
    minimum_frames: u64,
    before_frames: u64,
    recorder: Option<Record>,
    overlay: Option<u32>,
    late_expose: bool,
    wire: bool,
}
impl Script {
    fn schedule(&mut self) {
        self.minimum_frames = self.host.presented_frames + 1;
        self.host.request_redraw();
    }
    fn oracle(&mut self) {
        let owner = self.host.owner.as_mut().unwrap();
        let snapshot = owner.snapshot().unwrap();
        assert!(snapshot.presentation_valid && snapshot.prepared_epoch.is_none());
        let mut expected = vec![0; snapshot.size[0] as usize * snapshot.size[1] as usize];
        owner.render_bgrx(&mut expected).unwrap();
        let Some(Graphics::ReferenceCpu(surface, _)) = &mut self.host.graphics else {
            panic!("explicit CPU surface")
        };
        assert_eq!(
            surface.fetch().unwrap(),
            expected,
            "complete server pixels at stage{}",
            self.stage
        );
    }
    fn step(&mut self, event_loop: &ActiveEventLoop) {
        assert!(
            Instant::now() < self.deadline,
            "destination proof deadline stage{}",
            self.stage
        );
        assert!(
            self.host.instance.is_none(),
            "explicit CPU never initializes a GPU"
        );
        if self.stage == 8 {
            if !self.host.occluded {
                return;
            }
            assert!(self.host.destination.requires_full());
            let recorder = self.recorder.as_ref().unwrap();
            recorder
                .control
                .destroy_window(self.overlay.take().unwrap())
                .unwrap()
                .check()
                .unwrap();
            recorder.sync();
            self.schedule();
            self.stage = 9;
            return;
        }
        if self.stage == 10 {
            if self.host.window.as_ref().unwrap().is_visible() != Some(false) {
                return;
            }
            assert!(self.host.destination.requires_full());
            assert_eq!(
                self.host.presented_frames, self.before_frames,
                "hidden candidate is not acknowledged"
            );
            assert!(
                self.host
                    .owner
                    .as_ref()
                    .unwrap()
                    .snapshot()
                    .unwrap()
                    .prepared_epoch
                    .is_some()
            );
            self.host.window.as_ref().unwrap().set_visible(true);
            self.schedule();
            self.stage = 11;
            return;
        }
        let Some(owner) = &self.host.owner else {
            return;
        };
        let snapshot = owner.snapshot().unwrap();
        if !snapshot.presentation_valid
            || snapshot.prepared_epoch.is_some()
            || self.host.presented_frames < self.minimum_frames
        {
            return;
        }
        self.oracle();
        assert!(!self.host.destination.requires_full());
        if self.wire {
            match self.stage {
                0 => self.schedule(),
                1 => {
                    self.host
                        .owner
                        .as_mut()
                        .unwrap()
                        .update(|m| m.tone = !m.tone)
                        .unwrap();
                    self.schedule();
                }
                2 => {
                    self.complete = true;
                    event_loop.exit();
                }
                _ => unreachable!(),
            }
            self.stage += 1;
            return;
        }
        match self.stage {
            0 => self.schedule(), // Empty app damage: no image transfer on valid SHM.
            1 => {
                self.host
                    .owner
                    .as_mut()
                    .unwrap()
                    .update(|m| m.tone = !m.tone)
                    .unwrap();
                self.schedule();
            }
            2 => {
                // All requests reach the server while the event-loop owner is
                // in this callback. Public app+Expose redraws then coalesce.
                let recorder = self.recorder.as_ref().unwrap();
                recorder.corrupt();
                for count in [2, 1, 0] {
                    recorder.expose(count);
                }
                recorder.sync();
                self.host
                    .owner
                    .as_mut()
                    .unwrap()
                    .update(|m| m.tone = !m.tone)
                    .unwrap();
                self.before_frames = self.host.presented_frames;
                self.schedule();
                self.host.request_redraw();
                self.host.request_redraw();
            }
            3 => {
                assert_eq!(
                    self.host.presented_frames,
                    self.before_frames + 1,
                    "coalesced app/expose redraw"
                );
                let recorder = self.recorder.as_ref().unwrap();
                recorder.corrupt();
                recorder.expose(1);
                recorder.sync();
                self.schedule(); // The final Expose has deliberately not arrived.
            }
            4 => {
                let Some(Graphics::ReferenceCpu(_, history)) = &self.host.graphics else {
                    unreachable!()
                };
                assert_eq!(
                    history.since(2),
                    Some(Default::default()),
                    "forced full is not scene damage"
                );
                let recorder = self.recorder.as_ref().unwrap();
                recorder.expose(0);
                recorder.sync();
                self.schedule();
            }
            5 => {
                self.late_expose = true;
                self.schedule();
            }
            6 => {
                // Normal application policy returns platform errors. This proof
                // explicitly catches one real backend rejection and elects a
                // retry through the same native redraw/submit path.
                self.host
                    .owner
                    .as_mut()
                    .unwrap()
                    .update(|m| m.tone = !m.tone)
                    .unwrap();
                let before = self.host.presented_frames;
                self.host.fail_next_cpu_present = true;
                assert!(self.host.redraw().is_err());
                assert_eq!(self.host.presented_frames, before);
                assert!(self.host.destination.requires_full());
                assert!(
                    self.host
                        .owner
                        .as_ref()
                        .unwrap()
                        .snapshot()
                        .unwrap()
                        .prepared_epoch
                        .is_some()
                );
                self.schedule();
            }
            7 => {
                let recorder = self.recorder.as_ref().unwrap();
                let root = recorder
                    .control
                    .get_geometry(recorder.window)
                    .unwrap()
                    .reply()
                    .unwrap()
                    .root;
                let origin = recorder
                    .control
                    .translate_coordinates(recorder.window, root, 0, 0)
                    .unwrap()
                    .reply()
                    .unwrap();
                let overlay = recorder.control.generate_id().unwrap();
                recorder
                    .control
                    .create_window(
                        0,
                        overlay,
                        root,
                        origin.dst_x,
                        origin.dst_y,
                        184,
                        128,
                        0,
                        xproto::WindowClass::INPUT_OUTPUT,
                        0,
                        &xproto::CreateWindowAux::new()
                            .override_redirect(1)
                            .background_pixel(0xff00ff),
                    )
                    .unwrap()
                    .check()
                    .unwrap();
                recorder
                    .control
                    .map_window(overlay)
                    .unwrap()
                    .check()
                    .unwrap();
                recorder.sync();
                self.overlay = Some(overlay);
            }
            9 => {
                self.before_frames = self.host.presented_frames;
                self.host.window.as_ref().unwrap().set_visible(false);
                self.host
                    .owner
                    .as_mut()
                    .unwrap()
                    .update(|m| m.tone = !m.tone)
                    .unwrap();
                self.host.request_redraw();
            }
            11 => {
                let _ = self
                    .host
                    .window
                    .as_ref()
                    .unwrap()
                    .request_inner_size(PhysicalSize::new(208, 152));
                self.schedule();
            }
            12 => {
                if snapshot.size != [208, 152] {
                    return;
                }
                self.host.dispatch(event_loop, Callback::Suspended);
                assert!(self.host.destination.requires_full());
                self.host.dispatch(event_loop, Callback::Resumed);
                self.schedule();
            }
            13 => {
                self.host
                    .owner
                    .as_mut()
                    .unwrap()
                    .update(|m| m.solid = true)
                    .unwrap();
                self.schedule();
            }
            14 => {
                self.host
                    .owner
                    .as_mut()
                    .unwrap()
                    .update(|m| m.solid = false)
                    .unwrap();
                self.schedule();
            }
            15 => {
                self.complete = true;
                event_loop.exit();
            }
            _ => unreachable!("stage{}", self.stage),
        }
        self.stage += 1;
    }
}
impl Host for Script {
    fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>) {
        let resumed = matches!(callback, Callback::Resumed);
        let waiting = matches!(callback, Callback::AboutToWait);
        let redraw = matches!(
            callback,
            Callback::Window {
                event: WindowEvent::RedrawRequested,
                ..
            }
        );
        self.host.dispatch(event_loop, callback);
        assert!(self.host.error.is_none(), "{:?}", self.host.error);
        if resumed && self.recorder.is_none() {
            let window = u32::try_from(u64::from(self.host.window.as_ref().unwrap().id())).unwrap();
            self.recorder = Some(Record::start(window, !self.wire));
        }
        if redraw && self.late_expose {
            self.late_expose = false;
            let recorder = self.recorder.as_ref().unwrap();
            recorder.corrupt();
            // A server-generated Expose arrives while this draw callback still
            // owns the thread; the following event iteration must fully repair.
            recorder
                .control
                .clear_area(true, recorder.window, 80, 80, 16, 16)
                .unwrap()
                .check()
                .unwrap();
            recorder.sync();
            self.minimum_frames = self.host.presented_frames + 1;
        }
        if waiting {
            self.step(event_loop);
            event_loop.set_control_flow(winit::event_loop::ControlFlow::WaitUntil(self.deadline));
        }
    }
}
#[test]
#[ignore = "requires actual X11 with MIT-SHM + RECORD; complete server-pixel oracle"]
fn destination_invalidation_controls_actual_x11_uploads_and_failure_retry() {
    let transfers = run(false);
    assert_eq!(
        transfers.iter().filter(|t| t.kind == "WIRE").count(),
        0,
        "this explicit proof requires actual SHM"
    );
    let solids = transfers
        .iter()
        .filter(|t| t.kind == "SOLID")
        .collect::<Vec<_>>();
    assert_eq!(solids.len(), 1);
    assert_eq!(solids[0].rect, [0, 0, 208, 152]);
    let copies = transfers
        .iter()
        .filter(|t| t.kind == "SHM")
        .collect::<Vec<_>>();
    assert_eq!(
        copies.len(),
        12,
        "each successful upload; empty/failing frames upload nothing: {transfers:?}"
    );
    assert_eq!(copies[0].rect, [0, 0, 184, 128]);
    let partials = copies
        .iter()
        .filter(|t| t.rect != [0, 0, 184, 128] && t.rect != [0, 0, 208, 152])
        .collect::<Vec<_>>();
    assert_eq!(
        partials.len(),
        2,
        "ordinary scene damage and solid→normal only"
    );
    assert!(partials.iter().all(|t| t.pixel_bytes < 184 * 128 * 4));
    for Transfer {
        kind,
        rect,
        pixel_bytes,
        request_bytes,
    } in &transfers
    {
        eprintln!(
            "GPUI_X11_TRANSFER,{kind},{},{},{},{},{pixel_bytes},{request_bytes}",
            rect[0], rect[1], rect[2], rect[3]
        );
    }
}

fn run(wire: bool) -> Vec<Transfer> {
    let mut event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let script = Script {
        host: NativeHost::new(
            Window::document(Patch {
                tone: false,
                solid: false,
            })
            .size(184, 128)
            .renderer(RendererPolicy::ReferenceCpu),
        ),
        stage: 0,
        deadline: Instant::now() + Duration::from_secs(30),
        complete: false,
        minimum_frames: 1,
        before_frames: 0,
        recorder: None,
        overlay: None,
        late_expose: false,
        wire,
    };
    let (mut driver, wake) = Driver::new(&event_loop, script);
    driver.host_mut().host.wake = Some(wake);
    event_loop.run_app_on_demand(&mut driver).unwrap();
    assert!(driver.host().complete);
    driver.host_mut().recorder.take().unwrap().finish()
}

#[test]
#[ignore = "requires actual X11 with RECORD and MIT-SHM explicitly disabled"]
fn wire_fallback_still_uploads_full_for_empty_and_partial_scene_damage() {
    let transfers = run(true);
    assert_eq!(transfers.len(), 3);
    for transfer in transfers {
        assert_eq!(transfer.kind, "WIRE");
        assert_eq!(transfer.rect, [0, 0, 184, 128]);
        assert_eq!(transfer.pixel_bytes, 184 * 128 * 4);
        eprintln!(
            "GPUI_X11_TRANSFER,WIRE,0,0,184,128,{},{}",
            transfer.pixel_bytes, transfer.request_bytes
        );
    }
}

#[test]
fn invalidation_state_adds_no_host_constructor_allocation() {
    let opening = Window::document(Patch {
        tone: false,
        solid: false,
    });
    let mut host = None;
    let allocation = allocation_counter::measure(|| host = Some(NativeHost::new(opening)));
    assert_eq!(allocation.count_total, 0);
    assert_eq!(allocation.bytes_total, 0);
    assert_eq!(size_of::<destination::Destination>(), 1);
    assert_eq!(size_of::<winit::window::RedrawInvalidation>(), 1);
    drop(host);
}
