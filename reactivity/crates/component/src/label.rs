//! Visible primary and secondary text. Field association stays explicit in Input.
use crate::{
    Space, Theme,
    recipe::{Recipe, style},
};
use gpui::{El, IntoText};
pub struct Label<'a> {
    element: El<'a>,
    theme: &'a Theme,
}
impl<'a> Label<'a> {
    pub fn new(text: impl IntoText<'a>, theme: &'a Theme) -> Self {
        Self {
            element: gpui::label(text)
                .fg(theme.foreground())
                .font_size(theme.font_size()),
            theme,
        }
    }
    pub fn secondary(self, text: impl IntoText<'a>) -> El<'a> {
        gpui::row((self.element, gpui::text(text).fg(self.theme.muted())))
            .gap(self.theme.space(Space::Related))
    }
    pub fn style(mut self, recipe: impl Recipe<'a>) -> Self {
        self.element = style(self.element, recipe);
        self
    }
    pub fn build(self) -> El<'a> {
        self.element
    }
}
