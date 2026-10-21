//! Immutable geometry owned by one complete presentation. Reassembly only copies
//! the six admitted coefficients; it never recomposes or rounds a transform.
use super::{Affine, Presented};

const LIMIT: usize = 32;
pub(super) const ABSENT: u8 = u8::MAX;
const _: () = assert!(LIMIT < ABSENT as usize);
type Linear = [f32; 4];

pub(super) enum Spaces {
    Common(Linear),
    Shared(Box<[Linear]>),
    Dense(Vec<Affine>),
}
impl Default for Spaces {
    fn default() -> Self {
        Self::Common([1.0, 0.0, 0.0, 1.0])
    }
}
impl Spaces {
    #[inline]
    pub(super) fn transform(&self, index: usize, node: &Presented) -> Option<Affine> {
        if node.space == ABSENT {
            return None;
        }
        Some(match self {
            Self::Common(linear) => assemble(*linear, node.translation),
            Self::Shared(palette) => assemble(palette[usize::from(node.space)], node.translation),
            Self::Dense(values) => values[index],
        })
    }
}
#[inline]
fn linear(map: Affine) -> Linear {
    [map.a, map.b, map.c, map.d]
}
#[inline]
fn assemble([a, b, c, d]: Linear, [tx, ty]: [f32; 2]) -> Affine {
    Affine { a, b, c, d, tx, ty }
}
#[inline]
fn exact(a: Linear, b: Linear) -> bool {
    a.map(f32::to_bits) == b.map(f32::to_bits)
}

enum Building {
    Common(Option<Linear>),
    Shared(Vec<Linear>),
    Dense(Vec<Affine>),
}
pub(super) struct Builder {
    mode: Building,
    total: usize,
}
impl Builder {
    pub(super) fn new(total: usize) -> Self {
        Self {
            mode: Building::Common(None),
            total,
        }
    }
    // The prefix is this candidate's published nodes, never the acknowledged
    // sheet. Its exact translations permit one bounded promotion to dense.
    #[inline]
    pub(super) fn push(&mut self, map: Option<Affine>, prefix: &[Presented]) -> u8 {
        debug_assert!(map.is_none_or(|map| map.is_finite() && map.is_invertible()));
        if let Building::Dense(values) = &mut self.mode {
            values.push(map.unwrap_or(Affine::IDENTITY));
            return if map.is_some() { 0 } else { ABSENT };
        }
        let Some(map) = map else { return ABSENT };
        let value = linear(map);
        match &mut self.mode {
            Building::Common(None) => {
                self.mode = Building::Common(Some(value));
                0
            }
            Building::Common(Some(first)) if exact(*first, value) => 0,
            Building::Common(Some(first)) => {
                let mut palette = Vec::with_capacity(LIMIT);
                palette.extend([*first, value]);
                self.mode = Building::Shared(palette);
                1
            }
            Building::Shared(palette) => {
                if let Some(index) = palette.iter().position(|&prior| exact(prior, value)) {
                    index as u8
                } else if palette.len() < LIMIT {
                    let index = palette.len() as u8;
                    palette.push(value);
                    index
                } else {
                    let mut values = Vec::with_capacity(self.total);
                    values.extend(prefix.iter().map(|node| {
                        if node.space == ABSENT {
                            Affine::IDENTITY
                        } else {
                            assemble(palette[usize::from(node.space)], node.translation)
                        }
                    }));
                    values.push(map);
                    self.mode = Building::Dense(values);
                    0
                }
            }
            Building::Dense(_) => unreachable!(),
        }
    }
    pub(super) fn finish(self) -> Spaces {
        match self.mode {
            Building::Common(first) => Spaces::Common(first.unwrap_or([1.0, 0.0, 0.0, 1.0])),
            Building::Shared(palette) => Spaces::Shared(palette.into_boxed_slice()),
            Building::Dense(values) => Spaces::Dense(values),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::runtime::{Actions, NodeKind, Parent, Rect};

    fn node(map: Option<Affine>, space: u8) -> Presented {
        Presented {
            identity: 1,
            parent: Parent::NONE,
            kind: NodeKind::Div,
            text: None,
            size: [12.0, 23.0],
            translation: map.map_or([0.0, 0.0], |map| [map.tx, map.ty]),
            space,
            bounds: Rect::default(),
            hittable: false,
            actions: Actions::default(),
        }
    }
    fn build(maps: &[Option<Affine>]) -> (Vec<Presented>, Spaces) {
        let mut builder = Builder::new(maps.len());
        let mut nodes = Vec::with_capacity(maps.len());
        for &map in maps {
            let space = builder.push(map, &nodes);
            nodes.push(node(map, space));
        }
        (nodes, builder.finish())
    }
    fn bits(map: Option<Affine>) -> Option<[u32; 6]> {
        map.map(|map| [map.a, map.b, map.c, map.d, map.tx, map.ty].map(f32::to_bits))
    }
    fn assert_maps(maps: &[Option<Affine>], nodes: &[Presented], spaces: &Spaces) {
        for (index, (&expected, node)) in maps.iter().zip(nodes).enumerate() {
            assert_eq!(bits(spaces.transform(index, node)), bits(expected));
            assert_eq!(node.local_rect(), Rect::new(0.0, 0.0, 12.0, 23.0));
        }
    }
    #[test]
    fn exact_common_and_absent_maps_allocate_nothing() {
        assert_eq!(size_of::<Presented>(), 56);
        assert_eq!(size_of::<Spaces>(), 24);
        for map in [
            None,
            Some(Affine::IDENTITY),
            Some(Affine {
                a: -0.0,
                b: 1.0,
                c: -1.0,
                d: 0.0,
                tx: -0.0,
                ty: f32::MAX,
            }),
            Some(Affine::scale(-2.0, 0.25)),
        ] {
            let maps = [map; 64];
            // Nodes are unrelated storage: count just lane construction.
            let mut nodes = Vec::with_capacity(maps.len());
            let mut result = None;
            let allocation = allocation_counter::measure(|| {
                let mut builder = Builder::new(maps.len());
                for &map in &maps {
                    let space = builder.push(map, &nodes);
                    nodes.push(node(map, space));
                }
                result = Some(builder.finish());
            });
            assert_eq!(allocation.count_total, 0);
            let spaces = result.unwrap();
            assert!(matches!(spaces, Spaces::Common(_)));
            assert_maps(&maps, &nodes, &spaces);
        }
    }
    #[test]
    fn every_coefficient_bit_and_explicit_absence_survives_dense_promotion() {
        let mut maps = Vec::new();
        for index in 0..100 {
            if index % 3 == 0 {
                maps.push(None);
            }
            maps.push(Some(Affine {
                a: index as f32 + 1.0,
                b: if index % 2 == 0 { -0.0 } else { 0.0 },
                c: 0.0,
                d: -1.0,
                tx: if index % 2 == 0 { -0.0 } else { index as f32 },
                ty: f32::from_bits(1 + index),
            }));
        }
        let (nodes, spaces) = build(&maps);
        assert!(matches!(spaces, Spaces::Dense(_)));
        assert_maps(&maps, &nodes, &spaces);
    }
    #[test]
    fn palette_compares_bits_and_all_thirty_two_values_are_supported() {
        let mut maps = Vec::new();
        for _ in 0..8 {
            for index in 0..32 {
                maps.push(Some(Affine {
                    a: 1.0,
                    b: if index < 16 { 0.0 } else { -0.0 },
                    c: 0.0,
                    d: (index % 16) as f32 + 1.0,
                    tx: maps.len() as f32,
                    ty: -0.0,
                }));
            }
        }
        let (nodes, spaces) = build(&maps);
        let Spaces::Shared(palette) = &spaces else {
            panic!("expected palette")
        };
        assert_eq!(palette.len(), 32);
        assert_maps(&maps, &nodes, &spaces);
    }
    #[test]
    fn sheet_lanes_remain_independent_and_rebuilds_reclaim_history() {
        let maps = [Some(Affine::translation(-0.0, 24.0)); 64];
        let (old, old_spaces) = build(&maps);
        for frame in 0..100 {
            let new_maps = (0..64)
                .map(|index| Some(Affine::scale(index as f32 + 1.0, frame as f32 + 1.0)))
                .collect::<Vec<_>>();
            let (nodes, spaces) = build(&new_maps);
            let Spaces::Dense(values) = &spaces else {
                panic!("expected dense")
            };
            assert_eq!(values.len(), nodes.len());
            assert_eq!(values.capacity(), nodes.len());
            assert_maps(&maps, &old, &old_spaces);
            assert_maps(&new_maps, &nodes, &spaces);
        }
    }
    #[test]
    fn palette_and_dense_allocation_ledger() {
        for distinct in [0, 1, 2, 32, 33, 4096] {
            let mut nodes = Vec::with_capacity(4096);
            let mut result = None;
            let allocation = allocation_counter::measure(|| {
                let mut builder = Builder::new(4096);
                for index in 0..4096 {
                    let map = (distinct != 0)
                        .then(|| Affine::scale((index % distinct) as f32 + 1.0, 1.0));
                    let space = builder.push(map, &nodes);
                    nodes.push(node(map, space));
                }
                result = Some(builder.finish());
            });
            let expected = match distinct {
                0 | 1 => 0,
                2 | 32 => distinct * 16,
                _ => 4096 * 24,
            };
            assert_eq!(allocation.bytes_current, expected as i64);
            println!(
                "space_allocations,{distinct},{},{},{},{}",
                allocation.count_total,
                allocation.bytes_total,
                allocation.bytes_current,
                allocation.bytes_max
            );
            std::hint::black_box(result);
        }
    }
}
