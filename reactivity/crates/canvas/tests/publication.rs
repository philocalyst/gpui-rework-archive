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
#[test]
fn precommit_witness_borrows_actual_changed_slots_and_all_users_without_mutation_or_allocation() {
    let (mut canvas,_,_,slot)=setup();let stamp=canvas.accepted_scene().unwrap().stamp();
    for (color,count) in [(Color::WHITE,0),(Color::BLACK,1)] {
        let edits=[SlotEdit::new(slot,PaintColor::new(color))];let plan=canvas.prepare_slots(&edits).unwrap();
        let measured=allocation_counter::measure(|| {
            let witness=plan.prepared_mutation().unwrap();assert_eq!(witness.base(),stamp.to);
            assert_eq!(witness.bank_origin(),stamp.to);
            assert_eq!(witness.changed_slots().count(),count);
            assert_eq!(witness.actual_users(slot).unwrap().count(),1);
        });
        assert_eq!((measured.count_total,measured.bytes_total),(0,0));drop(plan);
        assert_eq!(canvas.accepted_scene().unwrap().stamp(),stamp);
    }
}
#[test]
fn stored_closed_dependencies_cover_actual_reader_not_just_raw_paint_source() {
    use gpui_reactivity_core::change::{Artifact,Dependencies,DependencyNode,Phase};
    let (mut canvas,mut issuer,mut journal,slot)=setup();let old=canvas.accepted_scene().unwrap().stamp();
    assert!(canvas.accepted_scene().unwrap().closed_dependencies().is_none());
    let source=SiteId::from_monotonic(issuer.owner(),Nz::new(2).unwrap());
    let reader=SiteId::from_monotonic(issuer.owner(),Nz::new(1).unwrap());
    let mut graph=Dependencies::new(128);graph.reset(old.to);graph.register_site(source);graph.register_site(reader);
    graph.depends_on(Artifact {site:reader,phase:Phase::Material},Artifact {site:source,phase:Phase::Material});
    assert!(graph.finish(2));
    journal.record(Change {site:source,facets:Facets::one(Facet::Paint),scope:Scope::Site,before:Support::Pending,after:Support::Pending});
    let closed=graph.invalidate_pending(&journal);let next=stamp(&issuer,&journal,2);
    let edits=[SlotEdit::new(slot,PaintColor::new(Color::BLACK))];let plan=canvas.prepare_slots(&edits).unwrap();
    let witness=plan.prepared_mutation().unwrap();assert_eq!(witness.actual_users(slot).unwrap().next(),Some(reader));drop(witness);
    let changes=journal.prepare(next).unwrap().with_closed(closed).unwrap();
    assert!(changes.closed_dependencies().unwrap().artifacts().contains(&DependencyNode::Site(Artifact {site:reader,phase:Phase::Raster})));
    plan.commit_publication(changes,issuer.prepare(next).unwrap()).unwrap();
    let view=canvas.accepted_scene().unwrap();let closed=view.closed_dependencies().unwrap();
    assert_eq!(closed.stamp(),view.stamp());assert!(closed.full().is_empty());
    assert!(closed.artifacts().contains(&DependencyNode::Site(Artifact {site:reader,phase:Phase::Material})));
    assert_eq!(view.checked_slot_mutation().unwrap().changed_slots(),&[slot]);
}
#[test]
fn paint_source_with_closed_layout_dependency_cannot_retarget_old_geometry() {
    use gpui_reactivity_core::change::{Artifact,Dependencies,Phase};
    let (mut canvas,mut issuer,mut journal,slot)=setup();let old=canvas.accepted_scene().unwrap().stamp();
    let source=SiteId::from_monotonic(issuer.owner(),Nz::new(2).unwrap());let reader=SiteId::from_monotonic(issuer.owner(),Nz::new(1).unwrap());
    let mut graph=Dependencies::new(128);graph.reset(old.to);graph.register_site(source);graph.register_site(reader);
    graph.depends_on(Artifact {site:reader,phase:Phase::Layout},Artifact {site:source,phase:Phase::Material});assert!(graph.finish(2));
    journal.record(Change {site:source,facets:Facets::one(Facet::Paint),scope:Scope::Site,before:Support::Pending,after:Support::Pending});
    let closed=graph.invalidate_pending(&journal);let next=stamp(&issuer,&journal,2);
    let changes=journal.prepare(next).unwrap().with_closed(closed).unwrap();let publication=issuer.prepare(next).unwrap();
    let edits=[SlotEdit::new(slot,PaintColor::new(Color::BLACK))];
    assert_eq!(canvas.prepare_slots(&edits).unwrap().commit_publication(changes,publication),Err(PublicationError::IncompleteChanges));
    assert_eq!(canvas.accepted_scene().unwrap().stamp(),old);assert_eq!(journal.base(),Some(old.to));
}
#[test]
fn ordinary_alpha_change_rebuilds_snapshot_and_cannot_reuse_old_opaque_cut() {
    let mut issuer=FrameIssuer::new().unwrap();let mut journal=Journal::new(issuer.owner(),16);
    let mut canvas=Canvas::recording(32,32,ColorConfig::default()).unwrap();
    let clip=Rect::new(0.,0.,32.,32.);let mut old_slot=None;
    for sequence in 1..=2 {
        let next=stamp(&issuer,&journal,sequence);let alpha=if sequence==1 {255}else{128};
        if sequence==2 {
            record(&mut journal,issuer.owner(),Facet::Paint);
            let edit=[SlotEdit::new(old_slot.unwrap(),PaintColor::new(Color::rgba(0,0,255,alpha)))];
            assert!(canvas.prepare_slots(&edit).is_err(),"same-alpha route must NOT certify opacity change");
            assert_eq!(canvas.accepted_scene().unwrap().stamp().to.sequence.get(),1);
        }
        let mut stage=canvas.stage();stage.clear(Color::BLACK);
        stage.fill_rect(clip,Affine::IDENTITY,clip,Color::rgba(255,0,0,255)).unwrap();
        let slot=stage.paint_slot(PaintColor::new(Color::rgba(0,0,255,alpha))).unwrap();
        stage.fill_rect_slot(clip,Affine::IDENTITY,clip,slot).unwrap();old_slot=Some(slot);
        let metadata=groups(next,stage.draw_count());
        stage.commit_publication(journal.prepare(next).unwrap(),issuer.prepare(next).unwrap(),metadata).unwrap();
        assert!(canvas.accepted_scene().unwrap().is_full_snapshot());
        let mut actual=vec![0;1024];canvas.render_bgrx(&mut actual).unwrap();
        let mut cold=Canvas::recording(32,32,ColorConfig::default()).unwrap();cold.clear(Color::BLACK);
        cold.fill_rect(clip,Affine::IDENTITY,clip,Color::rgba(255,0,0,255)).unwrap();
        cold.fill_rect(clip,Affine::IDENTITY,clip,Color::rgba(0,0,255,alpha)).unwrap();
        let mut expected=vec![0;1024];cold.render_bgrx(&mut expected).unwrap();assert_eq!(actual,expected);
        if sequence==1 {assert!(canvas.stats().full_rect_tiles>0);}else{assert!(!canvas.stats().bins_reused);}
    }
}
#[test]
fn ordinary_image_alpha_revision_is_new_material_snapshot_with_complete_cold_pixels() {
    use gpui_canvas::{AlphaMode,Image,ImageProfile,ImageSampling};
    let mut issuer=FrameIssuer::new().unwrap();let mut journal=Journal::new(issuer.owner(),16);
    let mut canvas=Canvas::recording(32,32,ColorConfig::default()).unwrap();let clip=Rect::new(0.,0.,32.,32.);
    let mut prior=None;
    for sequence in 1..=2 {
        let alpha=if sequence==1 {255}else{80};let image=Image::rgba8(1,1,ImageProfile::Srgb,AlphaMode::Straight,vec![0,0,255,alpha].into_boxed_slice()).unwrap();
        if let Some(old)=prior {assert_ne!(image.key(),old);}prior=Some(image.key());
        let next=stamp(&issuer,&journal,sequence);let mut stage=canvas.stage();stage.clear(Color::BLACK);
        stage.fill_rect(clip,Affine::IDENTITY,clip,Color::WHITE).unwrap();stage.draw_image(&image,clip,Affine::IDENTITY,clip,ImageSampling::Nearest).unwrap();
        let metadata=groups(next,stage.draw_count());
        stage.commit_publication(journal.prepare(next).unwrap(),issuer.prepare(next).unwrap(),metadata).unwrap();
        let view=canvas.accepted_scene().unwrap();assert!(view.is_full_snapshot());assert!(view.checked_slot_mutation().is_none());
        let mut actual=vec![0;1024];canvas.render_bgrx(&mut actual).unwrap();
        let mut cold=Canvas::recording(32,32,ColorConfig::default()).unwrap();cold.clear(Color::BLACK);
        cold.fill_rect(clip,Affine::IDENTITY,clip,Color::WHITE).unwrap();cold.draw_image(&image,clip,Affine::IDENTITY,clip,ImageSampling::Nearest).unwrap();
        let mut expected=vec![0;1024];cold.render_bgrx(&mut expected).unwrap();assert_eq!(actual,expected);
        assert!(!canvas.stats().bins_reused);
    }
}
#[test]
fn material_source_with_closed_primitive_content_dependency_requires_new_snapshot() {
    use gpui_reactivity_core::change::{Artifact,Dependencies,Phase};
    let (mut canvas,mut issuer,mut journal,slot)=setup();let old=canvas.accepted_scene().unwrap().stamp();
    let source=SiteId::from_monotonic(issuer.owner(),Nz::new(2).unwrap());let reader=SiteId::from_monotonic(issuer.owner(),Nz::new(1).unwrap());
    let mut graph=Dependencies::new(128);graph.reset(old.to);graph.register_site(source);graph.register_site(reader);
    graph.depends_on(Artifact {site:reader,phase:Phase::Primitive},Artifact {site:source,phase:Phase::Material});assert!(graph.finish(2));
    journal.record(Change {site:source,facets:Facets::one(Facet::Paint),scope:Scope::Site,before:Support::Pending,after:Support::Pending});
    let closure=graph.invalidate_pending(&journal);let next=stamp(&issuer,&journal,2);
    let changes=journal.prepare(next).unwrap().with_closed(closure).unwrap();
    let edits=[SlotEdit::new(slot,PaintColor::new(Color::BLACK))];
    assert_eq!(canvas.prepare_slots(&edits).unwrap().commit_publication(changes,issuer.prepare(next).unwrap()),Err(PublicationError::IncompleteChanges));
    assert_eq!(canvas.accepted_scene().unwrap().stamp(),old);assert_eq!(journal.base(),Some(old.to));
}

#[test]
fn non_graphical_reuse_rejects_raw_and_closed_graphical_domains_without_consuming_old_c() {
    use gpui_reactivity_core::change::{Artifact,Dependencies,DependencyNode,GlobalDependency,Phase};
    let forbidden=[Facet::Topology,Facet::Layout,Facet::TextSource,Facet::TextPolicy,Facet::TextWidth,
        Facet::Paint,Facet::Transform,Facet::Clip,Facet::Stacking,Facet::ResourcePixels,
        Facet::ResourceMetrics,Facet::WidthConstraint,Facet::HeightConstraint,Facet::PrimitiveContent];
    for facet in forbidden {
        let (mut canvas,mut issuer,mut journal,_)=setup();let old=canvas.accepted_scene().unwrap().stamp();
        let site=SiteId::from_monotonic(issuer.owner(),Nz::new(1).unwrap());
        let mut graph=Dependencies::new(128);graph.reset(old.to);graph.register_site(site);assert!(graph.finish(1));
        record(&mut journal,issuer.owner(),facet);let closed=graph.invalidate_pending(&journal);let next=stamp(&issuer,&journal,2);
        let changes=journal.prepare(next).unwrap().with_closed(closed).unwrap();
        assert_eq!(canvas.commit_non_graphical_publication(changes,issuer.prepare(next).unwrap()),Err(PublicationError::IncompleteChanges),"raw {facet:?}");
        assert_eq!(canvas.accepted_scene().unwrap().stamp(),old);assert_eq!(journal.base(),Some(old.to));
    }
    // A raw Hit fact can invalidate graphical work through the REAL graph.
    for phase in Phase::ALL.into_iter().filter(|phase|!matches!(phase,Phase::Hit|Phase::Semantics)) {
        let (mut canvas,mut issuer,mut journal,_)=setup();let old=canvas.accepted_scene().unwrap().stamp();
        let site=SiteId::from_monotonic(issuer.owner(),Nz::new(1).unwrap());
        let mut graph=Dependencies::new(128);graph.reset(old.to);graph.register_site(site);
        graph.depends_on(Artifact {site,phase},Artifact {site,phase:Phase::Hit});assert!(graph.finish(1));
        record(&mut journal,issuer.owner(),Facet::Hit);let closed=graph.invalidate_pending(&journal);let next=stamp(&issuer,&journal,2);
        assert_eq!(canvas.commit_non_graphical_publication(journal.prepare(next).unwrap().with_closed(closed).unwrap(),issuer.prepare(next).unwrap()),Err(PublicationError::IncompleteChanges),"closed {phase:?}");
        assert_eq!(canvas.accepted_scene().unwrap().stamp(),old);assert_eq!(journal.base(),Some(old.to));
    }
    let (mut canvas,mut issuer,mut journal,_)=setup();let old=canvas.accepted_scene().unwrap().stamp();
    let site=SiteId::from_monotonic(issuer.owner(),Nz::new(1).unwrap());
    let mut graph=Dependencies::new(128);graph.reset(old.to);graph.register_site(site);
    graph.depends_on_node(DependencyNode::Global {owner:issuer.owner(),kind:GlobalDependency::Pipeline},DependencyNode::Site(Artifact {site,phase:Phase::Hit}));assert!(graph.finish(1));
    record(&mut journal,issuer.owner(),Facet::Hit);let closed=graph.invalidate_pending(&journal);let next=stamp(&issuer,&journal,2);
    assert_eq!(canvas.commit_non_graphical_publication(journal.prepare(next).unwrap().with_closed(closed).unwrap(),issuer.prepare(next).unwrap()),Err(PublicationError::IncompleteChanges));
    assert_eq!(canvas.accepted_scene().unwrap().stamp(),old);
}

#[test]
fn non_graphical_reuse_requires_closed_receipt_and_preserves_failed_newer_until_retry() {
    use gpui_reactivity_core::change::Dependencies;
    let (mut canvas,mut issuer,mut journal,_)=setup();let old=canvas.accepted_scene().unwrap().stamp();
    let mut seed=vec![0;256];canvas.render_bgrx(&mut seed).unwrap();
    record(&mut journal,issuer.owner(),Facet::Hit);let next=stamp(&issuer,&journal,2);
    let wrong=groups(next,2);let stage=canvas.stage();
    assert_eq!(stage.commit_publication(journal.prepare(next).unwrap(),issuer.prepare(next).unwrap(),wrong),Err(PublicationError::Metadata));
    assert_eq!(canvas.commit_non_graphical_publication(journal.prepare(next).unwrap(),issuer.prepare(next).unwrap()),Err(PublicationError::IncompleteChanges));
    assert_eq!(canvas.prepare_slots(&[]).unwrap().commit_publication(journal.prepare(next).unwrap(),issuer.prepare(next).unwrap()),Err(PublicationError::IncompleteChanges),"empty SlotCommit cannot bypass the same mandatory receipt guard");
    let slot=canvas.accepted_scene().unwrap().scene().groups().next().unwrap().paint_slot().unwrap();
    let no_op=[SlotEdit::new(slot,PaintColor::new(Color::WHITE))];
    assert_eq!(canvas.prepare_slots(&no_op).unwrap().commit_publication(journal.prepare(next).unwrap(),issuer.prepare(next).unwrap()),Err(PublicationError::IncompleteChanges),"nonempty same-color edits cannot bypass the zero-actual-mutation guard");
    assert_eq!(canvas.accepted_scene().unwrap().stamp(),old);assert_eq!(journal.base(),Some(old.to));
    let mut graph=Dependencies::new(64);graph.reset(old.to);graph.register_site(SiteId::from_monotonic(issuer.owner(),Nz::new(1).unwrap()));assert!(graph.finish(1));
    let closed=graph.invalidate_pending(&journal);
    assert!(canvas.commit_non_graphical_publication(journal.prepare(next).unwrap().with_closed(closed).unwrap(),issuer.prepare(next).unwrap()).unwrap().is_empty());
    assert_eq!(canvas.accepted_scene().unwrap().stamp(),next);
    let mut output=vec![0;256];canvas.render_bgrx(&mut output).unwrap();assert_eq!(output,seed);
    graph.reset(next.to);graph.register_site(SiteId::from_monotonic(issuer.owner(),Nz::new(1).unwrap()));assert!(graph.finish(1));
    record(&mut journal,issuer.owner(),Facet::Paint);let third=stamp(&issuer,&journal,3);let closed=graph.invalidate_pending(&journal);
    assert_eq!(canvas.prepare_slots(&no_op).unwrap().commit_publication(journal.prepare(third).unwrap().with_closed(closed).unwrap(),issuer.prepare(third).unwrap()),Err(PublicationError::IncompleteChanges),"raw Paint no-op needs full stage until completed-output proof exists");
    assert_eq!(canvas.accepted_scene().unwrap().stamp(),next);assert_eq!(journal.base(),Some(next.to));
    // A truncated journal must not turn an empty retained row list into proof.
    let mut issuer=FrameIssuer::new().unwrap();let mut journal=Journal::new(issuer.owner(),0);
    let mut canvas=Canvas::recording(16,16,ColorConfig::default()).unwrap();initial(&mut canvas,&mut issuer,&mut journal);
    let old=canvas.accepted_scene().unwrap().stamp();record(&mut journal,issuer.owner(),Facet::Hit);let next=stamp(&issuer,&journal,2);
    let mut graph=Dependencies::new(64);graph.reset(old.to);graph.register_site(SiteId::from_monotonic(issuer.owner(),Nz::new(1).unwrap()));assert!(graph.finish(1));
    let closed=graph.invalidate_pending(&journal);
    assert_eq!(canvas.commit_non_graphical_publication(journal.prepare(next).unwrap().with_closed(closed).unwrap(),issuer.prepare(next).unwrap()),Err(PublicationError::IncompleteChanges));
    assert_eq!(canvas.accepted_scene().unwrap().stamp(),old);
}
