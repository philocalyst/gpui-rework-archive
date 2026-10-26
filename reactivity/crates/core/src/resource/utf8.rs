//! Sealed ArcStr1.2 full-root adapter. No arbitrary buffer projection, pointer
//! arithmetic, unsafe header reads, semantic source interner or mutable identity.
use super::*;

/// A whole immutable ArcStr, never Substr/inline storage/a caller-described slice.
/// This type's private field and concrete adapter establish the projection.
#[derive(Clone)]
pub struct Utf8Backing { root:arcstr::ArcStr }
impl Utf8Backing {
    pub fn new(root:arcstr::ArcStr)->Self {Self {root}}
    pub fn as_str(&self)->&str {self.root.as_str()}
    pub fn is_static(&self)->bool {arcstr::ArcStr::is_static(&self.root)}
    /// Exact requested ArcStr1.2 allocation: payload length + two usize fields,
    /// alignment8. Not allocator size-class/RSS; static/empty/leakedstatic has no
    /// lease-retained heap charge. No header is read or raw address subtracted.
    pub fn retained_allocation_bytes(&self)->Result<usize,ResourceError> {
        if self.is_static() {return Ok(0);}
        self.requested_dynamic_bytes()
    }
    fn requested_dynamic_bytes(&self)->Result<usize,ResourceError> {
        self.as_str().len().checked_add(2usize.checked_mul(std::mem::size_of::<usize>()).ok_or(ResourceError::Overflow)?)
            .ok_or(ResourceError::Overflow)
    }
    fn key(&self)->PhysicalKey {PhysicalKey {type_id:TypeId::of::<Self>(),pointer:self.as_str().as_ptr() as usize}}
    fn layout(&self)->Result<PayloadLayout,ResourceError> {
        // The full immutable allocation size cannot change. If another ArcStr
        // clone makes this root immortal AFTER the admission status check, keep
        // the original conservative charge until retirement, not a false layout
        // conflict from a changed lifetime flag.
        let bytes=self.requested_dynamic_bytes()?;
        PayloadLayout::new(bytes,bytes,NonZeroU64::MIN,AccountingDomain::Host)
    }
}
impl ResourceLedger {
    fn intern_utf8(&mut self,root:Utf8Backing,created:&mut Vec<PhysicalKey>)->Result<Arc<Backing>,ResourceError> {
        let key=root.key();let layout=root.layout()?;
        Self::increment(&mut self.stats.root_lookups)?;
        // The concrete ArcStr is proven full heap-backed/move-stable. This owned
        // clone pins its root during lookup; a live alias needs NO new wrapper.
        if let Some(backing)=self.roots.get(&key).and_then(|entry|entry.weak.upgrade()) {
            if backing.layout!=layout {return Err(ResourceError::Conflict);}
            Self::increment(&mut self.stats.aliases)?;return Ok(backing);
        }
        self.remove_dead_root(key)?;
        if self.roots.len()>=self.limits.physical_roots {return Err(ResourceError::Capacity);}
        let charged=self.stats.retained_payload_bytes.checked_add(layout.capacity).ok_or(ResourceError::Overflow)?;
        if charged>self.limits.retained_payload_bytes {return Err(ResourceError::Capacity);}
        let before=created.capacity();created.try_reserve(1).map_err(|_|ResourceError::Capacity)?;
        if created.capacity()!=before {Self::increment(&mut self.stats.capacity_growth_requests)?;}
        Self::increment(&mut self.stats.root_records_created)?;
        Self::increment(&mut self.stats.utf8_guard_wrappers_created)?;
        let guard=Arc::new(root);
        // Observe/check full allocation identity AFTER stable owned storage.
        // Only this sealed typed adapter may differ from the Arc guard address.
        if guard.key()!=key || guard.layout()?!=layout {return Err(ResourceError::InvalidLayout);}
        let erased:Arc<dyn Any+Send+Sync>=guard;
        let backing=Arc::new(Backing {key,layout,_guard:erased});
        self.roots.insert(key,RootEntry {weak:Arc::downgrade(&backing),capacity:layout.capacity});
        self.stats.retained_payload_bytes=charged;created.push(key);Ok(backing)
    }
}
impl Reservation<'_> {
    /// Only Utf8Source records may use this concrete source adapter. Nominal
    /// kinds elsewhere remain trusted bookkeeping, not a renderability proof.
    pub fn share_utf8(&mut self,draft:DraftResource,root:Utf8Backing)->Result<(),ResourceError> {
        let result=(|| {
            self.live()?;
            let row=self.rows.get(draft.index).filter(|row|row.id==draft.id).ok_or(ResourceError::ForeignOwner)?;
            if row.kind!=ResourceKind::Utf8Source {return Err(ResourceError::InvalidLayout);}
            if root.is_static() {return Ok(());} // Immutable program/immortal data, no extra guard needed.
            let key=root.key();let layout=root.layout()?;
            if let Some(backing)=row.backings.iter().find(|backing|backing.key==key) {
                return if backing.layout==layout {Ok(())} else {Err(ResourceError::Conflict)};
            }
            if row.backings.len()>=self.ledger.limits.backings_per_resource {return Err(ResourceError::Capacity);}
            let before=self.rows[draft.index].backings.capacity();
            self.rows[draft.index].backings.try_reserve(1).map_err(|_|ResourceError::Capacity)?;
            if self.rows[draft.index].backings.capacity()!=before {ResourceLedger::increment(&mut self.ledger.stats.capacity_growth_requests)?;}
            let backing=self.ledger.intern_utf8(root,&mut self.new_roots)?;
            self.rows[draft.index].backings.push(backing);Ok(())
        })();self.poison(result)
    }
}
impl WindowReservation<'_> {
    pub fn share_utf8(&mut self,draft:DraftResource,root:Utf8Backing)->Result<(),ResourceError> {self.inner.share_utf8(draft,root)}
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::change::{Artifact,FrameIssuer,Phase,SiteId};
    fn limits(bytes:usize)->ResourceLimits {ResourceLimits {retained_payload_bytes:bytes,physical_roots:8,resource_records:16,backings_per_resource:2}}
    fn artifact(issuer:&FrameIssuer,local:u64)->Artifact {Artifact {site:SiteId::from_monotonic(issuer.owner(),NonZeroU64::new(local).unwrap()),phase:Phase::Shape}}
    fn admit(context:&mut ResourceContext,issuer:&FrameIssuer,local:u64,root:Utf8Backing)->ResourceLease {
        let scope=WindowAccounting::Scoped(context.scope(issuer));let mut tx=context.window_reservation(scope,issuer).unwrap();
        let draft=tx.stage(ResourceKind::Utf8Source,artifact(issuer,local)).unwrap();tx.share_utf8(draft,root).unwrap();tx.commit().unwrap().pop().unwrap()
    }
    #[test]
    fn static_and_empty_have_zero_retained_heap_and_no_guard_wrapper() {
        let issuer=FrameIssuer::new().unwrap();let mut cap=limits(0);cap.physical_roots=0;cap.backings_per_resource=0;
        let mut context=ResourceContext::new(cap).unwrap();
        for (index,root) in [Utf8Backing::new(arcstr::literal!("static α")),Utf8Backing::new(arcstr::ArcStr::new())].into_iter().enumerate() {
            assert!(root.is_static());assert_eq!(root.retained_allocation_bytes(),Ok(0));
            let lease=admit(&mut context,&issuer,index as u64+1,root);assert_eq!(lease.backing_count(),0);assert!(lease.render_lease().is_none());
        }
        assert_eq!(context.stats().retained_payload_bytes,0);assert_eq!(context.stats().root_records_created,0);assert_eq!(context.stats().utf8_guard_wrappers_created,0);
    }
    #[test]
    fn aliases_share_exact_dynamic_allocation_but_not_semantic_resource_records() {
        let issuer=FrameIssuer::new().unwrap();let root=Utf8Backing::new(arcstr::ArcStr::from("dynamic α"));assert!(!root.is_static());
        let requested=root.as_str().len()+2*std::mem::size_of::<usize>();assert_eq!(root.retained_allocation_bytes(),Ok(requested));let key=root.key();
        let mut context=ResourceContext::new(limits(requested)).unwrap();let a=admit(&mut context,&issuer,1,root.clone());let before=context.stats();
        let b=admit(&mut context,&issuer,2,root.clone());assert_ne!(a.id(),b.id());
        assert_eq!(context.stats().retained_payload_bytes,requested);assert_eq!(context.stats().root_records_created,1);assert_eq!(context.stats().utf8_guard_wrappers_created,1);
        assert_eq!(context.stats().aliases,before.aliases+1);assert_eq!(context.stats().reap_visits,before.reap_visits);
        let weak=context.ledger.roots[&key].weak.clone();drop(root);drop(a);
        let guard=weak.upgrade().unwrap();assert_eq!(guard._guard.as_ref().downcast_ref::<Utf8Backing>().unwrap().as_str(),"dynamic α");drop(guard);
        assert!(context.maintain(8).unwrap()<=8);assert_eq!(context.stats().retained_payload_bytes,requested);
        drop(b);for _ in 0..4 {context.maintain(8).unwrap();}
        assert!(weak.upgrade().is_none());assert_eq!(context.stats().retained_payload_bytes,0);
    }
    #[test]
    fn equal_bytes_in_distinct_roots_are_not_aliased_and_shared_windows_charge_once() {
        let a=Utf8Backing::new(arcstr::ArcStr::from("same bytes"));let b=Utf8Backing::new(arcstr::ArcStr::from("same bytes"));
        assert_eq!(a.as_str(),b.as_str());assert_ne!(a.key(),b.key());let bytes=a.retained_allocation_bytes().unwrap();
        let wa=FrameIssuer::new().unwrap();let wb=FrameIssuer::new().unwrap();let mut context=ResourceContext::new(limits(bytes*2)).unwrap();
        let first=admit(&mut context,&wa,1,a.clone());let second=admit(&mut context,&wb,1,a);let third=admit(&mut context,&wa,2,b);
        assert_ne!(first.origin(),second.origin());assert_ne!(first.id(),second.id());assert_ne!(first.id(),third.id());
        assert_eq!(context.stats().retained_payload_bytes,bytes*2);assert_eq!(context.stats().root_records_created,2);assert_eq!(context.stats().utf8_guard_wrappers_created,2);
    }
    #[test]
    fn overlap_capacity_abort_and_wrong_kind_fail_closed_without_old_lease_mutation() {
        let issuer=FrameIssuer::new().unwrap();let old=Utf8Backing::new(arcstr::ArcStr::from("old source"));let bytes=old.retained_allocation_bytes().unwrap();let mut context=ResourceContext::new(limits(bytes)).unwrap();
        let accepted=admit(&mut context,&issuer,1,old);let before=context.stats();let scope=WindowAccounting::Scoped(context.scope(&issuer));
        {let mut tx=context.window_reservation(scope,&issuer).unwrap();let draft=tx.stage(ResourceKind::Utf8Source,artifact(&issuer,2)).unwrap();assert_eq!(tx.share_utf8(draft,Utf8Backing::new(arcstr::ArcStr::from("new source"))),Err(ResourceError::Capacity));assert!(matches!(tx.commit(),Err(ResourceError::Capacity)));}
        assert_eq!(context.stats().retained_payload_bytes,before.retained_payload_bytes);assert_eq!(context.stats().utf8_guard_wrappers_created,before.utf8_guard_wrappers_created);context.ledger.owns(&accepted).unwrap();
        {let mut tx=context.window_reservation(scope,&issuer).unwrap();let draft=tx.stage(ResourceKind::Image,artifact(&issuer,3)).unwrap();assert_eq!(tx.share_utf8(draft,Utf8Backing::new(arcstr::literal!("static"))),Err(ResourceError::InvalidLayout));}
        assert_eq!(context.stats().retained_payload_bytes,bytes);
    }
    #[test]
    fn successful_staged_new_root_abort_releases_only_new_charge_and_guard() {
        let issuer=FrameIssuer::new().unwrap();let a=Utf8Backing::new(arcstr::ArcStr::from("same size A"));let b=Utf8Backing::new(arcstr::ArcStr::from("same size B"));
        let bytes=a.retained_allocation_bytes().unwrap();assert_eq!(b.retained_allocation_bytes(),Ok(bytes));let b_key=b.key();
        let mut context=ResourceContext::new(limits(bytes*2)).unwrap();let accepted=admit(&mut context,&issuer,1,a);let scope=WindowAccounting::Scoped(context.scope(&issuer));
        {let mut tx=context.window_reservation(scope,&issuer).unwrap();let draft=tx.stage(ResourceKind::Utf8Source,artifact(&issuer,2)).unwrap();tx.share_utf8(draft,b).unwrap();assert_eq!(tx.inner.ledger.stats().retained_payload_bytes,bytes*2);}
        assert_eq!(context.stats().retained_payload_bytes,bytes);assert!(!context.ledger.roots.contains_key(&b_key));context.ledger.owns(&accepted).unwrap();
        assert_eq!(context.stats().utf8_guard_wrappers_created,2); // cumulative creation, not live-wrapper count.
    }

}
