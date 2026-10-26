//! Experimental live-source artifact. Never part of a published Canvas scene.
use super::*;
use gpui_reactivity_core::{change::Artifact,resource::{ResourceLease,ResourceKind,WindowReservation,PayloadLayout,AccountingDomain,DraftResource}};
use std::{mem::size_of,num::NonZeroU64};

/// Whole immutable source plus a DISTINCT child accounting record. Private
/// construction derives text from this backing only, never a separately supplied
/// &str. It does not contain the parent raw record and cannot self-pin that owner.
pub struct OwnedShapeSource { backing:gpui_reactivity_core::resource::Utf8Backing, lease:ResourceLease }
impl OwnedShapeSource {
    pub fn admit(backing:gpui_reactivity_core::resource::Utf8Backing,context:&mut gpui_reactivity_core::resource::ResourceContext,
        scope:gpui_reactivity_core::resource::WindowAccounting,issuer:&gpui_reactivity_core::change::FrameIssuer,artifact:Artifact)
        ->Result<Self,gpui_reactivity_core::resource::ResourceError>
    {
        if artifact.phase!=gpui_reactivity_core::change::Phase::Shape {return Err(gpui_reactivity_core::resource::ResourceError::InvalidLayout);}
        let mut tx=context.window_reservation(scope,issuer)?;
        let draft=tx.stage(ResourceKind::Utf8Source,artifact)?;tx.share_utf8(draft,backing.clone())?;
        let lease=tx.commit()?.pop().ok_or(gpui_reactivity_core::resource::ResourceError::Aborted)?;
        Ok(Self {backing,lease})
    }
    pub fn as_str(&self)->&str {self.backing.as_str()}
}
enum SourceStorage { Copied(String), Shared(OwnedShapeSource) }
impl std::ops::Deref for SourceStorage {
    type Target=str;
    fn deref(&self)->&str {match self {Self::Copied(source)=>source,Self::Shared(source)=>source.as_str()}}
}
impl SourceStorage {
    fn capacity(&self)->usize {match self {Self::Copied(source)=>source.capacity(),Self::Shared(_)=>0}}
}
struct ParagraphOwner { range:paragraph::Paragraph, owner:parley::ShapedParagraph<()> }
/// Immutable shape/source and exact ORIGINAL font registration identity. Width
/// output is transient. This resource is source-side only, never renderable.
pub struct ShapeResource { source:SourceStorage, paragraphs:Vec<ParagraphOwner>, size:f32, ids:[Option<u64>;3], faces:FontSet }
/// The common derived-artifact store owns BOTH payload and accounting lease.
#[derive(Clone)]
pub struct ShapeArtifact { resource:Arc<ShapeResource>, lease:ResourceLease }
/// Reclaimable source-side handle. No naked shape root or font map escapes.
#[derive(Clone)]
pub struct OptionalShape { handle:gpui_reactivity_core::resource::OptionalHandle<Arc<ShapeResource>> }
impl OptionalShape {
    pub fn id(&self)->gpui_reactivity_core::resource::ResourceId {self.handle.id()}
    pub fn pin(&self,context:&gpui_reactivity_core::resource::ResourceContext)->Result<Option<ShapeArtifact>,gpui_reactivity_core::resource::ResourceError> {
        Ok(context.pin_optional(&self.handle)?.map(|pin|ShapeArtifact {
            resource:pin.payload().clone(),lease:pin.lease().clone(),
        }))
    }
}
impl ShapeArtifact {
    /// Transfer the SAME root and record, without hiding a second lease inside
    /// the optional payload. An actual reflow pin reconstructs this pair.
    pub fn into_optional(self,context:&mut gpui_reactivity_core::resource::ResourceContext)->Result<OptionalShape,gpui_reactivity_core::resource::ResourceError> {
        let Self {resource,lease}=self;
        Ok(OptionalShape {handle:context.retain_optional(resource,lease)?})
    }

    pub fn validate_request(text:&str,size:f32,width:Option<f32>)->Result<(),Error> {validate(text,size,width)}
    /// Exclusive source/shape payload capacity only, excluding shared font roots,
    /// opaque Arc/allocator headers and packed outputs (which coexist separately).
    pub fn exclusive_capacity_bytes(&self)->Option<usize> {
        let mut bytes=size_of::<ShapeResource>().checked_add(self.resource.source.capacity())?
            .checked_add(self.resource.paragraphs.capacity().checked_mul(size_of::<ParagraphOwner>())?)?;
        for part in &self.resource.paragraphs {bytes=bytes.checked_add(part.owner.exclusive_shape_vec_capacity_bytes()?)?;}
        Some(bytes)
    }
    pub fn lease(&self)->&ResourceLease { &self.lease }
    pub fn source(&self)->&str { &self.resource.source }
    pub fn same_font(&self,font:&FontFace)->bool { self.resource.faces.primary.same_face(font) }
    pub fn font_size(&self)->f32 { self.resource.size }
    pub fn measure(&self,width:Option<f32>)->Result<TextMetrics,Error> { Ok(self.resource.reflow::<false>(width,false)?.metrics) }
    pub fn shape_interactive(&self,width:Option<f32>)->Result<TextLayout,Error> {
        let planned=self.resource.reflow::<true>(width,true)?;
        output(planned,&self.resource.faces,self.resource.size,self.resource.source.len())
    }
}
fn validate(text:&str,size:f32,width:Option<f32>)->Result<(),Error> {
    if !size.is_finite() || !(0.0..=512.0).contains(&size) || size==0. { return Err(Error::InvalidFontSize); }
    if width.is_some_and(|w| !w.is_finite() || w<=0.) { return Err(Error::InvalidWidth); }
    if text.len()>MAX_TEXT { return Err(Error::ResourceLimit); } Ok(())
}
fn output(planned:Planned,faces:&FontSet,size:f32,len:usize)->Result<TextLayout,Error> {
    Ok(TextLayout { width:planned.metrics.width,height:planned.metrics.height,baseline:planned.metrics.baseline,font_size:size,
        glyphs:GlyphBuffer::new(planned.glyphs,len).map_err(|_|Error::ResourceLimit)?,
        fonts:Arc::new(FontSet { primary:faces.primary.clone(),fallbacks:std::array::from_fn(|i| if planned.mask&(1<<i)!=0 { faces.fallbacks[i].clone() } else { None }) }),
        mapping:planned.details.map(Arc::new) })
}
impl ShapeResource {
    fn reflow<const M:bool>(&self,width:Option<f32>,interactive:bool)->Result<Planned,Error> {
        validate(&self.source,self.size,width)?;
        let mut lower=lowering::Lowering::new();
        for paragraph in &self.paragraphs {
            let content=&self.source[paragraph.range.content.clone()];
            let view=paragraph.owner.width_view(width).ok_or(Error::InvalidWidth)?;
            lower=lower.paragraph::<M>(lowering::PlannedParagraph::View(&view),content,&paragraph.range,&self.source,self.size,width,interactive,&self.ids)?;
        }
        Ok(lower.finish())
    }
}
impl FontFace {
    /// Sealed exact FontData backing adapter for a retained validity witness.
    /// No fresh registration IDs, bytes copy, or caller-supplied projection.
    pub fn share_retained_text_backing(&self,tx:&mut WindowReservation<'_>,draft:DraftResource)->Result<(),gpui_reactivity_core::resource::ResourceError> {
        let bytes=size_of::<FontData>().checked_add(match &self.0.bytes {Cow::Owned(v)=>v.capacity(),Cow::Borrowed(_)=>0})
            .ok_or(gpui_reactivity_core::resource::ResourceError::Overflow)?;
        tx.share_arc(draft,self.0.clone(),layout(bytes).ok_or(gpui_reactivity_core::resource::ResourceError::Overflow)?)
    }
}
struct Capture<'a> { tx:WindowReservation<'a>,draft:DraftResource,source:SourceStorage,paragraphs:Vec<ParagraphOwner>,shape_bytes:usize }
fn layout(bytes:usize)->Option<PayloadLayout> { PayloadLayout::new(bytes,bytes,NonZeroU64::MIN,AccountingDomain::Host).ok() }
impl<'a> Capture<'a> {
    fn new(mut tx:WindowReservation<'a>,artifact:Artifact,text:&str,planner:&Planner<'_>,shared:Option<OwnedShapeSource>)->Option<Self> {
        let draft=tx.stage(ResourceKind::Shape,artifact).ok()?;
        if let Some(source)=&shared {
            if source.lease.id().owner()!=draft.id().owner() || source.lease.origin()!=gpui_reactivity_core::change::DependencyNode::Site(artifact)
                || !std::ptr::eq::<str>(source.as_str(),text) {return None;}
        }
        // SAME roots accepted by the ORIGINAL builder; never create/register a
        // fresh FontBytes/Blob. Shared font bytes excluded from shape Vec charge.
        for slot in 0..3 {
            if let Some(root)=&planner.font_roots[slot] {
                tx.share_arc(draft,root.clone(),layout(size_of::<FontBytes>())?).ok()?;
                let face=&root.0.0;
                let bytes=size_of::<FontData>().checked_add(match &face.bytes { Cow::Owned(v)=>v.capacity(),Cow::Borrowed(_)=>0 })?;
                tx.share_arc(draft,face.clone(),layout(bytes)?).ok()?;
            }
        }
        let minimum=size_of::<ShapeResource>().checked_add(if shared.is_some() {0} else {text.len()})?;
        if !tx.can_fit_new_root(draft,minimum) { return None; }
        let source=match shared {
            Some(source)=>SourceStorage::Shared(source),None=> {
                let mut source=String::new();source.try_reserve_exact(text.len()).ok()?;source.push_str(text);SourceStorage::Copied(source)
            }
        };
        Some(Self {tx,draft,source,paragraphs:Vec::new(),shape_bytes:0})
    }
    fn bytes(&self,extra:usize)->Option<usize> {
        size_of::<ShapeResource>().checked_add(self.source.capacity())?
            .checked_add(self.paragraphs.capacity().checked_mul(size_of::<ParagraphOwner>())?)?
            .checked_add(self.shape_bytes)?.checked_add(extra)
    }
    fn prepare(&mut self,planned:&parley::Layout<()>)->Option<usize> {
        let bytes=planned.exclusive_shape_vec_capacity_bytes()?;
        // Actual record capacity after fallible reserve is included BEFORE move.
        self.paragraphs.try_reserve(1).ok()?;
        if !self.tx.can_fit_new_root(self.draft,self.bytes(bytes)?) { return None; }
        Some(bytes)
    }
    fn finish(mut self,planner:&Planner<'_>,size:f32)->Option<ShapeArtifact> {
        let bytes=self.bytes(0)?;
        let resource=Arc::new(ShapeResource {source:self.source,paragraphs:self.paragraphs,size,ids:planner.blob_ids,faces:planner.faces.clone()});
        self.tx.share_arc(self.draft,resource.clone(),layout(bytes)?).ok()?;
        let lease=self.tx.commit().ok()?.pop()?;
        Some(ShapeArtifact {resource,lease})
    }
}
/// First pass preserves interleaving: build -> break -> canonical admission/
/// lowering -> optional capture. Decline keeps ordinary outputs and never reruns.
fn plan<'a,const M:bool>(planner:&mut Planner<'_>,text:&str,size:f32,width:Option<f32>,interactive:bool,tx:WindowReservation<'a>,artifact:Artifact,shared:Option<OwnedShapeSource>)
    ->Result<(Planned,Option<Capture<'a>>),Error>
{
    let needed=planner.coverage(text)?;
    let mut names=FAMILIES.map(|name|FontFamilyName::Named(name.into()));let mut count=1;
    for (index,family) in FAMILIES.iter().enumerate().skip(1) { if needed&(1<<(index-1))!=0 { names[count]=FontFamilyName::Named((*family).into());count+=1; } }
    let mut capture=Capture::new(tx,artifact,text,planner,shared);
    // A new retained source must not inherit an unrelated site's oversized
    // ordinary scratch capacities after quota decline. No shaping is rerun.
    // Source capture already moves every admitted paragraph out of this slot.
    if capture.is_some() {planner.layout=parley::Layout::default();}
    let mut lower=lowering::Lowering::new();
    for paragraph in paragraph::ranges(text) {
        let content=&text[paragraph.content.clone()];
        let mut builder=planner.context.ranged_builder(&mut planner.fonts,content,1.,false);
        builder.push_default(&names[..count]);builder.push_default(StyleProperty::FontSize(size));
        builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
        #[cfg(test)]
        BUILDS.with(|n|n.set(n.get()+1));
        builder.build_into(&mut planner.layout,content);
        planner.layout.break_all_lines(width);
        lower=lower.paragraph::<M>(lowering::PlannedParagraph::Layout(&planner.layout),content,&paragraph,text,size,width,interactive,&planner.blob_ids)?;
        if let Some(active)=capture.as_mut() {
            if let Some(bytes)=active.prepare(&planner.layout) {
                let owned=std::mem::take(&mut planner.layout);
                match owned.try_into_shaped_paragraph() {
                    Ok(owner)=> {
                        #[cfg(test)]
                        CAPTURES.with(|n|n.set(n.get()+1));
                        active.shape_bytes=active.shape_bytes.checked_add(bytes).expect("preflight checked sum");active.paragraphs.push(ParagraphOwner {range:paragraph,owner}); }
                    Err(original)=> {planner.layout=original;capture=None;}
                }
            } else { capture=None; } // Drops ALL prefix owners/leases before next build.
        }
    }
    Ok((lower.finish(),capture))
}
pub(in crate::text) fn shape(planner:&mut Planner<'_>,text:&str,size:f32,width:Option<f32>,tx:WindowReservation<'_>,artifact:Artifact)
    ->Result<(TextLayout,Option<ShapeArtifact>),Error>
{
    let result=(|| { let (planned,capture)=plan::<true>(planner,text,size,width,true,tx,artifact,None)?;
        let output=output(planned,&planner.faces,size,text.len())?;
        Ok((output,capture.and_then(|c|c.finish(planner,size)))) })();
    if result.is_err() {planner.layout=parley::Layout::default();} result
}
pub(in crate::text) fn measure(planner:&mut Planner<'_>,text:&str,size:f32,width:Option<f32>,tx:WindowReservation<'_>,artifact:Artifact)
    ->Result<(TextMetrics,Option<ShapeArtifact>),Error>
{
    let result=(|| {let (planned,capture)=plan::<false>(planner,text,size,width,false,tx,artifact,None)?;
        Ok((planned.metrics,capture.and_then(|c|c.finish(planner,size))))})();
    if result.is_err() {planner.layout=parley::Layout::default();} result
}

pub(in crate::text) fn shape_owned(planner:&mut Planner<'_>,source:OwnedShapeSource,size:f32,width:Option<f32>,tx:WindowReservation<'_>,artifact:Artifact)
    ->Result<(TextLayout,Option<ShapeArtifact>),Error>
{
    let text=source.backing.clone();
    let result=(|| {let (planned,capture)=plan::<true>(planner,text.as_str(),size,width,true,tx,artifact,Some(source))?;
        let output=output(planned,&planner.faces,size,text.as_str().len())?;
        Ok((output,capture.and_then(|c|c.finish(planner,size))))})();
    if result.is_err() {planner.layout=parley::Layout::default();}result
}
pub(in crate::text) fn measure_owned(planner:&mut Planner<'_>,source:OwnedShapeSource,size:f32,width:Option<f32>,tx:WindowReservation<'_>,artifact:Artifact)
    ->Result<(TextMetrics,Option<ShapeArtifact>),Error>
{
    let text=source.backing.clone();
    let result=(|| {let (planned,capture)=plan::<false>(planner,text.as_str(),size,width,false,tx,artifact,Some(source))?;
        Ok((planned.metrics,capture.and_then(|c|c.finish(planner,size))))})();
    if result.is_err() {planner.layout=parley::Layout::default();}result
}
#[cfg(test)]
std::thread_local! { static BUILDS:std::cell::Cell<usize>=const { std::cell::Cell::new(0) };
    static CAPTURES:std::cell::Cell<usize>=const { std::cell::Cell::new(0) }; }
#[cfg(test)]
mod tests {
    use super::*;
    use gpui_reactivity_core::{change::{FrameIssuer,Phase,SiteId},resource::{ResourceContext,ResourceLimits,WindowAccounting}};
    fn context(bytes:usize)->ResourceContext { ResourceContext::new(ResourceLimits {retained_payload_bytes:bytes,physical_roots:64,resource_records:32,backings_per_resource:16}).unwrap() }
    fn artifact(issuer:&FrameIssuer)->Artifact { Artifact {site:SiteId::from_monotonic(issuer.owner(),NonZeroU64::MIN),phase:Phase::Shape} }
    fn words(layout:&TextLayout)->Vec<u64> { super::super::lowering_control::packed_words(layout) }
    #[test]
    fn optional_shape_keeps_same_root_and_original_ids_until_unpinned_reclaim() {
        let face=FontFace::new(include_bytes!("../../assets/NotoSans-default.ttf")).unwrap();
        let mut service=face.shaper();let mut context=context(8*1024*1024);let issuer=FrameIssuer::new().unwrap();
        let scope=WindowAccounting::Scoped(context.scope(&issuer));
        let tx=context.window_reservation(scope,&issuer).unwrap();
        let source="office affinity wraps at narrow widths";
        let (packed,shape)=service.shape_interactive_resource(source,14.1,Some(120.),tx,artifact(&issuer)).unwrap();
        let shape=shape.unwrap();let ptr=Arc::as_ptr(&shape.resource);let ids=shape.resource.ids;
        let optional=shape.into_optional(&mut context).unwrap();
        let pin=optional.pin(&context).unwrap().unwrap();
        assert_eq!(Arc::as_ptr(&pin.resource),ptr);assert_eq!(pin.resource.ids,ids);
        assert_eq!(words(&pin.shape_interactive(Some(120.)).unwrap()),words(&packed));
        assert_eq!(context.reclaim_optional(usize::MAX).removed,0);
        drop(pin);assert_eq!(context.reclaim_optional(usize::MAX).removed,1);
        assert!(optional.pin(&context).unwrap().is_none());
        // Packed output remains independent of the raw source-side owner.
        assert!(!words(&packed).is_empty());
    }
    #[test]
    fn shared_source_child_survives_witness_reclaim_and_raw_owner_does_not_self_pin() {
        use gpui_reactivity_core::resource::Utf8Backing;
        let _lock=super::super::super::BUNDLED_TEST_LOCK.lock().unwrap();
        let face=FontFace::bundled().unwrap();let mut service=face.shaper();
        let text="office affinity source α\r\nאבג العربية wraps repeatedly";
        let backing=Utf8Backing::new(String::from(text).into());let mut context=context(8*1024*1024);let issuer=FrameIssuer::new().unwrap();let key=artifact(&issuer);let scope=WindowAccounting::Scoped(context.scope(&issuer));
        let mut tx=context.window_reservation(scope,&issuer).unwrap();let draft=tx.stage(ResourceKind::Utf8Source,key).unwrap();tx.share_utf8(draft,backing.clone()).unwrap();let witness_lease=tx.commit().unwrap().pop().unwrap();let witness_id=witness_lease.id();
        let witness=context.retain_optional(backing.clone(),witness_lease).unwrap();
        let owned=OwnedShapeSource::admit(backing.clone(),&mut context,scope,&issuer,key).unwrap();let child_id=owned.lease.id();assert_ne!(child_id,witness_id);
        assert_eq!(context.stats().utf8_guard_wrappers_created,1,"child must alias SAME physical backing");
        let tx=context.window_reservation(scope,&issuer).unwrap();let (packed,raw)=service.shape_interactive_owned_resource(owned,14.1,Some(120.),tx,key).unwrap();let raw=raw.unwrap();
        assert_ne!(raw.lease().id(),child_id);assert_eq!(raw.resource.source.capacity(),0);
        assert_eq!(raw.source().as_ptr(),backing.as_str().as_ptr());
        assert_eq!(context.reclaim_optional(usize::MAX).removed,1);assert!(context.pin_optional(&witness).unwrap().is_none());
        for _ in 0..4 {context.maintain(usize::MAX).unwrap();}
        let wrapper_bytes=raw.resource.ids.iter().filter(|id|id.is_some()).count()*size_of::<FontBytes>();
        let accepted_fonts=font_payload((0..3).filter_map(|slot|raw.resource.faces.face(slot).ok().cloned()));
        assert_eq!(context.stats().retained_payload_bytes,raw.exclusive_capacity_bytes().unwrap()+wrapper_bytes+accepted_fonts+backing.retained_allocation_bytes().unwrap(),"exact declared live-root union must still include source ONCE after witness retirement");
        assert_eq!(context.stats().utf8_guard_wrappers_created,1);
        for width in [Some(120.),Some(40.),Some(120.)] {
            let reused=raw.shape_interactive(width).unwrap();let cold=face.shaper().shape_interactive(text,14.1,width).unwrap();assert_eq!(words(&reused),words(&cold));
        }
        assert_eq!(words(&raw.shape_interactive(Some(120.)).unwrap()),words(&packed));
        let optional=raw.into_optional(&mut context).unwrap();assert_eq!(context.reclaim_optional(usize::MAX).removed,1,"raw owner must not contain its OWN record lease");
        assert!(optional.pin(&context).unwrap().is_none());for _ in 0..4 {context.maintain(usize::MAX).unwrap();}assert_eq!(context.stats().retained_payload_bytes,0);
    }
    #[test]
    fn shared_source_matches_copied_resource_and_reports_removed_copy_capacity() {
        use gpui_reactivity_core::resource::Utf8Backing;
        let _lock=super::super::super::BUNDLED_TEST_LOCK.lock().unwrap();
        let face=FontFace::bundled().unwrap();let mut service=face.shaper();
        for text in [String::new(),String::from("office"),String::from("office affinity\r\n\r\nאבג العربية\nlast"),"office ".repeat(2000)] {
            let mut context=context(16*1024*1024);let issuer=FrameIssuer::new().unwrap();let scope=WindowAccounting::Scoped(context.scope(&issuer));let key=artifact(&issuer);
            let tx=context.window_reservation(scope,&issuer).unwrap();let (copied_output,copied)=service.shape_interactive_resource(&text,14.1,Some(120.),tx,key).unwrap();let copied=copied.unwrap();
            let backing=Utf8Backing::new(text.clone().into());let owned=OwnedShapeSource::admit(backing.clone(),&mut context,scope,&issuer,key).unwrap();
            let tx=context.window_reservation(scope,&issuer).unwrap();let (shared_output,shared)=service.shape_interactive_owned_resource(owned,14.1,Some(120.),tx,key).unwrap();let shared=shared.unwrap();
            assert!(matches!(&copied.resource.source,SourceStorage::Copied(_)));assert!(matches!(&shared.resource.source,SourceStorage::Shared(_)));
            assert_eq!(words(&copied_output),words(&shared_output));assert_eq!(copied.resource.ids,shared.resource.ids);
            let removed=copied.resource.source.capacity();assert_eq!(shared.resource.source.capacity(),0);
            assert_eq!(copied.exclusive_capacity_bytes().unwrap()-shared.exclusive_capacity_bytes().unwrap(),removed);
            assert!(shared.same_font(&face));assert_eq!(shared.source().as_ptr(),backing.as_str().as_ptr());
            for width in [Some(120.),Some(40.),Some(120.)] {
                let owned=OwnedShapeSource::admit(backing.clone(),&mut context,scope,&issuer,key).unwrap();let tx=context.window_reservation(scope,&issuer).unwrap();
                let (measured,raw)=service.measure_owned_resource(owned,14.1,width,tx,key).unwrap();let raw=raw.expect("explicit test quota must admit owned measure");
                assert_eq!(raw.source().as_ptr(),backing.as_str().as_ptr());assert_eq!(raw.resource.source.capacity(),0);
                let ordinary=face.shaper().measure(&text,14.1,width).unwrap();let reused=shared.measure(width).unwrap();
                assert_eq!([measured.width,measured.height,measured.baseline].map(f32::to_bits),[ordinary.width,ordinary.height,ordinary.baseline].map(f32::to_bits));
                assert_eq!([measured.width,measured.height,measured.baseline].map(f32::to_bits),[reused.width,reused.height,reused.baseline].map(f32::to_bits));
            }
            eprintln!("CAP_SHARED_SHAPE_SOURCE scope=declared_payload_capacities_not_total_memory bytes={} removed_string_capacity={} shared_source_field={} copied_string_field={} child_lease_handle={} current_shape_header={} exclusions=child_record_and_vec_refs,arc_btree_metadata,mandatory_packed_outputs",text.len(),removed,size_of::<SourceStorage>(),size_of::<String>(),size_of::<ResourceLease>(),size_of::<ShapeResource>());
        }
    }
    #[test]
    fn shared_source_child_record_limit_and_foreign_domain_decline_without_reshaping() {
        use gpui_reactivity_core::resource::{Utf8Backing,ResourceError};
        let face=FontFace::new(include_bytes!("../../assets/NotoSans-default.ttf")).unwrap();let mut service=face.shaper();let text="office\r\nlast";
        let issuer=FrameIssuer::new().unwrap();let key=artifact(&issuer);
        for foreign in [false,true] {
            let mut a=ResourceContext::new(ResourceLimits {retained_payload_bytes:8*1024*1024,physical_roots:64,resource_records:1,backings_per_resource:16}).unwrap();let sa=WindowAccounting::Scoped(a.scope(&issuer));
            let mut b=context(8*1024*1024);let sb=WindowAccounting::Scoped(b.scope(&issuer));
            let owned=OwnedShapeSource::admit(Utf8Backing::new(String::from(text).into()),&mut a,sa,&issuer,key).unwrap();
            let (target,scope)=if foreign {(&mut b,sb)} else {(&mut a,sa)};
            let before_build=BUILDS.with(|n|n.get());let before_capture=CAPTURES.with(|n|n.get());
            let tx=target.window_reservation(scope,&issuer).unwrap();let (actual,raw)=service.shape_interactive_owned_resource(owned,14.1,Some(40.),tx,key).unwrap();
            assert!(raw.is_none());assert_eq!(BUILDS.with(|n|n.get())-before_build,paragraph::ranges(text).count());assert_eq!(CAPTURES.with(|n|n.get()),before_capture);
            assert_eq!(words(&actual),words(&face.shaper().shape_interactive(text,14.1,Some(40.)).unwrap()));
        }
        let mut c=context(8*1024*1024);let scope=WindowAccounting::Scoped(c.scope(&issuer));let wrong=Artifact {phase:Phase::Material,..key};
        assert!(matches!(OwnedShapeSource::admit(Utf8Backing::new("office".into()),&mut c,scope,&issuer,wrong),Err(ResourceError::InvalidLayout)));
    }
    #[test]
    fn shared_source_child_alias_record_metadata_is_additional_without_source_payload_charge() {
        use gpui_reactivity_core::resource::Utf8Backing;
        for text in [String::new(),String::from("office"),"office ".repeat(2000)] {
            let mut context=context(8*1024*1024);let issuer=FrameIssuer::new().unwrap();let scope=WindowAccounting::Scoped(context.scope(&issuer));let key=artifact(&issuer);
            let backing=Utf8Backing::new(text.clone().into());
            let mut tx=context.window_reservation(scope,&issuer).unwrap();let draft=tx.stage(ResourceKind::Utf8Source,key).unwrap();tx.share_utf8(draft,backing.clone()).unwrap();let witness=tx.commit().unwrap().pop().unwrap();
            let before=context.stats();let mut owned=None;
            let admission=allocation_counter::measure(|| {owned=Some(OwnedShapeSource::admit(backing.clone(),&mut context,scope,&issuer,key).unwrap());});
            let after=context.stats();assert_eq!(after.retained_payload_bytes,before.retained_payload_bytes);assert_eq!(after.root_records_created,before.root_records_created);assert_eq!(after.resource_records_created,before.resource_records_created+1);
            assert_ne!(owned.as_ref().unwrap().lease.id(),witness.id());
            let child_refs=after.retained_reference_capacity_bytes-before.retained_reference_capacity_bytes;
            let dropped=allocation_counter::measure(||drop(owned.take()));
            let reaped=allocation_counter::measure(|| {for _ in 0..4 {context.maintain(usize::MAX).unwrap();}});
            assert_eq!(context.stats().retained_reference_capacity_bytes,before.retained_reference_capacity_bytes);assert_eq!(context.stats().retained_payload_bytes,before.retained_payload_bytes);
            assert!(admission.bytes_current>0,"distinct child record has real metadata cost even for empty source");
            eprintln!("CAP_SHARED_SOURCE_CHILD_METADATA scope=isolated_alias_record_allocator_requests_not_rss bytes={} extra_child_records=1 extra_source_payload=0 child_reference_capacity_bytes={} admit_total={} admit_live={} drop_delta={} reap_delta={} source_owner_inline={} exclusions=existing_witness_root,allocator_internal_overhead,btree_spare_capacity_until_context_drop",text.len(),child_refs,admission.bytes_total,admission.bytes_current,dropped.bytes_current,reaped.bytes_current,size_of::<OwnedShapeSource>());
        }
    }
    fn packed_payload(layout:&TextLayout)->usize {
        let mut n=size_of::<TextLayout>()+layout.glyphs.capacity()*size_of::<PackedGlyph>()+size_of::<FontSet>();
        if let Some(details)=&layout.mapping {
            n+=size_of::<Details>()+details.runs.capacity()*size_of::<Run>()+details.lines.capacity()*size_of::<Line>();
            if let Some(stops)=&details.carets {n+=stops.capacity()*size_of::<Stop>();}
        } n
    }
    fn font_payload(faces:impl Iterator<Item=FontFace>)->usize {
        let mut unique=std::collections::BTreeMap::new();
        for face in faces {unique.entry(Arc::as_ptr(&face.0) as usize).or_insert_with(||size_of::<FontData>()+match &face.0.bytes {Cow::Owned(v)=>v.capacity(),Cow::Borrowed(_)=>0});}
        unique.values().sum()
    }
    #[test]
    fn actual_resource_reflows_a_b_a_to_full_packed_cold_output_without_new_builds() {
        let _lock=super::super::super::BUNDLED_TEST_LOCK.lock().unwrap();
        let face=FontFace::bundled().unwrap();let mut service=face.shaper();let issuer=FrameIssuer::new().unwrap();
        let mut context=context(16*1024*1024);let scope=context.scope(&issuer);
        let text="office affinity AVATAR repeated paragraph must genuinely wrap at narrow width. אבג العربية\r\n\r\nlast paragraph";
        BUILDS.with(|n|n.set(0));
        let tx=context.window_reservation(WindowAccounting::Scoped(scope),&issuer).unwrap();
        let (initial,resource)=service.shape_interactive_resource(text,14.1,Some(120.),tx,artifact(&issuer)).unwrap();
        let resource=resource.expect("explicit large test budget must admit");
        assert_eq!(BUILDS.with(|n|n.get()),paragraph::ranges(text).count());
        assert!(resource.same_font(&face));assert_eq!(resource.source(),text);
        let a=resource.shape_interactive(Some(120.)).unwrap();let b=resource.shape_interactive(Some(40.)).unwrap();
        assert_ne!(a.height.to_bits(),b.height.to_bits(),"fixture must genuinely rewrap");
        for width in [Some(120.),Some(40.),Some(120.),None] {
            let reused=resource.shape_interactive(width).unwrap();let cold=face.shaper().shape_interactive(text,14.1,width).unwrap();
            assert_eq!(words(&reused),words(&cold));
            assert!(reused.fonts.primary.same_face(&face));
            for slot in 1..=2 { if let Some(accepted)=&reused.fonts.fallbacks[slot-1] { assert!(accepted.same_face(resource.resource.faces.face(slot).unwrap())); } }
            let measured=resource.measure(width).unwrap();let ordinary=face.shaper().measure(text,14.1,width).unwrap();
            assert_eq!([measured.width.to_bits(),measured.height.to_bits(),measured.baseline.to_bits()],
                [ordinary.width.to_bits(),ordinary.height.to_bits(),ordinary.baseline.to_bits()]);
        }
        assert_eq!(words(&initial),words(&a));assert_eq!(BUILDS.with(|n|n.get()),paragraph::ranges(text).count());
        // Declared retained snapshots, NOT actual execution high-water/RSS.
        // Current transient-shaping baseline AFTER service drop keeps packed
        // output, but no raw paragraphs/FontBytes wrappers. Raw+packed can LOSE.
        let a2=resource.shape_interactive(Some(120.)).unwrap();
        let raw=resource.exclusive_capacity_bytes().unwrap();
        let wrappers=resource.resource.ids.iter().filter(|id|id.is_some()).count()*size_of::<FontBytes>();
        let baseline_fonts=font_payload((0..3).filter_map(|slot|a.fonts.face(slot).ok().cloned()));
        let retained_fonts=font_payload((0..3).filter_map(|slot|resource.resource.faces.face(slot).ok().cloned()));
        let baseline=packed_payload(&a)+baseline_fonts;
        let retained=raw+wrappers+packed_payload(&a)+retained_fonts;
        assert!(retained>baseline,"reuse is not intrinsically a retained-memory win");
        assert!(!std::ptr::eq(a.glyphs.as_ptr(),b.glyphs.as_ptr()));
        assert!(!std::ptr::eq(a.glyphs.as_ptr(),a2.glyphs.as_ptr()));
        eprintln!("CAP_RESOURCE_RETENTION scope=declared_ownership_model_not_actual_live_union baseline_packed_after_service_drop={} raw_exclusive={} retained_font_wrappers={} baseline_unique_font_payload={} retained_unique_font_payload={} raw_plus_packed={} held_initial_a_b_a_payload={} exclusions=arc_headers,allocator_headers,ledger_metadata,store_index,gpui_packed_key_metadata,instrumentation,planner_scratch,lower_internal_peak,raster_scene",baseline,raw,wrappers,baseline_fonts,retained_fonts,retained,raw+wrappers+packed_payload(&initial)+packed_payload(&a)+packed_payload(&b)+packed_payload(&a2)+retained_fonts);
        drop(service);drop(face);assert_eq!(words(&resource.shape_interactive(Some(40.)).unwrap()),words(&b));
        assert!(resource.lease().render_lease().is_none());
    }
    #[test]
    fn actual_budget_decline_keeps_ordinary_output_and_builds_each_paragraph_once() {
        let _lock=super::super::super::BUNDLED_TEST_LOCK.lock().unwrap();
        let face=FontFace::bundled().unwrap();let issuer=FrameIssuer::new().unwrap();let text="office paragraph long enough to wrap\r\n\r\nsecond العربية paragraph";
        let expected=face.shaper().shape_interactive(text,14.1,Some(40.)).unwrap();
        for budget in [0,1,64] {
            let mut context=context(budget);let scope=context.scope(&issuer);let mut service=face.shaper();BUILDS.with(|n|n.set(0));
            let tx=context.window_reservation(WindowAccounting::Scoped(scope),&issuer).unwrap();
            let (actual,resource)=service.shape_interactive_resource(text,14.1,Some(40.),tx,artifact(&issuer)).unwrap();
            assert!(resource.is_none());assert_eq!(words(&actual),words(&expected));
            assert_eq!(BUILDS.with(|n|n.get()),paragraph::ranges(text).count());
        }
    }
    #[test]
    fn backing_slot_quota_declines_before_any_owner_is_consumed() {
        let _lock=super::super::super::BUNDLED_TEST_LOCK.lock().unwrap();
        let face=FontFace::bundled().unwrap();let issuer=FrameIssuer::new().unwrap();let text="office paragraph must wrap\r\nsecond paragraph";
        let mut context=ResourceContext::new(ResourceLimits {retained_payload_bytes:16*1024*1024,physical_roots:64,resource_records:32,backings_per_resource:2}).unwrap();
        let scope=context.scope(&issuer);let tx=context.window_reservation(WindowAccounting::Scoped(scope),&issuer).unwrap();
        BUILDS.with(|n|n.set(0));CAPTURES.with(|n|n.set(0));
        let (actual,retained)=face.shaper().shape_interactive_resource(text,14.1,Some(40.),tx,artifact(&issuer)).unwrap();
        assert!(retained.is_none());assert_eq!(CAPTURES.with(|n|n.get()),0);
        assert_eq!(BUILDS.with(|n|n.get()),paragraph::ranges(text).count());
        assert_eq!(words(&actual),words(&face.shaper().shape_interactive(text,14.1,Some(40.)).unwrap()));
    }

    #[test]
    fn declined_large_scratch_does_not_prevent_later_short_source_admission() {
        let bytes=include_bytes!("../../assets/NotoSans-default.ttf");let face=FontFace::new(bytes).unwrap();let issuer=FrameIssuer::new().unwrap();
        let mut context=ResourceContext::new(ResourceLimits {retained_payload_bytes:bytes.len()+64*1024,physical_roots:64,resource_records:32,backings_per_resource:16}).unwrap();let scope=context.scope(&issuer);let mut service=face.shaper();
        let large="office ".repeat(4000);let tx=context.window_reservation(WindowAccounting::Scoped(scope),&issuer).unwrap();
        let (_,declined)=service.measure_resource(&large,14.1,None,tx,artifact(&issuer)).unwrap();assert!(declined.is_none());
        let tx=context.window_reservation(WindowAccounting::Scoped(scope),&issuer).unwrap();
        let (small,retained)=service.measure_resource("office",14.1,None,tx,artifact(&issuer)).unwrap();let retained=retained.expect("fresh short owner must not inherit huge declined scratch capacity");
        let cold=face.shaper().measure("office",14.1,None).unwrap();assert_eq!(small.width.to_bits(),cold.width.to_bits());assert_eq!(retained.source(),"office");
        assert!(retained.exclusive_capacity_bytes().unwrap()<64*1024);
    }

}
