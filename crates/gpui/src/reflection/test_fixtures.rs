use gpui::{
    AnyElement, App, Div, ElementId, InteractiveElement, IntoElement, RenderOnce, Stateful, Styled,
    Window, div, px, reflection::Reflect,
};

#[gpui::reflection::reflect_trait]
pub(crate) trait TestValue {
    fn value(&mut self) -> &mut usize;
}

#[derive(gpui::Element)]
#[reflect(TestValue)]
pub(crate) struct TestElement {
    #[element(style, children, interactive, stateful)]
    inner: Stateful<Div>,
    pub(crate) value: usize,
}

impl TestElement {
    #[track_caller]
    pub(crate) fn new(element_id: impl Into<ElementId>) -> Self {
        Self {
            inner: div().id(element_id),
            value: 0,
        }
    }
}

impl TestValue for TestElement {
    fn value(&mut self) -> &mut usize {
        &mut self.value
    }
}

pub(crate) fn set_value(element: &mut AnyElement, value: usize) {
    *element.reflect_mut(TestValue).unwrap().value() = value;
}

#[derive(IntoElement, Reflect, Default)]
#[reflect(TestValue)]
pub(crate) struct TestComponent {
    value: usize,
}

impl TestValue for TestComponent {
    fn value(&mut self) -> &mut usize {
        &mut self.value
    }
}

impl RenderOnce for TestComponent {
    fn render(self, _window: &mut Window, _cx: &mut App) -> impl IntoElement {
        div().size(px(24.))
    }
}
