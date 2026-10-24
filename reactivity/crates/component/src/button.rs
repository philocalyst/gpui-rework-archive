//! Semantic application commands. The caller owns enabled policy and effects.
use crate::{
    Size, Theme,
    recipe::{Recipe, style},
};
use gpui::{BoolInput, El, IntoHandler, IntoText};

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
    variant: ButtonVariant,
}
impl<'a> Button<'a> {
    pub fn new(label: impl IntoText<'a>, theme: &'a Theme) -> Self {
        Self {
            element: gpui::button(label).focus_indicator(theme.focus()),
            theme,
            variant: ButtonVariant::Default,
        }
        .variant(ButtonVariant::Default)
        .with_size(Size::Medium)
    }
    pub fn variant(mut self, variant: ButtonVariant) -> Self {
        self.variant = variant;
        let (bg, fg) = Self::colors(self.theme, variant);
        self.element = self.element.bg(bg).fg(fg).rounded(self.theme.radius());
        self
    }
    fn colors(theme: &Theme, variant: ButtonVariant) -> (gpui::Color, gpui::Color) {
        match variant {
            ButtonVariant::Default => (theme.raised(), theme.foreground()),
            ButtonVariant::Primary => (theme.accent(), theme.on_accent()),
            ButtonVariant::Ghost => (theme.surface(), theme.foreground()),
            ButtonVariant::Danger => (theme.danger(), theme.on_accent()),
        }
    }
    pub fn with_size(mut self, size: Size) -> Self {
        self.element = self
            .element
            .h(self.theme.control_height(size))
            .p(self.theme.rem(4.0 / 7.0))
            .font_size(self.theme.control_font(size));
        self
    }
    pub fn disabled(mut self, disabled: impl BoolInput<'a>) -> Self {
        self.element = self.element.disabled(disabled);
        self.element = self
            .element
            .fg(disabled.select(Self::colors(self.theme, self.variant).1, self.theme.muted()));
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
