//! Historical Approach A syntax sketch; not the selected API or a compilable contract.
//! See `designs/reactivity/03-hybrid-plan.md` for the authoritative model.
//!
//! Approach A — simple example: a counter.
//!
//! Design sketch (target API, does not compile against today's gpui).
//! What to notice:
//!   - `cx` still exists and is threaded exactly as in current GPUI code.
//!   - No `Render` impl, no `Entity` for the component, no `notify()`.
//!   - A click updates ONE text run and ONE background color. Nothing else in the
//!     window is re-rendered, re-laid-out, or re-allocated.

use gpui::{div, px, rgb, text, App, Application, IntoElement, ParentElement, Styled, Window};
use gpui_reactive::{bind, Signal};

fn counter(cx: &mut App) -> impl IntoElement {
    // Owned by the enclosing window's owner-scope; disposed when the window closes.
    let count: Signal<i64> = cx.signal(0);

    // Lazy, equality-gated: recomputes at most once per flush, and only if `count` changed.
    let label = cx.memo(move |cx| format!("Clicked {} times", count.get(cx)));
    let hot = cx.memo(move |cx| count.get(cx) >= 10);

    div()
        .flex()
        .flex_col()
        .gap_2()
        .p_4()
        // Reactive style property: paint-only invalidation, no layout pass.
        .bg(hot.map(|h| if h { rgb(0xcc3333) } else { rgb(0x2d2d2d) }))
        .rounded_md()
        // Reactive leaf: `label` is a Memo<String>, so this text run — and only
        // this text run — re-shapes when the count changes.
        .child(text(label).text_color(rgb(0xffffff)))
        // Structure changes need an explicit bind region (the granularity dial):
        .child(bind(hot, |hot, _cx| {
            hot.then(|| text("On fire! 🔥").text_sm())
        }))
        .child(
            div()
                .id("increment")
                .px_3()
                .py_1()
                .bg(rgb(0x3b82f6))
                .rounded_sm()
                .child(text("+1"))
                // `count` is Copy: no clone dance, no weak/strong entity juggling.
                // The write marks + enqueues; the flush at frame boundary does the rest.
                .on_click(move |_event, _window, cx| count.update(cx, |n| *n += 1)),
        )
}

fn main() {
    Application::new().run(|cx: &mut App| {
        cx.open_window(Default::default(), |_window: &mut Window, cx| counter(cx))
            .unwrap();
    });
}
