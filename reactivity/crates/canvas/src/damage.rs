/// Conservative integer device bounds of changed pixels. Empty by default.
/// Coordinates fit the canvas's checked 16,384-pixel per-axis limit; this is
/// exact integer storage, without rounding or a per-tile allocation.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct DamageRegion([u16; 4]);

impl DamageRegion {
    pub(crate) fn coordinates(self) -> [u16; 4] {
        self.0
    }

    pub fn is_empty(self) -> bool {
        self.0[0] == self.0[2] || self.0[1] == self.0[3]
    }

    /// Half-open `[left, top, right, bottom]`, or None for no changed support.
    pub fn bounds(self) -> Option<[u32; 4]> {
        (!self.is_empty()).then(|| self.0.map(u32::from))
    }

    pub fn union(self, other: Self) -> Self {
        if self.is_empty() {
            return other;
        }
        if other.is_empty() {
            return self;
        }
        Self([
            self.0[0].min(other.0[0]),
            self.0[1].min(other.0[1]),
            self.0[2].max(other.0[2]),
            self.0[3].max(other.0[3]),
        ])
    }

    pub(crate) fn checked_canvas_bounds(bounds: [usize; 4]) -> Self {
        debug_assert!(bounds.iter().all(|&value| value <= 16_384));
        Self(bounds.map(|value| u16::try_from(value).expect("checked canvas coordinate")))
    }
}

/// Bounded, pairwise separated conservative repair regions. A single region
/// allocates nothing. At most 64 regions are retained; overflow permanently
/// collapses this update to its bounding rectangle. No pixel is omitted.
#[derive(Debug)]
pub struct DamageRegions(Regions);
#[derive(Debug)]
enum Regions {
    One(DamageRegion),
    Many(Vec<DamageRegion>),
    Dense(DamageRegion),
}
impl Default for DamageRegions {
    fn default() -> Self {
        Self(Regions::One(DamageRegion::default()))
    }
}
impl DamageRegions {
    pub fn regions(&self) -> &[DamageRegion] {
        match &self.0 {
            Regions::One(region) | Regions::Dense(region) => std::slice::from_ref(region),
            Regions::Many(regions) => regions,
        }
    }
    pub fn bounds(&self) -> DamageRegion {
        self.regions()
            .iter()
            .fold(DamageRegion::default(), |a, &b| a.union(b))
    }
    pub fn pixels(&self) -> u64 {
        self.regions()
            .iter()
            .filter_map(|r| r.bounds())
            .map(|[l, t, r, b]| u64::from(r - l) * u64::from(b - t))
            .sum()
    }
    /// Add old or new support. Intersecting/touching rectangles are merged into
    /// their bounds, which may conservatively include otherwise unchanged gaps.
    pub fn include(&mut self, mut region: DamageRegion) {
        if region.is_empty() {
            return;
        }
        let touches = |a: DamageRegion, b: DamageRegion| {
            let [l, t, r, bottom] = a.0;
            let [x, y, right, down] = b.0;
            l <= right && x <= r && t <= down && y <= bottom
        };
        match &mut self.0 {
            Regions::Dense(bounds) => *bounds = bounds.union(region),
            Regions::One(old) if old.is_empty() || touches(*old, region) => {
                *old = old.union(region)
            }
            Regions::One(old) => {
                let mut regions = Vec::with_capacity(64);
                regions.extend([*old, region]);
                self.0 = Regions::Many(regions);
            }
            Regions::Many(regions) => {
                let mut index = 0;
                while index < regions.len() {
                    if touches(regions[index], region) {
                        region = region.union(regions.swap_remove(index));
                        index = 0;
                    } else {
                        index += 1;
                    }
                }
                if regions.len() == 64 {
                    self.0 = Regions::Dense(regions.iter().fold(region, |a, &b| a.union(b)));
                } else {
                    regions.push(region);
                }
            }
        }
    }
}
