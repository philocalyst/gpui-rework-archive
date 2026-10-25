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
