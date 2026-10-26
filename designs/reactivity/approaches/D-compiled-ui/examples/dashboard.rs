//! Historical compiler-syntax experiment; automatic rewriting is optional Phase 9 work.
//! See `designs/reactivity/approaches/D-compiled-ui/README.md` for the correction.
//!
//! Approach D — complex example: a settings-driven dashboard.
//!
//! Design sketch (target API). Demonstrates:
//!   - component props with the Compose-style skip protocol (unchanged inputs
//!     ⇒ subtree skipped wholesale)
//!   - keyed loops: `for` without `key!` is a compile error inside #[component]
//!   - conditional panes as typed Either branches
//!   - `tw!` variants (hover:, dark:, focus:) compiling to reactive bindings
//!   - a deliberate static-inference bail-out surfaced by #[component(report)]
//!   - interop: a `state!` binding handed to a plain function as a real Signal

use gpui::{div, input, text, tw, Element, Signal, Ui};

#[derive(Clone, PartialEq)]
struct Widget {
    id: u64,
    kind: WidgetKind,
    title: String,
}

#[derive(Clone, Copy, PartialEq)]
enum WidgetKind {
    Chart,
    Feed,
    Notes,
}

#[derive(Clone, Copy, PartialEq)]
enum Layout {
    Grid,
    Column,
}

// ---------------------------------------------------------------------------
// Root component
// ---------------------------------------------------------------------------

#[gpui::component(report)] // surface every dynamic-tracking bail-out as a note
fn dashboard(cx: &mut Ui) -> impl Element {
    let mut layout = state!(Layout::Grid);
    let mut widgets = state!(vec![
        Widget { id: 1, kind: WidgetKind::Chart, title: "Revenue".into() },
        Widget { id: 2, kind: WidgetKind::Feed, title: "Activity".into() },
    ]);
    let mut query = state!(String::new());

    // Statically inferred scope: deps = {widgets, query}. Recomputes only when
    // either changes; equality-gated so downstream sees real changes only.
    let visible: Vec<Widget> = widgets
        .iter()
        .filter(|w| w.title.to_lowercase().contains(&query.to_lowercase()))
        .cloned()
        .collect();

    div()
        .class(tw!("size-full flex flex-col bg-zinc-100 dark:bg-zinc-900"))
        .child(toolbar(&mut layout, &mut query))
        .child(
            div()
                // Structural branch: Either<GridSeq, ColumnSeq>, typed. Only a
                // layout-mode flip rebuilds; pane *contents* carry their slots
                // across the move because identity is keyed, not positional.
                .class(match layout {
                    Layout::Grid => tw!("grid grid-cols-3 gap-3 p-3"),
                    Layout::Column => tw!("flex flex-col gap-3 p-3"),
                })
                .children({
                    // Loops REQUIRE a key — omitting `key!` is a compile error:
                    //   error: `for` inside #[component] needs `key!(expr)` as
                    //          its first statement (positional slots cannot
                    //          distinguish iterations)
                    let mut panes = vec![];
                    for w in &visible {
                        key!(w.id);
                        panes.push(widget_pane(w.clone(), widgets.signal()));
                    }
                    panes
                }),
        )
}

// ---------------------------------------------------------------------------
// Child component with props: the skip protocol. When `dashboard` rebuilds
// structurally, each `widget_pane(w, …)` call compares `w` by PartialEq via
// the $changed bitmask; unchanged panes skip their whole body.
// ---------------------------------------------------------------------------

#[gpui::component]
fn widget_pane(w: Widget, all: Signal<Vec<Widget>>) -> impl Element {
    let mut collapsed = state!(false);

    div()
        .class(tw!(
            "rounded-lg border border-zinc-300 dark:border-zinc-700 \
             bg-white dark:bg-zinc-800 hover:shadow-md"
        )) // hover:shadow-md = memoized binding on this pane's hover signal
        .child(
            div()
                .class(tw!("flex justify-between px-3 py-2 cursor-pointer"))
                .child(text!("{}", w.title))
                .child(text!("{}", if collapsed { "▸" } else { "▾" }))
                .on_click(move || collapsed = !collapsed),
        )
        .child(if collapsed {
            None
        } else {
            Some(match w.kind {
                // Three-way typed branch: Either3. Slots inside each arm are
                // grouped per-arm (Compose branch keys), so flipping kinds
                // resets state; toggling `collapsed` preserves it.
                WidgetKind::Chart => chart_body(w.id).into_any(),
                WidgetKind::Feed => feed_body(w.id).into_any(),
                WidgetKind::Notes => notes_body(w.id, all).into_any(),
            })
        })
}

#[gpui::component]
fn toolbar(layout: &mut state!(Layout), query: &mut state!(String)) -> impl Element {
    div()
        .class(tw!("flex items-center gap-3 px-3 py-2"))
        .child(
            input(query) // two-way binding to the rune
                .class(tw!("px-2 py-1 rounded focus:ring-2 focus:ring-blue-500")),
        )
        .child(text!("Grid").on_click(move || *layout = Layout::Grid))
        .child(text!("Column").on_click(move || *layout = Layout::Column))
}

// ---------------------------------------------------------------------------
// A deliberate bail-out, and rune→signal interop with plain Rust.
// ---------------------------------------------------------------------------

#[gpui::component]
fn notes_body(id: u64, all: Signal<Vec<Widget>>) -> impl Element {
    let mut draft = state!(String::new());

    // `summarize` is an opaque call: the macro cannot see which states it
    // reads, so THIS SCOPE ONLY falls back to runtime tracking (sound, just
    // dynamic). Under #[component(report)]:
    //   note: scope at dashboard.rs:… uses dynamic tracking
    //         (call to opaque `summarize`) — annotate with #[reads(all)] or
    //         pass values instead of signals to restore static inference.
    let summary = summarize(all);

    div()
        .class(tw!("p-3 flex flex-col gap-2"))
        .child(text!("{summary}"))
        .child(input(&mut draft).class(tw!("w-full")))
}

/// Plain, macro-free Rust: a rune crossing into ordinary code becomes the real
/// Signal it always was underneath. D is a front-end over A/C's runtime, not a
/// parallel world.
fn summarize(all: Signal<Vec<Widget>>) -> String {
    all.with(|ws| format!("{} widgets on this board", ws.len()))
}

#[gpui::component]
fn chart_body(id: u64) -> impl Element { text!("chart {id}") }
#[gpui::component]
fn feed_body(id: u64) -> impl Element { text!("feed {id}") }

fn main() {
    gpui::App::run(|cx| cx.open_window(Default::default(), dashboard));
}
