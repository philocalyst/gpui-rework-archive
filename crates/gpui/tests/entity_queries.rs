use gpui::{
    AppContext, Context, InteractiveElement, IntoElement, ParentElement, Render, Select,
    SelectableElement, Styled, TestAppContext, Window, div, px, size,
};

struct StatefulLabel {
    text: String,
}

impl Render for StatefulLabel {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        let text = self.text.clone();
        div()
            .w(px(8.))
            .h(px(8.))
            .debug_selector(move || text.clone().into())
    }
}

#[gpui::test]
fn selects_entity_models_after_type_and_class_filtering(cx: &mut TestAppContext) {
    let first = cx.new(|_| StatefulLabel {
        text: "first".into(),
    });
    let second = cx.new(|_| StatefulLabel {
        text: "second".into(),
    });

    let window = cx.add_empty_window();
    window.draw(Default::default(), size(px(100.), px(100.)), |_, _| {
        div()
            .select_entity(
                Select::children().class("row").nth(1),
                |model: &mut StatefulLabel, _cx| {
                    // Assigning the same value is safe if this entity is selected again in a
                    // later render session. The selector runs before the model renders.
                    model.text = "selected".into();
                },
            )
            .child(first.clone().class("row"))
            .child(
                div()
                    .class("row")
                    .debug_selector(|| "ordinary element".into()),
            )
            .child(second.clone().class("row"))
            .into_any_element()
    });

    assert_eq!(window.debug_bounds("first").unwrap().size.width, px(8.));
    assert_eq!(window.debug_bounds("selected").unwrap().size.width, px(8.));
    assert!(window.debug_bounds("ordinary element").is_some());

    // A new render session can select the same entity; the assignment remains stable.
    window.draw(Default::default(), size(px(100.), px(100.)), |_, _| {
        div()
            .select_entity(
                Select::children().class("row").nth(1),
                |model: &mut StatefulLabel, _cx| {
                    model.text = "selected again".into();
                },
            )
            .child(first.clone().class("row"))
            .child(
                div()
                    .class("row")
                    .debug_selector(|| "ordinary element".into()),
            )
            .child(second.clone().class("row"))
            .into_any_element()
    });
    assert_eq!(
        window.debug_bounds("selected again").unwrap().size.width,
        px(8.)
    );
}

#[cfg(entity_query_escape)]
fn entity_borrow_cannot_escape() {
    let saved = std::rc::Rc::new(std::cell::RefCell::new(None::<&'static mut StatefulLabel>));
    let saved_in_callback = saved.clone();
    let _ = div().select_entity(Select::children(), move |model: &mut StatefulLabel, _cx| {
        *saved_in_callback.borrow_mut() = Some(model);
    });
}

#[cfg(entity_query_alias)]
fn entity_borrow_cannot_alias() {
    let _ = div().select_entity(Select::children(), |model: &mut StatefulLabel, _cx| {
        let first = &mut *model;
        let second = &mut *model;
        drop((first, second));
    });
}
