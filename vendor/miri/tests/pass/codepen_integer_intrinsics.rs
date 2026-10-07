#![feature(core_intrinsics)]
#![allow(internal_features)]
use std::hash::{Hash, Hasher};

fn main() {
    unsafe {
        assert_eq!(std::intrinsics::disjoint_bitor(-2i64, 1i64), -1);
        assert_eq!(std::intrinsics::disjoint_bitor(i128::MIN, i128::MAX), -1);
        assert!(std::intrinsics::disjoint_bitor(false, true));
        assert!(!std::intrinsics::disjoint_bitor(false, false));
    }
    let mut digest = std::hash::DefaultHasher::new();
    macro_rules! integers {
        ($($ty:ty => $signed:ty),*) => { $( {
            let bits = <$ty>::BITS;
            for value in [0u128, 1, u128::MAX, 0x0123456789abcdef_fedcba9876543210,
                0xaaaaaaaaaaaaaaaa_5555555555555555] {
                let a = std::hint::black_box(value as $ty);
                let b = std::hint::black_box(value.reverse_bits() as $ty);
                for shift in [0, 1, bits - 1, bits, bits + 1, u32::MAX] {
                    let shift = std::hint::black_box(shift);
                    a.rotate_left(shift).hash(&mut digest);
                    a.rotate_right(shift).hash(&mut digest);
                    (a as $signed).rotate_left(shift).hash(&mut digest);
                    (a as $signed).rotate_right(shift).hash(&mut digest);
                    let shift = shift % bits;
                    unsafe {
                        std::intrinsics::unchecked_funnel_shl(a, b, shift).hash(&mut digest);
                        std::intrinsics::unchecked_funnel_shr(a, b, shift).hash(&mut digest);
                        std::intrinsics::disjoint_bitor(a & b, a & !b).hash(&mut digest);
                    }
                }
            }
        } )* };
    }
    integers!(u8 => i8, u16 => i16, u32 => i32, u64 => i64, u128 => i128, usize => isize);
    let result = digest.finish();
    // Computed by this exact fixture compiled by the pinned native rustc/LLVM.
    // This compares Miri's intrinsic path with codegen, not with its own fallback.
    #[cfg(target_pointer_width = "64")]
    assert_eq!(result, 12539077455292929518);
    println!("{result}");
}
