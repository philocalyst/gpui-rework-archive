use gpui::{FieldId, Signal, Source};
struct Owner { value: Signal<triomphe::Arc<gpui_canvas::TextGeometry>> }
const SOURCE: Source<Owner, triomphe::Arc<gpui_canvas::TextGeometry>> = Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
#[test] fn declaration() { let _ = SOURCE; }
