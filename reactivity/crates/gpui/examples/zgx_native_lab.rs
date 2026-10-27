//! Public-API port of ZGX's component_workload at a3678578980e.
//! Shared workload is copied verbatim under its adjacent MIT license.
use gpui::{Affine, Application, Remote, RendererPolicy, SendError, Window, prelude::*};
use std::time::{Duration, Instant};
#[allow(dead_code)]
#[path = "support/zgx_workload/src/lib.rs"]
mod workload;
use workload::{Mode, Workload};

struct Lab {
    scroll_offset: f32,
    rows: std::ops::Range<usize>,
    stream: Signal<String>,
    items: Vec<i32>,
    done: i32,
}
impl Lab {
    const STREAM: Source<Self, String> =
        Source::new(FieldId::new(1), "stream", |m| &m.stream, |m| &mut m.stream);
    fn new(work: &Workload) -> Self {
        Self {
            stream: Signal::new(work.visible_text()),
            scroll_offset: work.scroll_offset,
            rows: work.row_range(),
            items: Vec::new(),
            done: 0,
        }
    }
    fn control(&mut self, id: usize) {
        self.done = match id {
            0 => {
                let mut result = 0;
                for value in [1, 2, 3] {
                    if self.items.len() == 4 {
                        result = -1;
                        break;
                    }
                    self.items.push(value);
                }
                result
            }
            1 => match self.items.first_mut() {
                Some(first) => {
                    *first = 99;
                    *first = 99;
                    0
                }
                None => -1,
            },
            _ => 999,
        };
    }
}
// This state belongs to the UI callback. The producer only sends a tick:
// string generation and publication remain one UI-thread operation.
struct Driver {
    work: Workload,
    received: u64,
    delivered: std::sync::mpsc::Sender<()>,
}
impl Driver {
    fn advance(&mut self, finished: bool) -> bool {
        if finished {
            eprintln!("WORKLOAD_FINISHED admitted_ticks={}", self.received);
            return false;
        }
        self.work.tick();
        self.received += 1;
        true
    }
    fn stream(&mut self, value: &mut String, finished: bool) {
        if self.advance(finished) {
            *value = self.work.visible_text();
            let _ = self.delivered.send(());
        }
    }
    fn owner(&mut self, model: &mut Lab, finished: bool) {
        if self.advance(finished) {
            if matches!(self.work.mode, Mode::Stream | Mode::Both) {
                *model.stream = self.work.visible_text();
            }
            model.scroll_offset = self.work.scroll_offset;
            model.rows = self.work.row_range();
            let _ = self.delivered.send(());
        }
    }
}
impl Drop for Driver {
    fn drop(&mut self) {
        eprintln!(
            "workload_ticks={} admitted_ticks={} mounted_rows={}",
            self.work.frames,
            self.received,
            self.work.row_range().len()
        );
    }
}
// An ordinary zero-height wrapper places children without affecting sibling
// flow; its unclipped overflow is equivalent to the source's positioned boxes.
fn at<'a>(x: f32, y: f32, child: El<'a>) -> El<'a> {
    div()
        .w(0)
        .h(0)
        .transform(Affine::translation(x, y))
        .child(child)
}
fn label<'a>(value: impl gpui::IntoText<'a>, width: f64, height: f64) -> El<'a> {
    text(value)
        .w(width)
        .h(height)
        .font_size(14)
        .fg(rgb(0xe5edf7))
}
impl View for Lab {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::STREAM)
    }
    fn view(&self) -> El<'_> {
        let controls = (0..3).map(|id| {
            at(
                20. + id as f32 * 60.,
                55.,
                button("")
                    .w(50)
                    .h(32)
                    .p(0)
                    .bg(rgb(0x293b50))
                    .child(at(
                        12.,
                        6.,
                        label(
                            match id {
                                0 => "+".into(),
                                1 => "=".into(),
                                _ => self.done.to_string(),
                            },
                            38.,
                            20.,
                        ),
                    ))
                    .on_click(move |m: &mut Self| m.control(id)),
            )
        });
        let rows = self.rows.clone().map(|index| {
            at(
                0.,
                index as f32 * workload::ROW_HEIGHT - self.scroll_offset,
                div()
                    .w(920)
                    .h(28)
                    .bg(rgb(if index % 2 == 0 { 0x192230 } else { 0x1d2838 }))
                    .child(at(8., 4., label(workload::row_label(index), 904., 20.))),
            )
        });
        div()
            .w(960)
            .h(720)
            .bg(rgb(0x10141c))
            .child(at(
                20.,
                20.,
                label("zgx performance lab", 920., 28.).font_size(20),
            ))
            .child(controls)
            .child(at(220., 62., label(self.items.len().to_string(), 50., 24.)))
            .child(at(280., 62., label("stable", 80., 24.)))
            .child(at(370., 62., label(self.items.len().to_string(), 50., 24.)))
            .child(at(
                20.,
                110.,
                div().w(920).h(160).bg(rgb(0x192230)).clip().child(at(
                    8.,
                    8.,
                    label(&self.stream, 904., 144.),
                )),
            ))
            .child(at(
                20.,
                290.,
                div().w(920).h(400).bg(rgb(0x192230)).clip().child(rows),
            ))
    }
}
struct Presents {
    count: u64,
    start: Instant,
}
impl Presents {
    fn record(&mut self) {
        self.count += 1;
    }
}
impl Drop for Presents {
    fn drop(&mut self) {
        eprintln!(
            "native_acknowledgements={} native_elapsed_seconds={:.6}",
            self.count,
            self.start.elapsed().as_secs_f64()
        );
    }
}
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let work = Workload::from_env();
    let model = Lab::new(&work);
    let font_bytes = workload::font_file().unwrap_or_else(|| workload::FONT_BYTES.to_vec());
    eprintln!("font_file_fnv64={:016x}", workload::fnv64(&font_bytes));
    let font = gpui_canvas::FontFace::new(&font_bytes)?;
    if let Ok(path) = std::env::var("GPUI_LAB_SNAPSHOT") {
        let mut win = gpui::Win::recording_with_font(
            model,
            gpui::WindowOptions {
                size: [960, 720],
                ..Default::default()
            },
            font,
        )?;
        let token = win.with_scene(|_, t| t)?;
        win.presented(token)?;
        assert!(win.contains_text("zgx performance lab")?);
        win.with_pixels(|pixels, w, h| {
            use std::io::Write;
            let mut out = std::fs::File::create(path).unwrap();
            write!(out, "P6\n{w} {h}\n255\n").unwrap();
            for pixel in pixels.as_chunks::<4>().0 {
                out.write_all(&pixel[..3]).unwrap();
            }
        })?;
        return Ok(());
    }
    let seconds = work.seconds;
    let mode = work.mode;
    let (remote, inbox) = Remote::bounded(4);
    let (start_send, start_receive) = std::sync::mpsc::sync_channel(1);
    let (stop_send, stop_receive) = std::sync::mpsc::channel::<()>();
    let (delivered_send, delivered_receive) = std::sync::mpsc::channel::<()>();
    let worker = std::thread::spawn(move || {
        if start_receive.recv().is_err() {
            return;
        }
        let start = Instant::now();
        let end = (seconds > 0.).then(|| start + Duration::from_secs_f64(seconds));
        let mut next = start + workload::PERIOD;
        loop {
            let wake = if mode == Mode::Idle {
                let Some(end) = end else {
                    return;
                };
                end
            } else {
                end.map_or(next, |end| end.min(next))
            };
            match stop_receive.recv_timeout(wake.saturating_duration_since(Instant::now())) {
                Err(std::sync::mpsc::RecvTimeoutError::Timeout) => {}
                _ => return,
            }
            let finished = end.is_some_and(|end| Instant::now() >= end);
            match remote.try_send(finished) {
                Ok(()) => {}
                Err(SendError::Closed(_)) => break,
                Err(SendError::Full(_)) => {
                    eprintln!("workload_error=inbox_full");
                    break;
                }
            }
            if finished {
                break;
            }
            // Match the reference's UI-loop pacing: at most one pending tick.
            // A blocked UI cannot accumulate an external producer backlog.
            loop {
                match delivered_receive.recv_timeout(Duration::from_millis(50)) {
                    Ok(()) => break,
                    Err(std::sync::mpsc::RecvTimeoutError::Disconnected) => return,
                    Err(std::sync::mpsc::RecvTimeoutError::Timeout) => {
                        if stop_receive.try_recv().is_ok() {
                            return;
                        }
                    }
                }
            }
            next += workload::PERIOD;
            let now = Instant::now();
            if next <= now {
                next = now + workload::PERIOD;
            }
        }
    });
    let trace = std::env::var_os("GPUI_LAB_TRACE").is_some();
    let mut start_send = Some(start_send);
    let mut presents = Presents {
        count: 0,
        start: Instant::now(),
    };
    let renderer = if std::env::var("GPUI_LAB_RENDERER").as_deref() == Ok("cpu") {
        RendererPolicy::ReferenceCpu
    } else {
        RendererPolicy::Gpu
    };
    let window = Window::document(model)
        .title("GPUI ZGX lab")
        .size(960, 720)
        .text_font(font)
        .renderer(renderer)
        .on_presentation_error(|error| eprintln!("PRESENTATION_ERROR {error:?}"))
        .on_presented(move |frame| {
            presents.record();
            if let Some(sender) = start_send.take() {
                presents.start = Instant::now();
                let _ = sender.send(());
            }
            if trace {
                eprintln!(
                    "GPUI_ACK,{},{},{}",
                    frame.source_epoch,
                    frame.presentation_epoch,
                    presents.start.elapsed().as_nanos()
                );
            }
        });
    let mut driver = Driver {
        work,
        received: 0,
        delivered: delivered_send,
    };
    // The optional coarse route is an equivalent-work qualification control.
    let exact = mode == Mode::Stream && std::env::var("GPUI_LAB_INGRESS").as_deref() != Ok("owner");
    eprintln!("source_ingress={}", if exact { "exact" } else { "owner" });
    let result = if exact {
        Application::run_window(window.with_inbox_for(
            inbox,
            Lab::STREAM,
            move |value, finished| {
                driver.stream(value, finished);
            },
        ))
    } else {
        Application::run_window(window.with_inbox(inbox, move |model, finished| {
            driver.owner(model, finished);
        }))
    };
    let _ = stop_send.send(());
    worker.join().unwrap();
    result?;
    Ok(())
}

#[cfg(test)]
mod port_tests {
    use super::*;
    use gpui::{Win, WindowOptions};
    use std::sync::mpsc;

    fn seeded(mode: Mode) -> Workload {
        let mut work = Workload {
            text: String::with_capacity(8256),
            scroll_offset: 0.,
            frames: 0,
            mode: Mode::Both,
            seconds: 1.,
        };
        for _ in 0..190 {
            work.tick();
        }
        work.mode = mode;
        work
    }
    fn window(work: &Workload) -> Win<Lab> {
        Win::recording_with_font(
            Lab::new(work),
            WindowOptions {
                size: [960, 720],
                ..Default::default()
            },
            gpui_canvas::FontFace::new(workload::FONT_BYTES).unwrap(),
        )
        .unwrap()
    }
    fn fresh_pixels(work: &Workload) -> Vec<u8> {
        window(work)
            .with_pixels(|pixels, _, _| pixels.to_vec())
            .unwrap()
    }

    #[test]
    fn exact_stream_ingress_keeps_ui_work_and_matches_full_publication() {
        let mut oracle = seeded(Mode::Stream);
        let (remote, inbox) = Remote::bounded(4);
        let (delivered, received) = mpsc::channel();
        let mut driver = Driver {
            work: seeded(Mode::Stream),
            received: 0,
            delivered,
        };
        let ui_thread = std::thread::current().id();
        let mut win = window(&oracle)
            .with_inbox_for(inbox, Lab::STREAM, move |value, finished| {
                assert_eq!(std::thread::current().id(), ui_thread);
                driver.stream(value, finished);
            })
            .unwrap();
        let (owner_remote, owner_inbox) = Remote::bounded(4);
        let (owner_delivered, owner_received) = mpsc::channel();
        let mut owner_driver = Driver {
            work: seeded(Mode::Stream),
            received: 0,
            delivered: owner_delivered,
        };
        let mut owner = window(&oracle)
            .with_inbox(owner_inbox, move |model, finished| {
                owner_driver.owner(model, finished);
            })
            .unwrap();
        for tick in 1..=32 {
            oracle.tick();
            remote.try_send(false).unwrap();
            owner_remote.try_send(false).unwrap();
            win.reset_counters().unwrap();
            let delivery = win.deliver_ready(1).unwrap();
            assert_eq!((delivery.received, delivery.applied), (1, 1));
            owner.deliver_ready(1).unwrap();
            received.try_recv().unwrap();
            owner_received.try_recv().unwrap();
            assert_eq!(&**win.read(Lab::STREAM).unwrap(), oracle.visible_text());
            assert_eq!(win.root().unwrap().scroll_offset, oracle.scroll_offset);
            assert_eq!(win.root().unwrap().rows, oracle.row_range());
            assert_eq!(win.counters().exact_updates, 1);
            assert_eq!(win.counters().owner_reruns, 0);
            if matches!(tick, 1 | 2 | 16 | 32) {
                let pixels = win.with_pixels(|p, _, _| p.to_vec()).unwrap();
                assert_eq!(pixels, fresh_pixels(&oracle), "fresh tick {tick}");
                assert_eq!(
                    pixels,
                    owner.with_pixels(|p, _, _| p.to_vec()).unwrap(),
                    "owner tick {tick}"
                );
            }
            let token = win.with_scene(|_, token| token).unwrap();
            win.presented(token).unwrap();
            let token = owner.with_scene(|_, token| token).unwrap();
            owner.presented(token).unwrap();
        }
        let before = win.read(Lab::STREAM).unwrap().to_string();
        remote.try_send(true).unwrap();
        win.deliver_ready(1).unwrap();
        assert_eq!(&**win.read(Lab::STREAM).unwrap(), before);
        assert!(received.try_recv().is_err());
        drop(remote);
        win.reset_counters().unwrap();
        assert_eq!(win.deliver_ready(4).unwrap().received, 0);
        assert_eq!(win.counters(), gpui::Counters::default());
    }

    #[test]
    fn owner_modes_keep_reference_rows_offsets_and_text() {
        for mode in [Mode::Idle, Mode::Scroll, Mode::Both] {
            let mut oracle = seeded(mode);
            let (remote, inbox) = Remote::bounded(4);
            let (delivered, received) = mpsc::channel();
            let mut driver = Driver {
                work: seeded(mode),
                received: 0,
                delivered,
            };
            let mut win = window(&oracle)
                .with_inbox(inbox, move |model, finished| {
                    driver.owner(model, finished);
                })
                .unwrap();
            for tick in 1..=8 {
                oracle.tick();
                remote.try_send(false).unwrap();
                win.deliver_ready(1).unwrap();
                received.try_recv().unwrap();
                let model = win.root().unwrap();
                assert_eq!(model.scroll_offset, oracle.scroll_offset);
                assert_eq!(model.rows, oracle.row_range());
                assert_eq!(&*model.stream, &oracle.visible_text());
                if matches!(tick, 1 | 8) {
                    assert_eq!(
                        win.with_pixels(|p, _, _| p.to_vec()).unwrap(),
                        fresh_pixels(&oracle)
                    );
                }
                let token = win.with_scene(|_, token| token).unwrap();
                win.presented(token).unwrap();
            }
        }
    }
}
