//! Separate matched capability fixture; original untracked primary is unchanged.
#![cfg(feature = "source-observation-experiment")]
use gpui::{prelude::*,WindowOptions};
use std::{cell::Cell,rc::Rc};
const LIST:ListId=ListId::new(188);
struct Page {len:Signal<u32>,a:Signal<Color>,b:Signal<Color>,select:Rc<Cell<bool>>,tracked:bool}
impl Page {
    const LEN:Source<Self,u32>=Source::new(FieldId::new(1),"len",|m|&m.len,|m|&mut m.len);
    const PALETTE:Source<Self,Color>=Source::new(FieldId::new(2),"palette",
        |m|if m.select.get(){&m.b}else{&m.a},|m|if m.select.get(){&mut m.b}else{&mut m.a});
    fn new(select:Rc<Cell<bool>>,tracked:bool)->Self {Self{len:Signal::new(2),a:Signal::new(rgb(0x406080)),b:Signal::new(rgb(0xb04020)),select,tracked}}
    fn palette(&self)->Color {if self.select.get(){*self.b}else{*self.a}}
}
impl ItemSource for Page {
    fn observation_dependencies(&self)->Option<&[FieldId]> {
        const ALL_TEMPLATE_INPUTS:[FieldId;2]=[Page::LEN.id(),Page::PALETTE.id()];
        // Includes ordinary row-template paint, not only length/keys. The
        // registered palette projector's actual incarnation is also observed.
        if self.tracked {Some(&ALL_TEMPLATE_INPUTS)}else{None}
    }
    fn len(&self)->usize {*self.len as usize}
    fn key(&self,index:usize)->ItemKey {ItemKey::new(index as u64+1)}
    fn index_of(&self,key:ItemKey)->Option<usize>{(key.get()>0&&key.get()<=self.len() as u64).then(||key.get() as usize-1)}
    fn row(&self,index:usize)->El<'_>{text(format!("row {index}")).font_size(9).h(12).bg(self.palette())}
}
impl View for Page {
    fn sources()->Sources<Self>{Sources::new().field(Self::LEN).field(Self::PALETTE)}
    fn view(&self)->El<'_>{uniform_list(LIST,self,12).w(80).h(40)}
}
fn options(size:[u32;2])->WindowOptions {WindowOptions{size,..Default::default()}}
fn ack(win:&mut Win<Page>){let token=win.with_scene(|_,t|t).unwrap();win.presented(token).unwrap();}
fn pixels(win:&mut Win<Page>,size:[u32;2])->Vec<u32>{let mut out=vec![0;size[0] as usize*size[1] as usize];win.render_bgrx(&mut out).unwrap();out}
#[test]
fn matched_registered_template_observation_is_stable_changed_and_incarnation_sensitive() {
    let select=Rc::new(Cell::new(false));
    let mut tracked=Win::recording(Page::new(select.clone(),true),options([96,64])).unwrap();
    let mut legacy=Win::recording(Page::new(select.clone(),false),options([96,64])).unwrap();ack(&mut tracked);ack(&mut legacy);
    for size in [[104,72],[112,80]] {
        tracked.reset_counters().unwrap();legacy.reset_counters().unwrap();
        // Exactly matched operation. Only the explicit complete read capability differs.
        tracked.resize(size).unwrap();legacy.resize(size).unwrap();
        assert_eq!(tracked.counters().descriptions,0);assert!(legacy.counters().descriptions>0);ack(&mut tracked);ack(&mut legacy);
        assert_eq!(pixels(&mut tracked,size),pixels(&mut legacy,size));
    }
    let old=pixels(&mut tracked,[112,80]);
    select.set(true); // Equal Signal revisions, DIFFERENT actual palette source instance.
    tracked.reset_counters().unwrap();legacy.reset_counters().unwrap();
    tracked.resize([120,88]).unwrap();legacy.resize([120,88]).unwrap();
    assert!(tracked.counters().descriptions>0,"row-template source incarnation changed even though count/keys did not");
    assert!(legacy.counters().descriptions>0);ack(&mut tracked);ack(&mut legacy);
    let current=pixels(&mut tracked,[120,88]);assert_eq!(current,pixels(&mut legacy,[120,88]));
    let mut cold=Win::with_options(Page::new(select.clone(),true),options([120,88])).unwrap();
    assert_eq!(current,pixels(&mut cold,[120,88]));
    assert_ne!(old[0],current[0],"ordinary row-template palette really changed");
    tracked.set(Page::LEN,3).unwrap();legacy.set(Page::LEN,3).unwrap();ack(&mut tracked);ack(&mut legacy);
    assert_eq!(tracked.list_state(tracked.list(LIST).unwrap()).unwrap().len,3);
    assert_eq!(pixels(&mut tracked,[120,88]),pixels(&mut legacy,[120,88]));
}
