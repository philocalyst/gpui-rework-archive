//! Historical compiler-syntax experiment; only `tw!` is an early bounded macro candidate.
//! See `designs/reactivity/approaches/D-compiled-ui/README.md` for the correction.
//!
//! Approach D — simple example: the counter, rune style.
//!
//! Design sketch (target API). The top half is what the author writes; the
//! bottom half sketches what `#[component]` expands it to. There is no way to
//! write a frozen read by accident: the macro rewrites every read of a
//! `state!` binding into a tracked access.

use gpui::{button, div, text, tw, Element, Ui};

#[gpui::component]
fn counter(cx: &mut Ui) -> impl Element {
    // A slot in this component instance's slot table, keyed positionally.
    let mut count = state!(0i64);

    // Plain Rust expressions over `count`. The macro assigns each its own
    // recompute scope with a statically-inferred read set {count}.
    let label = format!("Clicked {count} times");
    let hot = count >= 10;

    div()
        .class(tw!("flex flex-col gap-2 p-4 rounded-md"))
        // `tw!` typo demo: tw!("gpa-2") → compile error: unknown class `gpa-2`
        //                  tw!("p-4 p-8") → compile error: conflicting paddings
        .class_if(hot, tw!("bg-red-700"))
        .child(text!("{label}"))
        .child(if hot {
            // if/else compiles to Either<A, B>: a typed structural branch,
            // rebuilt only when `hot` flips.
            Some(text!("On fire! 🔥").class(tw!("text-sm")))
        } else {
            None
        })
        .child(
            button("+1")
                .class(tw!("px-3 py-1 bg-blue-500 rounded-sm hover:bg-blue-400"))
                // Plain assignment. The macro rewrites `count += 1` into a
                // queued signal write; nothing recomputes until frame flush.
                .on_click(move || count += 1),
        )
}

// ---------------------------------------------------------------------------
// EXPANSION SKETCH (abridged; real expansion keeps user spans on every scope)
// ---------------------------------------------------------------------------
//
// fn counter(cx: &mut Ui) -> impl Element {
//     let __slots = cx.slot_table(__COMPONENT_ID);           // positional identity
//     let count: Signal<i64> = __slots.state(__slot!(0), || 0);
//
//     // scope 1: deps inferred statically = {count}
//     let label = cx.scoped(__slot!(1), (count,), |(count,)| {
//         format!("Clicked {} times", count.get())
//     });
//     // scope 2: deps = {count}, equality-gated → propagates only on flips
//     let hot = cx.scoped(__slot!(2), (count,), |(count,)| count.get() >= 10);
//
//     div()
//         .class(/* tw! parsed at compile time into a const StyleRefinement */)
//         .class_if_attr(hot, /* … */)                       // per-property binding
//         .child(text_attr(label))                           // one text-run node
//         .child(either_view(hot, /* then-branch builder */, /* else */))
//         .child(button("+1").on_click(cx.handler(__slot!(3), move |cx| {
//             count.update(cx, |n| *n += 1)                  // `count += 1` rewritten
//         })))
// }
//
// Notes:
//  - `hover:bg-blue-400` did not generate an if: it compiled to a memoized
//    attribute over the button's interaction signal (variants are bindings).
//  - Had scope 1 called an opaque function, the macro would have emitted
//    cx.scoped_dyn(...) — runtime-tracked, still correct — and, under
//    #[component(report)], a note: "scope at counter.rs:17 falls back to
//    dynamic tracking (call to opaque `helper`)".

fn main() {
    gpui::App::run(|cx| cx.open_window(Default::default(), counter));
}
