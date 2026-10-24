use gpui::{FieldId, Signal, Source};
struct Owner { value: Signal<gpui::Image> }
const SOURCE: Source<Owner, gpui::Image> = Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
#[test] fn declaration() { let _ = SOURCE; }
