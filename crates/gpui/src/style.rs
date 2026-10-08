//! Resolved style and style refinements used by GPUI's layout and paint pipeline.
//!
//! [`StyleRefinement`](crate::StyleRefinement) is the builder-facing, partial style: methods from
//! [`Styled`](crate::Styled) add fields to it and later refinements override earlier fields.
//! [`Style`] is the resolved value used for a frame. Resolution applies inherited text properties
//! and interaction-state refinements; it does not make layout or paint properties inherit.
//! Lengths are expressed in logical [`Pixels`] unless a type explicitly says otherwise; `rem`s
//! resolve from the window's configured root text size. Layout properties affect Taffy, which
//! computes bounds before paint properties are applied.
//!
//! For a property-by-property tour, start with the [layout constraints example](https://gpui-ce.github.io/examples/layout/#constraints),
//! then use the [drawing example](https://gpui-ce.github.io/examples/drawing/#paint) to see how
//! resolved bounds reach paint.

use crate::{
    AbsoluteLength, App, Background, BorderStyle, Bounds, ColorExt, ContentMask, Corners,
    CornersRefinement, CursorStyle, DefiniteLength, DevicePixels, Edges, EdgesRefinement, Font,
    FontFallbacks, FontFeatures, FontStyle, FontWeight, FontWidth, GridLocation, Length, Pixels,
    Point, PointRefinement, ScaledPixels, SharedString, Size, SizeRefinement, Styled, TextRun,
    Window, black, phi, point, px, quad, rems, size, transparent_black,
};
use collections::HashSet;
use palette::{Hsla, IntoColor, rgb::Rgba};
use refineable::Refineable;
use schemars::JsonSchema;
use serde::{Deserialize, Serialize};
use std::{iter, mem, ops::Range};

/// Use this struct for interfacing with the 'debug_below' styling from your own elements.
/// If a parent element has this style set on it, then this struct will be set as a global in
/// GPUI.
#[cfg(debug_assertions)]
pub struct DebugBelow;

#[cfg(debug_assertions)]
impl crate::Global for DebugBelow {}

/// How an image's dimensions fit its element's layout box.
///
/// `Contain`, `Cover`, and `ScaleDown` preserve aspect ratio and center the result.
/// `Fill` can distort it. Fitting computes bounds; clipping is a separate paint operation.
pub enum ObjectFit {
    /// Match the box's width and height, without preserving aspect ratio.
    Fill,
    /// Scale to the largest size that fits entirely inside the box, preserving aspect ratio.
    Contain,
    /// Scale to cover the whole box, preserving aspect ratio. Part of the image can extend
    /// outside the box; the caller determines clipping.
    Cover,
    /// Use the original dimensions if they fit; otherwise use [`Self::Contain`]. Never enlarge.
    ScaleDown,
    /// Keep the original dimensions at the box's top-left origin, without centering.
    None,
}

impl ObjectFit {
    /// Compute image placement from the destination box and nonzero source dimensions.
    ///
    /// Source device-pixel counts are treated numerically as logical pixels for `None` and
    /// `ScaleDown`; this method does not apply a window scale factor. `Cover` can return bounds
    /// larger than the destination, so the result is not necessarily contained in `bounds`.
    pub fn get_bounds(
        &self,
        bounds: Bounds<Pixels>,
        image_size: Size<DevicePixels>,
    ) -> Bounds<Pixels> {
        let image_size = image_size.map(|dimension| Pixels::from(u32::from(dimension)));
        let image_ratio = image_size.width / image_size.height;
        let bounds_ratio = bounds.size.width / bounds.size.height;

        match self {
            ObjectFit::Fill => bounds,
            ObjectFit::Contain => {
                let new_size = if bounds_ratio > image_ratio {
                    size(
                        image_size.width * (bounds.size.height / image_size.height),
                        bounds.size.height,
                    )
                } else {
                    size(
                        bounds.size.width,
                        image_size.height * (bounds.size.width / image_size.width),
                    )
                };

                Bounds {
                    origin: point(
                        bounds.origin.x + (bounds.size.width - new_size.width) / 2.0,
                        bounds.origin.y + (bounds.size.height - new_size.height) / 2.0,
                    ),
                    size: new_size,
                }
            }
            ObjectFit::ScaleDown => {
                // Check if the image is larger than the bounds in either dimension.
                if image_size.width > bounds.size.width || image_size.height > bounds.size.height {
                    // If the image is larger, use the same logic as Contain to scale it down.
                    let new_size = if bounds_ratio > image_ratio {
                        size(
                            image_size.width * (bounds.size.height / image_size.height),
                            bounds.size.height,
                        )
                    } else {
                        size(
                            bounds.size.width,
                            image_size.height * (bounds.size.width / image_size.width),
                        )
                    };

                    Bounds {
                        origin: point(
                            bounds.origin.x + (bounds.size.width - new_size.width) / 2.0,
                            bounds.origin.y + (bounds.size.height - new_size.height) / 2.0,
                        ),
                        size: new_size,
                    }
                } else {
                    // If the image is smaller than or equal to the container, display it at its original size,
                    // centered within the container.
                    let original_size = size(image_size.width, image_size.height);
                    Bounds {
                        origin: point(
                            bounds.origin.x + (bounds.size.width - original_size.width) / 2.0,
                            bounds.origin.y + (bounds.size.height - original_size.height) / 2.0,
                        ),
                        size: original_size,
                    }
                }
            }
            ObjectFit::Cover => {
                let new_size = if bounds_ratio > image_ratio {
                    size(
                        bounds.size.width,
                        image_size.height * (bounds.size.width / image_size.width),
                    )
                } else {
                    size(
                        image_size.width * (bounds.size.height / image_size.height),
                        bounds.size.height,
                    )
                };

                Bounds {
                    origin: point(
                        bounds.origin.x + (bounds.size.width - new_size.width) / 2.0,
                        bounds.origin.y + (bounds.size.height - new_size.height) / 2.0,
                    ),
                    size: new_size,
                }
            }
            ObjectFit::None => Bounds {
                origin: bounds.origin,
                size: image_size,
            },
        }
    }
}

/// A sizing preset for repeated grid columns or rows.
///
/// Despite the type name, [`Self::MaxContent`] changes the maximum as well as the minimum.
#[derive(
    Copy, Clone, PartialEq, Eq, PartialOrd, Ord, Debug, Default, JsonSchema, Serialize, Deserialize,
)]
pub enum GridTemplateMinSize {
    /// Use `minmax(0, 1fr)`: equal shares of free space, with no content-based minimum.
    #[default]
    Zero,
    /// Use `minmax(min-content, 1fr)`: equal shares, constrained by each track's intrinsic minimum.
    MinContent,
    /// Use `minmax(0, max-content)`: content-sized tracks that can shrink toward zero.
    /// Unlike the other presets, this does not distribute free space using fractional tracks.
    MaxContent,
}

/// Repeated grid tracks with one shared sizing preset.
///
/// `repeat = 3` with [`GridTemplateMinSize::Zero`] corresponds to
/// `repeat(3, minmax(0, 1fr))`. [`GridTemplateMinSize::MinContent`] raises the minimum;
/// [`GridTemplateMinSize::MaxContent`] instead uses `minmax(0, max-content)`.
#[derive(
    Copy,
    Clone,
    Refineable,
    PartialEq,
    Eq,
    PartialOrd,
    Ord,
    Debug,
    Default,
    JsonSchema,
    Serialize,
    Deserialize,
)]
pub struct GridTemplate {
    /// Number of tracks to create.
    pub repeat: u16,
    /// Sizing preset applied to each repeated track.
    pub min_size: GridTemplateMinSize,
}

/// A ring's color or gradient.
#[derive(Clone, Copy, Debug, Default, PartialEq, Serialize, Deserialize, JsonSchema)]
pub enum RingColor {
    /// Use the element's effective text color, matching CSS `currentColor`.
    #[default]
    CurrentColor,
    /// Use an explicit color or gradient.
    Color(Background),
}

impl RingColor {
    fn resolve(self, current_color: Hsla) -> Background {
        match self {
            Self::CurrentColor => current_color.into(),
            Self::Color(color) => color,
        }
    }
}

/// A ring around or inside an element.
#[derive(Refineable, Clone, Copy, Debug, Default, PartialEq, Serialize, Deserialize)]
#[refineable(Debug, PartialEq, Serialize, Deserialize)]
pub struct RingStyle {
    /// The width of the ring. A zero width disables it.
    pub width: Pixels,
    /// The ring color or gradient.
    pub color: RingColor,
}

impl RingStyle {
    fn outer_quad(
        self,
        bounds: Bounds<Pixels>,
        corner_radii: Corners<Pixels>,
        current_color: Hsla,
    ) -> Option<crate::PaintQuad> {
        (self.width > Pixels::ZERO).then(|| {
            // Quad borders are painted inward, so expanding the quad by the ring width leaves
            // its transparent interior aligned with the element's original bounds.
            quad(
                bounds.dilate(self.width),
                corner_radii.map(|radius| *radius + self.width),
                transparent_black(),
                Edges::all(self.width),
                self.color.resolve(current_color),
                BorderStyle::Solid,
            )
        })
    }

    fn inset_shadow(self, current_color: Hsla) -> Option<BoxShadow> {
        (self.width > Pixels::ZERO).then(|| {
            BoxShadow::new(px(0.), px(0.), self.color.resolve(current_color))
                .spread_radius(self.width)
                .inset()
        })
    }
}

/// The resolved layout, paint, and text style for one element.
///
/// [`Styled`] methods build a partial [`StyleRefinement`]; resolution merges
/// those fields with defaults, inherited text properties, and interaction
/// state to produce this value. Layout fields feed Taffy to compute bounds.
/// Backgrounds, borders, filters, opacity, and other paint fields are consumed
/// after layout. Geometry and paint values belong to this element. Text
/// properties documented on [`TextStyle`] inherit to descendants, and
/// [`LayoutDirection`] establishes inline direction for logical descendants.
#[derive(Clone, Refineable, Debug)]
#[refineable(Debug, PartialEq, Serialize, Deserialize)]
pub struct Style {
    /// Layout strategy for children. [`Style::default`] uses [`Display::Block`].
    pub display: Display,

    /// Whether to draw the element while preserving its layout space.
    /// Use [`Display::None`] to omit it from layout as well.
    pub visibility: Visibility,

    /// The inline direction of this element and its descendants.
    pub direction: LayoutDirection,

    /// How this element participates in Unicode bidirectional text formatting.
    pub unicode_bidi: UnicodeBidi,

    /// Whether `unicode_bidi` was authored rather than supplied by its initial value.
    #[doc(hidden)]
    pub unicode_bidi_explicit: bool,

    // Overflow properties
    /// How children overflowing their container should affect layout
    #[refineable]
    pub overflow: Point<Overflow>,
    /// Edge fade distances for overflow masking.
    #[refineable]
    pub overflow_fade: Edges<AbsoluteLength>,
    /// How much logical space should be reserved for scrollbars on `Overflow::Scroll` and
    /// `Overflow::Auto` nodes. A zero width reserves no layout space.
    pub scrollbar_width: AbsoluteLength,
    /// Whether both x and y axis should be scrollable at the same time.
    pub allow_concurrent_scroll: bool,
    /// Whether scrolling should be restricted to the input gesture's axis.
    ///
    /// Pixel-based scroll gestures are locked to their initially dominant axis. The lock may be
    /// released when the gesture changes direction strongly. Touch phases delimit gestures when
    /// available, with a timeout fallback for platforms that only emit moved events.
    ///
    /// This also prevents input from being remapped to another axis. For example, horizontal input
    /// will not scroll a container that only has vertical overflow enabled. Mouse wheel platforms
    /// typically report ordinary wheel input on the Y axis and Shift-modified input on the X axis.
    ///
    /// ## Motivation
    ///
    /// On the web when scrolling with the mouse wheel, scrolling up and down will always scroll the Y axis, even when
    /// the mouse is over a horizontally-scrollable element.
    ///
    /// The only way to scroll horizontally is to hold down `Shift` while scrolling, which then changes the scroll axis
    /// to the X axis.
    ///
    /// Currently, GPUI operates differently from the web in that it will scroll an element in either the X or Y axis
    /// when scrolling with just the mouse wheel. This causes problems when scrolling in a vertical list that contains
    /// horizontally-scrollable elements, as when you get to the horizontally-scrollable elements the scroll will be
    /// hijacked.
    ///
    /// Ideally we would match the web's behavior and not have a need for this, but right now we're adding this opt-in
    /// style property to limit the potential blast radius.
    pub restrict_scroll_to_axis: bool,

    // Position properties
    /// Whether insets offset a normally laid-out item or position an absolute item.
    pub position: Position,
    /// Offsets from the edges selected by [`Self::position`]. `Auto` leaves an edge unspecified.
    #[refineable]
    pub inset: Edges<Length>,

    // Size properties
    /// Sets the preferred width and height of the item. Flex layout may still
    /// shrink the item; use `min_size` or `flex_shrink = 0` when it must retain
    /// a lower bound or its preferred size.
    #[refineable]
    pub size: Size<Length>,
    /// Controls the minimum size of the item
    #[refineable]
    pub min_size: Size<Length>,
    /// Controls the maximum size of the item
    #[refineable]
    pub max_size: Size<Length>,
    /// Sets the preferred aspect ratio for the item. The ratio is calculated as width divided by height.
    pub aspect_ratio: Option<f32>,

    // Spacing Properties
    /// Space outside each border edge. Auto margins and negative lengths participate in layout.
    #[refineable]
    pub margin: Edges<Length>,
    /// Space between border and contents on each edge. Padding cannot use `Auto`.
    #[refineable]
    pub padding: Edges<DefiniteLength>,
    /// Border thickness on each edge. This consumes layout space even when no border color
    /// causes it to be painted.
    #[refineable]
    pub border_widths: Edges<AbsoluteLength>,

    // Alignment properties
    /// Alignment of children on the flex cross axis or grid block axis.
    pub align_items: Option<AlignItems>,
    /// How this node should be aligned in the cross/block axis. Falls back to the parents [`AlignItems`] if not set
    pub align_self: Option<AlignSelf>,
    /// How this element aligns vertically when it participates in an inline formatting context.
    pub vertical_align: VerticalAlign,
    /// Distribution of flex lines or grid tracks across the cross/block axis.
    /// Use [`Self::align_items`] to align individual children within a line or track.
    pub align_content: Option<AlignContent>,
    /// Distribution of flex items or grid tracks along the main/inline axis.
    pub justify_content: Option<JustifyContent>,
    /// Horizontal and vertical gaps between flex items or grid tracks.
    #[refineable]
    pub gap: Size<DefiniteLength>,

    // Flexbox properties
    /// Which direction does the main axis flow in?
    pub flex_direction: FlexDirection,
    /// Should elements wrap, or stay in a single line?
    pub flex_wrap: FlexWrap,
    /// Sets the initial main axis size of the item
    pub flex_basis: Length,
    /// The relative rate at which this item grows to fill free space. The
    /// default is `0.0`; use a non-negative factor.
    pub flex_grow: f32,
    /// The relative rate at which this item shrinks when space is insufficient.
    /// The default is `1.0`; set it to `0.0` to disable flex shrinking.
    pub flex_shrink: f32,

    /// Fill for the element's box. This does not inherit; text-run backgrounds belong to
    /// [`TextStyle::background_color`].
    pub background: Option<Fill>,

    /// The background painted into the border of this element
    pub border_color: Option<Background>,

    /// The border style of this element
    pub border_style: BorderStyle,

    /// The length of each border dash, as a multiple of the border width.
    pub border_dashed_length: f32,

    /// The gap between border dashes, as a multiple of the border width.
    pub border_dashed_gap: f32,

    /// The radius of the corners of this element
    #[refineable]
    pub corner_radii: Corners<AbsoluteLength>,

    /// Controls the transition from each rounded corner to the straight edges.
    /// `0.0` produces circular corners. `1.0` applies maximum smoothing.
    pub corner_smoothing: Option<f32>,

    /// Box shadow of the element
    pub box_shadow: Vec<BoxShadow>,

    /// A solid ring painted outside the element.
    #[refineable]
    pub ring: RingStyle,

    /// A solid ring painted inside the element.
    #[refineable]
    pub inset_ring: RingStyle,

    /// Filters applied to this element's own content and children (CSS `filter`).
    pub filter: Vec<Filter>,

    /// Filters applied to the content rendered behind this element (CSS `backdrop-filter`).
    pub backdrop_filter: Vec<Filter>,

    /// The text style of this element
    #[refineable]
    pub text: TextStyleRefinement,

    /// The mouse cursor style shown when the mouse pointer is over an element.
    pub mouse_cursor: Option<CursorStyle>,

    /// Opacity applied to this element and its subtree during element painting.
    pub opacity: Option<f32>,

    /// The grid columns of this element
    /// Roughly equivalent to the Tailwind `grid-cols-<number>`
    pub grid_cols: Option<GridTemplate>,

    /// Template for the element's grid rows. Placement within a parent grid belongs to
    /// [`Self::grid_location`].
    pub grid_rows: Option<GridTemplate>,

    /// The grid location of this element
    pub grid_location: Option<GridLocation>,

    /// Whether to draw a red debugging outline around this element
    #[cfg(debug_assertions)]
    pub debug: bool,

    /// Whether to draw a red debugging outline around this element and all of its conforming children
    #[cfg(debug_assertions)]
    pub debug_below: bool,
}

impl Styled for StyleRefinement {
    fn style(&mut self) -> &mut StyleRefinement {
        self
    }
}

impl StyleRefinement {
    /// The grid location of this element
    pub fn grid_location_mut(&mut self) -> &mut GridLocation {
        self.grid_location.get_or_insert_default()
    }
}

/// The value of the visibility property, similar to the CSS property `visibility`
#[derive(Default, Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize, JsonSchema)]
pub enum Visibility {
    /// The element should be drawn as normal.
    #[default]
    Visible,
    /// The element should not be drawn, but should still take up space in the layout.
    Hidden,
}

/// The inline direction established by an element.
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq, Hash, Serialize, Deserialize, JsonSchema)]
pub enum LayoutDirection {
    /// Use the resolved direction of the logical parent.
    #[default]
    Inherit,
    /// Establish left-to-right directionality.
    LeftToRight,
    /// Establish right-to-left directionality.
    RightToLeft,
    /// Determine direction from eligible source text.
    Auto,
}

/// An element direction after inheritance and automatic detection have been resolved.
#[doc(hidden)]
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq, Hash, Serialize, Deserialize)]
pub enum ResolvedDirection {
    /// Left-to-right inline direction.
    #[default]
    LeftToRight,
    /// Right-to-left inline direction.
    RightToLeft,
}

impl ResolvedDirection {
    /// Returns whether this direction is right-to-left.
    pub fn is_rtl(self) -> bool {
        self == Self::RightToLeft
    }

    pub(crate) fn from_first_strong(text: &str) -> Option<Self> {
        use unicode_bidi::BidiClass;

        text.chars()
            .find_map(|character| match unicode_bidi::bidi_class(character) {
                BidiClass::L => Some(Self::LeftToRight),
                BidiClass::R | BidiClass::AL => Some(Self::RightToLeft),
                _ => None,
            })
    }
}

/// Controls the Unicode bidirectional scope established by an element.
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq, Hash, Serialize, Deserialize, JsonSchema)]
pub enum UnicodeBidi {
    /// Apply ordinary bidirectional processing without another scope.
    #[default]
    Normal,
    /// Establish a directional embedding.
    Embed,
    /// Isolate the element's inline content from surrounding content.
    Isolate,
    /// Override the ordering of inline content with the element direction.
    BidiOverride,
    /// Isolate the content and override its ordering.
    IsolateOverride,
    /// Determine each paragraph's direction from its own content.
    Plaintext,
}

/// The possible values of the box-shadow property
#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
pub struct BoxShadow {
    /// The shadow color or gradient.
    pub color: Background,
    /// How should it be offset from its element?
    pub offset: Point<Pixels>,
    /// How much should the shadow be blurred?
    pub blur_radius: Pixels,
    /// How much should the shadow spread?
    pub spread_radius: Pixels,
    /// Whether this is an inset shadow (drawn inside the element's bounds).
    pub inset: bool,
}

impl BoxShadow {
    /// Creates a new [`BoxShadow`] with the given offset and color, matching the order
    /// of the CSS `box-shadow` property. Use the builder methods to set blur radius,
    /// spread radius, and inset.
    pub fn new(offset_x: Pixels, offset_y: Pixels, color: impl Into<Background>) -> Self {
        Self {
            color: color.into(),
            offset: point(offset_x, offset_y),
            blur_radius: px(0.),
            spread_radius: px(0.),
            inset: false,
        }
    }

    /// Sets the shadow blur radius.
    pub fn blur_radius(mut self, blur_radius: Pixels) -> Self {
        self.blur_radius = blur_radius;
        self
    }

    /// Sets the shadow spread radius.
    pub fn spread_radius(mut self, spread_radius: Pixels) -> Self {
        self.spread_radius = spread_radius;
        self
    }

    /// Marks the shadow as inset (drawn inside the element's bounds).
    pub fn inset(mut self) -> Self {
        self.inset = true;
        self
    }
}

/// A graphical filter that can be applied either to an element's own content
/// (via [`Styled::filter`], like CSS `filter`) or to the content rendered behind
/// it (via [`Styled::backdrop_filter`], like CSS `backdrop-filter`).
#[derive(Clone, Copy, Debug, PartialEq, Serialize, Deserialize, JsonSchema)]
pub enum Filter {
    /// A gaussian blur with the given radius, in logical pixels. Maps to CSS `blur(<px>)`.
    Blur(Pixels),
}

impl Filter {
    /// Whether this filter has no visible effect, so painting can skip it entirely (and the
    /// element can avoid the offscreen isolation pass when *all* of its filters are identities).
    ///
    /// Each variant declares its own no-op case here rather than the pipeline special-casing
    /// blur — adding a filter that this returns `true` for is silently dropped before it ever
    /// reaches the renderer.
    pub fn is_identity(&self) -> bool {
        match self {
            Filter::Blur(radius) => *radius <= Pixels::ZERO,
        }
    }

    /// Lower this logical-pixel filter into its scene-space ([`ScaledFilter`]) form for the
    /// renderer, scaling any pixel magnitudes by `factor` (the window scale factor).
    pub fn scale(&self, factor: f32) -> ScaledFilter {
        match self {
            Filter::Blur(radius) => ScaledFilter::Blur(radius.scale(factor)),
        }
    }
}

/// The scene-space (device-pixel) form of a [`Filter`], carried on the scene primitives that the
/// renderers consume. Produced by [`Filter::scale`]; pixel magnitudes are in [`ScaledPixels`].
///
/// This is intentionally a separate enum from [`Filter`] (rather than reusing it) so the scene
/// stays in device space like every other primitive, and so the renderers `match` on it
/// exhaustively — adding a filter variant breaks each backend's match, forcing a deliberate
/// implement-or-decline decision per backend instead of silently rendering nothing.
#[derive(Clone, Copy, Debug, PartialEq, Serialize, Deserialize)]
pub enum ScaledFilter {
    /// A gaussian blur with the given radius, in scaled (device) pixels.
    Blur(ScaledPixels),
}

/// Whether layout inserts soft line breaks in text.
///
/// Both policies preserve hard breaks and source whitespace. These names do not imply CSS
/// whitespace collapsing. Choose a [`TextOverflow`] separately to replace overflowing content
/// with an affix.
#[derive(Copy, Clone, Debug, Default, PartialEq, Eq, Serialize, Deserialize, JsonSchema)]
pub enum WhiteSpace {
    /// Allow soft wrapping at the available width.
    #[default]
    Normal,
    /// Disable soft wrapping. Hard breaks remain; a long line can overflow its box.
    Nowrap,
}

/// Which part of overflowing source text to replace with an affix.
///
/// The cut follows logical source order and preserves complete grapheme clusters. It is not a
/// visual left/right cut in bidirectional text. Affixes can be any string, not only an ellipsis.
/// Even an affix wider than the available space is retained; use the element's overflow style
/// when painting must be clipped. See [`crate::TextLayout::apply_truncation`].
#[derive(Clone, Debug, PartialEq, Eq, Serialize, Deserialize, JsonSchema)]
pub enum TextOverflow {
    /// Truncate the text at the end when it doesn't fit, and represent this truncation by
    /// displaying the provided string (e.g., "very long te…").
    Truncate(SharedString),
    /// Truncate the text at the start when it doesn't fit, and represent this truncation by
    /// displaying the provided string at the beginning (e.g., "…ong text here").
    /// Typically more adequate for file paths where the end is more important than the beginning.
    TruncateStart(SharedString),
    /// Truncate the text in the middle when it doesn't fit, preserving both the start and end
    /// of the string (e.g., "long fi…name.rs"). Useful for filenames where both the prefix
    /// and the extension are important context.
    TruncateMiddle(SharedString),
}

/// How to align text within the element
#[derive(Copy, Clone, Debug, Default, PartialEq, Eq, Hash, Serialize, Deserialize, JsonSchema)]
pub enum TextAlign {
    /// Align text to the start edge for the line's direction.
    #[default]
    Start,

    /// Align text to the end edge for the line's direction.
    End,

    /// Align the text to the physical left edge of the element.
    Left,

    /// Center the text within the element
    Center,

    /// Align the text to the right of the element
    Right,
}

/// Case mapping applied at layout time while keeping **UTF-8 byte lengths** unchanged.
///
/// [`TextTransform::Uppercase`] and [`TextTransform::Lowercase`] use Unicode case mapping via
/// [`char::to_uppercase`] / [`char::to_lowercase`]. If mapping a code point would change its UTF-8
/// length, or would replace one scalar value with more than one character, the **original**
/// character is kept. That keeps indices into the underlying buffer aligned with hit-testing and
/// editor-style caret positions that use raw byte offsets.
///
/// [`TextTransform::Capitalize`] uses Unicode word boundaries to uppercase the first alphabetic
/// scalar in each word, subject to the same byte-length restriction. It resembles CSS
/// [`capitalize`][tw-cap], but is not a locale-sensitive case conversion.
///
/// [tw-cap]: https://tailwindcss.com/docs/text-transform
#[derive(Copy, Clone, Debug, Default, PartialEq, Eq, Serialize, Deserialize, JsonSchema)]
pub enum TextTransform {
    /// Do not transform text.
    #[default]
    None,
    /// Uppercase text (Unicode, byte-length preserving — see [`TextTransform`]).
    Uppercase,
    /// Lowercase text (Unicode, byte-length preserving — see [`TextTransform`]).
    Lowercase,
    /// Uppercase the first alphabetic scalar of each Unicode word when its byte length is unchanged.
    Capitalize,
}

/// Typography inherited by text elements and their descendants.
///
/// [`Styled`] methods author a [`TextStyleRefinement`]; the window resolves those partial values
/// against the current inherited style. Read the result with [`Window::text_style`].
/// [`StyledText`](crate::StyledText) can override selected ranges with a [`HighlightStyle`], or
/// replace their font and paint properties with complete [`TextRun`] values.
///
/// Font size, line height, wrapping, alignment, and truncation describe the document's layout.
/// [`Self::to_run`] copies the font and paint properties for a byte range; it does not copy those
/// document-wide layout settings. See the [text chapter](https://gpui-ce.github.io/book/text.html)
/// for choosing a text element and working with measured positions.
#[derive(Refineable, Clone, Debug, PartialEq)]
#[refineable(Debug, PartialEq, Serialize, Deserialize)]
pub struct TextStyle {
    /// The color of the text
    pub color: Hsla,

    /// The font family to use
    pub font_family: SharedString,

    /// The font features to use
    pub font_features: FontFeatures,

    /// The fallback fonts to use
    pub font_fallbacks: Option<FontFallbacks>,

    /// The font size to use, in pixels or rems.
    pub font_size: AbsoluteLength,

    /// Visual-row height. A relative value multiplies the resolved font size;
    /// an absolute value uses logical pixels or rems.
    pub line_height: DefiniteLength,

    /// The font weight, e.g. bold
    pub font_weight: FontWeight,

    /// The font width as a percentage of normal width.
    pub font_width: FontWidth,

    /// The font style, e.g. italic
    pub font_style: FontStyle,

    /// The background color of the text
    pub background_color: Option<Hsla>,

    /// The underline style of the text
    pub underline: Option<UnderlineStyle>,

    /// The strikethrough style of the text
    pub strikethrough: Option<StrikethroughStyle>,

    /// How to handle whitespace in the text
    pub white_space: WhiteSpace,

    /// The text should be truncated if it overflows the width of the element
    pub text_overflow: Option<TextOverflow>,

    /// How the text should be aligned within the element
    pub text_align: TextAlign,

    /// Optional limit passed to line breaking. This alone does not insert an ellipsis;
    /// configure [`Self::text_overflow`] for an affix and clip through the element's overflow style.
    pub line_clamp: Option<usize>,

    /// Letter spacing added between characters, in pixels (positive widens, negative tightens).
    ///
    /// The platform text stack may clamp values outside the range it supports.
    pub letter_spacing: Option<Pixels>,

    /// Case transformation applied at layout time.
    pub text_transform: Option<TextTransform>,
}

impl Default for TextStyle {
    fn default() -> Self {
        TextStyle {
            color: black(),
            // todo(linux) make this configurable or choose better default
            font_family: ".SystemUIFont".into(),
            font_features: FontFeatures::default(),
            font_fallbacks: None,
            font_size: rems(1.).into(),
            line_height: phi().into(),
            font_weight: FontWeight::default(),
            font_width: FontWidth::default(),
            font_style: FontStyle::default(),
            background_color: None,
            underline: None,
            strikethrough: None,
            white_space: WhiteSpace::Normal,
            text_overflow: None,
            text_align: TextAlign::default(),
            line_clamp: None,
            letter_spacing: None,
            text_transform: None,
        }
    }
}

impl TextStyle {
    /// Apply specified highlight properties, preserving the rest of this style.
    ///
    /// Font and decoration properties replace their corresponding values. Highlight color
    /// blends over the existing foreground; `fade_out` then reduces its alpha. A missing
    /// background or decoration leaves the existing one in place rather than clearing it.
    pub fn highlight(mut self, style: impl Into<HighlightStyle>) -> Self {
        let style = style.into();
        if let Some(weight) = style.font_weight {
            self.font_weight = weight;
        }

        if let Some(width) = style.font_width {
            self.font_width = width;
        }

        if let Some(style) = style.font_style {
            self.font_style = style;
        }

        if let Some(color) = style.color {
            self.color = self.color.blend(&color);
        }

        if let Some(factor) = style.fade_out {
            self.color.fade_out(factor);
        }

        if let Some(background_color) = style.background_color {
            self.background_color = Some(background_color);
        }

        if let Some(underline) = style.underline {
            self.underline = Some(underline);
        }

        if let Some(strikethrough) = style.strikethrough {
            self.strikethrough = Some(strikethrough);
        }

        self
    }

    /// Copy this style's font request, including feature tags and fallback families.
    ///
    /// The request is resolved during shaping; it does not identify one guaranteed font face
    /// for every glyph in the string.
    pub fn font(&self) -> Font {
        Font {
            family: self.font_family.clone(),
            features: self.font_features.clone(),
            fallbacks: self.font_fallbacks.clone(),
            weight: self.font_weight,
            width: self.font_width,
            style: self.font_style,
        }
    }

    /// Resolve the line height against this style's font size and the window's rem size,
    /// then round to the nearest logical pixel.
    pub fn line_height_in_pixels(&self, rem_size: Pixels) -> Pixels {
        self.line_height.to_pixels(self.font_size, rem_size).round()
    }

    /// Copy font and paint properties into a run covering `len` UTF-8 bytes.
    ///
    /// The length is not validated here. When supplying runs to shaping, make their lengths
    /// cover the string exactly and end on character boundaries. Font size, line height,
    /// wrapping, alignment, truncation, and case conversion stay outside the run.
    pub fn to_run(&self, len: usize) -> TextRun {
        TextRun {
            len,
            font: Font {
                family: self.font_family.clone(),
                features: self.font_features.clone(),
                fallbacks: self.font_fallbacks.clone(),
                weight: self.font_weight,
                width: self.font_width,
                style: self.font_style,
            },
            color: self.color,
            background_color: self.background_color,
            underline: self.underline,
            strikethrough: self.strikethrough,
            letter_spacing: self.letter_spacing,
        }
    }
}

/// Partial font and paint overrides for selected ranges of text.
///
/// Use it with [`StyledText::with_highlights`](crate::StyledText::with_highlights) to emphasize a
/// substring while keeping inherited typography elsewhere. Apply it to an entire style with
/// [`TextStyle::highlight`]. Absent fields retain the base value; color blends with the base
/// foreground instead of replacing it directly.
///
/// Layout extras on the base [`TextStyle`] — such as [`TextStyle::letter_spacing`] and
/// [`TextStyle::text_transform`] — are not stored here; highlighted segments inherit them
/// from the surrounding style (see [`TextStyle::highlight`] and
/// [`crate::StyledText::with_default_highlights`]).
#[derive(Copy, Clone, Debug, Default, PartialEq)]
pub struct HighlightStyle {
    /// The color of the text
    pub color: Option<Hsla>,

    /// The font weight, e.g. bold
    pub font_weight: Option<FontWeight>,

    /// The font width as a percentage of normal width.
    pub font_width: Option<FontWidth>,

    /// The font style, e.g. italic
    pub font_style: Option<FontStyle>,

    /// The background color of the text
    pub background_color: Option<Hsla>,

    /// The underline style of the text
    pub underline: Option<UnderlineStyle>,

    /// The strikethrough style of the text
    pub strikethrough: Option<StrikethroughStyle>,

    /// Fraction of foreground alpha to remove, clamped to `0..=1` when applied.
    /// Zero preserves the foreground; one makes it transparent. Background and decoration
    /// colors are not faded by this field.
    pub fade_out: Option<f32>,
}

impl Style {
    /// Resolves the initial Unicode bidi behavior against this style's direction.
    #[doc(hidden)]
    pub fn effective_unicode_bidi(&self) -> UnicodeBidi {
        if self.unicode_bidi_explicit {
            self.unicode_bidi
        } else if self.direction == LayoutDirection::Inherit {
            UnicodeBidi::Normal
        } else {
            UnicodeBidi::Isolate
        }
    }

    /// Return whether a background exists and is not fully transparent.
    ///
    /// Despite the name, a partially transparent background also returns `true`.
    /// The method does not inspect [`Self::visibility`] or [`Self::opacity`].
    pub fn has_opaque_background(&self) -> bool {
        self.background
            .as_ref()
            .is_some_and(|fill| fill.color().is_some_and(|color| !color.is_transparent()))
    }

    /// Borrow the authored text refinement, or return `None` if no text fields were set.
    ///
    /// This is a partial style, not the inherited result from [`Window::text_style`].
    pub fn text_style(&self) -> Option<&TextStyleRefinement> {
        if self.text.is_some() {
            Some(&self.text)
        } else {
            None
        }
    }

    /// Get the content mask for this element style, based on the given bounds.
    /// If the element does not hide its overflow, this will return `None`.
    pub fn overflow_mask(
        &self,
        bounds: Bounds<Pixels>,
        rem_size: Pixels,
    ) -> Option<ContentMask<Pixels>> {
        match self.overflow {
            Point {
                x: Overflow::Visible,
                y: Overflow::Visible,
            } => None,
            _ => {
                let mut min = bounds.origin;
                let mut max = bounds.bottom_right();

                if self
                    .border_color
                    .is_some_and(|background| !background.is_transparent())
                {
                    min.x += self.border_widths.left.to_pixels(rem_size);
                    max.x -= self.border_widths.right.to_pixels(rem_size);
                    min.y += self.border_widths.top.to_pixels(rem_size);
                    max.y -= self.border_widths.bottom.to_pixels(rem_size);
                }

                let bounds = match (
                    self.overflow.x == Overflow::Visible,
                    self.overflow.y == Overflow::Visible,
                ) {
                    // x and y both visible
                    (true, true) => return None,
                    // x visible, y hidden
                    (true, false) => Bounds::from_corners(
                        point(min.x, bounds.origin.y),
                        point(max.x, bounds.bottom_right().y),
                    ),
                    // x hidden, y visible
                    (false, true) => Bounds::from_corners(
                        point(bounds.origin.x, min.y),
                        point(bounds.bottom_right().x, max.y),
                    ),
                    // both hidden
                    (false, false) => Bounds::from_corners(min, max),
                };

                let mut fade_out = self.overflow_fade.to_pixels(rem_size);
                if self.overflow.x == Overflow::Visible {
                    fade_out.left = Pixels::ZERO;
                    fade_out.right = Pixels::ZERO;
                }
                if self.overflow.y == Overflow::Visible {
                    fade_out.top = Pixels::ZERO;
                    fade_out.bottom = Pixels::ZERO;
                }

                Some(ContentMask { bounds, fade_out })
            }
        }
    }

    /// Get the content mask for a container that always clips and scrolls
    /// vertically, like [`List`](crate::List) and
    /// [`UniformList`](crate::UniformList): the vertical axis always clips,
    /// the horizontal axis clips according to `overflow.x`, and
    /// `overflow_fade` distances apply on each clipped axis.
    pub fn scroll_mask(&self, bounds: Bounds<Pixels>, rem_size: Pixels) -> ContentMask<Pixels> {
        let scroll_style = Style {
            overflow: Point {
                x: self.overflow.x,
                y: Overflow::Scroll,
            },
            border_color: self.border_color,
            border_widths: self.border_widths,
            overflow_fade: self.overflow_fade,
            ..Style::default()
        };
        scroll_style
            .overflow_mask(bounds, rem_size)
            .expect("vertical scrolling always clips")
    }

    /// Paint the element's box, calling `continuation` for its contents.
    ///
    /// Outer shadows, the outer ring, backdrop filters, the background, and inset shadows
    /// precede the contents; the border follows them. Own-content filters surround the box's
    /// background, inset shadows, contents, and border. An inline element paints its box
    /// fragments separately and calls the continuation once.
    ///
    /// This method does not perform layout, resolve inherited text, apply opacity, or hide the
    /// element for its visibility setting. The element lifecycle handles those operations.
    pub fn paint(
        &self,
        bounds: Bounds<Pixels>,
        window: &mut Window,
        cx: &mut App,
        continuation: impl FnOnce(&mut Window, &mut App),
    ) {
        if let Some(fragments) = window.current_inline_fragments.clone() {
            for fragment in fragments.iter() {
                self.paint_box(*fragment, window, cx, |_, _| {});
            }

            continuation(window, cx);

            return;
        }

        self.paint_box(bounds, window, cx, continuation);
    }

    fn paint_box(
        &self,
        bounds: Bounds<Pixels>,
        window: &mut Window,
        cx: &mut App,
        continuation: impl FnOnce(&mut Window, &mut App),
    ) {
        #[cfg(debug_assertions)]
        if self.debug_below {
            cx.set_global(DebugBelow)
        }

        #[cfg(debug_assertions)]
        if self.debug || cx.has_global::<DebugBelow>() {
            window.paint_quad(crate::outline(bounds, crate::red(), BorderStyle::default()));
        }

        let rem_size = window.rem_size();
        let corner_radii = self
            .corner_radii
            .to_pixels(rem_size)
            .clamp_radii_for_quad_size(bounds.size);
        let corner_smoothing = self.corner_smoothing.unwrap_or_default();

        let current_color = self.text.color.unwrap_or_else(|| window.text_style().color);

        window.paint_drop_shadows_with_corner_smoothing(
            bounds,
            corner_radii,
            corner_smoothing,
            &self.box_shadow,
        );
        if let Some(ring) = self.ring.outer_quad(bounds, corner_radii, current_color) {
            window.paint_quad_with_corner_smoothing(ring, corner_smoothing);
        }

        // Blur the content behind this element before its (typically translucent) background
        // is painted on top, so the background tints the frosted backdrop (CSS `backdrop-filter`).
        if !self.backdrop_filter.is_empty() {
            window.paint_backdrop_filter_with_corner_smoothing(
                bounds,
                corner_radii,
                corner_smoothing,
                &self.backdrop_filter,
            );
        }

        // The element's own box — background, inset shadows, children, and border — painted as a
        // unit. A `filter` (CSS `filter`) wraps this whole unit so the renderer blurs the element
        // and its children together as one group; without a filter it paints directly.
        let paint_box = |window: &mut Window, cx: &mut App| {
            let background_color = self.background.as_ref().and_then(Fill::color);
            if background_color.is_some_and(|color| !color.is_transparent()) {
                let background_color = background_color.unwrap_or_default();
                window.paint_quad_with_corner_smoothing(
                    quad(
                        bounds,
                        corner_radii,
                        background_color,
                        Edges::default(),
                        background_color.opacity(0.),
                        self.border_style,
                    ),
                    corner_smoothing,
                );
            }

            if let Some(ring) = self.inset_ring.inset_shadow(current_color) {
                window.paint_inset_shadows_with_corner_smoothing(
                    bounds,
                    corner_radii,
                    corner_smoothing,
                    std::slice::from_ref(&ring),
                );
            }
            window.paint_inset_shadows_with_corner_smoothing(
                bounds,
                corner_radii,
                corner_smoothing,
                &self.box_shadow,
            );

            continuation(window, cx);

            if self.is_border_visible() {
                let border_widths = self.border_widths.to_pixels(rem_size);
                let border_color = self.border_color.unwrap_or_default();
                window.paint_quad_with_corner_smoothing(
                    quad(
                        bounds,
                        corner_radii,
                        border_color.opacity(0.),
                        border_widths,
                        border_color,
                        self.border_style,
                    )
                    .border_dashed_length(self.border_dashed_length)
                    .border_dashed_gap(self.border_dashed_gap),
                    corner_smoothing,
                );
            }
        };

        if self.filter.is_empty() {
            paint_box(window, cx);
        } else {
            window.with_filter_layer_with_corner_smoothing(
                bounds,
                corner_radii,
                corner_smoothing,
                &self.filter,
                |window| {
                    paint_box(window, cx);
                },
            );
        }

        #[cfg(debug_assertions)]
        if self.debug_below {
            cx.remove_global::<DebugBelow>();
        }
    }

    fn is_border_visible(&self) -> bool {
        self.border_color
            .is_some_and(|background| !background.is_transparent())
            && self.border_widths.any(|length| !length.is_zero())
    }
}

impl Default for Style {
    fn default() -> Self {
        Style {
            display: Display::Block,
            visibility: Visibility::Visible,
            direction: LayoutDirection::Inherit,
            unicode_bidi: UnicodeBidi::Normal,
            unicode_bidi_explicit: false,
            overflow: Point {
                x: Overflow::Visible,
                y: Overflow::Visible,
            },
            overflow_fade: Edges::<AbsoluteLength>::zero(),
            allow_concurrent_scroll: false,
            restrict_scroll_to_axis: false,
            scrollbar_width: AbsoluteLength::default(),
            position: Position::Relative,
            inset: Edges::auto(),
            margin: Edges::<Length>::zero(),
            padding: Edges::<DefiniteLength>::zero(),
            border_widths: Edges::<AbsoluteLength>::zero(),
            size: Size::auto(),
            min_size: Size::auto(),
            max_size: Size::auto(),
            aspect_ratio: None,
            gap: Size::default(),
            // Alignment
            align_items: None,
            align_self: None,
            vertical_align: VerticalAlign::Baseline,
            align_content: None,
            justify_content: None,
            // Flexbox
            flex_direction: FlexDirection::Row,
            flex_wrap: FlexWrap::NoWrap,
            flex_grow: 0.0,
            flex_shrink: 1.0,
            flex_basis: Length::Auto,
            background: None,
            border_color: None,
            border_style: BorderStyle::default(),
            border_dashed_length: crate::scene::DEFAULT_BORDER_DASHED_LENGTH,
            border_dashed_gap: crate::scene::DEFAULT_BORDER_DASHED_GAP,
            corner_radii: Corners::default(),
            corner_smoothing: None,
            box_shadow: Default::default(),
            ring: Default::default(),
            inset_ring: Default::default(),
            filter: Default::default(),
            backdrop_filter: Default::default(),
            text: TextStyleRefinement::default(),
            mouse_cursor: None,
            opacity: None,
            grid_rows: None,
            grid_cols: None,
            grid_location: None,

            #[cfg(debug_assertions)]
            debug: false,
            #[cfg(debug_assertions)]
            debug_below: false,
        }
    }
}

/// The properties that can be applied to an underline.
#[derive(Refineable, Copy, Clone, Default, Debug, PartialEq, Serialize, Deserialize)]
pub struct UnderlineStyle {
    /// The thickness of the underline.
    pub thickness: Pixels,

    /// The color of the underline.
    #[serde(with = "crate::color::serde_colors::optional_hsla")]
    pub color: Option<Hsla>,

    /// Whether the underline should be wavy, like in a spell checker.
    pub wavy: bool,
}

/// The properties that can be applied to a strikethrough.
#[derive(Refineable, Copy, Clone, Default, Debug, PartialEq, Serialize, Deserialize)]
pub struct StrikethroughStyle {
    /// The thickness of the strikethrough.
    pub thickness: Pixels,

    /// The color of the strikethrough.
    #[serde(with = "crate::color::serde_colors::optional_hsla")]
    pub color: Option<Hsla>,
}

/// The kinds of fill that can be applied to a shape.
#[derive(Clone, Debug, PartialEq, Serialize, Deserialize, JsonSchema)]
pub enum Fill {
    /// A solid color fill.
    Color(Background),
}

impl Fill {
    /// Unwrap this fill into a solid color, if it is one.
    ///
    /// If the fill is not a solid color, this method returns `None`.
    pub fn color(&self) -> Option<Background> {
        match self {
            Fill::Color(color) => Some(*color),
        }
    }
}

impl Default for Fill {
    fn default() -> Self {
        Self::Color(Background::default())
    }
}

impl<T: Into<Background>> From<T> for Fill {
    fn from(color: T) -> Self {
        Self::Color(color.into())
    }
}

impl From<TextStyle> for HighlightStyle {
    fn from(other: TextStyle) -> Self {
        Self::from(&other)
    }
}

impl From<&TextStyle> for HighlightStyle {
    fn from(other: &TextStyle) -> Self {
        Self {
            color: Some(other.color),
            font_weight: Some(other.font_weight),
            font_width: Some(other.font_width),
            font_style: Some(other.font_style),
            background_color: other.background_color,
            underline: other.underline,
            strikethrough: other.strikethrough,
            fade_out: None,
        }
    }
}

impl HighlightStyle {
    /// Create a highlight style with just a color
    pub fn color(color: Hsla) -> Self {
        Self {
            color: Some(color),
            ..Default::default()
        }
    }
    /// Blend this highlight style with another.
    /// Non-continuous properties, like font_weight and font_style, are overwritten.
    #[must_use]
    pub fn highlight(self, other: HighlightStyle) -> Self {
        Self {
            color: other
                .color
                .map(|other_color| {
                    if let Some(color) = self.color {
                        color.blend(&other_color)
                    } else {
                        other_color
                    }
                })
                .or(self.color),
            font_weight: other.font_weight.or(self.font_weight),
            font_width: other.font_width.or(self.font_width),
            font_style: other.font_style.or(self.font_style),
            background_color: other.background_color.or(self.background_color),
            underline: other.underline.or(self.underline),
            strikethrough: other.strikethrough.or(self.strikethrough),
            fade_out: other
                .fade_out
                .map(|source_fade| {
                    self.fade_out
                        .map(|dest_fade| (dest_fade * (1. + source_fade)).clamp(0., 1.))
                        .unwrap_or(source_fade)
                })
                .or(self.fade_out),
        }
    }
}

impl From<Hsla> for HighlightStyle {
    fn from(color: Hsla) -> Self {
        Self {
            color: Some(color),
            ..Default::default()
        }
    }
}

impl From<FontWeight> for HighlightStyle {
    fn from(font_weight: FontWeight) -> Self {
        Self {
            font_weight: Some(font_weight),
            ..Default::default()
        }
    }
}

impl From<FontStyle> for HighlightStyle {
    fn from(font_style: FontStyle) -> Self {
        Self {
            font_style: Some(font_style),
            ..Default::default()
        }
    }
}

impl From<Rgba> for HighlightStyle {
    fn from(color: Rgba) -> Self {
        Self {
            color: Some(color.into_color()),
            ..Default::default()
        }
    }
}

/// Split overlapping highlight ranges into nonoverlapping styled segments.
///
/// The inputs can be unsorted. Empty or reversed ranges are discarded. The output is ordered
/// by byte position and contains only covered segments, leaving unhighlighted gaps out. This
/// function has no source string and does not validate UTF-8 boundaries; validate those before
/// passing the result to [`StyledText::with_highlights`](crate::StyledText::with_highlights).
///
/// Active highlights are combined with [`HighlightStyle::highlight`] in hash-set iteration
/// order. Do not use this function to choose which of two conflicting font or decoration
/// overrides wins; that precedence is unspecified.
///
/// ```
/// use gpui::{FontStyle, FontWeight, combine_highlights};
///
/// let runs: Vec<_> = combine_highlights(
///     [(0..4, FontWeight::BOLD.into())],
///     [(2..6, FontStyle::Italic.into())],
/// ).collect();
/// assert_eq!(runs.iter().map(|(range, _)| range.clone()).collect::<Vec<_>>(),
///            [0..2, 2..4, 4..6]);
/// assert_eq!(runs[1].1.font_weight, Some(FontWeight::BOLD));
/// assert_eq!(runs[1].1.font_style, Some(FontStyle::Italic));
/// ```
pub fn combine_highlights(
    a: impl IntoIterator<Item = (Range<usize>, HighlightStyle)>,
    b: impl IntoIterator<Item = (Range<usize>, HighlightStyle)>,
) -> impl Iterator<Item = (Range<usize>, HighlightStyle)> {
    let mut endpoints = Vec::new();
    let mut highlights = Vec::new();
    for (range, highlight) in a.into_iter().chain(b) {
        if !range.is_empty() {
            let highlight_id = highlights.len();
            endpoints.push((range.start, highlight_id, true));
            endpoints.push((range.end, highlight_id, false));
            highlights.push(highlight);
        }
    }
    endpoints.sort_unstable_by_key(|(position, _, _)| *position);
    let mut endpoints = endpoints.into_iter().peekable();

    let mut active_styles = HashSet::default();
    let mut ix = 0;
    iter::from_fn(move || {
        while let Some((endpoint_ix, highlight_id, is_start)) = endpoints.peek() {
            let prev_index = mem::replace(&mut ix, *endpoint_ix);
            if ix > prev_index && !active_styles.is_empty() {
                let current_style = active_styles
                    .iter()
                    .fold(HighlightStyle::default(), |acc, highlight_id| {
                        acc.highlight(highlights[*highlight_id])
                    });
                return Some((prev_index..ix, current_style));
            }

            if *is_start {
                active_styles.insert(*highlight_id);
            } else {
                active_styles.remove(highlight_id);
            }
            endpoints.next();
        }
        None
    })
}

/// Used to control how child nodes are aligned.
/// For Flexbox it controls alignment in the cross axis
/// For Grid it controls alignment in the block axis
///
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/align-items)
#[derive(Copy, Clone, PartialEq, Eq, Debug, Serialize, Deserialize, JsonSchema)]
// Copy of taffy::style type of the same name, to derive JsonSchema.
pub enum AlignItems {
    /// Items are packed toward the start of the axis
    Start,
    /// Items are packed toward the end of the axis
    End,
    /// Items are packed towards the flex-relative start of the axis.
    ///
    /// For flex containers with flex_direction RowReverse or ColumnReverse this is equivalent
    /// to End. In all other cases it is equivalent to Start.
    FlexStart,
    /// Items are packed towards the flex-relative end of the axis.
    ///
    /// For flex containers with flex_direction RowReverse or ColumnReverse this is equivalent
    /// to Start. In all other cases it is equivalent to End.
    FlexEnd,
    /// Items are packed along the center of the cross axis
    Center,
    /// Items are aligned such as their baselines align
    Baseline,
    /// Stretch to fill the container
    Stretch,
}
/// Used to control how child nodes are aligned.
/// Does not apply to Flexbox, and will be ignored if specified on a flex container
/// For Grid it controls alignment in the inline axis
///
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/justify-items)
pub type JustifyItems = AlignItems;
/// Used to control how the specified nodes is aligned.
/// Overrides the parent Node's `AlignItems` property.
/// For Flexbox it controls alignment in the cross axis
/// For Grid it controls alignment in the block axis
///
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/align-self)
pub type AlignSelf = AlignItems;
/// Used to control how the specified nodes is aligned.
/// Overrides the parent Node's `JustifyItems` property.
/// Does not apply to Flexbox, and will be ignored if specified on a flex child
/// For Grid it controls alignment in the inline axis
///
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/justify-self)
pub type JustifySelf = AlignItems;

/// Controls the vertical position of an element box in an inline formatting context.
///
/// This property has no effect on ordinary block, flex, or grid layout.
#[derive(Copy, Clone, PartialEq, Eq, Hash, Debug, Default, Serialize, Deserialize, JsonSchema)]
pub enum VerticalAlign {
    /// Align the bottom of the box with the text baseline.
    #[default]
    Baseline,
    /// Align the box midpoint with the parent baseline plus half the parent font's x-height.
    /// This is CSS text-metric alignment. Use `self_center` or `items_center` for flex or grid
    /// container centering.
    Middle,
    /// Align the top of the box with the top of its line.
    Top,
    /// Align the bottom of the box with the bottom of its line.
    Bottom,
}

/// Sets the distribution of space between and around content items
/// For Flexbox it controls alignment in the cross axis
/// For Grid it controls alignment in the block axis
///
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/align-content)
#[derive(Copy, Clone, PartialEq, Eq, Debug, Serialize, Deserialize, JsonSchema)]
// Copy of taffy::style type of the same name, to derive JsonSchema.
pub enum AlignContent {
    /// Items are packed toward the start of the axis
    Start,
    /// Items are packed toward the end of the axis
    End,
    /// Items are packed towards the flex-relative start of the axis.
    ///
    /// For flex containers with flex_direction RowReverse or ColumnReverse this is equivalent
    /// to End. In all other cases it is equivalent to Start.
    FlexStart,
    /// Items are packed towards the flex-relative end of the axis.
    ///
    /// For flex containers with flex_direction RowReverse or ColumnReverse this is equivalent
    /// to Start. In all other cases it is equivalent to End.
    FlexEnd,
    /// Items are centered around the middle of the axis
    Center,
    /// Items are stretched to fill the container
    Stretch,
    /// The first and last items are aligned flush with the edges of the container (no gap)
    /// The gap between items is distributed evenly.
    SpaceBetween,
    /// The gap between the first and last items is exactly THE SAME as the gap between items.
    /// The gaps are distributed evenly
    SpaceEvenly,
    /// The gap between the first and last items is exactly HALF the gap between items.
    /// The gaps are distributed evenly in proportion to these ratios.
    SpaceAround,
}

/// Sets the distribution of space between and around content items
/// For Flexbox it controls alignment in the main axis
/// For Grid it controls alignment in the inline axis
///
/// [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/justify-content)
pub type JustifyContent = AlignContent;

/// Sets the layout used for the children of this node
///
/// The enum's default is `Flex`, but [`Style::default`] explicitly chooses `Block`.
/// Block containers arrange text and inline children in paragraphs.
#[derive(Copy, Clone, PartialEq, Eq, Debug, Default, Serialize, Deserialize, JsonSchema)]
// Inline participation is handled by GPUI before independent box layout in Taffy.
pub enum Display {
    /// The children will follow the block layout algorithm
    Block,

    /// The children will follow the flexbox layout algorithm
    #[default]
    Flex,

    /// The children will follow the CSS Grid layout algorithm
    Grid,

    /// Contributes its contents to the surrounding paragraph, wrapping across lines.
    /// As a root or flex/grid item, lays out its contents independently using block flow.
    Inline,

    /// An atomic inline box whose children use flex layout.
    InlineFlex,

    /// The element and its children are hidden and occupy no space.
    None,
}

/// Controls whether flex items are forced onto one line or can wrap onto multiple lines.
///
/// Defaults to [`FlexWrap::NoWrap`]
///
/// [Specification](https://www.w3.org/TR/css-flexbox-1/#flex-wrap-property)
#[derive(Copy, Clone, PartialEq, Eq, Debug, Default, Serialize, Deserialize, JsonSchema)]
// Copy of taffy::style type of the same name, to derive JsonSchema.
pub enum FlexWrap {
    /// Items will not wrap and stay on a single line
    #[default]
    NoWrap,
    /// Items will wrap according to this item's [`FlexDirection`]
    Wrap,
    /// Items will wrap in the opposite direction to this item's [`FlexDirection`]
    WrapReverse,
}

/// The direction of the flexbox layout main axis.
///
/// There are always two perpendicular layout axes: main (or primary) and cross (or secondary).
/// Adding items will cause them to be positioned adjacent to each other along the main axis.
/// By varying this value throughout your tree, you can create complex axis-aligned layouts.
///
/// Items are always aligned relative to the cross axis, and justified relative to the main axis.
///
/// The default behavior is [`FlexDirection::Row`].
///
/// [Specification](https://www.w3.org/TR/css-flexbox-1/#flex-direction-property)
#[derive(Copy, Clone, PartialEq, Eq, Debug, Default, Serialize, Deserialize, JsonSchema)]
// Copy of taffy::style type of the same name, to derive JsonSchema.
pub enum FlexDirection {
    /// Defines +x as the main axis
    ///
    /// Items will be added from left to right in a row.
    #[default]
    Row,
    /// Defines +y as the main axis
    ///
    /// Items will be added from top to bottom in a column.
    Column,
    /// Defines -x as the main axis
    ///
    /// Items will be added from right to left in a row.
    RowReverse,
    /// Defines -y as the main axis
    ///
    /// Items will be added from bottom to top in a column.
    ColumnReverse,
}

/// Overflow policy for each axis of an element.
///
/// The policy affects both layout and painting. `Hidden` and `Scroll` allow an automatic flex
/// or grid minimum to shrink to zero, whereas `Visible` and `Clip` retain a content-based
/// minimum. Scrollbar space is controlled by [`Style::scrollbar_width`]. A zero scrollbar width
/// makes `Scroll` and `Hidden` equivalent for that part of layout; a scrolling element still
/// handles input and offsets its contents.
///
/// [`Style::overflow_mask`] computes clipping for element painting. Lists use
/// [`Style::scroll_mask`] because they always clip vertically. Setting an overflow value alone
/// does not install a scroll listener on a custom [`Element`](crate::Element).
/// See the [CSS overflow reference](https://developer.mozilla.org/en-US/docs/Web/CSS/overflow)
/// for the related layout vocabulary.
#[derive(Copy, Clone, PartialEq, Eq, Debug, Default, Serialize, Deserialize, JsonSchema)]
// Copy of taffy::style type of the same name, to derive JsonSchema.
pub enum Overflow {
    /// The automatic minimum size of this node as a flexbox/grid item should be based on the size of its content.
    /// Content that overflows this node *should* contribute to the scroll region of its parent.
    #[default]
    Visible,
    /// The automatic minimum size of this node as a flexbox/grid item should be based on the size of its content.
    /// Content that overflows this node should *not* contribute to the scroll region of its parent.
    Clip,
    /// The automatic minimum size of this node as a flexbox/grid item should be `0`.
    /// Content that overflows this node should *not* contribute to the scroll region of its parent.
    Hidden,
    /// The automatic minimum size of this node as a flexbox/grid item should be `0`. Additionally, space should be reserved
    /// for a scrollbar. The amount of space reserved is controlled by the `scrollbar_width` property.
    /// Content that overflows this node should *not* contribute to the scroll region of its parent.
    Scroll,
}

/// The positioning strategy for this item.
///
/// This controls both how the origin is determined for the [`Style::position`] field,
/// and whether or not the item will be controlled by flexbox's layout algorithm.
///
/// [`Position::Relative`] is the default. GPUI has no CSS `static` position mode.
/// See the [CSS positioning reference](https://developer.mozilla.org/en-US/docs/Web/CSS/position)
/// for related terminology; GPUI exposes only the two modes below.
#[derive(Copy, Clone, PartialEq, Eq, Debug, Default, Serialize, Deserialize, JsonSchema)]
// Copy of taffy::style type of the same name, to derive JsonSchema.
pub enum Position {
    /// The offset is computed relative to the final position given by the layout algorithm.
    /// Offsets do not affect the position of any other items; they are effectively a correction factor applied at the end.
    #[default]
    Relative,
    /// The offset is computed relative to this item's closest positioned ancestor, if any.
    /// Otherwise, it is placed relative to the origin.
    /// No space is reserved among normally laid-out siblings. The item's size is still computed
    /// from its style, contents, and containing bounds.
    ///
    /// Absolute positioning still performs layout. Use [`Display::None`] to omit the subtree.
    Absolute,
}

impl From<AlignItems> for taffy::style::AlignItems {
    fn from(value: AlignItems) -> Self {
        match value {
            AlignItems::Start => Self::START,
            AlignItems::End => Self::END,
            AlignItems::FlexStart => Self::FLEX_START,
            AlignItems::FlexEnd => Self::FLEX_END,
            AlignItems::Center => Self::CENTER,
            AlignItems::Baseline => Self::BASELINE,
            AlignItems::Stretch => Self::STRETCH,
        }
    }
}

impl From<AlignContent> for taffy::style::AlignContent {
    fn from(value: AlignContent) -> Self {
        match value {
            AlignContent::Start => Self::START,
            AlignContent::End => Self::END,
            AlignContent::FlexStart => Self::FLEX_START,
            AlignContent::FlexEnd => Self::FLEX_END,
            AlignContent::Center => Self::CENTER,
            AlignContent::Stretch => Self::STRETCH,
            AlignContent::SpaceBetween => Self::SPACE_BETWEEN,
            AlignContent::SpaceEvenly => Self::SPACE_EVENLY,
            AlignContent::SpaceAround => Self::SPACE_AROUND,
        }
    }
}

impl From<Display> for taffy::style::Display {
    fn from(value: Display) -> Self {
        match value {
            Display::Block | Display::Inline => Self::Block,
            Display::Flex | Display::InlineFlex => Self::Flex,
            Display::Grid => Self::Grid,
            Display::None => Self::None,
        }
    }
}

impl From<FlexWrap> for taffy::style::FlexWrap {
    fn from(value: FlexWrap) -> Self {
        match value {
            FlexWrap::NoWrap => Self::NoWrap,
            FlexWrap::Wrap => Self::Wrap,
            FlexWrap::WrapReverse => Self::WrapReverse,
        }
    }
}

impl From<FlexDirection> for taffy::style::FlexDirection {
    fn from(value: FlexDirection) -> Self {
        match value {
            FlexDirection::Row => Self::Row,
            FlexDirection::Column => Self::Column,
            FlexDirection::RowReverse => Self::RowReverse,
            FlexDirection::ColumnReverse => Self::ColumnReverse,
        }
    }
}

impl From<Overflow> for taffy::style::Overflow {
    fn from(value: Overflow) -> Self {
        match value {
            Overflow::Visible => Self::Visible,
            Overflow::Clip => Self::Clip,
            Overflow::Hidden => Self::Hidden,
            Overflow::Scroll => Self::Scroll,
        }
    }
}

impl From<Position> for taffy::style::Position {
    fn from(value: Position) -> Self {
        match value {
            Position::Relative => Self::Relative,
            Position::Absolute => Self::Absolute,
        }
    }
}

#[cfg(test)]
mod tests {
    use crate::{blue, green, hsla, linear_color_stop, linear_gradient, px, red, yellow};
    use palette::WithAlpha;

    use super::*;

    fn ring_gradient() -> Background {
        linear_gradient(
            90.,
            linear_color_stop(red(), 0.),
            linear_color_stop(blue(), 1.),
        )
    }

    #[test]
    fn border_color_accepts_backgrounds_and_solid_colors() {
        let gradient = linear_gradient(
            90.0,
            linear_color_stop(red(), 0.0),
            linear_color_stop(blue(), 1.0),
        );
        let gradient_style = StyleRefinement::default().border_color(gradient);
        assert_eq!(gradient_style.border_color, Some(gradient));

        let solid_style = StyleRefinement::default().border_color(red());
        assert_eq!(solid_style.border_color, Some(red().into()));
    }

    #[test]
    fn test_basic_highlight_style_combination() {
        let style_a = HighlightStyle::default();
        let style_b = HighlightStyle::default();
        let style_a = style_a.highlight(style_b);
        assert_eq!(
            style_a,
            HighlightStyle::default(),
            "Combining empty styles should not produce a non-empty style."
        );

        let mut style_b = HighlightStyle {
            color: Some(red()),
            strikethrough: Some(StrikethroughStyle {
                thickness: px(2.),
                color: Some(blue()),
            }),
            fade_out: Some(0.),
            font_style: Some(FontStyle::Italic),
            font_weight: Some(FontWeight(300.)),
            font_width: Some(FontWidth::CONDENSED),
            background_color: Some(yellow()),
            underline: Some(UnderlineStyle {
                thickness: px(2.),
                color: Some(red()),
                wavy: true,
            }),
        };
        let expected_style = style_b;

        assert_eq!(
            TextStyle::default().highlight(style_b).font_width,
            FontWidth::CONDENSED
        );

        let style_a = style_a.highlight(style_b);
        assert_eq!(
            style_a, expected_style,
            "Blending an empty style with another style should return the other style"
        );

        let style_b = style_b.highlight(Default::default());
        assert_eq!(
            style_b, expected_style,
            "Blending a style with an empty style should not change the style."
        );

        let mut style_c = expected_style;

        let style_d = HighlightStyle {
            color: Some(blue().with_alpha(0.7)),
            strikethrough: Some(StrikethroughStyle {
                thickness: px(4.),
                color: Some(crate::red()),
            }),
            fade_out: Some(0.),
            font_style: Some(FontStyle::Oblique),
            font_weight: Some(FontWeight(800.)),
            font_width: Some(FontWidth::EXPANDED),
            background_color: Some(green()),
            underline: Some(UnderlineStyle {
                thickness: px(4.),
                color: None,
                wavy: false,
            }),
        };

        let expected_style = HighlightStyle {
            color: Some(red().blend(&blue().with_alpha(0.7))),
            strikethrough: Some(StrikethroughStyle {
                thickness: px(4.),
                color: Some(red()),
            }),
            // TODO this does not seem right
            fade_out: Some(0.),
            font_style: Some(FontStyle::Oblique),
            font_weight: Some(FontWeight(800.)),
            font_width: Some(FontWidth::EXPANDED),
            background_color: Some(green()),
            underline: Some(UnderlineStyle {
                thickness: px(4.),
                color: None,
                wavy: false,
            }),
        };

        let style_c = style_c.highlight(style_d);
        assert_eq!(
            style_c, expected_style,
            "Blending styles should blend properties where possible and override all others"
        );
    }

    #[test]
    fn test_combine_highlights() {
        assert_eq!(
            combine_highlights(
                [
                    (0..5, green().into()),
                    (4..10, FontWeight::BOLD.into()),
                    (15..20, yellow().into()),
                ],
                [
                    (2..6, FontStyle::Italic.into()),
                    (1..3, blue().into()),
                    (21..23, red().into()),
                ]
            )
            .collect::<Vec<_>>(),
            [
                (
                    0..1,
                    HighlightStyle {
                        color: Some(green()),
                        ..Default::default()
                    }
                ),
                (
                    1..2,
                    HighlightStyle {
                        color: Some(blue()),
                        ..Default::default()
                    }
                ),
                (
                    2..3,
                    HighlightStyle {
                        color: Some(blue()),
                        font_style: Some(FontStyle::Italic),
                        ..Default::default()
                    }
                ),
                (
                    3..4,
                    HighlightStyle {
                        color: Some(green()),
                        font_style: Some(FontStyle::Italic),
                        ..Default::default()
                    }
                ),
                (
                    4..5,
                    HighlightStyle {
                        color: Some(green()),
                        font_weight: Some(FontWeight::BOLD),
                        font_style: Some(FontStyle::Italic),
                        ..Default::default()
                    }
                ),
                (
                    5..6,
                    HighlightStyle {
                        font_weight: Some(FontWeight::BOLD),
                        font_style: Some(FontStyle::Italic),
                        ..Default::default()
                    }
                ),
                (
                    6..10,
                    HighlightStyle {
                        font_weight: Some(FontWeight::BOLD),
                        ..Default::default()
                    }
                ),
                (
                    15..20,
                    HighlightStyle {
                        color: Some(yellow()),
                        ..Default::default()
                    }
                ),
                (
                    21..23,
                    HighlightStyle {
                        color: Some(red()),
                        ..Default::default()
                    }
                )
            ]
        );
    }

    #[test]
    fn test_text_style_refinement() {
        let mut style = Style::default();
        style.refine(&StyleRefinement::default().text_size(px(20.0)));
        style.refine(&StyleRefinement::default().font_weight(FontWeight::SEMIBOLD));
        style.refine(&StyleRefinement::default().font_width(87.5));

        assert_eq!(
            Some(AbsoluteLength::from(px(20.0))),
            style.text_style().unwrap().font_size
        );

        assert_eq!(
            Some(FontWeight::SEMIBOLD),
            style.text_style().unwrap().font_weight
        );

        let mut resolved = TextStyle::default();
        resolved.refine(style.text_style().unwrap());
        let inherited = resolved.highlight(HighlightStyle::color(red()));

        assert_eq!(inherited.font().width, FontWidth::SEMI_CONDENSED);
        assert_eq!(inherited.to_run(4).font.width, FontWidth::SEMI_CONDENSED);
        assert_eq!(
            HighlightStyle::from(&inherited).font_width,
            Some(FontWidth::SEMI_CONDENSED)
        );

        let mut element = crate::div()
            .font_width(FontWidth::CONDENSED)
            .font(crate::font("IBM Plex Sans"));
        assert_eq!(element.text_style().font_width, Some(FontWidth::NORMAL));
    }

    #[test]
    fn dashed_border_pattern_has_legacy_defaults_and_refines_independently() {
        let mut style = Style::default();

        assert_eq!(
            style.border_dashed_length,
            crate::scene::DEFAULT_BORDER_DASHED_LENGTH
        );
        assert_eq!(
            style.border_dashed_gap,
            crate::scene::DEFAULT_BORDER_DASHED_GAP
        );

        style.refine(
            &StyleRefinement::default()
                .border_dashed_length(4.0)
                .border_dashed_gap(0.5),
        );

        assert_eq!(style.border_dashed_length, 4.0);
        assert_eq!(style.border_dashed_gap, 0.5);
        assert_eq!(style.border_style, BorderStyle::Solid);

        style.refine(&StyleRefinement::default().border_dashed());
        assert_eq!(style.border_style, BorderStyle::Dashed);
    }

    #[test]
    fn outer_ring_is_hollow_and_composes_with_shadows() {
        let drop_shadow = BoxShadow::new(px(0.), px(2.), blue()).blur_radius(px(4.));
        let mut style = Style::default();
        style.refine(
            &StyleRefinement::default()
                .ring_2()
                .shadow(vec![drop_shadow.clone()]),
        );
        let current_color = hsla(0.7, 0.5, 0.4, 0.8);
        style.refine(&StyleRefinement::default().ring(px(3.5)));
        let element_bounds = Bounds {
            origin: point(px(10.), px(20.)),
            size: size(px(100.), px(40.)),
        };
        let element_radii = Corners {
            top_left: px(0.),
            top_right: px(4.),
            bottom_right: px(10.),
            bottom_left: px(20.),
        };
        let ring = style
            .ring
            .outer_quad(element_bounds, element_radii, current_color)
            .unwrap();

        assert_eq!(ring.bounds.dilate(-px(3.5)), element_bounds);
        assert_eq!(ring.border_widths, Edges::all(px(3.5)));
        assert_eq!(
            ring.corner_radii.map(|radius| *radius - px(3.5)),
            element_radii
        );
        assert!(ring.background.is_transparent());
        assert_eq!(ring.border_color, current_color.into());
        assert_eq!(ring.border_style, BorderStyle::Solid);
        assert_eq!(style.box_shadow, vec![drop_shadow]);

        let gradient = ring_gradient();
        style.refine(&StyleRefinement::default().ring_color(gradient));
        assert_eq!(
            style
                .ring
                .outer_quad(element_bounds, element_radii, current_color)
                .unwrap()
                .border_color,
            gradient
        );

        style.refine(&StyleRefinement::default().ring_0());
        assert!(
            style
                .ring
                .outer_quad(element_bounds, element_radii, current_color)
                .is_none()
        );
        assert_eq!(style.box_shadow.len(), 1);
    }

    #[test]
    fn inset_ring_utility_refines_independently_and_lowers_to_an_inset_shadow() {
        let gradient = ring_gradient();
        let mut style = Style::default();
        style.refine(
            &StyleRefinement::default()
                .inset_ring(px(1.))
                .inset_ring_color(gradient),
        );
        style.refine(&StyleRefinement::default().inset_ring_4());

        let inset = style.inset_ring.inset_shadow(blue()).unwrap();

        assert_eq!(inset.offset, point(px(0.), px(0.)));
        assert_eq!(inset.blur_radius, px(0.));
        assert_eq!(inset.spread_radius, px(4.));
        assert_eq!(inset.color, gradient);
        assert!(inset.inset);
        assert_eq!(style.ring, RingStyle::default());
    }
}
