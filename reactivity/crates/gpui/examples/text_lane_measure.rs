//! Whole-window requested-allocation ledger, with recording and CPU modes.
use gpui::{WindowOptions, prelude::*};
use std::time::Instant;

struct Page {
    count: usize,
    every: usize,
    value: Signal<String>,
    visible: bool,
    broken: bool,
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
        column((0..self.count).map(|index| {
            if self.visible && self.every != 0 && index % self.every == 0 {
                text(&self.value).w(64).h(1)
            } else {
                div().w(64).h(1)
            }
        }))
        .w(64)
        .h(24)
        .bg(Color::WHITE)
        .transform(if self.broken {
            gpui::Affine::scale(f32::MAX, f32::MAX)
        } else {
            gpui::Affine::IDENTITY
        })
    }
}
fn page(count: usize, every: usize) -> Page {
    Page {
        count,
        every,
        value: Signal::new("alpha beta gamma".into()),
        visible: true,
        broken: false,
    }
}
fn options() -> WindowOptions {
    WindowOptions {
        size: [80, 24],
        ..Default::default()
    }
}
fn ack(win: &mut Win<Page>) {
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
}
fn main() {
    let args = std::env::args().skip(1).collect::<Vec<_>>();
    let count: usize = args[0].parse().unwrap();
    let every: usize = args[1].parse().unwrap();
    let recording = args.get(2).is_none_or(|mode| mode == "recording");
    let hold_ack = args.get(3).is_some_and(|mode| mode == "pending");
    assert!(
        !hold_ack || recording,
        "pending candidates need recording mode"
    );
    assert!(count <= 16_384);
    // Independent fresh reference guards against a zero-work fixture. It also
    // warms code and allocator pages before the timed fresh owner.
    let mut preflight = Win::recording(page(count, every), options()).unwrap();
    ack(&mut preflight);
    assert_eq!(preflight.inspect().unwrap().nodes.len(), count + 1);
    let expected_texts = if every == 0 { 0 } else { count.div_ceil(every) };
    assert_eq!(
        preflight.role(gpui::Role::Text).count().unwrap(),
        expected_texts
    );
    assert!(preflight.with_scene(|s, _| s.draws().len() > 0).unwrap());
    let expected_draws = preflight
        .with_scene(|scene, _| scene.draws().len())
        .unwrap();
    preflight
        .with_pixels(|pixels, _, _| {
            assert_eq!(
                pixels.chunks_exact(4).any(|pixel| pixel[..3] != [255; 3]),
                expected_texts > 0
            );
        })
        .unwrap();
    drop(preflight);
    let model = page(count, every);
    let source_bytes = model.value.capacity();
    let mut win = None;
    let mut retained = 0i64;
    println!(
        "nodes,text_sites,mode,source_bytes,stage,microseconds,retained_delta,total_retained,peak_new_bytes,allocations,measure_calls,paint_passes"
    );
    // Keep the model move outside the operation closure's match borrow.
    let mut model = Some(model);
    let stages: &[&str] = if hold_ack {
        &["mount", "prepare_pending", "ack_pending", "drop"]
    } else {
        &[
            "mount",
            "equal_description",
            "direct_edit",
            "resize",
            "failed_prepare",
            "repair",
            "remove_text",
            "restore_text",
            "drop",
        ]
    };
    let mut old_visible_height = None;
    for &stage in stages {
        if let Some(win) = &mut win {
            Win::<Page>::reset_counters(win).unwrap();
        }
        let start = Instant::now();
        let work = allocation_counter::measure(|| {
            match stage {
                "mount" => {
                    let owner = model.take().unwrap();
                    let mut mounted = if recording {
                        Win::recording(owner, options())
                    } else {
                        Win::with_options(owner, options())
                    }
                    .unwrap();
                    if recording {
                        ack(&mut mounted);
                    }
                    assert_eq!(
                        mounted.with_scene(|scene, _| scene.draws().len()).unwrap(),
                        expected_draws
                    );
                    win = Some(mounted);
                }
                "prepare_pending" => {
                    let current = win.as_mut().unwrap();
                    let old_token = current.with_scene(|_, token| token).unwrap();
                    let mut height = 0.0;
                    current
                        .visit(|part| height += part.bounds().height)
                        .unwrap();
                    old_visible_height = Some(height);
                    current.resize([96, 32]).unwrap();
                    assert_ne!(current.with_scene(|_, token| token).unwrap(), old_token);
                    let mut still_presented = 0.0;
                    current
                        .visit(|part| still_presented += part.bounds().height)
                        .unwrap();
                    assert_eq!(
                        height, still_presented,
                        "queries retain acknowledged geometry"
                    );
                    assert_eq!(current.counters().presentations, 0);
                }
                "ack_pending" => {
                    let current = win.as_mut().unwrap();
                    ack(current);
                    let mut height = 0.0;
                    current
                        .visit(|part| height += part.bounds().height)
                        .unwrap();
                    if count > 24 {
                        assert!(height > old_visible_height.unwrap());
                    }
                    assert_eq!(current.counters().presentations, 1);
                }
                "equal_description" => {
                    win.as_mut().unwrap().update(|_| {}).unwrap();
                }
                "direct_edit" => {
                    win.as_mut()
                        .unwrap()
                        .set(Page::VALUE, "omega theta lambda".into())
                        .unwrap();
                }
                "resize" => {
                    win.as_mut().unwrap().resize([96, 32]).unwrap();
                }
                "failed_prepare" => {
                    let current = win.as_mut().unwrap();
                    let old = current.with_scene(|_, token| token).unwrap();
                    let old_draws = current.with_scene(|scene, _| scene.draws().len()).unwrap();
                    assert!(current.update(|m| m.broken = true).is_err());
                    assert_eq!(current.with_scene(|_, token| token).unwrap(), old);
                    assert_eq!(
                        current.with_scene(|scene, _| scene.draws().len()).unwrap(),
                        old_draws
                    );
                }
                "repair" => {
                    win.as_mut().unwrap().update(|m| m.broken = false).unwrap();
                }
                "remove_text" => {
                    win.as_mut().unwrap().update(|m| m.visible = false).unwrap();
                }
                "restore_text" => {
                    win.as_mut().unwrap().update(|m| m.visible = true).unwrap();
                }
                "drop" => {
                    drop(win.take());
                }
                _ => unreachable!(),
            }
            if !hold_ack
                && stage != "mount"
                && stage != "failed_prepare"
                && recording
                && let Some(win) = &mut win
            {
                ack(win);
            }
            if !recording && let Some(win) = &mut win {
                win.with_pixels(|pixels, _, _| std::hint::black_box(pixels.len()))
                    .unwrap();
            }
        });
        let us = start.elapsed().as_secs_f64() * 1e6;
        retained += work.bytes_current;
        let counters = win.as_ref().map(Win::counters).unwrap_or_default();
        println!(
            "{},{expected_texts},{},{source_bytes},{stage},{us:.3},{},{retained},{},{},{},{}",
            count + 1,
            if recording { "recording" } else { "cpu" },
            work.bytes_current,
            work.bytes_max,
            work.count_total,
            counters.measure_calls,
            counters.paint_passes
        );
    }
    // The untracked source allocation was dropped with the model; charge it
    // separately and verify no unexplained framework allocation remains.
    assert_eq!(retained, -(source_bytes as i64));
}
