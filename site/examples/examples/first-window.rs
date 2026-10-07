#[path = "../src/support.rs"]
mod support;

// ## Return the elements to draw {#render}
// The window will display “Hello, GPUI”. Its view, `Greeting`, needs no state:
// it implements [`Render`] and returns a [`div`] containing that string.
//
// The [`Styled`] builders make the div fill its parent, center its child, and
// give the text a size and color. GPUI lays out and paints these elements in
// one window. The [rendering explanation](@/reference/rendering.md) describes
// the work between this return value and the displayed frame.

use gpui::{AppContext, Context, IntoElement, Render, Window, div, prelude::*, rgb};

struct Greeting;

impl Render for Greeting {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .items_center()
            .justify_center()
            .bg(rgb(0xf7f6f2))
            .text_color(rgb(0x155b50))
            .text_2xl()
            .child("Hello, GPUI")
    }
}

// ## Keep a root view in a window {#window}
// [`AppContext::new`] stores `Greeting` in the app and returns its entity
// handle. The window retains that entity as its root view.
//
// `support::run` opens the platform window through [`App::open_window`]. It
// also keeps the browser application's handle alive; native execution uses
// [`Application::run`]. The complete source includes this helper, so the
// downloadable program contains its entry point as well as its rendering code.

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<Greeting> {
    cx.new(|_cx| Greeting)
}

pub fn main() {
    support::run(component);
}
