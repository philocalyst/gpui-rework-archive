//! Historical Approach A syntax sketch; not the selected API or a compilable contract.
//! See `designs/reactivity/03-hybrid-plan.md` for the authoritative model.
//!
//! Approach A — complex example: a task board.
//!
//! Design sketch (target API). Demonstrates, in one screen:
//!   - plain-Rust state structs holding signals as ordinary fields (P1)
//!   - keyed incremental lists (`each_keyed`): editing one task touches one row
//!   - memo chains as derived state (filter → count → title)
//!   - async loading: a background task writes a signal; the FrameWaker turns
//!     that into exactly one scheduled frame
//!   - a `bind` region for structural change (empty state vs list)
//!   - interop with a legacy `Render`-based entity (the status bar)
//!   - free functions taking `impl ReadValue<T>` so literals, signals, and memos
//!     all compose through ordinary Rust code

use gpui::{div, rgb, text, App, Application, Context, Entity, IntoElement, ParentElement, Styled};
use gpui_reactive::{bind, each_keyed, Memo, ReadValue, Signal, WriteSignal};

// ---------------------------------------------------------------------------
// Plain Rust domain types. The framework does not own them (P1).
// ---------------------------------------------------------------------------

#[derive(Clone, PartialEq)]
struct Task {
    id: u64,
    title: String,
    done: bool,
}

#[derive(Clone, Copy, PartialEq)]
enum Filter {
    All,
    Active,
    Done,
}

/// Signals are ordinary fields. This struct is Copy-cheap to hand around and
/// has no lifetime or framework baggage; it can live in a Vec, a HashMap, an
/// Entity — wherever plain Rust wants to put it.
#[derive(Clone, Copy)]
struct BoardState {
    tasks: Signal<Vec<Task>>,
    filter: Signal<Filter>,
    loading: Signal<bool>,
}

impl BoardState {
    fn new(cx: &mut App) -> Self {
        Self {
            tasks: cx.signal(Vec::new()),
            filter: cx.signal(Filter::All),
            loading: cx.signal(true),
        }
    }

    /// Derived state is a method returning a Memo — an ordinary function of
    /// ordinary values. Equality gating means downstream consumers (the list,
    /// the counts) only wake when the *filtered result* actually changes.
    fn visible(&self, cx: &mut App) -> Memo<Vec<Task>> {
        let Self { tasks, filter, .. } = *self;
        cx.memo(move |cx| {
            let f = filter.get(cx);
            tasks.with(cx, |ts| {
                ts.iter()
                    .filter(|t| match f {
                        Filter::All => true,
                        Filter::Active => !t.done,
                        Filter::Done => t.done,
                    })
                    .cloned()
                    .collect()
            })
        })
    }
}

// ---------------------------------------------------------------------------
// Async: background load writes signals; scheduling is invisible (P2).
// ---------------------------------------------------------------------------

fn load_tasks(state: BoardState, cx: &mut App) {
    cx.spawn(async move |cx| {
        let fetched = fake_api_fetch().await;
        // AsyncApp write: marks dirty + pings the FrameWaker (idempotent), which
        // requests exactly one redraw however many writes land before the frame.
        cx.update(|cx| {
            state.tasks.set(cx, fetched);
            state.loading.set(cx, false);
        })
        .ok();
    })
    .detach();
}

// ---------------------------------------------------------------------------
// Components are free functions. Helpers accept `impl ReadValue<T>` so callers
// pass literals, signals, memos, or closures interchangeably (P1).
// ---------------------------------------------------------------------------

fn pill(label: impl ReadValue<String>, active: impl ReadValue<bool>) -> impl IntoElement {
    div()
        .px_2()
        .py_0p5()
        .rounded_full()
        .bg(active.map(|a| if a { rgb(0x3b82f6) } else { rgb(0x27272a) }))
        .child(text(label).text_sm())
}

fn filter_bar(state: BoardState) -> impl IntoElement {
    let seg = move |f: Filter, name: &'static str| {
        let filter = state.filter;
        pill(name.to_string(), filter.map(move |cur| cur == f))
            .id(name)
            .on_click(move |_, _, cx| filter.set(cx, f))
    };
    div()
        .flex()
        .gap_1()
        .child(seg(Filter::All, "All"))
        .child(seg(Filter::Active, "Active"))
        .child(seg(Filter::Done, "Done"))
}

fn task_row(task: Task, tasks: WriteSignal<Vec<Task>>) -> impl IntoElement {
    let id = task.id;
    div()
        .id(("task", id))
        .flex()
        .items_center()
        .gap_2()
        .px_3()
        .py_2()
        .child(text(if task.done { "☑" } else { "☐" }))
        .child(text(task.title.clone()).when(task.done, |t| t.line_through()))
        .on_click(move |_, _, cx| {
            // Row update: the keyed differ sees one changed key → one row's
            // element state patched. 999 sibling rows are untouched.
            tasks.update(cx, |ts| {
                if let Some(t) = ts.iter_mut().find(|t| t.id == id) {
                    t.done = !t.done;
                }
            })
        })
}

fn board(cx: &mut App, status_bar: Entity<StatusBar>) -> impl IntoElement {
    let state = BoardState::new(cx);
    load_tasks(state, cx);

    let visible = state.visible(cx);
    let remaining = cx.memo(move |cx| {
        state.tasks.with(cx, |ts| ts.iter().filter(|t| !t.done).count())
    });

    div()
        .flex()
        .flex_col()
        .size_full()
        .child(
            div()
                .flex()
                .justify_between()
                .p_3()
                .child(text(remaining.map(|n| format!("{n} open tasks"))).text_lg())
                .child(filter_bar(state)),
        )
        // Structural region: loading spinner ⇄ empty state ⇄ list. Only this
        // region rebuilds when `loading` or emptiness flips.
        .child(bind(
            cx.memo(move |cx| (state.loading.get(cx), visible.with(cx, Vec::is_empty))),
            move |(loading, empty), _cx| match (loading, empty) {
                (true, _) => text("Loading…").into_any(),
                (false, true) => text("Nothing here. Add a task!").into_any(),
                (false, false) => div()
                    .flex()
                    .flex_col()
                    // Keyed list: one subscription per row; splice-diff on keys.
                    .children(each_keyed(visible, |t| t.id, move |task, _cx| {
                        task_row(task, state.tasks.write_only())
                    }))
                    .into_any(),
            },
        ))
        // Legacy interop: an old-school Render entity, driven the old way —
        // and fed from the new world via observe_signal inside its constructor.
        .child(status_bar)
}

// A pre-existing, untouched GPUI view participating in the same window.
struct StatusBar {
    message: String,
}
impl StatusBar {
    fn new(cx: &mut Context<Self>, remaining: Memo<usize>) -> Self {
        // Old world subscribes to new world: signal change → notify → re-render
        // of this entity only (the coarse fallback layer, scoped to one view).
        cx.observe_signal(remaining, |this: &mut Self, n, cx| {
            this.message = format!("{n} to go");
            cx.notify();
        });
        Self { message: String::new() }
    }
}
impl gpui::Render for StatusBar {
    fn render(&mut self, _w: &mut gpui::Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().p_2().child(text(self.message.clone()).text_xs())
    }
}

async fn fake_api_fetch() -> Vec<Task> {
    vec![
        Task { id: 1, title: "Ship fine-grained reactivity".into(), done: false },
        Task { id: 2, title: "Delete cx.notify() call sites".into(), done: false },
    ]
}

fn main() {
    Application::new().run(|cx: &mut App| {
        cx.open_window(Default::default(), |_, cx| {
            let remaining = /* … plumbed as above … */ cx.memo(|_| 0);
            let status_bar = cx.new(|cx| StatusBar::new(cx, remaining));
            board(cx, status_bar)
        })
        .unwrap();
    });
}
