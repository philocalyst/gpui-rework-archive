// Frozen uncompressed Color oracle from a847d85f45. Keep independent of production helpers.
#![allow(dead_code)]
use gpui_canvas::{ColorSpace, Error};
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
