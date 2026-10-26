//! Slint `TouchArea.mouse-x` / Bevy `RelativeCursorPosition` / Iced `mouse_area`.
//!
//! Pointer geometry is a `GeometryRef` the placement graph consumes. It is not a
//! `Signal<Point>` the view reads — that is either pointer-rate re-describe or an
//! overwritten binding. `follow(pointer::local())` is a placement value, not a node type of
//! its own (13 §3.3): it says *where*, the same way `.align(TopRight)` and `.at(handle)` do.
//!
//! Stateless: a fn view (07 §2), no `struct Loupe {} + impl Default + impl View` adapter (12
//! §4b). The document root fills the window by default, so nothing here spells `.size_full()` —
//! and there is no wrapper `div()` establishing a positioning context: absolute placement needs
//! no `.relative()` incantation, on any container (12 §4b). `layers(…)`/`stack(…)`/`.overlay(…)`
//! are deleted; there is one child verb, so the three pieces below are just children of one
//! `div()` — the container exists to hold them, not to opt them into position:absolute.
//!
//! Resolved (14 §2.1): `div()` is exactly the right constructor here, and this is the settled
//! form, not an open question. The rule is a real semantic distinction, not a stand-in for a
//! missing "positioning canvas" primitive — flow containers (`column`/`row`/`grid`) are born with
//! their children because they exist to ARRANGE them; `div()` is the styled-box primitive and
//! stays nullary, so its three pieces below are added with `.child(x)`, the one child verb, one
//! call per piece — not `div((…))`, which cannot coexist with nullary `div()` (Rust has no arity
//! overloading) and was never the spelling to reach for.

use gpui::prelude::*;

fn loupe() -> El<'static> {
    div()
        .child(text("Move around").pos(24, 24))
        .child(
            follow(pointer::local())
                .offset(-12, -12)
                .child(icon(Crosshair).colorize(theme.accent.on)),
        )
        // Transform as Length (Bevy UiTransform in Val):
        .child(
            div()
                .size(80, 80)
                .bg(theme.accent)
                .translate(pct(10), 0)
                .rounded_full(),
        )
}

fn main() {
    Application::run(Window::document(loupe).title("Follow").size(480, 320));
}
