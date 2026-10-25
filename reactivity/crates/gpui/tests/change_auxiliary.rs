//! Non-model visual inputs must enter the same canonical mutation stream.
use gpui::*;
use gpui_reactivity_core::change::{Facet,FullReasons};
const SIZE:[u32;2]=[160,48];
struct Form { value:Signal<String> }
impl Form {const VALUE:Source<Self,String>=Source::new(FieldId::new(1),"value",|m|&m.value,|m|&mut m.value);}
impl View for Form {
    fn sources()->Sources<Self> {Sources::new().direct(Self::VALUE)}
    fn view(&self)->El<'_> {text_input(&self.value).w(150).h(36).font_size(16)}
}
fn model()->Form {Form{value:Signal::new(String::from("office"))}}
fn options()->WindowOptions {WindowOptions{size:SIZE,..Default::default()}}
fn ack(win:&mut Win<Form>) {let t=win.with_scene(|_,t|t).unwrap();win.presented(t).unwrap();}
fn pixels(win:&mut Win<Form>)->Vec<u32> {let mut out=vec![0;SIZE[0] as usize*SIZE[1] as usize];win.render_bgrx(&mut out).unwrap();out}
#[test]
fn font_owner_replacement_is_explicitly_full_and_matches_fresh_canonical_output() {
    let mut win=Win::recording(model(),options()).unwrap();ack(&mut win);
    let old=pixels(&mut win);
    let font=FontFace::new(include_bytes!("fonts/ime/cjk.otf")).unwrap();
    let mut fresh=Win::recording_with_font(model(),options(),font.clone()).unwrap();
    win.set_text_font(font).unwrap();
    win.with_change_scene(|frame,_|assert!(frame.batch().full.contains(FullReasons::SCENE))).unwrap();
    let current=pixels(&mut win);assert_ne!(current,old,"different outline owner must genuinely affect output");
    assert_eq!(current,pixels(&mut fresh));
}
#[test]
fn caret_and_effective_ime_display_publish_ordinary_paint_and_text_facts() {
    let mut win=Win::recording(model(),options()).unwrap();ack(&mut win);
    let target=win.input();win.focus(target).unwrap();ack(&mut win);
    let old_selection=win.selection(target).unwrap();let old=pixels(&mut win);
    win.key(Key::Left{extend:true}).unwrap();
    assert_ne!(win.selection(target).unwrap(),old_selection);
    win.with_change_scene(|frame,_|assert!(frame.batch().entries.iter().any(|c|c.facets.contains(Facet::PrimitiveContent)))).unwrap();
    assert_ne!(pixels(&mut win),old);ack(&mut win);
    let mut session=ImeSession::default();win.ime_event(&mut session,ImeEvent::Enabled).unwrap();
    let before=win.with_scene(|_,t|t).unwrap();let before_pixels=pixels(&mut win);
    win.ime_event(&mut session,ImeEvent::Preedit{text:"XYZ",cursor:Some((3,3))}).unwrap();
    win.with_change_scene(|frame,token| {
        assert_ne!(token,before);
        assert!(frame.batch().entries.iter().any(|c|c.facets.contains(Facet::TextSource)));
    }).unwrap();
    assert_ne!(pixels(&mut win),before_pixels);
    assert_eq!(win.read(Form::VALUE).unwrap(),"office","preedit is display state, not source mutation");
}
