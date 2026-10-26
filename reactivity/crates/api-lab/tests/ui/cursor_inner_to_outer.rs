#[path = "../../src/scope.rs"]
mod scope;

fn main() {
    scope::with_frame(|outer: &mut scope::Frame<'_, u8>| {
        scope::with_frame(|inner| {
            let cursor = inner.lower([1u8]);
            let _ = outer.read(cursor);
        });
    });
}
