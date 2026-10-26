//! Historical attribute-graph syntax sketch; type-level durability/MVCC are not target API.
//! See `designs/reactivity/approaches/C-attribute-graph/README.md` for the correction.
//!
//! Approach C — complex example: a 100k-row virtualized data table.
//!
//! Design sketch (target API). This is the workload C exists for. Demonstrates:
//!   - durability tiers as types: theme (Durable) / dataset (Session) /
//!     scroll & hover (Volatile) — a mouse move provably cannot touch the
//!     sort graph, and the compiler checks the claim
//!   - background sorting against an immutable snapshot (MVCC), applied
//!     atomically — the UI thread never blocks and never sees a half-sorted view
//!   - incremental filter via a keyed arrangement (differential-dataflow shape):
//!     one row edit re-evaluates one key, not 100k
//!   - virtualization as demand: offscreen rows have no observers, so their
//!     attributes never enter the dirty heap at all
//!   - per-cell attributes: editing one cell re-shapes one text run

use gpui::{
    div, rgb, text, uniform_list, App, Attr, Durable, GraphCx, IntoView, MergePolicy, Session,
    SortSpec, State, Volatile,
};

#[derive(Clone, PartialEq)]
struct Row {
    id: u64,
    symbol: String,
    price: f64,
    change: f64,
}

struct TableCtx {
    // Durable: written ~never. A theme flip is a Durable-tier flush; a mouse
    // move never visits anything rooted only here (checked by the type lattice).
    theme: State<Theme, Durable>,
    // Session: the dataset and view configuration.
    rows: State<KeyedTable<u64, Row>, Session>, // arrangement: keyed, diff-emitting
    sort: State<SortSpec<Row>, Session>,
    query: State<String, Session>,
    // Volatile: per-frame interaction state.
    scroll_top: State<f32, Volatile>,
    hover_row: State<Option<u64>, Volatile>,
}

fn table(cx: &mut GraphCx, t: &TableCtx) -> impl IntoView {
    // -----------------------------------------------------------------------
    // Derived pipeline. Durability of each node = min of its inputs (trait
    // arithmetic). Annotations shown for documentation; they're inferred, and
    // an annotation stronger than the inputs justify is a COMPILE ERROR:
    //
    //   let x: Attr<_, Durable> = cx.derive((t.rows, ..), ..);
    //             ^^^^^^^ error: computation reads `Session` input `rows`
    // -----------------------------------------------------------------------

    // Incremental filter: an arrangement operator, not a re-scan. A single
    // row upsert emits a single keyed diff downstream.
    let filtered: Attr<KeyedTable<u64, Row>, Session> =
        cx.arrange_filter(t.rows, t.query, |row, q| row.symbol.contains(q.as_str()));

    // Sorting 100k rows is too slow for a frame, so it runs on the background
    // pool AGAINST A SNAPSHOT. `derive_bg` = take snapshot → compute off-thread
    // → apply result atomically; the previous sorted order remains on screen
    // (with a staleness attr) until the new one lands as one consistent frame.
    let sorted: Attr<Vec<u64>, Session> = cx.derive_bg(
        (filtered, t.sort),
        MergePolicy::TakeLatest,
        |(table, spec)| {
            let mut ids: Vec<u64> = table.keys().collect();
            ids.sort_by(|a, b| spec.compare(&table[a], &table[b]));
            ids
        },
    );
    let sorting: Attr<bool, Session> = sorted.in_flight();

    // -----------------------------------------------------------------------
    // Virtualized body: rows are materialized on demand. An offscreen row has
    // no observer → its cells never enter the dirty heap (demand-driven skip).
    // -----------------------------------------------------------------------
    let body = uniform_list(sorted, t.scroll_top, move |cx, row_id| {
        let row = cx.at(filtered, row_id); // Attr<Row>: one subscription per visible row
        let hovered: Attr<bool, Volatile> = cx.derive((t.hover_row,), move |(h,)| *h == Some(row_id));

        div()
            .flex()
            .gap_4()
            .px_3()
            // Volatile paint-only attribute: hover repaints ONE row's quad.
            .bg(hovered.select_with(t.theme, |th| th.row_hover, |th| th.row_bg))
            .on_hover(move |is, cx| t.hover_row.set(cx, is.then_some(row_id)))
            // Per-cell attributes: a price tick re-shapes exactly one text run
            // and repaints one color. The row, table, and window do nothing.
            .child(text(row.field(|r| r.symbol.clone())).w_24())
            .child(text(row.field(|r| format!("{:.2}", r.price))).w_20())
            .child(
                text(row.field(|r| format!("{:+.2}%", r.change)))
                    .text_color(row.field_with(t.theme, |r, th| {
                        if r.change >= 0.0 { th.gain } else { th.loss }
                    })),
            )
    });

    div()
        .size_full()
        .flex()
        .flex_col()
        .bg(cx.durable(t.theme, |th| th.surface)) // Durable attr: free at runtime
        .child(header(cx, t, sorting))
        .child(body)
}

fn header(cx: &mut GraphCx, t: &TableCtx, sorting: Attr<bool, Session>) -> impl IntoView {
    div()
        .flex()
        .gap_4()
        .px_3()
        .py_2()
        .child(
            gpui::input(t.query) // two-way: an input element bound to State<String>
                .placeholder("Filter symbols…"),
        )
        .child(sorting.then_view(|| text("sorting…").text_xs().opacity(0.6)))
        .child(
            text("Price")
                .id("sort-price")
                .on_click(move |_, cx| t.sort.update(cx, |s| s.toggle(|r: &Row| r.price))),
        )
}

// Feed: 1000 price ticks/sec from a network thread. Each tick takes a write
// snapshot, upserts keyed diffs, applies. Between two frames, N applies
// coalesce; the arrangement forwards only net diffs; visible cells whose
// values changed re-shape. Everything else is proven quiet — by tier, by
// equality cutoff, or by absence of observers.
fn spawn_feed(cx: &mut GraphCx, rows: State<KeyedTable<u64, Row>, Session>) {
    let handle = rows.background_writer();
    std::thread::spawn(move || {
        for tick in fake_ticks() {
            handle
                .write(move |table| table.upsert(tick.id, |r| r.price = tick.price))
                .ok(); // Err after teardown — same honest boundary as Approach B
        }
    });
}

struct Theme { surface: u32, row_bg: u32, row_hover: u32, gain: u32, loss: u32 }
struct KeyedTable<K, V>(std::marker::PhantomData<(K, V)>);
fn fake_ticks() -> impl Iterator<Item = Tick> { std::iter::empty() }
struct Tick { id: u64, price: f64 }

fn main() {
    App::run(|cx| {
        cx.open_window(Default::default(), |cx| {
            let t = TableCtx { /* … construct states … */ };
            spawn_feed(cx, t.rows);
            table(cx, &t)
        })
    });
}
