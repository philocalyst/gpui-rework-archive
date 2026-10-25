//! Measure/final resolver over the COMMON derived artifact owner. Feature opt-in.
use super::*;
use super::artifacts::{ArtifactStore,ShapeInputs};
use gpui_reactivity_core::{change::{Artifact,FrameIssuer},resource::{ResourceContext,WindowAccounting,ResourceError,ResourceId}};
#[cfg(test)]
use gpui_canvas::text::FontFace;

#[derive(Debug)]
pub(super) enum TextResourceError { Resource(ResourceError), Canvas(gpui_canvas::Error) }
impl From<gpui_canvas::Error> for TextResourceError {fn from(error:gpui_canvas::Error)->Self {Self::Canvas(error)}}
/// Caller records the returned exact ResourceId edge in the PENDING common graph.
/// Effective display/IME text is an immutable source lease, not a special flag.
pub(super) fn measure(store:&mut ArtifactStore,context:&mut ResourceContext,scope:WindowAccounting,issuer:&FrameIssuer,
    slot:usize,key:Artifact,source:SharedText,size:f32,width:Option<f32>,service:&mut TextShaper<'_>)
    ->Result<(TextMetrics,Option<ResourceId>),TextResourceError>
{
    gpui_canvas::text::ShapeArtifact::validate_request(&source,size,width)?;
    context.ledger_for(scope,issuer).map_err(TextResourceError::Resource)?;
    if key.site.owner!=issuer.owner() {return Err(TextResourceError::Resource(ResourceError::ForeignOwner));}
    if key.phase!=gpui_reactivity_core::change::Phase::Shape {return Err(TextResourceError::Resource(ResourceError::InvalidLayout));}
    let inputs=ShapeInputs::new(source.clone(),service.font_face().clone(),size);
    if let Some(shape)=store.reconcile(slot,key,&inputs) {
        context.ledger_for(scope,issuer).and_then(|ledger|ledger.owns(shape.lease())).map_err(TextResourceError::Resource)?;
        return Ok((shape.measure(width)?,Some(shape.lease().id())));
    }
    let tx=context.window_reservation(scope,issuer).map_err(TextResourceError::Resource)?;
    let (metrics,resource)=service.measure_resource(&source,size,width,tx,key)?;
    let id=resource.and_then(|resource| {let id=resource.lease().id();store.stage(slot,key,inputs,resource).then_some(id)});
    Ok((metrics,id))
}
pub(super) fn shape(store:&mut ArtifactStore,context:&mut ResourceContext,scope:WindowAccounting,issuer:&FrameIssuer,
    slot:usize,key:Artifact,source:SharedText,size:f32,width:Option<f32>,service:&mut TextShaper<'_>)
    ->Result<(TextLayout,Option<ResourceId>),TextResourceError>
{
    gpui_canvas::text::ShapeArtifact::validate_request(&source,size,width)?;
    context.ledger_for(scope,issuer).map_err(TextResourceError::Resource)?;
    if key.site.owner!=issuer.owner() {return Err(TextResourceError::Resource(ResourceError::ForeignOwner));}
    if key.phase!=gpui_reactivity_core::change::Phase::Shape {return Err(TextResourceError::Resource(ResourceError::InvalidLayout));}
    let inputs=ShapeInputs::new(source.clone(),service.font_face().clone(),size);
    if let Some(shape)=store.reconcile(slot,key,&inputs) {
        context.ledger_for(scope,issuer).and_then(|ledger|ledger.owns(shape.lease())).map_err(TextResourceError::Resource)?;
        return Ok((shape.shape_interactive(width)?,Some(shape.lease().id())));
    }
    let tx=context.window_reservation(scope,issuer).map_err(TextResourceError::Resource)?;
    let (layout,resource)=service.shape_interactive_resource(&source,size,width,tx,key)?;
    let id=resource.and_then(|resource| {let id=resource.lease().id();store.stage(slot,key,inputs,resource).then_some(id)});
    Ok((layout,id))
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui_reactivity_core::{change::{Phase,SiteId},resource::ResourceLimits};
    fn context()->ResourceContext {ResourceContext::new(ResourceLimits {retained_payload_bytes:32*1024*1024,physical_roots:128,resource_records:64,backings_per_resource:16}).unwrap()}
    fn key(issuer:&FrameIssuer)->Artifact {Artifact {site:SiteId::from_monotonic(issuer.owner(),std::num::NonZeroU64::MIN),phase:Phase::Shape}}
    fn face()->FontFace {FontFace::new(include_bytes!("../../../canvas/assets/NotoSans-default.ttf")).unwrap()}
    #[test]
    fn common_shape_artifact_is_shared_by_measure_final_and_width_but_not_foreign_font_domain() {
        let mut context=context();let issuer=FrameIssuer::new().unwrap();let scope=WindowAccounting::Scoped(context.scope(&issuer));
        let font=face();let mut service=font.shaper();let mut store=ArtifactStore::new(8);store.begin();
        let source=SharedText::from("office affinity paragraph must genuinely wrap repeatedly at narrow widths.");let key=key(&issuer);
        let (measured,id)=measure(&mut store,&mut context,scope,&issuer,3,key,source.clone(),14.1,Some(120.),&mut service).unwrap();let id=id.unwrap();
        let (a,final_id)=shape(&mut store,&mut context,scope,&issuer,3,key,source.clone(),14.1,Some(120.),&mut service).unwrap();
        let (b,narrow_id)=shape(&mut store,&mut context,scope,&issuer,3,key,source.clone(),14.1,Some(40.),&mut service).unwrap();
        assert_eq!(final_id,Some(id));assert_eq!(narrow_id,Some(id));assert_eq!(measured.height.to_bits(),a.height.to_bits());
        assert_ne!(a.height.to_bits(),b.height.to_bits());assert!(store.metadata_payload_bytes().unwrap()>0);
        store.commit(|actual|actual==key);store.begin();
        let foreign=face();assert!(!foreign.same_face(&font));let mut foreign_service=foreign.shaper();
        let (_,foreign_id)=shape(&mut store,&mut context,scope,&issuer,3,key,source,14.1,Some(120.),&mut foreign_service).unwrap();
        assert_ne!(foreign_id,Some(id)); // Equal bytes do not merge foreign face domains.
    }
    #[test]
    fn failed_pending_reflow_keeps_accepted_artifact_and_rejects_reused_dense_slot_identity() {
        let mut context=context();let issuer=FrameIssuer::new().unwrap();let scope=WindowAccounting::Scoped(context.scope(&issuer));
        let font=face();let mut service=font.shaper();let mut store=ArtifactStore::new(8);let key=key(&issuer);
        let original=SharedText::from("original office paragraph wraps.");store.begin();
        let (_,id)=shape(&mut store,&mut context,scope,&issuer,2,key,original.clone(),14.1,Some(40.),&mut service).unwrap();let id=id.unwrap();
        store.commit(|actual|actual==key);store.begin();
        let changed=SharedText::from("replacement source has a different resource dependency.");
        let (_,pending)=measure(&mut store,&mut context,scope,&issuer,2,key,changed.clone(),14.1,Some(120.),&mut service).unwrap();assert_ne!(pending,Some(id));
        assert!(matches!(shape(&mut store,&mut context,scope,&issuer,2,key,changed,14.1,Some(f32::NAN),&mut service),Err(TextResourceError::Canvas(gpui_canvas::Error::InvalidWidth))));
        store.abort();let inputs=ShapeInputs::new(original,font.clone(),14.1);
        assert_eq!(store.lease(2,key,&inputs).unwrap().id(),id);
        let another=Artifact {site:SiteId::from_monotonic(issuer.owner(),std::num::NonZeroU64::new(2).unwrap()),phase:Phase::Shape};
        assert!(store.get(2,another,&inputs).is_none());
    }
    #[test]
    fn cached_shape_from_another_context_cannot_bypass_current_admission() {
        let mut a=context();let mut b=context();let issuer=FrameIssuer::new().unwrap();let sa=WindowAccounting::Scoped(a.scope(&issuer));let sb=WindowAccounting::Scoped(b.scope(&issuer));
        let font=face();let mut service=font.shaper();let source=SharedText::from("office resource domain witness");let key=key(&issuer);let mut store=ArtifactStore::new(4);
        let (_,id)=measure(&mut store,&mut a,sa,&issuer,1,key,source.clone(),14.1,Some(120.),&mut service).unwrap();assert!(id.is_some());
        assert!(matches!(shape(&mut store,&mut b,sb,&issuer,1,key,source,14.1,Some(120.),&mut service),Err(TextResourceError::Resource(ResourceError::ForeignOwner))));
    }

    #[test]
    fn changed_source_quota_decline_retires_old_raw_artifact_only_after_success() {
        let font_bytes=include_bytes!("../../../canvas/assets/NotoSans-default.ttf");
        let mut context=ResourceContext::new(ResourceLimits {retained_payload_bytes:font_bytes.len()+64*1024,physical_roots:128,resource_records:64,backings_per_resource:16}).unwrap();
        let issuer=FrameIssuer::new().unwrap();let scope=WindowAccounting::Scoped(context.scope(&issuer));let font=face();let mut service=font.shaper();let key=key(&issuer);let mut store=ArtifactStore::new(4);
        let original=SharedText::from("office");let original_inputs=ShapeInputs::new(original.clone(),font.clone(),14.1);
        let (_,id)=measure(&mut store,&mut context,scope,&issuer,1,key,original,14.1,None,&mut service).unwrap();assert!(id.is_some(),"small resource fixture must admit");
        store.commit(|actual|actual==key);store.begin();
        let large=SharedText::from("office ".repeat(4000));
        let (metrics,declined)=measure(&mut store,&mut context,scope,&issuer,1,key,large,14.1,None,&mut service).unwrap();
        assert!(metrics.width>0.);assert!(declined.is_none(),"large raw shape must exceed remaining capacity");
        store.abort();assert_eq!(store.lease(1,key,&original_inputs).unwrap().id(),id.unwrap());
        store.begin();let large=SharedText::from("office ".repeat(4000));
        let (_,declined)=measure(&mut store,&mut context,scope,&issuer,1,key,large,14.1,None,&mut service).unwrap();assert!(declined.is_none());
        store.commit(|actual|actual==key);assert!(store.lease(1,key,&original_inputs).is_none());
    }

    #[test]
    fn accounted_site_preserves_exact_packed_cache_when_retention_declines_and_keys_effective_source() {
        let mut context=ResourceContext::new(ResourceLimits {retained_payload_bytes:0,physical_roots:8,resource_records:8,backings_per_resource:8}).unwrap();
        let issuer=FrameIssuer::new().unwrap();let scope=WindowAccounting::Scoped(context.scope(&issuer));let key=key(&issuer);
        let font=face();let mut service=font.shaper();let original=SharedText::from("office");let mut site=TextSite {value:original.clone(),field:None,shaped:None};let mut store=ArtifactStore::new(4);
        let input=WidthMeasureInput {known_dimensions:Size {width:Some(120.),height:None},available_width:AvailableSpace::Definite(120.)};
        let (_,id)=site.measure_accounted(&mut service,14.1,input,original.clone(),&mut store,&mut context,scope,&issuer,1,key).unwrap();assert!(id.is_none());
        let first=site.shaped.as_ref().unwrap().layout.retain_geometry().unwrap();
        let (same,id)=site.shape_accounted(&mut service,14.1,Some(120.),original,&mut store,&mut context,scope,&issuer,1,key).unwrap();
        assert!(id.is_none());assert!(std::sync::Arc::ptr_eq(&first,&same.retain_geometry().unwrap()));
        let changed=SharedText::from("a genuinely changed source paragraph long enough to occupy multiple wrapped lines at this width");
        let (different,_)=site.shape_accounted(&mut service,14.1,Some(120.),changed.clone(),&mut store,&mut context,scope,&issuer,1,key).unwrap();
        let accepted=different.retain_geometry().unwrap();assert!(!std::sync::Arc::ptr_eq(&first,&accepted));
        assert!(matches!(site.shape_accounted(&mut service,0.,Some(120.),changed,&mut store,&mut context,scope,&issuer,1,key),Err(TextResourceError::Canvas(gpui_canvas::Error::InvalidFontSize))));
        assert!(std::sync::Arc::ptr_eq(&accepted,&site.shaped.as_ref().unwrap().layout.retain_geometry().unwrap()));
    }

    #[test]
    fn final_packed_a_reconciles_measure_b_without_retiring_valid_accepted_a() {
        for abort in [false,true] {
            let mut context=context();let issuer=FrameIssuer::new().unwrap();let scope=WindowAccounting::Scoped(context.scope(&issuer));let key=key(&issuer);
            let font=face();let mut service=font.shaper();let a=SharedText::from("accepted office paragraph A");let b=SharedText::from("measured different paragraph B office");
            let mut site=TextSite {value:a.clone(),field:None,shaped:None};let mut store=ArtifactStore::new(4);
            let (_,a_id)=site.shape_accounted(&mut service,14.1,Some(120.),a.clone(),&mut store,&mut context,scope,&issuer,1,key).unwrap();let a_id=a_id.unwrap();
            store.commit(|actual|actual==key);store.begin();
            let input=WidthMeasureInput {known_dimensions:Size::NONE,available_width:AvailableSpace::MaxContent};
            let (_,b_id)=site.measure_accounted(&mut service,14.1,input,b,&mut store,&mut context,scope,&issuer,1,key).unwrap();let b_id=b_id.unwrap();assert_ne!(a_id,b_id);
            assert_eq!(store.owned_resource_ids(),[a_id,b_id].into_iter().collect());
            let (_,final_id)=site.shape_accounted(&mut service,14.1,Some(120.),a.clone(),&mut store,&mut context,scope,&issuer,1,key).unwrap();
            assert_eq!(final_id,Some(a_id)); // Exact ID for pending graph read replacement.
            assert_eq!(store.owned_resource_ids(),[a_id].into_iter().collect());
            if abort {store.abort();} else {store.commit(|actual|actual==key);}
            let inputs=ShapeInputs::new(a,font.clone(),14.1);assert_eq!(store.lease(1,key,&inputs).unwrap().id(),a_id);
        }
    }



    #[test]
    fn sparse_late_admission_churn_abort_and_warm_turns_price_only_live_and_touched_metadata() {
        let mut context=context();let issuer=FrameIssuer::new().unwrap();let scope=WindowAccounting::Scoped(context.scope(&issuer));let font=face();let mut service=font.shaper();
        let source=SharedText::from("office sparse artifact");let inputs=ShapeInputs::new(source.clone(),font.clone(),14.1);let mut store=ArtifactStore::new(64);
        let empty=store.metadata_payload_bytes().unwrap();
        // Model of10000 optional resource-None outcomes; actual Canvas quota
        // decline/no-rerun and later short admission have separate real tests.
        let misses=allocation_counter::measure(|| {
            for local in 1..=10_000 {let key=Artifact {site:SiteId::from_monotonic(issuer.owner(),std::num::NonZeroU64::new(local).unwrap()),phase:Phase::Shape};assert!(store.reconcile(local as usize,key,&inputs).is_none());}
        });
        assert_eq!(misses.bytes_total,0);assert_eq!(store.metadata_payload_bytes(),Some(empty));
        let key=Artifact {site:SiteId::from_monotonic(issuer.owner(),std::num::NonZeroU64::new(100_001).unwrap()),phase:Phase::Shape};
        let tx=context.window_reservation(scope,&issuer).unwrap();let (_,resource)=service.measure_resource(&source,14.1,None,tx,key).unwrap();let resource=resource.unwrap();let late_keepalive=resource.clone();
        let moved_inputs=inputs.clone();let stage=allocation_counter::measure(||assert!(store.stage(100_000,key,moved_inputs,resource)));
        assert!(stage.bytes_current>0);assert!(stage.bytes_total<64*1024,"one sparse key must not allocate100k full Entry rows");
        let commit=allocation_counter::measure(||store.commit(|_|true));
        let one=store.metadata_payload_bytes().unwrap();assert!(one>empty);let before=store.visits();
        let warm=allocation_counter::measure(||for _ in 0..32 {assert!(store.get(100_000,key,&inputs).is_some());store.begin();store.commit(|_|true);});
        assert_eq!(warm.bytes_total,0);assert_eq!(store.visits().abort,before.abort);assert_eq!(store.visits().commit-before.commit,32);
        let mut guards=Vec::new();let mut touched_metadata=0i64;
        for local in 1..=32 {
            let next=Artifact {site:SiteId::from_monotonic(issuer.owner(),std::num::NonZeroU64::new(local).unwrap()),phase:Phase::Shape};
            let tx=context.window_reservation(scope,&issuer).unwrap();let (_,resource)=service.measure_resource(&source,14.1,None,tx,next).unwrap();let resource=resource.unwrap();guards.push(resource.clone());
            let moved_inputs=inputs.clone();let cost=allocation_counter::measure(||assert!(store.stage(local as usize,next,moved_inputs,resource)));touched_metadata+=cost.bytes_current;
        }
        let before_abort=store.visits();let abort=allocation_counter::measure(||store.abort());
        assert_eq!(store.visits().abort-before_abort.abort,32);assert_eq!(abort.bytes_current,-touched_metadata);assert_eq!(store.metadata_payload_bytes(),Some(one));
        let retired=allocation_counter::measure(||store.commit(|_|false));assert!(retired.bytes_current<0);assert_eq!(store.metadata_payload_bytes(),Some(empty));
        let after=store.visits();for _ in 0..32 {store.begin();store.abort();store.commit(|_|false);}assert_eq!(store.visits(),after);assert!(!after.overflow);
        eprintln!("CAP_SPARSE_ARTIFACT_METADATA scope=isolated_allocator_requests_not_rss empty_inline={} one_inline={} stage_total={} stage_live={} commit_total={} commit_live_delta={} touched_live={} abort_live_delta={} retire_live_delta={} warm_total={} abort_entries={} commit_entries={} exclusions=allocator_internal_overhead,payloads_pinned_outside_measurement,btree_lookup_comparisons",empty,one,stage.bytes_total,stage.bytes_current,commit.bytes_total,commit.bytes_current,touched_metadata,abort.bytes_current,retired.bytes_current,warm.bytes_total,after.abort,after.commit);
        drop(guards);drop(late_keepalive);
    }

}

fn packed_resource_id(store:&mut ArtifactStore,context:&mut ResourceContext,scope:WindowAccounting,issuer:&FrameIssuer,
    slot:usize,key:Artifact,inputs:&ShapeInputs)->Result<Option<ResourceId>,TextResourceError>
{
    let ledger=context.ledger_for(scope,issuer).map_err(TextResourceError::Resource)?;
    if key.site.owner!=issuer.owner() {return Err(TextResourceError::Resource(ResourceError::ForeignOwner));}
    if key.phase!=gpui_reactivity_core::change::Phase::Shape {return Err(TextResourceError::Resource(ResourceError::InvalidLayout));}
    if let Some(shape)=store.reconcile(slot,key,inputs) {
        ledger.owns(shape.lease()).map_err(TextResourceError::Resource)?;
        Ok(Some(shape.lease().id()))
    } else {Ok(None)}
}
impl TextSite {
    /// Same known-width first-shape shortcut and one-width packed cache as the
    /// ordinary path. Raw source artifacts resolve BOTH measure and final work.
    pub(super) fn measure_accounted(&mut self,service:&mut TextShaper<'_>,font_size:f32,input:WidthMeasureInput,
        source:SharedText,store:&mut ArtifactStore,context:&mut ResourceContext,scope:WindowAccounting,
        issuer:&FrameIssuer,slot:usize,key:Artifact)->Result<(TextMetrics,Option<ResourceId>),TextResourceError>
    {
        let width=input.known_dimensions.width.or(match input.available_width {
            AvailableSpace::Definite(width)=>Some(width),AvailableSpace::MinContent=>Some(f32::MIN_POSITIVE),AvailableSpace::MaxContent=>None,
        });
        let width=width.map(|value|value.max(f32::MIN_POSITIVE));
        gpui_canvas::text::ShapeArtifact::validate_request(&source,font_size,width)?;
        if self.shaped.is_none() && input.known_dimensions.width.is_some() {
            self.shape_accounted(service,font_size,width,source.clone(),store,context,scope,issuer,slot,key)?;
        }
        let inputs=ShapeInputs::new(source.clone(),service.font_face().clone(),font_size);
        if let Some(shape)=&self.shaped
            && shape.width==width.map(f32::to_bits) && shape.layout.font_size()==font_size
            && shape.input.as_ref().is_some_and(|accepted|accepted.matches(&inputs))
        {
            let id=packed_resource_id(store,context,scope,issuer,slot,key,&inputs)?;
            return Ok((TextMetrics {width:shape.layout.width,height:shape.layout.height,baseline:shape.layout.baseline},id));
        }
        measure(store,context,scope,issuer,slot,key,source,font_size,width,service)
    }
    pub(super) fn shape_accounted<'n>(&'n mut self,service:&mut TextShaper<'_>,font_size:f32,width:Option<f32>,
        source:SharedText,store:&mut ArtifactStore,context:&mut ResourceContext,scope:WindowAccounting,
        issuer:&FrameIssuer,slot:usize,key:Artifact)->Result<(&'n TextLayout,Option<ResourceId>),TextResourceError>
    {
        let width=width.map(|value|value.max(f32::MIN_POSITIVE));let width_key=width.map(f32::to_bits);
        gpui_canvas::text::ShapeArtifact::validate_request(&source,font_size,width)?;
        let inputs=ShapeInputs::new(source.clone(),service.font_face().clone(),font_size);
        let hit=self.shaped.as_ref().is_some_and(|shape|shape.width==width_key && shape.layout.font_size()==font_size
            && shape.input.as_ref().is_some_and(|accepted|accepted.matches(&inputs)));
        let id=if hit {packed_resource_id(store,context,scope,issuer,slot,key,&inputs)?} else {
            let (layout,id)=shape(store,context,scope,issuer,slot,key,source,font_size,width,service)?;
            self.shaped=Some(Shaped {width:width_key,layout,input:Some(inputs)});id
        };
        Ok((&self.shaped.as_ref().unwrap().layout,id))
    }
}
