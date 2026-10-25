//! Experimental live-source artifact. Never part of a published Canvas scene.
use super::*;
use gpui_reactivity_core::{change::Artifact,resource::{ResourceLease,ResourceKind,WindowReservation,PayloadLayout,AccountingDomain,DraftResource}};
use std::{mem::size_of,num::NonZeroU64};

struct ParagraphOwner { range:paragraph::Paragraph, owner:parley::ShapedParagraph<()> }
/// Immutable shape/source and exact ORIGINAL font registration identity. Width
/// output is transient. This resource is source-side only, never renderable.
pub struct ShapeResource { source:String, paragraphs:Vec<ParagraphOwner>, size:f32, ids:[Option<u64>;3], faces:FontSet }
/// The common derived-artifact store owns BOTH payload and accounting lease.
pub struct ShapeArtifact { resource:Arc<ShapeResource>, lease:ResourceLease }
impl ShapeArtifact {
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
struct Capture<'a> { tx:WindowReservation<'a>,draft:DraftResource,source:String,paragraphs:Vec<ParagraphOwner>,shape_bytes:usize }
fn layout(bytes:usize)->Option<PayloadLayout> { PayloadLayout::new(bytes,bytes,NonZeroU64::MIN,AccountingDomain::Host).ok() }
impl<'a> Capture<'a> {
    fn new(mut tx:WindowReservation<'a>,artifact:Artifact,text:&str,planner:&Planner<'_>)->Option<Self> {
        let draft=tx.stage(ResourceKind::Shape,artifact).ok()?;
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
        let minimum=size_of::<ShapeResource>().checked_add(text.len())?;
        if !tx.can_fit_new_root(draft,minimum) { return None; }
        let mut source=String::new();source.try_reserve_exact(text.len()).ok()?;source.push_str(text);
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
fn plan<'a,const M:bool>(planner:&mut Planner<'_>,text:&str,size:f32,width:Option<f32>,interactive:bool,tx:WindowReservation<'a>,artifact:Artifact)
    ->Result<(Planned,Option<Capture<'a>>),Error>
{
    let needed=planner.coverage(text)?;
    let mut names=FAMILIES.map(|name|FontFamilyName::Named(name.into()));let mut count=1;
    for (index,family) in FAMILIES.iter().enumerate().skip(1) { if needed&(1<<(index-1))!=0 { names[count]=FontFamilyName::Named((*family).into());count+=1; } }
    let mut capture=Capture::new(tx,artifact,text,planner);
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
    let result=(|| { let (planned,capture)=plan::<true>(planner,text,size,width,true,tx,artifact)?;
        let output=output(planned,&planner.faces,size,text.len())?;
        Ok((output,capture.and_then(|c|c.finish(planner,size)))) })();
    if result.is_err() {planner.layout=parley::Layout::default();} result
}
pub(in crate::text) fn measure(planner:&mut Planner<'_>,text:&str,size:f32,width:Option<f32>,tx:WindowReservation<'_>,artifact:Artifact)
    ->Result<(TextMetrics,Option<ShapeArtifact>),Error>
{
    let result=(|| {let (planned,capture)=plan::<false>(planner,text,size,width,false,tx,artifact)?;
        Ok((planned.metrics,capture.and_then(|c|c.finish(planner,size))))})();
    if result.is_err() {planner.layout=parley::Layout::default();} result
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
        eprintln!("CAP_RESOURCE_RETENTION scope=declared_ownership_model_not_actual_live_union baseline_packed_after_service_drop={} raw_exclusive={} retained_font_wrappers={} baseline_unique_font_payload={} retained_unique_font_payload={} raw_plus_packed={} held_initial_a_b_a_payload={} exclusions=arc_headers,allocator_headers,ledger_metadata,store_index,planner_scratch,lower_internal_peak,raster_scene",baseline,raw,wrappers,baseline_fonts,retained_fonts,retained,raw+wrappers+packed_payload(&initial)+packed_payload(&a)+packed_payload(&b)+packed_payload(&a2)+retained_fonts);
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

}
