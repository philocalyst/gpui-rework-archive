use gpui_canvas::{Affine,Canvas,Color,ColorConfig,ClipShape,PaintColor,PaintEdit,PublicationError,Rect,SlotEdit,OutputProfile,PixelFormat,SdrMapping};
use gpui_reactivity_core::change::{BatchStamp,Change,Facet,Facets,FrameIssuer,GroupSpan,Journal,SceneGroups,SceneRevision,Scope,SiteId,Support};
use std::num::NonZeroU64 as Nz;
fn stamp(issuer:&FrameIssuer,journal:&Journal,sequence:u64)->BatchStamp {
    BatchStamp {from:journal.base(),to:SceneRevision {owner:issuer.owner(),sequence:Nz::new(sequence).unwrap()},source_epoch:sequence,snapshot_epoch:sequence}
}
fn groups(stamp:BatchStamp,count:usize)->SceneGroups {
    SceneGroups::new(stamp.to,stamp.source_epoch,stamp.snapshot_epoch,
        vec![GroupSpan {local:Nz::new(1).unwrap(),parent:None,draws:0..count as u32}],count).unwrap()
}
fn initial(canvas:&mut Canvas,issuer:&mut FrameIssuer,journal:&mut Journal)->gpui_canvas::PaintSlot {
    let stamp=stamp(issuer,journal,1);
    let mut stage=canvas.stage();stage.clear(Color::BLACK);
    let slot=stage.paint_slot(PaintColor::new(Color::WHITE)).unwrap();
    stage.fill_rect_slot(Rect::new(1.,1.,10.,10.),Affine::IDENTITY,Rect::new(0.,0.,16.,16.),slot).unwrap();
    let groups=groups(stamp,stage.draw_count());
    let changes=journal.prepare(stamp).unwrap();let publication=issuer.prepare(stamp).unwrap();
    stage.commit_publication(changes,publication,groups).unwrap();slot
}
fn setup()->(Canvas,FrameIssuer,Journal,gpui_canvas::PaintSlot) {
    let mut issuer=FrameIssuer::new().unwrap();let mut journal=Journal::new(issuer.owner(),16);
    let mut canvas=Canvas::recording(16,16,ColorConfig::default()).unwrap();let slot=initial(&mut canvas,&mut issuer,&mut journal);
    (canvas,issuer,journal,slot)
}
fn record(journal:&mut Journal,owner:Nz,facet:Facet) {
    journal.record(Change {site:SiteId::from_monotonic(owner,Nz::new(1).unwrap()),facets:Facets::one(facet),scope:Scope::Site,before:Support::Pending,after:Support::Pending});
}
#[test]
fn owned_publication_pairs_exact_scene_metadata_and_never_rebinds_foreign_same_length() {
    let (canvas,_,_,_)=setup();let (foreign,_,_,_)=setup();
    let view=canvas.accepted_scene().unwrap();let other=foreign.accepted_scene().unwrap();
    assert_eq!(view.scene().draws().len(),other.scene().draws().len());
    assert!(view.matches_scene(view.scene()));assert!(view.clone().matches_scene(view.scene()));
    assert!(!view.matches_scene(other.scene()),"same-count foreign command/resource owner");
    assert_eq!(view.stamp(),view.batch().stamp);assert_eq!(view.groups().revision(),view.stamp().to);
    let mut changed=view.scene();changed.width+=1;assert!(!view.matches_scene(changed));
    changed=view.scene();changed.height+=1;assert!(!view.matches_scene(changed));
    for channel in 0..4 {changed=view.scene();changed.clear[channel]=f32::from_bits(changed.clear[channel].to_bits()^1);assert!(!view.matches_scene(changed));}
    changed=view.scene();changed.clear[0]=-0.;assert!(!view.matches_scene(changed));
    changed=view.scene();changed.color_config.reference_white_nits+=1.;assert!(!view.matches_scene(changed));
    changed=view.scene();changed.color_config.profile=OutputProfile::DisplayP3;assert!(!view.matches_scene(changed));
    changed=view.scene();changed.color_config.format=PixelFormat::Rgba16Float;assert!(!view.matches_scene(changed));
    changed=view.scene();changed.color_config.mapping=SdrMapping::ReinhardPerChannel {exposure:1.};assert!(!view.matches_scene(changed));
}
#[test]
fn dropped_failed_stage_and_slot_admission_preserve_old_bound_c_and_pending_journal() {
    let (mut canvas,mut issuer,mut journal,slot)=setup();let old=canvas.accepted_scene().unwrap().stamp();
    {let mut stage=canvas.stage();stage.clear(Color::WHITE);}
    assert_eq!(canvas.accepted_scene().unwrap().stamp(),old);
    let alpha=[SlotEdit::new(slot,PaintColor::new(Color::rgba(4,5,6,80)))];
    assert!(canvas.prepare_slots(&alpha).is_err());assert_eq!(canvas.accepted_scene().unwrap().stamp(),old);
    let edit=[SlotEdit::new(slot,PaintColor::new(Color::rgba(4,5,6,255)))];
    drop(canvas.prepare_slots(&edit).unwrap());assert_eq!(canvas.accepted_scene().unwrap().stamp(),old);
    record(&mut journal,issuer.owner(),Facet::Paint);let next=stamp(&issuer,&journal,2);
    // Valid privately checked metadata for DIFFERENT draw count must reject
    // before committing stage, draining journal or advancing issuer.
    let wrong=groups(next,2);let stage=canvas.stage();
    let changes=journal.prepare(next).unwrap();let publication=issuer.prepare(next).unwrap();
    assert_eq!(stage.commit_publication(changes,publication,wrong),Err(PublicationError::Metadata));
    assert_eq!(canvas.accepted_scene().unwrap().stamp(),old);assert_eq!(journal.base(),Some(old.to));
    let changes=journal.prepare(next).unwrap();assert_eq!(changes.batch().entries.len(),1);
    let publication=issuer.prepare(next).unwrap();
    canvas.prepare_slots(&edit).unwrap().commit_publication(changes,publication).unwrap();
    assert_eq!(canvas.accepted_scene().unwrap().stamp().to,next.to);
    assert_eq!(canvas.accepted_scene().unwrap().groups().draw_count(),1);
    let mut actual=vec![0;256];canvas.render_bgrx(&mut actual).unwrap();
    let mut cold=Canvas::recording(16,16,ColorConfig::default()).unwrap();cold.clear(Color::BLACK);
    cold.fill_rect(Rect::new(1.,1.,10.,10.),Affine::IDENTITY,Rect::new(0.,0.,16.,16.),Color::rgba(4,5,6,255)).unwrap();
    let mut expected=vec![0;256];cold.render_bgrx(&mut expected).unwrap();assert_eq!(actual,expected);
}
#[test]
fn successful_direct_canonical_mutations_revoke_but_render_and_strategy_do_not() {
    let (mut canvas,_,_,_)=setup();let stamp=canvas.accepted_scene().unwrap().stamp();
    let mut output=vec![0;256];canvas.render_bgrx(&mut output).unwrap();canvas.set_tile_proofs(false);
    let _=canvas.try_pixels().unwrap();assert_eq!(canvas.accepted_scene().unwrap().stamp(),stamp);
    canvas.paint_slot(PaintColor::new(Color::BLACK)).unwrap();assert_eq!(canvas.accepted_scene().err(),Some(PublicationError::NoPublication));
    let (mut canvas,_,_,_)=setup();canvas.create_clip(None,ClipShape::Rect(Rect::new(0.,0.,8.,8.)),Affine::IDENTITY).unwrap();assert!(canvas.accepted_scene().is_err());
    let (mut canvas,_,_,_)=setup();let key=canvas.prepared_scene().paint_index(0).unwrap();
    canvas.prepare_paint(&[PaintEdit::new(key,Color::BLACK)]).unwrap().commit();assert!(canvas.accepted_scene().is_err());
    let (mut canvas,_,_,slot)=setup();canvas.prepare_slots(&[SlotEdit::new(slot,PaintColor::new(Color::BLACK))]).unwrap().commit();assert!(canvas.accepted_scene().is_err());
    let (mut canvas,_,_,_)=setup();canvas.fill_rect(Rect::new(0.,0.,1.,1.),Affine::IDENTITY,Rect::new(0.,0.,16.,16.),Color::BLACK).unwrap();assert!(canvas.accepted_scene().is_err());
    let (mut canvas,_,_,_)=setup();canvas.stage().commit();assert!(canvas.accepted_scene().is_err());
    let (mut canvas,_,_,_)=setup();canvas.clear(Color::BLACK);assert!(canvas.accepted_scene().is_err());
}

#[test]
fn actual_changed_slot_cannot_publish_as_empty_or_nonpaint_journal() {
    for facet in [None,Some(Facet::Hit),Some(Facet::Semantics)] {
        let (mut canvas,mut issuer,mut journal,slot)=setup();let old=canvas.accepted_scene().unwrap().stamp();
        if let Some(facet)=facet {record(&mut journal,issuer.owner(),facet);}
        let next=stamp(&issuer,&journal,2);let edits=[SlotEdit::new(slot,PaintColor::new(Color::BLACK))];
        let changes=journal.prepare(next).unwrap();let publication=issuer.prepare(next).unwrap();
        let result=canvas.prepare_slots(&edits).unwrap().commit_publication(changes,publication);
        assert_eq!(result,Err(PublicationError::NonPaintMutation));
        assert_eq!(canvas.accepted_scene().unwrap().stamp(),old);assert_eq!(journal.base(),Some(old.to));
    }
}
#[test]
fn shared_material_requires_every_actual_owner_and_keeps_owned_witness_after_failed_newer() {
    let mut issuer=FrameIssuer::new().unwrap();let owner=issuer.owner();let mut journal=Journal::new(owner,16);
    let mut canvas=Canvas::recording(16,16,ColorConfig::default()).unwrap();let first=stamp(&issuer,&journal,1);
    let mut stage=canvas.stage();stage.clear(Color::BLACK);let slot=stage.paint_slot(PaintColor::new(Color::WHITE)).unwrap();
    for x in [0.,8.] {stage.fill_rect_slot(Rect::new(x,0.,8.,16.),Affine::IDENTITY,Rect::new(0.,0.,16.,16.),slot).unwrap();}
    let metadata=SceneGroups::new(first.to,1,1,vec![
        GroupSpan {local:Nz::new(1).unwrap(),parent:None,draws:0..1},
        GroupSpan {local:Nz::new(2).unwrap(),parent:None,draws:1..2},
    ],2).unwrap();
    stage.commit_publication(journal.prepare(first).unwrap(),issuer.prepare(first).unwrap(),metadata).unwrap();
    assert_eq!(canvas.accepted_scene().unwrap().material_users(slot).unwrap().count(),2);
    for sequence in 2..=4 {
        record(&mut journal,owner,Facet::Paint);let next=stamp(&issuer,&journal,sequence);
        let edits=[SlotEdit::new(slot,PaintColor::new(Color::rgba(sequence as u8,30,50,255)))];
        let changes=journal.prepare(next).unwrap();let publication=issuer.prepare(next).unwrap();
        assert_eq!(canvas.prepare_slots(&edits).unwrap().commit_publication(changes,publication),Err(PublicationError::UncoveredPaint),"subset Paint does not cover shared second owner");
        assert_eq!(canvas.accepted_scene().unwrap().stamp().to.sequence.get(),sequence-1);
        if sequence>2 {
            let old=canvas.accepted_scene().unwrap().checked_slot_mutation().unwrap();
            assert_eq!(old.base().sequence.get(),sequence-2);assert_eq!(old.changed_slots(),&[slot]);
        }
        journal.record(Change {site:SiteId::from_monotonic(owner,Nz::new(2).unwrap()),facets:Facets::one(Facet::Paint),scope:Scope::Site,before:Support::Pending,after:Support::Pending});
        let changes=journal.prepare(next).unwrap();let publication=issuer.prepare(next).unwrap();
        let plan=canvas.prepare_slots(&edits).unwrap();
        if sequence==4 {
            // Both witness buffers are warm; all required guard allocations are
            // outside this measured commit. This is an allocation test, no timer.
            let allocations=allocation_counter::measure(|| {plan.commit_publication(changes,publication).unwrap();});
            assert_eq!((allocations.count_total,allocations.bytes_total),(0,0));
        }else{plan.commit_publication(changes,publication).unwrap();}
        let view=canvas.accepted_scene().unwrap();let witness=view.checked_slot_mutation().unwrap();
        assert!(!view.is_full_snapshot());assert_eq!(witness.base(),next.from.unwrap());
        assert_eq!(witness.bank_origin(),first.to);assert_eq!(witness.changed_slots(),&[slot]);
        let mut actual=vec![0;256];canvas.render_bgrx(&mut actual).unwrap();
        let mut cold=Canvas::recording(16,16,ColorConfig::default()).unwrap();cold.clear(Color::BLACK);
        cold.fill_rect(Rect::new(0.,0.,16.,16.),Affine::IDENTITY,Rect::new(0.,0.,16.,16.),Color::rgba(sequence as u8,30,50,255)).unwrap();
        let mut expected=vec![0;256];cold.render_bgrx(&mut expected).unwrap();assert_eq!(actual,expected);
    }
}
#[test]
fn truncated_paint_plus_hidden_layout_requires_full_snapshot_before_publication() {
    let mut issuer=FrameIssuer::new().unwrap();let owner=issuer.owner();let mut journal=Journal::new(owner,1);
    let mut canvas=Canvas::recording(16,16,ColorConfig::default()).unwrap();let slot=initial(&mut canvas,&mut issuer,&mut journal);
    let old=canvas.accepted_scene().unwrap().stamp();record(&mut journal,owner,Facet::Paint);
    journal.record(Change {site:SiteId::from_monotonic(owner,Nz::new(2).unwrap()),facets:Facets::one(Facet::Layout),scope:Scope::Site,before:Support::Pending,after:Support::Pending});
    let next=stamp(&issuer,&journal,2);let edits=[SlotEdit::new(slot,PaintColor::new(Color::BLACK))];
    let changes=journal.prepare(next).unwrap();assert!(changes.batch().full.contains(gpui_reactivity_core::change::FullReasons::CAPACITY));
    assert_eq!(changes.batch().entries.len(),1);let publication=issuer.prepare(next).unwrap();
    assert_eq!(canvas.prepare_slots(&edits).unwrap().commit_publication(changes,publication),Err(PublicationError::IncompleteChanges));
    assert_eq!(canvas.accepted_scene().unwrap().stamp(),old);assert_eq!(journal.base(),Some(old.to));
    let mut stage=canvas.stage();stage.clear(Color::BLACK);
    stage.fill_rect(Rect::new(2.,2.,12.,12.),Affine::IDENTITY,Rect::new(0.,0.,16.,16.),Color::WHITE).unwrap();
    let metadata=groups(next,stage.draw_count());
    stage.commit_publication(journal.prepare(next).unwrap(),issuer.prepare(next).unwrap(),metadata).unwrap();
    let view=canvas.accepted_scene().unwrap();assert!(view.is_full_snapshot());assert!(view.checked_slot_mutation().is_none());
    assert_eq!(view.stamp().to,next.to);assert_eq!(view.scene().draws().next().unwrap().local_rect,Rect::new(2.,2.,12.,12.));
}
