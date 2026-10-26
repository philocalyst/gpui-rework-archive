//! Review-only resize pass-removal falsifier. No builds or observed run claim.
use std::{cell::Cell,rc::Rc};
use gpui::{ItemKey,ItemSource,ListId,prelude::*};
const LIST:ListId=ListId::new(98);
struct Page {len:Rc<Cell<usize>>}
impl ItemSource for Page {
    fn len(&self)->usize {self.len.get()}
    fn key(&self,index:usize)->ItemKey {ItemKey::new(index as u64+1)}
    fn index_of(&self,key:ItemKey)->Option<usize> {
        (key.get()>0 && key.get()<=self.len() as u64).then(||key.get() as usize-1)
    }
    fn row(&self,index:usize)->El<'_> {text(format!("row {}",index+1)).h(12)}
}
impl View for Page {
    fn view(&self)->El<'_> {uniform_list(LIST,self,12).w(80).h(48)}
}
#[test]
fn resize_keeps_existing_observation_of_untracked_borrowed_source() {
    let len=Rc::new(Cell::new(1));
    let mut win=Win::with_size(Page{len:len.clone()},96,96).unwrap();
    let pane=win.list(LIST).unwrap();
    assert_eq!(win.list_state(pane).unwrap().len,1);
    // Pure during each description, exactly as ItemSource's public contract
    // requires. No source reference is retained across a description.
    len.set(2);
    win.resize([112,112]).unwrap();
    assert_eq!(win.list_state(pane).unwrap().len,2);
    let mut cold=Win::with_size(Page{len},112,112).unwrap();
    let actual=win.with_pixels(|p,_,_|p.to_vec()).unwrap();
    cold.with_pixels(|p,_,_|assert_eq!(actual,p)).unwrap();
}
