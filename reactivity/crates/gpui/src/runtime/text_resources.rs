//! Measure/final resolver over the COMMON derived artifact owner. Feature opt-in.
use super::*;
use super::artifacts::{ArtifactStore,ShapeInputs};
use gpui_reactivity_core::{change::{Artifact,FrameIssuer},resource::{ResourceContext,WindowAccounting,ResourceError,ResourceId}};
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
    if let Some(shape)=store.get(slot,key,&inputs) {
        context.ledger_for(scope,issuer).and_then(|ledger|ledger.owns(shape.lease())).map_err(TextResourceError::Resource)?;
        return Ok((shape.measure(width)?,Some(shape.lease().id())));
    }
    store.retire(slot,key);
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
    if let Some(shape)=store.get(slot,key,&inputs) {
        context.ledger_for(scope,issuer).and_then(|ledger|ledger.owns(shape.lease())).map_err(TextResourceError::Resource)?;
        return Ok((shape.shape_interactive(width)?,Some(shape.lease().id())));
    }
    store.retire(slot,key);
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
        assert_ne!(a.height.to_bits(),b.height.to_bits());assert!(store.index_capacity_bytes().unwrap()>0);
        store.commit(|slot,actual|slot==3&&actual==key);store.begin();
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
        store.commit(|slot,actual|slot==2&&actual==key);store.begin();
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
        store.commit(|slot,actual|slot==1&&actual==key);store.begin();
        let large=SharedText::from("office ".repeat(4000));
        let (metrics,declined)=measure(&mut store,&mut context,scope,&issuer,1,key,large,14.1,None,&mut service).unwrap();
        assert!(metrics.width>0.);assert!(declined.is_none(),"large raw shape must exceed remaining capacity");
        store.abort();assert_eq!(store.lease(1,key,&original_inputs).unwrap().id(),id.unwrap());
        store.begin();let large=SharedText::from("office ".repeat(4000));
        let (_,declined)=measure(&mut store,&mut context,scope,&issuer,1,key,large,14.1,None,&mut service).unwrap();assert!(declined.is_none());
        store.commit(|slot,actual|slot==1&&actual==key);assert!(store.lease(1,key,&original_inputs).is_none());
    }

}
