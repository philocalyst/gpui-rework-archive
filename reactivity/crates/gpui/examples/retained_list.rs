//! Fresh-process declaration/layout/scene benchmark; not native-present timing.
use gpui::{
    El, ItemKey, ItemSource, ListId, Role, View, Win, WindowOptions, column, text, uniform_list,
};
use std::{hint::black_box, time::Instant};

const LIST: ListId = ListId::new(1);
struct Rows {
    ids: Vec<u64>,
    virtualized: bool,
}
impl ItemSource for Rows {
    fn len(&self) -> usize {
        self.ids.len()
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(self.ids[index])
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        let index = usize::try_from(key.get()).ok()?;
        self.ids
            .get(index)
            .filter(|id| **id == key.get())
            .map(|_| index)
    }
    fn row(&self, index: usize) -> El<'_> {
        text(format!("Track {:06}", self.ids[index])).h(32)
    }
}
impl View for Rows {
    fn view(&self) -> El<'_> {
        if self.virtualized {
            uniform_list(LIST, self, 32).h(400).w(320)
        } else {
            column((0..self.len()).map(|index| self.row(index)))
                .h(400)
                .w(320)
        }
    }
}
fn acknowledge(win: &mut Win<Rows>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}

fn options() -> WindowOptions {
    WindowOptions {
        size: [320, 400],
        ..Default::default()
    }
}

// Before measuring a fresh owner, independently render its expected visible
// rows through the ordinary eager path and compare every output byte. This
// deliberately warms code/allocator pages, not the measured owner's caches.
fn preflight(count: usize, virtualized: bool) {
    let mut actual = Win::recording(
        Rows {
            ids: (0..count as u64).collect(),
            virtualized,
        },
        options(),
    )
    .unwrap();
    acknowledge(&mut actual);
    let visible = count.min(13);
    if virtualized {
        assert_eq!(actual.role(Role::ListItem).count().unwrap(), visible);
        assert_eq!(actual.role(Role::Text).count().unwrap(), visible);
        assert_eq!(actual.inspect().unwrap().nodes.len(), 1 + 2 * visible);
    }
    assert!(actual.with_scene(|scene, _| scene.draws().len()).unwrap() > 0);
    let mut reference = Win::recording(
        Rows {
            ids: (0..visible as u64).collect(),
            virtualized: false,
        },
        options(),
    )
    .unwrap();
    acknowledge(&mut reference);
    actual
        .with_pixels(|pixels, width, height| {
            assert_eq!([width, height], [320, 400]);
            assert!(
                pixels
                    .as_chunks::<4>()
                    .0
                    .iter()
                    .any(|pixel| pixel[..3] != [255; 3])
            );
            reference
                .with_pixels(|expected, _, _| assert_eq!(pixels, expected))
                .unwrap();
        })
        .unwrap();
}
fn main() {
    let args = std::env::args().skip(1).collect::<Vec<_>>();
    assert_eq!(args.len(), 2, "virtual|eager item_count");
    let virtualized = match args[0].as_str() {
        "virtual" => true,
        "eager" => false,
        _ => panic!("virtual|eager item_count"),
    };
    let count: usize = args[1].parse().unwrap();
    // The ordinary runtime explicitly rejects >100K nodes. Do not deliberately
    // allocate 250K eager row descriptions just to rediscover that limit.
    if !virtualized && count >= 100_000 {
        println!("mode,count,status\neager,{count},exceeds_documented_node_limit");
        return;
    }
    assert!(count != 0);
    preflight(count, virtualized);
    let rows = Rows {
        ids: (0..count as u64).collect(),
        virtualized,
    };
    let source_bytes = rows.ids.capacity() * size_of::<u64>();
    let mut mounted = None;
    let start = Instant::now();
    let mount = allocation_counter::measure(|| {
        mounted = Some(Win::recording(rows, options()).unwrap());
    });
    let mount_us = start.elapsed().as_secs_f64() * 1e6;
    let mut win = mounted.unwrap();
    acknowledge(&mut win);
    let nodes = win.inspect().unwrap().nodes.len();
    let draws = win.with_scene(|scene, _| scene.draws().len()).unwrap();
    assert!(
        nodes > 1 && draws > 0,
        "benchmark must publish and paint real rows"
    );
    let counters = win.counters();
    let mut scroll_us = Vec::new();
    let mut scroll_retained = 0;
    let mut scroll_peak = 0;
    if virtualized && count != 0 {
        let list = win.list(LIST).unwrap();
        for step in 0..32 {
            let index = step * 7919 % count;
            let started = Instant::now();
            let work = allocation_counter::measure(|| {
                win.scroll_to_index(list, index).unwrap();
                acknowledge(&mut win);
            });
            scroll_us.push(started.elapsed().as_secs_f64() * 1e6);
            scroll_retained += work.bytes_current;
            scroll_peak = scroll_peak.max(work.bytes_max);
        }
        scroll_us.sort_by(f64::total_cmp);
    }
    black_box(win.counters());
    println!(
        "mode,count,source_bytes,mount_us,mount_retained_bytes,mount_peak_bytes,mount_allocations,presented_nodes,draws,measure_calls,scroll_median_us,scroll_retained_delta,scroll_peak_new_bytes"
    );
    println!(
        "{},{count},{source_bytes},{mount_us:.3},{},{},{},{nodes},{draws},{},{:.3},{scroll_retained},{scroll_peak}",
        args[0],
        mount.bytes_current,
        mount.bytes_max,
        mount.count_total,
        counters.measure_calls,
        scroll_us.get(scroll_us.len() / 2).copied().unwrap_or(0.0)
    );
}
