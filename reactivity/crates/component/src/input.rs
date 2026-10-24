//! A single-line writable signal with an explicit frame/control styling seam.
use crate::{
    Size, Theme,
    recipe::{Recipe, style},
};
use gpui::{BoolBinding, BoolInput, El, IntoProp, Signal};

pub struct InputParts<'a> {
    frame: El<'a>,
    control: El<'a>,
}
impl<'a> InputParts<'a> {
    pub fn frame(mut self, recipe: impl Recipe<'a>) -> Self {
        self.frame = style(self.frame, recipe);
        self
    }
    pub fn control(mut self, recipe: impl Recipe<'a>) -> Self {
        self.control = style(self.control, recipe);
        self
    }
}
pub struct Input<'a> {
    parts: InputParts<'a>,
    theme: &'a Theme,
}
impl<'a> Input<'a> {
    /// `value` must be registered in the surrounding View's source schema.
    pub fn new(value: &'a Signal<String>, name: &'a str, theme: &'a Theme) -> Self {
        Self {
            parts: InputParts {
                frame: gpui::div()
                    .bg(theme.border())
                    .rounded(theme.radius())
                    .p(theme.rem(1.0 / 14.0)),
                control: gpui::text_input(value)
                    .name(name)
                    .focus_indicator(theme.focus())
                    .bg(theme.surface())
                    .fg(theme.foreground())
                    .rounded((theme.radius() - 1.0).max(0.0)),
            },
            theme,
        }
        .with_size(Size::Medium)
    }
    pub fn with_size(mut self, size: Size) -> Self {
        self.parts.control = self
            .parts
            .control
            .h(self.theme.control_height(size))
            .p(self.theme.rem(4.0 / 7.0))
            .font_size(self.theme.control_font(size));
        self
    }
    pub fn invalid(mut self, invalid: impl IntoProp<'a, bool>) -> Self {
        let binding = BoolBinding::new(invalid);
        let invalid = binding.state();
        self.parts.control = binding.attach(self.parts.control.invalid(invalid));
        self.parts.frame = self
            .parts
            .frame
            .bg(invalid.select(self.theme.border(), self.theme.danger()));
        self
    }
    pub fn disabled(mut self, disabled: impl IntoProp<'a, bool>) -> Self {
        let binding = BoolBinding::new(disabled);
        let disabled = binding.state();
        self.parts.control = binding.attach(self.parts.control.disabled(disabled));
        self.parts.control = self
            .parts
            .control
            .fg(disabled.select(self.theme.foreground(), self.theme.muted()));
        self
    }
    pub fn description(mut self, description: &'a str) -> Self {
        self.parts.control = self.parts.control.description(description);
        self
    }
    pub fn parts(mut self, customize: impl FnOnce(InputParts<'a>) -> InputParts<'a>) -> Self {
        self.parts = customize(self.parts);
        self
    }
    pub fn build(self) -> El<'a> {
        self.parts.frame.child(self.parts.control)
    }
}
