//! Measure/final resolver over the COMMON derived artifact owner. Feature opt-in.
use super::*;
use super::artifacts::{ArtifactStore,ShapeInputs,RetainedInputs};
use gpui_reactivity_core::{change::{Artifact,FrameIssuer},resource::{ResourceContext,WindowAccounting,ResourceError,ResourceId}};
#[cfg(test)]
use gpui_canvas::FontFace;

#[derive(Debug)]
pub(super) enum TextResourceError { Resource(ResourceError), Canvas(gpui_canvas::Error) }
impl From<gpui_canvas::Error> for TextResourceError {fn from(error:gpui_canvas::Error)->Self {Self::Canvas(error)}}
/// Caller records the returned exact ResourceId edge in the PENDING common graph.
/// Effective display/IME text is an immutable source lease, not a special flag.
#[cfg(test)]
pub(super) fn measure(store:&mut ArtifactStore,context:&mut ResourceContext,scope:WindowAccounting,issuer:&FrameIssuer,
    slot:usize,key:Artifact,source:SharedText,size:f32,width:Option<f32>,service:&mut TextShaper<'_>)
    ->Result<(TextMetrics,Option<ResourceId>),TextResourceError>
{
    gpui_canvas::ShapeArtifact::validate_request(&source,size,width)?;
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
#[cfg(test)]
pub(super) fn shape(store:&mut ArtifactStore,context:&mut ResourceContext,scope:WindowAccounting,issuer:&FrameIssuer,
    slot:usize,key:Artifact,source:SharedText,size:f32,width:Option<f32>,service:&mut TextShaper<'_>)
    ->Result<(TextLayout,Option<ResourceId>),TextResourceError>
{
    gpui_canvas::ShapeArtifact::validate_request(&source,size,width)?;
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
    fn accounted_site_declines_unfunded_witness_without_reuse_and_keys_effective_source() {
        let mut context=ResourceContext::new(ResourceLimits {retained_payload_bytes:0,physical_roots:8,resource_records:8,backings_per_resource:8}).unwrap();
        let issuer=FrameIssuer::new().unwrap();let scope=WindowAccounting::Scoped(context.scope(&issuer));let key=key(&issuer);
        let font=face();let mut service=font.shaper();let original=SharedText::from("office");let mut site=TextSite {value:original.clone(),field:None,shaped:None};let mut store=ArtifactStore::new(4);
        let input=WidthMeasureInput {known_dimensions:Size {width:Some(120.),height:None},available_width:AvailableSpace::Definite(120.)};
        let (_,id)=site.measure_accounted(&mut service,14.1,input,original.clone(),&mut store,&mut context,scope,&issuer,1,key).unwrap();assert!(id.is_none());
        let first=site.shaped.as_ref().unwrap().layout.retain_geometry().unwrap();
        let (same,id)=site.shape_accounted(&mut service,14.1,Some(120.),original,&mut store,&mut context,scope,&issuer,1,key).unwrap();
        assert!(id.is_none());assert!(!std::sync::Arc::ptr_eq(&first,&same.retain_geometry().unwrap()));
        assert!(site.shaped.as_ref().unwrap().input.is_none());
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
            let inputs=ShapeInputs::new(a,font.clone(),14.1);assert_eq!(store.reconcile_optional(key,&inputs,&context).unwrap().lease().id(),a_id);
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
        let commit=allocation_counter::measure(||store.commit_touched());assert_eq!(commit.bytes_total,0);
        let one=store.metadata_payload_bytes().unwrap();assert!(one>empty);let before=store.visits();
        let warm=allocation_counter::measure(||for _ in 0..32 {assert!(store.get(100_000,key,&inputs).is_some());store.begin();store.commit_touched();});
        assert_eq!(warm.bytes_total,0);assert_eq!(store.visits().abort,before.abort);assert_eq!(store.visits().commit,before.commit);
        let mut guards=Vec::new();let mut touched_metadata=0i64;
        for local in 1..=32 {
            let next=Artifact {site:SiteId::from_monotonic(issuer.owner(),std::num::NonZeroU64::new(local).unwrap()),phase:Phase::Shape};
            let tx=context.window_reservation(scope,&issuer).unwrap();let (_,resource)=service.measure_resource(&source,14.1,None,tx,next).unwrap();let resource=resource.unwrap();guards.push(resource.clone());
            let moved_inputs=inputs.clone();let cost=allocation_counter::measure(||assert!(store.stage(local as usize,next,moved_inputs,resource)));touched_metadata+=cost.bytes_current;
        }
        let before_abort=store.visits();let abort=allocation_counter::measure(||store.abort());
        assert_eq!(store.visits().abort-before_abort.abort,32);assert!(abort.bytes_current<0);assert!(store.metadata_payload_bytes().unwrap()>=one);
        store.retire_owner(key);
        let retired=allocation_counter::measure(||store.commit_touched());assert_eq!(retired.bytes_total,0);assert!(retired.bytes_current<0);assert_eq!(store.metadata_payload_bytes(),Some(empty));
        let after=store.visits();for _ in 0..32 {store.begin();store.abort();store.commit_touched();}assert_eq!(store.visits(),after);assert!(!after.overflow);
        assert_eq!(stage.bytes_current+commit.bytes_current+touched_metadata+abort.bytes_current+retired.bytes_current,0,"all isolated metadata requests must balance after final retirement");
        eprintln!("CAP_SPARSE_ARTIFACT_METADATA scope=cfg_test_reference_inclusive_isolated_allocator_requests_not_rss empty_inline={} one_inline={} stage_total={} stage_live={} commit_total={} commit_live_delta={} touched_live={} abort_live_delta={} retire_live_delta={} warm_total={} abort_entries={} commit_entries={} exclusions=allocator_internal_overhead,payloads_pinned_outside_measurement,btree_lookup_comparisons",empty,one,stage.bytes_total,stage.bytes_current,commit.bytes_total,commit.bytes_current,touched_metadata,abort.bytes_current,retired.bytes_current,warm.bytes_total,after.abort,after.commit);
        drop(guards);drop(late_keepalive);
    }

    #[test]
    fn touched_owner_commits_match_full_liveness_reference_with_abort_and_retirement() {
        let mut context=context();let issuer=FrameIssuer::new().unwrap();let scope=WindowAccounting::Scoped(context.scope(&issuer));let font=face();let mut service=font.shaper();let a=SharedText::from("accepted A office");let b=SharedText::from("pending B office");let key=key(&issuer);
        let tx=context.window_reservation(scope,&issuer).unwrap();let (_,resource)=service.measure_resource(&a,14.1,None,tx,key).unwrap();let resource=resource.unwrap();let a_id=resource.lease().id();
        let mut reference=ArtifactStore::new(4);let mut touched=ArtifactStore::new(4);
        for store in [&mut reference,&mut touched] {assert!(store.stage(0,key,ShapeInputs::new(a.clone(),font.clone(),14.1),resource.clone()));}
        reference.commit(|_|true);touched.commit_touched();assert_eq!(reference.owned_resource_ids(),touched.owned_resource_ids());
        let before=touched.visits();for _ in 0..8 {touched.begin();touched.commit_touched();}assert_eq!(touched.visits(),before);
        let tx=context.window_reservation(scope,&issuer).unwrap();let (_,resource)=service.measure_resource(&b,14.1,None,tx,key).unwrap();let resource=resource.unwrap();
        for store in [&mut reference,&mut touched] {
            assert!(store.stage(0,key,ShapeInputs::new(b.clone(),font.clone(),14.1),resource.clone()));
            assert_eq!(store.reconcile(0,key,&ShapeInputs::new(a.clone(),font.clone(),14.1)).unwrap().lease().id(),a_id);
        }
        reference.commit(|_|true);touched.commit_touched();assert_eq!(reference.owned_resource_ids(),touched.owned_resource_ids());
        for store in [&mut reference,&mut touched] {assert_eq!(store.retire_owner(key),Some(a_id));store.abort();assert_eq!(store.owned_resource_ids(),[a_id].into_iter().collect());}
        for store in [&mut reference,&mut touched] {assert_eq!(store.retire_owner(key),Some(a_id));}
        reference.commit(|_|false);touched.commit_touched();assert_eq!(reference.owned_resource_ids(),touched.owned_resource_ids());assert!(touched.owned_resource_ids().is_empty());
    }

    #[test]
    fn modeled_touch_reserve_failure_uses_reference_commit_and_preserves_abort() {
        for abort in [false,true] {
            let mut context=context();let issuer=FrameIssuer::new().unwrap();let scope=WindowAccounting::Scoped(context.scope(&issuer));let font=face();let mut service=font.shaper();let key=key(&issuer);let a=SharedText::from("accepted A");let b=SharedText::from("pending B");
            let tx=context.window_reservation(scope,&issuer).unwrap();let (_,resource)=service.measure_resource(&a,14.1,None,tx,key).unwrap();let resource=resource.unwrap();let a_id=resource.lease().id();
            let mut reference=ArtifactStore::new(4);let mut touched=ArtifactStore::new(4);
            for store in [&mut reference,&mut touched] {assert!(store.stage(0,key,ShapeInputs::new(a.clone(),font.clone(),14.1),resource.clone()));store.commit_touched();}
            let tx=context.window_reservation(scope,&issuer).unwrap();let (_,resource)=service.measure_resource(&b,14.1,None,tx,key).unwrap();let resource=resource.unwrap();let b_id=resource.lease().id();
            super::super::artifacts::with_forced_touch_failure(|| {
                for store in [&mut reference,&mut touched] {assert!(store.stage(0,key,ShapeInputs::new(b.clone(),font.clone(),14.1),resource.clone()));}
            });
            if abort {reference.abort();touched.abort();assert_eq!(touched.owned_resource_ids(),[a_id].into_iter().collect());}
            else {reference.commit(|_|true);let before=touched.visits();touched.commit_touched();assert_eq!(touched.visits().full_fallbacks,before.full_fallbacks+1);assert_eq!(touched.owned_resource_ids(),[b_id].into_iter().collect());}
            assert_eq!(reference.owned_resource_ids(),touched.owned_resource_ids());
        }
    }

}

/// Optional source witness is admitted before optional raw capture. Decline
/// selects ordinary lowering, never an output error or a second shaping pass.
fn shape_reclaimable(store:&mut ArtifactStore,context:&mut ResourceContext,scope:WindowAccounting,issuer:&FrameIssuer,
    key:Artifact,source:SharedText,size:f32,width:Option<f32>,service:&mut TextShaper<'_>)
    ->Result<(TextLayout,Option<ResourceId>,Option<RetainedInputs>),TextResourceError>
{
    gpui_canvas::ShapeArtifact::validate_request(&source,size,width)?;
    context.ledger_for(scope,issuer).map_err(TextResourceError::Resource)?;
    if key.site.owner!=issuer.owner() {return Err(TextResourceError::Resource(ResourceError::ForeignOwner));}
    if key.phase!=gpui_reactivity_core::change::Phase::Shape {return Err(TextResourceError::Resource(ResourceError::InvalidLayout));}
    let inputs=ShapeInputs::new(source.clone(),service.font_face().clone(),size);
    if let Some(shape)=store.reconcile_optional(key,&inputs,context) {
        return Ok((shape.shape_interactive(width)?,Some(shape.lease().id()),store.retained_inputs(key)));
    }
    let witness=RetainedInputs::retain(inputs,context,scope,issuer,key);
    let Some(witness)=witness else {
        store.retire_owner(key);
        return Ok((service.shape_interactive(&source,size,width)?,None,None));
    };
    let owned=gpui_canvas::OwnedShapeSource::admit(source.utf8_backing(),context,scope,issuer,key).ok();
    let Some(owned)=owned else {
        store.retire_owner(key);
        return match service.shape_interactive(&source,size,width) {
            Ok(layout)=>Ok((layout,None,Some(witness))),Err(error)=> {witness.discard(context);Err(error.into())}
        };
    };
    let tx=context.window_reservation(scope,issuer).map_err(TextResourceError::Resource)?;
    let (layout,raw)=match service.shape_interactive_owned_resource(owned,size,width,tx,key) {
        Ok(result)=>result,Err(error)=> {witness.discard(context);return Err(error.into());}
    };
    let id=raw.and_then(|raw| {let id=raw.lease().id();store.stage_optional(key,witness.clone(),raw,context).then_some(id)});
    Ok((layout,id,Some(witness)))
}
fn measure_reclaimable(store:&mut ArtifactStore,context:&mut ResourceContext,scope:WindowAccounting,issuer:&FrameIssuer,
    key:Artifact,source:SharedText,size:f32,width:Option<f32>,service:&mut TextShaper<'_>)
    ->Result<(TextMetrics,Option<ResourceId>),TextResourceError>
{
    gpui_canvas::ShapeArtifact::validate_request(&source,size,width)?;
    context.ledger_for(scope,issuer).map_err(TextResourceError::Resource)?;
    if key.site.owner!=issuer.owner() {return Err(TextResourceError::Resource(ResourceError::ForeignOwner));}
    if key.phase!=gpui_reactivity_core::change::Phase::Shape {return Err(TextResourceError::Resource(ResourceError::InvalidLayout));}
    let inputs=ShapeInputs::new(source.clone(),service.font_face().clone(),size);
    if let Some(shape)=store.reconcile_optional(key,&inputs,context) {return Ok((shape.measure(width)?,Some(shape.lease().id())));}
    let Some(witness)=RetainedInputs::retain(inputs,context,scope,issuer,key) else {
        store.retire_owner(key);return Ok((service.measure(&source,size,width)?,None));
    };
    let owned=gpui_canvas::OwnedShapeSource::admit(source.utf8_backing(),context,scope,issuer,key).ok();
    let Some(owned)=owned else {
        store.retire_owner(key);witness.discard(context);return Ok((service.measure(&source,size,width)?,None));
    };
    let tx=context.window_reservation(scope,issuer).map_err(TextResourceError::Resource)?;
    let (metrics,raw)=match service.measure_owned_resource(owned,size,width,tx,key) {
        Ok(result)=>result,Err(error)=> {witness.discard(context);return Err(error.into());}
    };
    let id=raw.and_then(|raw| {let id=raw.lease().id();store.stage_optional(key,witness.clone(),raw,context).then_some(id)});
    if id.is_none() {witness.discard(context);}
    Ok((metrics,id))
}
#[cfg(test)]
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
fn packed_optional_id(store:&mut ArtifactStore,context:&mut ResourceContext,scope:WindowAccounting,issuer:&FrameIssuer,
    key:Artifact,inputs:&ShapeInputs)->Result<Option<ResourceId>,TextResourceError>
{
    context.ledger_for(scope,issuer).map_err(TextResourceError::Resource)?;
    if key.site.owner!=issuer.owner() {return Err(TextResourceError::Resource(ResourceError::ForeignOwner));}
    if key.phase!=gpui_reactivity_core::change::Phase::Shape {return Err(TextResourceError::Resource(ResourceError::InvalidLayout));}
    Ok(store.reconcile_optional(key,inputs,context).map(|shape|shape.lease().id()))
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
        gpui_canvas::ShapeArtifact::validate_request(&source,font_size,width)?;
        if self.shaped.is_none() && input.known_dimensions.width.is_some() {
            let (layout,id)=self.shape_accounted(service,font_size,width,source.clone(),store,context,scope,issuer,slot,key)?;
            return Ok((TextMetrics {width:layout.width,height:layout.height,baseline:layout.baseline},id));
        }
        let inputs=ShapeInputs::new(source.clone(),service.font_face().clone(),font_size);
        if let Some(shape)=&self.shaped
            && shape.width==width.map(f32::to_bits) && shape.layout.font_size()==font_size
            && shape.input.as_ref().is_some_and(|accepted|accepted.matches(context,&inputs))
        {
            let id=packed_optional_id(store,context,scope,issuer,key,&inputs)?;
            return Ok((TextMetrics {width:shape.layout.width,height:shape.layout.height,baseline:shape.layout.baseline},id));
        }
        measure_reclaimable(store,context,scope,issuer,key,source,font_size,width,service)
    }
    pub(super) fn shape_accounted<'n>(&'n mut self,service:&mut TextShaper<'_>,font_size:f32,width:Option<f32>,
        source:SharedText,store:&mut ArtifactStore,context:&mut ResourceContext,scope:WindowAccounting,
        issuer:&FrameIssuer,slot:usize,key:Artifact)->Result<(&'n TextLayout,Option<ResourceId>),TextResourceError>
    {
        let width=width.map(|value|value.max(f32::MIN_POSITIVE));let width_key=width.map(f32::to_bits);
        gpui_canvas::ShapeArtifact::validate_request(&source,font_size,width)?;
        let inputs=ShapeInputs::new(source.clone(),service.font_face().clone(),font_size);
        let hit=self.shaped.as_ref().is_some_and(|shape|shape.width==width_key && shape.layout.font_size()==font_size
            && shape.input.as_ref().is_some_and(|accepted|accepted.matches(context,&inputs)));
        let id=if hit {packed_optional_id(store,context,scope,issuer,key,&inputs)?} else {
            let (layout,id,witness)=shape_reclaimable(store,context,scope,issuer,key,source,font_size,width,service)?;
            self.shaped=Some(Shaped {width:width_key,layout,input:witness});id
        };
        Ok((&self.shaped.as_ref().unwrap().layout,id))
    }
}

#[cfg(test)]
mod reclaimable_tests {
    use super::*;
    use gpui_reactivity_core::{change::{Phase,SiteId},resource::ResourceLimits};
    #[test]
    fn weak_common_owner_reconciles_a_measure_b_final_a_and_aborts_candidate() {
        let font=FontFace::new(include_bytes!("../../../canvas/assets/NotoSans-default.ttf")).unwrap();
        let mut service=font.shaper();let issuer=FrameIssuer::new().unwrap();
        let mut context=ResourceContext::new(ResourceLimits {retained_payload_bytes:8*1024*1024,physical_roots:128,resource_records:128,backings_per_resource:16}).unwrap();
        let scope=WindowAccounting::Scoped(context.scope(&issuer));
        let key=Artifact {site:SiteId::from_monotonic(issuer.owner(),std::num::NonZeroU64::MIN),phase:Phase::Shape};
        let a=SharedText::from("office affinity paragraph A wraps");let b=SharedText::from("replacement B paragraph has different wrapping");
        let mut store=ArtifactStore::new(8);store.begin();
        let (packed,a_id,witness)=shape_reclaimable(&mut store,&mut context,scope,&issuer,key,a.clone(),14.1,Some(80.),&mut service).unwrap();
        let a_id=a_id.unwrap();assert!(witness.is_some());store.commit_touched();
        let wrong=Artifact {phase:Phase::Material,..key};let inputs=ShapeInputs::new(a.clone(),font.clone(),14.1);
        assert!(matches!(packed_optional_id(&mut store,&mut context,scope,&issuer,wrong,&inputs),Err(TextResourceError::Resource(ResourceError::InvalidLayout))));
        for abort in [true,false] {
            store.begin();
            let (_,b_id)=measure_reclaimable(&mut store,&mut context,scope,&issuer,key,b.clone(),14.1,Some(40.),&mut service).unwrap();assert_ne!(b_id,Some(a_id));assert!(b_id.is_some());
            let (again,id,_)=shape_reclaimable(&mut store,&mut context,scope,&issuer,key,a.clone(),14.1,Some(80.),&mut service).unwrap();
            assert_eq!(id,Some(a_id));assert_eq!(again.height.to_bits(),packed.height.to_bits());
            if abort {store.abort();} else {store.commit_touched();}
            assert_eq!(store.owned_resource_ids(),[a_id].into_iter().collect());
        }
        // Explicit pressure expires cache handles without changing packed output.
        assert!(context.reclaim_optional(usize::MAX).removed>=2);
        let input=ShapeInputs::new(a.clone(),font.clone(),14.1);assert!(store.reconcile_optional(key,&input,&context).is_none());
        let (cold,new_id,_)=shape_reclaimable(&mut store,&mut context,scope,&issuer,key,a,14.1,Some(80.),&mut service).unwrap();
        assert_ne!(new_id,Some(a_id));assert_eq!(cold.height.to_bits(),packed.height.to_bits());
    }
    #[test]
    fn actual_source_witness_aliases_charge_one_backing_and_expire_without_strong_keys() {
        let font=FontFace::new(include_bytes!("../../../canvas/assets/NotoSans-default.ttf")).unwrap();let issuer=FrameIssuer::new().unwrap();
        let mut context=ResourceContext::new(ResourceLimits {retained_payload_bytes:8*1024*1024,physical_roots:128,resource_records:128,backings_per_resource:16}).unwrap();
        let scope=WindowAccounting::Scoped(context.scope(&issuer));let source=SharedText::from("whole dynamic source backing");
        let input=ShapeInputs::new(source.clone(),font.clone(),14.1);
        let key=Artifact {site:SiteId::from_monotonic(issuer.owner(),std::num::NonZeroU64::MIN),phase:Phase::Shape};
        let a=RetainedInputs::retain(input.clone(),&mut context,scope,&issuer,key).unwrap();
        let charged=context.stats().retained_payload_bytes;let roots=context.stats().root_records_created;
        let other=Artifact {site:SiteId::from_monotonic(issuer.owner(),std::num::NonZeroU64::new(2).unwrap()),..key};
        let b=RetainedInputs::retain(input.clone(),&mut context,scope,&issuer,other).unwrap();
        assert_eq!(context.stats().retained_payload_bytes,charged);assert_eq!(context.stats().root_records_created,roots);
        assert!(a.matches(&context,&input));assert!(b.matches(&context,&input));
        let distinct=ShapeInputs::new(SharedText::from("whole dynamic source backing"),font,14.1);assert!(!a.matches(&context,&distinct));
        assert_eq!(context.reclaim_optional(usize::MAX).removed,2);assert!(!a.matches(&context,&input));assert!(!b.matches(&context,&input));
        context.maintain(usize::MAX).unwrap();assert_eq!(context.stats().retained_payload_bytes,0);
        // `source` is a mandatory model lease, explicitly outside this subset.
        assert!(!source.is_empty());
    }

    #[test]
    fn optional_owner_metadata_zero_one_many_and_orphan_staging_are_explicit() {
        use gpui_reactivity_core::resource::{OptionalHandle,OptionalPin,PayloadLayout,AccountingDomain,ResourceKind};
        for count in [0usize,1,128] {
            let mut context=ResourceContext::new(ResourceLimits {retained_payload_bytes:8,physical_roots:1,resource_records:128,backings_per_resource:1}).unwrap();
            let issuer=FrameIssuer::new().unwrap();let scope=WindowAccounting::Scoped(context.scope(&issuer));
            let root=std::sync::Arc::new([5u8;8]); // payload pinned OUTSIDE allocation measurement
            let mut handles=Vec::with_capacity(count);
            let admission=allocation_counter::measure(|| {
                for _ in 0..count {
                    let mut tx=context.window_reservation(scope,&issuer).unwrap();
                    let draft=tx.stage_scene_global(ResourceKind::Shape,gpui_reactivity_core::change::GlobalDependency::Pipeline).unwrap();
                    tx.share_arc(draft,root.clone(),PayloadLayout::new(8,8,std::num::NonZeroU64::MIN,AccountingDomain::Host).unwrap()).unwrap();
                    let lease=tx.commit().unwrap().pop().unwrap();handles.push(context.retain_optional(0u8,lease).unwrap());
                }
            });
            let live=context.inspect_optional_metadata().unwrap();assert_eq!(live.owners,count);assert_eq!(live.orphan_rows,0);assert_eq!(live.pinned_rows,0);
            assert_eq!(live.root_inline_bytes,count*OptionalHandle::<u8>::owner_inline_bytes());
            handles.truncate((count+1)/2);let orphan=context.inspect_optional_metadata().unwrap();assert_eq!(orphan.orphan_rows,count-handles.len());
            let retirement=allocation_counter::measure(|| {
                assert_eq!(context.reclaim_optional(usize::MAX).removed,count);
                for _ in 0..4 {context.maintain(usize::MAX).unwrap();}
                assert_eq!(context.optional_owner_count(),0);assert_eq!(context.stats().retained_payload_bytes,0);
            });
            for handle in &handles {assert!(context.pin_optional(handle).unwrap().is_none());}
            let weak_shell_and_empty_index_live=admission.bytes_current+retirement.bytes_current;
            if count>0 {assert!(weak_shell_and_empty_index_live>0,"stale Weak handles retain allocation envelopes");}
            let final_cleanup=allocation_counter::measure(|| {handles.clear();drop(context);});
            assert_eq!(admission.bytes_current+retirement.bytes_current+final_cleanup.bytes_current,0,"isolated ledger+optional metadata requests must balance");
            if count==0 {assert_eq!(admission.bytes_total,0);}
            eprintln!("CAP_OPTIONAL_METADATA scope=isolated_allocator_requests_not_rss owners={} live_root_inline={} live_index_inline={} orphan_rows={} handle_vec_capacity_bytes={} admit_total={} admit_live={} retire_delta={} weak_shell_and_empty_index_live={} final_cleanup_delta={} exclusions=external_payload,handle_vec_allocation,allocator_internal_overhead",count,live.root_inline_bytes,live.index_inline_bytes,orphan.orphan_rows,handles.capacity()*std::mem::size_of::<OptionalHandle<u8>>(),admission.bytes_total,admission.bytes_current,retirement.bytes_current,weak_shell_and_empty_index_live,final_cleanup.bytes_current);
        }
        eprintln!("CAP_OPTIONAL_TEXT_HEADERS scope=sizeof_not_total_memory source_key_payload={} source_owner_inline={} source_handle={} shape_owner_inline={} shape_handle={} pin={} sparse_entry_cfg_test_reference_inclusive={} exclusions=btree_nodes,arc_control_blocks,raw_shape_arrays,mandatory_textsite_and_packed_payloads",std::mem::size_of::<ShapeInputs>(),OptionalHandle::<ShapeInputs>::owner_inline_bytes(),std::mem::size_of::<RetainedInputs>(),OptionalHandle::<std::sync::Arc<gpui_canvas::ShapeResource>>::owner_inline_bytes(),std::mem::size_of::<gpui_canvas::OptionalShape>(),std::mem::size_of::<OptionalPin<std::sync::Arc<gpui_canvas::ShapeResource>>>(),ArtifactStore::entry_inline_bytes());
    }

    #[test]
    fn actual_optional_consumer_uses_same_source_backing_with_distinct_child_lease() {
        let font=FontFace::new(include_bytes!("../../../canvas/assets/NotoSans-default.ttf")).unwrap();let mut service=font.shaper();
        let issuer=FrameIssuer::new().unwrap();let mut context=ResourceContext::new(ResourceLimits {retained_payload_bytes:8*1024*1024,physical_roots:128,resource_records:128,backings_per_resource:16}).unwrap();let scope=WindowAccounting::Scoped(context.scope(&issuer));
        let key=Artifact {site:SiteId::from_monotonic(issuer.owner(),std::num::NonZeroU64::MIN),phase:Phase::Shape};let source=SharedText::from("office actual owned source paragraph wraps");let inputs=ShapeInputs::new(source.clone(),font.clone(),14.1);let mut store=ArtifactStore::new(8);
        let (packed,id,witness)=shape_reclaimable(&mut store,&mut context,scope,&issuer,key,source.clone(),14.1,Some(80.),&mut service).unwrap();assert!(id.is_some());let witness=witness.unwrap();
        let raw=store.reconcile_optional(key,&inputs,&context).unwrap();assert_eq!(raw.source().as_ptr(),source.as_ptr(),"actual consumer must not retain a second String copy");
        assert_eq!(context.reclaim_optional(usize::MAX).removed,1,"source witness can retire while real raw pin remains");assert!(!witness.matches(&context,&inputs));
        assert_eq!(raw.shape_interactive(Some(80.)).unwrap().height.to_bits(),packed.height.to_bits());
        drop(raw);assert_eq!(context.reclaim_optional(usize::MAX).removed,1);for _ in 0..4 {context.maintain(usize::MAX).unwrap();}assert_eq!(context.stats().retained_payload_bytes,0);
        let (repaired,new_id,_)=shape_reclaimable(&mut store,&mut context,scope,&issuer,key,source,14.1,Some(80.),&mut service).unwrap();assert_ne!(new_id,id);assert_eq!(repaired.height.to_bits(),packed.height.to_bits());
    }

}
