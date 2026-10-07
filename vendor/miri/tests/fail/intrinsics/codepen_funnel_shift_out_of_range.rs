#![feature(core_intrinsics)]
#![allow(internal_features)]
fn main() {
    unsafe {
        let _ = std::intrinsics::unchecked_funnel_shl(1u64, 2u64, 64);
        //~^ ERROR: unchecked_funnel_shl shift 64 exceeds integer width 64
    }
}
