use crate::Error;

/// Author color encoding. RGB can be negative or exceed one; alpha cannot.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ColorSpace {
    Srgb,
    LinearSrgb,
    DisplayP3,
    LinearDisplayP3,
    /// Perceptual lightness, chroma and hue in degrees, relative to D65.
    Oklch,
}

/// Finite, straight-alpha tagged color. Construction validates representability
/// in the extended-linear-sRGB working domain; no gamut clipping occurs here.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Color {
    channels: [f32; 4],
    space: ColorSpace,
}
impl Default for Color {
    fn default() -> Self {
        Self::TRANSPARENT
    }
}
impl Color {
    // The default neutral palette uses the same authoring space as `oklch`.
    pub const BLACK: Self = Self {
        channels: [0.0, 0.0, 0.0, 1.0],
        space: ColorSpace::Oklch,
    };
    pub const WHITE: Self = Self {
        channels: [1.0, 0.0, 0.0, 1.0],
        space: ColorSpace::Oklch,
    };
    pub const TRANSPARENT: Self = Self {
        channels: [0.0; 4],
        space: ColorSpace::Oklch,
    };
    pub const fn rgba(r: u8, g: u8, b: u8, a: u8) -> Self {
        Self {
            channels: [
                r as f32 / 255.0,
                g as f32 / 255.0,
                b as f32 / 255.0,
                a as f32 / 255.0,
            ],
            space: ColorSpace::Srgb,
        }
    }
    pub const fn rgb(r: u8, g: u8, b: u8) -> Self {
        Self::rgba(r, g, b, 255)
    }
    pub fn srgb(r: f32, g: f32, b: f32, a: f32) -> Result<Self, Error> {
        Self::new([r, g, b, a], ColorSpace::Srgb)
    }
    pub fn linear_srgb(r: f32, g: f32, b: f32, a: f32) -> Result<Self, Error> {
        Self::new([r, g, b, a], ColorSpace::LinearSrgb)
    }
    pub fn display_p3(r: f32, g: f32, b: f32, a: f32) -> Result<Self, Error> {
        Self::new([r, g, b, a], ColorSpace::DisplayP3)
    }
    pub fn linear_display_p3(r: f32, g: f32, b: f32, a: f32) -> Result<Self, Error> {
        Self::new([r, g, b, a], ColorSpace::LinearDisplayP3)
    }
    /// Perceptual authoring color: L in [0,1], C >= 0, finite hue in degrees.
    /// Hue wraps into [0,360). Alpha is in [0,1]. Invalid ranges are rejected,
    /// rather than CSS parsing's clamping. Out-of-gamut RGB remains extended;
    /// use `linear_srgb` or `linear_display_p3` for HDR scene highlights.
    pub fn oklch(lightness: f32, chroma: f32, hue: f32, alpha: f32) -> Result<Self, Error> {
        Self::new([lightness, chroma, hue, alpha], ColorSpace::Oklch)
    }
    fn new(mut channels: [f32; 4], space: ColorSpace) -> Result<Self, Error> {
        if !channels.iter().all(|v| v.is_finite()) || !(0.0..=1.0).contains(&channels[3]) {
            return Err(Error::InvalidColor);
        }
        if space == ColorSpace::Oklch {
            if !(0.0..=1.0).contains(&channels[0]) || channels[1] < 0.0 {
                return Err(Error::InvalidColor);
            }
            channels[2] = wrap_hue(channels[2] as f64);
        }
        let color = Self { channels, space };
        // Explicit numerical admission, far beyond SDR. Keeping working values
        // <=1e20 leaves ample headroom for f32 source-over intermediates.
        if color
            .linear_rgb()
            .iter()
            .any(|v| !v.is_finite() || v.abs() > 1e20)
        {
            return Err(Error::ColorOutOfRange);
        }
        Ok(color)
    }
    /// Authored components and alpha. For Oklch these are [L,C,h_degrees,a].
    pub const fn channels(self) -> [f32; 4] {
        self.channels
    }
    pub const fn space(self) -> ColorSpace {
        self.space
    }
    pub const fn alpha(self) -> f32 {
        self.channels[3]
    }
    pub fn with_alpha(self, alpha: f32) -> Result<Self, Error> {
        let mut channels = self.channels;
        channels[3] = alpha;
        Self::new(channels, self.space)
    }
    /// Straight-alpha extended linear sRGB. Negative/out-of-gamut values survive.
    pub fn to_linear_srgb(self) -> [f32; 4] {
        let rgb = self.linear_rgb();
        [rgb[0] as f32, rgb[1] as f32, rgb[2] as f32, self.alpha()]
    }
    pub fn convert(self, space: ColorSpace) -> Result<Self, Error> {
        if space == self.space {
            return Ok(self);
        }
        let mut rgb = self.linear_rgb();
        if space == ColorSpace::Oklch {
            let lab = linear_to_oklab(rgb);
            let chroma = lab[1].hypot(lab[2]);
            return Self::new(
                [
                    lab[0] as f32,
                    chroma as f32,
                    if chroma <= 1e-12 {
                        0.0
                    } else {
                        wrap_hue(lab[2].atan2(lab[1]).to_degrees())
                    },
                    self.alpha(),
                ],
                space,
            );
        }
        if matches!(space, ColorSpace::DisplayP3 | ColorSpace::LinearDisplayP3) {
            rgb = matrix(XYZ_TO_P3, matrix(SRGB_TO_XYZ, rgb));
        }
        if matches!(space, ColorSpace::Srgb | ColorSpace::DisplayP3) {
            rgb = rgb.map(encode_transfer);
        }
        Self::new(
            [rgb[0] as f32, rgb[1] as f32, rgb[2] as f32, self.alpha()],
            space,
        )
    }
    fn linear_rgb(self) -> [f64; 3] {
        if self.space == ColorSpace::Oklch {
            let [lightness, chroma, hue, _] = self.channels;
            if chroma == 0.0 {
                return [(lightness as f64).powi(3); 3];
            }
            let (sin, cos) = (hue as f64).to_radians().sin_cos();
            let lab = [lightness as f64, chroma as f64 * cos, chroma as f64 * sin];
            let lms = matrix(OKLAB_TO_LMS, lab).map(|v| v.powi(3));
            return matrix(XYZ_TO_SRGB, matrix(LMS_TO_XYZ, lms));
        }
        let mut rgb = [
            self.channels[0] as f64,
            self.channels[1] as f64,
            self.channels[2] as f64,
        ];
        if matches!(self.space, ColorSpace::Srgb | ColorSpace::DisplayP3) {
            rgb = rgb.map(decode_transfer);
        }
        if matches!(
            self.space,
            ColorSpace::DisplayP3 | ColorSpace::LinearDisplayP3
        ) {
            rgb = matrix(XYZ_TO_SRGB, matrix(P3_TO_XYZ, rgb));
        }
        rgb
    }
    pub(crate) fn premultiplied(self) -> [f32; 4] {
        let mut v = self.to_linear_srgb();
        for channel in &mut v[..3] {
            *channel *= self.alpha();
        }
        v
    }
}
/// Opaque perceptual authoring color. For transparency use `Color::oklch`.
pub fn oklch(lightness: f32, chroma: f32, hue: f32) -> Result<Color, Error> {
    Color::oklch(lightness, chroma, hue, 1.0)
}
pub const fn rgb(hex: u32) -> Color {
    Color::rgb((hex >> 16) as u8, (hex >> 8) as u8, hex as u8)
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum OutputProfile {
    #[default]
    Srgb,
    DisplayP3,
}
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum PixelFormat {
    #[default]
    Rgba8Premultiplied,
    /// Eight bytes/pixel: R,G,B,A little-endian IEEE binary16, premultiplied
    /// linear light in `OutputProfile` primaries. Final numeric overflow uses
    /// `FloatRangePolicy::FiniteSaturate`; no SDR transfer or tone map applies.
    Rgba16Float,
}
/// Mapping happens once, on final straight output-profile linear RGB.
#[derive(Clone, Copy, Debug, Default, PartialEq)]
pub enum SdrMapping {
    /// Explicit hard clipping. This is not a perceptual CSS gamut mapper.
    #[default]
    Clip,
    /// Scene-relative per-channel Reinhard: max(0, exposure*x)/(1+max(0,exposure*x)).
    /// Deliberately named per-channel because it need not preserve hue.
    ReinhardPerChannel { exposure: f32 },
}
/// Conversion at the finite binary16 storage boundary, distinct from a display
/// gamut mapper or tone mapper. Extended negative and >1 channels are preserved.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum FloatRangePolicy {
    /// Round to nearest, ties to even; saturate magnitudes >65504 to signed
    /// 65504. No infinities/NaNs are emitted. Input NaN is an internal invariant
    /// violation (validated author colors and bounded composition cannot yield it).
    FiniteSaturate,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum OutputTransfer {
    Srgb,
    Linear,
}
/// Required interpretation of the byte buffer; this does not negotiate a host
/// display mode. A consumer must honor primaries, transfer and reference white.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct OutputMetadata {
    pub profile: OutputProfile,
    pub format: PixelFormat,
    pub primaries_xy: [[f32; 2]; 3],
    pub white_point_xy: [f32; 2],
    pub transfer: OutputTransfer,
    /// Luminance represented by scene-relative neutral linear 1, in cd/m².
    pub reference_white_nits: f32,
    pub premultiplied_alpha: bool,
    pub float_range: Option<FloatRangePolicy>,
    pub sdr_mapping: Option<SdrMapping>,
}
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct ColorConfig {
    pub profile: OutputProfile,
    pub format: PixelFormat,
    /// Used only by RGBA8. RGBA16Float requires `Clip`, which selects no SDR
    /// mapper there; an explicitly requested Reinhard mapper is rejected.
    pub mapping: SdrMapping,
    /// Scene-relative neutral linear 1's luminance; default 203 cd/m², following
    /// the HDR diffuse-white convention. Metadata only: never rescales samples.
    pub reference_white_nits: f32,
}
impl Default for ColorConfig {
    fn default() -> Self {
        Self {
            profile: OutputProfile::Srgb,
            format: PixelFormat::Rgba8Premultiplied,
            mapping: SdrMapping::Clip,
            reference_white_nits: 203.0,
        }
    }
}
impl ColorConfig {
    /// Linear HDR interchange buffer. Neutral linear 1 represents the supplied
    /// reference-white luminance; this scale is metadata, not a sample multiplier.
    pub fn linear_hdr(profile: OutputProfile, reference_white_nits: f32) -> Result<Self, Error> {
        let config = Self {
            profile,
            format: PixelFormat::Rgba16Float,
            reference_white_nits,
            ..Self::default()
        };
        config.validate()?;
        Ok(config)
    }
    pub fn validate(self) -> Result<(), Error> {
        if !self.reference_white_nits.is_finite() || self.reference_white_nits <= 0.0 {
            return Err(Error::InvalidColor);
        }
        if self.format == PixelFormat::Rgba16Float && self.mapping != SdrMapping::Clip {
            return Err(Error::InvalidColor);
        }
        if let SdrMapping::ReinhardPerChannel { exposure } = self.mapping
            && (!exposure.is_finite() || exposure <= 0.0 || exposure > 1e10)
        {
            return Err(Error::InvalidColor);
        }
        Ok(())
    }
    pub const fn bytes_per_pixel(self) -> usize {
        match self.format {
            PixelFormat::Rgba8Premultiplied => 4,
            PixelFormat::Rgba16Float => 8,
        }
    }
    pub fn metadata(self) -> OutputMetadata {
        let half = self.format == PixelFormat::Rgba16Float;
        OutputMetadata {
            profile: self.profile,
            format: self.format,
            primaries_xy: match self.profile {
                OutputProfile::Srgb => [[0.64, 0.33], [0.30, 0.60], [0.15, 0.06]],
                OutputProfile::DisplayP3 => [[0.68, 0.32], [0.265, 0.69], [0.15, 0.06]],
            },
            white_point_xy: [0.3127, 0.3290],
            transfer: if half {
                OutputTransfer::Linear
            } else {
                OutputTransfer::Srgb
            },
            reference_white_nits: self.reference_white_nits,
            premultiplied_alpha: true,
            float_range: half.then_some(FloatRangePolicy::FiniteSaturate),
            sdr_mapping: (!half).then_some(self.mapping),
        }
    }
    pub(crate) fn half_encoder(self) -> HalfFloatEncoder {
        HalfFloatEncoder {
            profile: self.profile,
        }
    }
    pub(crate) fn encoder(self) -> OutputEncoder {
        OutputEncoder {
            config: self,
            opaque: (self.profile == OutputProfile::Srgb && self.mapping == SdrMapping::Clip)
                .then(|| &*OPAQUE_SRGB),
        }
    }
    #[inline(never)]
    fn encode_general(self, color: [f32; 4]) -> [u8; 4] {
        let alpha = color[3].clamp(0.0, 1.0);
        if alpha == 0.0 {
            return [0; 4];
        }
        let mut rgb = [
            color[0] as f64 / alpha as f64,
            color[1] as f64 / alpha as f64,
            color[2] as f64 / alpha as f64,
        ];
        if self.profile == OutputProfile::DisplayP3 {
            rgb = matrix(XYZ_TO_P3, matrix(SRGB_TO_XYZ, rgb));
        }
        let mut output = [0; 4];
        for i in 0..3 {
            let value = match self.mapping {
                SdrMapping::Clip => rgb[i].clamp(0.0, 1.0),
                SdrMapping::ReinhardPerChannel { exposure } => {
                    let value = (rgb[i] * exposure as f64).max(0.0);
                    value / (1.0 + value)
                }
            };
            output[i] = (encode_transfer(value) * alpha as f64 * 255.0).round() as u8;
        }
        output[3] = (alpha * 255.0).round() as u8;
        output
    }
}

/// Select profile handling and initialize the exact table once per raster pass,
/// keeping the LazyLock check and the general converter's stack out of pixels.
#[derive(Clone, Copy)]
pub(crate) struct OutputEncoder {
    config: ColorConfig,
    opaque: Option<&'static OpaqueSrgb>,
}
impl OutputEncoder {
    #[inline]
    pub(crate) fn encode(self, color: [f32; 4]) -> [u8; 4] {
        if color[3] == 1.0
            && let Some(quantizer) = self.opaque
        {
            [
                quantizer.encode(color[0]),
                quantizer.encode(color[1]),
                quantizer.encode(color[2]),
                255,
            ]
        } else {
            self.config.encode_general(color)
        }
    }
}

/// IEEE binary16 output, without a nonlinear transfer or display gamut mapping.
#[derive(Clone, Copy)]
pub(crate) struct HalfFloatEncoder {
    profile: OutputProfile,
}
impl HalfFloatEncoder {
    #[inline]
    pub(crate) fn encode(self, color: [f32; 4]) -> [u8; 8] {
        let mut rgb = [color[0] as f64, color[1] as f64, color[2] as f64];
        if self.profile == OutputProfile::DisplayP3 {
            rgb = matrix(XYZ_TO_P3, matrix(SRGB_TO_XYZ, rgb));
        }
        let mut bytes = [0; 8];
        for (index, value) in rgb.into_iter().chain([color[3] as f64]).enumerate() {
            let half = finite_binary16(value);
            bytes[index * 2..index * 2 + 2].copy_from_slice(&half.to_le_bytes());
        }
        bytes
    }
}
impl crate::canvas::PixelWriter for HalfFloatEncoder {
    type Element = u8;
    const ELEMENTS: usize = 8;
    #[inline]
    fn write(self, color: [f32; 4], destination: &mut [u8]) {
        destination.copy_from_slice(&self.encode(color));
    }
}

// Direct f64 -> binary16 avoids double rounding after the output-profile matrix.
// All finite half values are integer multiples of 2^-24 below the normal range;
// normal values have an implicit leading bit and ten explicit fraction bits.
// Round the integer significand with a guard/remainder and ties-to-even. The
// saturation check removes overflow before rounding; all other casts are exact.
fn finite_binary16(value: f64) -> u16 {
    assert!(!value.is_nan(), "non-finite compositor invariant");
    let sign = ((value.to_bits() >> 48) as u16) & 0x8000;
    let value = value.abs().min(65504.0);
    let bits = value.to_bits();
    let exponent = ((bits >> 52) & 0x7ff) as i32 - 1023;
    if exponent < -25 {
        return sign;
    }
    let significand = (bits & ((1_u64 << 52) - 1)) | (1_u64 << 52);
    let shift = if exponent < -14 {
        (28 - exponent) as u32
    } else {
        42
    };
    let integer = significand >> shift;
    let remainder = significand & ((1_u64 << shift) - 1);
    let halfway = 1_u64 << (shift - 1);
    let rounded =
        integer + u64::from(remainder > halfway || (remainder == halfway && integer & 1 != 0));
    let magnitude = if exponent < -14 {
        rounded as u16
    } else {
        (((exponent + 14) as u16) << 10) + rounded as u16
    };
    sign | magnitude
}

fn wrap_hue(hue: f64) -> f32 {
    let wrapped = hue.rem_euclid(360.0) as f32;
    // Narrowing an angle just below 360 can round to 360.
    if wrapped >= 360.0 || wrapped == 0.0 {
        0.0
    } else {
        wrapped
    }
}
// CSS Color 4, 9 October 2026, sample conversion matrices (§18).
const OKLAB_TO_LMS: [[f64; 3]; 3] = [
    [1.0, 0.3963377773761749, 0.2158037573099136],
    [1.0, -0.1055613458156586, -0.0638541728258133],
    [1.0, -0.0894841775298119, -1.2914855480194092],
];
const LMS_TO_XYZ: [[f64; 3]; 3] = [
    [1.2268798758459243, -0.5578149944602171, 0.2813910456659647],
    [
        -0.0405757452148008,
        1.112_286_803_280_317,
        -0.0717110580655164,
    ],
    [-0.0763729366746601, -0.4214933324022432, 1.5869240198367816],
];
const XYZ_TO_LMS: [[f64; 3]; 3] = [
    [
        0.819_022_437_996_703,
        0.3619062600528904,
        -0.1288737815209879,
    ],
    [0.0329836539323885, 0.9292868615863434, 0.0361446663506424],
    [0.0481771893596242, 0.2642395317527308, 0.6335478284694309],
];
const LMS_TO_OKLAB: [[f64; 3]; 3] = [
    [
        0.210_454_268_309_314,
        0.7936177747023054,
        -0.0040720430116193,
    ],
    [
        1.9779985324311684,
        -2.428_592_242_048_58,
        0.450_593_709_617_411,
    ],
    [0.0259040424655478, 0.7827717124575296, -0.8086757549230774],
];
fn linear_to_oklab(rgb: [f64; 3]) -> [f64; 3] {
    if rgb[0] == rgb[1] && rgb[1] == rgb[2] {
        return [rgb[0].cbrt(), 0.0, 0.0];
    }
    matrix(
        LMS_TO_OKLAB,
        matrix(XYZ_TO_LMS, matrix(SRGB_TO_XYZ, rgb)).map(f64::cbrt),
    )
}

// D65 matrices and sign-preserving extended sRGB transfer, CSS Color 4 §18.
// Display P3 shares the sRGB transfer function. Rational entries avoid truncating
// the published primary/white-point-derived constants to coarse decimal values.
const SRGB_TO_XYZ: [[f64; 3]; 3] = [
    [506752.0 / 1228815.0, 87881.0 / 245763.0, 12673.0 / 70218.0],
    [87098.0 / 409605.0, 175762.0 / 245763.0, 12673.0 / 175545.0],
    [7918.0 / 409605.0, 87881.0 / 737289.0, 1001167.0 / 1053270.0],
];
const XYZ_TO_SRGB: [[f64; 3]; 3] = [
    [12831.0 / 3959.0, -329.0 / 214.0, -1974.0 / 3959.0],
    [
        -851781.0 / 878810.0,
        1648619.0 / 878810.0,
        36519.0 / 878810.0,
    ],
    [705.0 / 12673.0, -2585.0 / 12673.0, 705.0 / 667.0],
];
const P3_TO_XYZ: [[f64; 3]; 3] = [
    [
        608311.0 / 1250200.0,
        189793.0 / 714400.0,
        198249.0 / 1000160.0,
    ],
    [
        35783.0 / 156275.0,
        247089.0 / 357200.0,
        198249.0 / 2500400.0,
    ],
    [0.0, 32229.0 / 714400.0, 5220557.0 / 5000800.0],
];
const XYZ_TO_P3: [[f64; 3]; 3] = [
    [
        446124.0 / 178915.0,
        -333277.0 / 357830.0,
        -72051.0 / 178915.0,
    ],
    [-14852.0 / 17905.0, 63121.0 / 35810.0, 423.0 / 17905.0],
    [11844.0 / 330415.0, -50337.0 / 660830.0, 316169.0 / 330415.0],
];
fn matrix(m: [[f64; 3]; 3], v: [f64; 3]) -> [f64; 3] {
    m.map(|row| row[0] * v[0] + row[1] * v[1] + row[2] * v[2])
}
fn decode_transfer(v: f64) -> f64 {
    let a = v.abs();
    if a <= 0.04045 {
        v / 12.92
    } else {
        v.signum() * ((a + 0.055) / 1.055).powf(2.4)
    }
}
fn encode_transfer(v: f64) -> f64 {
    let a = v.abs();
    if a == 1.0 {
        v
    } else if a <= 0.0031308 {
        12.92 * v
    } else {
        v.signum() * (1.055 * a.powf(1.0 / 2.4) - 0.055)
    }
}

/// Exact final-byte quantization for opaque, clipped sRGB output. Positive IEEE
/// f32 bit patterns have numeric order. A seven-mantissa-bit bucket crosses at
/// most one byte threshold, so lookup + one comparison replaces a power call.
///
/// Thresholds are found against this build's reference transfer function, not an
/// approximate gamma fit. Initializing all 3 KiB requires no heap allocation.
struct OpaqueSrgb {
    thresholds: [u32; 256],
    buckets: [u8; 2048],
}
static OPAQUE_SRGB: std::sync::LazyLock<OpaqueSrgb> = std::sync::LazyLock::new(|| {
    let thresholds = std::array::from_fn(|index| {
        if index == 255 {
            // A sentinel makes all u8 bucket values valid threshold indices.
            return u32::MAX;
        }
        let mut low = 0;
        let mut high = 1.0f32.to_bits();
        while low < high {
            let middle = low + (high - low) / 2;
            if opaque_reference(f32::from_bits(middle)) > index as u8 {
                high = middle;
            } else {
                low = middle + 1;
            }
        }
        low
    });
    // Buckets cover [2^-15, 2), and the admitted lookup domain ends at one.
    // Masking the index proves the array bound without an unsafe load.
    assert!(thresholds[0] >= 0x3800_0000);
    let buckets = std::array::from_fn(|index| {
        let low = ((0x3800 + index as u32) << 16).min(1.0f32.to_bits());
        let high = (low + 0xffff).min(1.0f32.to_bits());
        let first = thresholds.partition_point(|&threshold| threshold <= low);
        let last = thresholds.partition_point(|&threshold| threshold <= high);
        assert!(
            last - first <= 1,
            "sRGB quantizer bucket crosses two thresholds"
        );
        first as u8
    });
    OpaqueSrgb {
        thresholds,
        buckets,
    }
});
fn opaque_reference(value: f32) -> u8 {
    (encode_transfer(f64::from(value).clamp(0.0, 1.0)) * 255.0).round() as u8
}
impl OpaqueSrgb {
    #[inline]
    fn encode(&self, value: f32) -> u8 {
        if value <= 0.0 {
            return 0;
        }
        if value >= 1.0 {
            return 255;
        }
        let bits = value.to_bits();
        if bits < self.thresholds[0] {
            return 0;
        }
        let base = self.buckets[((bits >> 16) as usize) & 2047];
        base + u8::from(bits >= self.thresholds[usize::from(base)])
    }
}

#[cfg(test)]
mod quantizer_tests {
    use super::*;

    #[test]
    fn quantizer_matches_reference_at_all_thresholds_and_bucket_edges() {
        let quantizer = &*OPAQUE_SRGB;
        for &boundary in &quantizer.thresholds[..255] {
            for bits in boundary - 1..=boundary + 1 {
                let value = f32::from_bits(bits);
                assert_eq!(quantizer.encode(value), opaque_reference(value));
            }
        }
        for bucket in 0x3800..=0x3f80 {
            for bits in [(bucket << 16) - 1, bucket << 16, (bucket << 16) + 1] {
                let value = f32::from_bits(bits);
                assert_eq!(quantizer.encode(value), opaque_reference(value));
            }
        }
        for value in [-f32::MAX, -0.0, 0.0, f32::from_bits(1), f32::MAX] {
            assert_eq!(quantizer.encode(value), opaque_reference(value));
        }
        assert_eq!(std::mem::size_of::<OpaqueSrgb>(), 3072);
    }

    #[test]
    #[ignore = "107 million inputs; run explicitly with --release"]
    fn every_in_range_float_matches_the_reference_quantizer() {
        let quantizer = &*OPAQUE_SRGB;
        // Below the first threshold the result is identically zero; outside
        // [0,1] clipping is exact. Cover every float in the remaining domain.
        for bits in quantizer.thresholds[0] - 1..=1.0f32.to_bits() {
            let value = f32::from_bits(bits);
            assert_eq!(quantizer.encode(value), opaque_reference(value), "{bits:x}");
        }
    }

    #[test]
    #[ignore = "timing experiment; run explicitly with --release --nocapture"]
    fn opaque_quantizer_microbenchmark() {
        use std::{
            hint::black_box,
            time::{Duration, Instant},
        };
        fn measure(values: &[f32], encode: impl Fn(f32) -> u8) -> (Duration, u64) {
            let start = Instant::now();
            let mut checksum = 0;
            for _ in 0..50 {
                for &value in values {
                    checksum += u64::from(encode(black_box(value)));
                }
            }
            (start.elapsed() / 50, checksum)
        }
        let mut state = 0x1234_5678u32;
        let values: Vec<_> = (0..640 * 480 * 3)
            .map(|_| {
                state ^= state << 13;
                state ^= state >> 17;
                state ^= state << 5;
                (state >> 8) as f32 / 16_777_215.0
            })
            .collect();
        let start = Instant::now();
        let quantizer = &*OPAQUE_SRGB;
        let init = start.elapsed();
        let reference = measure(&values, opaque_reference);
        let exact = measure(&values, |value| quantizer.encode(value));
        assert_eq!(reference.1, exact.1);
        eprintln!(
            "init={init:?}; 640x480 RGB reference={:?}, exact={:?}; bytes={}",
            reference.0,
            exact.0,
            std::mem::size_of::<OpaqueSrgb>()
        );
    }
}

#[cfg(test)]
mod half_tests {
    use super::*;
    // Independent mathematical decoder: not the encoder's bit-shift algorithm.
    fn decode(bits: u16) -> f64 {
        let exponent = ((bits >> 10) & 31) as i32;
        let fraction = (bits & 1023) as f64;
        let magnitude = if exponent == 0 {
            fraction * 2_f64.powi(-24)
        } else {
            (1.0 + fraction / 1024.0) * 2_f64.powi(exponent - 15)
        };
        if bits & 0x8000 != 0 {
            -magnitude
        } else {
            magnitude
        }
    }
    #[test]
    fn every_finite_half_roundtrips_including_signed_zero() {
        for bits in 0..=u16::MAX {
            if bits & 0x7c00 != 0x7c00 {
                assert_eq!(finite_binary16(decode(bits)), bits, "{bits:04x}");
            }
        }
    }
    #[test]
    fn every_adjacent_half_midpoint_rounds_ties_even_on_both_sides() {
        for lower in 0..0x7bff_u16 {
            let upper = lower + 1;
            let midpoint = (decode(lower) + decode(upper)) / 2.0;
            let below = f64::from_bits(midpoint.to_bits() - 1);
            let above = f64::from_bits(midpoint.to_bits() + 1);
            let tie = if lower & 1 == 0 { lower } else { upper };
            for (input, expected) in [(below, lower), (midpoint, tie), (above, upper)] {
                assert_eq!(finite_binary16(input), expected, "{lower:04x}: {input}");
                assert_eq!(finite_binary16(-input), expected | 0x8000);
            }
        }
    }
    #[test]
    fn known_values_finite_saturation_and_little_endian_channels() {
        for (value, bits) in [
            (1.0, 0x3c00),
            (0.5, 0x3800),
            (-2.0, 0xc000),
            (65504.0, 0x7bff),
            (2_f64.powi(-14), 0x0400),
            (2_f64.powi(-24), 1),
            (2_f64.powi(-25), 0),
            (1e20, 0x7bff),
            (-1e20, 0xfbff),
            (f64::INFINITY, 0x7bff),
            (f64::NEG_INFINITY, 0xfbff),
        ] {
            assert_eq!(finite_binary16(value), bits);
        }
        let config = ColorConfig {
            format: PixelFormat::Rgba16Float,
            ..ColorConfig::default()
        };
        assert_eq!(
            config
                .half_encoder()
                .encode([-1e20, 1e20, 2_f32.powi(-24), 0.5]),
            [0xff, 0xfb, 0xff, 0x7b, 1, 0, 0, 0x38]
        );
        assert_eq!(
            config.half_encoder().encode([-0.0, 0.0, 4.0, 1.0]),
            [0, 0x80, 0, 0, 0, 0x44, 0, 0x3c]
        );
    }
    #[test]
    fn p3_matrix_applies_to_premultiplied_linear_channels() {
        let config = ColorConfig {
            profile: OutputProfile::DisplayP3,
            format: PixelFormat::Rgba16Float,
            ..ColorConfig::default()
        };
        let input = Color::linear_display_p3(4.0, -0.5, 2.0, 0.25)
            .unwrap()
            .premultiplied();
        let bytes = config.half_encoder().encode(input);
        for (i, expected) in [1.0, -0.125, 0.5, 0.25].into_iter().enumerate() {
            assert_eq!(
                decode(u16::from_le_bytes([bytes[i * 2], bytes[i * 2 + 1]])),
                expected
            );
        }
    }
    #[test]
    fn authored_color_keeps_twenty_byte_provenance_header() {
        assert_eq!(std::mem::size_of::<Color>(), 20);
    }
}
