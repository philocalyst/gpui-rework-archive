#[path = "../support.rs"]
mod support;

// docs:step render | Describe the view
// A view is an ordinary Rust value that implements `Render`. GPUI calls `render`
// when it needs the view's element tree. The returned `Div` fills its parent,
// centers a string, and supplies the colors that the text inherits.
//
// You do not create a native widget for each element. GPUI lays out this tree
// and paints it into the window. See [the rendering contract](@/reference/rendering.md)
// for the three phases involved.
// docs:api gpui::Render gpui::div gpui::Styled
// docs:code
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
// docs:end

// docs:step window | Give the view a window
// `cx.new` gives GPUI ownership of the greeting and returns an `Entity<Greeting>`.
// The window keeps that entity as its root view. Nothing in the greeting needs
// to manage a graphics device or event loop.
//
// `support::run` selects the platform, opens the window, and keeps the browser
// application alive. The complete source below includes that helper. In a native
// application, the entry point begins with `gpui_platform::application().run(...)`.
// docs:api gpui::AppContext gpui::App::open_window gpui::Application::run
// docs:code
pub fn main() {
    support::run(|_window, cx| cx.new(|_cx| Greeting));
}
// docs:end
