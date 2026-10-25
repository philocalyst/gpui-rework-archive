//! Cross-framework CPU-scene baseline; no native display or GPU measurements.
#![allow(dead_code)]
use gpui::prelude::*;
use gpui::{FontFace, ItemKey, ItemSource, ListId, uniform_list};
use std::hint::black_box;
use std::time::Instant;

const ROWS: usize = 100;
const COLUMNS: usize = 100;
const WARMUP: usize = 32;
const SAMPLES: usize = 240;

struct Grid<const DIRECT: bool> {
    color: Signal<Color>,
    width: Signal<f64>,
}
impl<const DIRECT: bool> Grid<DIRECT> {
    const COLOR: Source<Self, Color> = Source::new(
        FieldId::new(1),
        "color",
        |model| &model.color,
        |model| &mut model.color,
    );
    const WIDTH: Source<Self, f64> = Source::new(
        FieldId::new(2),
        "width",
        |model| &model.width,
        |model| &mut model.width,
    );
    fn new() -> Self {
        Self {
            color: Signal::new(Color::WHITE),
            width: Signal::new(8.0),
        }
    }
}
impl<const DIRECT: bool> View for Grid<DIRECT> {
    fn sources() -> Sources<Self> {
        if DIRECT {
            Sources::new().direct(Self::COLOR).direct(Self::WIDTH)
        } else {
            Sources::new().field(Self::COLOR).field(Self::WIDTH)
        }
    }
    fn view(&self) -> El<'_> {
        column((0..ROWS).map(|row_index| {
            row((0..COLUMNS).map(move |column_index| {
                let leaf = div().w(&self.width).h(8);
                if row_index == 50 && column_index == 50 {
                    leaf.bg(&self.color)
                } else {
                    leaf.bg(Color::WHITE)
                }
            }))
            .h(10)
            .gap(2)
            .transform(Affine::translation(1.0, 0.0))
        }))
    }
}

struct Rows {
    labels: Vec<String>,
}
impl ItemSource for Rows {
    fn len(&self) -> usize {
        self.labels.len()
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(index as u64)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        usize::try_from(key.get())
            .ok()
            .filter(|index| *index < self.labels.len())
    }
    fn row(&self, index: usize) -> El<'_> {
        text(self.labels[index].as_str()).font_size(14).h(32)
    }
}
impl View for Rows {
    fn view(&self) -> El<'_> {
        uniform_list(ListId::new(1), self, 32)
            .name("rows")
            .w(1000)
            .h(1000)
    }
}

struct Editor {
    value: Signal<String>,
}
impl Editor {
    const VALUE: Source<Self, String> = Source::new(
        FieldId::new(1),
        "value",
        |model| &model.value,
        |model| &mut model.value,
    );
}
impl View for Editor {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        text_input(&self.value).font_size(14).w(1000).h(80)
    }
}

fn font() -> FontFace {
    let path = std::env::var("COMPARISON_FONT").expect("COMPARISON_FONT must name pinned Inter");
    FontFace::new(std::fs::read(path).unwrap()).unwrap()
}

fn run<M: View + 'static>(
    name: &str,
    mut window: Win<M>,
    mut operation: impl FnMut(&mut Win<M>, usize),
) -> Win<M> {
    let initial_nodes = window.snapshot().unwrap().nodes.len();
    for step in 0..WARMUP {
        operation(&mut window, step);
    }
    window.reset_counters().unwrap();
    let mut samples = Vec::with_capacity(SAMPLES);
    for step in WARMUP..WARMUP + SAMPLES {
        let start = Instant::now();
        operation(&mut window, step);
        black_box(window.counters());
        samples.push(start.elapsed().as_nanos() as u64);
    }
    let counters = window.counters();
    let snapshot = window.snapshot().unwrap();
    let draws = window.with_scene(|scene, _| scene.draws().len()).unwrap();
    println!(
        "{}",
        serde_json::json!({
            "scenario": name,
            "scope": "public automatic-headless CPU scene and logical acknowledgement; no raster/GPU/OS",
            "warmup": WARMUP, "samples": SAMPLES, "ns": samples,
            "initial_nodes": initial_nodes, "final_nodes": snapshot.nodes.len(), "draws": draws,
            "owner_reruns": counters.owner_reruns, "descriptions": counters.descriptions,
            "source_operations": counters.source_operations, "source_reads": counters.source_reads,
            "destination_compares": counters.destination_compares,
            "layout_runs": counters.layout_runs, "measure_calls": counters.measure_calls,
            "paint_passes": counters.paint_passes, "text_promotions": counters.text_promotions,
            "text_bytes_copied": counters.text_bytes_copied,
        })
    );
    window
}

fn grid<const DIRECT: bool>() -> Win<Grid<DIRECT>> {
    let mut window = Win::with_size(Grid::new(), 1000, 1000).unwrap();
    let snapshot = window.snapshot().unwrap();
    assert_eq!(snapshot.nodes.len(), 10_101);
    // Snapshot bounds are conservatively expanded for hit testing. Validate
    // actual retained draw geometry instead of treating them as exact geometry.
    window
        .with_scene(|scene, _| {
            assert_eq!(scene.draws().len(), 10_000);
            let first = scene.draws().next().unwrap();
            assert_eq!(
                [first.local_rect.width, first.local_rect.height],
                [8.0, 8.0]
            );
            assert_eq!(
                first.sampled_rect_clip([1000, 1000]).unwrap(),
                Rect::new(1.0, 0.0, 8.0, 8.0)
            );
        })
        .unwrap();
    window.set(Grid::<DIRECT>::COLOR, rgb(0xff0000)).unwrap();
    let mut pixels = vec![0; 1_000_000];
    window.render_bgrx(&mut pixels).unwrap();
    assert_eq!(pixels[504 * 1000 + 505] & 0x00ffffff, 0x00ff0000);
    assert_eq!(pixels[4 * 1000 + 5] & 0x00ffffff, 0x00ffffff);
    window.set(Grid::<DIRECT>::COLOR, Color::WHITE).unwrap();
    window
}

#[derive(serde::Serialize)]
struct Wide {
    leaves: usize,
    inserted: bool,
}
impl View for Wide {
    fn view(&self) -> El<'_> {
        let leaves = self.leaves;
        let grid = column((0..leaves.div_ceil(COLUMNS)).map(move |row_index| {
            let columns = COLUMNS.min(leaves - row_index * COLUMNS);
            row((0..columns).map(|_| div().w(8).h(8).bg(Color::WHITE)))
                .h(10)
                .p(1)
                .gap(2)
                .justify(gpui::Justify::SpaceBetween)
        }))
        .align(gpui::Align::Stretch);
        if self.inserted {
            // A real visible structural change, not a renamed no-op. This is
            // a prepended control, not an anchored overlay/popover protocol.
            column((button("").name("inserted").size(1).bg(Color::BLACK), grid))
                .align(gpui::Align::Stretch)
        } else {
            column(grid).align(gpui::Align::Stretch)
        }
    }
}

fn wide(leaves: usize) -> Win<Wide> {
    Win::with_size(
        Wide {
            leaves,
            inserted: false,
        },
        1000,
        1000,
    )
    .unwrap()
}

fn geometry_signature(window: &mut Win<Wide>, width: u32) -> serde_json::Value {
    let (leaves, inserted) = window
        .with_model(|model| (model.leaves, model.inserted))
        .unwrap();
    let mut nodes = 0;
    window.visit(|_| nodes += 1).unwrap();
    assert_eq!(
        nodes,
        leaves + leaves.div_ceil(COLUMNS) + 2 + usize::from(inserted)
    );
    let source: serde_json::Value = serde_json::from_str(&window.source_json().unwrap()).unwrap();
    assert_eq!(
        source,
        serde_json::json!({"leaves": leaves, "inserted": inserted})
    );
    let (draws, samples) = window.with_scene(|scene, _| {
        let count = scene.draws().len();
        assert_eq!(count, leaves + usize::from(inserted));
        // The midpoint of a whole number of 100-column rows can be column
        // zero, which correctly does not move under SpaceBetween. Sample the
        // next admitted column in that case; do not weaken the movement gate.
        let midpoint = leaves / 2;
        let midpoint = if midpoint % COLUMNS == 0 && midpoint + 1 < leaves {
            midpoint + 1
        } else {
            midpoint
        };
        let indices = [0, midpoint, leaves - 1];
        let samples: Vec<_> = indices.into_iter().map(|index| {
            let draw = scene.draws().nth(index + usize::from(inserted)).unwrap();
            let local = draw.local_rect;
            assert_eq!([local.width, local.height], [8.0, 8.0]);
            let clipped = draw.sampled_rect_clip([width, 1000]).unwrap();
            if index == 0 {
                assert_eq!([clipped.x, clipped.y], [1.0, 1.0 + u8::from(inserted) as f32]);
            }
            serde_json::json!({
                "index": index,
                "local_bits": ([local.x, local.y, local.width, local.height].map(f32::to_bits)),
                "window_bits": ([clipped.x, clipped.y, clipped.width, clipped.height].map(f32::to_bits)),
            })
        }).collect();
        (count, samples)
    }).unwrap();
    serde_json::json!({"source": source, "nodes": nodes, "draws": draws, "width": width, "samples": samples, "scene_digest": window.scene_digest().unwrap()})
}

fn first_target<M: View + 'static>(window: &Win<M>) -> gpui::Target {
    let mut target = None;
    window
        .visit(|part| {
            if target.is_none() {
                target = Some(part.target());
            }
        })
        .unwrap();
    target.unwrap()
}
fn assert_foreign<M: View + 'static>(window: &Win<M>, foreign: &Win<Wide>) {
    assert!(matches!(
        foreign.bounds(first_target(window)),
        Err(gpui::Error::StaleTarget)
    ));
    assert!(matches!(
        window.bounds(first_target(foreign)),
        Err(gpui::Error::StaleTarget)
    ));
}

fn fast_batches(direct: bool, batch: usize, timed: bool) {
    assert!(batch > 0 && batch <= 4096);
    let mut window = grid::<true>();
    let foreign = wide(1);
    assert_foreign(&window, &foreign);
    let mut step = 0usize;
    for _ in 0..WARMUP * batch {
        if direct {
            window
                .set(
                    Grid::<true>::COLOR,
                    if step % 2 == 0 {
                        rgb(0xff0000)
                    } else {
                        Color::WHITE
                    },
                )
                .unwrap();
        } else {
            window.settle().unwrap();
        }
        step += 1;
    }
    window.reset_counters().unwrap();
    let mut samples = Vec::with_capacity(SAMPLES);
    let mut last = None;
    for _ in 0..SAMPLES {
        let start = timed.then(Instant::now);
        for _ in 0..batch {
            if direct {
                last = Some(
                    window
                        .set(
                            Grid::<true>::COLOR,
                            if step % 2 == 0 {
                                rgb(0xff0000)
                            } else {
                                Color::WHITE
                            },
                        )
                        .unwrap(),
                );
            } else {
                window.settle().unwrap();
            }
            black_box(window.counters());
            step += 1;
        }
        if let Some(start) = start {
            samples.push(start.elapsed().as_nanos() as u64);
        }
    }
    let counters = window.counters();
    assert_eq!(
        counters.source_operations,
        if direct { (SAMPLES * batch) as u64 } else { 0 }
    );
    assert_eq!(counters.source_reads, counters.source_operations);
    assert_eq!(counters.descriptions, 0);
    assert_eq!(counters.layout_runs, 0);
    assert_eq!(counters.paint_passes, 0);
    if let Some(commit) = last {
        assert!(commit.presentation_valid);
        assert_eq!(commit.source_epoch, commit.presentation_epoch);
    }
    assert_foreign(&window, &foreign);
    println!(
        "{}",
        serde_json::json!({"scenario": if direct { "batched-direct" } else { "batched-idle" }, "batch": batch, "warmup_batches": WARMUP, "sample_batches": SAMPLES, "batch_ns": samples, "counters": counters, "source_color_white": window.with_model(|model| *model.color == Color::WHITE).unwrap(), "scene_digest": window.scene_digest().unwrap(), "scope": "each operation is the real public call with automatic logical ACK; no coalescing; clock surrounds the complete batch"})
    );
}

fn topology_costs(mode: &str, leaves: usize, samples: usize, timed: bool) {
    assert!(leaves > 0 && leaves <= 10_000 && samples > 0);
    let mut elapsed = Vec::with_capacity(samples);
    let mut drop_elapsed = Vec::with_capacity(samples);
    let mut signatures = Vec::with_capacity(samples);
    if mode == "mount" {
        let mut foreign = None;
        for _ in 0..samples {
            let start = timed.then(Instant::now);
            let mut window = black_box(wide(leaves));
            if let Some(start) = start {
                elapsed.push(start.elapsed().as_nanos() as u64);
            }
            signatures.push(geometry_signature(&mut window, 1000));
            let foreign = foreign.get_or_insert_with(|| wide(1));
            assert_foreign(&window, foreign);
            let start = timed.then(Instant::now);
            drop(black_box(window));
            if let Some(start) = start {
                drop_elapsed.push(start.elapsed().as_nanos() as u64);
            }
        }
    } else {
        let mut window = wide(leaves);
        let foreign = wide(1);
        let mut previous_inserted = None;
        let mut previous_signature = geometry_signature(&mut window, 1000);
        window.reset_counters().unwrap();
        for sample in 0..samples {
            let width = if mode == "resize" && sample % 2 == 0 {
                1100
            } else {
                1000
            };
            let start = timed.then(Instant::now);
            let commit = if mode == "resize" {
                window.resize([width, 1000]).unwrap()
            } else {
                window
                    .update(|model| model.inserted = !model.inserted)
                    .unwrap()
            };
            black_box(commit);
            if let Some(start) = start {
                elapsed.push(start.elapsed().as_nanos() as u64);
            }
            assert!(commit.presentation_valid);
            assert_eq!(commit.source_epoch, commit.presentation_epoch);
            let signature = geometry_signature(&mut window, width);
            if mode == "resize" && leaves > 1 {
                assert_ne!(
                    signature["samples"][1]["window_bits"][0],
                    previous_signature["samples"][1]["window_bits"][0],
                    "actual viewport resize must move sampled flex geometry"
                );
            }
            let inserted = window.with_model(|model| model.inserted).unwrap();
            if inserted {
                previous_inserted = Some(window.query().name("inserted").one().unwrap());
            } else if let Some(removed) = previous_inserted.take() {
                assert!(matches!(
                    window.bounds(removed),
                    Err(gpui::Error::StaleTarget)
                ));
            }
            assert_foreign(&window, &foreign);
            previous_signature = signature.clone();
            signatures.push(signature);
        }
        println!(
            "{}",
            serde_json::json!({"scenario": mode, "leaves": leaves, "samples": samples, "ns": elapsed, "signatures": signatures, "counters": window.counters(), "scope": "full public owner update/resize plus automatic scene ACK; canonical checks outside the clock; no raster/GPU/OS"})
        );
        return;
    }
    println!(
        "{}",
        serde_json::json!({"scenario": "fresh-owner-mount", "leaves": leaves, "samples": samples, "ns": elapsed, "drop_ns": drop_elapsed, "signatures": signatures, "scope": "fresh owner first mount; first observation distinct from repeated fresh owners; drop measured separately after validation; not process/page-cache/native startup"})
    );
}

fn main() {
    let args: Vec<_> = std::env::args().collect();
    let mode = args.get(1).map_or("check", String::as_str);
    let size = args.get(2).map_or(1000, |value| value.parse().unwrap());
    if mode == "check" {
        fast_batches(false, 1, false);
        fast_batches(true, 16, false);
        topology_costs("mount", size, 1, false);
        topology_costs("rebuild", size, 4, false);
        topology_costs("resize", size, 4, false);
    } else if matches!(mode, "fast-idle" | "fast-direct") {
        fast_batches(mode == "fast-direct", size, true);
    } else {
        let samples = args.get(3).map_or(32, |value| value.parse().unwrap());
        assert!(matches!(mode, "mount" | "rebuild" | "resize"));
        topology_costs(mode, size, samples, true);
    }
}
