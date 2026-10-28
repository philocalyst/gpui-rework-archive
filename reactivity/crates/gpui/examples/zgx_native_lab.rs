//! Public-API port of ZGX's component_workload at a3678578980e.
//! Shared workload is copied verbatim under its adjacent MIT license.
use gpui::{Affine, Application, Remote, RendererPolicy, SendError, Window, prelude::*};
use std::{
    collections::VecDeque,
    time::{Duration, Instant},
};
#[allow(dead_code)]
#[path = "support/zgx_workload/src/lib.rs"]
mod workload;
use workload::{Mode, Workload};

pub(crate) struct Lab {
    scroll_offset: Signal<f64>,
    stream: Signal<String>,
    items: Vec<i32>,
    done: i32,
    controls: Controls,
}
// Match the reference's spawn + yield_now: one poll yields, the next applies.
// Only the wake is coalesced; every queued operation remains UI-owned and FIFO.
#[derive(Clone, Copy, Debug)]
enum Control {
    Append,
    Rewrite,
}
struct ControlTask {
    operation: Control,
    yielded: bool,
}
#[derive(Default)]
struct Controls {
    pending: VecDeque<ControlTask>,
    wake: Option<Remote<()>>,
    trace: bool,
}
impl Controls {
    fn schedule(&mut self) {
        if let Some(wake) = &self.wake {
            match wake.try_send(()) {
                Ok(()) | Err(SendError::Full(())) => {}
                Err(SendError::Closed(())) => self.pending.clear(),
            }
        }
    }
}
impl Lab {
    const STREAM: Source<Self, String> =
        Source::new(FieldId::new(1), "stream", |m| &m.stream, |m| &mut m.stream);
    const OFFSET: Source<Self, f64> = Source::new(
        FieldId::new(2),
        "offset",
        |m| &m.scroll_offset,
        |m| &mut m.scroll_offset,
    );
    fn new(work: &Workload) -> Self {
        Self {
            stream: Signal::new(work.visible_text()),
            scroll_offset: Signal::new(f64::from(work.scroll_offset)),
            items: Vec::new(),
            done: 0,
            controls: Controls::default(),
        }
    }
    fn control(&mut self, id: usize) {
        let operation = match id {
            0 => Control::Append,
            1 => Control::Rewrite,
            _ => {
                self.done = 999;
                if self.controls.trace {
                    eprintln!(
                        "GPUI_CONTROL,immediate,999,{},{}",
                        self.items.len(),
                        self.done
                    );
                }
                return;
            }
        };
        self.controls.pending.push_back(ControlTask {
            operation,
            yielded: false,
        });
        if self.controls.trace {
            eprintln!(
                "GPUI_CONTROL,queued,{operation:?},{},{}",
                self.items.len(),
                self.done
            );
        }
        self.controls.schedule();
    }
    fn poll_controls(&mut self, (): ()) {
        // deliver_ready freezes the inbox before callbacks. A self-wake here
        // belongs to a later delivery, even when that caller has a large budget.
        let ready = self.controls.pending.len();
        for _ in 0..ready {
            let mut task = self.controls.pending.pop_front().unwrap();
            if task.yielded {
                self.apply_control(task.operation);
                if self.controls.trace {
                    eprintln!(
                        "GPUI_CONTROL,applied,{:?},{},{}",
                        task.operation,
                        self.items.len(),
                        self.done
                    );
                }
            } else {
                task.yielded = true;
                if self.controls.trace {
                    eprintln!(
                        "GPUI_CONTROL,yielded,{:?},{},{}",
                        task.operation,
                        self.items.len(),
                        self.done
                    );
                }
                self.controls.pending.push_back(task);
            }
        }
        if !self.controls.pending.is_empty() {
            self.controls.schedule();
        }
    }
    fn apply_control(&mut self, operation: Control) {
        self.done = match operation {
            Control::Append => {
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
            Control::Rewrite => match self.items.first_mut() {
                Some(first) => {
                    *first = 99;
                    *first = 99;
                    0
                }
                None => -1,
            },
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
        self.work.scroll_offset = *model.scroll_offset as f32;
        if self.advance(finished) {
            if matches!(self.work.mode, Mode::Stream | Mode::Both) {
                *model.stream = self.work.visible_text();
            }
            if matches!(self.work.mode, Mode::Scroll | Mode::Both) {
                *model.scroll_offset = f64::from(self.work.scroll_offset);
            }
            let _ = self.delivered.send(());
        }
    }
}
impl Drop for Driver {
    fn drop(&mut self) {
        eprintln!(
            "workload_ticks={} admitted_ticks={} workload_scroll_offset={}",
            self.work.frames, self.received, self.work.scroll_offset
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
        .line_height(20)
        .fg(rgb(0xe5edf7))
}
const ROWS: ListId = ListId::new(1);
impl ItemSource for Lab {
    fn len(&self) -> usize {
        workload::ROW_COUNT
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(index as u64)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        usize::try_from(key.get())
            .ok()
            .filter(|index| *index < self.len())
    }
    fn row(&self, index: usize) -> El<'_> {
        div()
            .w(920)
            .h(28)
            .bg(rgb(if index % 2 == 0 { 0x192230 } else { 0x1d2838 }))
            .child(at(8., 4., label(workload::row_label(index), 904., 20.)))
    }
}
impl View for Lab {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::STREAM).direct(Self::OFFSET)
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

        div()
            .w(960)
            .h(720)
            .bg(rgb(0x10141c))
            .child(at(
                20.,
                20.,
                label("zgx performance lab", 920., 28.)
                    .font_size(20)
                    .line_height(28),
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
                uniform_list(ROWS, self, workload::ROW_HEIGHT as f64)
                    .overscan(2)
                    .scroll_offset(&self.scroll_offset)
                    .w(920)
                    .h(400)
                    .bg(rgb(0x192230)),
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
    let mut model = Lab::new(&work);
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
    let (control_wake, control_inbox) = Remote::bounded(1);
    model.controls.wake = Some(control_wake);
    model.controls.trace = trace;
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
        .with_inbox(control_inbox, Lab::poll_controls)
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
pub(crate) fn visit_scroll_frames(mut visit: impl FnMut(&mut gpui::Win<Lab>, usize)) {
    for mode in [Mode::Scroll, Mode::Both] {
        let work = port_tests::seeded(mode);
        let mut window = port_tests::window(&work);
        let (delivered, _received) = std::sync::mpsc::channel();
        let mut driver = Driver {
            work,
            received: 0,
            delivered,
        };
        visit(&mut window, 0);
        for tick in 1..=4 {
            window.update(|model| driver.owner(model, false)).unwrap();
            visit(&mut window, tick);
        }
    }
}

#[cfg(test)]
#[allow(dead_code)]
pub(crate) fn visit_cold_stream_frames(
    mut visit: impl FnMut(&mut gpui::Win<Lab>, &mut gpui::Win<Lab>, bool, usize),
) {
    for owner_route in [false, true] {
        let work = Workload {
            text: String::with_capacity(8256),
            scroll_offset: 0.,
            frames: 0,
            mode: Mode::Stream,
            seconds: 1.,
        };
        let mut window = port_tests::window(&work);
        let (delivered, _received) = std::sync::mpsc::channel();
        let mut driver = Driver {
            work,
            received: 0,
            delivered,
        };
        visit(
            &mut window,
            &mut port_tests::window(&driver.work),
            owner_route,
            0,
        );
        for tick in 1..=24 {
            if owner_route {
                window.update(|model| driver.owner(model, false)).unwrap();
            } else {
                let mut value = String::new();
                driver.stream(&mut value, false);
                window.set(Lab::STREAM, value).unwrap();
            }
            visit(
                &mut window,
                &mut port_tests::window(&driver.work),
                owner_route,
                tick,
            );
        }
    }
}

#[cfg(test)]
#[allow(dead_code)]
pub(crate) struct CostFixture {
    pub(crate) owner: gpui::Win<Lab>,
    driver: Driver,
    received: std::sync::mpsc::Receiver<()>,
}
#[cfg(test)]
#[allow(dead_code)]
impl CostFixture {
    pub(crate) fn new(case: &str) -> Self {
        let mode = match case {
            "scroll" | "fractional" => Mode::Scroll,
            "both" => Mode::Both,
            "stream" | "stream-owner" | "exposure" => Mode::Stream,
            _ => panic!("unknown complete workload case: {case}"),
        };
        let work = port_tests::seeded(mode);
        let owner = port_tests::window(&work);
        let (delivered, received) = std::sync::mpsc::channel();
        Self {
            owner,
            driver: Driver {
                work,
                received: 0,
                delivered,
            },
            received,
        }
    }
    pub(crate) fn advance(&mut self, case: &str) {
        if case == "exposure" {
            return;
        }
        if case == "stream" {
            let mut value = String::new();
            self.driver.stream(&mut value, false);
            self.owner.set(Lab::STREAM, value).unwrap();
        } else {
            self.owner
                .update(|model| {
                    self.driver.owner(model, false);
                    if case == "fractional" {
                        *model.scroll_offset += 0.5;
                    }
                })
                .unwrap();
        }
        self.received.try_recv().unwrap();
    }
}

#[cfg(test)]
mod port_tests {
    use super::*;
    use gpui::{Win, WindowOptions};
    use std::sync::mpsc;

    pub(super) fn seeded(mode: Mode) -> Workload {
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
    pub(super) fn window(work: &Workload) -> Win<Lab> {
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
            assert_eq!(
                *win.read(Lab::OFFSET).unwrap(),
                f64::from(oracle.scroll_offset)
            );
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
            assert_eq!(
                win.list_state(win.list(ROWS).unwrap())
                    .unwrap()
                    .realized_range,
                oracle.row_range()
            );
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
                assert_eq!(*model.scroll_offset, f64::from(oracle.scroll_offset));
                assert_eq!(&*model.stream, &oracle.visible_text());
                if matches!(tick, 1 | 8) {
                    assert_eq!(
                        win.with_pixels(|p, _, _| p.to_vec()).unwrap(),
                        fresh_pixels(&oracle)
                    );
                }
                let token = win.with_scene(|_, token| token).unwrap();
                win.presented(token).unwrap();
                assert_eq!(
                    win.list_state(win.list(ROWS).unwrap())
                        .unwrap()
                        .realized_range,
                    oracle.row_range()
                );
            }
        }
    }
    struct Positional {
        model: Lab,
        work: Workload,
    }
    impl View for Positional {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Source::new(
                FieldId::new(1),
                "stream",
                |m: &Self| &m.model.stream,
                |m: &mut Self| &mut m.model.stream,
            ))
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
                                    _ => self.model.done.to_string(),
                                },
                                38.,
                                20.,
                            ),
                        ))
                        .on_click(move |m: &mut Self| m.model.control(id)),
                )
            });
            let rows = self.work.row_range().map(|index| {
                at(
                    0.,
                    index as f32 * workload::ROW_HEIGHT - self.work.scroll_offset,
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
                    label("zgx performance lab", 920., 28.)
                        .font_size(20)
                        .line_height(28),
                ))
                .child(controls)
                .child(at(
                    220.,
                    62.,
                    label(self.model.items.len().to_string(), 50., 24.),
                ))
                .child(at(280., 62., label("stable", 80., 24.)))
                .child(at(
                    370.,
                    62.,
                    label(self.model.items.len().to_string(), 50., 24.),
                ))
                .child(at(
                    20.,
                    110.,
                    div().w(920).h(160).bg(rgb(0x192230)).clip().child(at(
                        8.,
                        8.,
                        label(&self.model.stream, 904., 144.),
                    )),
                ))
                .child(at(
                    20.,
                    290.,
                    div().w(920).h(400).bg(rgb(0x192230)).clip().child(rows),
                ))
        }
    }
    fn positional_pixels(work: Workload) -> Vec<u8> {
        Win::recording_with_font(
            Positional {
                model: Lab::new(&work),
                work,
            },
            WindowOptions {
                size: [960, 720],
                ..Default::default()
            },
            gpui_canvas::FontFace::new(workload::FONT_BYTES).unwrap(),
        )
        .unwrap()
        .with_pixels(|p, _, _| p.to_vec())
        .unwrap()
    }
    #[test]
    fn keyed_list_matches_frozen_positional_pixels_and_reference_range() {
        for offset in [0., 14., 16.5, 2660., 2799600.] {
            let mut work = seeded(Mode::Both);
            work.scroll_offset = offset;
            let mut win = window(&work);
            let pixels = win.with_pixels(|p, _, _| p.to_vec()).unwrap();
            let token = win.with_scene(|_, t| t).unwrap();
            win.presented(token).unwrap();
            let state = win.list_state(win.list(ROWS).unwrap()).unwrap();
            assert_eq!(state.offset, f64::from(offset));
            assert_eq!(state.realized_range, work.row_range());
            assert!(state.realized_range.len() <= 19);
            assert_eq!(pixels, positional_pixels(work), "offset={offset}");
        }
    }
    #[test]
    fn wheel_and_programmatic_scroll_feed_next_ui_tick_and_keep_keys() {
        let mut oracle = seeded(Mode::Both);
        let mut win = window(&oracle);
        let token = win.with_scene(|_, t| t).unwrap();
        win.presented(token).unwrap();
        let list = win.list(ROWS).unwrap();
        let key = ItemKey::new(100);
        let retained = win.list_item(list, key).unwrap();
        win.scroll_at(Point { x: 100., y: 310. }, 16.5).unwrap();
        let token = win.with_scene(|_, t| t).unwrap();
        win.presented(token).unwrap();
        assert_eq!(win.list_item(list, key).unwrap(), retained);
        oracle.scroll_offset += 16.5;
        assert_eq!(
            *win.read(Lab::OFFSET).unwrap(),
            f64::from(oracle.scroll_offset)
        );
        let (remote, inbox) = Remote::bounded(4);
        let (delivered, received) = mpsc::channel();
        let mut driver = Driver {
            work: seeded(Mode::Both),
            received: 0,
            delivered,
        };
        let mut win = win
            .with_inbox(inbox, move |m, done| driver.owner(m, done))
            .unwrap();
        for programmatic in [false, true] {
            if programmatic {
                win.scroll_to_index(list, 1234).unwrap();
                let token = win.with_scene(|_, t| t).unwrap();
                win.presented(token).unwrap();
                oracle.scroll_offset = 1234. * workload::ROW_HEIGHT;
            }
            oracle.tick();
            remote.try_send(false).unwrap();
            win.deliver_ready(1).unwrap();
            received.try_recv().unwrap();
            assert_eq!(
                *win.read(Lab::OFFSET).unwrap(),
                f64::from(oracle.scroll_offset)
            );
            assert_eq!(&**win.read(Lab::STREAM).unwrap(), oracle.visible_text());
            assert_eq!(
                win.with_pixels(|p, _, _| p.to_vec()).unwrap(),
                fresh_pixels(&oracle)
            );
            let token = win.with_scene(|_, t| t).unwrap();
            win.presented(token).unwrap();
            assert_eq!(
                win.list_state(list).unwrap().realized_range,
                oracle.row_range()
            );
        }
    }
}

#[cfg(test)]
mod deferred_control_tests {
    use super::*;
    use gpui::{LaneSet, Win};

    fn window() -> (Win<Lab, impl LaneSet<Lab>>, Remote<()>) {
        let work = port_tests::seeded(Mode::Idle);
        let (wake, inbox) = Remote::bounded(1);
        let mut model = Lab::new(&work);
        model.controls.wake = Some(wake.clone());
        let ui = std::thread::current().id();
        let mut win = Win::recording_with_font(
            model,
            gpui::WindowOptions {
                size: [960, 720],
                ..Default::default()
            },
            gpui_canvas::FontFace::new(workload::FONT_BYTES).unwrap(),
        )
        .unwrap()
        .with_inbox(inbox, move |m: &mut Lab, event| {
            assert_eq!(std::thread::current().id(), ui);
            m.poll_controls(event);
        })
        .unwrap();
        acknowledge(&mut win);
        (win, wake)
    }
    fn acknowledge<L: LaneSet<Lab>>(win: &mut Win<Lab, L>) {
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
    }
    fn click<L: LaneSet<Lab>>(win: &mut Win<Lab, L>, control: usize) {
        win.click_at(Point {
            x: 30. + control as f32 * 60.,
            y: 65.,
        })
        .unwrap();
        acknowledge(win);
    }
    fn deliver<L: LaneSet<Lab>>(win: &mut Win<Lab, L>) -> gpui::Delivery {
        let result = win.deliver_ready(usize::MAX).unwrap();
        acknowledge(win);
        result
    }
    fn pixels<L: LaneSet<Lab>>(
        win: &mut Win<Lab, L>,
        items: &[i32],
        done: i32,
        focused: usize,
        work: &Workload,
    ) {
        // Independent expected model; only reproduce focus, never run its tasks.
        let mut expected = port_tests::window(work);
        acknowledge(&mut expected);
        click(&mut expected, focused);
        expected
            .update(|m| {
                m.items = items.to_vec();
                m.done = done;
            })
            .unwrap();
        assert_eq!(
            win.with_pixels(|p, _, _| p.to_vec()).unwrap(),
            expected.with_pixels(|p, _, _| p.to_vec()).unwrap()
        );
    }
    #[test]
    fn controls_yield_before_effects_and_keep_immediate_control_visible() {
        let (mut win, _wake) = window();
        let work = port_tests::seeded(Mode::Idle);
        click(&mut win, 0);
        assert!(
            win.root().unwrap().items.is_empty(),
            "click must only enqueue"
        );
        pixels(&mut win, &[], 0, 0, &work);
        win.reset_counters().unwrap();
        let first = deliver(&mut win);
        assert_eq!((first.received, first.applied), (1, 1));
        assert!(
            win.root().unwrap().items.is_empty(),
            "first poll must yield"
        );
        eprintln!("CONTROL_FIRST_POLL_COUNTERS,{:?}", win.counters());
        pixels(&mut win, &[], 0, 0, &work);
        click(&mut win, 2);
        assert_eq!(win.root().unwrap().done, 999);
        pixels(&mut win, &[], 999, 2, &work);
        assert_eq!(deliver(&mut win).applied, 1);
        assert_eq!(win.root().unwrap().items, [1, 2, 3]);
        assert_eq!(win.root().unwrap().done, 0);
        pixels(&mut win, &[1, 2, 3], 0, 2, &work);
        assert_eq!(deliver(&mut win).received, 0);
    }
    #[test]
    fn coalesced_wake_keeps_fifo_operations_and_partial_capacity_failure() {
        let (mut win, _wake) = window();
        for id in [0, 1, 0] {
            click(&mut win, id);
        }
        assert!(win.root().unwrap().items.is_empty());
        assert_eq!(deliver(&mut win).received, 1);
        assert!(win.root().unwrap().items.is_empty());
        assert_eq!(deliver(&mut win).received, 1);
        assert_eq!(win.root().unwrap().items, [99, 2, 3, 1]);
        assert_eq!(win.root().unwrap().done, -1);
        assert!(win.root().unwrap().controls.pending.is_empty());
        pixels(
            &mut win,
            &[99, 2, 3, 1],
            -1,
            0,
            &port_tests::seeded(Mode::Idle),
        );
        assert_eq!(deliver(&mut win).received, 0);
    }
    #[test]
    fn newly_queued_control_yields_while_older_ready_control_applies() {
        let (mut win, _wake) = window();
        click(&mut win, 0);
        deliver(&mut win);
        click(&mut win, 1);
        deliver(&mut win);
        assert_eq!(win.root().unwrap().items, [1, 2, 3]);
        deliver(&mut win);
        assert_eq!(win.root().unwrap().items, [99, 2, 3]);
        assert_eq!(win.root().unwrap().done, 0);
        assert_eq!(deliver(&mut win).received, 0);
    }
    #[test]
    fn empty_rewrite_reports_error_only_after_yield() {
        let (mut win, _wake) = window();
        click(&mut win, 1);
        assert_eq!(win.root().unwrap().done, 0);
        deliver(&mut win);
        assert_eq!(win.root().unwrap().done, 0);
        deliver(&mut win);
        assert!(win.root().unwrap().items.is_empty());
        assert_eq!(win.root().unwrap().done, -1);
    }
    #[test]
    fn close_cancels_before_either_poll_and_cannot_reach_replacement_owner() {
        for polls in [0, 1] {
            let (mut win, wake) = window();
            click(&mut win, 0);
            for _ in 0..polls {
                deliver(&mut win);
            }
            win.close();
            assert!(win.is_closed());
            assert!(matches!(wake.try_send(()), Err(SendError::Closed(()))));
            assert!(win.deliver_ready(usize::MAX).is_err());
            let (mut replacement, _new_wake) = window();
            assert_eq!(deliver(&mut replacement).received, 0);
            assert!(replacement.root().unwrap().items.is_empty());
            assert_eq!(replacement.root().unwrap().done, 0);
        }
    }
    #[test]
    fn deferred_controls_coexist_with_exact_stream_lane() {
        let (win, _wake) = window();
        let (remote, inbox) = Remote::bounded(1);
        let mut win = win
            .with_inbox_for(inbox, Lab::STREAM, |value, next| *value = next)
            .unwrap();
        let mut work = port_tests::seeded(Mode::Stream);
        work.tick();
        click(&mut win, 0);
        remote.try_send(work.visible_text()).unwrap();
        let first = deliver(&mut win);
        assert_eq!(first.received, 2);
        assert!(win.root().unwrap().items.is_empty());
        assert_eq!(&**win.read(Lab::STREAM).unwrap(), work.visible_text());
        pixels(&mut win, &[], 0, 0, &work);
        assert_eq!(deliver(&mut win).received, 1);
        assert_eq!(win.root().unwrap().items, [1, 2, 3]);
        assert_eq!(&**win.read(Lab::STREAM).unwrap(), work.visible_text());
        pixels(&mut win, &[1, 2, 3], 0, 0, &work);
    }
    #[test]
    fn deferred_control_storage_and_wake_allocation_ledger() {
        let mut lane = None;
        let inbox = allocation_counter::measure(|| lane = Some(Remote::<()>::bounded(1)));
        let mut controls = Controls::default();
        let queue = allocation_counter::measure(|| {
            for _ in 0..64 {
                controls.pending.push_back(ControlTask {
                    operation: Control::Append,
                    yielded: false,
                });
            }
        });
        eprintln!(
            "CONTROL_HEADERS,Lab={},Controls={},Task={},Remote={},Inbox={}",
            size_of::<Lab>(),
            size_of::<Controls>(),
            size_of::<ControlTask>(),
            size_of::<Remote<()>>(),
            size_of::<gpui::Inbox<()>>()
        );
        eprintln!(
            "CONTROL_STORAGE,inbox_requests={},inbox_bytes={},inbox_retained={},queue_requests={},queue_bytes={},queue_retained={},queue_capacity={}",
            inbox.count_total,
            inbox.bytes_total,
            inbox.bytes_current,
            queue.count_total,
            queue.bytes_total,
            queue.bytes_current,
            controls.pending.capacity()
        );
        drop(lane);
    }
}
