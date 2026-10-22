use gpui::{prelude::*, property::BACKGROUND, WindowOptions};
struct Panel(Signal<Color>);
impl Panel {
    const COLOR: Source<Self, Color> = Source::new(FieldId::new(1), "color", |m| &m.0, |m| &mut m.0);
}
impl View for Panel {
    fn sources() -> Sources<Self> { Sources::new().direct(Self::COLOR) }
    fn view(&self) -> El<'_> { div().name("panel").size(16).bg(&self.0) }
}
fn ack(win: &mut Win<Panel>) { let token=win.with_scene(|_, token| token).unwrap(); win.presented(token).unwrap(); }
fn pixels(win: &mut Win<Panel>) -> Vec<u8> { win.with_pixels(|p,_,_|p.to_vec()).unwrap() }
fn main() {
    let expected=pixels(&mut Win::with_size(Panel(Signal::new(Color::WHITE)),16,16).unwrap());
    for mode in 0..3 {
        let mut win=if mode==0 { Win::with_size(Panel(Signal::new(Color::BLACK)),16,16).unwrap() }
        else { Win::recording(Panel(Signal::new(Color::BLACK)),WindowOptions{size:[16,16],..Default::default()}).unwrap() };
        if mode==1 { ack(&mut win); }
        let coarse=win.update(|_|{}).unwrap();
        let exact=win.set(Panel::COLOR,Color::WHITE).unwrap();
        if mode!=0 { ack(&mut win); }
        let target=win.query().name("panel").one().unwrap();
        println!("mode={mode},coarse={coarse:?},exact={exact:?},property_white={},pixels_match={},first_pixel={:?}",win.property(target,BACKGROUND).unwrap().same_authoring(Color::WHITE),pixels(&mut win)==expected,&pixels(&mut win)[..4]);
    }
}
