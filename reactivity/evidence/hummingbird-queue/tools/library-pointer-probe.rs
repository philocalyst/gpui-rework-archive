use gpui::{Win, Role, WindowOptions, ItemKey};
use hummingbird_gpui_port::{app::{Library,connect,recordings,track_key},database::Database,worker::Worker,transcript::settle};
fn main() {
 let (worker,inbox)=Worker::new(Database::fixture().unwrap()).unwrap();
 let (model,questions)=connect(worker.handle()).unwrap();
 let mut owner=Win::with_questions(model,questions,WindowOptions{size:[720,900],..Default::default()}).unwrap().with_inbox(inbox,Library::receive).unwrap();
 settle(&mut owner,&worker).unwrap();
 let list=owner.list(recordings(Default::default())).unwrap();
 owner.scroll_to_key(list,track_key(44)).unwrap();
 let row=owner.list_item(list,track_key(44)).unwrap();
 owner.activate(owner.role(Role::Button).within(row).one().unwrap()).unwrap();
 settle(&mut owner,&worker).unwrap();
 let add=owner.button("Add prepared recording 44 to queue");
 for _ in 0..3 {owner.activate(add).unwrap();}
 let (list,key)=owner.with_model(|m|(m.queue.list_id(),m.queue.playback().queue().at(0).unwrap().key)).unwrap();
 let row=owner.list_item(owner.list(list).unwrap(),ItemKey::new(key.get())).unwrap();
 let target=owner.role(Role::CheckBox).within(row).one().unwrap();
 println!("target={target:?} click={:?}",owner.click(target));
 println!("selected={:?}",owner.with_model(|m|m.queue.selected().to_vec()).unwrap());
 drop(owner);worker.finish().unwrap();
}
