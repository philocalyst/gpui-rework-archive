//! Shared inline styling for rich text and editable-text decorations.

use crate::rich_text::{Affinity, RangeError, RangeSet, Span};
use gpui::{
    ColorExt, Font, FontFallbacks, FontFeatures, FontStyle, FontWeight, HighlightStyle, Hsla,
    Pixels, SharedString, StrikethroughStyle, TextRun, TextStyle, UnderlineStyle,
};
use palette::IntoColor;
use std::{collections::BTreeSet, fmt};

/// How an inline color property is applied to the inherited foreground.
#[derive(Clone, Copy, Debug, PartialEq)]
pub enum InlineColor {
    /// Replace the inherited foreground color.
    Replace(Hsla),
    /// Blend a GPUI `HighlightStyle` color over the inherited foreground.
    Blend(Hsla),
    /// Return to the inherited foreground color.
    Reset,
}

/// A composable set of inline text properties.
///
/// Each property is optional. When ranges overlap, the last range in `RangeSet` insertion order
/// that sets a property wins. Properties from separate ranges compose, so a color annotation can
/// coexist with bold, background, underline, or font-family styling.
#[derive(Clone, Default, PartialEq)]
pub struct InlineStyle {
    /// The foreground text color.
    pub color: Option<InlineColor>,
    /// The background color. The inner `None` explicitly clears an inherited background.
    pub background_color: Option<Option<Hsla>>,
    /// The font family.
    pub font_family: Option<Option<SharedString>>,
    /// OpenType features for the font.
    pub font_features: Option<FontFeatures>,
    /// Fallback fonts. `Some(None)` explicitly clears inherited fallbacks.
    pub font_fallbacks: Option<Option<FontFallbacks>>,
    /// The font weight.
    pub font_weight: Option<FontWeight>,
    /// The font style.
    pub font_style: Option<FontStyle>,
    /// Underline styling. `Some(None)` explicitly clears an inherited underline.
    pub underline: Option<Option<UnderlineStyle>>,
    /// Strikethrough styling. `Some(None)` explicitly clears an inherited strikethrough.
    pub strikethrough: Option<Option<StrikethroughStyle>>,
    /// Letter spacing. `Some(None)` explicitly clears inherited letter spacing.
    pub letter_spacing: Option<Option<Pixels>>,
    /// A fade factor applied to the resolved foreground color.
    pub fade_out: Option<f32>,
}

impl fmt::Debug for InlineStyle {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("InlineStyle")
            .field("color", &self.color)
            .field("background_color", &self.background_color)
            .field("font_family", &self.font_family)
            .field(
                "font_features",
                &self.font_features.as_ref().map(|features| &features.0),
            )
            .field("font_fallbacks", &self.font_fallbacks)
            .field("font_weight", &self.font_weight)
            .field("font_style", &self.font_style)
            .field("underline", &self.underline)
            .field("strikethrough", &self.strikethrough)
            .field("letter_spacing", &self.letter_spacing)
            .field("fade_out", &self.fade_out)
            .finish()
    }
}

impl InlineStyle {
    /// Sets the foreground color.
    pub fn color(mut self, color: impl IntoColor<Hsla>) -> Self {
        self.color = Some(InlineColor::Replace(color.into_color()));
        self
    }

    /// Returns to the inherited foreground color, clearing an earlier inline override.
    pub fn clear_color(mut self) -> Self {
        self.color = Some(InlineColor::Reset);
        self
    }

    /// Sets the background color.
    pub fn background(mut self, color: impl IntoColor<Hsla>) -> Self {
        self.background_color = Some(Some(color.into_color()));
        self
    }

    /// Clears a background set by the base style or an earlier overlapping range.
    pub fn clear_background(mut self) -> Self {
        self.background_color = Some(None);
        self
    }

    /// Sets the font family.
    pub fn font_family(mut self, family: impl Into<SharedString>) -> Self {
        self.font_family = Some(Some(family.into()));
        self
    }

    /// Returns to the inherited font family, clearing an earlier inline override.
    pub fn clear_font_family(mut self) -> Self {
        self.font_family = Some(None);
        self
    }

    /// Sets the OpenType font features.
    pub fn font_features(mut self, features: FontFeatures) -> Self {
        self.font_features = Some(features);
        self
    }

    /// Sets fallback fonts, or clears them when passed `None`.
    pub fn font_fallbacks(mut self, fallbacks: Option<FontFallbacks>) -> Self {
        self.font_fallbacks = Some(fallbacks);
        self
    }

    /// Sets the font weight.
    pub fn font_weight(mut self, weight: impl Into<FontWeight>) -> Self {
        self.font_weight = Some(weight.into());
        self
    }

    /// Applies bold weight.
    pub fn bold(self) -> Self {
        self.font_weight(FontWeight::BOLD)
    }

    /// Sets the font style.
    pub fn font_style(mut self, style: FontStyle) -> Self {
        self.font_style = Some(style);
        self
    }

    /// Applies italic style.
    pub fn italic(self) -> Self {
        self.font_style(FontStyle::Italic)
    }

    /// Copies all font properties from a native GPUI font.
    pub fn font(mut self, font: Font) -> Self {
        self.font_family = Some(Some(font.family));
        self.font_features = Some(font.features);
        self.font_fallbacks = Some(font.fallbacks);
        self.font_weight = Some(font.weight);
        self.font_style = Some(font.style);
        self
    }

    /// Sets underline styling.
    pub fn underline(mut self, style: UnderlineStyle) -> Self {
        self.underline = Some(Some(style));
        self
    }

    /// Applies the default underline style.
    pub fn underlined(self) -> Self {
        self.underline(UnderlineStyle::default())
    }

    /// Clears an underline set by the base style or an earlier overlapping range.
    pub fn clear_underline(mut self) -> Self {
        self.underline = Some(None);
        self
    }

    /// Sets strikethrough styling.
    pub fn strikethrough(mut self, style: StrikethroughStyle) -> Self {
        self.strikethrough = Some(Some(style));
        self
    }

    /// Applies the default strikethrough style.
    pub fn struck_through(self) -> Self {
        self.strikethrough(StrikethroughStyle::default())
    }

    /// Clears strikethrough set by the base style or an earlier overlapping range.
    pub fn clear_strikethrough(mut self) -> Self {
        self.strikethrough = Some(None);
        self
    }

    /// Sets letter spacing.
    pub fn letter_spacing(mut self, spacing: impl Into<Pixels>) -> Self {
        self.letter_spacing = Some(Some(spacing.into()));
        self
    }

    /// Clears letter spacing set by the base style or an earlier overlapping range.
    pub fn clear_letter_spacing(mut self) -> Self {
        self.letter_spacing = Some(None);
        self
    }

    /// Fades the resolved foreground color by a factor from zero to one.
    pub fn fade_out(mut self, factor: f32) -> Self {
        self.fade_out = Some(factor);
        self
    }

    /// Clears a fade-out set by an earlier overlapping style.
    pub fn clear_fade_out(mut self) -> Self {
        self.fade_out = Some(0.);
        self
    }

    /// Adds the properties present in a GPUI highlight style.
    ///
    /// Its color uses GPUI's native alpha-blend behavior over the inherited text color.
    pub fn highlight(mut self, highlight: HighlightStyle) -> Self {
        if let Some(value) = highlight.color {
            self.color = Some(InlineColor::Blend(value));
        }
        if let Some(value) = highlight.background_color {
            self.background_color = Some(Some(value));
        }
        if let Some(value) = highlight.font_weight {
            self.font_weight = Some(value);
        }
        if let Some(value) = highlight.font_style {
            self.font_style = Some(value);
        }
        if let Some(value) = highlight.underline {
            self.underline = Some(Some(value));
        }
        if let Some(value) = highlight.strikethrough {
            self.strikethrough = Some(Some(value));
        }
        if let Some(value) = highlight.fade_out {
            self.fade_out = Some(value);
        }
        self
    }

    /// Returns the properties representable as a GPUI highlight style.
    ///
    /// A replacement or reset color is omitted because `HighlightStyle` always alpha-blends its
    /// color over the inherited foreground. Colors added through [`InlineStyle::highlight`] keep
    /// that native blend behavior.
    pub fn as_highlight(&self) -> HighlightStyle {
        HighlightStyle {
            color: self.color.and_then(|color| match color {
                InlineColor::Blend(color) => Some(color),
                InlineColor::Replace(_) | InlineColor::Reset => None,
            }),
            font_weight: self.font_weight,
            font_style: self.font_style,
            background_color: self.background_color.flatten(),
            underline: self.underline.flatten(),
            strikethrough: self.strikethrough.flatten(),
            fade_out: self.fade_out,
        }
    }

    /// Composes `later` over this style, replacing only properties it explicitly sets.
    pub fn then(&self, later: &Self) -> Self {
        Self {
            color: later.color.or(self.color),
            background_color: later.background_color.or(self.background_color),
            font_family: later
                .font_family
                .clone()
                .or_else(|| self.font_family.clone()),
            font_features: later
                .font_features
                .clone()
                .or_else(|| self.font_features.clone()),
            font_fallbacks: later
                .font_fallbacks
                .clone()
                .or_else(|| self.font_fallbacks.clone()),
            font_weight: later.font_weight.or(self.font_weight),
            font_style: later.font_style.or(self.font_style),
            underline: later.underline.or(self.underline),
            strikethrough: later.strikethrough.or(self.strikethrough),
            letter_spacing: later.letter_spacing.or(self.letter_spacing),
            fade_out: later.fade_out.or(self.fade_out),
        }
    }

    fn to_run(&self, len: usize, base: &TextStyle) -> TextRun {
        let mut font = base.font();
        if let Some(Some(value)) = &self.font_family {
            font.family = value.clone();
        }
        if let Some(value) = &self.font_features {
            font.features = value.clone();
        }
        if let Some(value) = &self.font_fallbacks {
            font.fallbacks = value.clone();
        }
        if let Some(value) = self.font_weight {
            font.weight = value;
        }
        if let Some(value) = self.font_style {
            font.style = value;
        }

        let mut color = match self.color {
            Some(InlineColor::Replace(color)) => color,
            Some(InlineColor::Blend(color)) => base.color.blend(&color),
            Some(InlineColor::Reset) | None => base.color,
        };
        if let Some(factor) = self.fade_out {
            color.fade_out(factor);
        }

        TextRun {
            len,
            font,
            color,
            background_color: self.background_color.unwrap_or(base.background_color),
            underline: self.underline.unwrap_or(base.underline),
            strikethrough: self.strikethrough.unwrap_or(base.strikethrough),
            letter_spacing: self.letter_spacing.unwrap_or(base.letter_spacing),
        }
    }
}

impl From<HighlightStyle> for InlineStyle {
    fn from(highlight: HighlightStyle) -> Self {
        Self::default().highlight(highlight)
    }
}

/// Converts a range set into coalesced GPUI text runs using a byte-range sweep.
impl RangeSet<InlineStyle> {
    /// Validates ranges against `text` and lowers them to coalesced native text runs.
    pub fn text_runs(&self, text: &str, base: &TextStyle) -> Result<Vec<TextRun>, RangeError> {
        self.validate(text)?;
        if text.is_empty() {
            return Ok(Vec::new());
        }

        let mut events = Vec::with_capacity(self.len() * 2);
        for (index, span) in self.iter().enumerate() {
            if span.is_point() {
                continue;
            }
            events.push(Event {
                offset: span.range.start,
                index,
                starts: true,
            });
            events.push(Event {
                offset: span.range.end,
                index,
                starts: false,
            });
        }
        events.sort_by_key(|event| (event.offset, event.starts, event.index));

        let mut active = ActiveProperties::default();
        let mut runs = Vec::with_capacity(events.len() + 1);
        let mut cursor = 0;
        let mut event_index = 0;
        while event_index < events.len() {
            let offset = events[event_index].offset;
            if cursor < offset {
                push_run(
                    &mut runs,
                    active.resolve(self).to_run(offset - cursor, base),
                );
            }
            while event_index < events.len() && events[event_index].offset == offset {
                let event = events[event_index];
                active.update(event.index, self[event.index].value(), event.starts);
                event_index += 1;
            }
            cursor = offset;
        }
        if cursor < text.len() {
            push_run(
                &mut runs,
                active.resolve(self).to_run(text.len() - cursor, base),
            );
        }
        Ok(runs)
    }
}

#[derive(Clone, Copy)]
struct Event {
    offset: usize,
    index: usize,
    starts: bool,
}

#[derive(Default)]
struct ActiveProperties {
    color: BTreeSet<usize>,
    background: BTreeSet<usize>,
    family: BTreeSet<usize>,
    features: BTreeSet<usize>,
    fallbacks: BTreeSet<usize>,
    weight: BTreeSet<usize>,
    style: BTreeSet<usize>,
    underline: BTreeSet<usize>,
    strikethrough: BTreeSet<usize>,
    letter_spacing: BTreeSet<usize>,
    fade_out: BTreeSet<usize>,
}

impl ActiveProperties {
    fn update(&mut self, index: usize, style: &InlineStyle, starts: bool) {
        macro_rules! update {
            ($set:ident, $field:ident) => {
                if style.$field.is_some() {
                    if starts {
                        self.$set.insert(index);
                    } else {
                        self.$set.remove(&index);
                    }
                }
            };
        }
        update!(color, color);
        update!(background, background_color);
        update!(family, font_family);
        update!(features, font_features);
        update!(fallbacks, font_fallbacks);
        update!(weight, font_weight);
        update!(style, font_style);
        update!(underline, underline);
        update!(strikethrough, strikethrough);
        update!(letter_spacing, letter_spacing);
        update!(fade_out, fade_out);
    }

    fn resolve(&self, ranges: &RangeSet<InlineStyle>) -> InlineStyle {
        fn latest<T>(
            active: &BTreeSet<usize>,
            ranges: &RangeSet<InlineStyle>,
            property: impl Fn(&InlineStyle) -> Option<T>,
        ) -> Option<T> {
            active
                .last()
                .and_then(|&index| property(ranges[index].value()))
        }

        InlineStyle {
            color: latest(&self.color, ranges, |style| style.color),
            background_color: latest(&self.background, ranges, |style| style.background_color),
            font_family: latest(&self.family, ranges, |style| style.font_family.clone()),
            font_features: latest(&self.features, ranges, |style| style.font_features.clone()),
            font_fallbacks: latest(&self.fallbacks, ranges, |style| {
                style.font_fallbacks.clone()
            }),
            font_weight: latest(&self.weight, ranges, |style| style.font_weight),
            font_style: latest(&self.style, ranges, |style| style.font_style),
            underline: latest(&self.underline, ranges, |style| style.underline),
            strikethrough: latest(&self.strikethrough, ranges, |style| style.strikethrough),
            letter_spacing: latest(&self.letter_spacing, ranges, |style| style.letter_spacing),
            fade_out: latest(&self.fade_out, ranges, |style| style.fade_out),
        }
    }
}

fn push_run(runs: &mut Vec<TextRun>, run: TextRun) {
    if let Some(previous) = runs.last_mut()
        && same_run_style(previous, &run)
    {
        previous.len += run.len;
    } else {
        runs.push(run);
    }
}

fn same_run_style(left: &TextRun, right: &TextRun) -> bool {
    left.font == right.font
        && left.color == right.color
        && left.background_color == right.background_color
        && left.underline == right.underline
        && left.strikethrough == right.strikethrough
        && left.letter_spacing == right.letter_spacing
}

/// An immutable rich-text value with typed inline annotations.
#[derive(Clone, Debug)]
pub struct RichText {
    text: SharedString,
    ranges: RangeSet<InlineStyle>,
}

impl RichText {
    /// Starts a rich-text builder.
    pub fn new() -> RichTextBuilder {
        RichTextBuilder::default()
    }

    /// Creates rich text from an existing shared string and inline annotations.
    ///
    /// The range set is validated against the UTF-8 byte boundaries of `text`, then retained
    /// directly so callers can construct immutable parser or document snapshots without copying
    /// their annotation payloads.
    pub fn try_from_parts(
        text: impl Into<SharedString>,
        ranges: RangeSet<InlineStyle>,
    ) -> Result<Self, RangeError> {
        let text = text.into();
        ranges.validate(text.as_ref())?;
        Ok(Self { text, ranges })
    }

    /// Returns the UTF-8 text.
    pub fn as_str(&self) -> &str {
        self.text.as_ref()
    }

    /// Returns a cheap clone of the shared text buffer.
    pub fn shared_string(&self) -> SharedString {
        self.text.clone()
    }

    /// Returns the inline annotations in authoring order.
    pub fn ranges(&self) -> &RangeSet<InlineStyle> {
        &self.ranges
    }

    /// Lowers this builder-created rich text to GPUI's native text runs.
    pub fn text_runs(&self, base: &TextStyle) -> Vec<TextRun> {
        self.ranges
            .text_runs(self.as_str(), base)
            .expect("RichText builders only create valid UTF-8 ranges")
    }
}

impl From<&str> for RichText {
    fn from(text: &str) -> Self {
        Self {
            text: SharedString::from(text),
            ranges: RangeSet::default(),
        }
    }
}

impl From<String> for RichText {
    fn from(text: String) -> Self {
        Self {
            text: SharedString::from(text),
            ranges: RangeSet::default(),
        }
    }
}

/// A fluent builder for [`RichText`].
#[derive(Debug, Default)]
pub struct RichTextBuilder {
    text: String,
    spans: Vec<Span<InlineStyle>>,
    identity: std::sync::Arc<u8>,
}

impl RichTextBuilder {
    /// Appends plain text.
    pub fn text(mut self, text: impl AsRef<str>) -> Self {
        self.text.push_str(text.as_ref());
        self
    }

    /// Appends text carrying one inline style.
    pub fn span(mut self, text: impl AsRef<str>, style: impl Into<InlineStyle>) -> Self {
        self.append_span(text.as_ref(), style.into());
        self
    }

    /// Appends a finished rich-text fragment, retaining its annotations at shifted byte offsets.
    pub fn rich_text(mut self, fragment: RichText) -> Self {
        self.push_rich_text(&fragment);
        self
    }

    /// Alias for [`RichTextBuilder::rich_text`].
    pub fn append(self, fragment: RichText) -> Self {
        self.rich_text(fragment)
    }

    /// Applies a style to everything appended by the scoped builder closure.
    ///
    /// Nested calls compose in order: the scope's properties apply first and styles added inside
    /// the closure override them property by property.
    pub fn styled(mut self, style: impl Into<InlineStyle>, add: impl FnOnce(&mut Self)) -> Self {
        self.push_styled(style, add);
        self
    }

    /// Applies a style to text appended by a nested mutable scope.
    pub fn push_styled(
        &mut self,
        style: impl Into<InlineStyle>,
        add: impl FnOnce(&mut Self),
    ) -> &mut Self {
        let start = self.text.len();
        let style_index = self.spans.len();
        let identity = self.identity.clone();
        let style = style.into();
        self.spans.push(Span::new(
            start..start,
            Affinity::Before,
            Affinity::After,
            style.clone(),
        ));
        add(self);
        if !std::sync::Arc::ptr_eq(&identity, &self.identity) {
            // A closure can legally replace the builder through its mutable reference. In that
            // case, scope the replacement's whole output and insert its style before inner spans.
            let end = self.text.len();
            self.spans.insert(
                0,
                Span::new(0..end, Affinity::Before, Affinity::After, style),
            );
            return self;
        }
        self.spans[style_index].range = start..self.text.len();
        self
    }

    /// Appends text to this builder from inside a scoped closure.
    pub fn push_text(&mut self, text: impl AsRef<str>) -> &mut Self {
        self.text.push_str(text.as_ref());
        self
    }

    /// Appends styled text to this builder from inside a scoped closure.
    pub fn push_span(&mut self, text: impl AsRef<str>, style: impl Into<InlineStyle>) -> &mut Self {
        self.append_span(text.as_ref(), style.into());
        self
    }

    /// Appends a finished fragment while sharing its annotation payloads.
    pub fn push_rich_text(&mut self, fragment: &RichText) -> &mut Self {
        let offset = self.text.len();
        self.text.push_str(fragment.as_str());
        self.spans
            .extend(fragment.ranges.iter().map(|span| span.shifted(offset)));
        self
    }

    fn append_span(&mut self, text: &str, style: InlineStyle) {
        let start = self.text.len();
        self.text.push_str(text);
        let end = self.text.len();
        self.spans.push(Span::new(
            start..end,
            Affinity::Before,
            Affinity::After,
            style,
        ));
    }

    /// Finishes the rich-text value.
    pub fn finish(self) -> RichText {
        RichText {
            text: SharedString::from(self.text),
            ranges: RangeSet::new(self.spans),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui::hsla;

    #[test]
    fn overlapping_properties_compose_and_later_values_win() {
        let text = "abcdefg";
        let red = hsla(0., 1., 0.5, 1.);
        let blue = hsla(0.66, 1., 0.5, 1.);
        let yellow = hsla(0.16, 1., 0.5, 1.);
        let ranges = RangeSet::new([
            Span::new(
                0..5,
                Affinity::Before,
                Affinity::After,
                InlineStyle::default().color(red).bold(),
            ),
            Span::new(
                2..7,
                Affinity::Before,
                Affinity::After,
                InlineStyle::default().color(blue),
            ),
            Span::new(
                3..4,
                Affinity::Before,
                Affinity::After,
                InlineStyle::default().background(yellow),
            ),
        ]);

        let runs = ranges.text_runs(text, &TextStyle::default()).unwrap();
        assert_eq!(
            runs.iter().map(|run| run.len).collect::<Vec<_>>(),
            [2, 1, 1, 1, 2]
        );
        assert_eq!(runs[0].color, red);
        assert_eq!(runs[0].font.weight, FontWeight::BOLD);
        assert_eq!(runs[1].color, blue);
        assert_eq!(runs[1].font.weight, FontWeight::BOLD);
        assert_eq!(runs[2].color, blue);
        assert_eq!(runs[2].background_color, Some(yellow));
        assert_eq!(runs[2].font.weight, FontWeight::BOLD);
        assert_eq!(runs[3].color, blue);
        assert_eq!(runs[3].font.weight, FontWeight::BOLD);
        assert_eq!(runs[4].color, blue);
        assert_eq!(runs[4].font.weight, FontWeight::NORMAL);
    }

    #[test]
    fn scoped_builder_orders_outer_style_before_nested_styles() {
        let rich = RichText::new()
            .text("a")
            .styled(InlineStyle::default().bold(), |rich| {
                rich.push_text("bc")
                    .push_span("d", InlineStyle::default().color(hsla(0., 1., 0.5, 1.)));
            })
            .text("e")
            .finish();
        let runs = rich.text_runs(&TextStyle::default());

        assert_eq!(rich.as_str(), "abcde");
        assert_eq!(
            runs.iter().map(|run| run.len).collect::<Vec<_>>(),
            [1, 2, 1, 1]
        );
        assert_eq!(runs[1].font.weight, FontWeight::BOLD);
        assert_eq!(runs[2].font.weight, FontWeight::BOLD);
        assert_eq!(runs[2].color, hsla(0., 1., 0.5, 1.));
        assert_eq!(runs[3].font.weight, FontWeight::NORMAL);
    }

    #[test]
    fn text_runs_use_utf8_byte_lengths_for_non_bmp_text() {
        let rich = RichText::new()
            .text("a")
            .span("😀", InlineStyle::default().italic())
            .text("b")
            .finish();
        let runs = rich.text_runs(&TextStyle::default());
        assert_eq!(
            runs.iter().map(|run| run.len).collect::<Vec<_>>(),
            [1, 4, 1]
        );
        assert_eq!(runs[1].font.style, FontStyle::Italic);
    }

    #[test]
    fn nested_scopes_can_reset_color_and_font_to_the_inherited_style() {
        let inherited_color = hsla(0.55, 0.4, 0.3, 1.);
        let outer_color = hsla(0., 1., 0.5, 1.);
        let mut base = TextStyle::default();
        base.color = inherited_color;
        base.font_family = "base-family".into();

        let rich = RichText::new()
            .styled(
                InlineStyle::default()
                    .color(outer_color)
                    .font_family("outer-family"),
                |rich| {
                    rich.push_text("a").push_styled(
                        InlineStyle::default().clear_color().clear_font_family(),
                        |rich| {
                            rich.push_text("b");
                        },
                    );
                },
            )
            .finish();
        let runs = rich.text_runs(&base);

        assert_eq!(runs[0].color, outer_color);
        assert_eq!(runs[0].font.family.as_ref(), "outer-family");
        assert_eq!(runs[1].color, inherited_color);
        assert_eq!(runs[1].font.family.as_ref(), "base-family");
    }

    #[test]
    fn appending_rich_and_empty_fragments_shifts_and_shares_annotations() {
        let fragment = RichText::new()
            .span("xy", InlineStyle::default().color(hsla(0., 1., 0.5, 1.)))
            .finish();
        let empty = RichText::new()
            .styled(InlineStyle::default().italic(), |_rich| {})
            .finish();

        let rich = RichText::new()
            .text("!")
            .styled(InlineStyle::default().bold(), |rich| {
                rich.push_rich_text(&fragment).push_rich_text(&empty);
            })
            .text("!")
            .finish();
        let runs = rich.text_runs(&TextStyle::default());

        assert_eq!(rich.as_str(), "!xy!");
        assert_eq!(rich.ranges()[0].range, 1..3); // the enclosing bold scope
        assert_eq!(rich.ranges()[1].range, 1..3); // shifted fragment span
        assert_eq!(rich.ranges()[2].range, 3..3); // explicit point from the empty fragment
        assert!(std::ptr::eq(
            fragment.ranges()[0].value(),
            rich.ranges()[1].value()
        ));
        assert_eq!(
            runs.iter().map(|run| run.len).collect::<Vec<_>>(),
            [1, 2, 1]
        );
        assert_eq!(runs[1].font.weight, FontWeight::BOLD);
    }

    #[test]
    fn scoped_builder_replacement_keeps_outer_style_without_using_stale_indices() {
        let red = hsla(0., 1., 0.5, 1.);
        let rich = RichText::new()
            .text("discarded")
            .styled(InlineStyle::default().bold(), |builder| {
                *builder = RichTextBuilder::default()
                    .text("new ")
                    .span("text", InlineStyle::default().color(red));
            })
            .finish();
        let runs = rich.text_runs(&TextStyle::default());

        assert_eq!(rich.as_str(), "new text");
        assert_eq!(rich.ranges()[0].range, 0..8);
        assert_eq!(rich.ranges()[1].range, 4..8);
        assert_eq!(runs[0].font.weight, FontWeight::BOLD);
        assert_eq!(runs[1].font.weight, FontWeight::BOLD);
        assert_eq!(runs[1].color, red);
    }

    #[test]
    fn highlight_colors_use_native_alpha_blending() {
        let base_color = hsla(0.55, 0.4, 0.3, 1.);
        let overlay = hsla(0., 1., 0.5, 0.4);
        let mut base = TextStyle::default();
        base.color = base_color;
        let style = InlineStyle::default().highlight(HighlightStyle {
            color: Some(overlay),
            ..HighlightStyle::default()
        });
        let ranges = RangeSet::new([Span::new(0..1, Affinity::Before, Affinity::After, style)]);
        let runs = ranges.text_runs("x", &base).unwrap();

        assert_eq!(runs[0].color, base_color.blend(&overlay));
    }

    #[test]
    fn try_from_parts_validates_utf8_and_preserves_shared_data_and_resets() {
        let base_color = hsla(0.55, 0.4, 0.3, 1.);
        let mut base = TextStyle::default();
        base.color = base_color;
        base.font_family = "base-family".into();

        let payload = std::sync::Arc::new(
            InlineStyle::default()
                .clear_color()
                .clear_font_family()
                .italic(),
        );
        let ranges = RangeSet::new([Span::shared(
            0..4,
            Affinity::Before,
            Affinity::After,
            payload.clone(),
        )]);
        let shared = SharedString::from("😀");
        let rich = RichText::try_from_parts(shared.clone(), ranges).unwrap();

        assert_eq!(rich.shared_string(), shared);
        assert!(std::sync::Arc::ptr_eq(
            &payload,
            &rich.ranges()[0].shared_value()
        ));
        let run = &rich.text_runs(&base)[0];
        assert_eq!(run.len, 4);
        assert_eq!(run.color, base_color);
        assert_eq!(run.font.family.as_ref(), "base-family");
        assert_eq!(run.font.style, FontStyle::Italic);

        let invalid_ranges = RangeSet::new([Span::new(
            1..4,
            Affinity::Before,
            Affinity::After,
            InlineStyle::default().bold(),
        )]);
        assert_eq!(
            RichText::try_from_parts("😀", invalid_ranges).unwrap_err(),
            RangeError::NotCharBoundary { offset: 1 }
        );
    }
}
