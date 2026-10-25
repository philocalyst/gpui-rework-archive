#![feature(type_info)]
use core::any::TypeId;

struct Pair(u8, u16);

// Rustc's reflection intrinsics are comptime-only; arbitrary runtime field selection is not
// expressible through this API.
fn runtime_field_name(index: usize) -> &'static str {
    TypeId::of::<Pair>().field(0, index).name()
}
