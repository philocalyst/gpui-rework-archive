//! Immutable analytic paint. Author stops and compiled intervals share one lease.
use super::{Color, ColorSpace};
use crate::{Error, Point};
use fearless_simd::{Simd, f32x4, prelude::*};
use fearless_simd_macros::simd;
use std::sync::atomic::{AtomicU64, Ordering};
use triomphe::ThinArc;

pub const MAX_GRADIENT_STOPS: usize = 4096;
const HEADER_WORDS: usize = 3;
const STOP_WORDS: usize = 4;
type Word = [u32; 4];
mod precision;
mod trig;

/// Exact resource identity, not a content hash or an owner capability. Its two
/// lanes keep cold reflected values four-aligned without encoding a pointer.
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct GradientKey([u32; 2]);
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
#[repr(u32)]
pub enum Extend {
    #[default]
    Pad,
    Repeat,
    Reflect,
}
/// Interpolation occurs before final gamut/output conversion. Oklch is GPUI's
/// authoring default; CSS's general interpolation default is Oklab.
/// Perceptual modes reject positive subnormal stop alpha. Rendered fades may
/// underflow; WGSL permits flushing subnormal arithmetic. Interior results use
/// f32 arithmetic and are not promised bit-identical across backends. Exact stop
/// and padded endpoint samples use stored premultiplied RGB. No gamut clipping
/// or missing-component syntax is applied here.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Interpolation {
    LinearSrgb,
    Oklab,
    Oklch { hue: HueInterpolation },
}
impl Default for Interpolation {
    fn default() -> Self {
        Self::Oklch {
            hue: HueInterpolation::Shorter,
        }
    }
}
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
#[repr(u32)]
pub enum HueInterpolation {
    #[default]
    Shorter,
    Longer,
    Increasing,
    Decreasing,
}
impl Interpolation {
    /// Per-channel absolute conversion budget in premultiplied linear sRGB,
    /// before coverage, compositing and output encoding. Exact endpoint/fixed
    /// paths retain ordinary per-channel f32 rounding. Geometry has its own
    /// admitted sampling domain; this is not a whole-frame error budget.
    pub const MAX_CONVERSION_ERROR: f64 = 1.0 / 16384.0;
    fn tag(self) -> u32 {
        match self {
            Self::LinearSrgb => 0,
            Self::Oklab => 1,
            Self::Oklch { hue } => 2 + hue as u32,
        }
    }
}
/// Coordinates are relative to the painted rectangle; element transforms apply
/// equally to coverage and this coordinate system. Conic zero points upward,
/// with positive turns clockwise. Degenerate geometry is explicitly rejected.
#[derive(Clone, Copy, Debug, PartialEq)]
pub enum GradientGeometry {
    Linear { start: Point, end: Point },
    Radial { center: Point, radii: [f32; 2] },
    Conic { center: Point, start_turn: f32 },
}
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct GradientStop {
    pub offset: f32,
    pub color: Color,
}
impl GradientStop {
    pub const fn new(offset: f32, color: Color) -> Self {
        Self { offset, color }
    }
}
/// One thin, immutable allocation containing author bits and compiled interval
/// coefficients. Canonical scenes lease this once per distinct resource; draw
/// iteration and raster sampling borrow it without refcount operations.
#[derive(Clone)]
pub struct Gradient(ThinArc<GradientKey, Word>);
impl std::fmt::Debug for Gradient {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Gradient")
            .field("key", &self.key())
            .field("geometry", &self.view().geometry())
            .field("stops", &self.view().stop_count())
            .finish()
    }
}
impl PartialEq for Gradient {
    fn eq(&self, other: &Self) -> bool {
        self.key() == other.key()
    }
}
impl Eq for Gradient {}
#[derive(Clone, Copy, Debug)]
pub struct GradientView<'a> {
    key: GradientKey,
    words: &'a [Word],
}
impl Gradient {
    /// Compile explicit ordered stops. Perceptual intervals which cannot meet
    /// the numeric profile return `Error::GradientPrecision`; author Color's
    /// full extended range does not imply every interval is admitted.
    pub fn new(
        geometry: GradientGeometry,
        stops: &[GradientStop],
        extend: Extend,
        interpolation: Interpolation,
    ) -> Result<Self, Error> {
        // Perceptual gradients require normal positive author alpha. Color's
        // lossless storage and explicit LinearSrgb interpolation remain broader.
        // WGSL may flush subnormal arithmetic; fading output may still underflow.
        if interpolation != Interpolation::LinearSrgb
            && stops
                .iter()
                .any(|s| s.color.alpha() > 0.0 && s.color.alpha() < f32::MIN_POSITIVE)
        {
            return Err(Error::InvalidGradient);
        }
        let stride = if interpolation == Interpolation::LinearSrgb {
            STOP_WORDS
        } else {
            5
        };
        if !(2..=MAX_GRADIENT_STOPS).contains(&stops.len()) {
            return Err(Error::InvalidGradient);
        }
        for (index, stop) in stops.iter().enumerate() {
            if !stop.offset.is_finite() || stop.offset.abs() > 1e6 {
                return Err(Error::InvalidGradient);
            }
            if index != 0 {
                let span = stop.offset - stops[index - 1].offset;
                // Duplicate stops are real hard edges. Positive subnormal spans
                // cannot promise the same division on WGSL implementations.
                if span < 0.0
                    || (span != 0.0 && (span < f32::MIN_POSITIVE || !(1.0 / span).is_finite()))
                {
                    return Err(Error::InvalidGradient);
                }
            }
        }
        if extend != Extend::Pad && stops.last().unwrap().offset == stops[0].offset {
            return Err(Error::InvalidGradient);
        }
        let (kind, author, prepared) = prepare_geometry(geometry)?;
        if extend != Extend::Pad {
            let span = f64::from(stops.last().unwrap().offset) - f64::from(stops[0].offset);
            let bound = match kind {
                0 => {
                    (1.0 + f64::from(prepared[0]).abs()) * f64::from(prepared[2]).abs()
                        + (1.0 + f64::from(prepared[1]).abs()) * f64::from(prepared[3]).abs()
                }
                1 => ((1.0 + f64::from(prepared[0]).abs()) * f64::from(prepared[2]).abs())
                    .hypot((1.0 + f64::from(prepared[1]).abs()) * f64::from(prepared[3]).abs()),
                _ => 1.0,
            };
            if (bound + f64::from(stops[0].offset).abs()) / span > 1_048_576.0 {
                return Err(Error::InvalidGradient);
            }
        }
        let header = [
            [
                kind,
                extend as u32,
                stops.len() as u32,
                u32::from(stops.iter().any(|stop| stop.color.alpha() > 0.0))
                    | interpolation.tag() << 1,
            ],
            author.map(f32::to_bits),
            prepared.map(f32::to_bits),
        ];
        static NEXT: AtomicU64 = AtomicU64::new(1);
        let id = NEXT
            .try_update(Ordering::Relaxed, Ordering::Relaxed, |n| n.checked_add(1))
            .map_err(|_| Error::ResourceLimit)?;
        let key = GradientKey([id as u32, (id >> 32) as u32]);
        let mut cached = [[0; 4]; 5];
        let mut precision_admitted = true;
        let mut left = if interpolation == Interpolation::LinearSrgb {
            PreparedColor::default()
        } else {
            prepare_color(stops[0].color, interpolation)
        };
        let words = (0..HEADER_WORDS + stops.len() * stride).map(|word| {
            if word < HEADER_WORDS {
                return header[word];
            }
            let n = word - HEADER_WORDS;
            if n.is_multiple_of(stride) {
                let i = n / stride;
                let stop = stops[i];
                let next = stops.get(i + 1).copied().unwrap_or(stop);
                let right = if i + 1 == stops.len() || interpolation == Interpolation::LinearSrgb {
                    left
                } else {
                    prepare_color(next.color, interpolation)
                };
                let (packet, admitted) = prepare_interval(stop, next, interpolation, left, right);
                cached = packet;
                precision_admitted &= admitted;
                left = right;
            }
            cached[n % stride]
        });
        let resource =
            ThinArc::try_from_header_and_iter(key, words).map_err(|_| Error::ResourceLimit)?;
        // The one bounded allocation is dropped on a precision rejection.
        // Converted author colors stream once; no temporary stop Vec is needed.
        if !precision_admitted {
            return Err(Error::GradientPrecision);
        }
        Ok(Self(resource))
    }
    /// A padded gradient using GPUI's Oklch/shorter authoring default.
    /// Stops remain explicit, ordered positions; this does not apply CSS fixup.
    pub fn perceptual(geometry: GradientGeometry, stops: &[GradientStop]) -> Result<Self, Error> {
        Self::new(geometry, stops, Extend::Pad, Interpolation::default())
    }
    #[cfg(test)]
    pub(crate) fn lease_count(&self) -> usize {
        ThinArc::strong_count(&self.0)
    }
    pub fn key(&self) -> GradientKey {
        self.0.header.header
    }
    pub fn view(&self) -> GradientView<'_> {
        GradientView {
            key: self.key(),
            words: &self.0.slice,
        }
    }
}
// Preparation uses f64 author conversions, never the rounded public conversion.
// Color admission bounds straight linear RGB to 1e20. The composed forward LMS
// row norm is < 2, Lab row norm < 5, and inverse LMS row norm < 3.5. Even allowing
// arbitrary polar hue, |q| < 1e9, |q^3| < 1e27 and RGB row norm < 8: all interior
// intermediates remain far below f32::MAX. No RGB coefficients are expanded.
#[derive(Clone, Copy, Default)]
struct PreparedColor {
    coordinates: [f64; 3],
    endpoint: [f32; 4],
}
fn prepare_interval(
    stop: GradientStop,
    next: GradientStop,
    mode: Interpolation,
    left_color: PreparedColor,
    right_color: PreparedColor,
) -> ([Word; 5], bool) {
    let span = next.offset - stop.offset;
    let reciprocal = if span > 0.0 { 1.0 / span } else { 0.0 };
    if mode == Interpolation::LinearSrgb {
        let endpoint = stop.color.premultiplied();
        let right = next.color.premultiplied();
        return (
            [
                [stop.offset.to_bits(), reciprocal.to_bits(), 0, 0],
                endpoint.map(f32::to_bits),
                std::array::from_fn(|c| (right[c] - endpoint[c]).to_bits()),
                stop.color.words,
                [0; 4],
            ],
            true,
        );
    }
    let endpoint = left_color.endpoint;
    let a0 = stop.color.alpha();
    let a1 = next.color.alpha();
    let mut exact_rgb = true;
    let mut left = left_color.coordinates;
    let mut right = right_color.coordinates;
    let mut polar = false;
    if let Interpolation::Oklch { hue } = mode {
        if left[1] <= 0.000004 {
            left[2] = right[2];
        }
        if right[1] <= 0.000004 {
            right[2] = left[2];
        }
        let both_powerless = left[1] <= 0.000004 && right[1] <= 0.000004;
        if both_powerless {
            left[2] = 0.0;
            right[2] = 0.0;
        }
        exact_rgb = (a0 == 0.0 || left[1] == 0.0 || left[2] == left_color.coordinates[2])
            && (a1 == 0.0 || right[1] == 0.0 || right[2] == right_color.coordinates[2]);
        // Invisible L/C must not survive as a huge cancelling base/delta. Hue
        // still belongs to the authored route and always advances with t.
        if a0 == 0.0 {
            left[0] = right[0];
            left[1] = right[1];
        }
        if a1 == 0.0 {
            right[0] = left[0];
            right[1] = left[1];
        }
        let delta = right[2] - left[2];
        if !both_powerless {
            match hue {
                HueInterpolation::Shorter if delta > 180.0 => left[2] += 360.0,
                HueInterpolation::Shorter if delta < -180.0 => right[2] += 360.0,
                HueInterpolation::Longer if delta > 0.0 && delta < 180.0 => left[2] += 360.0,
                HueInterpolation::Longer if delta > -180.0 && delta <= 0.0 => right[2] += 360.0,
                HueInterpolation::Increasing if delta < 0.0 => right[2] += 360.0,
                HueInterpolation::Decreasing if delta > 0.0 => left[2] += 360.0,
                _ => {}
            }
        }
        polar = left[2] != right[2] && (left[1] != 0.0 || right[1] != 0.0);
        if polar {
            left[2] = left[2].to_radians();
            right[2] = right[2].to_radians();
        } else {
            let (sin, cos) = left[2].to_radians().sin_cos();
            left = [left[0], left[1] * cos, left[1] * sin];
            right = [right[0], right[1] * cos, right[1] * sin];
        }
    } else {
        if a0 == 0.0 {
            left = right;
        }
        if a1 == 0.0 {
            right = left;
        }
    }
    if !polar {
        left = super::matrix(super::OKLAB_TO_LMS, left);
        right = super::matrix(super::OKLAB_TO_LMS, right);
    }
    let exact_fixed = !polar && left == right && exact_rgb;
    let admitted = span <= 0.0
        || exact_fixed
        || precision::conversion_bound(left, right, a0, a1, polar)
            .iter()
            .all(|error| error.is_finite() && *error <= Interpolation::MAX_CONVERSION_ERROR);
    let scale = f64::from(a0.max(a1));
    let normalized = if scale == 0.0 {
        [0.0; 2]
    } else {
        [f64::from(a0) / scale, f64::from(a1) / scale]
    };
    (
        [
            [
                stop.offset.to_bits(),
                (if polar { reciprocal } else { -reciprocal }).to_bits(),
                (normalized[0] as f32).to_bits() | if exact_fixed { 1 << 31 } else { 0 },
                (normalized[1] as f32).to_bits(),
            ],
            [
                (left[0] as f32).to_bits(),
                (left[1] as f32).to_bits(),
                (left[2] as f32).to_bits(),
                a0.to_bits(),
            ],
            [
                ((right[0] - left[0]) as f32).to_bits(),
                ((right[1] - left[1]) as f32).to_bits(),
                ((right[2] - left[2]) as f32).to_bits(),
                a1.to_bits(),
            ],
            stop.color.words,
            endpoint.map(f32::to_bits),
        ],
        admitted,
    )
}
// Stream one converted author color across adjacent intervals: no stop Vec,
// repeated forward conversion or additional retained resource representation.
fn prepare_color(color: Color, mode: Interpolation) -> PreparedColor {
    let rgb = color.linear_rgb();
    let alpha = color.alpha();
    let endpoint = [
        (rgb[0] as f32) * alpha,
        (rgb[1] as f32) * alpha,
        (rgb[2] as f32) * alpha,
        alpha,
    ];
    let coordinates = if color.space() == ColorSpace::Oklch {
        let [l, c, h, _] = color.channels();
        if matches!(mode, Interpolation::Oklch { .. }) {
            [f64::from(l), f64::from(c), f64::from(h)]
        } else {
            let (sin, cos) = f64::from(h).to_radians().sin_cos();
            [f64::from(l), f64::from(c) * cos, f64::from(c) * sin]
        }
    } else {
        let lab = super::linear_to_oklab(rgb);
        if matches!(mode, Interpolation::Oklch { .. }) {
            [
                lab[0],
                lab[1].hypot(lab[2]),
                lab[2].atan2(lab[1]).to_degrees().rem_euclid(360.0),
            ]
        } else {
            lab
        }
    };
    PreparedColor {
        coordinates,
        endpoint,
    }
}
const LMS_TO_RGB: [[f64; 3]; 3] = [
    [4.076741636075958, -3.3077115392580616, 0.23096990318210442],
    [-1.268437973285032, 2.609757349287688, -0.34131937600265727],
    [
        -0.004196076138675566,
        -0.7034186179359363,
        1.7076146940746117,
    ],
];
fn prepare_geometry(geometry: GradientGeometry) -> Result<(u32, [f32; 4], [f32; 4]), Error> {
    let result = match geometry {
        GradientGeometry::Linear { start, end } => {
            let dx = f64::from(end.x) - f64::from(start.x);
            let dy = f64::from(end.y) - f64::from(start.y);
            let d = dx * dx + dy * dy;
            (
                0,
                [start.x, start.y, end.x, end.y],
                [start.x, start.y, (dx / d) as f32, (dy / d) as f32],
            )
        }
        GradientGeometry::Radial { center, radii } => {
            if radii.iter().any(|r| !r.is_finite() || *r <= 0.0) {
                return Err(Error::InvalidGradient);
            }
            (
                1,
                [center.x, center.y, radii[0], radii[1]],
                [center.x, center.y, 1.0 / radii[0], 1.0 / radii[1]],
            )
        }
        GradientGeometry::Conic { center, start_turn } => (
            2,
            [center.x, center.y, start_turn, 0.0],
            [center.x, center.y, start_turn.rem_euclid(1.0), 0.0],
        ),
    };
    if result.1.iter().any(|v| !v.is_finite() || v.abs() > 1e6)
        || result.2.iter().any(|v| !v.is_finite() || v.abs() > 1e12)
    {
        return Err(Error::InvalidGradient);
    }
    Ok(result)
}
impl<'a> GradientView<'a> {
    pub fn key(self) -> GradientKey {
        self.key
    }
    /// Shared CPU/GPU packet: three headers, four words per LinearSrgb stop,
    /// five per perceptual stop. Word +3 always retains exact authored Color;
    /// perceptual word +4 preserves exact premultiplied endpoint RGB. Metadata's
    /// reciprocal sign selects LMS-prime (negative) or moving LCH (positive).
    /// Metadata z's sign marks a resolved fixed-coordinate interval; its
    /// magnitude and metadata w are normalized endpoint alpha.
    pub fn words(self) -> &'a [Word] {
        self.words
    }
    pub fn has_visible_stop(self) -> bool {
        self.words[0][3] & 1 != 0
    }
    pub fn extend(self) -> Extend {
        match self.words[0][1] {
            0 => Extend::Pad,
            1 => Extend::Repeat,
            _ => Extend::Reflect,
        }
    }
    pub fn interpolation(self) -> Interpolation {
        match self.words[0][3] >> 1 {
            0 => Interpolation::LinearSrgb,
            1 => Interpolation::Oklab,
            tag => Interpolation::Oklch {
                hue: match tag {
                    2 => HueInterpolation::Shorter,
                    3 => HueInterpolation::Longer,
                    4 => HueInterpolation::Increasing,
                    _ => HueInterpolation::Decreasing,
                },
            },
        }
    }
    fn stride(self) -> usize {
        if self.words[0][3] >> 1 == 0 {
            STOP_WORDS
        } else {
            5
        }
    }
    pub fn stop_count(self) -> usize {
        self.words[0][2] as usize
    }
    pub fn byte_len(self) -> usize {
        self.words.len() * 16
    }
    pub fn geometry(self) -> GradientGeometry {
        let a = self.words[1].map(f32::from_bits);
        let p = Point { x: a[0], y: a[1] };
        match self.words[0][0] {
            0 => GradientGeometry::Linear {
                start: p,
                end: Point { x: a[2], y: a[3] },
            },
            1 => GradientGeometry::Radial {
                center: p,
                radii: [a[2], a[3]],
            },
            _ => GradientGeometry::Conic {
                center: p,
                start_turn: a[2],
            },
        }
    }
    pub fn stop(self, index: usize) -> Option<GradientStop> {
        if index >= self.stop_count() {
            return None;
        }
        let base = HEADER_WORDS + index * self.stride();
        Some(GradientStop {
            offset: f32::from_bits(self.words[base][0]),
            color: Color {
                words: self.words[base + 3],
            },
        })
    }
    /// Sample a point in the normalized painted rectangle, including its edges.
    /// Returns premultiplied extended-linear output without gamut/output encoding.
    pub fn sample(self, point: [f32; 2]) -> Result<[f32; 4], Error> {
        if point
            .iter()
            .any(|v| !v.is_finite() || !(0.0..=1.0).contains(v))
        {
            return Err(Error::InvalidGradient);
        }
        Ok(self.sample_normalized(point))
    }
    // Draw admission and coverage already certify this domain. Raster sampling
    // keeps no fallible public-input validation in its per-sample kernel.
    pub(crate) fn sample_normalized(self, point: [f32; 2]) -> [f32; 4] {
        self.sample_four(fearless_simd::Fallback::new(), [point; 4], 1)[0]
    }
    // Covered sample lanes share actual color arithmetic. Interval selection is
    // bounded binary search per lane; no all-stops scan, allocation or lease.
    #[simd]
    pub(crate) fn sample_four<S: Simd>(
        self,
        simd: S,
        points: [[f32; 2]; 4],
        mask: u8,
    ) -> [[f32; 4]; 4] {
        let p = self.words[2].map(f32::from_bits);
        let x = f32x4::from_fn(simd, |i| {
            if mask & (1 << i) != 0 {
                points[i][0] - p[0]
            } else {
                0.0
            }
        });
        let y = f32x4::from_fn(simd, |i| {
            if mask & (1 << i) != 0 {
                points[i][1] - p[1]
            } else {
                0.0
            }
        });
        let parameters = match self.words[0][0] {
            0 => x * p[2] + y * p[3],
            1 => {
                let x = x * p[2];
                let y = y * p[3];
                (x * x + y * y).sqrt()
            }
            _ => f32x4::from_fn(simd, |i| {
                if mask & (1 << i) == 0 {
                    return 0.0;
                }
                let angle = if x[i] == 0.0 && y[i] == 0.0 {
                    0.0
                } else {
                    x[i].atan2(-y[i]) / std::f32::consts::TAU
                };
                let value = angle - p[2];
                value - value.floor()
            }),
        };
        self.evaluate_four(simd, parameters.into(), mask)
    }

    /// Evaluate a finite parameter. Repeating paints admit at most 2^20 periods
    /// from the first stop, matching the renderer's phase-precision bound.
    pub fn sample_parameter(self, t: f32) -> Result<[f32; 4], Error> {
        if !t.is_finite() {
            return Err(Error::InvalidGradient);
        }
        if self.extend() != Extend::Pad {
            let first = f64::from(f32::from_bits(self.words[HEADER_WORDS][0]));
            let last = f64::from(f32::from_bits(
                self.words[HEADER_WORDS + (self.stop_count() - 1) * self.stride()][0],
            ));
            if ((f64::from(t) - first) / (last - first)).abs() > 1_048_576.0 {
                return Err(Error::InvalidGradient);
            }
        }
        Ok(self.evaluate_four(fearless_simd::Fallback::new(), [t; 4], 1)[0])
    }
    fn interval(self, mut t: f32) -> (usize, f32) {
        let stride = self.stride();
        let n = self.stop_count();
        let first = f32::from_bits(self.words[HEADER_WORDS][0]);
        let last = f32::from_bits(self.words[HEADER_WORDS + (n - 1) * stride][0]);
        let span = last - first;
        match self.words[0][1] {
            1 => {
                let x = t - first;
                t = x - (x / span).floor() * span + first;
            }
            2 => {
                let period = span * 2.0;
                let x = t - first;
                let u = x - (x / period).floor() * period;
                t = first + if u > span { period - u } else { u };
            }
            _ => {}
        }
        // upper_bound chooses the last duplicate at an exact hard edge. Do not
        // clamp t first: doing so would erase hard edges at the end stops.
        let mut low = 0;
        let mut high = n;
        while low < high {
            let mid = (low + high) / 2;
            if f32::from_bits(self.words[HEADER_WORDS + mid * stride][0]) <= t {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        let i = low.saturating_sub(1);
        let base = HEADER_WORDS + i * stride;
        let meta = self.words[base].map(f32::from_bits);
        if low == 0 || i + 1 == n {
            return (base, 0.0);
        }
        (base, ((t - meta[0]) * meta[1].abs()).clamp(0.0, 1.0))
    }
    #[inline(always)]
    fn evaluate_four<S: Simd>(self, simd: S, parameters: [f32; 4], mask: u8) -> [[f32; 4]; 4] {
        let intervals = std::array::from_fn::<_, 4, _>(|i| {
            if mask & (1 << i) != 0 {
                self.interval(parameters[i])
            } else {
                (HEADER_WORDS, 0.0)
            }
        });
        let load = |word: usize, channel: usize| {
            f32x4::from_fn(simd, |i| {
                f32::from_bits(self.words[intervals[i].0 + word][channel])
            })
        };
        let t = f32x4::from_fn(simd, |i| intervals[i].1);
        let mut c = [load(1, 0), load(1, 1), load(1, 2)];
        let d = [load(2, 0), load(2, 1), load(2, 2)];
        let alpha;
        if self.interpolation() == Interpolation::LinearSrgb {
            for j in 0..3 {
                c[j] += t * d[j];
            }
            alpha = load(1, 3) + t * load(2, 3);
        } else {
            let a0 = load(0, 2).abs();
            let a1 = load(0, 3);
            let mut v = t;
            if a0.simd_eq(a1).to_bitmask() != 15 {
                let denominator = (1.0 - t) * a0 + t * a1;
                let ratio = t * a1 / denominator.max(f32::MIN_POSITIVE);
                v = a0
                    .simd_eq(0.0)
                    .select(
                        f32x4::splat(simd, 1.0),
                        a1.simd_eq(0.0).select(f32x4::splat(simd, 0.0), ratio),
                    )
                    .max(0.0)
                    .min(1.0);
            }
            // Hue is never premultiplied: it advances with t, L and C with v.
            let h = c[2] + t * d[2];
            for j in 0..3 {
                c[j] += v * d[j];
            }
            let polar = std::array::from_fn::<_, 4, _>(|i| {
                mask & (1 << i) != 0 && self.words[intervals[i].0][1] >> 31 == 0
            });
            if polar.iter().any(|p| *p) {
                let tau = std::f32::consts::TAU;
                let angle = h - ((h + tau * 0.5) / tau).floor() * tau;
                let [sin, cos] = trig::sin_cos(angle);
                let a = c[1] * cos;
                let b = c[1] * sin;
                let q = super::OKLAB_TO_LMS.map(|row| c[0] + a * row[1] as f32 + b * row[2] as f32);
                for j in 0..3 {
                    let original: [f32; 4] = c[j].into();
                    let converted: [f32; 4] = q[j].into();
                    c[j] =
                        f32x4::from_fn(simd, |i| if polar[i] { converted[i] } else { original[i] });
                }
            }
            for q in &mut c {
                *q = *q * *q * *q;
            }
            let q = c;
            for (j, row) in LMS_TO_RGB.iter().enumerate() {
                c[j] = q[0] * row[0] as f32 + q[1] * row[1] as f32 + q[2] * row[2] as f32;
            }
            let left_alpha = load(1, 3);
            let right_alpha = load(2, 3);
            alpha = left_alpha
                .simd_eq(right_alpha)
                .select(left_alpha, (1.0 - t) * left_alpha + t * right_alpha);
            for value in &mut c {
                *value *= alpha;
            }
        }
        let channels: [[f32; 4]; 4] = [c[0].into(), c[1].into(), c[2].into(), alpha.into()];
        std::array::from_fn(|i| {
            if mask & (1 << i) == 0 {
                return [0.0; 4];
            }
            if intervals[i].1 == 0.0 {
                return self.words[intervals[i].0 + if self.stride() == 4 { 1 } else { 4 }]
                    .map(f32::from_bits);
            }
            if self.stride() == 5 && intervals[i].1 == 1.0 {
                return self.words[intervals[i].0 + self.stride() + 4].map(f32::from_bits);
            }
            if self.stride() == 5 && self.words[intervals[i].0][2] >> 31 != 0 {
                let left = self.words[intervals[i].0 + 4].map(f32::from_bits);
                let right = self.words[intervals[i].0 + self.stride() + 4].map(f32::from_bits);
                return std::array::from_fn(|j| {
                    (1.0 - intervals[i].1) * left[j] + intervals[i].1 * right[j]
                });
            }
            std::array::from_fn(|j| channels[j][i])
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn line() -> GradientGeometry {
        GradientGeometry::Linear {
            start: Point { x: 0.0, y: 0.0 },
            end: Point { x: 1.0, y: 0.0 },
        }
    }
    fn gradient(stops: &[GradientStop], extend: Extend) -> Gradient {
        Gradient::new(line(), stops, extend, Interpolation::LinearSrgb).unwrap()
    }
    #[test]
    fn perceptual_allocation_and_all_available_simd_backends_share_the_kernel() {
        let stops = [
            GradientStop::new(0.0, Color::oklch(0.6, 0.2, 350., 0.1).unwrap()),
            GradientStop::new(0.3, Color::linear_display_p3(2., -0.1, 0.5, 0.9).unwrap()),
            GradientStop::new(0.3, Color::oklch(0.3, 0.1, 170., 0.5).unwrap()),
            GradientStop::new(1.0, Color::linear_srgb(0.2, 0.2, 0.2, 1.).unwrap()),
        ];
        for mode in [
            Interpolation::Oklab,
            Interpolation::default(),
            Interpolation::Oklch {
                hue: HueInterpolation::Longer,
            },
        ] {
            let mut gradient = None;
            let cost = allocation_counter::measure(|| {
                gradient = Some(Gradient::new(line(), &stops[..2], Extend::Pad, mode).unwrap())
            });
            assert_eq!((cost.count_total, cost.bytes_total), (1, 232));
            let g = Gradient::new(line(), &stops, Extend::Reflect, mode).unwrap();
            fn check<S: Simd>(simd: S, g: GradientView<'_>) {
                for mask in 0..16 {
                    for x in [
                        0.0,
                        0.125,
                        0.3,
                        f32::from_bits(0.3f32.to_bits() - 1),
                        0.7,
                        1.0,
                    ] {
                        let points = [[x, 0.0], [0.3, 0.5], [1.0 - x, 0.0], [0.0, 1.0]];
                        let vector = g.sample_four(simd, points, mask);
                        for i in 0..4 {
                            let expected = if mask & (1 << i) == 0 {
                                [0.0; 4]
                            } else {
                                g.sample(points[i]).unwrap()
                            };
                            assert_eq!(
                                vector[i].map(f32::to_bits),
                                expected.map(f32::to_bits),
                                "{:?} {mask} {x} {i}",
                                simd.level()
                            );
                        }
                    }
                }
            }
            check(fearless_simd::Fallback::new(), g.view());
            let level = fearless_simd::Level::new();
            #[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
            {
                if let Some(s) = level.as_sse2() {
                    check(s, g.view());
                }
                if let Some(s) = level.as_sse4_2() {
                    check(s, g.view());
                }
                if let Some(s) = level.as_avx2() {
                    check(s, g.view());
                }
                if let Some(s) = level.as_avx512() {
                    check(s, g.view());
                }
            }
            #[cfg(target_arch = "aarch64")]
            if let Some(s) = level.as_neon() {
                check(s, g.view());
            }
            eprintln!("perceptual SIMD available backend ceiling {level:?}");
        }
    }
    #[test]
    fn resource_compilation_has_one_allocation_and_no_temporary_stop_vector() {
        let stops = [
            GradientStop::new(0., Color::BLACK),
            GradientStop::new(1., Color::WHITE),
        ];
        let mut resource = None;
        let cost = allocation_counter::measure(|| resource = Some(gradient(&stops, Extend::Pad)));
        assert_eq!(cost.count_total, 1);
        assert_eq!(cost.bytes_total, 200);
        eprintln!(
            "gradient_resource,handle={},key={},key_align={},payload={},allocation_count={},allocated_bytes={}",
            size_of::<Gradient>(),
            size_of::<GradientKey>(),
            align_of::<GradientKey>(),
            resource.unwrap().view().byte_len(),
            cost.count_total,
            cost.bytes_total
        );
    }
    #[test]
    fn authored_hdr_bits_and_small_handle_are_lossless() {
        let hidden = Color::linear_srgb(-0.0, 3.0, -0.25, f32::from_bits(1)).unwrap();
        let stops = [
            GradientStop::new(-0.25, hidden),
            GradientStop::new(2.0, Color::WHITE),
        ];
        let g = gradient(&stops, Extend::Pad);
        assert!(g.view().stop(0).unwrap().color.same_authoring(hidden));
        assert_eq!(g.view().geometry(), line());
        assert_eq!(size_of::<Gradient>(), 8);
        assert_eq!(size_of::<GradientKey>(), 8);
        assert_eq!(align_of::<GradientKey>(), 4);
        assert_eq!(g.view().byte_len(), 48 + 2 * 64);
        assert_eq!(g.key(), g.clone().key());
        let mut identities = std::collections::HashSet::new();
        for _ in 0..256 {
            assert!(identities.insert(gradient(&stops, Extend::Pad).key()));
        }
        eprintln!(
            "gradient_layout,handle={},key={},key_align={},view={},header_words=3,stop_words=4,payload2={}",
            size_of::<Gradient>(),
            size_of::<GradientKey>(),
            align_of::<GradientKey>(),
            size_of::<GradientView<'_>>(),
            g.view().byte_len()
        );
    }
    #[test]
    fn hard_edges_endpoints_and_negative_spreads_have_explicit_sides() {
        let g = gradient(
            &[
                GradientStop::new(0.0, Color::BLACK),
                GradientStop::new(0.5, Color::BLACK),
                GradientStop::new(0.5, Color::WHITE),
                GradientStop::new(1.0, Color::WHITE),
            ],
            Extend::Pad,
        );
        assert_eq!(g.view().sample_parameter(0.5).unwrap(), [1.0; 4]);
        assert_eq!(
            g.view().sample_parameter(0.5 - f32::EPSILON).unwrap(),
            [0.0, 0.0, 0.0, 1.0]
        );
        for extend in [Extend::Repeat, Extend::Reflect] {
            let g = gradient(
                &[
                    GradientStop::new(0.25, Color::BLACK),
                    GradientStop::new(0.75, Color::WHITE),
                ],
                extend,
            );
            for t in [-1.0, -0.5, 0.0, 0.5, 1.0] {
                assert_eq!(g.view().sample_parameter(t).unwrap(), [0.5, 0.5, 0.5, 1.0]);
            }
            assert_eq!(
                g.view().sample_parameter(0.75).unwrap()[0],
                if extend == Extend::Repeat { 0.0 } else { 1.0 }
            );
        }
        let g = gradient(
            &[
                GradientStop::new(0.0, Color::BLACK),
                GradientStop::new(0.0, Color::WHITE),
            ],
            Extend::Pad,
        );
        assert_eq!(
            g.view().sample_parameter(-1.0).unwrap(),
            [0.0, 0.0, 0.0, 1.0]
        );
        assert_eq!(g.view().sample_parameter(0.0).unwrap(), [1.0; 4]);
    }
    #[test]
    fn transparent_endpoint_is_premultiplied_before_interpolation() {
        let g = gradient(
            &[
                GradientStop::new(0.0, Color::rgb(255, 0, 0)),
                GradientStop::new(1.0, Color::rgba(0, 0, 255, 0)),
            ],
            Extend::Pad,
        );
        assert_eq!(
            g.view().sample_parameter(0.5).unwrap(),
            [0.5, 0.0, 0.0, 0.5]
        );
        assert_eq!(g.view().sample_parameter(1.0).unwrap(), [0.0; 4]);
    }
    #[test]
    fn geometry_and_numeric_admission_cover_ellipse_conic_and_degeneracy() {
        let stops = [
            GradientStop::new(0.0, Color::BLACK),
            GradientStop::new(1.0, Color::WHITE),
        ];
        let g = Gradient::new(
            GradientGeometry::Radial {
                center: Point { x: 0.5, y: 0.5 },
                radii: [0.5, 0.25],
            },
            &stops,
            Extend::Pad,
            Interpolation::LinearSrgb,
        )
        .unwrap();
        assert_eq!(g.view().sample([0.75, 0.5]).unwrap()[0], 0.5);
        assert_eq!(g.view().sample([0.5, 0.625]).unwrap()[0], 0.5);
        let g = Gradient::new(
            GradientGeometry::Conic {
                center: Point { x: 0.5, y: 0.5 },
                start_turn: 0.0,
            },
            &stops,
            Extend::Pad,
            Interpolation::LinearSrgb,
        )
        .unwrap();
        for (p, value) in [
            ([0.5, 0.0], 0.0),
            ([1.0, 0.5], 0.25),
            ([0.5, 1.0], 0.5),
            ([0.0, 0.5], 0.75),
            ([0.5, 0.5], 0.0),
        ] {
            assert_eq!(g.view().sample(p).unwrap()[0], value);
        }
        for geometry in [
            GradientGeometry::Linear {
                start: Point::default(),
                end: Point::default(),
            },
            GradientGeometry::Radial {
                center: Point::default(),
                radii: [0.0, 1.0],
            },
            GradientGeometry::Radial {
                center: Point::default(),
                radii: [f32::from_bits(1), 1.0],
            },
            GradientGeometry::Conic {
                center: Point::default(),
                start_turn: f32::NAN,
            },
        ] {
            assert_eq!(
                Gradient::new(geometry, &stops, Extend::Pad, Interpolation::LinearSrgb).err(),
                Some(Error::InvalidGradient)
            );
        }
        for stops in [
            vec![],
            vec![stops[0]],
            vec![stops[1], stops[0]],
            vec![GradientStop::new(f32::INFINITY, Color::BLACK), stops[1]],
            vec![stops[0], GradientStop::new(f32::from_bits(1), Color::WHITE)],
        ] {
            assert_eq!(
                Gradient::new(line(), &stops, Extend::Pad, Interpolation::LinearSrgb).err(),
                Some(Error::InvalidGradient)
            );
        }
        assert!(
            Gradient::new(
                line(),
                &[stops[0], stops[0]],
                Extend::Repeat,
                Interpolation::LinearSrgb
            )
            .is_err()
        );
        assert!(
            Gradient::new(
                line(),
                &[stops[0], GradientStop::new(1e-10, Color::WHITE)],
                Extend::Repeat,
                Interpolation::LinearSrgb
            )
            .is_err()
        );
    }
}
