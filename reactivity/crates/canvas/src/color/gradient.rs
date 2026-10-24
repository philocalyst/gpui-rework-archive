//! Immutable analytic paint. Author stops and compiled intervals share one lease.
use super::Color;
use crate::{Error, Point};
use std::sync::atomic::{AtomicU64, Ordering};
use triomphe::ThinArc;

pub const MAX_GRADIENT_STOPS: usize = 4096;
const HEADER_WORDS: usize = 3;
const STOP_WORDS: usize = 4;
type Word = [u32; 4];

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
/// This first analytic material interpolates premultiplied extended linear sRGB.
/// Further spaces need explicit preparation AND CPU/GPU decoding, not a tag
/// silently accepted by one backend.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Interpolation {
    LinearSrgb,
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
    pub fn new(
        geometry: GradientGeometry,
        stops: &[GradientStop],
        extend: Extend,
        interpolation: Interpolation,
    ) -> Result<Self, Error> {
        let Interpolation::LinearSrgb = interpolation;
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
                u32::from(stops.iter().any(|stop| stop.color.alpha() > 0.0)),
            ],
            author.map(f32::to_bits),
            prepared.map(f32::to_bits),
        ];
        static NEXT: AtomicU64 = AtomicU64::new(1);
        let id = NEXT
            .try_update(Ordering::Relaxed, Ordering::Relaxed, |n| n.checked_add(1))
            .map_err(|_| Error::ResourceLimit)?;
        let key = GradientKey([id as u32, (id >> 32) as u32]);
        let mut cached = [[0; 4]; STOP_WORDS];
        let words = (0..HEADER_WORDS + stops.len() * STOP_WORDS).map(|word| {
            if word < HEADER_WORDS {
                return header[word];
            }
            let n = word - HEADER_WORDS;
            if n.is_multiple_of(STOP_WORDS) {
                let i = n / STOP_WORDS;
                let stop = stops[i];
                let next = stops.get(i + 1).copied().unwrap_or(stop);
                let base = stop.color.premultiplied();
                let right = next.color.premultiplied();
                let span = next.offset - stop.offset;
                cached = [
                    [
                        stop.offset.to_bits(),
                        if span > 0.0 {
                            (1.0 / span).to_bits()
                        } else {
                            0
                        },
                        0,
                        0,
                    ],
                    base.map(f32::to_bits),
                    std::array::from_fn(|c| (right[c] - base[c]).to_bits()),
                    stop.color.words,
                ];
            }
            cached[n % STOP_WORDS]
        });
        let resource =
            ThinArc::try_from_header_and_iter(key, words).map_err(|_| Error::ResourceLimit)?;
        Ok(Self(resource))
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
    /// Shared validated word schema: three header words, four per stop (position
    /// and reciprocal span, premultiplied base, delta, exact authored Color).
    pub fn words(self) -> &'a [Word] {
        self.words
    }
    pub fn has_visible_stop(self) -> bool {
        self.words[0][3] != 0
    }
    pub fn extend(self) -> Extend {
        match self.words[0][1] {
            0 => Extend::Pad,
            1 => Extend::Repeat,
            _ => Extend::Reflect,
        }
    }
    pub fn interpolation(self) -> Interpolation {
        Interpolation::LinearSrgb
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
        let base = HEADER_WORDS + index * STOP_WORDS;
        Some(GradientStop {
            offset: f32::from_bits(self.words[base][0]),
            color: Color {
                words: self.words[base + 3],
            },
        })
    }
    /// Premultiplied extended-linear output; no gamut clipping or output encode.
    pub fn sample(self, point: [f32; 2]) -> [f32; 4] {
        let p = self.words[2].map(f32::from_bits);
        let x = point[0] - p[0];
        let y = point[1] - p[1];
        let t = match self.words[0][0] {
            0 => x * p[2] + y * p[3],
            1 => ((x * p[2]) * (x * p[2]) + (y * p[3]) * (y * p[3])).sqrt(),
            _ => {
                let angle = if x == 0.0 && y == 0.0 {
                    0.0
                } else {
                    x.atan2(-y) / std::f32::consts::TAU
                };
                let value = angle - p[2];
                value - value.floor()
            }
        };
        self.sample_parameter(t)
    }
    pub fn sample_parameter(self, mut t: f32) -> [f32; 4] {
        let n = self.stop_count();
        let first = f32::from_bits(self.words[HEADER_WORDS][0]);
        let last = f32::from_bits(self.words[HEADER_WORDS + (n - 1) * STOP_WORDS][0]);
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
            if f32::from_bits(self.words[HEADER_WORDS + mid * STOP_WORDS][0]) <= t {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        let i = low.saturating_sub(1);
        let base = HEADER_WORDS + i * STOP_WORDS;
        let meta = self.words[base].map(f32::from_bits);
        let c = self.words[base + 1].map(f32::from_bits);
        if low == 0 || i + 1 == n {
            return c;
        }
        let u = ((t - meta[0]) * meta[1]).clamp(0.0, 1.0);
        let d = self.words[base + 2].map(f32::from_bits);
        std::array::from_fn(|j| c[j] + u * d[j])
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
        assert_eq!(g.view().sample_parameter(0.5), [1.0; 4]);
        assert_eq!(
            g.view().sample_parameter(0.5 - f32::EPSILON),
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
                assert_eq!(g.view().sample_parameter(t), [0.5, 0.5, 0.5, 1.0]);
            }
            assert_eq!(
                g.view().sample_parameter(0.75)[0],
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
        assert_eq!(g.view().sample_parameter(-1.0), [0.0, 0.0, 0.0, 1.0]);
        assert_eq!(g.view().sample_parameter(0.0), [1.0; 4]);
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
        assert_eq!(g.view().sample_parameter(0.5), [0.5, 0.0, 0.0, 0.5]);
        assert_eq!(g.view().sample_parameter(1.0), [0.0; 4]);
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
        assert_eq!(g.view().sample([0.75, 0.5])[0], 0.5);
        assert_eq!(g.view().sample([0.5, 0.625])[0], 0.5);
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
            assert_eq!(g.view().sample(p)[0], value);
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
