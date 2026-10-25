//! Actual Runtime sparse-owner/admission controls, not a synthetic slot model.
use super::*;
use crate::prelude::*;
use gpui_reactivity_core::resource::{ResourceContext,ResourceLimits};
struct Page { nontext:usize, value:Signal<String>, width:f32 }
impl Page { const VALUE:Source<Self,String>=Source::new(FieldId::new(1),"value",|m|&m.value,|m|&mut m.value); }
impl View for Page {
    fn sources()->Sources<Self> {Sources::new().direct(Self::VALUE)}
    fn view(&self)->El<'_> {
        column((0..self.nontext).map(|_|div().size(0)))
            .child(text(&self.value).name("late").w(self.width).font_size(12))
            .w(128).h(48)
    }
}
fn model(nontext:usize,width:f32)->Page {Page{nontext,value:Signal::new("office paragraph wraps at narrower widths".into()),width}}
fn context()->ResourceContext {
    // Explicit isolated fixture policy, not a per-window/default production cap.
    ResourceContext::new(ResourceLimits {retained_payload_bytes:8*1024*1024,physical_roots:128,resource_records:128,backings_per_resource:16}).unwrap()
}
fn options()->WindowOptions {WindowOptions{size:[128,48],..Default::default()}}
fn ack(win:&mut Win<Page>) {let token=win.with_scene(|_,t|t).unwrap();win.presented(token).unwrap();}
fn pixels(win:&mut Win<Page>)->Vec<u32> {let mut out=vec![0;128*48];win.render_bgrx(&mut out).unwrap();out}
#[test]
fn actual_late_text_owner_cost_is_independent_of_nontext_prefix_and_width_keeps_raw_identity() {
    let mut small_context=context();let mut late_context=context();
    let mut small=Win::recording_with_resources(model(0,100.),options(),&mut small_context).unwrap();
    let mut late=Win::recording_with_resources(model(10_000,100.),options(),&mut late_context).unwrap();
    ack(&mut small);ack(&mut late);
    let a=&small.runtime().unwrap().artifacts;let b=&late.runtime().unwrap().artifacts;
    assert_eq!(a.owned_resource_ids().len(),1);assert_eq!(b.owned_resource_ids().len(),1);
    assert_eq!(a.metadata_payload_bytes(),b.metadata_payload_bytes(),"nontext nodes are not ArtifactStore allocation slots");
    assert_eq!(a.visits(),b.visits(),"commit/abort scans live artifacts, not node prefix");
    let original=b.owned_resource_ids();let target=late.query().name("late").one().unwrap();
    for width in [40.,80.,100.] {
        let old_rows=late.snapshot().unwrap().nodes;
        let mut turn=late.edit_turn_with_resources(&mut late_context).unwrap();
        turn.set_property(target,crate::property::WIDTH,Contribution::Set(Some(width))).unwrap();
        turn.finish().unwrap();assert_eq!(late.snapshot().unwrap().nodes,old_rows);ack(&mut late);
        assert_eq!(late.runtime().unwrap().artifacts.owned_resource_ids(),original,"wrap width is not raw Shape source identity");
        let mut cold=Win::with_options(model(10_000,width),options()).unwrap();
        assert_eq!(pixels(&mut late),pixels(&mut cold));
        let rows=|win:&Win<Page>|{let mut rows=win.snapshot().unwrap().nodes;for row in &mut rows {row.identity=0;row.target=None;}rows};
        assert_eq!(rows(&late),rows(&cold));
    }
}
