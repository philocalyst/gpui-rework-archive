//! Colors for text, fills, and borders, with gradients and repeating patterns.
//!
//! Start with [`rgb`] for an opaque hexadecimal color or [`rgba`] when the
//! last byte supplies alpha. Both return sRGB [`Rgba`]. APIs that store [`Hsla`]
//! accept an explicit [`rgb_to_hsla`] conversion; background builders accept
//! either representation. [`Background`] describes paint, including a solid
//! color, a two-stop gradient, or a procedural pattern.
//!
//! Three operations answer different questions: [`ColorExt::opacity`] changes
//! how much a color contributes, [`ColorExt::blend`] composites an overlay over
//! a base, and [`Lerp`](crate::Lerp) finds an intermediate animation value.
//! A gradient instead varies across its drawing bounds and uses its own
//! [`ColorSpace`]. The [drawing chapter](crate::_documentation::drawing#choose-colors-and-backgrounds)
//! connects those choices to painting.

use palette::{IntoColor, OklabHue, Oklcha, RgbHue};
pub(crate) mod serde_colors;
use schemars::{JsonSchema, json_schema};
use serde::{Deserialize, Serialize};
use std::fmt::{self, Display, Formatter};

// Re-exported for api maintenance
pub use palette::{Hsla, rgb::Rgba};

/// Converts `0xRRGGBB` into opaque sRGB [`Rgba`], ignoring the highest byte.
///
/// Each channel becomes its byte value divided by 255. Use [`rgba`] when
/// the input also contains an alpha byte; `rgb(0x000000)` is opaque black.
///
/// ```
/// use gpui::{rgb, rgba};
///
/// assert_eq!(rgb(0x155b50), rgba(0x155b50ff));
/// assert_eq!(rgb(0x000000).alpha, 1.0);
/// ```
pub fn rgb(hex: u32) -> Rgba {
    let [_, r, g, b] = hex.to_be_bytes().map(|b| (b as f32) / 255.0);
    Rgba {
        color: palette::rgb::Rgb::new(r, g, b),
        alpha: 1.0,
    }
}

/// Converts `0xRRGGBBAA` into sRGB [`Rgba`].
///
/// The lowest byte is alpha: `00` is transparent and `ff` is opaque. These
/// are straight-alpha channels; RGB is not multiplied by alpha. In particular,
/// `rgba(0x155b5080)` has alpha `128 / 255`, slightly more than one half.
pub fn rgba(hex: u32) -> Rgba {
    let [r, g, b, a] = hex.to_be_bytes().map(|b| (b as f32) / 255.0);
    Rgba::new(r, g, b, a)
}

/// Convert an sRGB color to GPUI's HSL-with-alpha representation.
///
/// Use this when a field requires [`Hsla`], such as [`TextStyle::color`](crate::TextStyle::color).
/// Alpha is preserved. Converting the representation does not composite the
/// color over a background or apply opacity.
pub fn rgb_to_hsla(color: Rgba) -> Hsla {
    color.into_color()
}

/// Convert GPUI's HSL-with-alpha representation to sRGB.
///
/// Alpha is preserved. See [`rgb_to_hsla`] for the reverse conversion.
pub fn hsla_to_rgba(color: Hsla) -> Rgba {
    color.into_color()
}

/// Convert one premultiplied RGBA pixel to straight-alpha BGRA in place.
///
/// `color` must contain at least four bytes in `[r, g, b, a]` order. The
/// function swaps the red and blue channels and unpremultiplies RGB when
/// alpha is nonzero. Bytes after the first pixel are unchanged; call it on
/// each four-byte chunk to convert an image. With zero alpha, the swapped
/// channel bytes are preserved.
///
/// # Panics
///
/// Panics if the slice contains fewer than four bytes.
pub fn swap_rgba_pa_to_bgra(color: &mut [u8]) {
    color.swap(0, 2);
    if color[3] > 0 {
        let a = color[3] as f32 / 255.;
        color[0] = (color[0] as f32 / a) as u8;
        color[1] = (color[1] as f32 / a) as u8;
        color[2] = (color[2] as f32 / a) as u8;
    }
}

/// Constructs [`Hsla`] from normalized hue, saturation, lightness, and alpha.
///
/// Hue is expressed in turns (`1.0` is a full circle), not degrees. Every
/// finite input is clamped to `0.0..=1.0`. Thus `0.0` and `1.0` both select
/// red, while `0.5` selects cyan. Constructing [`Hsla`] directly uses degrees
/// and does not apply this helper's clamping.
pub const fn hsla(h: f32, s: f32, l: f32, a: f32) -> Hsla {
    Hsla {
        color: palette::Hsl::new_const(
            // `RgbHue` stores degrees, so the 0..1 fraction of the circle needs
            // scaling to 0..360 before it's wrapped.
            RgbHue::new(h.clamp(0., 1.) * 360.),
            s.clamp(0., 1.),
            l.clamp(0., 1.),
        ),
        alpha: a.clamp(0., 1.),
    }
}

/// Constructs a [`palette::Oklcha`] value from its components.
///
/// Lightness and chroma use Oklab coordinates; `hue` accepts a Palette Oklab
/// hue value, or degrees when supplied as a plain number. This differs from
/// [`hsla`], whose hue argument is in turns. For ordinary `f32` colors, use
/// lightness and alpha in `0.0..=1.0` and nonnegative chroma; the available
/// chroma depends on the target gamut. This helper stores every component
/// without clamping or validation.
pub fn oklcha<T>(lightness: T, chroma: T, hue: impl Into<OklabHue<T>>, alpha: T) -> Oklcha<T> {
    Oklcha::new(lightness, chroma, hue, alpha)
}

/// Pure black in [`Hsla`]
pub const fn black() -> Hsla {
    Hsla::new_const(RgbHue::new(0.), 0., 0., 1.)
}

/// Transparent black in [`Hsla`]
pub const fn transparent_black() -> Hsla {
    Hsla::new_const(RgbHue::new(0.), 0., 0., 0.)
}

/// Transparent white in [`Hsla`]
pub const fn transparent_white() -> Hsla {
    Hsla::new_const(RgbHue::new(0.), 0., 1., 0.)
}

/// A gray color with the supplied lightness and alpha.
///
/// Despite the name, the result is opaque only when `opacity` is `1.0`.
/// Supply both arguments in `0.0..=1.0`; this helper does not clamp them.
pub const fn opaque_grey(lightness: f32, opacity: f32) -> Hsla {
    Hsla::new_const(RgbHue::new(0.), 0., lightness, opacity)
}

/// Pure white in [`Hsla`]
pub const fn white() -> Hsla {
    Hsla::new_const(RgbHue::new(0.), 0., 1., 1.)
}

/// The color red in [`Hsla`]
pub const fn red() -> Hsla {
    Hsla::new_const(RgbHue::new(0.), 1., 0.5, 1.)
}

/// The color blue in [`Hsla`]
pub const fn blue() -> Hsla {
    Hsla::new_const(RgbHue::new(240.), 1., 0.5, 1.)
}

/// The color green in [`Hsla`]
pub const fn green() -> Hsla {
    Hsla::new_const(RgbHue::new(120.), 1., 0.25, 1.)
}

/// The color yellow in [`Hsla`]
pub const fn yellow() -> Hsla {
    Hsla::new_const(RgbHue::new(60.), 1., 0.5, 1.)
}

/// Builds an object schema for Palette's serialized [`Hsla`] field names.
///
/// The schema describes numeric `hue`, `saturation`, `lightness`, and `alpha`
/// properties. It imposes no component ranges and does not make the fields
/// required. The generator argument is unused; this helper supplies a schema,
/// not color parsing or validation.
pub fn hsla_schemar(_generator: &mut schemars::SchemaGenerator) -> schemars::Schema {
    // https://github.com/Ogeon/palette/blob/9aa1ac21a7da60db398e8c044a43dbf3fdaf4855/palette/src/hsl.rs#L633-L636
    // https://github.com/Ogeon/palette/blob/9aa1ac21a7da60db398e8c044a43dbf3fdaf4855/palette/src/alpha/alpha.rs#L1197
    json_schema!({
        "type": "object",
        "properties": {
          "hue": {
              "type": "number",
              "format": "float"
          },
          "saturation": {
              "type": "number",
              "format": "float"
          },
          "lightness": {
              "type": "number",
              "format": "float"
          },
          "alpha": {
              "type": "number",
              "format": "float"
          },
        }
    })
}

/// Builds an object schema for Palette's serialized [`Rgba`] field names.
///
/// The numeric properties are `red`, `green`, `blue`, and `alpha`. As with
/// [`hsla_schemar`], this schema specifies neither required fields nor ranges.
pub fn rgba_schemar(_generator: &mut schemars::SchemaGenerator) -> schemars::Schema {
    // https://github.com/Ogeon/palette/blob/9aa1ac21a7da60db398e8c044a43dbf3fdaf4855/palette/src/rgb/rgb.rs#L1690
    // https://github.com/Ogeon/palette/blob/9aa1ac21a7da60db398e8c044a43dbf3fdaf4855/palette/src/alpha/alpha.rs#L1197
    json_schema!({
        "type": "object",
        "properties": {
          "red": {
              "type": "number",
              "format": "float"
          },
          "green": {
              "type": "number",
              "format": "float"
          },
          "blue": {
              "type": "number",
              "format": "float"
          },
          "alpha": {
              "type": "number",
              "format": "float"
          },
        }
    })
}

/// Alpha adjustment and source-over compositing for [`Rgba`] and [`Hsla`].
///
/// [`opacity`](Self::opacity) returns a faded copy; [`fade_out`](Self::fade_out)
/// changes the existing value. Both multiply its current alpha. Use
/// [`blend`](Self::blend) when an overlay must contribute its color to a base.
pub trait ColorExt {
    /// Composite `other` over `self`, preserving alpha in the result.
    ///
    /// A transparent `other` leaves the base unchanged; an opaque `other`
    /// replaces it. HSL values are converted to sRGB for this operation.
    /// Compositing uses the stored sRGB channels without a linear-light
    /// conversion. This differs from interpolating two colors with [`crate::Lerp`].
    ///
    /// ```
    /// use gpui::{ColorExt, Rgba};
    ///
    /// let base = Rgba::new(1.0, 0.0, 0.0, 1.0);
    /// let overlay = Rgba::new(0.0, 0.0, 1.0, 0.25);
    /// assert_eq!(base.blend(&overlay), Rgba::new(0.75, 0.0, 0.25, 1.0));
    /// ```
    fn blend(&self, other: &Self) -> Self
    where
        Self: Sized;

    /// Fades the color by multiplying alpha by `1.0 - factor`.
    ///
    /// `factor` is clamped to `0.0..=1.0`; `0.0` leaves alpha unchanged and
    /// `1.0` makes it transparent.
    fn fade_out(&mut self, factor: f32);

    /// Returns a copy with alpha multiplied by a factor clamped to `0.0..=1.0`.
    ///
    /// The factor is clamped, not the resulting alpha. Color channels are unchanged.
    /// Repeated calls multiply their effects. To replace alpha instead, use
    /// Palette's [`with_alpha`](palette::WithAlpha::with_alpha).
    ///
    /// ```
    /// use gpui::{ColorExt, hsla};
    ///
    /// let color = hsla(0.7, 1.0, 0.5, 0.8);
    /// assert_eq!(color.opacity(0.5).alpha, 0.4);
    /// assert_eq!(color.opacity(0.5).opacity(0.5).alpha, 0.2);
    /// assert_eq!(color.opacity(2.0).alpha, 0.8);
    /// ```
    fn opacity(&self, factor: f32) -> Self
    where
        Self: Sized;
}
impl ColorExt for Rgba {
    fn blend(&self, other: &Self) -> Self {
        use palette::blend::Compose;
        other.over(*self)
    }

    fn fade_out(&mut self, factor: f32) {
        self.alpha *= 1.0 - factor.clamp(0., 1.);
    }

    fn opacity(&self, factor: f32) -> Self {
        let mut color = *self;
        color.alpha *= factor.clamp(0., 1.);
        color
    }
}
impl ColorExt for Hsla {
    fn blend(&self, other: &Self) -> Self {
        let this: Rgba = (*self).into_color();
        let other: Rgba = (*other).into_color();
        this.blend(&other).into_color()
    }

    fn fade_out(&mut self, factor: f32) {
        self.alpha *= 1.0 - factor.clamp(0., 1.);
    }

    fn opacity(&self, factor: f32) -> Self {
        let mut color = *self;
        color.alpha *= factor.clamp(0., 1.);
        color
    }
}

/// The storage-buffer discriminant for a [`Background`].
#[derive(Debug, Clone, Copy, PartialEq, Serialize, Deserialize, JsonSchema)]
#[repr(u32)]
pub enum BackgroundTag {
    /// A flat color.
    Solid = 0,
    /// A two-stop linear gradient.
    LinearGradient = 1,
    /// Diagonal color stripes over transparency.
    PatternSlash = 2,
    /// Alternating colored and transparent squares.
    Checkerboard = 3,
}

/// Selects the renderer's interpolation path between gradient stops.
///
/// Set it with [`Background::color_space`]. [`linear_gradient`] selects
/// [`Oklab`](Self::Oklab); this enum's standalone default is [`Srgb`](Self::Srgb).
/// The choice affects the intermediate colors, not the stop positions, output
/// display profile, or [`Lerp`](crate::Lerp) implementation for solid colors.
/// [Oklab](https://bottosson.github.io/posts/oklab/) was designed to make
/// equal coordinate steps more nearly equal in perceived color difference.
///
/// > [!NOTE]
/// > The supplied shader preserves legacy transfer curves, including a
/// > gamma-2.2 approximation in its Oklab conversion. It interpolates color
/// > components and alpha separately, without premultiplying the stops.
/// > These modes do not promise pixel equivalence with CSS gradients.
#[derive(Debug, Clone, Copy, PartialEq, Default, Serialize, Deserialize, JsonSchema)]
#[repr(u32)]
pub enum ColorSpace {
    #[default]
    /// The renderer's sRGB interpolation mode.
    Srgb = 0,
    /// The renderer's Oklab interpolation mode, selected by [`linear_gradient`].
    Oklab = 1,
}

impl Display for ColorSpace {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        match self {
            ColorSpace::Srgb => write!(f, "sRGB"),
            ColorSpace::Oklab => write!(f, "Oklab"),
        }
    }
}

/// A paintable background: solid, gradient, or procedural pattern.
///
/// A color converts directly into a solid background. Use [`linear_gradient`],
/// [`checkerboard`], or [`pattern_slash`] for the other forms, then pass the
/// result to [`Styled::bg`](crate::Styled::bg) or a window paint operation.
/// Constructing a background draws nothing and chooses no layout size.
///
/// [`kind`](Self::kind) exposes its paint parameters; gradient interpolation
/// space is queried separately with [`interpolation_space`](Self::interpolation_space).
/// The default background is opaque black. To paint nothing, use
/// [`transparent_black`] or apply [`opacity(0.)`](Self::opacity).
#[derive(Clone, Copy, PartialEq, Serialize, Deserialize, JsonSchema)]
#[repr(C)]
pub struct Background {
    pub(crate) tag: BackgroundTag,
    pub(crate) color_space: ColorSpace,
    pub(crate) solid: crate::SceneHsla,
    pub(crate) gradient_angle_or_pattern_height: f32,
    pub(crate) colors: [LinearColorStop; 2],
    /// Padding for alignment for repr(C) layout.
    pub(crate) padding: u32,
}

impl std::fmt::Debug for Background {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        match self.tag {
            BackgroundTag::Solid => write!(f, "Solid({:?})", self.solid),
            BackgroundTag::LinearGradient => write!(
                f,
                "LinearGradient({}, {:?}, {:?})",
                self.gradient_angle_or_pattern_height, self.colors[0], self.colors[1]
            ),
            BackgroundTag::PatternSlash => write!(
                f,
                "PatternSlash({:?}, {})",
                self.solid, self.gradient_angle_or_pattern_height
            ),
            BackgroundTag::Checkerboard => write!(
                f,
                "Checkerboard({:?}, {})",
                self.solid, self.gradient_angle_or_pattern_height
            ),
        }
    }
}

impl Eq for Background {}
impl Default for Background {
    fn default() -> Self {
        Self {
            tag: BackgroundTag::Solid,
            solid: Hsla::default().into(),
            color_space: ColorSpace::default(),
            gradient_angle_or_pattern_height: 0.0,
            colors: [LinearColorStop::default(), LinearColorStop::default()],
            padding: 0,
        }
    }
}

/// Creates diagonal colored stripes separated by transparent gaps.
///
/// `width` and `interval` are measured in renderer pixels. They are not scaled
/// with the window's display density; multiply both by
/// [`Window::scale_factor`](crate::Window::scale_factor)
/// when the pattern should keep a chosen logical-pixel size. The pattern starts
/// at the painted bounds' origin.
///
/// Supply a finite `width` in `0.0..=257.0` and a finite `interval` in
/// `0.0..257.0`. The packed representation quantizes both values to steps of
/// `1.0 / 255.0`; floating-point storage can reduce precision further as width
/// increases. Keep their sum positive. No validation is performed.
///
/// # Panics
///
/// Widths outside the packed range can overflow integer arithmetic in debug
/// builds and produce an invalid pattern in release builds.
pub fn pattern_slash(color: impl IntoColor<Hsla>, width: f32, interval: f32) -> Background {
    const PATTERN_COMPONENT_SCALE: f32 = u8::MAX as f32;
    const PATTERN_PACKING_RADIX: u32 = u16::MAX as u32;

    let width_scaled = (width * PATTERN_COMPONENT_SCALE) as u32;
    let interval_scaled = (interval * PATTERN_COMPONENT_SCALE) as u32;
    let height = (width_scaled * PATTERN_PACKING_RADIX + interval_scaled) as f32;

    Background {
        tag: BackgroundTag::PatternSlash,
        solid: color.into_color().into(),
        gradient_angle_or_pattern_height: height,
        ..Default::default()
    }
}

/// Creates alternating colored and transparent squares.
///
/// `size` is each square's side in renderer pixels, measured from the painted
/// bounds' origin. The display scale is not applied to it. Multiply by
/// [`Window::scale_factor`](crate::Window::scale_factor) for a constant
/// logical-pixel size. Supply a finite, positive value; it is stored without
/// validation. Transparent squares reveal
/// what was painted underneath, so draw a solid base first for two opaque colors.
pub fn checkerboard(color: impl IntoColor<Hsla>, size: f32) -> Background {
    Background {
        tag: BackgroundTag::Checkerboard,
        solid: color.into_color().into(),
        gradient_angle_or_pattern_height: size,
        ..Default::default()
    }
}

/// Creates a solid background color.
///
/// Equivalent to converting the color with [`Background::from`]. Alpha is
/// preserved; this does not composite the color with another background.
pub fn solid_background(color: impl IntoColor<Hsla>) -> Background {
    Background {
        solid: color.into_color().into(),
        ..Default::default()
    }
}

/// Creates a two-stop linear gradient, with stops blended in Oklab by default.
///
/// `angle` is measured in degrees: `0.0` points up and larger values rotate
/// clockwise: `90.0` points right and `180.0` points down. Supply finite stop
/// positions with `0.0 <= from.percentage < to.percentage <= 1.0`; `0.25`
/// means one quarter, not 25 percent as a whole number. Before the first stop
/// and after the second, the nearest endpoint color continues. The constructor
/// neither sorts nor validates stops; equal positions divide by zero in the
/// supplied shader and are not a supported way to request a hard edge.
///
/// ```
/// use gpui::{ColorSpace, div, linear_color_stop, linear_gradient, prelude::*, rgb};
///
/// let background = linear_gradient(
///     90.0,
///     linear_color_stop(rgb(0x155b50), 0.0),
///     linear_color_stop(rgb(0x3478c8), 1.0),
/// );
/// assert_eq!(background.interpolation_space(), ColorSpace::Oklab);
/// let panel = div().w_64().h_24().bg(background);
/// ```
///
/// [`Background::color_space`] changes interpolation. For a fade to transparency,
/// keep the endpoint's RGB color and reduce its alpha: fading to transparent
/// black also changes the color along the way. See [`ColorSpace`] for the
/// supplied renderer's conversion and alpha policy.
pub fn linear_gradient(
    angle: f32,
    from: impl Into<LinearColorStop>,
    to: impl Into<LinearColorStop>,
) -> Background {
    Background {
        tag: BackgroundTag::LinearGradient,
        gradient_angle_or_pattern_height: angle,
        colors: [from.into(), to.into()],
        color_space: ColorSpace::Oklab,
        ..Default::default()
    }
}

/// One color and position in the two-stop [`linear_gradient`] representation.
///
/// Construct with [`linear_color_stop`] to convert an ordinary color to the
/// scene representation. The position is a fraction along the gradient's line,
/// not a pixel distance. Gradient construction preserves the two stops in the
/// supplied order; it does not apply CSS's stop-order correction rules.
#[derive(Debug, Clone, Copy, Default, PartialEq, Serialize, Deserialize, JsonSchema)]
#[repr(C)]
pub struct LinearColorStop {
    /// The stop's color in GPUI's scene representation, including alpha.
    pub color: crate::SceneHsla,
    /// The normalized position in the gradient, conventionally `0.0..=1.0`.
    pub percentage: f32,
}

/// Creates a linear color stop at normalized position `percentage`.
///
/// Use a finite fraction in `0.0..=1.0`, such as `0.25` for one quarter.
/// The value is stored unchanged. The pair passed to [`linear_gradient`]
/// must be strictly increasing; constructing one stop does not validate that pair.
pub fn linear_color_stop(color: impl IntoColor<Hsla>, percentage: f32) -> LinearColorStop {
    LinearColorStop {
        color: color.into_color().into(),
        percentage,
    }
}

impl LinearColorStop {
    /// Multiplies this stop's alpha by a factor clamped to `0.0..=1.0`.
    ///
    /// Preserves its position and color components. Repeated calls multiply
    /// their effects, as in [`ColorExt::opacity`].
    pub fn opacity(&self, factor: f32) -> Self {
        let color: Hsla = self.color.into();
        Self {
            percentage: self.percentage,
            color: color.opacity(factor).into(),
        }
    }
}

/// What a [`Background`] paints, decoded from its packed representation.
#[derive(Debug, Clone, Copy, PartialEq)]
pub enum BackgroundKind {
    /// A flat color.
    Solid(Hsla),
    /// A linear gradient between two color stops.
    LinearGradient {
        /// The gradient line's angle in degrees, `0.0` pointing up, increasing clockwise.
        angle: f32,
        /// The two ends of the gradient.
        stops: [LinearColorStop; 2],
    },
    /// A diagonal stripe pattern.
    PatternSlash {
        /// The stripe color.
        color: Hsla,
        /// The decoded stripe width in renderer pixels; packing can lose precision.
        width: f32,
        /// The decoded gap in renderer pixels; packing can lose precision.
        interval: f32,
    },
    /// Alternating squares of one color and full transparency.
    Checkerboard {
        /// The color of one set of squares. The other set is fully transparent.
        color: Hsla,
        /// Each square's side in renderer pixels, without display-density scaling.
        size: f32,
    },
}

impl Background {
    /// Returns the solid color if this is a solid background, None otherwise.
    pub fn as_solid(&self) -> Option<Hsla> {
        if self.tag == BackgroundTag::Solid {
            Some(self.solid.into())
        } else {
            None
        }
    }

    /// Returns the paint parameters decoded from this background.
    ///
    /// Pattern dimensions can differ slightly from their constructor inputs
    /// because of packing. The result omits the gradient's interpolation space;
    /// query [`interpolation_space`](Self::interpolation_space) separately.
    pub fn kind(&self) -> BackgroundKind {
        match self.tag {
            BackgroundTag::Solid => BackgroundKind::Solid(self.solid.into()),
            BackgroundTag::LinearGradient => BackgroundKind::LinearGradient {
                angle: self.gradient_angle_or_pattern_height,
                stops: self.colors,
            },
            BackgroundTag::PatternSlash => {
                const PATTERN_COMPONENT_SCALE: f32 = u8::MAX as f32;
                const PATTERN_PACKING_RADIX: f32 = u16::MAX as f32;

                // Decode the quantized components from the packed float. Large widths may
                // lose low bits of the interval when the integer is converted to f32.
                let packed = self.gradient_angle_or_pattern_height;
                BackgroundKind::PatternSlash {
                    color: self.solid.into(),
                    width: (packed / PATTERN_PACKING_RADIX).floor() / PATTERN_COMPONENT_SCALE,
                    interval: (packed.rem_euclid(PATTERN_PACKING_RADIX)) / PATTERN_COMPONENT_SCALE,
                }
            }
            BackgroundTag::Checkerboard => BackgroundKind::Checkerboard {
                color: self.solid.into(),
                size: self.gradient_angle_or_pattern_height,
            },
        }
    }

    /// Selects the color space used to interpolate this background's gradient stops.
    ///
    /// This setting has no visual effect on solids or patterns and does not
    /// change how [`Lerp`](crate::Lerp) animates a background. See [`ColorSpace`]
    /// for the supplied renderer's interpolation policy.
    pub fn color_space(mut self, color_space: ColorSpace) -> Self {
        self.color_space = color_space;
        self
    }

    /// Returns the gradient interpolation setting, including on a solid or pattern.
    ///
    /// Solids and patterns retain this setting but do not use it when painted.
    pub fn interpolation_space(&self) -> ColorSpace {
        self.color_space
    }

    /// Multiplies every color's alpha by a factor clamped to `0.0..=1.0`.
    ///
    /// This preserves gradient positions, interpolation space, and pattern geometry.
    pub fn opacity(&self, factor: f32) -> Self {
        let mut background = *self;
        let solid: Hsla = background.solid.into();
        background.solid = solid.opacity(factor).into();
        background.colors = [
            self.colors[0].opacity(factor),
            self.colors[1].opacity(factor),
        ];
        background
    }

    /// Returns whether every color used by this background has exactly zero alpha.
    ///
    /// A patterned background with opaque stripes or squares returns `false`,
    /// even though its gaps are transparent. Geometry, clipping, and whether
    /// the background is currently on screen do not affect this query.
    pub fn is_transparent(&self) -> bool {
        match self.tag {
            BackgroundTag::Solid => self.solid.a == 0.,
            BackgroundTag::LinearGradient => self.colors.iter().all(|c| c.color.a == 0.),
            BackgroundTag::PatternSlash => self.solid.a == 0.,
            BackgroundTag::Checkerboard => self.solid.a == 0.,
        }
    }
}

impl<T: IntoColor<Hsla>> From<T> for Background {
    fn from(value: T) -> Self {
        Self {
            tag: BackgroundTag::Solid,
            solid: value.into_color().into(),
            ..Default::default()
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn color_blend_composites_the_overlay_over_the_base() {
        let base = Rgba::new(1.0, 0.0, 0.0, 1.0);
        assert_eq!(base.blend(&Rgba::new(0.0, 0.0, 1.0, 0.0)), base);
        assert_eq!(
            base.blend(&Rgba::new(0.0, 0.0, 1.0, 1.0)),
            Rgba::new(0.0, 0.0, 1.0, 1.0)
        );
        assert_eq!(
            base.blend(&Rgba::new(0.0, 0.0, 1.0, 0.25)),
            Rgba::new(0.75, 0.0, 0.25, 1.0)
        );

        let translucent = Rgba::new(1.0, 0.0, 0.0, 0.5);
        let result = translucent.blend(&Rgba::new(0.0, 0.0, 1.0, 0.5));
        assert!((result.red - 1.0 / 3.0).abs() < 1e-6);
        assert!((result.blue - 2.0 / 3.0).abs() < 1e-6);
        assert_eq!(result.alpha, 0.75);
    }

    #[test]
    fn highlight_keeps_the_base_when_the_overlay_is_transparent() {
        let base = crate::TextStyle {
            color: red(),
            ..Default::default()
        };
        let highlighted = base
            .clone()
            .highlight(crate::HighlightStyle::color(transparent_blue()));
        assert_eq!(highlighted.color, base.color);

        fn transparent_blue() -> Hsla {
            Hsla::new_const(RgbHue::new(240.), 1., 0.5, 0.)
        }
    }

    #[test]
    fn test_background_solid() {
        let color: Hsla = rgba(0xff0099ff).into_color();
        let mut background = Background::from(color);
        assert_eq!(background.tag, BackgroundTag::Solid);
        assert_eq!(background.solid, color.into());

        assert_eq!(background.opacity(0.5).solid, color.opacity(0.5).into());
        assert!(!background.is_transparent());
        background.solid = hsla(0.0, 0.0, 0.0, 0.0).into();
        assert!(background.is_transparent());
    }

    #[test]
    fn test_background_linear_gradient() {
        let from = linear_color_stop(rgba(0xff0099ff), 0.0);
        let to = linear_color_stop(rgba(0x00ff99ff), 1.0);
        let background = linear_gradient(90.0, from, to);
        assert_eq!(background.tag, BackgroundTag::LinearGradient);
        assert_eq!(background.colors[0], from);
        assert_eq!(background.colors[1], to);

        assert_eq!(background.opacity(0.5).colors[0], from.opacity(0.5));
        assert_eq!(background.opacity(0.5).colors[1], to.opacity(0.5));
        assert!(!background.is_transparent());
        assert!(background.opacity(0.0).is_transparent());
    }

    #[test]
    fn test_background_kind() {
        let color: Hsla = rgba(0xff0099ff).into_color();
        assert_eq!(Background::from(color).kind(), BackgroundKind::Solid(color));

        let from = linear_color_stop(rgba(0xff0099ff), 0.0);
        let to = linear_color_stop(rgba(0x00ff99ff), 1.0);
        assert_eq!(
            linear_gradient(90.0, from, to).kind(),
            BackgroundKind::LinearGradient {
                angle: 90.0,
                stops: [from, to],
            }
        );

        assert_eq!(
            checkerboard(color, 12.0).kind(),
            BackgroundKind::Checkerboard { color, size: 12.0 }
        );
    }

    #[test]
    fn test_background_kind_unpacks_pattern_slash() {
        let color: Hsla = rgba(0xff0099ff).into_color();
        // Both values survive to the 1/255 the constructor quantizes them to.
        for (width, interval) in [(1.0, 3.0), (0.5, 0.25), (2.0, 10.0)] {
            let BackgroundKind::PatternSlash {
                width: got_width,
                interval: got_interval,
                ..
            } = pattern_slash(color, width, interval).kind()
            else {
                panic!("pattern_slash did not produce a PatternSlash");
            };
            assert!((got_width - width).abs() <= 1.0 / 255.0);
            assert!((got_interval - interval).abs() <= 1.0 / 255.0);
        }
    }

    #[test]
    fn test_rgba_alpha() {
        use palette::WithAlpha;
        let color = Rgba::<palette::Srgb>::new(0.2, 0.6, 1.0, 0.8);
        assert_eq!(color.with_alpha(0.25).alpha, 0.25);
        // NOTE: diverging from upstream, where Rgba::alpha clamps. palette does not clamp alpha
        assert_eq!(color.with_alpha(1.5).alpha, 1.5);
    }

    #[test]
    fn test_rgba_opacity() {
        use super::ColorExt;
        let color = Rgba::new(0.2, 0.6, 1.0, 0.8);
        assert!((color.opacity(0.5).alpha - 0.4).abs() < 1e-6);
        assert_eq!(color.opacity(2.0).alpha, 0.8);
    }
}
