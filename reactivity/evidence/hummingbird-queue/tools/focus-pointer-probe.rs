use gpui::{prelude::*, WindowOptions, Error};
struct Page { input: Signal<String>, checked: bool }
impl Page { const INPUT:Source<Self,String>=Source::new(FieldId::new(1),"input",|m|&m.input,|m|&mut m.input); }
impl View for Page {
 fn sources()->Sources<Self> {Sources::new().direct(Self::INPUT)}
 fn view(&self)->El<'_> {column((text_input(&self.input).name("input").w(240).h(32),checkbox("check",self.checked).w(240).h(40).on_click(|m:&mut Self|m.checked=!m.checked)))}
}
fn ack(win:&mut Win<Page>) {let token=win.with_scene(|_,token|token).unwrap();println!("ACK {:?}",win.presented(token));}
fn main() {
 let mut win=Win::recording(Page{input:Signal::new("search".into()),checked:false},WindowOptions{size:[720,900],..Default::default()}).unwrap();
 ack(&mut win);let input=win.query().name("input").one().unwrap();let check=win.query().name("check").one().unwrap();
 println!("FOCUS_INPUT {:?}",win.click(input));ack(&mut win);
 let mut pointer=PointerSession::default();win.pointer_event(&mut pointer,PointerEvent::Move(Point{x:12.,y:52.})).unwrap();
 println!("PRESS {:?} focused={:?}",win.pointer_event(&mut pointer,PointerEvent::Press),win.focused());
 let release=win.pointer_event(&mut pointer,PointerEvent::Release);println!("RELEASE {release:?} checked={}",win.root().unwrap().checked);assert_eq!(release,Err(Error::PresentationStale));
 ack(&mut win);win.pointer_event(&mut pointer,PointerEvent::Release).unwrap();assert!(!win.root().unwrap().checked);
 win.pointer_event(&mut pointer,PointerEvent::Press).unwrap();println!("FRESH_RELEASE {:?}",win.pointer_event(&mut pointer,PointerEvent::Release));assert!(win.root().unwrap().checked);assert_eq!(win.focused().unwrap(),Some(check));
}
