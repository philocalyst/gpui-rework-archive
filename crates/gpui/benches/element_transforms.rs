// Run with `cargo bench -p gpui-ce --bench element_transforms --features bench-support`.
// For an identical baseline scene workload, build the same file at the comparison
// revision with `RUSTFLAGS="--cfg gpui_scene_only"` and pass `--scenes-only`.
#![allow(unexpected_cfgs)]

#[cfg(not(gpui_scene_only))]
mod full {
    use gpui::{
        Bounds, ContentMask, CoordinateSpace, Quad, ScaledPixels, Scene, Size,
        TransformationMatrix, point, px,
    };
    use std::{hint::black_box, time::Instant};

    #[derive(Clone, Copy)]
    struct Rect {
        x: f32,
        y: f32,
        w: f32,
        h: f32,
    }
    impl Rect {
        fn contains(self, (x, y): (f32, f32)) -> bool {
            x >= self.x && x <= self.x + self.w && y >= self.y && y <= self.y + self.h
        }
    }
    #[derive(Clone, Copy)]
    struct Clip {
        local: Rect,
        to_window: TransformationMatrix,
        from_window: TransformationMatrix,
    }
    fn matrix(seed: usize, axis: bool) -> TransformationMatrix {
        let a = if axis {
            0.0
        } else {
            (seed * 73 % 997) as f32 * 0.0063
        };
        let (s, c) = a.sin_cos();
        let sx = 0.7 + (seed * 37 % 119) as f32 / 100.;
        let sy = 0.75 + (seed * 53 % 91) as f32 / 100.;
        TransformationMatrix {
            rotation_scale: [[c * sx, -s * sy], [s * sx, c * sy]],
            translation: [(seed % 100) as f32 * 31., (seed % 79) as f32 * 29.],
        }
    }
    fn apply(m: TransformationMatrix, p: (f32, f32)) -> (f32, f32) {
        let q = m.apply(point(px(p.0), px(p.1)));
        (f32::from(q.x), f32::from(q.y))
    }
    fn inv(m: TransformationMatrix) -> TransformationMatrix {
        m.inverse().expect("nonsingular benchmark matrix")
    }
    fn summarize(name: &str, ops: usize, mut ts: Vec<f64>) {
        ts.sort_by(f64::total_cmp);
        let n = ts.len();
        let med = ts[n / 2] / ops as f64;
        let lo = ts[n / 10] / ops as f64;
        let hi = ts[n * 9 / 10] / ops as f64;
        println!("{name:58} median={med:8.2} ns/op p10={lo:8.2} p90={hi:8.2} ops/run={ops}");
        println!(
            "  raw ns/op: {}",
            ts.iter()
                .map(|t| format!("{:.2}", t / ops as f64))
                .collect::<Vec<_>>()
                .join(",")
        );
    }
    fn measure<R>(name: &str, ops: usize, mut f: impl FnMut() -> R, samples: usize) {
        for _ in 0..5 {
            black_box(f());
        }
        let mut ts = Vec::with_capacity(samples);
        for _ in 0..samples {
            let t = Instant::now();
            black_box(f());
            ts.push(t.elapsed().as_nanos() as f64);
        }
        summarize(name, ops, ts);
    }
    fn measure_pair<A, B>(
        name: &str,
        ops: usize,
        mut a: impl FnMut() -> A,
        mut b: impl FnMut() -> B,
        samples: usize,
    ) {
        for i in 0..6 {
            if i % 2 == 0 {
                black_box(a());
                black_box(b());
            } else {
                black_box(b());
                black_box(a());
            }
        }
        let (mut at, mut bt) = (Vec::with_capacity(samples), Vec::with_capacity(samples));
        for i in 0..samples {
            let (first, second) = if i % 2 == 0 {
                (&mut at, &mut bt)
            } else {
                (&mut bt, &mut at)
            };
            let t = Instant::now();
            if i % 2 == 0 {
                black_box(a());
            } else {
                black_box(b());
            }
            first.push(t.elapsed().as_nanos() as f64);
            let t = Instant::now();
            if i % 2 == 0 {
                black_box(b());
            } else {
                black_box(a());
            }
            second.push(t.elapsed().as_nanos() as f64);
        }
        summarize(&format!("{name} variant=A"), ops, at);
        summarize(&format!("{name} variant=B"), ops, bt);
    }
    fn hitbench(nodes: usize, events: usize) {
        let rect = Rect {
            x: -20.,
            y: -12.,
            w: 40.,
            h: 24.,
        };
        let boxes = (0..nodes)
            .map(|i| {
                let mut m = matrix(i + 1, false);
                m.translation = [(i % 100) as f32 * 90., (i / 100) as f32 * 75.];
                (m, inv(m))
            })
            .collect::<Vec<_>>();
        let mut rng = 0x2732026u64;
        let trace = (0..events)
            .map(|e| {
                rng ^= rng << 13;
                rng ^= rng >> 7;
                rng ^= rng << 17;
                let id = (rng as usize) % nodes;
                let local = if e % 4 == 3 {
                    (-100_000., -100_000.)
                } else {
                    (0., 0.)
                };
                (id, apply(boxes[id].0, local), e % 4 != 3)
            })
            .collect::<Vec<_>>();
        let expected = trace
            .iter()
            .filter(|(_, _, hit)| *hit)
            .map(|(i, _, _)| i + 1)
            .sum::<usize>();
        let tests = nodes * events;
        let uncached = || {
            let mut sum = 0usize;
            for (_, p, _) in &trace {
                let p = black_box(*p);
                for (i, (m, _)) in boxes.iter().enumerate() {
                    if rect.contains(apply(inv(black_box(*m)), p)) {
                        sum += i + 1;
                    }
                }
            }
            black_box(sum)
        };
        let cached = || {
            let mut sum = 0usize;
            for (_, p, _) in &trace {
                let p = black_box(*p);
                for (i, (_, m)) in boxes.iter().enumerate() {
                    if rect.contains(apply(black_box(*m), p)) {
                        sum += i + 1;
                    }
                }
            }
            black_box(sum)
        };
        assert_eq!(uncached(), expected);
        assert_eq!(cached(), expected);
        measure_pair(
            &format!("hit scan n={nodes} e={events}"),
            tests,
            uncached,
            cached,
            30,
        );
    }
    fn clip_data(depth: usize, rotated: bool) -> Vec<Clip> {
        let mut world = TransformationMatrix::unit();
        let mut clips = Vec::with_capacity(depth);
        for i in 0..depth {
            let a = if rotated { (i + 1) as f32 * 0.01 } else { 0.0 };
            let (s, c) = a.sin_cos();
            let child = TransformationMatrix {
                rotation_scale: [[c * 1.005, -s * 0.995], [s * 1.005, c * 0.995]],
                translation: [1.25, 0.75],
            };
            world = world.compose(child);
            let radius = if i + 1 == depth { 100. } else { 10_000. };
            clips.push(Clip {
                local: Rect {
                    x: -radius,
                    y: -radius,
                    w: 2. * radius,
                    h: 2. * radius,
                },
                to_window: world,
                from_window: inv(world),
            });
        }
        clips
    }
    fn exact(clips: &[Clip], p: (f32, f32)) -> (bool, usize) {
        let mut n = 0;
        for c in clips {
            n += 1;
            if !c.local.contains(apply(inv(c.to_window), p)) {
                return (false, n);
            }
        }
        (true, n)
    }
    fn clipbench(depth: usize, rotated: bool, events: usize) {
        let clips = clip_data(depth, rotated);
        let inner = if depth == 0 {
            (10., 10.)
        } else {
            apply(clips[0].to_window, (0., 0.))
        };
        let outside = if depth == 0 {
            inner
        } else {
            apply(clips[0].to_window, (30_000., 30_000.))
        };
        let last_miss = if depth == 0 {
            inner
        } else {
            apply(clips[depth - 1].to_window, (500., 500.))
        };
        let mut traces = [Vec::new(), Vec::new(), Vec::new(), Vec::new()];
        for e in 0..events {
            traces[0].push(inner);
            traces[1].push(outside);
            traces[2].push(last_miss);
            traces[3].push(match e % 4 {
                0 => inner,
                1 => outside,
                2 => last_miss,
                _ => inner,
            });
        }
        for (case, t) in ["inside", "first-miss", "last-miss", "mixed"]
            .into_iter()
            .zip(traces.iter())
        {
            let (ref_hits, ref_visits) = t
                .iter()
                .map(|p| exact(&clips, *p))
                .fold((0usize, 0usize), |(h, v), (a, n)| (h + a as usize, v + n));
            let cached_hits = t
                .iter()
                .map(|p| {
                    clips
                        .iter()
                        .all(|c| c.local.contains(apply(c.from_window, *p)))
                        as usize
                })
                .sum::<usize>();
            assert_eq!(ref_hits, cached_hits, "clip answers depth={depth} {case}");
            let expected_visits = match case {
                "inside" => events * depth,
                "first-miss" => events * depth.min(1),
                "last-miss" => events * depth,
                "mixed" => {
                    if depth == 0 {
                        0
                    } else {
                        events / 4 * (3 * depth + 1)
                    }
                }
                _ => 0,
            };
            assert_eq!(
                ref_visits, expected_visits,
                "clip traversal depth={depth} {case}"
            );
            let expected_accept = if depth == 0 {
                events
            } else {
                match case {
                    "inside" => events,
                    "mixed" => events / 2,
                    _ => 0,
                }
            };
            assert_eq!(
                ref_hits, expected_accept,
                "clip acceptance depth={depth} {case}"
            );
            let op_count = events;
            let uncached = || {
                let mut h = 0;
                let mut v = 0;
                for p in t {
                    let (a, n) = exact(&clips, black_box(*p));
                    h += a as usize;
                    v += n;
                }
                black_box((h, v));
            };
            let cached = || {
                let mut h = 0;
                let mut v = 0;
                for p in t {
                    let p = black_box(*p);
                    let mut ok = true;
                    for c in &clips {
                        v += 1;
                        if !c.local.contains(apply(c.from_window, p)) {
                            ok = false;
                            break;
                        }
                    }
                    h += ok as usize;
                }
                black_box((h, v));
            };
            measure_pair(
                &format!("clip d={depth} rot={rotated} {case} visits={ref_visits}"),
                op_count.max(1),
                uncached,
                cached,
                30,
            );
        }
        if !rotated && depth > 0 {
            let (mut l, mut t, mut r, mut b) = (
                f32::NEG_INFINITY,
                f32::NEG_INFINITY,
                f32::INFINITY,
                f32::INFINITY,
            );
            for c in &clips {
                let a = apply(c.to_window, (c.local.x, c.local.y));
                let z = apply(c.to_window, (c.local.x + c.local.w, c.local.y + c.local.h));
                l = l.max(a.0);
                t = t.max(a.1);
                r = r.min(z.0);
                b = b.min(z.1);
            }
            let intersection = Rect {
                x: l,
                y: t,
                w: (r - l).max(0.),
                h: (b - t).max(0.),
            };
            for trace in &traces {
                let exact_hits = trace
                    .iter()
                    .map(|p| exact(&clips, *p).0 as usize)
                    .sum::<usize>();
                let aabb_hits = trace
                    .iter()
                    .map(|p| intersection.contains(*p) as usize)
                    .sum::<usize>();
                assert_eq!(
                    exact_hits, aabb_hits,
                    "axis-aligned clip shortcut semantics"
                );
            }
            let trace = &traces[3];
            measure(
                &format!("clip preintersected AABB d={depth} mixed"),
                events,
                || {
                    black_box(
                        trace
                            .iter()
                            .filter(|p| intersection.contains(black_box(**p)))
                            .count(),
                    );
                },
                30,
            );
        }
    }
    fn quad(i: usize) -> Quad {
        Quad {
            bounds: Bounds::new(
                point(
                    ScaledPixels((i % 100) as f32 * 46.),
                    ScaledPixels((i / 100) as f32 * 42.),
                ),
                Size::new(ScaledPixels(40.), ScaledPixels(36.)),
            ),
            content_mask: ContentMask {
                bounds: Bounds::new(
                    point(ScaledPixels(0.), ScaledPixels(0.)),
                    Size::new(ScaledPixels(100000.), ScaledPixels(100000.)),
                ),
                ..Default::default()
            },
            ..Quad::default()
        }
    }
    fn checksum(s: &Scene) -> u64 {
        s.quads.iter().fold(0, |v, q| {
            v.wrapping_add(q.order as u64)
                .wrapping_add(q.bounds.origin.x.0.to_bits() as u64)
                .wrapping_add(q.bounds.origin.y.0.to_bits() as u64)
        })
    }
    fn scenebench(n: usize, frames: usize) {
        let qs = (0..n).map(quad).collect::<Vec<_>>();
        let mut src = Scene::default();
        for q in &qs {
            src.insert_primitive(*q);
        }
        src.finish();
        assert_eq!(src.quads.len(), n);
        let source_len = src.len();
        let replay_expected = checksum(&src);
        measure(
            &format!("scene insert+finish n={n}"),
            n,
            || {
                let mut s = Scene::default();
                for q in &qs {
                    s.insert_primitive(*q);
                }
                s.finish();
                assert_eq!(s.quads.len(), n);
                black_box(checksum(&s));
            },
            30,
        );
        measure(
            &format!("scene replay+finish n={n} frames={frames}"),
            n * frames,
            || {
                let mut sum = 0u64;
                for _ in 0..frames {
                    let mut dst = Scene::default();
                    dst.replay(0..source_len, &src);
                    dst.finish();
                    assert_eq!(dst.quads.len(), n);
                    sum = sum.wrapping_add(checksum(&dst));
                }
                assert_eq!(sum, replay_expected.wrapping_mul(frames as u64));
                black_box(sum);
            },
            30,
        );
    }
    fn raster(frames: usize) {
        let mut rng = 0x2732026u64;
        for dpr in [1.0, 1.5, 2.0] {
            let mut traces = Vec::new();
            for _ in 0..4 {
                let mut zoom = 0.8f64;
                let mut v = Vec::with_capacity(frames);
                for _ in 0..frames {
                    rng ^= rng << 13;
                    rng ^= rng >> 7;
                    rng ^= rng << 17;
                    let step = ((rng % 2001) as f64 - 1000.) * 0.00008;
                    zoom = (zoom * (1. + step)).clamp(0.25, 4.);
                    v.push(zoom);
                }
                traces.push(v);
            }
            let mut keys = std::collections::HashSet::new();
            let mut oversampling = Vec::new();
            let mut transitions = 0usize;
            let mut previous: Option<u64> = None;
            for trace in &traces {
                for zoom in trace {
                    let scale = (zoom.max(1.) * 8.).ceil().clamp(8., 64.) / 8.;
                    let key = (scale * dpr).to_bits();
                    keys.insert(key);
                    oversampling.push(scale / zoom.max(1.) - 1.);
                    if previous != Some(key) {
                        transitions += 1;
                        previous = Some(key);
                    }
                }
            }
            oversampling.sort_by(f64::total_cmp);
            println!(
                "raster policy=ceil(max(zoom,1)*8)/8 capped at 8; dpr={dpr} samples={} unique_effective_scales={} transitions={} p95_oversample={:.3}% max_oversample={:.3}%",
                frames * 4,
                keys.len(),
                transitions,
                oversampling[oversampling.len() * 95 / 100] * 100.,
                oversampling.last().unwrap() * 100.
            );
        }
    }
    fn identity(ops: usize) {
        let pts = (0..ops)
            .map(|i| point(px(200.25 + (i % 17) as f32), px(300.5 - (i % 13) as f32)))
            .collect::<Vec<_>>();
        let space = CoordinateSpace::default();
        let direct = || {
            let mut s = 0.;
            for p in &pts {
                let p = black_box(*p);
                s += f32::from(p.x) + f32::from(p.y);
            }
            black_box(s)
        };
        let forward = || {
            let mut s = 0.;
            for p in &pts {
                let q = space.to_window(black_box(*p));
                s += f32::from(q.x) + f32::from(q.y);
            }
            black_box(s)
        };
        let backward = || {
            let mut s = 0.;
            for p in &pts {
                let q = space.from_window(black_box(*p)).unwrap();
                s += f32::from(q.x) + f32::from(q.y);
            }
            black_box(s)
        };
        assert_eq!(direct().to_bits(), forward().to_bits());
        assert_eq!(direct().to_bits(), backward().to_bits());
        measure_pair(
            "identity direct vs CoordinateSpace::to_window",
            ops,
            direct,
            forward,
            30,
        );
        measure_pair(
            "identity direct vs CoordinateSpace::from_window",
            ops,
            direct,
            backward,
            30,
        );
    }
    pub fn run() {
        let args = std::env::args().collect::<Vec<_>>();
        if args.iter().any(|arg| arg == "--scenes-only") {
            scenebench(100, 100);
            scenebench(10_000, 10);
            return;
        }
        println!(
            "Release mode, fixed seed=0x2732026; compiler/CPU/revision should accompany saved output; correctness assertions precede timed comparisons."
        );
        hitbench(100, 256);
        hitbench(10_000, 64);
        for d in [0, 1, 4, 16] {
            for rot in [false, true] {
                clipbench(d, rot, 10_000);
            }
        }
        scenebench(100, 100);
        scenebench(10_000, 10);
        raster(100_000);
        identity(50_000);
    }
}

#[cfg(gpui_scene_only)]
fn run_scene_only() {
    use gpui::{Bounds, ContentMask, Quad, ScaledPixels, Scene, Size, point};
    use std::{hint::black_box, time::Instant};
    fn quad(i: usize) -> Quad {
        Quad {
            bounds: Bounds::new(
                point(
                    ScaledPixels((i % 100) as f32 * 46.),
                    ScaledPixels((i / 100) as f32 * 42.),
                ),
                Size::new(ScaledPixels(40.), ScaledPixels(36.)),
            ),
            content_mask: ContentMask {
                bounds: Bounds::new(
                    point(ScaledPixels(0.), ScaledPixels(0.)),
                    Size::new(ScaledPixels(100000.), ScaledPixels(100000.)),
                ),
                ..Default::default()
            },
            ..Quad::default()
        }
    }
    fn checksum(s: &Scene) -> u64 {
        s.quads.iter().fold(0, |v, q| {
            v.wrapping_add(q.order as u64)
                .wrapping_add(q.bounds.origin.x.0.to_bits() as u64)
                .wrapping_add(q.bounds.origin.y.0.to_bits() as u64)
        })
    }
    fn summarize(name: &str, ops: usize, mut ts: Vec<f64>) {
        ts.sort_by(f64::total_cmp);
        let n = ts.len();
        println!(
            "{name:40} median={:.2} ns/op p10={:.2} p90={:.2} ops/run={ops}",
            ts[n / 2] / ops as f64,
            ts[n / 10] / ops as f64,
            ts[n * 9 / 10] / ops as f64
        );
    }
    fn measure(name: &str, ops: usize, mut f: impl FnMut(), samples: usize) {
        for _ in 0..5 {
            black_box(f());
        }
        let mut ts = Vec::with_capacity(samples);
        for _ in 0..samples {
            let t = Instant::now();
            black_box(f());
            ts.push(t.elapsed().as_nanos() as f64);
        }
        summarize(name, ops, ts);
    }
    fn scene(n: usize, frames: usize) {
        let qs = (0..n).map(quad).collect::<Vec<_>>();
        let mut src = Scene::default();
        for q in &qs {
            src.insert_primitive(*q);
        }
        src.finish();
        assert_eq!(src.quads.len(), n);
        let len = src.len();
        let expected = checksum(&src);
        measure(
            &format!("scene insert+finish n={n}"),
            n,
            || {
                let mut s = Scene::default();
                for q in &qs {
                    s.insert_primitive(*q);
                }
                s.finish();
                assert_eq!(s.quads.len(), n);
                black_box(checksum(&s));
            },
            30,
        );
        measure(
            &format!("scene replay+finish n={n} frames={frames}"),
            n * frames,
            || {
                let mut sum = 0u64;
                for _ in 0..frames {
                    let mut dst = Scene::default();
                    dst.replay(0..len, &src);
                    dst.finish();
                    assert_eq!(dst.quads.len(), n);
                    sum = sum.wrapping_add(checksum(&dst));
                }
                assert_eq!(sum, expected.wrapping_mul(frames as u64));
                black_box(sum);
            },
            30,
        );
    }
    println!(
        "Scene-only mode: fixed workloads, 30 samples, alternating process order recommended for comparison."
    );
    scene(100, 100);
    scene(10_000, 10);
}

fn main() {
    #[cfg(gpui_scene_only)]
    run_scene_only();
    #[cfg(not(gpui_scene_only))]
    full::run();
}
