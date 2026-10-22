//! Exact logical identity lookup, rebuilt only with a complete description.
//!
//! Fresh and unchanged preorder descriptions commonly have consecutive IDs in
//! node order. Their index needs no allocation, including one bounded positive
//! ID gap. A few other consecutive runs retain only their affine mapping; other
//! orders retain a sorted entry per live node.
//! No historical identity survives in this index.

pub(super) enum IdentityIndex {
    Contiguous { first: u64, len: usize },
    Hole { first: u64, shape: HoleShape },
    Runs(Box<[Run]>),
    Indexed(Box<[Entry]>),
}

// Two admitted node counts and one positive gap fit the existing sixteen-byte
// enum payload together with the first ID. This is a representation limit only:
// larger gaps keep the general exact index instead of rejecting a live ID.
const COUNT_BITS: u32 = 17;
const COUNT_MASK: u64 = (1 << COUNT_BITS) - 1;
const GAP_SHIFT: u32 = COUNT_BITS * 2;
const GAP_LIMIT: u64 = 1 << (64 - GAP_SHIFT);
const _: () = assert!(super::MAX_NODES < 1 << COUNT_BITS);

pub(super) struct HoleShape(u64);

impl HoleShape {
    fn new(len: usize, cut: usize, gap: u64) -> Option<Self> {
        debug_assert!(cut > 0 && cut < len && len <= super::MAX_NODES);
        if gap == 0 || gap >= GAP_LIMIT {
            return None;
        }
        Some(Self(
            len as u64 | ((cut as u64) << COUNT_BITS) | (gap << GAP_SHIFT),
        ))
    }

    #[inline]
    fn len(&self) -> u64 {
        self.0 & COUNT_MASK
    }

    #[inline]
    fn cut(&self) -> u64 {
        (self.0 >> COUNT_BITS) & COUNT_MASK
    }

    #[inline]
    fn gap(&self) -> u64 {
        self.0 >> GAP_SHIFT
    }
}

#[derive(Clone, Copy)]
#[repr(C)]
pub(super) struct Run {
    first_id: u64,
    first_index: u32,
    len: u32,
}

// Every access copies the fields by value. Packed alignment reduces the fallback
// to twelve bytes without references to unaligned fields or unsafe code.
#[derive(Clone, Copy)]
#[repr(C, packed(4))]
pub(super) struct Entry {
    identity: u64,
    index: u32,
}

impl Default for IdentityIndex {
    fn default() -> Self {
        Self::Contiguous { first: 0, len: 0 }
    }
}

impl IdentityIndex {
    pub(super) fn from_ids(ids: impl ExactSizeIterator<Item = u64> + Clone) -> Self {
        let len = ids.len();
        assert!(len <= super::MAX_NODES, "admitted logical identity count");
        let Some(first) = ids.clone().next() else {
            return Self::default();
        };
        let mut run_count = 1;
        let mut first_break = (0, 0);
        let mut previous = first;
        for (index, identity) in ids.clone().enumerate().skip(1) {
            if previous.checked_add(1) != Some(identity) {
                if run_count == 1 {
                    first_break = (index, identity);
                }
                run_count += 1;
            }
            previous = identity;
        }
        if run_count == 1 {
            return Self::Contiguous { first, len };
        }
        if run_count == 2 {
            let (cut, next_first) = first_break;
            // Subtracting avoids an overflowing first + cut near u64::MAX.
            if let Some(gap) = next_first
                .checked_sub(first)
                .and_then(|d| d.checked_sub(cut as u64))
                && let Some(shape) = HoleShape::new(len, cut, gap)
            {
                return Self::Hole { first, shape };
            }
        }
        if run_count * std::mem::size_of::<Run>() < len * std::mem::size_of::<Entry>() {
            let mut runs = Vec::with_capacity(run_count);
            let mut current = Run {
                first_id: first,
                first_index: 0,
                len: 1,
            };
            for (index, identity) in ids.skip(1).enumerate() {
                if current.first_id.checked_add(u64::from(current.len)) == Some(identity) {
                    current.len += 1;
                } else {
                    runs.push(current);
                    current = Run {
                        first_id: identity,
                        first_index: (index + 1) as u32,
                        len: 1,
                    };
                }
            }
            runs.push(current);
            runs.sort_unstable_by_key(|run| run.first_id);
            assert!(
                runs.windows(2).all(|pair| {
                    pair[1]
                        .first_id
                        .checked_sub(pair[0].first_id)
                        .is_some_and(|distance| distance >= u64::from(pair[0].len))
                }),
                "distinct admitted logical identities"
            );
            return Self::Runs(runs.into_boxed_slice());
        }
        let mut entries: Vec<_> = ids
            .enumerate()
            .map(|(index, identity)| Entry {
                identity,
                // MAX_NODES admission bounds the local index.
                index: index as u32,
            })
            .collect();
        entries.sort_unstable_by_key(|entry| entry.identity);
        assert!(
            entries
                .windows(2)
                .all(|pair| pair[0].identity != pair[1].identity),
            "distinct admitted logical identities"
        );
        Self::Indexed(entries.into_boxed_slice())
    }

    #[inline]
    pub(super) fn get(&self, identity: u64) -> Option<usize> {
        match self {
            Self::Contiguous { first, len } => {
                let index = identity.checked_sub(*first)?;
                (index < *len as u64).then_some(index as usize)
            }
            Self::Hole { first, shape } => {
                let delta = identity.checked_sub(*first)?;
                let cut = shape.cut();
                if delta < cut {
                    return Some(delta as usize);
                }
                let index = delta.checked_sub(shape.gap())?;
                // IDs inside the hole must not alias the prefix's indices.
                (index >= cut && index < shape.len()).then_some(index as usize)
            }
            Self::Runs(runs) => {
                let next = runs.partition_point(|run| run.first_id <= identity);
                let run = &runs[next.checked_sub(1)?];
                // Comparing displacement avoids an overflowing exclusive end
                // for a run whose last admitted identity is u64::MAX.
                let delta = identity - run.first_id;
                (delta < u64::from(run.len)).then(|| run.first_index as usize + delta as usize)
            }
            Self::Indexed(entries) => entries
                .binary_search_by_key(&identity, |entry| entry.identity)
                .ok()
                .map(|index| entries[index].index as usize),
        }
    }

    pub(super) fn contains(&self, identity: u64) -> bool {
        self.get(identity).is_some()
    }

    /// Only for call sites that have already admitted a live logical target.
    #[inline]
    pub(super) fn required(&self, identity: u64) -> usize {
        self.get(identity).expect("live logical identity")
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::{
        collections::BTreeMap,
        mem::{align_of, size_of},
    };

    #[test]
    fn header_and_exact_fallback_entry_layouts() {
        assert_eq!(size_of::<IdentityIndex>(), 24);
        assert_eq!(
            size_of::<IdentityIndex>(),
            size_of::<BTreeMap<u64, usize>>()
        );
        assert_eq!(size_of::<Entry>(), 12);
        assert_eq!(size_of::<Run>(), 16);
        assert_eq!(align_of::<Entry>(), 4);
    }

    #[test]
    fn empty_and_full_width_contiguous_ranges_allocate_nothing() {
        for ids in [
            vec![],
            vec![1],
            (u64::MAX - 4..=u64::MAX).collect(),
            (100..10_100).collect(),
        ] {
            let mut index = IdentityIndex::default();
            let allocation = allocation_counter::measure(|| {
                index = IdentityIndex::from_ids(ids.iter().copied());
            });
            assert!(matches!(index, IdentityIndex::Contiguous { .. }));
            assert_eq!(allocation.count_total, 0);
            for (expected, &identity) in ids.iter().enumerate() {
                assert_eq!(index.get(identity), Some(expected));
            }
            for absent in [0, 99, 10_100, u64::MAX] {
                assert_eq!(index.contains(absent), ids.contains(&absent));
            }
        }
    }

    #[test]
    fn gaps_and_permutations_match_the_previous_map_exactly() {
        for ids in [
            vec![u64::MAX, 1, 1 << 63, 17, u64::MAX - 1],
            (0..513).map(|i| 10_000 + ((i * 193) % 513) * 3).collect(),
        ] {
            let expected: BTreeMap<_, _> = ids
                .iter()
                .copied()
                .enumerate()
                .map(|(i, id)| (id, i))
                .collect();
            let mut index = IdentityIndex::default();
            let allocation = allocation_counter::measure(|| {
                index = IdentityIndex::from_ids(ids.iter().copied());
            });
            assert!(matches!(index, IdentityIndex::Indexed(_)));
            assert_eq!(allocation.count_total, 1);
            assert_eq!(
                allocation.bytes_total,
                (ids.len() * size_of::<Entry>()) as u64
            );
            for id in ids.iter().copied().chain(0..12_000).chain([u64::MAX - 2]) {
                assert_eq!(index.get(id), expected.get(&id).copied());
            }
        }
    }

    #[test]
    fn live_storage_uses_no_range_heap_or_spare_fallback_capacity() {
        for count in [0, 1, 60, 4096, 65_536] {
            for mode in ["contiguous", "gaps", "reverse"] {
                let ids: Vec<_> = (0..count)
                    .map(|i| match mode {
                        "gaps" => 100 + i as u64 * 2,
                        "reverse" => 100 + (count - 1 - i) as u64,
                        _ => 100 + i as u64,
                    })
                    .collect();
                let mut previous = BTreeMap::new();
                let old = allocation_counter::measure(|| {
                    previous = ids
                        .iter()
                        .copied()
                        .enumerate()
                        .map(|(i, id)| (id, i))
                        .collect();
                });
                let mut index = IdentityIndex::default();
                let new = allocation_counter::measure(|| {
                    index = IdentityIndex::from_ids(ids.iter().copied());
                });
                let fallback = count > 1 && mode != "contiguous";
                assert_eq!(new.count_total, u64::from(fallback));
                assert_eq!(
                    new.bytes_current,
                    if fallback { count * 12 } else { 0 } as i64
                );
                assert_eq!(new.bytes_total, new.bytes_current as u64);
                for id in ids.first().into_iter().chain(ids.last()) {
                    assert_eq!(index.get(*id), previous.get(id).copied());
                }
                println!(
                    "index-storage,{mode},{count},old,{},{},{},{},new,{},{},{},{}",
                    old.count_total,
                    old.bytes_total,
                    old.bytes_current,
                    old.bytes_max,
                    new.count_total,
                    new.bytes_total,
                    new.bytes_current,
                    new.bytes_max,
                );
            }
        }
    }

    #[test]
    fn sparse_edits_and_moved_subtrees_use_exact_affine_runs() {
        for ids in [
            (10..20).chain(100..105).chain(20..30).collect::<Vec<_>>(),
            (u64::MAX - 4..=u64::MAX).chain(1..9).collect(),
            (30..40).chain(10..20).chain(20..30).collect(),
        ] {
            let old: BTreeMap<_, _> = ids
                .iter()
                .copied()
                .enumerate()
                .map(|(i, id)| (id, i))
                .collect();
            let mut index = IdentityIndex::default();
            let allocation = allocation_counter::measure(|| {
                index = IdentityIndex::from_ids(ids.iter().copied())
            });
            let IdentityIndex::Runs(runs) = &index else {
                panic!("expected compact runs")
            };
            assert_eq!(allocation.count_total, 1);
            assert_eq!(allocation.bytes_current, (runs.len() * 16) as i64);
            assert_eq!(allocation.bytes_total, allocation.bytes_current as u64);
            assert!(runs.len() * 16 < ids.len() * 12);
            for id in ids
                .iter()
                .copied()
                .chain(0..200)
                .chain([u64::MAX - 5, u64::MAX])
            {
                assert_eq!(index.get(id), old.get(&id).copied());
            }
        }
    }

    #[test]
    fn chunk_permutations_and_holes_match_the_previous_map() {
        for width in [1, 2, 3, 8, 17] {
            for step in (1..16).step_by(2) {
                let ids: Vec<_> = (0..16)
                    .flat_map(|block| {
                        let start = 100 + ((block * step) % 16) * width * 2;
                        start..start + width
                    })
                    .collect();
                let old: BTreeMap<_, _> = ids
                    .iter()
                    .copied()
                    .enumerate()
                    .map(|(i, id)| (id, i))
                    .collect();
                let index = IdentityIndex::from_ids(ids.iter().copied());
                for identity in 0..100 + 32 * width {
                    assert_eq!(index.get(identity), old.get(&identity).copied());
                }
            }
        }
    }

    #[test]
    fn a_large_replaced_child_run_needs_no_allocation() {
        let ids: Vec<_> = std::iter::once(1).chain(65_538..131_075).collect();
        let mut index = IdentityIndex::default();
        let allocation =
            allocation_counter::measure(|| index = IdentityIndex::from_ids(ids.iter().copied()));
        assert_eq!(allocation.count_total, 0);
        assert_eq!(allocation.bytes_total, 0);
        let IdentityIndex::Hole { shape, .. } = &index else {
            panic!("expected inline hole")
        };
        assert_eq!(shape.len(), ids.len() as u64);
        assert_eq!(shape.cut(), 1);
        assert_eq!(shape.gap(), 65_536);
        assert_eq!(index.required(1), 0);
        assert_eq!(index.get(2), None);
        assert_eq!(index.get(65_537), None);
        assert_eq!(index.required(65_538), 1);
        assert_eq!(index.required(131_074), 65_537);
        assert_eq!(index.get(131_075), None);
    }

    #[test]
    fn dense_reordering_does_not_allocate_an_unprofitable_run_table() {
        for ids in [
            (1..65).rev().collect::<Vec<_>>(),
            (2..66).step_by(2).chain((1..65).step_by(2)).collect(),
            vec![1, 2, 4, 6], // A byte-size tie keeps the entry table.
        ] {
            let index = IdentityIndex::from_ids(ids.iter().copied());
            let old: BTreeMap<_, _> = ids
                .iter()
                .copied()
                .enumerate()
                .map(|(i, id)| (id, i))
                .collect();
            for &id in &ids {
                assert_eq!(index.get(id), old.get(&id).copied());
            }
            if let IdentityIndex::Runs(runs) = index {
                assert!(runs.len() * 16 < ids.len() * 12);
            } else {
                assert!(matches!(index, IdentityIndex::Indexed(_)));
            }
        }
    }

    #[test]
    fn one_positive_hole_is_exact_including_rejected_hole_ids() {
        for first in [0, 1, 100, u64::MAX - 40] {
            for len in 2..=12 {
                for cut in 1..len {
                    for gap in [1, 2, 7, 13] {
                        let ids: Vec<_> = (0..len)
                            .map(|i| first + i + if i >= cut { gap } else { 0 })
                            .collect();
                        let mut index = IdentityIndex::default();
                        let allocation = allocation_counter::measure(|| {
                            index = IdentityIndex::from_ids(ids.iter().copied());
                        });
                        assert!(matches!(index, IdentityIndex::Hole { .. }));
                        assert_eq!(allocation.count_total, 0);
                        for (i, &id) in ids.iter().enumerate() {
                            assert_eq!(index.get(id), Some(i));
                        }
                        for id in first..=first + len + gap {
                            assert_eq!(index.get(id), ids.iter().position(|&v| v == id));
                        }
                        if let Some(before) = first.checked_sub(1) {
                            assert_eq!(index.get(before), None);
                        }
                    }
                }
            }
        }
    }

    #[test]
    fn hole_shape_limits_and_maximum_identity_use_exact_fallbacks() {
        for gap in [GAP_LIMIT - 1, GAP_LIMIT, GAP_LIMIT + 1] {
            for first in [0, u64::MAX - gap - 5] {
                let ids = [
                    first,
                    first + 1,
                    first + 2 + gap,
                    first + 3 + gap,
                    first + 4 + gap,
                ];
                let index = IdentityIndex::from_ids(ids.into_iter());
                assert_eq!(matches!(index, IdentityIndex::Hole { .. }), gap < GAP_LIMIT);
                for (i, id) in ids.into_iter().enumerate() {
                    assert_eq!(index.get(id), Some(i));
                }
                for delta in [2, gap, gap + 1, gap + 5] {
                    assert_eq!(index.get(first + delta), None);
                }
            }
        }
        let ids = [u64::MAX - 9, u64::MAX - 8, u64::MAX - 1, u64::MAX];
        let index = IdentityIndex::from_ids(ids.into_iter());
        assert!(matches!(index, IdentityIndex::Hole { .. }));
        assert_eq!(index.get(u64::MAX), Some(3));
        assert_eq!(index.get(0), None);
        assert_eq!(index.get(u64::MAX - 7), None);
    }

    #[test]
    fn maximum_admitted_count_and_both_cut_extremes_fit_inline() {
        let len = super::super::MAX_NODES;
        for cut in [1, len - 1] {
            let ids: Vec<_> = (0..len)
                .map(|i| 100 + i as u64 + u64::from(i >= cut) * (GAP_LIMIT - 1))
                .collect();
            let mut index = IdentityIndex::default();
            let allocation = allocation_counter::measure(|| {
                index = IdentityIndex::from_ids(ids.iter().copied());
            });
            assert_eq!(allocation.count_total, 0);
            let IdentityIndex::Hole { shape, .. } = &index else {
                panic!("maximum admitted count fits")
            };
            assert_eq!(shape.len(), len as u64);
            assert_eq!(shape.cut(), cut as u64);
            assert_eq!(shape.gap(), GAP_LIMIT - 1);
            for (i, id) in ids.into_iter().enumerate() {
                assert_eq!(index.get(id), Some(i));
            }
        }
    }

    #[test]
    fn descending_or_wrapped_runs_never_become_a_positive_hole() {
        for ids in [
            vec![10, 11, 1, 2],
            vec![u64::MAX - 1, u64::MAX, 0, 1],
            vec![2, 1],
        ] {
            let index = IdentityIndex::from_ids(ids.iter().copied());
            assert!(!matches!(index, IdentityIndex::Hole { .. }));
            let old: BTreeMap<_, _> = ids.iter().enumerate().map(|(i, &id)| (id, i)).collect();
            for id in ids.into_iter().chain([0, 3, 9, 12, u64::MAX]) {
                assert_eq!(index.get(id), old.get(&id).copied());
            }
        }
    }

    #[test]
    #[should_panic(expected = "distinct admitted logical identities")]
    fn overlapping_runs_reject_duplicate_identity_admission() {
        let ids: Vec<_> = (1..20).chain(10..30).collect();
        IdentityIndex::from_ids(ids.iter().copied());
    }

    #[test]
    fn whole_replacement_releases_fallback_and_does_not_revive_ids() {
        let mut index = IdentityIndex::from_ids([10, 1, 20].into_iter());
        assert_eq!(index.required(1), 1);
        index = IdentityIndex::from_ids([30, 31, 32].into_iter());
        assert!(matches!(index, IdentityIndex::Contiguous { .. }));
        assert_eq!(index.get(1), None);
        assert_eq!(index.get(20), None);
        assert_eq!(index.get(31), Some(1));
    }

    #[test]
    #[should_panic(expected = "distinct admitted logical identities")]
    fn duplicate_ids_are_an_internal_admission_error() {
        IdentityIndex::from_ids([7, 2, 7].into_iter());
    }
}
