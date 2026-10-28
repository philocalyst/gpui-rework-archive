#[path = "../../src/scope.rs"]
mod scope;

fn main() {
    scope::with_frame(|outer| {
        let cursor = outer.lower([1u8]);
        scope::with_frame(|inner: &mut scope::Frame<'_, u8>| {
            let _ = inner.read(cursor);
        });
    });
}
