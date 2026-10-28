use gpui::{FieldId, Signal, Source};
struct Owner { value: Signal<std::sync::Arc<gpui::TextGeometry>> }
const SOURCE: Source<Owner, std::sync::Arc<gpui::TextGeometry>> = Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
#[test] fn declaration() { let _ = SOURCE; }
