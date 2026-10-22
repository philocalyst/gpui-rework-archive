//! Code-generation audit wrappers, not shipping code or a performance benchmark.
//! shipping_codec.rs is an exact contiguous excerpt from frozen9c1d geometry.rs.
#![allow(private_interfaces)]
use gpui_reactivity_core::Affine;
mod codec {
    use gpui_reactivity_core::{Affine, Point, Rect};
    const MAX_NODES: usize = 100_000;
    include!("shipping_codec.rs");
}
#[inline(never)]
pub fn decode_retained_map(
    basis: codec::MapBasis,
    placement: codec::Placement,
    records: &[codec::Record],
) -> Option<Affine> {
    codec::Bases::new(records).transform(basis, placement)
}
#[inline(never)]
pub fn encode_admitted_map(
    map: Option<Affine>,
    parent: Option<codec::MapBasis>,
    records: &mut Vec<codec::Record>,
) -> codec::MapBasis {
    codec::MapBasis::record(map, parent, records)
}
