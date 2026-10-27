//! Public-API port of ZGX's component_workload at a3678578980e.
//! Shared workload is copied verbatim under its adjacent MIT license.
use gpui::{Affine, Application, Remote, RendererPolicy, SendError, Window, prelude::*};
use std::time::{Duration, Instant};
#[allow(dead_code)]
#[path = "support/zgx_workload/src/lib.rs"]
mod workload;
use workload::{Mode, Workload};

struct Lab {
    work: Workload,
    stream: Signal<String>,
    items: Vec<i32>,
    done: i32,
    received: u64,
}
impl Lab {
    const STREAM: Source<Self, String> =
        Source::new(FieldId::new(1), "stream", |m| &m.stream, |m| &mut m.stream);
    fn new() -> Self {
        let work = Workload::from_env();
        Self {
            stream: Signal::new(work.visible_text()),
            work,
            items: Vec::new(),
            done: 0,
            received: 0,
        }
    }
    fn tick(&mut self) {
        self.work.tick();
        self.received += 1;
        if matches!(self.work.mode, Mode::Stream | Mode::Both) {
            *self.stream = self.work.visible_text();
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
impl Drop for Lab {
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
    let model = Lab::new();
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
            for pixel in pixels.chunks_exact(4) {
                out.write_all(&pixel[..3]).unwrap();
            }
        })?;
        return Ok(());
    }
    let seconds = model.work.seconds;
    let mode = model.work.mode;
    let (remote, inbox) = Remote::bounded(4);
    let (start_send, start_receive) = std::sync::mpsc::sync_channel(1);
    let (stop_send, stop_receive) = std::sync::mpsc::channel::<()>();
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
        .with_inbox(inbox, |model, finished| {
            if finished {
                eprintln!("WORKLOAD_FINISHED admitted_ticks={}", model.received);
            } else {
                model.tick();
            }
        })
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
    let result = Application::run_window(window);
    let _ = stop_send.send(());
    worker.join().unwrap();
    result?;
    Ok(())
}
