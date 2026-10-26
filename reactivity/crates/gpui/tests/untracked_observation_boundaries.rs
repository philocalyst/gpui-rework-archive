//! Legacy provider observation is region-local; a watch is not assumed.
use std::{cell::Cell,rc::Rc};
use gpui::{Affine,FieldId,ItemKey,ItemSource,ListId,Signal,Source,Sources,prelude::*};
const LIST:ListId=ListId::new(99);
struct Page {len:Rc<Cell<usize>>,map:Signal<Affine>}
impl Page {const MAP:Source<Self,Affine>=Source::new(FieldId::new(1),"independent placement",|m|&m.map,|m|&mut m.map);}
impl ItemSource for Page {
    fn len(&self)->usize {self.len.get()}
    fn key(&self,index:usize)->ItemKey {ItemKey::new(index as u64+1)}
    fn index_of(&self,key:ItemKey)->Option<usize> {
        (key.get()>0&&key.get()<=self.len() as u64).then(||key.get() as usize-1)
    }
    fn row(&self,index:usize)->El<'_> {
        text(format!("row {}",index+1)).font_size(8).h(12).bg(rgb(if index==0{0x406080}else{0x8098b0}))
    }
}
impl View for Page {
    fn sources()->Sources<Self>{Sources::new().direct(Self::MAP)}
    fn view(&self)->El<'_> {
        row((div().size(16).bg(rgb(0xb05020)).transform(&self.map),uniform_list(LIST,self,12).w(80).h(24))).gap(2)
    }
}
fn pixels(win:&mut Win<Page>,size:[u32;2])->Vec<u32> {
    let mut out=vec![0;size[0] as usize*size[1] as usize];win.render_bgrx(&mut out).unwrap();out
}
fn rows(win:&Win<Page>)->Vec<gpui::SnapshotNode> {
    let mut rows=win.snapshot().unwrap().nodes;for row in &mut rows{row.identity=0;row.target=None;}rows
}
#[test]
fn disjoint_exact_placement_keeps_legacy_observation_boundary_then_resize_observes_external_change() {
    let len=Rc::new(Cell::new(1));let size=[120,96];
    let mut win=Win::with_size(Page{len:len.clone(),map:Signal::new(Affine::IDENTITY)},size[0],size[1]).unwrap();
    let pane=win.list(LIST).unwrap();assert_eq!(win.list_state(pane).unwrap().len,1);
    let before=pixels(&mut win,size);
    // Legal external mutation: ItemSource is pure DURING each description,
    // not immutable across turns. MAP is not a template/item dependency.
    len.set(2);win.reset_counters().unwrap();let map=Affine::translation(4.,2.);
    win.set(Page::MAP,map).unwrap();
    assert_eq!(win.counters().descriptions,0);
    assert!(win.counters().paint_passes>0);
    assert_eq!(win.list_state(pane).unwrap().len,1,"unchanged legacy observed cohort, not unsolicited source refresh");
    assert_ne!(pixels(&mut win,size),before,"actual independent placement changed");
    // Resize is an established observation boundary for untracked providers.
    // It must discover the external change; no across-turn purity is invented.
    win.reset_counters().unwrap();let resized=[132,100];win.resize(resized).unwrap();
    assert!(win.counters().descriptions>0);
    assert_eq!(win.list_state(pane).unwrap().len,2);
    win.list_item(pane,ItemKey::new(2)).unwrap();
    let mut cold=Win::with_size(Page{len,map:Signal::new(map)},resized[0],resized[1]).unwrap();
    assert_eq!(rows(&win),rows(&cold));assert_eq!(pixels(&mut win,resized),pixels(&mut cold,resized));
}
