/// The local rectangle always starts at +0,+0. Its former origin words carry
/// the admitted map's exact translation instead; clipped bounds are independent.
#[derive(Clone, Copy)]
pub(super) struct Placement {
    pub translation: Point,
    pub size: [f32; 2],
}
impl Placement {
    pub fn new(size: [f32; 2], map: Option<Affine>) -> Self {
        Self {
            translation: map.map_or(Point { x: 0.0, y: 0.0 }, |map| Point {
                x: map.tx,
                y: map.ty,
            }),
            size,
        }
    }
    pub fn local_rect(self) -> Rect {
        Rect::new(0.0, 0.0, self.size[0], self.size[1])
    }
}

/// Exact finite basis bits, including signed zeros. This never recomposes or
/// renarrows an admitted map; equality is equality of all four stored words.
#[derive(Clone, Copy, PartialEq, Eq)]
struct Basis([u32; 4]);
impl Basis {
    fn from_map(map: Affine) -> Self {
        Self([map.a, map.b, map.c, map.d].map(f32::to_bits))
    }
    fn map(self, translation: Point) -> Affine {
        let [a, b, c, d] = self.0.map(f32::from_bits);
        Affine {
            a,
            b,
            c,
            d,
            tx: translation.x,
            ty: translation.y,
        }
    }
}
struct Radius {
    identity: u64,
    value: f32,
}

/// One safe, private 16-byte geometry stream: finite basis records precede
/// radius records. A basis has passed the existing finite-map admission, so
/// its first word cannot equal the reserved NaN radius marker. All payloads
/// remain ordinary u32 values; no enum/float representation is reinterpreted.
#[derive(Clone, Copy)]
pub(super) struct Record([u32; 4]);
impl Record {
    const RADIUS: u32 = 0x7fc0_0000;

    fn from_basis(basis: Basis) -> Self {
        debug_assert!(
            basis
                .0
                .into_iter()
                .all(|word| f32::from_bits(word).is_finite())
        );
        Self(basis.0)
    }
    fn from_radius(radius: Radius) -> Self {
        Self([
            Self::RADIUS,
            radius.value.to_bits(),
            radius.identity as u32,
            (radius.identity >> 32) as u32,
        ])
    }
    fn is_basis(&self) -> bool {
        self.0[0] != Self::RADIUS
    }
    fn basis(self) -> Basis {
        debug_assert!(self.is_basis());
        Basis(self.0)
    }
    fn radius(self) -> Radius {
        debug_assert!(!self.is_basis());
        Radius {
            identity: u64::from(self.0[2]) | (u64::from(self.0[3]) << 32),
            value: f32::from_bits(self.0[1]),
        }
    }
}

/// Exact diagonal coefficients fit inline when both off-diagonal words are +0.
/// Finite admitted a cannot equal either reserved NaN tag. General bases use a
/// direct index in their own sheet's stream; no sibling interning is performed.
#[derive(Clone, Copy)]
pub(super) struct MapBasis([u32; 2]);
const _: () = assert!(MAX_NODES < u32::MAX as usize);
impl MapBasis {
    const POOLED: u32 = 0x7fc0_0001;
    const INVALID: u32 = 0x7fc0_0002;

    pub fn record(map: Option<Affine>, parent: Option<Self>, records: &mut Vec<Record>) -> Self {
        debug_assert!(map.is_none_or(|map| map.is_finite() && map.is_invertible()));
        let Some(map) = map else {
            return Self([Self::INVALID, 0]);
        };
        let basis = Basis::from_map(map);
        if map.b.to_bits() == 0 && map.c.to_bits() == 0 {
            return Self([map.a.to_bits(), map.d.to_bits()]);
        }
        if let Some(parent) = parent
            && Bases::new(records).get(parent) == Some(basis)
        {
            return parent;
        }
        // Only emitted rows append bases, before any radius suffix exists.
        assert!(
            records.len() < MAX_NODES,
            "basis belongs to the admitted sheet"
        );
        let index = records.len() as u32;
        records.push(Record::from_basis(basis));
        Self([Self::POOLED, index])
    }
}

/// Borrowed basis prefix. During lowering this is the still-local C vector;
/// acknowledged queries obtain it from a once-split immutable Geometry view.
#[derive(Clone, Copy)]
pub(super) struct Bases<'a> {
    records: &'a [Record],
}
impl<'a> Bases<'a> {
    pub fn new(records: &'a [Record]) -> Self {
        Self { records }
    }
    fn get(self, basis: MapBasis) -> Option<Basis> {
        match basis.0 {
            [MapBasis::INVALID, _] => None,
            [MapBasis::POOLED, index] => Some(self.records[index as usize].basis()),
            [a, d] => Some(Basis([a, 0, 0, d])),
        }
    }
    pub fn transform(self, key: MapBasis, placement: Placement) -> Option<Affine> {
        self.get(key).map(|basis| basis.map(placement.translation))
    }
}

/// One borrowed split per query/hit view, never a split or allocation per row.
#[derive(Clone, Copy)]
pub(super) struct GeometryView<'a> {
    records: &'a [Record],
    radius_start: usize,
}
impl<'a> GeometryView<'a> {
    pub fn empty() -> Self {
        Self {
            records: &[],
            radius_start: 0,
        }
    }
    fn new(records: &'a [Record]) -> Self {
        Self {
            records,
            radius_start: records.partition_point(Record::is_basis),
        }
    }
    pub fn bases(self) -> Bases<'a> {
        Bases::new(&self.records[..self.radius_start])
    }
    pub fn radius(self, identity: u64) -> f32 {
        let radii = &self.records[self.radius_start..];
        radii
            .binary_search_by_key(&identity, |record| record.radius().identity)
            .ok()
            .map_or(0.0, |index| radii[index].radius().value)
    }
}

