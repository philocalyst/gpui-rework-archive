use value_shape_frontier::DynValue;
use value_shape_frontier_compile_fail::{dynamic, Pair};
fn escape() -> DynValue<'static> {
    let mut pair = Pair { left: 1, right: 2 };
    dynamic(&mut pair).field("left").unwrap()
}
fn main() { let _ = escape(); }
