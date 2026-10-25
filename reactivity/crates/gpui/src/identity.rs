//! Window-qualified, never-reused retained identities need no capability table.
use serde::Serialize;
use std::num::NonZeroU64;
use gpui_reactivity_core::change::FrameIssuer;

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
    issuer: FrameIssuer,
}
impl Sites {
    pub(crate) fn new() -> Self {
        Self { issuer: FrameIssuer::new().expect("window namespace exhausted") }
    }
    pub(crate) fn issuer(&self) -> &FrameIssuer { &self.issuer }
    pub(crate) fn issuer_mut(&mut self) -> &mut FrameIssuer { &mut self.issuer }

    pub(crate) fn namespace(&self) -> NonZeroU64 {
        self.issuer.owner()
    }
    pub(crate) fn target(&self, identity: u64) -> Target {
        Target {
            window: self.namespace(),
            identity: NonZeroU64::new(identity).expect("retained identities start at one"),
        }
    }
    /// Namespace check only. The owning runtime must also check logical validity
    /// and its current identity map before dispatching through this stamp.
    pub(crate) fn resolve(&self, target: Target) -> Option<u64> {
        (target.window == self.namespace()).then_some(target.identity.get())
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
        assert_eq!(std::mem::size_of::<Sites>(), std::mem::size_of::<FrameIssuer>());
        eprintln!("CANONICAL_ISSUER_HEADER sites={} prior_sites=8", std::mem::size_of::<Sites>());
        assert_eq!(std::mem::size_of::<Target>(), 16);
        assert_eq!(std::mem::size_of::<Option<Target>>(), 16);
    }
}
