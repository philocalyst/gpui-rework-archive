#[path = "../src/support.rs"]
mod support;

// ## Return the elements to draw {#render}
// The window will display “Hello, GPUI”. `Greeting` has no mutable fields, so
// its [`Render`] method only returns a [`div`] containing the string. `Render`
// is the contract for an entity-backed view; the returned element tree is a
// description GPUI lays out and paints for the current frame.
//
// The [`Styled`] builders make the div fill its parent, center its child, and
// set inherited text size and color. `size_full` needs a bounded parent; the
// window supplies that root constraint. Follow the [rendering explanation](@/reference/rendering.md)
// from this returned tree through layout, prepaint, scene construction, and
// presentation.

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
// `support::run` starts the application and opens a window through
// [`App::open_window`]. On native targets its platform application calls
// [`Application::run`] to enter GPUI's event loop; the web branch uses the
// embedded platform runner. The returned entity is installed as that window's
// root, which keeps it alive while open. The downloadable Cargo example also
// includes the native launcher, so it can be run without reconstructing the
// setup around the view.

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<Greeting> {
    cx.new(|_cx| Greeting)
}

pub fn main() {
    support::run(component);
}
