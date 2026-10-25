#![feature(core_intrinsics)]
#![allow(internal_features)]
fn main() {
    unsafe {
        let _ = std::intrinsics::disjoint_bitor(true, true);
        //~^ ERROR: disjoint_bitor operands have overlapping set bits
    }
}
