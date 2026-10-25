//! PUBLIC source-only regression proposal; genuine 64MiB aggregate limit.
//! Allocates ~64.012MiB immutable gradient words once. No fault state fabrication.
use gpui::{Error, Extend, Gradient, GradientGeometry, GradientStop, Interpolation,
    ItemKey, ItemSource, ListId, PresentationToken, Role, WindowOptions, prelude::*,
    property::BACKGROUND};
const LIST: ListId = ListId::new(93);
const SIZE: [u32; 2] = [32, 32];
struct Page { gradients: Vec<Gradient>, over_budget_row: bool }
impl ItemSource for Page {
    fn len(&self) -> usize { 2 }
    fn key(&self, index: usize) -> ItemKey { ItemKey::new(index as u64 + 1) }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        (1..=2).contains(&key.get()).then(|| key.get() as usize - 1)
    }
    fn row(&self, index: usize) -> El<'_> {
        if index == 1 && self.over_budget_row {
            column(self.gradients.iter().map(|gradient| div().size(1).bg(gradient)))
        } else { div().name("safe").size(4).bg(Color::BLACK) }
    }
}
impl View for Page {
    fn view(&self) -> El<'_> { uniform_list(LIST, self, 16).w(16).h(16) }
}
fn token(win: &Win<Page>) -> PresentationToken { win.with_scene(|_, t| t).unwrap() }
fn ack(win: &mut Win<Page>) { let t=token(win);win.presented(t).unwrap(); }
fn packed(win: &mut Win<Page>) -> Vec<u32> {
    let mut words=vec![0xdecafbad; SIZE[0] as usize*SIZE[1] as usize];
    assert_eq!(win.render_bgrx(&mut words).unwrap(),token(win)); words
}
fn gradients() -> Vec<Gradient> {
    let stops: Vec<_>=(0..4096).map(|index|GradientStop::new(
        index as f32/4095., if index%2==0 {Color::BLACK}else{Color::WHITE},
    )).collect();
    let gradients:Vec<_>=(0..256).map(|_|Gradient::new(
        GradientGeometry::Linear {start:Point::default(),end:Point{x:1.,y:0.}},
        &stops,Extend::Pad,Interpolation::LinearSrgb,
    ).unwrap()).collect();
    // Exact admitted per-resource words: header3*16 + stops4096*4*16.
    assert_eq!(gradients[0].view().byte_len(),262_192);
    assert_eq!(gradients.iter().map(|g|g.view().byte_len()).sum::<usize>(),67_121_152);
    assert!(67_121_152usize > gpui_canvas::MAX_IMAGE_SCENE_BYTES);
    // Each constructor produces a distinct immutable resource identity.
    assert_ne!(gradients[0].key(),gradients[1].key());
    gradients
}
#[test]
fn late_scroll_resource_error_keeps_old_complete_output_but_revokes_broken_working_index() {
    let mut win=Win::recording(Page {gradients:gradients(),over_budget_row:true},
        WindowOptions {size:SIZE,..Default::default()}).unwrap();
    ack(&mut win);
    let pane=win.list(LIST).unwrap();
    let safe=win.role(Role::Generic).name("safe").one().unwrap();
    let old_token=token(&win);let old_p=win.snapshot().unwrap().nodes;
    let old_words=packed(&mut win);let old_viewport=win.list_state(pane).unwrap();
    // Before-destructive-phase rejection must retain usable old target authority.
    assert!(win.scroll_to_index(pane,2).is_err());
    assert_eq!(win.list(LIST).unwrap(),pane);
    assert_eq!(win.role(Role::Generic).name("safe").one().unwrap(),safe);
    assert_eq!(win.list_state(pane).unwrap(),old_viewport);
    assert_eq!(token(&win),old_token);assert_eq!(packed(&mut win),old_words);
    // Row1 is source-valid (<300 nodes/depth5), but its distinct gradients exceed
    // the aggregate limit AFTER destructive logical reconciliation begins.
    assert!(matches!(win.scroll_to_index(pane,1),Err(Error::ResourceLimit)));
    assert_eq!(token(&win),old_token);
    assert_eq!(win.snapshot().unwrap().nodes,old_p);
    assert_eq!(packed(&mut win),old_words);
    // This logical query used to reach stale by_identity into empty nodes and
    // panic. It must reject cleanly, not claim current broken working authority.
    assert!(matches!(win.property(safe,BACKGROUND),Err(Error::StaleTarget)));
    assert_eq!(win.hit_target(Point{x:1.,y:1.}),Err(Error::PresentationStale));
    // Rendering/acknowledging old complete C remains legal, despite invalid L.
    win.presented(old_token).unwrap();
    // Coarse valid repair cannot trust the stale inverse or revive old Targets.
    win.update(|page|page.over_budget_row=false).unwrap();ack(&mut win);
    let repaired=win.role(Role::Generic).name("safe").one().unwrap();
    assert_ne!(repaired,safe);
    assert_eq!(packed(&mut win),old_words);
}
