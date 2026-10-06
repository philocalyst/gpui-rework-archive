use std::{
    hint::black_box,
    sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    },
    time::Instant,
};

#[derive(Clone, Debug, PartialEq)]
struct Clip {
    mask: [f32; 4],
    transform: [[f32; 2]; 2],
    inverse: [[f32; 2]; 2],
    window_bounds: [f32; 4],
    parent: Option<Arc<Clip>>,
}
#[derive(Clone, Debug, PartialEq)]
struct Space {
    transform: [[f32; 2]; 2],
    inverse: Option<[[f32; 2]; 2]>,
    raster_scale: f32,
    clips: Option<Arc<Clip>>,
}

fn chain(depth: usize) -> Arc<Clip> {
    let mut parent = None;
    for i in 0..depth {
        let f = i as f32 + 1.0;
        parent = Some(Arc::new(Clip {
            mask: [f, f + 1.0, f + 2.0, f + 3.0],
            transform: [[1.0 + f / 1000.0, 0.25], [-0.125, 1.0 + f / 2000.0]],
            inverse: [[1.0, -0.25], [0.125, 1.0]],
            window_bounds: [f, -f, f + 1.0, -f + 1.0],
            parent,
        }));
    }
    parent.unwrap()
}
fn space(clip: Arc<Clip>) -> Space {
    Space {
        transform: [[1.25, 0.0], [0.0, 1.25]],
        inverse: Some([[0.8, 0.0], [0.0, 0.8]]),
        raster_scale: 1.375,
        clips: Some(clip),
    }
}
fn explicit_ptr_fast_eq(a: &Space, b: &Space) -> bool {
    a.transform == b.transform
        && a.inverse == b.inverse
        && a.raster_scale == b.raster_scale
        && match (&a.clips, &b.clips) {
            (None, None) => true,
            (Some(a), Some(b)) => Arc::ptr_eq(a, b) || a == b,
            _ => false,
        }
}

static EQ_VISITS: AtomicUsize = AtomicUsize::new(0);
#[derive(Debug)]
struct Counted {
    id: usize,
    parent: Option<Arc<Counted>>,
}
impl PartialEq for Counted {
    fn eq(&self, other: &Self) -> bool {
        EQ_VISITS.fetch_add(1, Ordering::Relaxed);
        self.id == other.id && self.parent == other.parent
    }
}
fn counted_chain(depth: usize) -> Arc<Counted> {
    let mut parent = None;
    for id in 0..depth {
        parent = Some(Arc::new(Counted { id, parent }));
    }
    parent.unwrap()
}

fn summarize(label: &str, ops: usize, mut times: Vec<f64>) {
    times.sort_by(f64::total_cmp);
    let n = times.len();
    println!(
        "{label:54} median={:.2} ns/op p10={:.2} p90={:.2}",
        times[n / 2] / ops as f64,
        times[n / 10] / ops as f64,
        times[n * 9 / 10] / ops as f64
    );
}
fn pair(
    label: &str,
    ops: usize,
    mut derived: impl FnMut() -> usize,
    mut fast: impl FnMut() -> usize,
) {
    for i in 0..6 {
        if i % 2 == 0 {
            black_box(derived());
            black_box(fast());
        } else {
            black_box(fast());
            black_box(derived());
        }
    }
    let (mut a, mut b) = (Vec::new(), Vec::new());
    for i in 0..30 {
        let (first, second) = if i % 2 == 0 {
            (&mut a, &mut b)
        } else {
            (&mut b, &mut a)
        };
        let t = Instant::now();
        if i % 2 == 0 {
            black_box(derived());
        } else {
            black_box(fast());
        }
        first.push(t.elapsed().as_nanos() as f64);
        let t = Instant::now();
        if i % 2 == 0 {
            black_box(fast());
        } else {
            black_box(derived());
        }
        second.push(t.elapsed().as_nanos() as f64);
    }
    summarize(&format!("{label} derived equality"), ops, a);
    summarize(&format!("{label} explicit ptr fast path"), ops, b);
}
fn repeated(a: &Space, b: &Space, ops: usize, fast: bool) -> usize {
    let mut equal = 0;
    for _ in 0..ops {
        let result = if fast {
            explicit_ptr_fast_eq(black_box(a), black_box(b))
        } else {
            black_box(a) == black_box(b)
        };
        equal += result as usize;
    }
    black_box(equal)
}
fn main() {
    println!(
        "std Arc<PartialEq-only> equality versus explicit ptr_eq || structural fallback; fixed objects, 30 paired samples"
    );
    for depth in [1, 16, 64, 256] {
        let same = space(chain(depth));
        let same_clone = same.clone();
        let equal_a = space(chain(depth));
        let equal_b = space(chain(depth));
        assert_eq!(same, same_clone);
        assert_eq!(same, equal_a);
        assert_eq!(equal_a, equal_b);
        let counted = counted_chain(depth);
        assert!(counted == counted.clone());
        let counted_visits = EQ_VISITS.swap(0, Ordering::Relaxed);
        println!(
            "depth={depth:3} equal Arc comparisons descend through {counted_visits} PartialEq nodes"
        );
        let ops = 10_000;
        pair(
            &format!("same Arc depth={depth} ops={ops}"),
            ops,
            || repeated(&same, &same_clone, ops, false),
            || repeated(&same, &same_clone, ops, true),
        );
        pair(
            &format!("distinct equal Arcs depth={depth} ops={ops}"),
            ops,
            || repeated(&equal_a, &equal_b, ops, false),
            || repeated(&equal_a, &equal_b, ops, true),
        );
    }
}
