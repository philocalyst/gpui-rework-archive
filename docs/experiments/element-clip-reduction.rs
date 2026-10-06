use std::{hint::black_box, mem::size_of, time::Instant};

const EPS: f64 = 1e-10;
#[derive(Clone, Copy, Debug, Default, PartialEq)]
struct P {
    x: f64,
    y: f64,
}
impl P {
    fn dot(self, rhs: Self) -> f64 {
        self.x * rhs.x + self.y * rhs.y
    }
    fn cross(self, rhs: Self) -> f64 {
        self.x * rhs.y - self.y * rhs.x
    }
    fn add(self, rhs: Self) -> Self {
        Self {
            x: self.x + rhs.x,
            y: self.y + rhs.y,
        }
    }
    fn sub(self, rhs: Self) -> Self {
        Self {
            x: self.x - rhs.x,
            y: self.y - rhs.y,
        }
    }
    fn scale(self, s: f64) -> Self {
        Self {
            x: self.x * s,
            y: self.y * s,
        }
    }
    fn finite(self) -> bool {
        self.x.is_finite() && self.y.is_finite()
    }
}
#[derive(Clone, Copy, Debug)]
struct M {
    a: [[f64; 2]; 2],
    t: P,
}
impl M {
    fn apply(self, p: P) -> P {
        P {
            x: self.a[0][0] * p.x + self.a[0][1] * p.y + self.t.x,
            y: self.a[1][0] * p.x + self.a[1][1] * p.y + self.t.y,
        }
    }
    fn inv(self) -> Option<Self> {
        let [[a, b], [c, d]] = self.a;
        let det = a * d - b * c;
        if !det.is_finite()
            || det.abs() < 1e-14
            || !self.t.finite()
            || self.a.iter().flatten().any(|x| !x.is_finite())
        {
            return None;
        }
        let ia = [[d / det, -b / det], [-c / det, a / det]];
        let inv = Self {
            a: ia,
            t: P {
                x: -(ia[0][0] * self.t.x + ia[0][1] * self.t.y),
                y: -(ia[1][0] * self.t.x + ia[1][1] * self.t.y),
            },
        };
        (inv.t.finite() && inv.a.iter().flatten().all(|v| v.is_finite())).then_some(inv)
    }
    fn compose(self, b: Self) -> Self {
        let a = self.a;
        let c = b.a;
        let mat = [
            [
                a[0][0] * c[0][0] + a[0][1] * c[1][0],
                a[0][0] * c[0][1] + a[0][1] * c[1][1],
            ],
            [
                a[1][0] * c[0][0] + a[1][1] * c[1][0],
                a[1][0] * c[0][1] + a[1][1] * c[1][1],
            ],
        ];
        let t = self.apply(b.t);
        Self { a: mat, t }
    }
}
#[derive(Clone, Copy, Debug)]
struct Rect {
    x: f64,
    y: f64,
    w: f64,
    h: f64,
    fade: [f64; 4],
}
impl Rect {
    fn corners(self) -> Vec<P> {
        [
            P {
                x: self.x,
                y: self.y,
            },
            P {
                x: self.x + self.w,
                y: self.y,
            },
            P {
                x: self.x + self.w,
                y: self.y + self.h,
            },
            P {
                x: self.x,
                y: self.y + self.h,
            },
        ]
        .to_vec()
    }
    fn contains(self, p: P) -> bool {
        p.x >= self.x && p.x <= self.x + self.w && p.y >= self.y && p.y <= self.y + self.h
    }
    fn alpha(self, p: P) -> f64 {
        if !self.contains(p) {
            return 0.0;
        }
        let mut a = 1.0;
        for (ix, f) in self.fade.iter().enumerate() {
            if *f > 0.0 {
                let d = match ix {
                    0 => p.x - self.x,
                    1 => self.x + self.w - p.x,
                    2 => p.y - self.y,
                    _ => self.y + self.h - p.y,
                };
                a *= (d / f).clamp(0.0, 1.0);
            }
        }
        a
    }
}
#[derive(Clone, Debug)]
struct Clip {
    rect: Rect,
    to_world: M,
    from_world: Option<M>,
}
impl Clip {
    fn polygon(&self) -> Option<Vec<P>> {
        self.from_world?;
        let mut p = self
            .rect
            .corners()
            .into_iter()
            .map(|v| self.to_world.apply(v))
            .collect::<Vec<_>>();
        if p.iter().any(|v| !v.finite()) {
            return None;
        }
        if area(&p) < 0.0 {
            p.reverse();
        }
        Some(p)
    }
}
#[derive(Clone, Debug)]
struct Compiled {
    boundary: Vec<P>,
    fades: Vec<Clip>,
    fallback: Option<Vec<Clip>>,
}
fn area(p: &[P]) -> f64 {
    if p.len() < 3 {
        return 0.0;
    }
    (0..p.len())
        .map(|i| p[i].cross(p[(i + 1) % p.len()]))
        .sum::<f64>()
        * 0.5
}
fn signed_edge(a: P, b: P, p: P) -> f64 {
    b.sub(a).cross(p.sub(a))
}
fn intersect_segment(a: P, b: P, da: f64, db: f64) -> P {
    let den = da - db;
    if den.abs() < 1e-30 {
        a
    } else {
        a.add(b.sub(a).scale(da / den))
    }
}
fn clip_polygon(subject: &[P], boundary: &[P]) -> Vec<P> {
    let mut out = subject.to_vec();
    for i in 0..boundary.len() {
        if out.is_empty() {
            break;
        }
        let a = boundary[i];
        let b = boundary[(i + 1) % boundary.len()];
        let input = std::mem::take(&mut out);
        let mut s = *input.last().unwrap();
        let mut ds = signed_edge(a, b, s);
        let mut sin = ds >= -EPS;
        for e in input {
            let de = signed_edge(a, b, e);
            let ein = de >= -EPS;
            if ein != sin {
                out.push(intersect_segment(s, e, ds, de));
            }
            if ein {
                out.push(e);
            }
            s = e;
            ds = de;
            sin = ein;
        }
    }
    deduplicate(out)
}
fn deduplicate(mut p: Vec<P>) -> Vec<P> {
    let mut q = Vec::new();
    for v in p.drain(..) {
        if q.last()
            .is_none_or(|u: &P| (u.x - v.x).abs() > 1e-8 || (u.y - v.y).abs() > 1e-8)
        {
            q.push(v);
        }
    }
    if q.len() > 1 {
        let a = q[0];
        let b = *q.last().unwrap();
        if (a.x - b.x).abs() < 1e-8 && (a.y - b.y).abs() < 1e-8 {
            q.pop();
        }
    }
    let mut changed = true;
    while changed && q.len() >= 3 {
        changed = false;
        let mut r = Vec::with_capacity(q.len());
        for i in 0..q.len() {
            let a = q[(i + q.len() - 1) % q.len()];
            let b = q[i];
            let c = q[(i + 1) % q.len()];
            let cross = b.sub(a).cross(c.sub(b));
            let scale = (b.sub(a).dot(b.sub(a)) * c.sub(b).dot(c.sub(b)))
                .sqrt()
                .max(1.0);
            if cross.abs() <= 1e-9 * scale {
                changed = true;
            } else {
                r.push(b);
            }
        }
        if r.is_empty() {
            return vec![];
        }
        q = r;
    }
    q
}
fn compile(clips: &[Clip]) -> Compiled {
    if clips.is_empty() {
        return Compiled {
            boundary: vec![],
            fades: vec![],
            fallback: None,
        };
    }
    let Some(mut polygon) = clips[0].polygon() else {
        return Compiled {
            boundary: vec![],
            fades: vec![],
            fallback: None,
        };
    };
    for c in &clips[1..] {
        let Some(cp) = c.polygon() else {
            return Compiled {
                boundary: vec![],
                fades: vec![],
                fallback: None,
            };
        };
        polygon = clip_polygon(&polygon, &cp);
    }
    if polygon.len() < 3 {
        let fallback = (!polygon.is_empty()).then(|| clips.to_vec());
        return Compiled {
            boundary: vec![],
            fades: clips
                .iter()
                .filter(|c| c.rect.fade.iter().any(|f| *f > 0.0))
                .cloned()
                .collect(),
            fallback,
        };
    }
    if area(&polygon).abs() < 1e-12 || polygon.iter().any(|p| !p.finite()) {
        return Compiled {
            boundary: vec![],
            fades: clips
                .iter()
                .filter(|c| c.rect.fade.iter().any(|f| *f > 0.0))
                .cloned()
                .collect(),
            fallback: Some(clips.to_vec()),
        };
    }
    Compiled {
        boundary: polygon,
        fades: clips
            .iter()
            .filter(|c| c.rect.fade.iter().any(|f| *f > 0.0))
            .cloned()
            .collect(),
        fallback: None,
    }
}
fn chain_contains(clips: &[Clip], p: P) -> (bool, usize) {
    let mut n = 0;
    for c in clips {
        n += 1;
        let Some(inv) = c.from_world else {
            return (false, n);
        };
        if !c.rect.contains(inv.apply(p)) {
            return (false, n);
        }
    }
    (true, n)
}
fn poly_contains(poly: &[P], p: P) -> bool {
    poly.len() >= 3
        && (0..poly.len()).all(|i| signed_edge(poly[i], poly[(i + 1) % poly.len()], p) >= -EPS)
}
fn compiled_contains(c: &Compiled, p: P) -> bool {
    c.fallback.as_ref().map_or_else(
        || poly_contains(&c.boundary, p),
        |clips| chain_contains(clips, p).0,
    )
}
#[derive(Clone, Copy)]
struct Plane {
    nx: f64,
    ny: f64,
    offset: f64,
}
fn compile_planes(clips: &[Clip]) -> Option<Vec<Vec<Plane>>> {
    clips
        .iter()
        .map(|c| {
            let Some(edges) = c.polygon() else {
                return Some(vec![]);
            };
            let planes = (0..edges.len())
                .map(|i| {
                    let a = edges[i];
                    let b = edges[(i + 1) % edges.len()];
                    let edge = b.sub(a);
                    let length = edge.dot(edge).sqrt();
                    (length > 1e-20).then_some(Plane {
                        nx: -edge.y / length,
                        ny: edge.x / length,
                        offset: (edge.y * a.x - edge.x * a.y) / length,
                    })
                })
                .collect::<Option<Vec<_>>>();
            Some(planes.unwrap_or_default())
        })
        .collect()
}
fn plane_contains(planes: &[Vec<Plane>], p: P) -> (bool, usize) {
    let mut n = 0;
    for edges in planes {
        if edges.is_empty() {
            return (false, n);
        }
        for plane in edges {
            n += 1;
            if plane.nx * p.x + plane.ny * p.y + plane.offset < -EPS {
                return (false, n);
            }
        }
    }
    (true, n)
}
fn alpha_chain(clips: &[Clip], p: P) -> f64 {
    let mut a = 1.0;
    for c in clips {
        let Some(inv) = c.from_world else { return 0.0 };
        a *= c.rect.alpha(inv.apply(p));
        if a == 0.0 {
            return 0.0;
        }
    }
    a
}
fn alpha_compiled(c: &Compiled, p: P) -> f64 {
    if !compiled_contains(c, p) {
        return 0.0;
    }
    c.fades
        .iter()
        .fold(1.0, |a, f| a * f.rect.alpha(f.from_world.unwrap().apply(p)))
}
fn rect(r: f64, s: f64, fade: f64) -> Rect {
    Rect {
        x: -r,
        y: -s,
        w: 2.0 * r,
        h: 2.0 * s,
        fade: [fade; 4],
    }
}
fn mk_clip(m: M, r: Rect) -> Clip {
    Clip {
        rect: r,
        to_world: m,
        from_world: m.inv(),
    }
}
fn rotate(a: f64) -> M {
    M {
        a: [[a.cos(), -a.sin()], [a.sin(), a.cos()]],
        t: P::default(),
    }
}
fn scale(x: f64, y: f64) -> M {
    M {
        a: [[x, 0.0], [0.0, y]],
        t: P::default(),
    }
}
fn translate(x: f64, y: f64) -> M {
    M {
        a: [[1.0, 0.0], [0.0, 1.0]],
        t: P { x, y },
    }
}
fn chain(kind: &str, n: usize) -> Vec<Clip> {
    let mut out = Vec::new();
    let mut world = M {
        a: [[1.0, 0.0], [0.0, 1.0]],
        t: P::default(),
    };
    for i in 0..n {
        let i = i as f64;
        let (child, r) = match kind {
            "identical" => (
                M {
                    a: [[1.0, 0.0], [0.0, 1.0]],
                    t: P::default(),
                },
                rect(100.0, 60.0, 0.0),
            ),
            "contained" => (
                translate(i * 0.1, -i * 0.1).compose(rotate(i * 0.001)),
                rect(200.0 - i * 1.5, 120.0 - i * 0.8, 0.0),
            ),
            "nested_fade_safe" => (scale(0.7, 0.72), rect(100.0, 70.0, 10.0)),
            "fade_active" => (
                translate(0.5, 0.0).compose(rotate(i * 0.002)),
                rect(100.0, 70.0, 10.0),
            ),
            "adversarial" => {
                let a = ((i * 73.0 + 19.0) % 359.0) * std::f64::consts::PI / 180.0;
                let sx = 0.82 + (i * 17.0 % 30.0) / 100.0;
                let sy = 0.75 + (i * 11.0 % 40.0) / 100.0;
                (
                    translate((i * 13.0 % 21.0) - 10.0, (i * 9.0 % 17.0) - 8.0)
                        .compose(rotate(a))
                        .compose(scale(sx, sy)),
                    rect(115.0 + (i * 13.0 % 75.0), 65.0 + (i * 19.0 % 45.0), 0.0),
                )
            }
            "shear_reflect" => {
                let shear = if i as usize % 2 == 0 { 0.45 } else { -0.31 };
                let sx = if i as usize % 3 == 0 { -1.0 } else { 1.0 };
                (
                    translate((i * 3.0 % 19.0) - 9.0, (i * 7.0 % 13.0) - 6.0)
                        .compose(M {
                            a: [[sx, shear], [0.22, 1.0]],
                            t: P::default(),
                        })
                        .compose(rotate(i * 0.07)),
                    rect(120.0, 72.0, 0.0),
                )
            }
            "fade" => {
                let a = i * 0.13;
                (
                    translate((i * 5.0 % 15.0) - 7.0, 0.0).compose(rotate(a)),
                    rect(110.0, 74.0, 12.0),
                )
            }
            _ => unreachable!(),
        };
        world = world.compose(child);
        out.push(mk_clip(world, r));
    }
    out
}
fn full_coverage_contains(ancestor: &Clip, child: &Clip) -> bool {
    let Some(ancestor_inverse) = ancestor.from_world else {
        return false;
    };
    let inset = Rect {
        x: ancestor.rect.x + ancestor.rect.fade[0],
        y: ancestor.rect.y + ancestor.rect.fade[2],
        w: ancestor.rect.w - ancestor.rect.fade[0] - ancestor.rect.fade[1],
        h: ancestor.rect.h - ancestor.rect.fade[2] - ancestor.rect.fade[3],
        fade: [0.0; 4],
    };
    if inset.w < 0.0 || inset.h < 0.0 {
        return false;
    }
    child.rect.corners().into_iter().all(|corner| {
        let world = child.to_world.apply(corner);
        let in_ancestor = ancestor_inverse.apply(world);
        in_ancestor.finite()
            && in_ancestor.x >= inset.x
            && in_ancestor.x <= inset.x + inset.w
            && in_ancestor.y >= inset.y
            && in_ancestor.y <= inset.y + inset.h
    })
}
fn prune_dominated(clips: &[Clip]) -> Vec<Clip> {
    let mut retained = Vec::<Clip>::new();
    for child in clips {
        if child.from_world.is_none() {
            return vec![child.clone()];
        }
        retained.retain(|ancestor| !full_coverage_contains(ancestor, child));
        retained.push(child.clone());
    }
    retained
}
fn prune_prefix(clips: &[Clip]) -> Vec<Clip> {
    let mut retained = Vec::<Clip>::new();
    for child in clips {
        if child.from_world.is_none() {
            return vec![child.clone()];
        }
        while retained
            .last()
            .is_some_and(|ancestor| full_coverage_contains(ancestor, child))
        {
            retained.pop();
        }
        retained.push(child.clone());
    }
    retained
}
fn rng(s: &mut u64) -> u64 {
    *s ^= *s << 13;
    *s ^= *s >> 7;
    *s ^= *s << 17;
    *s
}
fn unit(s: &mut u64) -> f64 {
    (rng(s) >> 11) as f64 / ((1u64 << 53) as f64)
}
fn fuzz_dominance() -> (usize, usize) {
    let mut seed = 0x9e3779b97f4a7c15;
    let (mut clips_checked, mut points_checked) = (0, 0);
    for _ in 0..400 {
        let depth = 1 + (rng(&mut seed) as usize % 16);
        let mut world = M {
            a: [[1.0, 0.0], [0.0, 1.0]],
            t: P::default(),
        };
        let mut clips = Vec::with_capacity(depth);
        for _ in 0..depth {
            let angle = (unit(&mut seed) - 0.5) * 1.2;
            let sx = 0.45 + unit(&mut seed) * 0.8;
            let sy = 0.45 + unit(&mut seed) * 0.8;
            let reflect = if rng(&mut seed) & 1 == 0 { 1.0 } else { -1.0 };
            let shear = (unit(&mut seed) - 0.5) * 0.5;
            let local = translate((unit(&mut seed) - 0.5) * 5.0, (unit(&mut seed) - 0.5) * 5.0)
                .compose(rotate(angle))
                .compose(M {
                    a: [[reflect * sx, shear], [0.2, sy]],
                    t: P::default(),
                });
            world = world.compose(local);
            let w = 30.0 + unit(&mut seed) * 150.0;
            let h = 20.0 + unit(&mut seed) * 100.0;
            let fade = if rng(&mut seed) % 3 == 0 {
                unit(&mut seed) * 8.0
            } else {
                0.0
            };
            clips.push(mk_clip(
                world,
                Rect {
                    x: -w / 2.0,
                    y: -h / 2.0,
                    w,
                    h,
                    fade: [fade; 4],
                },
            ));
        }
        let pruned = prune_dominated(&clips);
        let prefix = prune_prefix(&clips);
        for _ in 0..1280 {
            let p = P {
                x: (unit(&mut seed) - 0.5) * 400.0,
                y: (unit(&mut seed) - 0.5) * 300.0,
            };
            let original = alpha_chain(&clips, p);
            let reduced = alpha_chain(&pruned, p);
            let prefix_alpha = alpha_chain(&prefix, p);
            assert!(
                (original - reduced).abs() < 2e-8,
                "dominance proof mismatch: depth={depth}, retained={}, p={p:?}, alpha={original} reduced={reduced}",
                pruned.len()
            );
            assert!(
                (original - prefix_alpha).abs() < 2e-8,
                "prefix dominance proof mismatch: depth={depth}, retained={}, p={p:?}, alpha={original} reduced={prefix_alpha}",
                prefix.len()
            );
            points_checked += 1;
        }
        clips_checked += 1;
    }
    (clips_checked, points_checked)
}
fn samples(clips: &[Clip], n: usize, kind: &str) -> Vec<P> {
    let mut s = 0x2732026u64;
    let mut v = Vec::with_capacity(n);
    for i in 0..n {
        let r = rng(&mut s);
        let p = match kind {
            "inside" => P { x: 0.0, y: 0.0 },
            "early_miss" => {
                let c = &clips[0];
                c.to_world.apply(P {
                    x: c.rect.x + c.rect.w + 3.0,
                    y: 0.0,
                })
            }
            "late_miss" => {
                let c = clips.last().unwrap();
                c.to_world.apply(P {
                    x: c.rect.x + c.rect.w + 3.0,
                    y: 0.0,
                })
            }
            _ => P {
                x: ((r & 0xffff) as f64 / 65535.0 - 0.5) * 500.0,
                y: (((r >> 16) & 0xffff) as f64 / 65535.0 - 0.5) * 400.0,
            },
        };
        if i % 4 == 0 && kind == "mixed" {
            v.push(P { x: 0.0, y: 0.0 })
        } else {
            v.push(p)
        }
    }
    v
}
fn stats(label: &str, mut times: Vec<f64>, ops: usize) {
    times.sort_by(f64::total_cmp);
    let n = times.len();
    println!(
        "{label:52} median={:.2} ns/op p10={:.2} p90={:.2}",
        times[n / 2] / ops as f64,
        times[n / 10] / ops as f64,
        times[n * 9 / 10] / ops as f64
    );
}
fn measure(label: &str, ops: usize, mut f: impl FnMut(), samples: usize) {
    for _ in 0..5 {
        black_box(f());
    }
    let mut t = Vec::new();
    for _ in 0..samples {
        let a = Instant::now();
        black_box(f());
        t.push(a.elapsed().as_nanos() as f64);
    }
    stats(label, t, ops);
}
fn raster_scale_f32([[a, b], [c, d]]: [[f32; 2]; 2]) -> f32 {
    let sum = a * a + b * b + c * c + d * d;
    let determinant = a * d - b * c;
    ((sum
        + (sum * sum - 4.0 * determinant * determinant)
            .max(0.0)
            .sqrt())
        * 0.5)
        .sqrt()
        .max(1.0)
        .mul_add(8.0, 0.0)
        .ceil()
        .clamp(8.0, 64.0)
        / 8.0
}
fn benchmark_shared_camera_raster_scale() {
    // Mirrors TransformationMatrix::max_scale and CoordinateSpace's eighth-step
    // bucket. This measures the repeated arithmetic only, not glyph shaping,
    // cache lookup, or frame rendering.
    let camera = [[1.37_f32, 0.34_f32], [-0.21_f32, 1.37_f32]];
    let cached = raster_scale_f32(camera);
    for glyph_count in [512, 10_000, 100_000] {
        for _ in 0..glyph_count {
            assert_eq!(raster_scale_f32(black_box(camera)), cached);
        }
        measure(
            &format!("shared-camera raster density recomputed glyphs={glyph_count}"),
            glyph_count,
            || {
                let mut sum = 0.0;
                for _ in 0..glyph_count {
                    sum += raster_scale_f32(black_box(camera));
                }
                black_box(sum);
            },
            30,
        );
        measure(
            &format!("shared-camera cached density reads glyphs={glyph_count}"),
            glyph_count,
            || {
                let mut sum = 0.0;
                for _ in 0..glyph_count {
                    sum += black_box(cached);
                }
                black_box(sum);
            },
            30,
        );
    }
}
fn main() {
    println!(
        "clip-compile prototype: f64 reference geometry; epsilon-tested polygon clipping; fixed seed; correctness before timing"
    );
    benchmark_shared_camera_raster_scale();
    let (fuzz_chains, fuzz_points) = fuzz_dominance();
    println!(
        "dominance differential fuzz: {fuzz_chains} affine/fade chains, {fuzz_points} points, original and pruned alpha agree"
    );
    for kind in [
        "identical",
        "contained",
        "adversarial",
        "shear_reflect",
        "nested_fade_safe",
        "fade_active",
    ] {
        for depth in [1, 4, 16, 64] {
            let clips = chain(kind, depth);
            let compiled = compile(&clips);
            let planes = compile_planes(&clips).expect("finite non-degenerate test clips");
            let pruned = prune_dominated(&clips);
            let prefix = prune_prefix(&clips);
            let trace = samples(&clips, 8192, "mixed");
            let mut chain_hits = 0;
            let mut poly_hits = 0;
            let mut plane_hits = 0;
            let mut chain_visits = 0;
            let mut plane_visits = 0;
            for p in &trace {
                let (c, cv) = chain_contains(&clips, *p);
                let (q, qv) = plane_contains(&planes, *p);
                let z = compiled_contains(&compiled, *p);
                assert_eq!(c, q, "reference methods disagree kind={kind} depth={depth}");
                assert_eq!(
                    c,
                    z,
                    "compiled polygon disagrees kind={kind} depth={depth} point={p:?} vertices={} area={}",
                    compiled.boundary.len(),
                    area(&compiled.boundary)
                );
                chain_hits += c as usize;
                poly_hits += z as usize;
                plane_hits += q as usize;
                chain_visits += cv;
                plane_visits += qv;
            }
            for p in &trace {
                assert_eq!(
                    chain_contains(&clips, *p).0,
                    chain_contains(&pruned, *p).0,
                    "pruned hard constraints mismatch kind={kind} depth={depth}"
                );
                assert!(
                    (alpha_chain(&clips, *p) - alpha_chain(&pruned, *p)).abs() < 1e-8,
                    "pruned fade product mismatch kind={kind} depth={depth}"
                );
                assert!(
                    (alpha_chain(&clips, *p) - alpha_chain(&prefix, *p)).abs() < 1e-8,
                    "prefix-pruned fade product mismatch kind={kind} depth={depth}"
                );
            }
            assert_eq!(chain_hits, poly_hits);
            assert_eq!(chain_hits, plane_hits);
            println!(
                "case={kind:16} depth={depth:2} vertices={:3} retained_clips={:2} prefix_clips={:2} chain_bytes~={} pruned_bytes~={} polygon_bytes={} hit_count={}",
                compiled.boundary.len(),
                pruned.len(),
                prefix.len(),
                depth * size_of::<Clip>(),
                pruned.len() * size_of::<Clip>(),
                compiled.boundary.capacity() * size_of::<P>(),
                chain_hits
            );
            measure(
                &format!(
                    "{kind} d={depth} exact chain mixed hits={chain_hits} visits={chain_visits}"
                ),
                trace.len(),
                || {
                    let mut h = 0;
                    let mut v = 0;
                    for p in &trace {
                        let (a, n) = chain_contains(&clips, black_box(*p));
                        h += a as usize;
                        v += n;
                    }
                    black_box((h, v));
                },
                30,
            );
            measure(
                &format!("{kind} d={depth} pruned chain clips={}", pruned.len()),
                trace.len(),
                || {
                    let mut h = 0;
                    let mut v = 0;
                    for p in &trace {
                        let (a, n) = chain_contains(&pruned, black_box(*p));
                        h += a as usize;
                        v += n;
                    }
                    black_box((h, v));
                },
                30,
            );
            measure(
                &format!("{kind} d={depth} prefix chain clips={}", prefix.len()),
                trace.len(),
                || {
                    let mut h = 0;
                    let mut v = 0;
                    for p in &trace {
                        let (a, n) = chain_contains(&prefix, black_box(*p));
                        h += a as usize;
                        v += n;
                    }
                    black_box((h, v));
                },
                30,
            );
            measure(
                &format!(
                    "{kind} d={depth} compiled polygon mixed vertices={}",
                    compiled.boundary.len()
                ),
                trace.len(),
                || {
                    let mut h = 0;
                    for p in &trace {
                        h += compiled_contains(&compiled, black_box(*p)) as usize;
                    }
                    black_box(h);
                },
                30,
            );
            measure(
                &format!("{kind} d={depth} unpruned plane scan visits={plane_visits}"),
                trace.len(),
                || {
                    let mut h = 0;
                    let mut v = 0;
                    for p in &trace {
                        let (a, n) = plane_contains(&planes, black_box(*p));
                        h += a as usize;
                        v += n;
                    }
                    black_box((h, v));
                },
                30,
            );
            measure(
                &format!("{kind} d={depth} compile build"),
                1,
                || {
                    black_box(compile(black_box(&clips)));
                },
                500,
            );
            measure(
                &format!("{kind} d={depth} dominance prune build"),
                1,
                || {
                    black_box(prune_dominated(black_box(&clips)));
                },
                500,
            );
            measure(
                &format!("{kind} d={depth} prefix prune build"),
                1,
                || {
                    black_box(prune_prefix(black_box(&clips)));
                },
                500,
            );
        }
    }
    // Exact alpha must preserve every independent edge ramp even after hard-edge reduction.
    for depth in [1, 4, 16] {
        let clips = chain("fade", depth);
        let compiled = compile(&clips);
        let mut s = 0x2732026;
        let mut worst: f64 = 0.0;
        for _ in 0..100_000 {
            let r = rng(&mut s);
            let p = P {
                x: ((r & 0xffff) as f64 / 65535.0 - 0.5) * 240.0,
                y: (((r >> 16) & 0xffff) as f64 / 65535.0 - 0.5) * 160.0,
            };
            let a = alpha_chain(&clips, p);
            let b = alpha_compiled(&compiled, p);
            worst = worst.max((a - b).abs());
            assert!((a - b).abs() < 1e-8, "fade alpha mismatch {a} != {b}");
        }
        let hard_only = Compiled {
            boundary: compiled.boundary.clone(),
            fades: vec![],
            fallback: compiled.fallback.clone(),
        };
        let mismatches = (0..100_000)
            .map(|i| {
                let x = (i % 1000) as f64 / 999.0 * 240.0 - 120.0;
                let y = (i / 1000) as f64 / 99.0 * 160.0 - 80.0;
                let p = P { x, y };
                (alpha_chain(&clips, p) - alpha_compiled(&hard_only, p)).abs() > 1e-4
            })
            .filter(|b| *b)
            .count();
        println!(
            "fade case depth={depth} hard_edges={} retained_fade_terms={} max_exact_alpha_error={worst:.3e} hard_boundary_only_alpha_mismatches={mismatches}/100000",
            compiled.boundary.len(),
            compiled.fades.len()
        );
    }
    // Invalid affine transforms collapse the clip space. The compiler must reject them.
    for m in [
        M {
            a: [[0.0, 0.0], [0.0, 1.0]],
            t: P::default(),
        },
        M {
            a: [[f64::NAN, 0.0], [0.0, 1.0]],
            t: P::default(),
        },
        M {
            a: [[f64::INFINITY, 0.0], [0.0, 1.0]],
            t: P::default(),
        },
    ] {
        let c = mk_clip(m, rect(10.0, 10.0, 0.0));
        let poly = compile(&[c.clone()]);
        for p in [
            P::default(),
            P {
                x: 100.0,
                y: -100.0,
            },
        ] {
            assert!(!chain_contains(&[c.clone()], p).0);
            assert!(!compiled_contains(&poly, p));
        }
        println!(
            "invalid transform {:?}: vertices={}",
            m,
            poly.boundary.len()
        );
    }
    // Zero-area local rectangles remain closed sets in the reference; report separately.
    let line = mk_clip(
        M {
            a: [[1.0, 0.0], [0.0, 1.0]],
            t: P::default(),
        },
        Rect {
            x: 0.0,
            y: -2.0,
            w: 0.0,
            h: 4.0,
            fade: [0.0; 4],
        },
    );
    let p = compile(&[line.clone()]);
    for point in [P { x: 0.0, y: 0.0 }, P { x: 1e-4, y: 0.0 }] {
        assert_eq!(
            chain_contains(&[line.clone()], point).0,
            compiled_contains(&p, point)
        );
    }
    println!(
        "zero-width rectangle reference boundary matches polygon compiler (vertices={})",
        p.boundary.len()
    );
}
