//! Historical attribute-graph syntax sketch; universal MVCC is not the selected state model.
//! See `designs/reactivity/approaches/C-attribute-graph/README.md` for the correction.
//!
//! Approach C — simple example: the counter as an attribute graph.
//!
//! Design sketch (target API). What to notice:
//!   - `build` runs ONCE. There is no per-frame render function at all.
//!   - Every dynamic property is an attribute wire; a click updates exactly
//!     two graph nodes (label text, background color) and the passes they map to.
//!   - Handler writes go to the frame snapshot and apply atomically (MVCC):
//!     reading after writing inside the handler sees the new value; the screen
//!     never sees half a frame.

use gpui::{div, rgb, text, App, GraphCx, IntoView, State, ViewSeq};

struct Counter {
    count: State<i64>, // default durability: Session
}

impl Counter {
    fn build(cx: &mut GraphCx) -> impl IntoView {
        let count = cx.state(0i64);

        // Attributes: named nodes in the persistent graph. Equality-cutoff means
        // `hot` only propagates on the false→true / true→false edges, even though
        // `count` changes on every click.
        let label = cx.derive(count, |n| format!("Clicked {n} times"));
        let hot = cx.derive(count, |n| *n >= 10);

        div()
            .flex()
            .flex_col()
            .gap_2()
            .p_4()
            .bg(hot.select(rgb(0xcc3333), rgb(0x2d2d2d))) // paint-pass attribute
            .child(text(label))                           // text-shaping attribute
            // Structure depends on `hot`: an Option<view> is a typed ViewSeq node.
            // rebuild(prev) runs only when `hot` flips — the Layer V fallback.
            .child(hot.then_view(|| text("On fire! 🔥").text_sm()))
            .child(
                div()
                    .px_3()
                    .py_1()
                    .bg(rgb(0x3b82f6))
                    .child(text("+1"))
                    .on_click(move |_ev, cx| {
                        // Writes to the frame's mutable snapshot:
                        count.update(cx, |n| *n += 1);
                        debug_assert_eq!(count.get(cx) % 1, 0); // sees own write
                        // Nothing recomputes here. At frame boundary: snapshot
                        // applies → reverse-index invalidation → stabilize →
                        // two attributes recompute → paint one quad, shape one line.
                    }),
            )
    }
}

fn main() {
    App::run(|cx| cx.open_window(Default::default(), Counter::build));
}
