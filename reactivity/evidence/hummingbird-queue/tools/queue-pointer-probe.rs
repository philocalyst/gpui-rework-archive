use gpui::{Win, Role};
use hummingbird_gpui_port::{queue::{Track,TrackRef},queue_view::QueueScreen};
fn main() {
 let mut model=QueueScreen::new(gpui::ListId::new(9000)).unwrap();
 model.enqueue(TrackRef::new(Track{path:"/missing.flac".into(),track_id:None,album_id:None,title:"Probe checkbox".into(),available_when_prepared:false}));
 let mut owner=Win::with_size(model,720,900).unwrap();
 let target=owner.role(Role::CheckBox).name("Probe checkbox").one().unwrap();
 println!("target={target:?} click={:?}",owner.click(target));
 println!("selected={:?}",owner.with_model(|m|m.selected().to_vec()).unwrap());
}
