//! Semantic route equivalence uses existing before/after values, not mirrors.
use super::*;
use crate::{Align,Color,Flow,Justify};
use change_model::{Facet,Facets,Scope};
#[test]
fn exact_style_field_matrix_keeps_layout_material_and_subtree_effects_distinct() {
    let base=Style::DEFAULT;
    let mut cases=Vec::new();
    let mut next=base;next.width=Some(1.);cases.push((next,Facet::WidthConstraint));
    let mut next=base;next.height=Some(1.);cases.push((next,Facet::HeightConstraint));
    let mut next=base;next.gap=1.;cases.push((next,Facet::Layout));
    let mut next=base;next.padding=1.;cases.push((next,Facet::Layout));
    let mut next=base;next.flow=Flow::Row;cases.push((next,Facet::Layout));
    let mut next=base;next.align=Align::Center;cases.push((next,Facet::Layout));
    let mut next=base;next.justify=Justify::Center;cases.push((next,Facet::Layout));
    let mut next=base;next.wrap=true;cases.push((next,Facet::Layout));
    let mut next=base;next.font_size=17.;cases.push((next,Facet::TextPolicy));
    let mut next=base;next.fg=Color::rgb(20,40,180);cases.push((next,Facet::Paint));
    let mut next=base;next.transform=Affine::translation(2.,3.);cases.push((next,Facet::Transform));
    for (next,expected) in cases {
        let delta=changes::style_facets(&base,&next,false);
        assert_eq!(delta,Facets::one(expected),"{expected:?}");
        assert_eq!(changes::mutation_scope(delta),if expected==Facet::Transform{Scope::Subtree}else{Scope::Site});
    }
    let mut before=base;before.width=Some(1.);
    let mut after=before;after.width=Some(f32::from_bits(1f32.to_bits()+1));
    assert_eq!(changes::style_facets(&before,&after,false),Facets::one(Facet::WidthConstraint));
    let mut opaque_before=base;opaque_before.bg=Color::rgb(1,2,3);
    let mut opaque_after=opaque_before;opaque_after.bg=Color::rgb(4,5,6);
    assert_eq!(changes::style_facets(&opaque_before,&opaque_after,false),Facets::one(Facet::Paint));
    let mut foreground_alpha=base;foreground_alpha.fg=Color::rgba(20,40,180,128);
    assert_eq!(changes::style_facets(&base,&foreground_alpha,false),changes::binding_facets());
    let mut zero=base;zero.width=Some(0.);let mut signed=zero;signed.width=Some(-0.);
    assert_eq!(changes::style_facets(&zero,&signed,false),Facets::one(Facet::WidthConstraint));
    let mut signed_transform=base;signed_transform.transform.tx=-0.;
    assert_eq!(changes::style_facets(&base,&signed_transform,false),Facets::one(Facet::Transform));
    let mut alpha=base;alpha.bg=Color::rgba(20,40,180,128);
    assert_eq!(changes::style_facets(&base,&alpha,false),changes::binding_facets());
    assert_eq!(changes::style_facets(&base,&base,true),changes::binding_facets());
    assert_eq!(changes::mutation_scope(changes::binding_facets()),Scope::Site);
    assert!(changes::brush_binding_facets().contains(Facet::PrimitiveContent));
    assert!(changes::brush_binding_facets().contains(Facet::ResourcePixels));
}

use crate::{El,FieldId,Signal,SignalMap,Source,Sources};
struct Styled { route:u8,width:Signal<f64>,color:Signal<Color>,literal_width:f64,literal_color:Color }
impl Styled {
    const WIDTH:Source<Self,f64>=Source::new(FieldId::new(41),"width",|m|&m.width,|m|&mut m.width);
    const COLOR:Source<Self,Color>=Source::new(FieldId::new(42),"color",|m|&m.color,|m|&mut m.color);
    fn new(route:u8,width:f64,color:Color)->Self {Self{route,width:Signal::new(width),color:Signal::new(color),literal_width:width,literal_color:color}}
}
impl View for Styled {
    fn sources()->Sources<Self>{Sources::new().direct(Self::WIDTH).direct(Self::COLOR)}
    fn view(&self)->El<'_> {
        let node=crate::div().h(24).name("box");
        match self.route {
            0=>node.w(self.literal_width).bg(self.literal_color),
            1=>node.w(&self.width).bg(&self.color),
            _=>node.w(self.width.map_with((),|value,_|*value)).bg(self.color.map_with((),|value,_|*value)),
        }
    }
}
const SIZE:[u32;2]=[96,48];
fn mounted(route:u8,width:f64,color:Color)->Win<Styled> {Win::with_size(Styled::new(route,width,color),SIZE[0],SIZE[1]).unwrap()}
fn pixels(win:&mut Win<Styled>)->Vec<u32> {let mut out=vec![0;SIZE[0] as usize*SIZE[1] as usize];win.render_bgrx(&mut out).unwrap();out}
fn rows(win:&Win<Styled>)->Vec<SnapshotNode> {let mut rows=win.snapshot().unwrap().nodes;for row in &mut rows{row.identity=0;row.target=None;}rows}
fn pending_facts(win:&mut Win<Styled>)->Vec<(Facets,Scope)> {
    let mut runtime=win.runtime_mut().unwrap();
    let old=runtime.canvas.accepted_scene().unwrap().stamp();
    let sequence=old.to.sequence.checked_add(1).unwrap();
    let stamp=change_model::BatchStamp{from:Some(old.to),to:change_model::SceneRevision{owner:old.to.owner,sequence},
        source_epoch:runtime.source_epoch,snapshot_epoch:old.snapshot_epoch+1};
    // Read an ordinary prepared guard, then DROP it. No fake C or commit is
    // installed; the public dropped-turn logical prefix remains pending.
    let prepared=runtime.changes.prepare(stamp).unwrap();
    assert!(prepared.batch().full.is_empty());
    prepared.batch().entries.iter().map(|change|(change.facets,change.scope)).collect()
}
#[test]
fn coarse_direct_and_mapped_width_use_identical_local_input_facts_and_cold_output() {
    let color=Color::rgb(30,60,90);let mut reference=None;
    for route in 0..3 {
        let mut win=mounted(route,64.,color);let before=pixels(&mut win);
        {
            let mut turn=win.edit_turn().unwrap();
            if route==0 {turn.update(|model|model.literal_width=48.).unwrap();}
            else {turn.set(Styled::WIDTH,48.).unwrap();}
            // Intentional public dropped-turn boundary; no intermediate C.
        }
        let facts=pending_facts(&mut win);
        assert_eq!(facts,vec![(Facets::one(Facet::WidthConstraint),Scope::Site)]);
        if let Some(expected)=&reference{assert_eq!(&facts,expected);}else{reference=Some(facts);}
        win.settle().unwrap();
        let mut cold=mounted(route,48.,color);let after=pixels(&mut win);assert_ne!(before,after);
        assert_eq!(rows(&win),rows(&cold));assert_eq!(after,pixels(&mut cold));
    }
}
#[test]
fn color_and_alpha_facts_match_all_routes_without_admitting_alpha_as_slot_only() {
    let initial=Color::rgb(30,60,90);
    for next in [Color::rgb(180,70,20),Color::rgba(180,70,20,128)] {
        let expected=changes::material_facets(initial.alpha(),next.alpha());
        for route in 0..3 {
            let mut win=mounted(route,64.,initial);let before=pixels(&mut win);win.reset_counters().unwrap();
            if route==0{win.update(|model|model.literal_color=next).unwrap();}
            else{win.set(Styled::COLOR,next).unwrap();}
            let mut cold=mounted(route,64.,next);let after=pixels(&mut win);assert_ne!(before,after);
            assert_eq!(rows(&win),rows(&cold));assert_eq!(after,pixels(&mut cold));
            win.with_change_scene(|frame,_| {
                assert!(frame.batch().full.is_empty());
                assert_eq!(frame.batch().entries.iter().map(|change|(change.facets,change.scope)).collect::<Vec<_>>(),vec![(expected,Scope::Site)]);
            }).unwrap();
            if next.alpha()!=initial.alpha(){assert!(win.counters().paint_passes>0,"alpha changes require complete primitive admission");}
        }
    }
}
#[test]
fn equal_color_binding_detachment_is_primitive_content_not_a_material_only_noop() {
    let color=Color::rgb(30,60,90);let mut win=mounted(1,64.,color);
    let target=win.role(crate::Role::Generic).name("box").one().unwrap();let before=pixels(&mut win);
    win.set_property(target,crate::property::BACKGROUND,crate::Contribution::Set(crate::Brush::Solid(color))).unwrap();
    assert_eq!(pixels(&mut win),before);
    win.with_change_scene(|frame,_|assert!(frame.batch().entries.iter().any(|change|
        change.facets.contains(Facet::PrimitiveContent)&&change.facets.contains(Facet::Paint)))).unwrap();
    win.set(Styled::COLOR,Color::rgb(180,70,20)).unwrap();
    assert_eq!(pixels(&mut win),before,"detached literal must not follow the old shared source");
    let mut cold=mounted(0,64.,color);assert_eq!(rows(&win),rows(&cold));assert_eq!(pixels(&mut win),pixels(&mut cold));
}

#[test]
fn retained_checkbox_state_change_has_primitive_and_semantic_facts() {
    struct Check(bool);impl View for Check{fn view(&self)->El<'_>{crate::checkbox("checked",self.0).w(64).h(24)}}
    let mut win=Win::with_size(Check(false),96,48).unwrap();
    let target=win.role(crate::Role::CheckBox).text("checked").one().unwrap();
    let mut before=vec![0;96*48];win.render_bgrx(&mut before).unwrap();win.update(|model|model.0=true).unwrap();
    assert_eq!(win.role(crate::Role::CheckBox).text("checked").one().unwrap(),target);
    let mut after=vec![0;96*48];win.render_bgrx(&mut after).unwrap();assert_ne!(before,after);
    let mut cold=Win::with_size(Check(true),96,48).unwrap();let mut expected=vec![0;96*48];cold.render_bgrx(&mut expected).unwrap();assert_eq!(after,expected);
    win.with_change_scene(|frame,_|assert!(frame.batch().entries.iter().any(|change|change.facets.contains(Facet::PrimitiveContent)&&change.facets.contains(Facet::Semantics)))).unwrap();
}
#[test]
fn transparent_handler_add_remove_has_local_hit_and_semantic_facts() {
    struct Hit{enabled:bool,calls:u32}
    impl Hit{fn activate(&mut self){self.calls+=1;}}
    impl View for Hit{fn view(&self)->El<'_>{let node=crate::div().size(16).name("hit");if self.enabled{node.on_click(Self::activate)}else{node}}}
    let mut win=Win::with_size(Hit{enabled:false,calls:0},32,32).unwrap();
    let target=win.role(crate::Role::Generic).name("hit").one().unwrap();
    for enabled in [true,false] {
        win.update(|model|model.enabled=enabled).unwrap();
        assert_eq!(win.role(crate::Role::Generic).name("hit").one().unwrap(),target);
        let mut supports=false;win.visit(|part|if part.target()==target{supports=part.actions().contains(crate::ActionKind::Activate)}).unwrap();assert_eq!(supports,enabled);
        win.with_change_scene(|frame,_|assert!(frame.batch().entries.iter().any(|change|change.facets.contains(Facet::Hit)&&change.facets.contains(Facet::Semantics)&&change.scope==Scope::Site))).unwrap();
        let mut actual=vec![0;32*32];win.render_bgrx(&mut actual).unwrap();let mut cold=Win::with_size(Hit{enabled,calls:0},32,32).unwrap();let mut expected=vec![0;32*32];cold.render_bgrx(&mut expected).unwrap();assert_eq!(actual,expected);
        if enabled{win.perform(target,crate::Action::Activate).unwrap();assert_eq!(win.root().unwrap().calls,1);}
    }
}
