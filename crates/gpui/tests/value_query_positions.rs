use gpui::reflection::TypedPath;
use gpui::{
    App, IntoElement, ParentElement, Pixels, RenderOnce, Select, SelectableElement, Styled,
    TestAppContext, Window, div, px, size,
};

struct NoPayload(Pixels);

impl RenderOnce for NoPayload {
    fn render(self, _: &mut Window, _: &mut App) -> impl IntoElement {
        div().w(self.0).h(px(8.))
    }
}

#[gpui::reflect]
mod position_fixture {
    use gpui::{App, InteractiveElement, IntoElement, RenderOnce, Styled, Window, div, px};

    pub struct PositionCard {
        pub label: String,
        pub state: State,
    }

    pub enum State {
        Text { value: String },
        Count { value: u32 },
        Empty,
    }

    impl PositionCard {
        pub fn text(label: &str) -> Self {
            Self {
                label: label.into(),
                state: State::Text {
                    value: label.into(),
                },
            }
        }

        pub fn count(label: &str) -> Self {
            Self {
                label: label.into(),
                state: State::Count { value: 0 },
            }
        }

        pub fn empty(label: &str) -> Self {
            Self {
                label: label.into(),
                state: State::Empty,
            }
        }
    }

    impl RenderOnce for PositionCard {
        fn render(self, _: &mut Window, _: &mut App) -> impl IntoElement {
            let width = match &self.state {
                State::Text { value } if value.ends_with('!') => px(16.),
                _ => px(8.),
            };
            let label = self.label;
            div()
                .w(width)
                .h(px(8.))
                .debug_selector(move || label.clone().into())
        }
    }

    pub trait Payload {
        type Item;
        fn payload(&mut self) -> &mut Self::Item;
    }

    impl Payload for PositionCard {
        type Item = String;

        fn payload(&mut self) -> &mut Self::Item {
            &mut self.label
        }
    }
}

#[gpui::test]
fn inactive_enum_paths_are_excluded_before_nth_and_every(cx: &mut TestAppContext) {
    use position_fixture::{PositionCard, State};

    let path = PositionCard::fields()
        .state
        .then(State::variant_fields().text.value);

    let nth_window = cx.add_empty_window();
    nth_window.draw(Default::default(), size(px(300.), px(100.)), |_, _| {
        div()
            .select(
                Select::children()
                    .class("nth-entry")
                    .field(path.clone())
                    .nth(1),
                |value| value.push('!'),
            )
            .child(PositionCard::text("first").class("nth-entry"))
            .child(PositionCard::count("count").class("nth-entry"))
            .child(PositionCard::text("second").class("nth-entry"))
            .child(PositionCard::empty("empty").class("nth-entry"))
            .child(PositionCard::text("third").class("nth-entry"))
            .into_any_element()
    });
    assert_eq!(nth_window.debug_bounds("first").unwrap().size.width, px(8.));
    assert_eq!(
        nth_window.debug_bounds("second").unwrap().size.width,
        px(16.)
    );
    assert_eq!(nth_window.debug_bounds("third").unwrap().size.width, px(8.));

    let every_window = cx.add_empty_window();
    every_window.draw(Default::default(), size(px(300.), px(100.)), |_, _| {
        div()
            .select(
                Select::children().class("every-entry").field(path).every(2),
                |value| value.push('!'),
            )
            .child(PositionCard::text("first").class("every-entry"))
            .child(PositionCard::count("count").class("every-entry"))
            .child(PositionCard::text("second").class("every-entry"))
            .child(PositionCard::empty("empty").class("every-entry"))
            .child(PositionCard::text("third").class("every-entry"))
            .into_any_element()
    });
    assert_eq!(
        every_window.debug_bounds("first").unwrap().size.width,
        px(16.)
    );
    assert_eq!(
        every_window.debug_bounds("second").unwrap().size.width,
        px(8.)
    );
    assert_eq!(
        every_window.debug_bounds("third").unwrap().size.width,
        px(16.)
    );
}

#[gpui::test]
fn missing_role_schemas_are_excluded_before_nth(cx: &mut TestAppContext) {
    use position_fixture::{Payload, PositionCard};

    let visual = cx.add_empty_window();
    visual.draw(Default::default(), size(px(300.), px(100.)), |_, _| {
        div()
            .select(
                Select::children()
                    .class("payload")
                    .role::<dyn Payload<Item = String>>()
                    .nth(1),
                |payload| payload.payload().push('!'),
            )
            .child(NoPayload(px(8.)).class("payload"))
            .child(PositionCard::text("first").class("payload"))
            .child(NoPayload(px(8.)).class("payload"))
            .child(PositionCard::count("second").class("payload"))
            .child(PositionCard::empty("third").class("payload"))
            .into_any_element()
    });

    assert!(visual.debug_bounds("first").is_some());
    assert!(visual.debug_bounds("second!").is_some());
    assert!(visual.debug_bounds("third").is_some());
}
