//! Explicit label/control/help composition without descendant discovery.
use crate::{
    Label, Space, Theme,
    recipe::{Recipe, style},
};
use gpui::El;
pub struct Field<'a> {
    label: El<'a>,
    control: El<'a>,
    help: Option<El<'a>>,
    theme: &'a Theme,
}
impl<'a> Field<'a> {
    pub fn new(label: &'a str, control: El<'a>, theme: &'a Theme) -> Self {
        Self {
            label: Label::new(label, theme).build(),
            control,
            help: None,
            theme,
        }
    }
    pub fn help(mut self, text: &'a str) -> Self {
        self.help = Some(
            gpui::text(text)
                .fg(self.theme.muted())
                .font_size(self.theme.rem(6.0 / 7.0)),
        );
        self
    }
    pub fn error(mut self, text: &'a str) -> Self {
        self.help = Some(
            gpui::text(text)
                .fg(self.theme.danger())
                .font_size(self.theme.rem(6.0 / 7.0)),
        );
        self
    }
    pub fn label(mut self, recipe: impl Recipe<'a>) -> Self {
        self.label = style(self.label, recipe);
        self
    }
    pub fn build(self) -> El<'a> {
        gpui::column((self.label, self.control, self.help)).gap(self.theme.space(Space::Part))
    }
}
