use crate::{Class, Point, Primitive, Rect};

const MAX_PIXELS: usize = 1 << 20;
const MAX_REFERENCES: usize = 1 << 24;

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Color([f64; 4]);
impl Color {
    pub const TRANSPARENT: Self = Self([0.0; 4]);
    /// Linear premultiplied RGBA. The lab admits bounded channels only.
    pub fn new(red: f64, green: f64, blue: f64, alpha: f64) -> Option<Self> {
        let color = [red, green, blue, alpha];
        (color.into_iter().all(f64::is_finite)
            && (0.0..=1.0).contains(&alpha)
            && [red, green, blue]
                .into_iter()
                .all(|c| c >= 0.0 && c <= alpha))
        .then_some(Self(color))
    }
    pub fn channels(self) -> [f64; 4] {
        self.0
    }
    fn over(self, background: Self) -> Self {
        let factor = 1.0 - self.0[3];
        Self(std::array::from_fn(|i| {
            self.0[i] + background.0[i] * factor
        }))
    }
    fn backdrop_scale(self, factor: f64) -> Self {
        Self([
            self.0[0] * factor,
            self.0[1] * factor,
            self.0[2] * factor,
            self.0[3],
        ])
    }
}
#[derive(Clone, Copy, Debug)]
// Inline commands avoid a separate allocation per primitive in this scalar lab.
// The full command width is included in the benchmark's immutable-scene ledger.
#[allow(clippy::large_enum_variant)]
pub enum Operation {
    SourceOver {
        primitive: Primitive,
        color: Color,
    },
    /// A real pointwise destination dependency used to test barrier semantics.
    /// This is a brightness operation, not a blur/backdrop backend implementation.
    BackdropScale {
        factor: f64,
    },
}
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum RenderError {
    Geometry,
    Viewport,
    Samples,
    Budget,
}
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub struct Stats {
    pub classifier_calls: u64,
    /// Full interval center-distance attempts; point predicates are separate.
    pub distance_evaluations: u64,
    pub outside_tiles: u64,
    pub inside_tiles: u64,
    pub boundary_tiles: u64,
    pub occluded_tile_draws: u64,
    pub retained_tile_operations: u64,
    /// Inverse mapping plus implicit circle/box sign tests, without SDF sqrt.
    pub boundary_point_tests: u64,
}
#[derive(Clone, Copy)]
enum Planned {
    Draw { index: u32, class: Class },
    Backdrop { index: u32 },
}
struct Bin {
    operations: Vec<Planned>,
    opaque: bool,
}
#[derive(Clone, Copy)]
struct Range {
    x0: u32,
    y0: u32,
    x1: u32,
    y1: u32,
}

/// Borrowing the immutable scene keeps certificates valid for the plan's lifetime.
/// Bins are built front-to-back, so proven hidden draws need neither references
/// nor point tests. Every backdrop dependency resets that segment's occlusion.
pub struct Plan<'a> {
    operations: &'a [Operation],
    width: u32,
    height: u32,
    tile: u32,
    columns: u32,
    bins: Vec<Bin>,
    scratch: Vec<Range>,
    stats: Stats,
    culling: bool,
}
impl<'a> Plan<'a> {
    pub fn build(
        operations: &'a [Operation],
        width: u32,
        height: u32,
        tile: u32,
        hierarchy: bool,
    ) -> Result<Self, RenderError> {
        Self::build_inner(operations, width, height, tile, hierarchy, true)
    }
    /// Classification-only control for measuring what opaque proof eliminates.
    pub fn build_unculled(
        operations: &'a [Operation],
        width: u32,
        height: u32,
        tile: u32,
        hierarchy: bool,
    ) -> Result<Self, RenderError> {
        Self::build_inner(operations, width, height, tile, hierarchy, false)
    }
    fn build_inner(
        operations: &'a [Operation],
        width: u32,
        height: u32,
        tile: u32,
        hierarchy: bool,
        culling: bool,
    ) -> Result<Self, RenderError> {
        validate(operations, width, height)?;
        if tile == 0 {
            return Err(RenderError::Viewport);
        }
        let columns = width.div_ceil(tile);
        let rows = height.div_ceil(tile);
        let mut result = Self {
            operations,
            width,
            height,
            tile,
            columns,
            bins: (0..columns as usize * rows as usize)
                .map(|_| Bin {
                    operations: Vec::new(),
                    opaque: false,
                })
                .collect(),
            scratch: Vec::new(),
            stats: Stats::default(),
            culling,
        };
        for (index, &operation) in operations.iter().enumerate().rev() {
            let index = u32::try_from(index).map_err(|_| RenderError::Budget)?;
            match operation {
                Operation::BackdropScale { .. } => {
                    for bin in &mut result.bins {
                        bin.operations.push(Planned::Backdrop { index });
                        bin.opaque = false;
                        result.stats.retained_tile_operations += 1;
                    }
                }
                Operation::SourceOver { primitive, color } => {
                    if hierarchy {
                        result.scratch.push(Range {
                            x0: 0,
                            y0: 0,
                            x1: columns,
                            y1: rows,
                        });
                        while let Some(range) = result.scratch.pop() {
                            if result.range_hidden(range) {
                                result.stats.occluded_tile_draws +=
                                    u64::from(range.x1 - range.x0) * u64::from(range.y1 - range.y0);
                                continue;
                            }
                            let class = result.classify(primitive, range);
                            if class == Class::Boundary
                                && (range.x1 - range.x0 > 1 || range.y1 - range.y0 > 1)
                            {
                                result.split(range);
                            } else {
                                result.emit(range, index, color, class);
                            }
                        }
                    } else {
                        for y in 0..rows {
                            for x in 0..columns {
                                let range = Range {
                                    x0: x,
                                    y0: y,
                                    x1: x + 1,
                                    y1: y + 1,
                                };
                                if result.range_hidden(range) {
                                    result.stats.occluded_tile_draws += 1;
                                    continue;
                                }
                                let class = result.classify(primitive, range);
                                result.emit(range, index, color, class);
                            }
                        }
                    }
                }
            }
            if result.stats.retained_tile_operations as usize > MAX_REFERENCES {
                return Err(RenderError::Budget);
            }
        }
        for bin in &mut result.bins {
            bin.operations.reverse();
        }
        Ok(result)
    }
    pub fn stats(&self) -> Stats {
        self.stats
    }
    /// Exact retained temporary payload; excludes allocator/Vec headers external
    /// to this object and the immutable scene. No GPU memory is implied.
    pub fn temporary_bytes(&self) -> usize {
        std::mem::size_of::<Self>()
            + self.bins.capacity() * std::mem::size_of::<Bin>()
            + self.scratch.capacity() * std::mem::size_of::<Range>()
            + self
                .bins
                .iter()
                .map(|b| b.operations.capacity() * std::mem::size_of::<Planned>())
                .sum::<usize>()
    }
    pub fn render(&self, samples: &[Point]) -> Result<(Vec<Color>, Stats), RenderError> {
        validate_samples(samples)?;
        let mut stats = self.stats;
        let mut pixels = Vec::with_capacity(self.width as usize * self.height as usize);
        for y in 0..self.height {
            for x in 0..self.width {
                let bin = &self.bins[((y / self.tile) * self.columns + x / self.tile) as usize];
                let mut average = [0.0; 4];
                for sample in samples {
                    let point = Point {
                        x: f64::from(x) + sample.x,
                        y: f64::from(y) + sample.y,
                    };
                    let mut color = Color::TRANSPARENT;
                    for &planned in &bin.operations {
                        match planned {
                            Planned::Draw { index, class } => {
                                let Operation::SourceOver {
                                    primitive,
                                    color: source,
                                } = self.operations[index as usize]
                                else {
                                    unreachable!("draw references source-over")
                                };
                                let covered = if class == Class::Inside {
                                    true
                                } else {
                                    stats.boundary_point_tests += 1;
                                    primitive.contains(point).ok_or(RenderError::Geometry)?
                                };
                                if covered {
                                    color = source.over(color);
                                }
                            }
                            Planned::Backdrop { index } => {
                                let Operation::BackdropScale { factor } =
                                    self.operations[index as usize]
                                else {
                                    unreachable!("backdrop reference")
                                };
                                color = color.backdrop_scale(factor);
                            }
                        }
                    }
                    for (sum, value) in average.iter_mut().zip(color.0) {
                        *sum += value;
                    }
                }
                pixels.push(Color(average.map(|v| v / samples.len() as f64)));
            }
        }
        Ok((pixels, stats))
    }
    fn range_hidden(&self, range: Range) -> bool {
        (range.y0..range.y1).all(|y| {
            (range.x0..range.x1).all(|x| self.bins[(y * self.columns + x) as usize].opaque)
        })
    }
    fn classify(&mut self, primitive: Primitive, range: Range) -> Class {
        self.stats.classifier_calls += 1;
        self.stats.distance_evaluations += 1;
        let x = (range.x0 * self.tile).min(self.width);
        let y = (range.y0 * self.tile).min(self.height);
        primitive.classify(Rect {
            x: f64::from(x),
            y: f64::from(y),
            width: f64::from((range.x1 * self.tile).min(self.width) - x),
            height: f64::from((range.y1 * self.tile).min(self.height) - y),
        })
    }
    fn emit(&mut self, range: Range, index: u32, color: Color, class: Class) {
        for y in range.y0..range.y1 {
            for x in range.x0..range.x1 {
                let bin = &mut self.bins[(y * self.columns + x) as usize];
                if bin.opaque {
                    self.stats.occluded_tile_draws += 1;
                    continue;
                }
                match class {
                    Class::Outside => self.stats.outside_tiles += 1,
                    Class::Inside => self.stats.inside_tiles += 1,
                    Class::Boundary => self.stats.boundary_tiles += 1,
                }
                if class == Class::Outside {
                    continue;
                }
                bin.operations.push(Planned::Draw { index, class });
                self.stats.retained_tile_operations += 1;
                if self.culling && class == Class::Inside && color.0[3] == 1.0 {
                    bin.opaque = true;
                }
            }
        }
    }
    fn split(&mut self, r: Range) {
        let xm = r.x0 + (r.x1 - r.x0) / 2;
        let ym = r.y0 + (r.y1 - r.y0) / 2;
        let xs = if xm == r.x0 {
            [r.x0, r.x1, r.x1]
        } else {
            [r.x0, xm, r.x1]
        };
        let ys = if ym == r.y0 {
            [r.y0, r.y1, r.y1]
        } else {
            [r.y0, ym, r.y1]
        };
        for y in 0..2 {
            for x in 0..2 {
                if xs[x] < xs[x + 1] && ys[y] < ys[y + 1] {
                    self.scratch.push(Range {
                        x0: xs[x],
                        y0: ys[y],
                        x1: xs[x + 1],
                        y1: ys[y + 1],
                    });
                }
            }
        }
    }
}
fn validate(operations: &[Operation], width: u32, height: u32) -> Result<(), RenderError> {
    let pixels = (width as usize)
        .checked_mul(height as usize)
        .ok_or(RenderError::Budget)?;
    if width == 0 || height == 0 || pixels > MAX_PIXELS {
        return Err(RenderError::Viewport);
    }
    for operation in operations {
        match operation {
            Operation::SourceOver { primitive, .. } if !primitive.space().is_admitted() => {
                return Err(RenderError::Geometry);
            }
            Operation::BackdropScale { factor }
                if !factor.is_finite() || !(0.0..=1.0).contains(factor) =>
            {
                return Err(RenderError::Geometry);
            }
            _ => {}
        }
    }
    Ok(())
}
fn validate_samples(samples: &[Point]) -> Result<(), RenderError> {
    if samples.is_empty()
        || samples.len() > 256
        || samples.iter().any(|p| {
            ![p.x, p.y]
                .into_iter()
                .all(|v| v.is_finite() && (0.0..=1.0).contains(&v))
        })
    {
        return Err(RenderError::Samples);
    }
    Ok(())
}
/// Clear all-pixel/all-shape reference, with exactly the same finite point-sample
/// contract as Plan::render. Independent geometric/compositing tests supplement it.
pub fn render_direct(
    operations: &[Operation],
    width: u32,
    height: u32,
    samples: &[Point],
) -> Result<(Vec<Color>, Stats), RenderError> {
    validate(operations, width, height)?;
    validate_samples(samples)?;
    let mut stats = Stats::default();
    let mut pixels = Vec::with_capacity(width as usize * height as usize);
    for y in 0..height {
        for x in 0..width {
            let mut average = [0.0; 4];
            for sample in samples {
                let point = Point {
                    x: f64::from(x) + sample.x,
                    y: f64::from(y) + sample.y,
                };
                let mut color = Color::TRANSPARENT;
                for &operation in operations {
                    match operation {
                        Operation::SourceOver {
                            primitive,
                            color: source,
                        } => {
                            stats.boundary_point_tests += 1;
                            if primitive.contains(point).ok_or(RenderError::Geometry)? {
                                color = source.over(color);
                            }
                        }
                        Operation::BackdropScale { factor } => color = color.backdrop_scale(factor),
                    }
                }
                for (sum, value) in average.iter_mut().zip(color.0) {
                    *sum += value;
                }
            }
            pixels.push(Color(average.map(|v| v / samples.len() as f64)));
        }
    }
    Ok((pixels, stats))
}
