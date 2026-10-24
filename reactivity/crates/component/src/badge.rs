//! Short semantic status; ordinary metadata should remain ordinary text.
use crate::{
    Space, Theme,
    recipe::{Recipe, style},
};
use gpui::{El, IntoText};
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum Tone {
    #[default]
    Neutral,
    Success,
    Danger,
}
pub struct Badge<'a> {
    element: El<'a>,
    theme: &'a Theme,
}
impl<'a> Badge<'a> {
    pub fn new(text: impl IntoText<'a>, theme: &'a Theme) -> Self {
        Self {
            element: gpui::text(text)
                .bg(theme.raised())
                .fg(theme.foreground())
                .p(theme.space(Space::Part))
                .rounded(theme.radius() / 2.0)
                .font_size(theme.rem(6.0 / 7.0)),
            theme,
        }
    }
    pub fn tone(mut self, tone: Tone) -> Self {
        self.element = self.element.fg(match tone {
            Tone::Neutral => self.theme.foreground(),
            Tone::Success => self.theme.success(),
            Tone::Danger => self.theme.danger(),
        });
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
