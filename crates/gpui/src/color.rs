//! Color values and backgrounds used by GPUI painting APIs.
//!
//! Hex helpers interpret bytes in conventional big-endian order (`0xRRGGBB`
//! and `0xRRGGBBAA`). [`Hsla`] uses Palette's hue angle in degrees and normalized
//! saturation, lightness, and alpha. The [`hsla`] helper instead accepts hue in
//! turns and clamps all four arguments to `0..=1`. Background gradients use an angle in degrees and stop
//! positions as normalized fractions. `linear_gradient` defaults to Oklab
//! interpolation between stops; solid-color interpolation and `ColorSpace`
//! are separate choices. For examples, see
//! <https://gpui-ce.github.io/examples/drawing/#paint>.

use palette::{IntoColor, OklabHue, Oklcha, RgbHue};
pub(crate) mod serde_colors;
use schemars::{JsonSchema, json_schema};
use serde::{Deserialize, Serialize};
use std::fmt::{self, Display, Formatter};

// Re-exported for api maintenance
pub use palette::{Hsla, rgb::Rgba};

/// Converts `0xRRGGBB` into opaque sRGB [`Rgba`], ignoring the highest byte.
pub fn rgb(hex: u32) -> Rgba {
    let [_, r, g, b] = hex.to_be_bytes().map(|b| (b as f32) / 255.0);
    Rgba {
        color: palette::rgb::Rgb::new(r, g, b),
        alpha: 1.0,
    }
}

/// Converts `0xRRGGBBAA` into sRGB [`Rgba`].
pub fn rgba(hex: u32) -> Rgba {
    let [r, g, b, a] = hex.to_be_bytes().map(|b| (b as f32) / 255.0);
    Rgba::new(r, g, b, a)
}

/// Convert an sRGB color to GPUI's HSL-with-alpha representation.
///
/// This is the explicit conversion boundary for APIs that store [`Hsla`]. It
/// avoids exposing Palette's conversion traits to applications and examples.
pub fn rgb_to_hsla(color: Rgba) -> Hsla {
    color.into_color()
}

/// Convert GPUI's HSL-with-alpha representation to sRGB.
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
/// input is clamped to `0.0..=1.0`.
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
/// hue value, and `alpha` is stored as supplied. This helper does not clamp or
/// validate the components.
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

/// Generates the JsonSchema for palette::Hsla
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

/// Generates the JsonSchema for palette::Rgba
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

/// Alpha adjustment and compositing for GPUI color values.
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

    /// Return a color whose alpha is multiplied by `factor`, clamped to `0.0..=1.0`.
    ///
    /// The factor is clamped, not the resulting alpha. Color channels are unchanged.
    /// If the color was previously opaque, then this is equivalent to
    /// [`with_alpha`](palette::WithAlpha::with_alpha).
    ///
    /// Useful for transforming colors with dynamic opacity,
    /// like a color from an external source.
    ///
    /// Example:
    /// ```
    /// use gpui::ColorExt;
    /// let color = gpui::red();
    /// let faded_color = color.opacity(0.5);
    /// assert_eq!(faded_color.alpha, 0.5);
    /// ```
    ///
    /// This will return a red color with half the opacity.
    ///
    /// Example:
    /// ```
    /// use gpui::{hsla, ColorExt};
    /// let color = hsla(0.7, 1.0, 0.5, 0.7); // A saturated blue
    /// let faded_color = color.opacity(0.16);
    /// assert!((faded_color.alpha - 0.112).abs() < 1e-6);
    /// ```
    ///
    /// This will return a blue color with around ~10% opacity,
    /// suitable for an element's hover or selected state.
    ///
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

/// A color space for color interpolation.
///
/// References:
/// - <https://developer.mozilla.org/en-US/docs/Web/CSS/color-interpolation-method>
/// - <https://www.w3.org/TR/css-color-4/#typedef-color-space>
#[derive(Debug, Clone, Copy, PartialEq, Default, Serialize, Deserialize, JsonSchema)]
#[repr(u32)]
pub enum ColorSpace {
    #[default]
    /// The sRGB color space.
    Srgb = 0,
    /// The Oklab color space.
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

/// Creates diagonal stripes with the given logical-pixel width and gap.
///
/// Supply a finite `width` in `0.0..=257.0` and a finite `interval` in
/// `0.0..257.0`. The packed representation quantizes both values to steps of
/// `1.0 / 255.0`; floating-point storage can reduce precision further as width
/// increases. Use small values for narrow stripes. No validation is performed.
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

/// Creates alternating colored and transparent squares of `size` logical pixels.
///
/// Supply a finite, positive size. The value is stored without validation.
pub fn checkerboard(color: impl IntoColor<Hsla>, size: f32) -> Background {
    Background {
        tag: BackgroundTag::Checkerboard,
        solid: color.into_color().into(),
        gradient_angle_or_pattern_height: size,
        ..Default::default()
    }
}

/// Creates a solid background color.
pub fn solid_background(color: impl IntoColor<Hsla>) -> Background {
    Background {
        solid: color.into_color().into(),
        ..Default::default()
    }
}

/// Creates a two-stop linear gradient, with stops blended in Oklab by default.
///
/// `angle` is measured in degrees: `0.0` points up and larger values rotate
/// clockwise. The value is stored as supplied; use `0.0..=360.0` for one
/// clockwise turn. Stop positions are normalized fractions in `0.0..=1.0`;
/// [`linear_color_stop`] preserves the supplied value, so validate untrusted
/// positions before constructing a gradient.
///
/// <https://developer.mozilla.org/en-US/docs/Web/CSS/gradient/linear-gradient>
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

/// A color stop in a linear gradient.
///
/// <https://developer.mozilla.org/en-US/docs/Web/CSS/gradient/linear-gradient#linear-color-stop>
#[derive(Debug, Clone, Copy, Default, PartialEq, Serialize, Deserialize, JsonSchema)]
#[repr(C)]
pub struct LinearColorStop {
    /// The color of the color stop.
    pub color: crate::SceneHsla,
    /// The normalized position in the gradient, conventionally `0.0..=1.0`.
    pub percentage: f32,
}

/// Creates a linear color stop at normalized position `percentage`.
///
/// Values are expected in `0.0..=1.0`; the renderer preserves the supplied
/// value, so callers should clamp or validate untrusted input.
pub fn linear_color_stop(color: impl IntoColor<Hsla>, percentage: f32) -> LinearColorStop {
    LinearColorStop {
        color: color.into_color().into(),
        percentage,
    }
}

impl LinearColorStop {
    /// Returns a new color stop with the same color, but with a modified alpha value.
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
        /// The stripe width, in logical pixels.
        width: f32,
        /// The gap between stripes, in logical pixels.
        interval: f32,
    },
    /// Alternating squares of one color and full transparency.
    Checkerboard {
        /// The color of one set of squares. The other set is fully transparent.
        color: Hsla,
        /// The width and height of each square, in logical pixels.
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

    /// Returns the decoded form of this background.
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
    /// <https://developer.mozilla.org/en-US/docs/Web/CSS/color-interpolation-method>
    pub fn color_space(mut self, color_space: ColorSpace) -> Self {
        self.color_space = color_space;
        self
    }

    /// The color space used to interpolate this background, set by [`Background::color_space`].
    pub fn interpolation_space(&self) -> ColorSpace {
        self.color_space
    }

    /// Multiply the alpha of every color by `factor`, clamped to `0.0..=1.0`.
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

    /// Returns whether the background color is transparent.
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
