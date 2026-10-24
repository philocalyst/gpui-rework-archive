//! Semantic application commands. The caller owns enabled policy and effects.
use crate::{
    Size, Theme,
    recipe::{Recipe, style},
};
use gpui::{El, IntoHandler, IntoText};

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum ButtonVariant {
    #[default]
    Default,
    Primary,
    Ghost,
    Danger,
}

pub struct Button<'a> {
    element: El<'a>,
    theme: &'a Theme,
}
impl<'a> Button<'a> {
    pub fn new(label: impl IntoText<'a>, theme: &'a Theme) -> Self {
        Self {
            element: gpui::button(label).focus_indicator(theme.focus()),
            theme,
        }
        .variant(ButtonVariant::Default)
        .with_size(Size::Medium)
    }
    pub fn variant(mut self, variant: ButtonVariant) -> Self {
        let (bg, fg) = match variant {
            ButtonVariant::Default => (self.theme.raised(), self.theme.foreground()),
            ButtonVariant::Primary => (self.theme.accent(), self.theme.on_accent()),
            ButtonVariant::Ghost => (self.theme.surface(), self.theme.foreground()),
            ButtonVariant::Danger => (self.theme.danger(), self.theme.on_accent()),
        };
        self.element = self.element.bg(bg).fg(fg).rounded(self.theme.radius());
        self
    }
    pub fn with_size(mut self, size: Size) -> Self {
        self.element = self
            .element
            .h(self.theme.control_height(size))
            .p(self.theme.rem(4.0 / 7.0))
            .font_size(self.theme.control_font(size));
        self
    }
    pub fn disabled(mut self, disabled: bool) -> Self {
        self.element = self.element.disabled(disabled);
        if disabled {
            self.element = self.element.fg(self.theme.muted()).bg(self.theme.surface());
        }
        self
    }
    pub fn name(mut self, name: impl IntoText<'a>) -> Self {
        self.element = self.element.name(name);
        self
    }
    /// Install the sole activation route. Registering again replaces it.
    pub fn on_click<M: 'static, S>(mut self, handler: impl IntoHandler<M, S>) -> Self {
        self.element = self.element.on_click(handler);
        self
    }
    pub fn style(mut self, recipe: impl Recipe<'a>) -> Self {
        self.element = style(self.element, recipe);
        self
    }
    pub fn build(self) -> El<'a> {
        self.element
    }
}
