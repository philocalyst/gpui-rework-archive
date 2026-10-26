//! Bounded producer retirement facts, not a payload catalog or text cache.
use super::*;
use change_model::{Artifact,Dependencies,Invalidated,Phase,ResourceReadPatch,SiteId};

pub(super) struct Retirements {removed:BTreeSet<Artifact>,limit:usize,complete:bool}
impl Retirements {
    pub(super) fn new(limit:usize)->Self {Self {removed:BTreeSet::new(),limit,complete:true}}
    /// Called from the existing reconciliation visit before an old text owner
    /// disappears. IDs come from its actual Sites issuer, never a new counter.
    pub(super) fn removed_shape(&mut self,site:SiteId) {
        let key=Artifact {site,phase:Phase::Shape};
        if !self.removed.contains(&key) && self.removed.len()>=self.limit {self.complete=false;return;}
        self.removed.insert(key);
    }
    /// Called in the common closure consumer's EXISTING visit. This is not a
    /// second pass over unrelated dependency nodes.
    pub(super) fn changed_shape(&mut self,site:SiteId) {self.removed_shape(site);}
    /// Apply exact removed facts and already-collected Shape-invalidated owners.
    /// Unknown/full closure or bounded-history overflow conservatively retires
    /// all accepted raw owners. Requested exact inputs may rescue them later.
    pub(super) fn stage(&self,closed:&Invalidated,store:&mut artifacts::ArtifactStore,baseline:&Dependencies,reads:&mut ResourceReadPatch)->bool {
        if !self.complete || !closed.full().is_empty() {
            store.retire_all(|key|reads.observe_one(baseline,key,None));return false;
        }
        for key in self.removed.iter().copied() {
            store.retire_owner(key);reads.observe_one(baseline,key,None);
        }
        true
    }
    /// Exact inline queue/header bytes, not private BTree node capacity/RSS.
    pub(super) fn metadata_payload_bytes(&self)->Option<usize> {
        std::mem::size_of::<Self>().checked_add(self.removed.len().checked_mul(std::mem::size_of::<Artifact>())?)
    }
    /// Only accepted C clears producer facts. Failed preparation keeps them for
    /// the next attempt while ArtifactStore.abort restores accepted payloads.
    pub(super) fn accepted(&mut self) {self.removed.clear();self.complete=true;}
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn removal_history_is_bounded_and_only_success_clears_incomplete_state() {
        let owner=NonZeroU64::new(17).unwrap();let mut history=Retirements::new(1);
        let first=SiteId::from_monotonic(owner,NonZeroU64::MIN);history.removed_shape(first);history.removed_shape(first);
        assert_eq!(history.removed.len(),1);assert!(history.complete);
        history.removed_shape(SiteId::from_monotonic(owner,NonZeroU64::new(2).unwrap()));
        assert_eq!(history.removed.len(),1);assert!(!history.complete);
        history.accepted();assert!(history.removed.is_empty());assert!(history.complete);
    }
}
