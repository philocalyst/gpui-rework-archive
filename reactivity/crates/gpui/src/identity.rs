//! Window-qualified, never-reused retained identities need no capability table.
use serde::Serialize;
use std::{
    num::NonZeroU64,
    sync::atomic::{AtomicU64, Ordering},
};

static NEXT_WINDOW: AtomicU64 = AtomicU64::new(1);

/// A process-local site capability. IDs are checked monotonic counters; restore
/// mints a new window namespace. Inspection serialization cannot restore a live
/// target. Logical membership, rather than a second slot table, checks liveness.
///
/// ```compile_fail,E0277
/// use gpui::Target;
/// let target: Target = serde_json::from_str("{}").unwrap();
/// ```
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash, Serialize)]
pub struct Target {
    window: NonZeroU64,
    identity: NonZeroU64,
}

pub(crate) struct Sites {
    window: NonZeroU64,
}
impl Sites {
    pub(crate) fn new() -> Self {
        let next = NEXT_WINDOW
            .fetch_update(Ordering::Relaxed, Ordering::Relaxed, |value| {
                value.checked_add(1)
            })
            .expect("window namespace exhausted");
        Self {
            window: NonZeroU64::new(next).expect("window namespaces start at one"),
        }
    }
    pub(crate) fn namespace(&self) -> NonZeroU64 {
        self.window
    }
    pub(crate) fn target(&self, identity: u64) -> Target {
        Target {
            window: self.window,
            identity: NonZeroU64::new(identity).expect("retained identities start at one"),
        }
    }
    /// Namespace check only. The owning runtime must also check logical validity
    /// and its current identity map before dispatching through this stamp.
    pub(crate) fn resolve(&self, target: Target) -> Option<u64> {
        (target.window == self.window).then_some(target.identity.get())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn target_stamps_are_pure_and_window_qualified() {
        let sites = Sites::new();
        let target = sites.target(42);
        assert_eq!(sites.target(42), target);
        assert_eq!(sites.resolve(target), Some(42));
        let foreign = Sites::new();
        assert_eq!(foreign.resolve(target), None);
        assert_ne!(foreign.target(42), target);
        assert_eq!(std::mem::size_of::<Sites>(), 8);
        assert_eq!(std::mem::size_of::<Target>(), 16);
        assert_eq!(std::mem::size_of::<Option<Target>>(), 16);
    }
}
