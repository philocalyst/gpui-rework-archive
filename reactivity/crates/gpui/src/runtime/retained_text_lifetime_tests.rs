//! Actual scoped producer output survives retirement of ALL frontend owners.
//! No source/shape/font resource is intentionally retained by this test's scene.
use super::*;
use crate::prelude::*;
use gpui_reactivity_core::resource::{ResourceContext,ResourceLimits};

struct DetachedPage {value:Signal<String>}
impl DetachedPage {
    const VALUE:Source<Self,String>=Source::new(FieldId::new(41),"value",|m|&m.value,|m|&mut m.value);
}
impl View for DetachedPage {
    fn sources()->Sources<Self> {Sources::new().direct(Self::VALUE)}
    fn view(&self)->El<'_> {column(text(&self.value).w(80).font_size(14.1)).w(160).h(96)}
}
fn model()->DetachedPage {DetachedPage {value:Signal::new("office affinity paragraph wraps across multiple lines.\r\nאבג العربية last".into())}}
fn options()->WindowOptions {WindowOptions {size:[160,96],..Default::default()}}

#[test]
fn accepted_canvas_renders_cold_identical_pixels_after_frontend_shape_and_font_services_drop() {
    // Explicit test policy; App limit covers registered resources, NOT total
    // model/source/render memory. In e257 this registers the raw-shape cohort.
    let mut resources=ResourceContext::new(ResourceLimits {retained_payload_bytes:8*1024*1024,physical_roots:128,resource_records:128,backings_per_resource:16}).unwrap();
    let mut win=Win::recording_with_resources(model(),options(),&mut resources).unwrap();
    assert_eq!(win.runtime().unwrap().artifacts.owned_resource_ids().len(),1,"real scoped hook must admit the raw artifact");
    assert!(resources.stats().retained_payload_bytes>0);
    let mut expected=vec![0x005aa55a;160*96];
    let mut cold=Win::with_options(model(),options()).unwrap();cold.render_bgrx(&mut expected).unwrap();
    assert!(expected.iter().any(|pixel|*pixel!=expected[0]),"fixture must contain visible glyph output");
    let mut before=vec![0x00a55aa5;160*96];let token=win.render_bgrx(&mut before).unwrap();assert_eq!(before,expected);win.presented(token).unwrap();
    drop(cold);

    // Retain ONLY the accepted Canvas. Drop the actual Runtime, including model,
    // TextSite packed-input witnesses, ArtifactStore/raw owners, TextSystem and
    // its font/raster/parser services. This is not merely dropping one shaper.
    let mut runtime=win.inner.take().expect("live Runtime");
    let config=runtime.canvas.color_config();
    let empty=Canvas::recording(1,1,config).unwrap();
    let mut accepted=std::mem::replace(&mut runtime.canvas,empty);
    drop(runtime);drop(win);
    // Explicit fixture collection, NOT an automatic production maintenance cap.
    resources.reclaim_optional(usize::MAX);for _ in 0..4 {resources.maintain(usize::MAX).unwrap();}
    assert_eq!(resources.stats().retained_payload_bytes,0,"registered accounting leases/cohort must retire with the frontend");
    drop(resources);

    // Every render_bgrx call renders its supplied target; this does NOT read an
    // old cached RGBA image. A new sentinel target forces full output evidence.
    let mut after=vec![0x00deadde;160*96];accepted.render_bgrx(&mut after).unwrap();assert_eq!(after,expected);
    let mut second=vec![0x00123456;160*96];accepted.render_bgrx(&mut second).unwrap();assert_eq!(second,expected);
}

struct AbortPage {first:Signal<String>,later:Signal<String>}
impl AbortPage {
    const FIRST:Source<Self,String>=Source::new(FieldId::new(61),"first",|m|&m.first,|m|&mut m.first);
    const LATER:Source<Self,String>=Source::new(FieldId::new(62),"later",|m|&m.later,|m|&mut m.later);
    fn new(first:&str,later:&str)->Self {Self {first:Signal::new(first.into()),later:Signal::new(later.into())}}
}
impl View for AbortPage {
    fn sources()->Sources<Self> {Sources::new().direct(Self::FIRST).direct(Self::LATER)}
    fn view(&self)->El<'_> {column((text(&self.first).w(80).font_size(14.1),text(&self.later).w(80).font_size(14.1))).w(160).h(96)}
}
#[test]
fn actual_failed_prepare_aborts_staged_raw_shapes_and_keeps_old_coherent_output() {
    let mut resources=ResourceContext::new(ResourceLimits {retained_payload_bytes:8*1024*1024,physical_roots:128,resource_records:128,backings_per_resource:16}).unwrap();
    let mut win=Win::recording_with_resources(AbortPage::new("old office first paragraph","old second paragraph"),options(),&mut resources).unwrap();
    let mut before=vec![0x005aa55a;160*96];let token=win.render_bgrx(&mut before).unwrap();win.presented(token).unwrap();
    let old_p=win.snapshot().unwrap().nodes;let old_ids=win.runtime().unwrap().artifacts.owned_resource_ids();assert_eq!(old_ids.len(),2);
    let old_staged=win.runtime().unwrap().artifacts.visits().staged_optional;
    let changed="replacement office first paragraph genuinely changes its wrapped geometry";
    let mut turn=win.edit_turn_with_resources(&mut resources).unwrap();
    turn.set(AbortPage::FIRST,changed.to_owned()).unwrap();turn.set(AbortPage::LATER,"bad\0control".to_owned()).unwrap();
    assert!(matches!(turn.finish(),Err(Error::Canvas(gpui_canvas::Error::UnsupportedControl('\0')))));
    assert!(win.runtime().unwrap().artifacts.visits().staged_optional>old_staged,"fixture must stage a new raw artifact before final preparation fails");
    assert_eq!(win.runtime().unwrap().artifacts.owned_resource_ids(),old_ids);assert_eq!(win.with_scene(|_,eligible|eligible).unwrap(),token);
    assert_eq!(win.snapshot().unwrap().nodes,old_p);
    let mut failed=vec![0x00a55aa5;160*96];assert_eq!(win.render_bgrx(&mut failed).unwrap(),token);assert_eq!(failed,before);
    // Explicit pressure may revoke optional caches, including accepted old raw
    // caches. Their weak IDs are not proof of surviving payloads; C/P is packed.
    resources.reclaim_optional(usize::MAX);for _ in 0..4 {resources.maintain(usize::MAX).unwrap();}assert_eq!(resources.stats().retained_payload_bytes,0);
    let mut after_pressure=vec![0x00abcdef;160*96];assert_eq!(win.render_bgrx(&mut after_pressure).unwrap(),token);assert_eq!(after_pressure,before);
    let repaired="repaired later paragraph";
    let mut turn=win.edit_turn_with_resources(&mut resources).unwrap();turn.set(AbortPage::LATER,repaired.to_owned()).unwrap();turn.finish().unwrap();
    let mut actual=vec![0x00123456;160*96];win.render_bgrx(&mut actual).unwrap();
    let mut cold=Win::with_options(AbortPage::new(changed,repaired),options()).unwrap();let mut expected=vec![0x00abcdef;160*96];cold.render_bgrx(&mut expected).unwrap();assert_eq!(actual,expected);
}

struct OwnerPage {show:Signal<bool>,caption:Signal<String>}
impl OwnerPage {
    const SHOW:Source<Self,bool>=Source::new(FieldId::new(71),"show",|m|&m.show,|m|&mut m.show);
    const CAPTION:Source<Self,String>=Source::new(FieldId::new(72),"caption",|m|&m.caption,|m|&mut m.caption);
    fn new(show:bool)->Self {Self {show:Signal::new(show),caption:Signal::new("office owner paragraph wraps as width changes".into())}}
}
impl View for OwnerPage {
    fn sources()->Sources<Self> {Sources::new().direct(Self::SHOW).direct(Self::CAPTION)}
    fn view(&self)->El<'_> {
        column(if *self.show {text(&self.caption).name("owner-text").w(80).font_size(14.1)} else {div().size(0)}).w(160).h(96)
    }
}
#[test]
fn width_only_turn_preserves_raw_owner_without_committing_unrelated_artifact_rows() {
    let mut resources=ResourceContext::new(ResourceLimits {retained_payload_bytes:8*1024*1024,physical_roots:128,resource_records:128,backings_per_resource:16}).unwrap();
    let mut win=Win::recording_with_resources(OwnerPage::new(true),options(),&mut resources).unwrap();
    let token=win.with_scene(|_,token|token).unwrap();win.presented(token).unwrap();
    let old=win.runtime().unwrap().artifacts.owned_resource_ids();assert_eq!(old.len(),1);let before=win.runtime().unwrap().artifacts.visits();
    let target=win.query().name("owner-text").one().unwrap();let mut turn=win.edit_turn_with_resources(&mut resources).unwrap();
    turn.set_property(target,crate::property::WIDTH,Contribution::Set(Some(40.))).unwrap();turn.finish().unwrap();
    assert_eq!(win.runtime().unwrap().artifacts.owned_resource_ids(),old);
    assert_eq!(win.runtime().unwrap().artifacts.visits().commit,before.commit,"known width changes must not sweep untouched raw owners");
    assert_eq!(win.runtime().unwrap().artifacts.visits().retire,before.retire);
}
#[test]
fn actual_removed_text_owner_retires_after_c_and_keeps_old_p_until_ack() {
    let mut resources=ResourceContext::new(ResourceLimits {retained_payload_bytes:8*1024*1024,physical_roots:128,resource_records:128,backings_per_resource:16}).unwrap();
    let mut win=Win::recording_with_resources(OwnerPage::new(true),options(),&mut resources).unwrap();
    let token=win.with_scene(|_,token|token).unwrap();win.presented(token).unwrap();let old_p=win.snapshot().unwrap().nodes;
    assert_eq!(win.runtime().unwrap().artifacts.owned_resource_ids().len(),1);
    let mut turn=win.edit_turn_with_resources(&mut resources).unwrap();turn.set(OwnerPage::SHOW,false).unwrap();turn.finish().unwrap();
    assert!(win.runtime().unwrap().artifacts.owned_resource_ids().is_empty());
    assert!(win.runtime().unwrap().artifacts.visits().retire>0,"actual producer retirement must be exercised");
    assert_eq!(win.snapshot().unwrap().nodes,old_p);
    let mut actual=vec![0x005aa55a;160*96];let next=win.render_bgrx(&mut actual).unwrap();assert_ne!(next,token);
    let mut cold=Win::with_options(OwnerPage::new(false),options()).unwrap();let mut expected=vec![0x00a55aa5;160*96];cold.render_bgrx(&mut expected).unwrap();assert_eq!(actual,expected);
    resources.reclaim_optional(usize::MAX);for _ in 0..4 {resources.maintain(usize::MAX).unwrap();}assert_eq!(resources.stats().retained_payload_bytes,0);
    win.presented(next).unwrap();
}

#[test]
fn optional_source_witness_decline_keeps_real_packed_output_and_disables_reuse() {
    let mut resources=ResourceContext::new(ResourceLimits {retained_payload_bytes:0,physical_roots:128,resource_records:128,backings_per_resource:16}).unwrap();
    let mut win=Win::recording_with_resources(model(),options(),&mut resources).unwrap();
    let runtime=win.runtime().unwrap();
    assert!(runtime.artifacts.owned_resource_ids().is_empty());
    assert_eq!(runtime.artifacts.visits().staged_optional,0);
    assert_eq!(resources.optional_owner_count(),0);
    let mut packed_sites=0;
    for site in runtime.texts.iter().filter_map(|site|site.as_ref()) {
        if let Some(packed)=&site.shaped {packed_sites+=1;assert!(packed.input.is_none());}
    }
    assert!(packed_sites>0,"decline must still produce an actual packed text site");
    assert_eq!(resources.stats().retained_payload_bytes,0,"one ledger has zero bytes for UTF8, font and raw roots alike");
    let mut actual=vec![0x00123456;160*96];win.render_bgrx(&mut actual).unwrap();
    let mut cold=Win::with_options(model(),options()).unwrap();let mut expected=vec![0x00abcdef;160*96];cold.render_bgrx(&mut expected).unwrap();assert_eq!(actual,expected);
    assert!(actual.iter().any(|pixel|*pixel!=actual[0]),"declined capture must still render visible text");
}
#[test]
fn accepted_packed_scene_survives_explicit_source_and_shape_cache_reclaim() {
    let mut resources=ResourceContext::new(ResourceLimits {retained_payload_bytes:8*1024*1024,physical_roots:128,resource_records:128,backings_per_resource:16}).unwrap();
    let mut win=Win::recording_with_resources(model(),options(),&mut resources).unwrap();
    assert!(!win.runtime().unwrap().artifacts.owned_resource_ids().is_empty());
    assert!(resources.optional_owner_count()>=2,"actual hook must retain source witness and shape owners");
    let mut before=vec![0x005aa55a;160*96];let token=win.render_bgrx(&mut before).unwrap();win.presented(token).unwrap();let p=win.snapshot().unwrap().nodes;
    assert!(resources.reclaim_optional(usize::MAX).removed>=2);
    for _ in 0..4 {resources.maintain(usize::MAX).unwrap();}assert_eq!(resources.stats().retained_payload_bytes,0);
    assert_eq!(win.snapshot().unwrap().nodes,p);
    let mut after=vec![0x00a55aa5;160*96];assert_eq!(win.render_bgrx(&mut after).unwrap(),token);assert_eq!(after,before);
    let mut cold=Win::with_options(model(),options()).unwrap();let mut expected=vec![0x00123456;160*96];cold.render_bgrx(&mut expected).unwrap();assert_eq!(after,expected);
}

#[test]
fn accounted_custom_font_constructor_preserves_exact_face_and_cold_output() {
    let font=gpui_canvas::FontFace::new(include_bytes!("../../../canvas/assets/NotoSans-default.ttf")).unwrap();
    let page=||DetachedPage {value:Signal::new(String::from("office custom immutable font paragraph wraps"))};
    let mut resources=ResourceContext::new(ResourceLimits {retained_payload_bytes:8*1024*1024,physical_roots:128,resource_records:128,backings_per_resource:16}).unwrap();
    let mut win=Win::recording_with_font_and_resources(page(),options(),font.clone(),&mut resources).unwrap();
    let text=win.runtime().unwrap().text.as_ref().unwrap();
    assert!(text.font.as_ref().unwrap().same_face(&font));
    assert!(text.system.as_ref().unwrap().font_face().same_face(&font));
    assert!(!win.runtime().unwrap().artifacts.owned_resource_ids().is_empty(),"constructor must actually enter scoped shape path");
    let mut actual=vec![0x00123456;160*96];win.render_bgrx(&mut actual).unwrap();
    let mut cold=Win::recording_with_font(page(),options(),font).unwrap();let mut expected=vec![0x00abcdef;160*96];cold.render_bgrx(&mut expected).unwrap();assert_eq!(actual,expected);
}
