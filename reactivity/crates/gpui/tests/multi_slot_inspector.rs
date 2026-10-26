//! Source-only PUBLIC inspector cross-product proposal; no build/run.
use gpui::{WindowOptions, prelude::*, property::BACKGROUND};
struct GuardPage { hover: Signal<u32> }
impl GuardPage {
    const HOVER: Source<Self,u32> = Source::new(FieldId::new(1),"hover",|m| &m.hover,|m| &mut m.hover);
    fn new() -> Self { Self { hover: Signal::new(0) } }
}
impl View for GuardPage {
    fn sources() -> Sources<Self> { Sources::new().direct(Self::HOVER) }
    fn view(&self) -> El<'_> {
        row((
            div().name("left").size(32).bg(self.hover.map(|id| {
                if *id == 1 { Color::WHITE } else { Color::BLACK }
            })),
            div().name("right").size(32).bg(self.hover.map(|id| {
                if *id == 1 { Color::BLACK } else { Color::WHITE }
            })),
        ))
    }
}
fn ack(win:&mut Win<GuardPage>) {
    let token=win.with_scene(|_,token|token).unwrap(); win.presented(token).unwrap();
}
fn inspected()->Win<GuardPage> {
    let mut win=Win::recording_with_inspector(GuardPage::new(),WindowOptions {
        size:[720,640],..Default::default()
    }).unwrap();
    ack(&mut win);
    let left=win.query().name("left").one().unwrap();
    win.inspector_select(left).unwrap(); ack(&mut win); win
}
#[test]
fn one_source_two_slot_transfer_cannot_publish_ahead_of_inspector_caption() {
    let mut exact=inspected(); let mut coarse=inspected();
    let left=exact.query().name("left").one().unwrap();
    let right=exact.query().name("right").one().unwrap();
    let caption=|color|format!("background: {:?}\nInherit",
        gpui::property::PropertyValue::Brush(gpui::Brush::Solid(color)));
    assert!(exact.contains_text(&caption(Color::BLACK)).unwrap());
    let old_rows=exact.snapshot().unwrap().nodes;
    exact.reset_counters().unwrap(); coarse.reset_counters().unwrap();
    exact.set(GuardPage::HOVER,1).unwrap();
    coarse.update(|m|m.hover=Signal::new(1)).unwrap();
    assert_eq!(exact.counters().source_operations,1);
    assert!(exact.counters().paint_passes>0,"inspector guard must use complete preparation");
    assert_eq!(exact.snapshot().unwrap().nodes,old_rows,"no pre-ACK relabeling of old P");
    ack(&mut exact); ack(&mut coarse);
    assert_eq!(exact.property(left,BACKGROUND).unwrap().solid().unwrap(),Color::WHITE);
    assert_eq!(exact.property(right,BACKGROUND).unwrap().solid().unwrap(),Color::BLACK);
    assert!(exact.contains_text(&caption(Color::WHITE)).unwrap());
    assert!(!exact.contains_text(&caption(Color::BLACK)).unwrap());
    let mut a=exact.snapshot().unwrap(); let mut b=coarse.snapshot().unwrap();
    for node in a.nodes.iter_mut().chain(b.nodes.iter_mut()) { node.target=None; }
    assert_eq!(a,b);
    let pixels=exact.with_pixels(|p,_,_|p.to_vec()).unwrap();
    coarse.with_pixels(|p,_,_|assert_eq!(pixels,p)).unwrap();
}
