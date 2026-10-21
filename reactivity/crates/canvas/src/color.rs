use crate::Error;

/// Author color encoding. RGB can be negative or exceed one; alpha cannot.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ColorSpace {
    Srgb,
    LinearSrgb,
    DisplayP3,
    LinearDisplayP3,
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
    pub const BLACK: Self = Self::rgb(0, 0, 0);
    pub const WHITE: Self = Self::rgb(255, 255, 255);
    pub const TRANSPARENT: Self = Self::rgba(0, 0, 0, 0);
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
    fn new(channels: [f32; 4], space: ColorSpace) -> Result<Self, Error> {
        if !channels.iter().all(|v| v.is_finite()) || !(0.0..=1.0).contains(&channels[3]) {
            return Err(Error::InvalidColor);
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
#[derive(Clone, Copy, Debug, Default, PartialEq)]
pub struct ColorConfig {
    pub profile: OutputProfile,
    pub format: PixelFormat,
    pub mapping: SdrMapping,
}
impl ColorConfig {
    pub fn validate(self) -> Result<(), Error> {
        if self.format != PixelFormat::Rgba8Premultiplied {
            return Err(Error::UnsupportedPixelFormat);
        }
        if let SdrMapping::ReinhardPerChannel { exposure } = self.mapping
            && (!exposure.is_finite() || exposure <= 0.0 || exposure > 1e10)
        {
            return Err(Error::InvalidColor);
        }
        Ok(())
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
