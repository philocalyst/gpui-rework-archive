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
pub enum ResourceError { IdentityExhausted, Capacity, Overflow, Conflict, InvalidLayout, Aborted, ForeignOwner, Unaccounted }

static NEXT_OWNER: AtomicU64 = AtomicU64::new(1);
fn allocate_owner(counter: &AtomicU64) -> Result<NonZeroU64, ResourceError> {
    let owner = counter.fetch_update(Ordering::Relaxed, Ordering::Relaxed,
        |value| if value == 0 { None } else { value.checked_add(1) })
        .map_err(|_| ResourceError::IdentityExhausted)?;
    NonZeroU64::new(owner).ok_or(ResourceError::IdentityExhausted)
}
/// Crate-private minting authority, eventually held exclusively by ResourceLedger.
/// Caller-supplied/resettable owner numbers cannot forge or recycle resource IDs.
pub(crate) struct IdentityDomain { owner: NonZeroU64, next: NonZeroU64 }
impl IdentityDomain {
    pub(crate) fn new() -> Result<Self, ResourceError> {
        Ok(Self { owner: allocate_owner(&NEXT_OWNER)?, next: NonZeroU64::MIN })
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
    fn owner_exhaustion_and_zero_are_closed_without_global_test_poisoning() {
        for value in [0,u64::MAX] {
            let counter=AtomicU64::new(value);
            assert_eq!(allocate_owner(&counter),Err(ResourceError::IdentityExhausted));
            assert_eq!(counter.load(Ordering::Relaxed),value);
        }
    }
    #[test]
    fn local_exhaustion_never_wraps_or_advances() {
        let mut domain = IdentityDomain::new().unwrap(); domain.next = NonZeroU64::new(u64::MAX).unwrap();
        assert_eq!(domain.mint(), Err(ResourceError::IdentityExhausted)); assert_eq!(domain.next.get(), u64::MAX);
    }
}

use crate::change::{Artifact, DependencyNode};
use std::{any::{Any, TypeId}, collections::BTreeMap, ops::Bound::{Excluded, Unbounded}, sync::{Arc, Weak}};

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum AccountingDomain { Host, Device }
/// TRUSTED adapter declaration, not proof of exclusive ownership/immutability.
/// Include the root's exclusively owned payload/capacity, exclude shared children
/// registered separately and allocator headers. Immutable while a lease lives.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct PayloadLayout { length: usize, capacity: usize, generation: NonZeroU64, domain: AccountingDomain }
impl PayloadLayout {
    pub fn new(length: usize, capacity: usize, generation: NonZeroU64, domain: AccountingDomain) -> Result<Self, ResourceError> {
        if length > capacity { return Err(ResourceError::InvalidLayout); }
        Ok(Self { length, capacity, generation, domain })
    }
    pub fn length(self) -> usize { self.length }
    pub fn capacity(self) -> usize { self.capacity }
    pub fn generation(self) -> NonZeroU64 { self.generation }
    pub fn domain(self) -> AccountingDomain { self.domain }
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ResourceKind { Font, Shape, TextLayout, PackedGlyphs, Mask, Image, Gradient, MaterialBinding }
impl ResourceKind { fn renderable(self) -> bool { matches!(self, Self::PackedGlyphs | Self::Mask | Self::Image | Self::Gradient | Self::MaterialBinding) } }
#[derive(Clone, Copy, Debug)]
pub struct ResourceLimits {
    pub retained_payload_bytes: usize, pub physical_roots: usize,
    pub resource_records: usize, pub backings_per_resource: usize,
}
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct ResourceStats {
    pub retained_payload_bytes: usize, pub root_weak_entries: usize, pub record_weak_entries: usize,
    pub retained_reference_capacity_bytes: usize,
    pub root_records_created: usize, pub resource_records_created: usize,
    pub root_lookups: usize, pub aliases: usize, pub capacity_growth_requests: usize,
    pub reap_visits: usize, pub roots_reaped: usize, pub records_reaped: usize,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct PhysicalKey { type_id: TypeId, pointer: usize }
struct Backing { key: PhysicalKey, layout: PayloadLayout, _guard: Arc<dyn Any + Send + Sync> }
struct RootEntry { weak: Weak<Backing>, capacity: usize }
struct Record { id: ResourceId, kind: ResourceKind, origin: DependencyNode, backings: Vec<Arc<Backing>> }
struct RecordEntry { weak: Weak<Record>, reference_capacity: usize }
/// Immutable committed record. Clone/borrow is O(1), one Arc operation and NO
/// registry lookup, sweep, payload Vec clone or storage-catalog operation.
#[derive(Clone)]
pub struct ResourceLease(Arc<Record>);
impl ResourceLease {
    pub fn id(&self) -> ResourceId { self.0.id }
    pub fn kind(&self) -> ResourceKind { self.0.kind }
    pub fn origin(&self) -> DependencyNode { self.0.origin }
    /// Legacy spelling, NOT source-compatible for callers requiring Artifact:
    /// the return type is now DependencyNode, permitting genuine global origins.
    pub fn artifact(&self) -> DependencyNode { self.0.origin }
    pub fn backing_count(&self) -> usize { self.0.backings.len() }
    /// Nominal retention classification only, not a certificate of immutable or
    /// font-free contents. Only trusted typed adapters may classify scene data.
    pub fn render_lease(&self) -> Option<RenderLease> { self.0.kind.renderable().then(|| RenderLease(self.clone())) }
}
/// Backend queues retain this until REAL completion/retirement. No numeric fence
/// completion API exists here. NOMINALLY tagged Font/Shape/TextLayout cannot
/// convert; caller-supplied ResourceKind is NOT a payload type/content proof.
/// Trusted typed producer adapters must exclude raw shape/fonts and transitive
/// source leases before binding to a scene. No consumer is adopted by this prototype.
#[derive(Clone)]
pub struct RenderLease(ResourceLease);
impl RenderLease { pub fn id(&self) -> ResourceId { self.0.id() } }

/// Single canonical-model accounting owner; not a backend storage catalog.
/// It must outlive the real backend retirement queue for this accounting scope.
/// Dropping the ledger does not free data still guarded by leases, but ends its
/// admission/accounting scope; creating another ledger is not global RSS proof.
/// Any+Send+Sync is only erased guard ownership, NEVER immutable-content proof.
/// Arc-root identity supports canonical existing SIZED Arc<T> owners only.
/// Arc<[T]>/Arc<str>, by-value or
/// arbitrary buffer projections (inline/subslices/parent overlap) are NOT public
/// API; EcoVec/SharedGlyphs need a separately proven typed heap adapter.
pub struct ResourceLedger {
    domain: IdentityDomain, limits: ResourceLimits, roots: BTreeMap<PhysicalKey, RootEntry>,
    records: BTreeMap<ResourceId, RecordEntry>, stats: ResourceStats,
    root_cursor: Option<PhysicalKey>, record_cursor: Option<ResourceId>, reap_record_next: bool, invariant_error: Option<ResourceError>,
}
impl ResourceLedger {
    pub fn new(limits: ResourceLimits) -> Result<Self, ResourceError> {
        Ok(Self { domain: IdentityDomain::new()?, limits, roots: BTreeMap::new(), records: BTreeMap::new(),
            stats: ResourceStats::default(), root_cursor: None, record_cursor: None, reap_record_next: false, invariant_error: None })
    }
    pub fn stats(&self) -> ResourceStats {
        ResourceStats { root_weak_entries: self.roots.len(), record_weak_entries: self.records.len(), ..self.stats }
    }
    pub fn owns(&self, lease: &ResourceLease) -> Result<(), ResourceError> {
        if lease.id().owner != self.domain.owner() { Err(ResourceError::ForeignOwner) } else { Ok(()) }
    }
    /// No implicit scan on begin, share, commit or a hot width/paint lease hit.
    /// Caller schedules bounded reap at retirement/capacity-pressure boundaries.
    pub fn reserve(&mut self) -> Reservation<'_> {
        Reservation { ledger: self, rows: Vec::new(), new_roots: Vec::new(), failed: None, committed: false }
    }
    fn increment(value: &mut usize) -> Result<(), ResourceError> {
        *value = value.checked_add(1).ok_or(ResourceError::Overflow)?; Ok(())
    }
    fn remove_dead_root(&mut self, key: PhysicalKey) -> Result<(), ResourceError> {
        if self.roots.get(&key).is_some_and(|entry| entry.weak.strong_count() == 0) {
            let capacity = self.roots[&key].capacity;
            let next = self.stats.retained_payload_bytes.checked_sub(capacity).ok_or(ResourceError::Overflow)?;
            Self::increment(&mut self.stats.roots_reaped)?;
            self.roots.remove(&key); self.stats.retained_payload_bytes = next;
        }
        Ok(())
    }
    fn root_step(&mut self) -> Result<bool, ResourceError> {
        let key = self.root_cursor.and_then(|cursor| self.roots.range((Excluded(cursor), Unbounded)).next().map(|(key,_)| *key))
            .or_else(|| self.roots.keys().next().copied());
        let Some(key) = key else { return Ok(false); }; self.root_cursor = Some(key);
        Self::increment(&mut self.stats.reap_visits)?; self.remove_dead_root(key)?; Ok(true)
    }
    fn record_step(&mut self) -> Result<bool, ResourceError> {
        let key = self.record_cursor.and_then(|cursor| self.records.range((Excluded(cursor), Unbounded)).next().map(|(key,_)| *key))
            .or_else(|| self.records.keys().next().copied());
        let Some(key) = key else { return Ok(false); }; self.record_cursor = Some(key);
        Self::increment(&mut self.stats.reap_visits)?;
        if self.records[&key].weak.strong_count() == 0 {
            let bytes = self.records[&key].reference_capacity;
            let next = self.stats.retained_reference_capacity_bytes.checked_sub(bytes).ok_or(ResourceError::Overflow)?;
            Self::increment(&mut self.stats.records_reaped)?; self.records.remove(&key);
            self.stats.retained_reference_capacity_bytes = next;
        }
        Ok(true)
    }
    /// At most budget visited entries, round-robin cursors prevent starvation.
    /// Dead entries may remain conservatively charged until a scheduled visit;
    /// capacity denial never silently scans all roots or grows history unbounded.
    pub fn reap(&mut self, budget: usize) -> Result<usize, ResourceError> {
        if let Some(error) = self.invariant_error { return Err(error); }
        let maximum = self.roots.len().checked_add(self.records.len()).ok_or(ResourceError::Overflow)?;
        let mut visits = 0;
        for _ in 0..budget.min(maximum) {
            let visited = if self.reap_record_next { self.record_step()? || self.root_step()? }
                else { self.root_step()? || self.record_step()? };
            self.reap_record_next = !self.reap_record_next;
            if !visited { break; } visits += 1;
        }
        Ok(visits)
    }
    fn intern<T: Any + Send + Sync>(&mut self, root: Arc<T>, layout: PayloadLayout,
        created: &mut Vec<PhysicalKey>) -> Result<Arc<Backing>, ResourceError> {
        if layout.capacity < std::mem::size_of::<T>() { return Err(ResourceError::InvalidLayout); }
        Self::increment(&mut self.stats.root_lookups)?;
        let key = PhysicalKey { type_id: TypeId::of::<T>(), pointer: Arc::as_ptr(&root) as usize };
        if let Some(backing) = self.roots.get(&key).and_then(|entry| entry.weak.upgrade()) {
            if backing.layout != layout { return Err(ResourceError::Conflict); }
            Self::increment(&mut self.stats.aliases)?; return Ok(backing);
        }
        // One exact expired-key check, not a full collection scan.
        self.remove_dead_root(key)?;
        if self.roots.len() >= self.limits.physical_roots { return Err(ResourceError::Capacity); }
        let charged = self.stats.retained_payload_bytes.checked_add(layout.capacity).ok_or(ResourceError::Overflow)?;
        if charged > self.limits.retained_payload_bytes { return Err(ResourceError::Capacity); }
        let before = created.capacity(); created.try_reserve(1).map_err(|_| ResourceError::Capacity)?;
        if created.capacity() != before { Self::increment(&mut self.stats.capacity_growth_requests)?; }
        Self::increment(&mut self.stats.root_records_created)?;
        let erased: Arc<dyn Any + Send + Sync> = root; // Unsize only, no new data allocation.
        if Arc::as_ptr(&erased) as *const () as usize != key.pointer { return Err(ResourceError::InvalidLayout); }
        let backing = Arc::new(Backing { key, layout, _guard: erased });
        self.roots.insert(key, RootEntry { weak: Arc::downgrade(&backing), capacity: layout.capacity });
        self.stats.retained_payload_bytes = charged; created.push(key); Ok(backing)
    }
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct DraftResource { id: ResourceId, index: usize }
impl DraftResource {
    /// Observation for a PENDING dependency graph only, not accepted storage or
    /// lease authority. Aborted IDs are never recycled; no lookup-by-ID exists.
    pub fn id(self) -> ResourceId { self.id }
}
struct Pending { id: ResourceId, kind: ResourceKind, origin: DependencyNode, backings: Vec<Arc<Backing>> }
/// Only complete commit returns leases. Failed reservation is poisoned; ignoring
/// an add error cannot accidentally publish a partially admitted resource set.
pub struct Reservation<'a> { ledger: &'a mut ResourceLedger, rows: Vec<Pending>, new_roots: Vec<PhysicalKey>, failed: Option<ResourceError>, committed: bool }
impl Reservation<'_> {
    fn live(&self) -> Result<(), ResourceError> { self.failed.or(self.ledger.invariant_error).map_or(Ok(()), Err) }
    fn poison<T>(&mut self, value: Result<T, ResourceError>) -> Result<T, ResourceError> {
        if let Err(error) = &value { self.failed = Some(*error); } value
    }
    pub fn stage(&mut self, kind: ResourceKind, origin: impl Into<DependencyNode>) -> Result<DraftResource, ResourceError> {
        let origin = origin.into();
        let result = (|| {
            self.live()?;
            let total = self.ledger.records.len().checked_add(self.rows.len()).ok_or(ResourceError::Overflow)?;
            if total >= self.ledger.limits.resource_records { return Err(ResourceError::Capacity); }
            let before = self.rows.capacity(); self.rows.try_reserve(1).map_err(|_| ResourceError::Capacity)?;
            if self.rows.capacity() != before { ResourceLedger::increment(&mut self.ledger.stats.capacity_growth_requests)?; }
            let id = self.ledger.domain.mint()?; let index = self.rows.len();
            self.rows.push(Pending { id, kind, origin, backings: Vec::new() }); Ok(DraftResource { id, index })
        })(); self.poison(result)
    }
    pub fn share_arc<T: Any + Send + Sync>(&mut self, draft: DraftResource, root: Arc<T>, layout: PayloadLayout) -> Result<(), ResourceError> {
        let result = (|| {
            self.live()?;
            if self.rows.get(draft.index).is_none_or(|row| row.id != draft.id) { return Err(ResourceError::ForeignOwner); }
            let key = PhysicalKey { type_id: TypeId::of::<T>(), pointer: Arc::as_ptr(&root) as usize };
            if let Some(backing) = self.rows[draft.index].backings.iter().find(|value| value.key == key) {
                return if backing.layout == layout { Ok(()) } else { Err(ResourceError::Conflict) };
            }
            if self.rows[draft.index].backings.len() >= self.ledger.limits.backings_per_resource { return Err(ResourceError::Capacity); }
            let before = self.rows[draft.index].backings.capacity();
            self.rows[draft.index].backings.try_reserve(1).map_err(|_| ResourceError::Capacity)?;
            if self.rows[draft.index].backings.capacity() != before { ResourceLedger::increment(&mut self.ledger.stats.capacity_growth_requests)?; }
            let backing = self.ledger.intern(root, layout, &mut self.new_roots)?;
            self.rows[draft.index].backings.push(backing); Ok(())
        })(); self.poison(result)
    }
    pub fn reserved_payload_bytes(&self) -> usize { self.ledger.stats.retained_payload_bytes }
    pub fn commit(mut self) -> Result<Vec<ResourceLease>, ResourceError> {
        self.live()?;
        // All arithmetic/limits validated before publishing ANY lease/index.
        let records_created = self.ledger.stats.resource_records_created.checked_add(self.rows.len()).ok_or(ResourceError::Overflow)?;
        let mut references = self.ledger.stats.retained_reference_capacity_bytes;
        for row in &self.rows {
            let bytes = row.backings.capacity().checked_mul(std::mem::size_of::<Arc<Backing>>()).ok_or(ResourceError::Overflow)?;
            references = references.checked_add(bytes).ok_or(ResourceError::Overflow)?;
        }
        let mut result = Vec::new(); result.try_reserve_exact(self.rows.len()).map_err(|_| ResourceError::Capacity)?;
        if result.capacity() != 0 { ResourceLedger::increment(&mut self.ledger.stats.capacity_growth_requests)?; }
        for row in self.rows.drain(..) {
            let reference_capacity = row.backings.capacity() * std::mem::size_of::<Arc<Backing>>();
            let record = Arc::new(Record { id: row.id, kind: row.kind, origin: row.origin, backings: row.backings });
            self.ledger.records.insert(record.id, RecordEntry { weak: Arc::downgrade(&record), reference_capacity });
            result.push(ResourceLease(record));
        }
        self.ledger.stats.resource_records_created = records_created;
        self.ledger.stats.retained_reference_capacity_bytes = references;
        self.committed = true; Ok(result)
    }
}
impl Drop for Reservation<'_> {
    fn drop(&mut self) {
        if self.committed { return; }
        self.rows.clear();
        // Exact newly-staged keys only. Never sweep or retire prior live leases.
        for key in &self.new_roots {
            // Overflow is impossible from matching private charges; on invariant
            // failure leave a conservative charge, never wrap/subtract old roots.
            if let Err(error) = self.ledger.remove_dead_root(*key) { self.ledger.invariant_error = Some(error); }
        }
    }
}

#[cfg(test)]
mod ledger_tests {
    use super::*;
    use crate::change::{Phase, SiteId};
    use std::sync::Mutex;
    fn artifact() -> Artifact { Artifact { site: SiteId::from_monotonic(NonZeroU64::new(90).unwrap(), NonZeroU64::MIN), phase: Phase::Shape } }
    fn limits(bytes: usize) -> ResourceLimits { ResourceLimits { retained_payload_bytes: bytes, physical_roots: 32, resource_records: 32, backings_per_resource: 8 } }
    fn layout(bytes: usize) -> PayloadLayout { PayloadLayout::new(bytes, bytes, NonZeroU64::MIN, AccountingDomain::Host).unwrap() }
    fn one<T: Any + Send + Sync>(ledger: &mut ResourceLedger, kind: ResourceKind, data: Arc<T>, bytes: usize) -> ResourceLease {
        let mut tx = ledger.reserve(); let key = tx.stage(kind, artifact()).unwrap(); tx.share_arc(key, data, layout(bytes)).unwrap(); tx.commit().unwrap().pop().unwrap()
    }
    fn drain(ledger: &mut ResourceLedger) { for _ in 0..64 { ledger.reap(4).unwrap(); } }
    #[test]
    fn font_image_gradient_shape_share_physical_children_once() {
        struct Font { bytes: Arc<[u8; 64]> }
        struct Image { bytes: Arc<[u8; 64]> }
        struct Gradient { bytes: Arc<[u8; 64]> }
        struct Shape { font: Arc<Font>, positions: Arc<[u8; 64]> }
        let bytes = Arc::new([7u8;64]); let font = Arc::new(Font { bytes: bytes.clone() });
        let image = Arc::new(Image { bytes: bytes.clone() }); let gradient = Arc::new(Gradient { bytes: bytes.clone() });
        let shape = Arc::new(Shape { font: font.clone(), positions: bytes.clone() });
        let expected = 64 + std::mem::size_of::<Font>() + std::mem::size_of::<Image>() + std::mem::size_of::<Gradient>() + std::mem::size_of::<Shape>();
        let mut ledger = ResourceLedger::new(limits(expected)).unwrap(); let mut tx = ledger.reserve();
        let f = tx.stage(ResourceKind::Font, artifact()).unwrap(); tx.share_arc(f, font.clone(), layout(std::mem::size_of::<Font>())).unwrap(); tx.share_arc(f, font.bytes.clone(), layout(64)).unwrap();
        let i = tx.stage(ResourceKind::Image, artifact()).unwrap(); tx.share_arc(i, image.clone(), layout(std::mem::size_of::<Image>())).unwrap(); tx.share_arc(i, image.bytes.clone(), layout(64)).unwrap();
        let g = tx.stage(ResourceKind::Gradient, artifact()).unwrap(); tx.share_arc(g, gradient.clone(), layout(std::mem::size_of::<Gradient>())).unwrap(); tx.share_arc(g, gradient.bytes.clone(), layout(64)).unwrap();
        let s = tx.stage(ResourceKind::Shape, artifact()).unwrap(); tx.share_arc(s, shape.clone(), layout(std::mem::size_of::<Shape>())).unwrap(); tx.share_arc(s, shape.font.clone(), layout(std::mem::size_of::<Font>())).unwrap(); tx.share_arc(s, shape.positions.clone(), layout(64)).unwrap();
        assert_eq!(tx.reserved_payload_bytes(), expected);
        let leases = tx.commit().unwrap(); assert_eq!(ledger.stats().root_weak_entries, 5);
        assert_eq!(ledger.stats().retained_payload_bytes, expected);
        assert!(leases[0].render_lease().is_none() && leases[3].render_lease().is_none());
        assert!(leases[1].render_lease().is_some() && leases[2].render_lease().is_some());
    }
    #[test]
    fn old_plus_new_overlap_is_reserved_before_commit_and_abort_keeps_old() {
        let mut ledger = ResourceLedger::new(limits(16)).unwrap(); let old = one(&mut ledger, ResourceKind::Image, Arc::new([1u8;8]), 8);
        let before = ledger.stats().retained_payload_bytes;
        { let mut tx = ledger.reserve(); let draft = tx.stage(ResourceKind::Mask, artifact()).unwrap(); tx.share_arc(draft, Arc::new([2u8;8]), layout(8)).unwrap(); assert_eq!(tx.reserved_payload_bytes(), 16); }
        assert_eq!(ledger.stats().retained_payload_bytes, before); ledger.owns(&old).unwrap();
        { let mut tx = ledger.reserve(); let draft = tx.stage(ResourceKind::Image, artifact()).unwrap(); assert_eq!(tx.share_arc(draft, Arc::new([3u8;16]), layout(16)), Err(ResourceError::Capacity)); assert!(matches!(tx.commit(), Err(ResourceError::Capacity))); }
        assert_eq!(ledger.stats().retained_payload_bytes, before); ledger.owns(&old).unwrap();
    }
    #[test]
    fn conflict_domain_length_capacity_generation_never_reuses_a_live_root() {
        let data = Arc::new([0u8;8]); let mut ledger = ResourceLedger::new(limits(128)).unwrap();
        let old = one(&mut ledger, ResourceKind::Font, data.clone(), 8);
        for changed in [PayloadLayout::new(7,8,NonZeroU64::MIN,AccountingDomain::Host).unwrap(),
            PayloadLayout::new(8,16,NonZeroU64::MIN,AccountingDomain::Host).unwrap(),
            PayloadLayout::new(8,8,NonZeroU64::new(2).unwrap(),AccountingDomain::Host).unwrap(),
            PayloadLayout::new(8,8,NonZeroU64::MIN,AccountingDomain::Device).unwrap()] {
            let mut tx = ledger.reserve(); let draft = tx.stage(ResourceKind::Shape, artifact()).unwrap();
            assert_eq!(tx.share_arc(draft, data.clone(), changed), Err(ResourceError::Conflict));
            assert!(matches!(tx.commit(), Err(ResourceError::Conflict)));
        }
        assert_eq!(ledger.stats().retained_payload_bytes,8);ledger.owns(&old).unwrap();
    }
    #[test]
    fn backend_queue_lease_not_frontend_or_ack_controls_retirement() {
        let mut ledger = ResourceLedger::new(limits(32)).unwrap(); let root = Arc::new([4u8;8]); let weak = Arc::downgrade(&root);
        let front = one(&mut ledger, ResourceKind::Mask, root.clone(),8); drop(root);
        let mut actual_backend_queue = vec![front.render_lease().unwrap()]; drop(front); drain(&mut ledger);
        assert_eq!(ledger.stats().retained_payload_bytes,8);assert!(weak.upgrade().is_some());
        // MODEL only: a real backend drops this after real completion, not ACK
        // or caller-fabricated numeric token. Core exposes no fence-number API.
        actual_backend_queue.clear(); drain(&mut ledger);
        assert_eq!(ledger.stats().retained_payload_bytes,0);assert!(weak.upgrade().is_none());
    }
    #[test]
    fn hot_clone_borrow_is_constant_and_reap_visits_are_explicitly_bounded() {
        let mut ledger = ResourceLedger::new(limits(64)).unwrap(); let lease = one(&mut ledger,ResourceKind::PackedGlyphs,Arc::new([0u8;8]),8);
        let before = ledger.stats(); for _ in 0..100 { let copy=lease.clone();assert_eq!(copy.id(),lease.id()); let _=copy.artifact(); }
        assert_eq!(ledger.stats(), before);
        let visits=ledger.reap(1).unwrap();assert!(visits<=1);assert_eq!(ledger.stats().reap_visits-before.reap_visits,visits);
        drop(lease); drain(&mut ledger);assert_eq!(ledger.stats().root_weak_entries,0);assert_eq!(ledger.stats().record_weak_entries,0);
    }
    #[test]
    fn foreign_owner_and_stale_draft_are_not_storage_authority() {
        let mut a=ResourceLedger::new(limits(64)).unwrap();let b=ResourceLedger::new(limits(64)).unwrap();
        let lease=one(&mut a,ResourceKind::Shape,Arc::new([0u8;8]),8);assert_eq!(b.owns(&lease),Err(ResourceError::ForeignOwner));
        let stale={let mut tx=a.reserve();tx.stage(ResourceKind::Font,artifact()).unwrap()};
        let mut tx=a.reserve();let _fresh=tx.stage(ResourceKind::Font,artifact()).unwrap();
        assert_eq!(tx.share_arc(stale,Arc::new([0u8;8]),layout(8)),Err(ResourceError::ForeignOwner));
    }
    #[test]
    fn numeric_overflow_and_identity_exhaustion_are_closed_without_old_mutation() {
        assert_eq!(PayloadLayout::new(2,1,NonZeroU64::MIN,AccountingDomain::Host),Err(ResourceError::InvalidLayout));
        let mut ledger=ResourceLedger::new(limits(usize::MAX)).unwrap();let old=one(&mut ledger,ResourceKind::Shape,Arc::new([0u8;8]),8);
        {let mut tx=ledger.reserve();let draft=tx.stage(ResourceKind::Shape,artifact()).unwrap();assert_eq!(tx.share_arc(draft,Arc::new([1u8;8]),layout(usize::MAX)),Err(ResourceError::Overflow));}
        assert_eq!(ledger.stats().retained_payload_bytes,8);ledger.owns(&old).unwrap();
        ledger.domain.next=NonZeroU64::new(u64::MAX).unwrap();let mut tx=ledger.reserve();assert_eq!(tx.stage(ResourceKind::Image,artifact()),Err(ResourceError::IdentityExhausted));
    }
    #[test]
    fn any_send_sync_guard_is_not_an_immutability_certificate() {
        let root=Arc::new(Mutex::new(1u64));let mut ledger=ResourceLedger::new(limits(128)).unwrap();
        let _lease=one(&mut ledger,ResourceKind::Shape,root.clone(),std::mem::size_of::<Mutex<u64>>());
        *root.lock().unwrap()=2;assert_eq!(*root.lock().unwrap(),2);
        let mislabeled=one(&mut ledger,ResourceKind::Image,root.clone(),std::mem::size_of::<Mutex<u64>>());
        assert!(mislabeled.render_lease().is_some(), "nominal kind is NOT a typed-payload certificate");
        // This intentional counterexample is why semantic immutability belongs
        // to trusted typed producer adapters, not Any/Send/Sync or this ledger.
    }
}

#[cfg(test)]
mod origin_tests {
    use super::*;
    use crate::change::{GlobalDependency, SceneRevision};
    #[test]
    fn unused_material_descriptor_has_real_global_origin_and_external_color_revision() {
        // Model of a sealed Canvas descriptor, NOT the actual Canvas factory.
        // No color/model/font state in the immutable descriptor/root.
        let owner=NonZeroU64::new(300).unwrap();
        let birth=SceneRevision { owner, sequence:NonZeroU64::MIN };
        let descriptor=Arc::new((birth,7u32));
        let origin=DependencyNode::Global { owner, kind:GlobalDependency::Pipeline };
        let limits=ResourceLimits { retained_payload_bytes:256,physical_roots:4,resource_records:4,backings_per_resource:2 };
        let mut ledger=ResourceLedger::new(limits).unwrap();let mut tx=ledger.reserve();
        let draft=tx.stage(ResourceKind::MaterialBinding,origin).unwrap();
        let bytes=std::mem::size_of_val(descriptor.as_ref());
        let layout=PayloadLayout::new(bytes,bytes,NonZeroU64::MIN,AccountingDomain::Host).unwrap();
        tx.share_arc(draft,descriptor.clone(),layout).unwrap();
        let lease=tx.commit().unwrap().pop().unwrap();let id=lease.id();
        assert_eq!(lease.origin(),origin);assert!(lease.render_lease().is_some());
        let external_color_revision=SceneRevision { owner, sequence:NonZeroU64::new(2).unwrap() };
        assert_ne!(external_color_revision,birth);assert_eq!(lease.id(),id);
        assert_eq!(*descriptor,(birth,7)); // Bank replacement needs a NEW descriptor/ID.
    }
}

/// App accounting domain. No implicit budget, global lock, or backend catalog.
/// Admission is serialized by an explicit mutable borrow. The App must keep this
/// accounting scope alive through queued jobs; leases independently keep payloads
/// alive even if that shutdown obligation is violated. This is not a fence proof.
pub struct ResourceContext { ledger: ResourceLedger }
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ResourceContextId { owner: NonZeroU64 }
/// Opaque membership witness, not a payload lease or GPU completion token.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct WindowResourceScope { context: ResourceContextId, window: NonZeroU64 }
/// Legacy constructors remain explicitly unaccounted until a caller opts in.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum WindowAccounting { Unaccounted, Scoped(WindowResourceScope) }
impl ResourceContext {
    pub fn new(limits: ResourceLimits) -> Result<Self, ResourceError> {
        Ok(Self { ledger: ResourceLedger::new(limits)? })
    }
    pub fn id(&self) -> ResourceContextId { ResourceContextId { owner: self.ledger.domain.owner() } }
    pub fn scope(&self, issuer: &crate::change::FrameIssuer) -> WindowResourceScope {
        WindowResourceScope { context: self.id(), window: issuer.owner() }
    }
    /// Checks context/window membership only. The returned trusted ledger can
    /// still stage arbitrary origins; a typed producer must bind its origins to
    /// actual scene/scope authority. This is not an origin validator.
    pub fn ledger_for(&mut self, accounting: WindowAccounting, issuer: &crate::change::FrameIssuer)
        -> Result<&mut ResourceLedger, ResourceError>
    {
        let WindowAccounting::Scoped(scope) = accounting else { return Err(ResourceError::Unaccounted); };
        if scope.context != self.id() || scope.window != issuer.owner() { return Err(ResourceError::ForeignOwner); }
        Ok(&mut self.ledger)
    }
}

#[cfg(test)]
mod context_tests {
    use super::*;
    use crate::change::{FrameIssuer, GlobalDependency};
    fn limits()->ResourceLimits { ResourceLimits { retained_payload_bytes:64,physical_roots:8,resource_records:8,backings_per_resource:2 } }
    fn admit(context:&mut ResourceContext, scope:WindowResourceScope, issuer:&FrameIssuer, root:Arc<[u8;8]>)->ResourceLease {
        let ledger=context.ledger_for(WindowAccounting::Scoped(scope),issuer).unwrap();
        let mut tx=ledger.reserve();
        let origin=DependencyNode::Global { owner:issuer.owner(),kind:GlobalDependency::Pipeline };
        let draft=tx.stage(ResourceKind::Mask,origin).unwrap();
        let layout=PayloadLayout::new(8,8,NonZeroU64::MIN,AccountingDomain::Host).unwrap();
        tx.share_arc(draft,root,layout).unwrap();tx.commit().unwrap().pop().unwrap()
    }
    #[test]
    fn two_windows_share_one_app_payload_charge_without_default_budget() {
        let mut context=ResourceContext::new(limits()).unwrap();
        let a=FrameIssuer::new().unwrap();let b=FrameIssuer::new().unwrap();
        let sa=context.scope(&a);let sb=context.scope(&b);let root=Arc::new([1u8;8]);
        let first=admit(&mut context,sa,&a,root.clone());let second=admit(&mut context,sb,&b,root);
        assert_ne!(first.id(),second.id());assert_eq!(context.ledger.stats().retained_payload_bytes,8);
        assert_eq!(context.ledger.stats().root_records_created,1);
    }
    #[test]
    fn scope_rejects_foreign_context_window_and_explicit_legacy_unaccounted() {
        let mut context=ResourceContext::new(limits()).unwrap();let mut other=ResourceContext::new(limits()).unwrap();
        let a=FrameIssuer::new().unwrap();let b=FrameIssuer::new().unwrap();let scope=context.scope(&a);
        assert!(matches!(other.ledger_for(WindowAccounting::Scoped(scope),&a),Err(ResourceError::ForeignOwner)));
        assert!(matches!(context.ledger_for(WindowAccounting::Scoped(scope),&b),Err(ResourceError::ForeignOwner)));
        assert!(matches!(context.ledger_for(WindowAccounting::Unaccounted,&a),Err(ResourceError::Unaccounted)));
        let old_id=context.id();drop(context);let mut fresh=ResourceContext::new(limits()).unwrap();
        assert_ne!(fresh.id(),old_id);
        assert!(matches!(fresh.ledger_for(WindowAccounting::Scoped(scope),&a),Err(ResourceError::ForeignOwner)));
    }
    #[test]
    fn queued_payload_survives_window_and_context_shutdown_but_accounting_scope_ends() {
        let mut context=ResourceContext::new(limits()).unwrap();let window=FrameIssuer::new().unwrap();
        let scope=context.scope(&window);let root=Arc::new([2u8;8]);let weak=Arc::downgrade(&root);
        let front=admit(&mut context,scope,&window,root);let queued=front.render_lease().unwrap();
        drop(front);drop(window);drop(context);
        assert!(weak.upgrade().is_some()); // Not a type-enforced shutdown/fence protocol.
        drop(queued);assert!(weak.upgrade().is_none());
    }
}

/// Adoption-facing window reservation. Site and scene-global origins are bound
/// to its actual issuer; it cannot stage App-global/group/tile origins.
/// Typed payload adapters remain responsible for exclusive charge and semantics.
pub struct WindowReservation<'a> { inner: Reservation<'a>, owner: NonZeroU64 }
impl ResourceContext {
    pub fn window_reservation(&mut self, accounting: WindowAccounting, issuer: &crate::change::FrameIssuer)
        -> Result<WindowReservation<'_>, ResourceError>
    {
        let owner=issuer.owner();
        let ledger=self.ledger_for(accounting,issuer)?;
        Ok(WindowReservation { inner:ledger.reserve(),owner })
    }

}
impl WindowReservation<'_> {
    /// Genuine WINDOW global, e.g. an unused material-bank descriptor. No owner
    /// argument or fake Site is accepted. This does not mint App-global authority.
    pub fn stage_scene_global(&mut self, kind:ResourceKind, global:crate::change::GlobalDependency)->Result<DraftResource,ResourceError> {
        self.inner.stage(kind,DependencyNode::Global { owner:self.owner,kind:global })
    }
    pub fn stage(&mut self, kind: ResourceKind, artifact: Artifact) -> Result<DraftResource,ResourceError> {
        if artifact.site.owner != self.owner { return self.inner.poison(Err(ResourceError::ForeignOwner)); }
        self.inner.stage(kind,artifact)
    }
    pub fn share_arc<T:Any+Send+Sync>(&mut self, draft:DraftResource, root:Arc<T>, layout:PayloadLayout)->Result<(),ResourceError> {
        self.inner.share_arc(draft,root,layout)
    }
    pub fn commit(self)->Result<Vec<ResourceLease>,ResourceError> { self.inner.commit() }
}
// App-global scoped staging is deliberately unavailable: resource-domain IDs
// and scene/window issuer IDs must not enter the same untagged Global owner.
// A tagged-domain graph binding must qualify before exposing that route.

#[cfg(test)]
mod scoped_tests {
    use super::*;
    use crate::change::{FrameIssuer,Phase,SiteId};
    fn limits()->ResourceLimits { ResourceLimits { retained_payload_bytes:64,physical_roots:8,resource_records:8,backings_per_resource:2 } }
    fn artifact(window:&FrameIssuer)->Artifact { Artifact { site:SiteId::from_monotonic(window.owner(),NonZeroU64::MIN),phase:Phase::Shape } }
    fn layout()->PayloadLayout { PayloadLayout::new(8,8,NonZeroU64::MIN,AccountingDomain::Host).unwrap() }
    #[test]
    fn scoped_admission_rejects_foreign_artifact_and_poisons_whole_pending_transaction() {
        let mut context=ResourceContext::new(limits()).unwrap();let a=FrameIssuer::new().unwrap();let b=FrameIssuer::new().unwrap();
        let scope=context.scope(&a);let mut tx=context.window_reservation(WindowAccounting::Scoped(scope),&a).unwrap();
        let accepted=tx.stage(ResourceKind::Shape,artifact(&a)).unwrap();tx.share_arc(accepted,Arc::new([1u8;8]),layout()).unwrap();
        assert_eq!(tx.stage(ResourceKind::Shape,artifact(&b)),Err(ResourceError::ForeignOwner));
        assert!(matches!(tx.commit(),Err(ResourceError::ForeignOwner)));
        assert_eq!(context.ledger.stats().retained_payload_bytes,0);
        assert_eq!(context.ledger.stats().resource_records_created,0);
    }
    #[test]
    fn distinct_window_scoped_admission_shares_backing_without_sharing_origin() {
        let mut context=ResourceContext::new(limits()).unwrap();let a=FrameIssuer::new().unwrap();let b=FrameIssuer::new().unwrap();
        let root=Arc::new([2u8;8]);let mut live=Vec::new();
        for issuer in [&a,&b] {
            let scope=context.scope(issuer);
            let mut tx=context.window_reservation(WindowAccounting::Scoped(scope),issuer).unwrap();
            let draft=tx.stage(ResourceKind::Mask,artifact(issuer)).unwrap();tx.share_arc(draft,root.clone(),layout()).unwrap();
            live.push(tx.commit().unwrap().pop().unwrap());
        }
        assert_ne!(live[0].origin(),live[1].origin());assert_ne!(live[0].id(),live[1].id());
        assert_eq!(context.ledger.stats().retained_payload_bytes,8);assert_eq!(context.ledger.stats().root_records_created,1);
    }

    #[test]
    fn scene_global_uses_actual_issuer_and_rejects_foreign_scope_before_staging() {
        let mut context=ResourceContext::new(limits()).unwrap();let a=FrameIssuer::new().unwrap();let b=FrameIssuer::new().unwrap();
        let scope=context.scope(&a);
        assert!(matches!(context.window_reservation(WindowAccounting::Scoped(scope),&b),Err(ResourceError::ForeignOwner)));
        let mut tx=context.window_reservation(WindowAccounting::Scoped(scope),&a).unwrap();
        let draft=tx.stage_scene_global(ResourceKind::MaterialBinding,crate::change::GlobalDependency::Pipeline).unwrap();
        tx.share_arc(draft,Arc::new([3u8;8]),layout()).unwrap();let global=tx.commit().unwrap().pop().unwrap();
        assert_eq!(global.origin(),DependencyNode::Global { owner:a.owner(),kind:crate::change::GlobalDependency::Pipeline });
        assert_ne!(global.origin(),DependencyNode::Global { owner:b.owner(),kind:crate::change::GlobalDependency::Pipeline });
    }

}
