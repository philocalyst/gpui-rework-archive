//! Exact logical identity lookup, rebuilt only with a complete description.
//!
//! Fresh and unchanged preorder descriptions commonly have consecutive IDs in
//! node order. Their index needs no allocation. Other orders retain one sorted
//! entry per live node; no historical identity survives in this index.

pub(super) enum IdentityIndex {
    Contiguous { first: u64, len: usize },
    Indexed(Box<[Entry]>),
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
        if ids
            .clone()
            .enumerate()
            .all(|(index, identity)| identity.checked_sub(first) == Some(index as u64))
        {
            return Self::Contiguous { first, len };
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

    pub(super) fn get(&self, identity: u64) -> Option<usize> {
        match self {
            Self::Contiguous { first, len } => {
                let index = identity.checked_sub(*first)?;
                (index < *len as u64).then_some(index as usize)
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
