//! Run with `cargo run -p gpui-ce --example element_selectors`.
//!
//! Select component values before `RenderOnce` consumes them. The rendered
//! root is a separate node; use `descendants()` to query across that boundary.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use example_prelude::init_example;
use gpui::{
    App, Bounds, Context, Entity, IntoElement, Pixels, Render, RenderOnce, Select, Window,
    WindowBounds, WindowOptions, div, prelude::*, px, rgb, rgb_to_hsla, size,
};

// Ordinary components need no derive or reflection attribute. `.class()` adds
// a query annotation while preserving the component as the selected value.
struct Note {
    text: String,
}

impl RenderOnce for Note {
    fn render(self, _: &mut Window, _: &mut App) -> impl IntoElement {
        div().child(self.text)
    }
}

#[gpui::reflect]
mod cards {
    use gpui::{App, IntoElement, ParentElement, RenderOnce, Styled, Window, div, px};

    pub struct Details {
        pub title: String,
        pub width: gpui::Pixels,
    }

    pub struct Card {
        pub details: Details,
    }

    impl Card {
        pub fn new(title: &str) -> Self {
            Self {
                details: Details {
                    title: title.into(),
                    width: px(180.),
                },
            }
        }

        pub fn rename(&mut self, title: &str) {
            self.details.title = title.into();
        }
    }

    pub trait Labelled {
        fn rename(&mut self, title: &str);
    }

    impl Labelled for Card {
        fn rename(&mut self, title: &str) {
            self.rename(title);
        }
    }

    impl RenderOnce for Card {
        fn render(self, _: &mut Window, _: &mut App) -> impl IntoElement {
            div()
                .w(self.details.width)
                .px_3()
                .py_2()
                .child(self.details.title)
        }
    }
}

use cards::{Card, Details};

trait WidthView {
    fn width(&mut self) -> &mut Pixels;
}

impl WidthView for Card {
    fn width(&mut self) -> &mut Pixels {
        &mut self.details.width
    }
}

struct ElementSelectorsExample;

impl Render for ElementSelectorsExample {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .flex_col()
            .items_center()
            .justify_center()
            .gap_3()
            .bg(rgb(0x111827))
            // The callback receives Note before render consumes it.
            .select(Select::children().class("note"), |note: &mut Note| {
                note.text.push_str(" (edited before render)");
            })
            .child(
                Note {
                    text: "A plain RenderOnce component".into(),
                }
                .class("note"),
            )
            // Typed paths let the callback edit just the selected field.
            .select(
                Select::children().field(Card::fields().details.then(Details::fields().title)),
                |title| title.push_str(" — selected"),
            )
            // Trait objects are projected safely from implementations visible
            // inside the reflected module.
            .select(
                Select::children()
                    .class("role")
                    .role::<dyn cards::Labelled>(),
                |label| label.rename("Renamed through a trait view"),
            )
            .child(Card::new("Typed field path").class("field"))
            .child(Card::new("Role view").class("role"))
            // Built-in style projections need no schema declaration.
            .select(Select::children().class("style").style(), |style| {
                style.size.width = Some(px(220.).into());
            })
            .select(Select::children().class("style").text_style(), |style| {
                style.color = Some(rgb_to_hsla(rgb(0xfacc15)));
            })
            .child(
                div()
                    .w(px(180.))
                    .child("Built-in style and text style")
                    .class("style"),
            )
            .select(
                Select::children()
                    .class("external")
                    .view(|card: &mut Card| {
                        // This noncapturing closure coerces to a reusable function pointer.
                        card as &mut dyn WidthView
                    }),
                |view| *view.width() = px(240.),
            )
            .child(Card::new("External view projection").class("external"))
    }
}

fn build_view(_: &mut Window, cx: &mut App) -> Entity<ElementSelectorsExample> {
    cx.new(|_| ElementSelectorsExample)
}

fn main() {
    gpui_platform::application().run(|cx: &mut App| {
        let bounds = Bounds::centered(None, size(px(420.), px(320.)), cx);
        cx.open_window(
            WindowOptions {
                window_bounds: Some(WindowBounds::Windowed(bounds)),
                ..Default::default()
            },
            build_view,
        )
        .expect("Failed to open window");

        init_example(cx, "Element Selectors");
    });
}
