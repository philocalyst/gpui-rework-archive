use gpui::{FieldId, Signal, Source};
struct Owner { value: Signal<arcstr::ArcStr> }
const SOURCE: Source<Owner, arcstr::ArcStr> = Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
#[test] fn declaration() { let _ = SOURCE; }
