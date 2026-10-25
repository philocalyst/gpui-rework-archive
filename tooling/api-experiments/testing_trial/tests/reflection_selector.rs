use gpui::{
    InteractiveElement, IntoElement, ParentElement, Select, SelectableElement, Styled,
    TestAppContext, div, px, size,
};

#[gpui::test]
fn reflected_selector_mutates_a_typed_child() {
    let cx = &mut TestAppContext::single();
    let visual = cx.add_empty_window();

    visual.draw(Default::default(), size(px(100.), px(100.)), |_, _| {
        div()
            .map_selected(
                Select::children().class("target").reflects(Styled),
                |element| element.w(px(24.)),
            )
            .child(
                div()
                    .class("target")
                    .w(px(8.))
                    .h(px(8.))
                    .debug_selector(|| "target".into()),
            )
            .into_any_element()
    });

    assert_eq!(visual.debug_bounds("target").unwrap().size.width, px(24.));
}
