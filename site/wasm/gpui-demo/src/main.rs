//! Host for the committed exhibit bundle. One WebAssembly build carries every
//! exhibit; the page picks one with the document's URL fragment, for example
//! `index.html#layout`. The live compiler builds a single exhibit instead and
//! generates its own host around `live.rs`.
mod bridge;
mod counter;
mod interaction;
mod layout;

fn main() {
    let hash = web_sys::window()
        .and_then(|window| window.location().hash().ok())
        .unwrap_or_default();
    match hash.trim_start_matches('#') {
        "layout" => layout::main(),
        "interaction" => interaction::main(),
        _ => counter::main(),
    }
}
