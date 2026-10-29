#![allow(dead_code)]
const MAX_NODES: usize = 100_000;
#[path="/home/user/gpui-cold-correspondence-lab/reactivity/crates/gpui/src/runtime/identity_index.rs"]
mod identity_index;
fn main() { println!("{}",std::mem::size_of::<identity_index::IdentityIndex>()); }
