//! Reclaimable common derived ownership, not a payload-semantic certificate.
//! No automatic policy runs on lookup. A caller explicitly visits at most a
//! supplied number of entries, then separately reaps the accounting ledger.
//! Index/Arc allocations are metadata and remain infallible on global OOM.
use super::*;
use std::{collections::BTreeMap, ops::Bound::{Excluded,Unbounded}, sync::{Arc,Weak,atomic::{AtomicUsize,Ordering}}};

struct Root<T> { payload:T, lease:ResourceLease, pins:AtomicUsize }
trait Owned:Send+Sync { fn unpinned_record(&self)->bool; fn pins(&self)->&AtomicUsize; fn inline_bytes(&self)->usize; }
impl<T:Send+Sync> Owned for Root<T> {
    fn unpinned_record(&self)->bool { Arc::strong_count(&self.lease.0)==1 }
    fn pins(&self)->&AtomicUsize {&self.pins}
    fn inline_bytes(&self)->usize {std::mem::size_of::<Self>()}
}
pub(super) struct OptionalOwners {
    rows:BTreeMap<ResourceId,Arc<dyn Owned>>, cursor:Option<ResourceId>, limit:usize,
}
impl OptionalOwners {
    pub(super) fn new(limit:usize)->Self {Self {rows:BTreeMap::new(),cursor:None,limit}}
}
/// Weak lookup authority. IDs are existing, non-reused ledger record identities;
/// no independent cache key, payload interner, or generation counter is minted.
pub struct OptionalHandle<T> { id:ResourceId, root:Weak<Root<T>> }
impl<T> Clone for OptionalHandle<T> {
    fn clone(&self)->Self {Self {id:self.id,root:self.root.clone()}}
}
impl<T> OptionalHandle<T> {
    pub fn id(&self)->ResourceId {self.id}
    /// Exact Root<T> inline payload; excludes Arc allocation/control metadata.
    pub fn owner_inline_bytes()->usize {std::mem::size_of::<Root<T>>()}
}
/// A real transient ownership pin. Dropping a context cannot invalidate this
/// borrow. Consumers must retain actual leases for published/queued resources.
pub struct OptionalPin<T>(Arc<Root<T>>);
impl<T> OptionalPin<T> {
    pub fn payload(&self)->&T {&self.0.payload}
    pub fn lease(&self)->&ResourceLease {&self.0.lease}
}
impl<T> Drop for OptionalPin<T> {
    fn drop(&mut self) {self.0.pins.fetch_sub(1,Ordering::Release);}
}
#[derive(Clone,Copy,Debug,Default,PartialEq,Eq)]
pub struct OptionalReclaim {pub visited:usize,pub removed:usize}
/// Declared inline metadata only. Private BTree nodes/spare storage and Arc
/// control blocks and retired owner allocations held by surviving Weak handles
/// are excluded, not zero. A zero row count does not mean wrappers are freed.
/// Inspecting this is an explicit O(N)
/// diagnostic scan; it is never invoked by lookup/admission/reclaim.
#[derive(Clone,Copy,Debug,Default,PartialEq,Eq)]
pub struct OptionalMetadata {pub owners:usize,pub orphan_rows:usize,pub pinned_rows:usize,pub root_inline_bytes:usize,pub index_inline_bytes:usize}

impl ResourceContext {
    /// Transfer an already admitted record and its typed payload to common
    /// optional ownership. The payload must not hide additional record leases
    /// if reclamation is desired. This does not prove immutable/renderable T,
    /// nor that T is the root charged by the lease. A trusted typed adapter must
    /// establish the exact same-root/owned-children accounting relationship.
    /// No payload/backing clone is made. Duplicate IDs fail rather than replace.
    pub fn retain_optional<T:Send+Sync+'static>(&mut self,payload:T,lease:ResourceLease)
        ->Result<OptionalHandle<T>,ResourceError>
    {
        self.ledger.owns(&lease)?;
        let id=lease.id();
        if self.optional.rows.contains_key(&id) {return Err(ResourceError::Conflict);}
        if self.optional.rows.len()>=self.optional.limit {return Err(ResourceError::Capacity);}
        let root=Arc::new(Root {payload,lease,pins:AtomicUsize::new(0)});
        let handle=OptionalHandle {id,root:Arc::downgrade(&root)};
        self.optional.rows.insert(id,root);
        Ok(handle)
    }
    /// O(1) weak upgrade after exact accounting-domain validation. Existing pins
    /// and mandatory ResourceLease clones prevent reclaim; no registry scan.
    pub fn pin_optional<T>(&self,handle:&OptionalHandle<T>)->Result<Option<OptionalPin<T>>,ResourceError> {
        if handle.id.owner()!=self.id().owner {return Err(ResourceError::ForeignOwner);}
        Ok(handle.root.upgrade().and_then(|root| {
            let pinned=root.pins.fetch_update(Ordering::AcqRel,Ordering::Acquire,|n| {
                if n>=usize::MAX-1 {None} else {Some(n+1)}
            }).is_ok();
            if pinned {Some(OptionalPin(root))} else {None}
        }))
    }
    /// Exact-owner cleanup for an unused candidate. No sweep, byte credit, or
    /// invalidation of real pins. A later ledger reap accounts final drops.
    pub fn discard_optional<T>(&mut self,handle:&OptionalHandle<T>)->Result<bool,ResourceError> {
        if handle.id.owner()!=self.id().owner {return Err(ResourceError::ForeignOwner);}
        let Some(root)=self.optional.rows.get(&handle.id) else {return Ok(false);};
        if Arc::as_ptr(root) as *const () != handle.root.as_ptr() as *const () {return Err(ResourceError::Conflict);}
        let closed=root.pins().compare_exchange(0,usize::MAX,Ordering::AcqRel,Ordering::Acquire).is_ok();
        let remove=closed && root.unpinned_record();
        if closed && !remove {root.pins().store(0,Ordering::Release);}
        if remove {self.optional.rows.remove(&handle.id);}
        Ok(remove)
    }
    pub fn inspect_optional_metadata(&self)->Result<OptionalMetadata,ResourceError> {
        let mut result=OptionalMetadata {owners:self.optional.rows.len(),index_inline_bytes:std::mem::size_of::<OptionalOwners>()
            .checked_add(self.optional.rows.len().checked_mul(std::mem::size_of::<(ResourceId,Arc<dyn Owned>)>()).ok_or(ResourceError::Overflow)?).ok_or(ResourceError::Overflow)?,..Default::default()};
        for root in self.optional.rows.values() {
            result.orphan_rows+=usize::from(Arc::weak_count(root)==0);
            result.pinned_rows+=usize::from(root.pins().load(Ordering::Acquire)>0);
            result.root_inline_bytes=result.root_inline_bytes.checked_add(root.inline_bytes()).ok_or(ResourceError::Overflow)?;
        }
        Ok(result)
    }
    pub fn optional_owner_count(&self)->usize {self.optional.rows.len()}
    /// Explicit bounded cursor walk. Removing an owner is NOT a claim that bytes
    /// became free: shared backings/other records may still pin the allocation.
    /// Run maintain with its own explicit budget before retrying admission.
    /// No explicit callback/lock API. T destructors run synchronously under this
    /// exclusive borrow and may panic or lock; typed producers must ensure safe,
    /// non-reentrant retirement. Generic Send + Sync is not that certificate.
    pub fn reclaim_optional(&mut self,budget:usize)->OptionalReclaim {
        let mut result=OptionalReclaim::default();
        let visits=budget.min(self.optional.rows.len());
        while result.visited<visits && !self.optional.rows.is_empty() {
            let next=match self.optional.cursor {
                Some(key)=>self.optional.rows.range((Excluded(key),Unbounded)).next(),
                None=>self.optional.rows.iter().next(),
            }.or_else(||self.optional.rows.iter().next());
            let (&id,root)=next.expect("nonempty optional owner index");
            let closed=root.pins().compare_exchange(0,usize::MAX,Ordering::AcqRel,Ordering::Acquire).is_ok();
            let reclaim=closed && root.unpinned_record();
            if closed && !reclaim {root.pins().store(0,Ordering::Release);}
            self.optional.cursor=Some(id);result.visited+=1;
            if reclaim {self.optional.rows.remove(&id);result.removed+=1;}
        }
        result
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn context()->ResourceContext {ResourceContext::new(ResourceLimits {retained_payload_bytes:64,physical_roots:8,resource_records:8,backings_per_resource:2}).unwrap()}
    fn admit(c:&mut ResourceContext,root:Arc<[u8;8]>)->ResourceLease {
        let issuer=crate::change::FrameIssuer::new().unwrap();
        let mut tx=c.ledger.reserve();
        let draft=tx.stage(ResourceKind::Shape,DependencyNode::Global {owner:issuer.owner(),kind:crate::change::GlobalDependency::Pipeline}).unwrap();
        tx.share_arc(draft,root,PayloadLayout::new(8,8,NonZeroU64::MIN,AccountingDomain::Host).unwrap()).unwrap();
        tx.commit().unwrap().pop().unwrap()
    }
    #[test]
    fn optional_pins_and_real_external_leases_prevent_reclaim() {
        let mut c=context();let lease=admit(&mut c,Arc::new([7;8]));let mandatory=lease.clone();
        let h=c.retain_optional(42u32,lease).unwrap();
        assert_eq!(c.reclaim_optional(usize::MAX),OptionalReclaim {visited:1,removed:0});
        drop(mandatory);
        let pin=c.pin_optional(&h).unwrap().unwrap();assert_eq!(*pin.payload(),42);
        assert_eq!(c.reclaim_optional(1).removed,0);
        drop(pin);assert_eq!(c.reclaim_optional(1).removed,1);
        assert!(c.pin_optional(&h).unwrap().is_none());
        assert_eq!(c.stats().retained_payload_bytes,8); // Removing != reaping.
        c.maintain(32).unwrap();assert_eq!(c.stats().retained_payload_bytes,0);
    }
    #[test]
    fn shared_backing_remains_charged_and_foreign_context_is_rejected() {
        let mut c=context();let other=context();let root=Arc::new([2;8]);
        let a=admit(&mut c,root.clone());let mandatory=admit(&mut c,root);assert_eq!(c.stats().retained_payload_bytes,8);
        let h=c.retain_optional((),a).unwrap();
        assert!(matches!(other.pin_optional(&h),Err(ResourceError::ForeignOwner)));
        assert_eq!(c.reclaim_optional(1).removed,1);c.maintain(32).unwrap();
        assert_eq!(c.stats().retained_payload_bytes,8);
        drop(mandatory);c.maintain(32).unwrap();assert_eq!(c.stats().retained_payload_bytes,0);
    }
    #[test]
    fn explicit_visit_budget_and_failed_reservation_preserve_optional_owner() {
        let mut c=context();let lease=admit(&mut c,Arc::new([1;8]));let h=c.retain_optional(17u8,lease).unwrap();
        let before=c.stats();
        {let mut tx=c.ledger.reserve();
         let issuer=crate::change::FrameIssuer::new().unwrap();
         let d=tx.stage(ResourceKind::Shape,DependencyNode::Global {owner:issuer.owner(),kind:crate::change::GlobalDependency::Pipeline}).unwrap();
         assert!(tx.share_arc(d,Arc::new([0u8;128]),PayloadLayout::new(128,128,NonZeroU64::MIN,AccountingDomain::Host).unwrap()).is_err());}
        assert_eq!(c.stats().retained_payload_bytes,before.retained_payload_bytes);
        assert_eq!(c.reclaim_optional(0),OptionalReclaim::default());
        assert_eq!(*c.pin_optional(&h).unwrap().unwrap().payload(),17);
        assert_eq!(c.optional_owner_count(),1);
        assert_eq!(c.reclaim_optional(1),OptionalReclaim {visited:1,removed:1});
    }
    #[test]
    fn context_shutdown_keeps_real_pin_payload_alive() {
        let mut c=context();let lease=admit(&mut c,Arc::new([8;8]));
        let h=c.retain_optional(String::from("queued owner"),lease).unwrap();
        let pin=c.pin_optional(&h).unwrap().unwrap();drop(c);
        assert_eq!(pin.payload(),"queued owner");
        assert_eq!(pin.lease().backing_count(),1);
        drop(pin);assert!(h.root.upgrade().is_none());
    }
    #[test]
    fn two_window_optional_owners_share_one_physical_backing() {
        let mut c=context();let a=crate::change::FrameIssuer::new().unwrap();let b=crate::change::FrameIssuer::new().unwrap();
        let root=Arc::new([3u8;8]);let mut handles=Vec::new();
        for issuer in [&a,&b] {
            let scope=WindowAccounting::Scoped(c.scope(issuer));
            let mut tx=c.window_reservation(scope,issuer).unwrap();
            let d=tx.stage_scene_global(ResourceKind::Shape,crate::change::GlobalDependency::Pipeline).unwrap();
            tx.share_arc(d,root.clone(),PayloadLayout::new(8,8,NonZeroU64::MIN,AccountingDomain::Host).unwrap()).unwrap();
            let lease=tx.commit().unwrap().pop().unwrap();
            handles.push(c.retain_optional(issuer.owner(),lease).unwrap());
        }
        assert_eq!(c.stats().retained_payload_bytes,8);
        assert_ne!(handles[0].id(),handles[1].id());
        let pin=c.pin_optional(&handles[1]).unwrap().unwrap();
        assert_eq!(c.reclaim_optional(2),OptionalReclaim {visited:2,removed:1});
        c.maintain(32).unwrap();assert_eq!(c.stats().retained_payload_bytes,8);
        drop(pin);assert_eq!(c.reclaim_optional(1).removed,1);
        c.maintain(32).unwrap();assert_eq!(c.stats().retained_payload_bytes,0);
    }

    #[test]
    fn exact_unused_candidate_discard_refuses_real_pins_and_needs_explicit_reap() {
        let mut c=context();let mut other=context();let lease=admit(&mut c,Arc::new([6;8]));let external=lease.clone();
        let h=c.retain_optional((),lease).unwrap();
        assert_eq!(other.discard_optional(&h),Err(ResourceError::ForeignOwner));
        assert_eq!(c.discard_optional(&h),Ok(false));drop(external);
        let pin=c.pin_optional(&h).unwrap().unwrap();assert_eq!(c.discard_optional(&h),Ok(false));drop(pin);
        assert_eq!(c.discard_optional(&h),Ok(true));assert_eq!(c.discard_optional(&h),Ok(false));
        assert!(c.pin_optional(&h).unwrap().is_none());assert_eq!(c.stats().retained_payload_bytes,8);
        c.maintain(32).unwrap();assert_eq!(c.stats().retained_payload_bytes,0);
    }

}
