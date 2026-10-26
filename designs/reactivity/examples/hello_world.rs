//! Syntax sketch of `crates/gpui/examples/legacy/hello_world.rs`.
//!
//! Floor: plain `T` implementing `View`. There is no `gpui::run` — one `Application`,
//! `Application::run(root)` (07 §12). `view` returns the concrete `El<'_>` (14 §1.2): it borrows
//! `self` (and this turn's frame arena) for the length of one description and is diffed into the
//! retained tape at commit (07 §2.1). `swatch` borrows nothing — `Color` is `Copy` — so it drops
//! the lifetime entirely and returns `impl Element + Styled` (open: callers may still restyle it,
//! as the last swatch does — Styled stays as a bound, not a finished-element wrapper, 14 §1.2) and
//! coerces into any frame. `text` is base Rust: `String` in the struct, `&str`/`format!` at the
//! boundary — no `SharedString` in application code (12 §3).

use gpui::prelude::*;

struct HelloWorld {
    text: String,
}

impl View for HelloWorld {
    fn view(&self) -> El<'_> {
        column((
            // `&self.text` is appended to the frame as a borrow; the `format!` temporary
            // lives in the arena and is promoted only if it differs from last commit.
            text(format!("Hello, {}!", self.text)),
            row((
                swatch(Color::Red),
                swatch(Color::Green),
                swatch(Color::Blue),
                swatch(Color::Yellow),
                swatch(Color::Black),
                swatch(Color::White).border_color(Color::Black),
            ))
            .gap(8),
        ))
        .gap(12)
        .bg(0x505050)
        .size(500)
        .center()
        .shadow_lg()
        .border_1()
        .border_color(Color::Blue)
        .text_xl()
        .text_color(Color::White)
    }
}

fn swatch(color: Color) -> impl Element + Styled {
    div()
        .size_8()
        .bg(color)
        .border_1()
        .border_dashed()
        .rounded_md()
        .border_color(Color::White)
}

fn main() {
    // One window, default chrome: the terse owner method. `Application::run` accepts a bare
    // `V: View` or a configured `Window::document(v)....` — same owner, no hidden path (07 §12).
    Application::run(HelloWorld { text: "World".into() });
}
