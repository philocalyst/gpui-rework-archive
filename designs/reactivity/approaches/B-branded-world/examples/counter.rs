//! Historical maximal-brand experiment; public `'ui` branding is not the selected API.
//! See `designs/reactivity/approaches/B-branded-world/README.md` for the correction.
//!
//! Approach B — simple example: a counter in the branded world.
//!
//! Design sketch (target API). What to notice:
//!   - No `Application::new()`, no globals, no `Context<T>`, no `notify()`.
//!   - `Sig<'ui, T>` is Copy and zero-cost; reads/writes are plain indexed loads,
//!     synchronized by the borrow checker through phase tokens — no RefCell.
//!   - Writing a signal during build DOES NOT COMPILE (phase tokens).
//!   - "App-wide state" is an ordinary struct the user owns and passes around.

use gpui::{div, rgb, text, Build, El, Events, ParentElement, Sig, Styled, Ui};

/// The entire "global" state of the app: a plain struct of branded signals.
/// Forgetting to construct a field is a compile error at the construction site —
/// the `"no global registered of type Theme"` runtime panic cannot exist here.
struct Ctx<'ui> {
    accent: Sig<'ui, u32>,
    count: Sig<'ui, i64>,
}

fn counter<'ui>(ui: &mut Build<'ui>, ctx: &Ctx<'ui>) -> El<'ui> {
    // Copy the handles we need. No clones, no Rc, no weak/strong dance.
    let Ctx { accent, count } = *ctx;

    // Derived state: tracked read through the Build token. Equality-gated.
    let label = ui.memo(move |f| format!("Clicked {} times", count.get(f)));
    let hot = ui.memo(move |f| count.get(f) >= 10);

    div(ui)
        .flex()
        .flex_col()
        .gap_2()
        .p_4()
        .bg(hot.select(rgb(0xcc3333), rgb(0x2d2d2d))) // reactive paint-only property
        .child(text(ui, label))
        .child(
            div(ui)
                .px_3()
                .py_1()
                .bg(accent) // theme accent is just another signal read
                .child(text(ui, "+1"))
                // The handler receives `&mut Events<'ui>` — the only writer token.
                .on_click(move |_click, ev: &mut Events<'ui>| {
                    count.update(ev, |n| *n += 1);

                    // count.get(&frame)  ← does not compile here: no Frame token
                    //                       exists inside a handler. Use peek:
                    let _n = count.peek(ev); // untracked read, allowed
                }),
        )
        .build(ui)

    // Meanwhile, inside this build function:
    //     count.set(???, 1)
    // cannot be written at all — `set` needs `&mut Events<'ui>` and build code
    // only holds `&mut Build<'ui>`. Write-during-render is unrepresentable.
}

fn main() {
    // `run` is the single entry point; the brand 'ui is minted here, fresh,
    // via a higher-ranked bound — user code can never name or leak it.
    gpui::run(|ui: &mut Ui<'_>| {
        let ctx = Ctx {
            accent: ui.sig(0x3b82f6),
            count: ui.sig(0),
        };
        ui.window(Default::default(), move |ui: &mut Build<'_>| {
            counter(ui, &ctx)
        });
    });
    // After `run` returns, every Sig<'ui, _> is statically unusable: the brand
    // died with the scope. Use-after-dispose is not a panic — it's E0521.
}
