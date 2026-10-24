//! Controlled binary choice with typed, application-owned named parts.
use crate::{
    Space, Theme,
    recipe::{Recipe, style},
};
use gpui::{Align, BoolInput, Color, El, Flex, IntoHandler, Source};

/// The named parts are ordinary descriptions, never dynamic selectors.
///
/// ```compile_fail
/// use gpui_component::{Checkbox, Theme};
/// let theme = Theme::default();
/// Checkbox::new("Choice", false, &theme).parts(|parts| parts.thumb(|e| e));
/// ```
pub struct CheckboxParts<'a> {
    root: El<'a>,
    indicator: El<'a>,
    label: El<'a>,
}
impl<'a> CheckboxParts<'a> {
    pub fn root(mut self, recipe: impl Recipe<'a>) -> Self {
        self.root = style(self.root, recipe);
        self
    }
    pub fn indicator(mut self, recipe: impl Recipe<'a>) -> Self {
        self.indicator = style(self.indicator, recipe);
        self
    }
    pub fn label(mut self, recipe: impl Recipe<'a>) -> Self {
        self.label = style(self.label, recipe);
        self
    }
}
pub struct Checkbox<'a> {
    parts: CheckboxParts<'a>,
    theme: &'a Theme,
}
impl<'a> Checkbox<'a> {
    pub fn new(label: &'a str, checked: impl BoolInput<'a>, theme: &'a Theme) -> Self {
        let indicator = gpui::div()
            .size(theme.rem(8.0 / 7.0))
            .rounded(theme.radius() / 2.0)
            .p(theme.rem(1.0 / 7.0))
            .bg(checked.select(theme.border(), theme.accent()))
            .child({
                let unit = theme.rem(1.0 / 14.0) as f32;
                let stroke = |width, a, b, x, y| {
                    gpui::div()
                        .w(theme.rem(width / 14.0))
                        .h(theme.rem(2.0 / 14.0))
                        .bg(checked.select(Color::TRANSPARENT, theme.on_accent()))
                        .transform(gpui::Affine {
                            a,
                            b,
                            c: -b,
                            d: a,
                            tx: x * unit,
                            ty: y * unit,
                        })
                };
                gpui::div().size(theme.rem(6.0 / 7.0)).child((
                    stroke(4.0, 0.707, 0.707, 1.0, 4.0),
                    stroke(8.0, 0.707, -0.707, 3.0, 4.0),
                ))
            });
        Self {
            parts: CheckboxParts {
                root: gpui::checkbox("", checked)
                    .name(label)
                    .focus_indicator(theme.focus())
                    .layout(Flex::row().align(Align::Center))
                    .gap(theme.space(Space::Related))
                    .p(theme.space(Space::Part)),
                indicator,
                label: gpui::label(label)
                    .fg(theme.foreground())
                    .font_size(theme.font_size()),
            },
            theme,
        }
    }
    /// Report intent once. The controlled value changes only when its owner writes.
    pub fn on_change<M: 'static>(mut self, handler: impl Fn(&mut M, bool) + 'static) -> Self {
        self.parts.root = self.parts.root.on_check(handler);
        self
    }
    /// Default behavior for an explicitly registered owner-relative field.
    /// Pass `&Signal<bool>` for direct checked/appearance bindings. A by-value
    /// bool remains a snapshot and requires `Sources::field` (and component
    /// dependencies for parent snapshot branches).
    pub fn toggle<M: 'static>(mut self, source: Source<M, bool>) -> Self {
        self.parts.root = self
            .parts
            .root
            .on_click(source.update(|checked| *checked = !*checked));
        self
    }
    /// Advanced ordinary GPUI route; the last registration has sole authority.
    pub fn on_click<M: 'static, S>(mut self, handler: impl IntoHandler<M, S>) -> Self {
        self.parts.root = self.parts.root.on_click(handler);
        self
    }
    pub fn disabled(mut self, disabled: impl BoolInput<'a>) -> Self {
        self.parts.root = self.parts.root.disabled(disabled);
        // Disabled paint is a caller policy, expressed through the same input.
        self.parts.label = self
            .parts
            .label
            .fg(disabled.select(self.theme.foreground(), self.theme.muted()));
        self
    }
    pub fn parts(mut self, customize: impl FnOnce(CheckboxParts<'a>) -> CheckboxParts<'a>) -> Self {
        self.parts = customize(self.parts);
        self
    }
    pub fn build(self) -> El<'a> {
        self.parts
            .root
            .child((self.parts.indicator, self.parts.label))
    }
}
