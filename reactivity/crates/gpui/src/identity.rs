//! Public site capabilities are independent of layout IDs and preorder offsets.
use serde::Serialize;
use std::{
    collections::BTreeMap,
    num::NonZeroU64,
    sync::atomic::{AtomicU64, Ordering},
};

static NEXT_WINDOW: AtomicU64 = AtomicU64::new(1);

/// A live, window-qualified addressed site. Serialization is for inspection,
/// not restore: constructing a fresh window remints its complete namespace.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash, Serialize)]
pub struct Target {
    window: NonZeroU64,
    slot: u32,
    generation: u32,
}

struct Site {
    identity: Option<u64>,
    generation: u32,
}

pub(crate) struct Sites {
    window: NonZeroU64,
    entries: Vec<Site>,
    free: Vec<u32>,
    by_identity: BTreeMap<u64, u32>,
}

impl Sites {
    pub(crate) fn new() -> Self {
        Self {
            window: NonZeroU64::new(
                NEXT_WINDOW
                    .fetch_update(Ordering::Relaxed, Ordering::Relaxed, |value| {
                        value.checked_add(1)
                    })
                    .expect("window namespace exhausted"),
            )
            .expect("window namespaces start at one"),
            entries: Vec::new(),
            free: Vec::new(),
            by_identity: BTreeMap::new(),
        }
    }

    pub(crate) fn target(&mut self, identity: u64) -> Target {
        let slot = *self.by_identity.entry(identity).or_insert_with(|| {
            if let Some(slot) = self.free.pop() {
                self.entries[slot as usize].identity = Some(identity);
                slot
            } else {
                let slot = u32::try_from(self.entries.len()).expect("target capacity exhausted");
                self.entries.push(Site {
                    identity: Some(identity),
                    generation: 0,
                });
                slot
            }
        });
        Target {
            window: self.window,
            slot,
            generation: self.entries[slot as usize].generation,
        }
    }

    pub(crate) fn resolve(&self, target: Target) -> Option<u64> {
        if target.window != self.window {
            return None;
        }
        let site = self.entries.get(target.slot as usize)?;
        (site.generation == target.generation)
            .then_some(site.identity)
            .flatten()
    }

    pub(crate) fn retain(&mut self, live: &BTreeMap<u64, usize>) {
        self.by_identity.retain(|identity, slot| {
            if live.contains_key(identity) {
                return true;
            }
            let entry = &mut self.entries[*slot as usize];
            entry.identity = None;
            if let Some(generation) = entry.generation.checked_add(1) {
                entry.generation = generation;
                self.free.push(*slot);
            }
            false
        });
    }

    pub(crate) fn revoke(&mut self) {
        self.retain(&BTreeMap::new());
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn sparse_sites_survive_preorder_moves_but_not_removal_or_foreign_windows() {
        let mut sites = Sites::new();
        let a = sites.target(11);
        let b = sites.target(42);
        assert_eq!(sites.target(42), b);
        assert_eq!(sites.entries.len(), 2);
        sites.retain(&BTreeMap::from([(11, 10_000), (42, 3)]));
        assert_eq!(sites.resolve(a), Some(11));
        assert_eq!(sites.resolve(b), Some(42));
        let mut foreign = Sites::new();
        assert_eq!(foreign.resolve(a), None);
        assert_ne!(foreign.target(11), a);
        sites.retain(&BTreeMap::from([(42, 7)]));
        assert_eq!(sites.resolve(a), None);
        let new_a = sites.target(11);
        assert_ne!(a, new_a);
        assert_eq!(sites.resolve(new_a), Some(11));
        sites.revoke();
        assert_eq!(sites.resolve(b), None);
        assert_eq!(sites.resolve(new_a), None);
    }

    #[test]
    fn exhausted_slots_retire_without_reviving_capabilities() {
        let mut sites = Sites::new();
        let original = sites.target(1);
        sites.entries[original.slot as usize].generation = u32::MAX;
        let last = sites.target(1);
        assert_eq!(last.generation, u32::MAX);
        sites.revoke();
        let replacement = sites.target(2);
        assert_ne!(replacement.slot, last.slot);
        assert_eq!(sites.resolve(original), None);
        assert_eq!(sites.resolve(last), None);
        assert_eq!(sites.resolve(replacement), Some(2));
    }

    #[test]
    fn optional_capabilities_do_not_require_a_separate_discriminant() {
        assert_eq!(std::mem::size_of::<Target>(), 16);
        assert_eq!(std::mem::size_of::<Option<Target>>(), 16);
    }
}
