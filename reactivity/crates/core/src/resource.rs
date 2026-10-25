//! Canonical resource identity/retained-payload accounting boundary.
//! IDs are immutable logical identity, not a storage slot, content certificate,
//! scene/ACK revision, or proof of a GPU fence completing.
use std::{num::NonZeroU64, sync::atomic::{AtomicU64, Ordering}};

/// Opaque owner-scoped monotonic identity. Only this module mints values;
/// storage catalogs/handles remain backend-owned and separate.
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct ResourceId { owner: NonZeroU64, local: NonZeroU64 }
impl ResourceId {
    pub const fn owner(self) -> NonZeroU64 { self.owner }
    pub const fn local(self) -> NonZeroU64 { self.local }
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ResourceError { IdentityExhausted, Capacity, Overflow, Conflict, InvalidLayout, Aborted, ForeignOwner }

static NEXT_OWNER: AtomicU64 = AtomicU64::new(1);
/// Crate-private minting authority, eventually held exclusively by ResourceLedger.
/// Caller-supplied/resettable owner numbers cannot forge or recycle resource IDs.
pub(crate) struct IdentityDomain { owner: NonZeroU64, next: NonZeroU64 }
impl IdentityDomain {
    pub(crate) fn new() -> Result<Self, ResourceError> {
        let owner = NEXT_OWNER.fetch_update(Ordering::Relaxed, Ordering::Relaxed, |value| value.checked_add(1))
            .map_err(|_| ResourceError::IdentityExhausted)?;
        Ok(Self { owner: NonZeroU64::new(owner).expect("owner counter starts nonzero"), next: NonZeroU64::MIN })
    }
    pub(crate) fn owner(&self) -> NonZeroU64 { self.owner }
    pub(crate) fn mint(&mut self) -> Result<ResourceId, ResourceError> {
        let next = self.next.checked_add(1).ok_or(ResourceError::IdentityExhausted)?;
        let id = ResourceId { owner: self.owner, local: self.next }; self.next = next; Ok(id)
    }
}
#[cfg(test)]
mod identity_tests {
    use super::*;
    #[test]
    fn independent_domains_and_retirement_never_reuse_identity() {
        let mut a = IdentityDomain::new().unwrap(); let mut b = IdentityDomain::new().unwrap();
        let old = a.mint().unwrap(); let next = a.mint().unwrap(); let other = b.mint().unwrap();
        assert_eq!(old.local(), other.local()); assert_ne!(old.owner(), other.owner()); assert_ne!(old, next);
    }
    #[test]
    fn local_exhaustion_never_wraps_or_advances() {
        let mut domain = IdentityDomain::new().unwrap(); domain.next = NonZeroU64::new(u64::MAX).unwrap();
        assert_eq!(domain.mint(), Err(ResourceError::IdentityExhausted)); assert_eq!(domain.next.get(), u64::MAX);
    }
}
