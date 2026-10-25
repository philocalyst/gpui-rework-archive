use gpui::reflection::TypedPath;
use gpui::{Div, IntoElement, ParentElement, Select, SelectableElement, Styled, div, px};

#[gpui::reflect]
mod cards {
    use gpui::{App, IntoElement, ParentElement, Pixels, RenderOnce, Styled, Window, div, px};

    pub struct Details {
        pub title: String,
        pub width: Pixels,
    }

    pub struct Card {
        pub details: Details,
        pub state: State,
    }

    pub enum State {
        Ready { title: String },
        Waiting,
    }

    impl Card {
        pub fn new(title: &str) -> Self {
            Self {
                details: Details {
                    title: title.into(),
                    width: px(80.),
                },
                state: State::Ready {
                    title: title.into(),
                },
            }
        }

        pub fn title(&self) -> &str {
            &self.details.title
        }
        pub fn width(&mut self, width: Pixels) {
            self.details.width = width;
        }
        pub fn apply<T>(&self, f: impl FnOnce(&str) -> T) -> T {
            f(self.title())
        }
    }

    impl RenderOnce for Card {
        fn render(self, _: &mut Window, _: &mut App) -> impl IntoElement {
            let title = self.details.title;
            div().w(self.details.width).child(title)
        }
    }

    pub trait Payload {
        type Item;
        fn payload(&mut self) -> &mut Self::Item;
    }

    impl Payload for Card {
        type Item = String;
        fn payload(&mut self) -> &mut Self::Item {
            &mut self.details.title
        }
    }

    // GAT and borrowed-return APIs stay ordinary native Rust for direct callbacks.
    pub trait Borrowed {
        type Text<'a>
        where
            Self: 'a;
        fn text(&self) -> Self::Text<'_>;
    }

    impl Borrowed for Card {
        type Text<'a> = &'a str;
        fn text(&self) -> Self::Text<'_> {
            self.title()
        }
    }
}

fn native_component(root: impl SelectableElement) -> impl IntoElement {
    use cards::{Borrowed, Card, Details};

    root.select(Select::children().class("native"), |card: &mut Card| {
        let _: &str = card.text();
        assert_eq!(
            Card::methods().apply.call(card, str::len),
            card.title().len()
        );
        card.width(px(120.));
    })
    .select(
        Select::children()
            .class("typed-path")
            .field(Card::fields().details.then(Details::fields().width)),
        |width| *width = px(140.),
    )
    .select(
        Select::children()
            .class("payload")
            .role::<dyn cards::Payload<Item = String>>(),
        |payload| payload.payload().push('!'),
    )
}

// A handwritten concrete element uses the same borrowed callback through its
// ordinary query subject; no module reflection is needed for this path.
fn concrete_element(root: impl SelectableElement) -> impl IntoElement {
    root.select(Select::children().class("div"), |element: &mut Div| {
        element.style().size.width = Some(px(160.).into());
    })
}

fn main() {
    let _ = native_component(div().child(cards::Card::new("native").class("native")));
    let _ = concrete_element(div().child(div().class("div")));
}
