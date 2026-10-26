//! Retained edited layout + current viewport proof + mapped multi-slot publication.
use gpui::{ItemKey, ItemSource, ListId, PresentationToken, WindowOptions, prelude::*};
const LIST: ListId = ListId::new(7);
struct Page { hover: Signal<u32>, popup_map: Signal<Affine>, popup: bool }
impl Page {
    const HOVER: Source<Self,u32> = Source::new(FieldId::new(1), "hover", |m| &m.hover, |m| &mut m.hover);
    const POPUP: Source<Self,Affine> = Source::new(FieldId::new(2), "popup_map", |m| &m.popup_map, |m| &mut m.popup_map);
    fn new(hover:u32,popup:bool,map:Affine)->Self {
        Self { hover:Signal::new(hover), popup_map:Signal::new(map), popup }
    }
}
impl ItemSource for Page {
    fn len(&self)->usize { 8 }
    fn key(&self,index:usize)->ItemKey { ItemKey::new(index as u64+1) }
    fn index_of(&self,key:ItemKey)->Option<usize> {
        (1..=8).contains(&key.get()).then(||key.get() as usize-1)
    }
    fn row(&self,index:usize)->El<'_> {
        row((text(format!("row {}",index+1)).font_size(10),div().size(2)))
            .name(format!("row-{}",index+1)).h(12)
            .bg(self.hover.map_with(index as u32+1,|hover,key| {
                if *hover==key { rgb(0xe05020) } else { rgb(0x406080) }
            }))
    }
}
impl View for Page {
    fn sources()->Sources<Self> { Sources::new().direct(Self::HOVER).direct(Self::POPUP) }
    fn view(&self)->El<'_> {
        let mut children=vec![div().size(4)];
        if self.popup {
            children.push(row((text("popup").font_size(10),div().size(3)))
                .name("popup").w(80).h(16).bg(rgb(0xf8c060)).transform(&self.popup_map));
        }
        children.push(uniform_list(LIST,self,12).w(120).h(72));
        column(children.into_iter())
    }
}
fn token(win:&Win<Page>)->PresentationToken { win.with_scene(|_,token|token).unwrap() }
fn ack(win:&mut Win<Page>) { win.presented(token(win)).unwrap(); }
fn exact_cold_rows_and_pixels(win:&mut Win<Page>,hover:u32,popup:bool,map:Affine) {
    let mut fresh=Win::with_size(Page::new(hover,popup,map),160,140).unwrap();
    let normalize=|win:&Win<Page>| {
        let mut nodes=win.snapshot().unwrap().nodes;
        for node in &mut nodes { node.identity=0;node.target=None; }
        nodes
    };
    assert_eq!(normalize(win),normalize(&fresh));
    let pixels=win.with_pixels(|p,_,_|p.to_vec()).unwrap();
    fresh.with_pixels(|p,_,_|assert_eq!(pixels,p)).unwrap();
}
#[test]
fn edited_keyed_text_mapping_then_disjoint_transform_and_two_color_transfer_share_one_core() {
    let mut win=Win::recording(Page::new(1,false,Affine::IDENTITY),WindowOptions {
        size:[160,140],..Default::default()
    }).unwrap();
    ack(&mut win);
    let pane=win.list(LIST).unwrap();
    let first=win.list_item(pane,ItemKey::new(1)).unwrap();
    let second=win.list_item(pane,ItemKey::new(2)).unwrap();
    // Middle insertion shifts actual text slots and leaves genuinely keyed rows
    // alive; the next solve uses the sorted full-capability inverse mapping.
    win.update(|m|m.popup=true).unwrap();ack(&mut win);
    assert_eq!(win.list(LIST).unwrap(),pane);
    assert_eq!(win.list_item(pane,ItemKey::new(1)).unwrap(),first);
    assert_eq!(win.list_item(pane,ItemKey::new(2)).unwrap(),second);
    exact_cold_rows_and_pixels(&mut win,1,true,Affine::IDENTITY);
    win.reset_counters().unwrap();
    let changed=win.set(Page::HOVER,2).unwrap();
    assert_eq!(changed.changed_nodes,2);
    assert_eq!(win.counters().source_operations,1);
    assert_eq!(win.counters().descriptions,0);
    assert_eq!(win.counters().layout_runs,0);
    assert_eq!(win.counters().paint_passes,0);
    ack(&mut win);exact_cold_rows_and_pixels(&mut win,2,true,Affine::IDENTITY);
    // This disjoint transform consults bits from the NEW complete description,
    // not predecessor positions, and still runs the ordinary full presentation.
    win.reset_counters().unwrap();
    let map=Affine::translation(4.,2.);
    win.set(Page::POPUP,map).unwrap();
    assert_eq!(win.counters().descriptions,0);
    assert!(win.counters().paint_passes>0);
    ack(&mut win);exact_cold_rows_and_pixels(&mut win,2,true,map);
    win.update(|m|m.popup=false).unwrap();ack(&mut win);
    assert_eq!(win.list_item(pane,ItemKey::new(1)).unwrap(),first);
    assert_eq!(win.list_item(pane,ItemKey::new(2)).unwrap(),second);
    win.reset_counters().unwrap();
    win.set(Page::HOVER,1).unwrap();
    assert_eq!(win.counters().paint_passes,0);
    ack(&mut win);exact_cold_rows_and_pixels(&mut win,1,false,map);
}
