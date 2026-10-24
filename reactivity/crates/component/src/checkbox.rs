//! Controlled binary choice with typed, application-owned named parts.
use crate::{
    Space, Theme,
    recipe::{Recipe, style},
};
use gpui::{Align, El, Flex, IntoHandler, Source};

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
    checked: bool,
    theme: &'a Theme,
}
impl<'a> Checkbox<'a> {
    pub fn new(label: &'a str, checked: bool, theme: &'a Theme) -> Self {
        let indicator = gpui::div()
            .size(theme.rem(8.0 / 7.0))
            .rounded(theme.radius() / 2.0)
            .p(theme.rem(1.0 / 7.0))
            .bg(if checked {
                theme.accent()
            } else {
                theme.border()
            })
            .child(checked.then(|| {
                // A UI mark is geometry, independent of the application's font.
                // Both strokes scale with the same rem snapshot as the frame.
                let unit = theme.rem(1.0 / 14.0) as f32;
                let stroke = |width, a, b, x, y| {
                    gpui::div()
                        .w(theme.rem(width / 14.0))
                        .h(theme.rem(2.0 / 14.0))
                        .bg(theme.on_accent())
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
            }));
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
            checked,
            theme,
        }
    }
    /// Report intent once. The controlled value changes only when its owner writes.
    pub fn on_change<M: 'static>(mut self, handler: impl Fn(&mut M, bool) + 'static) -> Self {
        let next = !self.checked;
        self.parts.root = self
            .parts
            .root
            .on_click(move |model: &mut M| handler(model, next));
        self
    }
    /// Default behavior for an explicitly registered owner-relative field.
    /// `checked` is a snapshot: register its source with `Sources::field` (and
    /// parent snapshot reads with `Sources::component`) so writes re-describe
    /// the controlled value. A direct-only declaration cannot observe that read.
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
    pub fn disabled(mut self, disabled: bool) -> Self {
        self.parts.root = self.parts.root.disabled(disabled);
        if disabled {
            self.parts.label = self.parts.label.fg(self.theme.muted());
            self.parts.indicator = self.parts.indicator.bg(self.theme.raised());
        }
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
