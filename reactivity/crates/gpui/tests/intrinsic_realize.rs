//! Intrinsic realization dependency controls. Authored source; host gates pending.
#![cfg(feature = "source-observation-experiment")]
use gpui::{Error, ItemKey, ItemSource, ListError, ListId, PresentationToken,
    WindowOptions, prelude::*};
const LIST: ListId = ListId::new(97);
const SIZE: [u32; 2] = [96, 96];
struct Page {
    empty: bool, height: Signal<f64>, gap: Signal<f64>, padding: Signal<f64>,
    world: Signal<Affine>, clip: Signal<bool>,
}
impl Page {
    const HEIGHT: Source<Self,f64> = Source::new(FieldId::new(1),"height",|m|&m.height,|m|&mut m.height);
    const GAP: Source<Self,f64> = Source::new(FieldId::new(2),"gap",|m|&m.gap,|m|&mut m.gap);
    const PADDING: Source<Self,f64> = Source::new(FieldId::new(3),"padding",|m|&m.padding,|m|&mut m.padding);
    const WORLD: Source<Self,Affine> = Source::new(FieldId::new(4),"world",|m|&m.world,|m|&mut m.world);
    const CLIP: Source<Self,bool> = Source::new(FieldId::new(5),"clip",|m|&m.clip,|m|&mut m.clip);
    fn new(empty:bool,height:f64,world:Affine,clip:bool)->Self {
        Self {empty,height:Signal::new(height),gap:Signal::new(0.),padding:Signal::new(0.),
            world:Signal::new(world),clip:Signal::new(clip)}
    }
}
impl ItemSource for Page {
    // Separate new-capability fixture: ordinary row template and keys are
    // immutable between coarse owner descriptions. Signals below bind ports.
    fn observation_dependencies(&self)->Option<&[FieldId]> {Some(&[])}
    fn len(&self)->usize {if self.empty {0}else{8}}
    fn key(&self,index:usize)->ItemKey {ItemKey::new(index as u64+1)}
    fn index_of(&self,key:ItemKey)->Option<usize> {
        (key.get()>0 && key.get()<=self.len() as u64).then(||key.get() as usize-1)
    }
    fn row(&self,index:usize)->El<'_> {
        text(format!("row {}",index+1)).font_size(9).h(12)
            .bg(if index%2==0 {rgb(0x604020)}else{rgb(0x2080a0)})
    }
}
impl View for Page {
    fn sources()->Sources<Self> {
        Sources::new().direct(Self::HEIGHT).direct(Self::GAP).direct(Self::PADDING)
            .direct(Self::WORLD).direct(Self::CLIP)
    }
    fn view(&self)->El<'_> {
        div().name("world").w(64).h(30).transform(&self.world).clipped(&self.clip)
            .child(uniform_list(LIST,self,12).w(64).h(&self.height).gap(&self.gap).p(&self.padding)
                .transform(Affine::translation(0.,12.)))
    }
}
fn token(win:&Win<Page>)->PresentationToken {win.with_scene(|_,t|t).unwrap()}
fn ack(win:&mut Win<Page>) {win.presented(token(win)).unwrap();}
fn words(win:&mut Win<Page>)->Vec<u32> {
    let mut out=vec![0xdecafbad;SIZE[0] as usize*SIZE[1] as usize];
    assert_eq!(win.render_bgrx(&mut out).unwrap(),token(win));out
}
fn window(empty:bool)->Win<Page> {
    let mut win=Win::recording(Page::new(empty,48.,Affine::IDENTITY,true),
        WindowOptions {size:SIZE,..Default::default()}).unwrap();ack(&mut win);win
}
fn cold(win:&mut Win<Page>,empty:bool,height:f64,world:Affine,clip:bool) {
    let mut fresh=Win::with_size(Page::new(empty,height,world,clip),SIZE[0],SIZE[1]).unwrap();
    let rows=|w:&Win<Page>| {
        let mut rows=w.snapshot().unwrap().nodes;
        for row in &mut rows {row.target=None;row.identity=0;}rows
    };
    assert_eq!(rows(win),rows(&fresh));assert_eq!(words(win),words(&mut fresh));
    let pane=win.list(LIST).unwrap();let reference=fresh.list(LIST).unwrap();
    assert_eq!(win.list_state(pane).unwrap(),fresh.list_state(reference).unwrap());
}
#[test]
fn empty_intrinsic_list_keeps_height_and_style_admission_dependencies() {
    let mut win=window(true);
    win.reset_counters().unwrap();win.set(Page::HEIGHT,24.).unwrap();
    assert!(win.counters().descriptions>0,"empty list still reads its own height");
    ack(&mut win);cold(&mut win,true,24.,Affine::IDENTITY,true);
    for source in [Page::GAP,Page::PADDING] {
        let old=token(&win);let old_words=words(&mut win);
        win.reset_counters().unwrap();
        assert!(matches!(win.set(source,1.),Err(Error::List(ListError::UnsupportedStyle))));
        assert!(win.counters().descriptions>0,"zero realized rows must not hide list style validation");
        assert_eq!(token(&win),old);assert_eq!(words(&mut win),old_words);
        // Rejected source value remains logical input; setting it valid repairs.
        win.set(source,0.).unwrap();ack(&mut win);
        cold(&mut win,true,24.,Affine::IDENTITY,true);
    }
}
#[test]
fn world_placement_and_clip_do_not_change_local_realization_but_do_change_output() {
    let mut win=window(false);let pane=win.list(LIST).unwrap();
    let first=win.list_item(pane,ItemKey::new(1)).unwrap();
    let before=win.list_state(pane).unwrap();let initial_words=words(&mut win);
    let world=Affine::translation(7.,4.);
    win.reset_counters().unwrap();win.set(Page::WORLD,world).unwrap();
    assert_eq!(win.counters().descriptions,0);
    assert!(win.counters().paint_passes>0);
    ack(&mut win);assert_eq!(win.list(LIST).unwrap(),pane);
    assert_eq!(win.list_item(pane,ItemKey::new(1)).unwrap(),first);
    assert_eq!(win.list_state(pane).unwrap(),before);
    assert_ne!(words(&mut win),initial_words);cold(&mut win,false,48.,world,true);
    let clipped=words(&mut win);
    win.reset_counters().unwrap();win.set(Page::CLIP,false).unwrap();
    assert_eq!(win.counters().descriptions,0);
    assert!(win.counters().paint_passes>0);
    ack(&mut win);assert_eq!(win.list_item(pane,ItemKey::new(1)).unwrap(),first);
    assert_eq!(win.list_state(pane).unwrap(),before);
    assert_ne!(words(&mut win),clipped,"world clip must genuinely expose lower row pixels");
    cold(&mut win,false,48.,world,false);
}
