use gpui::{FieldId, Signal, Source};
struct Owner { value: Signal<triomphe::Arc<gpui::TextGeometry>> }
const SOURCE: Source<Owner, triomphe::Arc<gpui::TextGeometry>> = Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
#[test] fn declaration() { let _ = SOURCE; }
