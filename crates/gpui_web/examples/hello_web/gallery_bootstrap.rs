use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn bootstrap_ready() -> String {
    "ready".to_owned()
}

fn main() {}
