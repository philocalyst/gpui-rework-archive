//! Canonical C progression is independent of public draw-token/ACK progression.
use super::*;
use crate::{El,FieldId,Signal,Source,Sources,SemanticText,div,text,rgb};
use change_model::{BatchStamp,Dependencies,SceneRevision,FullReasons};
struct Page {name:Signal<String>,map:Signal<Affine>,color:Signal<Color>}
impl Page {
    const NAME:Source<Self,String>=Source::new(FieldId::new(51),"name",|m|&m.name,|m|&mut m.name);
    const MAP:Source<Self,Affine>=Source::new(FieldId::new(52),"map",|m|&m.map,|m|&mut m.map);
    const COLOR:Source<Self,Color>=Source::new(FieldId::new(53),"color",|m|&m.color,|m|&mut m.color);
    fn new(name:&str,map:Affine,color:Color)->Self{Self{name:Signal::new(name.into()),map:Signal::new(map),color:Signal::new(color)}}
}
impl View for Page {
    fn sources()->Sources<Self>{Sources::new().direct(Self::NAME).direct(Self::MAP).direct(Self::COLOR)}
    fn view(&self)->El<'_>{div().w(64).h(24).name(&self.name).bg(&self.color).transform(&self.map).child(text("label").font_size(8))}
}
const SIZE:[u32;2]=[96,64];
fn mounted()->Win<Page>{let mut win=Win::recording(Page::new("initial",Affine::IDENTITY,rgb(0xb04020)),WindowOptions{size:SIZE,..Default::default()}).unwrap();ack(&mut win);win}
fn token(win:&Win<Page>)->PresentationToken{win.with_scene(|_,token|token).unwrap()}
fn stamp(win:&Win<Page>)->BatchStamp{win.with_change_scene(|frame,_|frame.stamp()).unwrap()}
fn ack(win:&mut Win<Page>){win.presented(token(win)).unwrap();}
fn pixels(win:&mut Win<Page>,size:[u32;2])->Vec<u32>{let mut out=vec![0;size[0] as usize*size[1] as usize];win.render_bgrx(&mut out).unwrap();out}
fn rows(win:&Win<Page>)->Vec<SnapshotNode>{let mut rows=win.snapshot().unwrap().nodes;for row in &mut rows{row.identity=0;row.target=None;}rows}
fn cold(win:&mut Win<Page>,name:&str,map:Affine,color:Color,size:[u32;2]) {
    let mut reference=Win::with_size(Page::new(name,map,color),size[0],size[1]).unwrap();
    win.role(crate::Role::Generic).name(name).one().unwrap();
    assert_eq!(rows(win),rows(&reference));assert_eq!(pixels(win,size),pixels(&mut reference,size));
}
fn target_index(win:&Win<Page>)->(Dependencies,SceneRevision) {
    let rt=win.runtime().unwrap();let revision=stamp(win).to;
    let mut graph=Dependencies::new(128);graph.reset(revision);
    for node in &rt.nodes {
        let parent=node.parent().index().map(|index|rt.nodes[index].identity());
        changes::register_node(&mut graph,rt.sites.namespace(),node.identity,parent,node.text_slot().0!=u32::MAX,node.kind()==NodeKind::List);
    }
    assert!(graph.finish(rt.nodes.len()));(graph,revision)
}
// This consumes actual common dependency edges, not an image-completion lease.
fn consume(win:&Win<Page>,graph:&mut Dependencies,cursor:&mut SceneRevision,non_graphical:bool) {
    win.with_change_scene(|frame,_| {
        assert_eq!(frame.stamp().from,Some(*cursor));
        assert_eq!(frame.stamp().to.sequence.get(),cursor.sequence.get()+1);
        let invalidated=graph.invalidate(frame.batch());
        assert!(!invalidated.full().contains(FullReasons::REVISION_GAP));
        if non_graphical {
            assert!(invalidated.full().is_empty());
            assert!(frame.checked_slot_mutation().unwrap().changed_slots().is_empty());
            assert!(frame.batch().entries.iter().all(|change|change.facets.is_non_graphical()));
        }
        *cursor=frame.stamp().to;graph.rebase(*cursor);
    }).unwrap();
}
#[test]
fn metadata_and_graphical_publications_share_c_history_without_replacing_draw_ack_authority() {
    let mut win=mounted();let (mut target,mut cursor)=target_index(&win);let first=token(&win);
    let red=rgb(0xb04020);let blue=rgb(0x2050b0);
    win.reset_counters().unwrap();win.set(Page::NAME,"one".into()).unwrap();
    consume(&win,&mut target,&mut cursor,true);assert_eq!(token(&win),first);
    assert_eq!(win.counters().descriptions,0);assert_eq!(win.counters().layout_runs,0);assert_eq!(win.counters().paint_passes,0);
    win.presented(first).unwrap();cold(&mut win,"one",Affine::IDENTITY,red,SIZE);
    // Checked paint after metadata C: C sequence and draw sequence now differ.
    win.reset_counters().unwrap();win.set(Page::COLOR,blue).unwrap();let painted=token(&win);
    assert_ne!(painted,first);consume(&win,&mut target,&mut cursor,false);
    assert_eq!(win.counters().paint_passes,0);
    win.with_change_scene(|frame,draw|{assert_eq!(frame.checked_slot_mutation().unwrap().changed_slots().len(),1);assert_ne!(frame.stamp().to.sequence,draw.sequence);}).unwrap();
    win.set(Page::NAME,"candidate".into()).unwrap();consume(&win,&mut target,&mut cursor,true);
    assert_eq!(token(&win),painted);
    assert_eq!(win.role(crate::Role::Generic).name("one").count().unwrap(),1);
    assert_eq!(win.role(crate::Role::Generic).name("candidate").count().unwrap(),0);
    assert!(matches!(win.role(crate::Role::Generic).name("one").one(),Err(Error::PresentationStale)));
    win.presented(painted).unwrap();cold(&mut win,"candidate",Affine::IDENTITY,blue,SIZE);
    // Two logical metadata admissions form one canonical C, without numeric S-1 inference.
    {let mut turn=win.edit_turn().unwrap();turn.set(Page::NAME,"two".into()).unwrap();turn.set(Page::NAME,"three".into()).unwrap();turn.finish().unwrap();}
    consume(&win,&mut target,&mut cursor,true);assert_eq!(token(&win),painted);
    win.presented(painted).unwrap();cold(&mut win,"three",Affine::IDENTITY,blue,SIZE);
    let map=Affine::translation(4.,2.);win.set(Page::MAP,map).unwrap();let eligible=token(&win);
    consume(&win,&mut target,&mut cursor,false);let complete=stamp(&win);let old_pixels=pixels(&mut win,SIZE);
    assert!(win.set(Page::MAP,Affine::scale(0.,1.)).is_err());
    let paint_before=win.counters().paint_passes;
    win.set(Page::NAME,"failed-prefix".into()).unwrap();
    assert_eq!(win.counters().paint_passes,paint_before,"metadata must not retry failed glyph/layout preparation");
    assert_eq!(stamp(&win),complete);assert_eq!(token(&win),eligible);assert_eq!(pixels(&mut win,SIZE),old_pixels);
    win.presented(eligible).unwrap();
    assert_eq!(win.snapshot().unwrap().presentation_epoch,complete.source_epoch);
    assert_eq!(win.role(crate::Role::Generic).name("three").count().unwrap(),1);
    assert_eq!(win.role(crate::Role::Generic).name("failed-prefix").count().unwrap(),0);
    assert!(matches!(win.role(crate::Role::Generic).name("three").one(),Err(Error::PresentationStale)));
    let repaired=Affine::translation(8.,3.);win.set(Page::MAP,repaired).unwrap();
    consume(&win,&mut target,&mut cursor,false);ack(&mut win);cold(&mut win,"failed-prefix",repaired,blue,SIZE);
    let source=stamp(&win).source_epoch;let prior=stamp(&win).to;let resized=[112,80];
    win.resize(resized).unwrap();consume(&win,&mut target,&mut cursor,false);
    assert_eq!(stamp(&win).source_epoch,source);assert_ne!(stamp(&win).to,prior);
    ack(&mut win);cold(&mut win,"failed-prefix",repaired,blue,resized);
    let last_draw=token(&win);win.reset_counters().unwrap();win.set(Page::NAME,"last".into()).unwrap();
    consume(&win,&mut target,&mut cursor,true);assert_eq!(token(&win),last_draw);assert_eq!(win.counters().paint_passes,0);
    win.presented(last_draw).unwrap();cold(&mut win,"last",repaired,blue,resized);
    let final_stamp=stamp(&win);win.settle().unwrap();assert_eq!(stamp(&win),final_stamp);
    assert_ne!(final_stamp.to.sequence,last_draw.sequence);assert_ne!(final_stamp.source_epoch,final_stamp.snapshot_epoch);
}
#[test]
fn missing_an_intermediate_metadata_c_is_a_real_dependency_predecessor_gap() {
    let mut win=mounted();let (target,old)=target_index(&win);
    win.set(Page::NAME,"skipped".into()).unwrap();win.set(Page::NAME,"latest".into()).unwrap();
    win.with_change_scene(|frame,_| {
        assert_ne!(frame.stamp().from,Some(old));
        assert!(target.invalidate(frame.batch()).full().contains(FullReasons::REVISION_GAP));
    }).unwrap();
}
#[test]
fn canonical_sequence_exhaustion_preserves_canvas_metadata_and_old_draw_token() {
    let mut win=mounted();let draw=token(&win);let before=pixels(&mut win,SIZE);
    {
        let mut rt=win.runtime_borrow().unwrap();let old=rt.changes.base().unwrap();
        let last=NonZeroU64::new(u64::MAX).unwrap();
        let stamp=BatchStamp{from:Some(old),to:SceneRevision{owner:old.owner,sequence:last},source_epoch:rt.source_epoch,snapshot_epoch:u64::MAX};
        let closed=changes::close_dependencies(&rt.dependencies,None,&rt.changes);
        let state=&mut *rt.runtime;
        let pending=state.changes.prepare(stamp).unwrap().with_closed(closed).unwrap();
        let ticket=state.sites.issuer_mut().prepare(stamp).unwrap();
        // A genuine checked zero-edit publication reaches the boundary; no
        // detached counter is forged and every authority records the same C.
        state.canvas.commit_non_graphical_publication(pending,ticket).unwrap();state.dependencies.rebase(stamp.to);
    }
    let last=stamp(&win);let source=win.snapshot().unwrap().source_epoch;
    let target=win.role(crate::Role::Generic).name("initial").one().unwrap();
    let result=win.set_semantic(target,SemanticText::Name,Contribution::Set(Some("rejected".into())));
    match result {Err(SetError::Rejected{error:Error::EpochExhausted,value:Contribution::Set(Some(value))})=>assert_eq!(value,"rejected"),other=>panic!("expected pre-admission canonical exhaustion: {other:?}")}
    assert_eq!(stamp(&win),last);assert_eq!(token(&win),draw);assert_eq!(win.snapshot().unwrap().source_epoch,source);
    assert_eq!(pixels(&mut win,SIZE),before);win.presented(draw).unwrap();
    win.role(crate::Role::Generic).name("initial").one().unwrap();
}
