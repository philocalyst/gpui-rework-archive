use gpui_reactivity_core::{Affine, Rect};
use gpui_scene_packet::{
    Builder, Capacity, Common, Glyph, Limits, Operation, Packet, Paint, ResourceKey,
};
use std::{hint::black_box, mem::size_of, sync::Arc, time::Instant};

enum Source {
    Rectangle,
    Glyph(Arc<[u8; 64]>),
}
// Exact f1dd1a1aad Command fields/order. B also measures the bounds-only change.
struct OldCommand<B> {
    rect: Rect,
    clip: Rect,
    inverse: [f64; 6],
    source: Source,
    color: [f32; 4],
    bounds: B,
}
struct Fixture {
    glyphs: usize,
    per_run: usize,
    unique_transform: bool,
    masks: Vec<Arc<[u8; 64]>>,
}
impl Fixture {
    fn runs(&self) -> usize {
        self.glyphs.div_ceil(self.per_run)
    }
    fn paint(&self, run: usize) -> Paint {
        Paint {
            transform: if self.unique_transform {
                Affine::translation((run % 1024) as f32 / 1024.0, (run / 1024) as f32 / 1024.0)
            } else {
                Affine::translation(0.25, 0.5)
            },
            clip: Rect::new(0.0, 0.0, 1024.0, 1024.0),
            color: [0.3, 0.2, 0.1, 0.5],
        }
    }
    fn glyph(&self, index: usize) -> Glyph {
        let column = if self.per_run == 1 {
            index % 64
        } else {
            index % self.per_run
        };
        let row = if self.per_run == 1 {
            index / 64 % 64
        } else {
            index / self.per_run % 64
        };
        Glyph {
            rect: Rect::new(
                10.0 + column as f32 * 9.0,
                10.0 + row as f32 * 14.0,
                7.0,
                11.0,
            ),
            resource: ResourceKey((index % self.masks.len()) as u128),
        }
    }
}

fn packet(f: &Fixture) -> Packet<Arc<[u8; 64]>> {
    let mut builder = Builder::new(1024, 1024, Limits::default()).unwrap();
    builder
        .reserve(Capacity {
            rectangles: 1,
            runs: f.runs(),
            glyphs: f.glyphs,
            resources: f.masks.len(),
        })
        .unwrap();
    for (index, mask) in f.masks.iter().enumerate() {
        builder
            .resource(ResourceKey(index as u128), mask.clone())
            .unwrap();
    }
    builder
        .rectangle(Rect::new(0.0, 0.0, 1024.0, 1024.0), f.paint(0))
        .unwrap();
    for run in 0..f.runs() {
        let first = run * f.per_run;
        builder
            .glyph_run(
                f.paint(run),
                (first..(first + f.per_run).min(f.glyphs)).map(|index| f.glyph(index)),
            )
            .unwrap();
    }
    builder.finish()
}

fn old(f: &Fixture) -> Vec<OldCommand<[usize; 4]>> {
    let mut output = Vec::with_capacity(f.glyphs + 1);
    let p = f.paint(0);
    let common = Common::prepare(p).unwrap();
    let rect = Rect::new(0.0, 0.0, 1024.0, 1024.0);
    output.push(OldCommand {
        rect,
        clip: p.clip,
        inverse: *common.inverse(),
        source: Source::Rectangle,
        color: p.color,
        bounds: reference_bounds(rect, p),
    });
    for index in 0..f.glyphs {
        let glyph = f.glyph(index);
        let p = f.paint(index / f.per_run);
        let common = Common::prepare(p).unwrap();
        output.push(OldCommand {
            rect: glyph.rect,
            clip: p.clip,
            inverse: *common.inverse(),
            source: Source::Glyph(f.masks[glyph.resource.0 as usize].clone()),
            color: p.color,
            bounds: reference_bounds(glyph.rect, p),
        });
    }
    output
}

// Source baseline's four-corner guard/clip arithmetic, kept independent from
// packet preparation so equality checks detect geometry/order regressions.
fn reference_bounds(r: Rect, p: Paint) -> [usize; 4] {
    let t = p.transform;
    let mut min = [f64::INFINITY; 2];
    let mut max = [f64::NEG_INFINITY; 2];
    for (x, y) in [
        (r.x as f64, r.y as f64),
        (r.x as f64 + r.width as f64, r.y as f64),
        (r.x as f64, r.y as f64 + r.height as f64),
        (r.x as f64 + r.width as f64, r.y as f64 + r.height as f64),
    ] {
        let wx = t.a as f64 * x + t.c as f64 * y + t.tx as f64;
        let wy = t.b as f64 * x + t.d as f64 * y + t.ty as f64;
        min[0] = min[0].min(wx);
        min[1] = min[1].min(wy);
        max[0] = max[0].max(wx);
        max[1] = max[1].max(wy);
    }
    [
        (min[0] - 1.0)
            .max(p.clip.x as f64)
            .max(0.0)
            .floor()
            .min(1024.0) as usize,
        (min[1] - 1.0)
            .max(p.clip.y as f64)
            .max(0.0)
            .floor()
            .min(1024.0) as usize,
        (max[0] + 1.0)
            .min(p.clip.x as f64 + p.clip.width as f64)
            .min(1024.0)
            .ceil()
            .max(0.0) as usize,
        (max[1] + 1.0)
            .min(p.clip.y as f64 + p.clip.height as f64)
            .min(1024.0)
            .ceil()
            .max(0.0) as usize,
    ]
}

fn mix(
    sum: u64,
    rect: Rect,
    inverse: &[f64; 6],
    clip: Rect,
    color: [f32; 4],
    bounds: [usize; 4],
    mask: u8,
) -> u64 {
    sum.rotate_left(3)
        ^ rect.x.to_bits() as u64
        ^ rect.y.to_bits() as u64
        ^ inverse[4].to_bits()
        ^ clip.width.to_bits() as u64
        ^ color[0].to_bits() as u64
        ^ bounds[0] as u64
        ^ mask as u64
}
fn scan_old(commands: &[OldCommand<[usize; 4]>]) -> u64 {
    commands.iter().fold(0, |sum, c| {
        mix(
            sum,
            c.rect,
            &c.inverse,
            c.clip,
            c.color,
            c.bounds,
            match &c.source {
                Source::Rectangle => 0,
                Source::Glyph(mask) => mask[0],
            },
        )
    })
}
fn scan_packet(packet: &Packet<Arc<[u8; 64]>>) -> u64 {
    let mut sum = 0;
    for op in packet.operations() {
        match op {
            Operation::Rectangle(c) => {
                sum = mix(
                    sum,
                    c.rect,
                    c.common.inverse(),
                    c.common.clip(),
                    c.common.color(),
                    c.bounds.0.map(usize::from),
                    0,
                )
            }
            Operation::Glyphs(run) => {
                for glyph in run.glyphs() {
                    sum = mix(
                        sum,
                        glyph.rect,
                        run.common.inverse(),
                        run.common.clip(),
                        run.common.color(),
                        glyph.bounds.0.map(usize::from),
                        glyph.resource[0],
                    );
                }
            }
        }
    }
    sum
}
fn ns(iterations: usize, mut f: impl FnMut()) -> f64 {
    let start = Instant::now();
    for _ in 0..iterations {
        f();
    }
    start.elapsed().as_nanos() as f64 / iterations as f64
}

fn main() {
    assert_eq!(size_of::<OldCommand<[usize; 4]>>(), 136);
    assert_eq!(size_of::<OldCommand<[u16; 4]>>(), 112);
    println!(
        "case,glyphs,runs,resources,old_resident,narrow_bounds_only,packet_resident,resource_body_bytes,old_arc_clones,packet_arc_clones,old_prepare_ns,packet_prepare_ns,old_scan_ns,packet_scan_ns,old_allocations,packet_allocations,old_prepare_peak,packet_prepare_peak"
    );
    for (name, count, per_run, unique, resources) in [
        ("48_labels", 480, 10, false, 64),
        ("1k", 1000, 10, false, 64),
        ("32k", 32000, 32, false, 64),
        ("unique_transforms", 32000, 1, true, 64),
        ("unique_everything", 32000, 1, true, 32000),
    ] {
        let mut masks = Vec::new();
        let resource_alloc = allocation_counter::measure(|| {
            masks = (0..resources).map(|n| Arc::new([n as u8; 64])).collect();
        });
        let resource_bytes =
            resource_alloc.bytes_current as usize - masks.capacity() * size_of::<Arc<[u8; 64]>>();
        let f = Fixture {
            glyphs: count,
            per_run,
            unique_transform: unique,
            masks,
        };
        let mut baseline = None;
        let baseline_alloc = allocation_counter::measure(|| baseline = Some(old(&f)));
        let baseline = baseline.unwrap();
        let mut grouped = None;
        let grouped_alloc = allocation_counter::measure(|| grouped = Some(packet(&f)));
        let grouped = grouped.unwrap();
        assert_eq!(scan_old(&baseline), scan_packet(&grouped));
        assert_eq!(
            grouped_alloc.bytes_current as usize + grouped.storage().object,
            grouped.storage().total()
        );
        // Exact oracle, not only a checksum: compare every retained operand.
        let mut cursor = 0;
        for op in grouped.operations() {
            match op {
                Operation::Rectangle(c) => {
                    let old = &baseline[cursor];
                    assert_eq!(c.rect, old.rect);
                    assert_eq!(c.bounds.0.map(usize::from), old.bounds);
                    cursor += 1;
                }
                Operation::Glyphs(run) => {
                    for glyph in run.glyphs() {
                        let old = &baseline[cursor];
                        assert_eq!(glyph.rect, old.rect);
                        assert_eq!(glyph.bounds.0.map(usize::from), old.bounds);
                        assert_eq!(run.common.inverse(), &old.inverse);
                        assert_eq!(run.common.clip(), old.clip);
                        assert_eq!(run.common.color(), old.color);
                        let Source::Glyph(mask) = &old.source else {
                            panic!()
                        };
                        assert!(Arc::ptr_eq(glyph.resource, mask));
                        cursor += 1;
                    }
                }
            }
        }
        assert_eq!(cursor, baseline.len());
        let iterations = if count < 2000 { 200 } else { 20 };
        let old_prepare = ns(iterations, || {
            black_box(old(black_box(&f)));
        });
        let packet_prepare = ns(iterations, || {
            black_box(packet(black_box(&f)));
        });
        let old_scan = ns(iterations * 10, || {
            black_box(scan_old(black_box(&baseline)));
        });
        let packet_scan = ns(iterations * 10, || {
            black_box(scan_packet(black_box(&grouped)));
        });
        println!(
            "{name},{count},{},{resources},{},{},{},{resource_bytes},{count},{resources},{old_prepare:.1},{packet_prepare:.1},{old_scan:.1},{packet_scan:.1},{},{},{},{}",
            f.runs(),
            size_of_val(&baseline) + baseline.capacity() * 136,
            size_of_val(&baseline) + baseline.capacity() * 112,
            grouped.storage().total(),
            baseline_alloc.count_total,
            grouped_alloc.count_total,
            baseline_alloc.bytes_max,
            grouped_alloc.bytes_max
        );
    }
}
