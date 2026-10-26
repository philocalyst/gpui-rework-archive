#[path = "../../src/scope.rs"]
mod scope;

fn main() {
    let cursor = scope::with_frame(|frame| frame.lower([1u8]));
    let _ = cursor;
}
