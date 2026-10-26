//! Genuine two-owner paint changes and canonical publication history.
use gpui::{prelude::*, PresentationToken, WindowOptions};
const SIZE: [u32;2] = [48,24];
struct Page { hover: Signal<u32> }
impl Page {
    const HOVER: Source<Self,u32> = Source::new(FieldId::new(1),"hover",|m|&m.hover,|m|&mut m.hover);
}
impl View for Page {
    fn sources()->Sources<Self> {Sources::new().direct(Self::HOVER)}
    fn view(&self)->El<'_> {
        row((0..2).map(|id|div().size(16).bg(self.hover.map_with(id,|hover,id| {
            if *hover==id {rgb(0xe05020)} else if id==0 {rgb(0x406080)} else {rgb(0x8098b0)}
        })))).gap(2)
    }
}
fn window(hover:u32)->Win<Page> {Win::recording(Page {hover:Signal::new(hover)},WindowOptions {size:SIZE,..Default::default()}).unwrap()}
fn token(win:&Win<Page>)->PresentationToken {win.with_scene(|_,t|t).unwrap()}
fn pixels(win:&mut Win<Page>)->Vec<u32> {let mut out=vec![0;SIZE[0] as usize*SIZE[1] as usize];win.render_bgrx(&mut out).unwrap();out}
#[test]
fn checked_two_color_transfer_and_full_resize_share_one_revision_stream() {
    let mut win=window(0);let first=token(&win);win.presented(first).unwrap();
    let initial=win.with_change_scene(|frame,_| {assert!(frame.is_full_snapshot());frame.stamp()}).unwrap();
    let old_p=win.snapshot().unwrap().nodes;let old_pixels=pixels(&mut win);
    win.set(Page::HOVER,1).unwrap();
    let transfer=win.with_change_scene(|frame,t| {
        let mutation=frame.checked_slot_mutation().expect("genuine two-slot publication");
        assert_eq!(mutation.changed_slots().len(),2);
        assert_eq!(mutation.base(),initial.to);
        let users=mutation.changed_slots().iter().flat_map(|slot|frame.material_users(*slot).unwrap()).collect::<std::collections::BTreeSet<_>>();
        assert_eq!(users.len(),2);
        assert!(users.iter().all(|site|frame.batch().entries.iter().any(|entry|entry.site==*site)));
        assert_eq!(frame.stamp().from,Some(initial.to));
        (frame.stamp(),t)
    }).unwrap();
    assert_eq!(win.snapshot().unwrap().nodes,old_p);
    assert_ne!(pixels(&mut win),old_pixels);
    assert_eq!(pixels(&mut win),pixels(&mut window(1)));
    win.presented(transfer.1).unwrap();
    let epoch=transfer.0.source_epoch;
    win.resize([50,24]).unwrap();
    win.with_change_scene(|frame,_| {
        assert!(frame.is_full_snapshot());assert_eq!(frame.stamp().from,Some(transfer.0.to));
        assert!(frame.stamp().to.sequence>transfer.0.to.sequence);
        assert!(frame.stamp().snapshot_epoch>transfer.0.snapshot_epoch);
        assert_eq!(frame.stamp().source_epoch,epoch,"resize advances C independently of S");
    }).unwrap();
}
