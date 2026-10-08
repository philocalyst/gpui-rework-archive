#![feature(rustc_private)]
extern crate rustc_apfloat;
extern crate rustc_driver;

#[path = "browser-float.rs"]
mod fast;

use fast::{Op, Value};
use rustc_apfloat::{Float, FloatConvert, ieee::{Single, Double}};

fn reference<F: Float + FloatConvert<F>>(op: Op, left: u64, right: u64) -> Option<Value> {
    let l = F::from_bits(left as u128);
    let r = F::from_bits(right as u128);
    if l.is_nan() || r.is_nan() { return None; }
    let result = match op {
        Op::Eq => return Some(Value::Bool(l == r)),
        Op::Ne => return Some(Value::Bool(l != r)),
        Op::Lt => return Some(Value::Bool(l < r)),
        Op::Le => return Some(Value::Bool(l <= r)),
        Op::Gt => return Some(Value::Bool(l > r)),
        Op::Ge => return Some(Value::Bool(l >= r)),
        Op::Add => (l + r).value,
        Op::Sub => (l - r).value,
        Op::Mul => (l * r).value,
        Op::Div => (l / r).value,
    };
    if result.is_nan() { None } else { Some(Value::Bits(result.to_bits() as u64)) }
}

fn check<F: Float + FloatConvert<F>>(width: u32, left: u64, right: u64) {
    for op in [Op::Add, Op::Sub, Op::Mul, Op::Div, Op::Eq, Op::Ne, Op::Lt, Op::Le, Op::Gt, Op::Ge] {
        assert_eq!(fast::binary(width, op, left, right), reference::<F>(op, left, right),
            "f{width} {op:?} {left:#018x} {right:#018x}");
    }
}

fn main() {
    // Both signs of zero, subnormals, normal boundary, largest finite, infinities,
    // quiet/signaling NaNs and halfway-rounding neighborhoods.
    let edges32 = [0, 1, 2, 0x7fffff, 0x800000, 0x3effffff, 0x3f000000,
        0x3f000001, 0x3f7fffff, 0x3f800000, 0x3f800001, 0x7f7fffff,
        0x7f800000, 0x7fc00000, 0x7f800001];
    let edges64 = [0, 1, 2, 0x000fffffffffffff, 0x0010000000000000,
        0x3fdfffffffffffff, 0x3fe0000000000000, 0x3fe0000000000001,
        0x3fefffffffffffff, 0x3ff0000000000000, 0x3ff0000000000001,
        0x7fefffffffffffff, 0x7ff0000000000000, 0x7ff8000000000000, 0x7ff0000000000001];
    for &l in &edges32 { for &r in &edges32 {
        for ls in [0, 0x80000000] { for rs in [0, 0x80000000] {
            check::<Single>(32, l | ls, r | rs);
        }}
    }}
    for &l in &edges64 { for &r in &edges64 {
        for ls in [0, 0x8000000000000000] { for rs in [0, 0x8000000000000000] {
            check::<Double>(64, l | ls, r | rs);
        }}
    }}
    let mut seed = 0x48213f9a7b654de0u64;
    let mut next = || { seed ^= seed << 13; seed ^= seed >> 7; seed ^= seed << 17; seed };
    for _ in 0..200_000 {
        let l = next(); let r = next();
        check::<Single>(32, l as u32 as u64, r as u32 as u64);
        check::<Double>(64, l, r);
    }
    assert_eq!(fast::binary(16, Op::Add, 0, 0), None);
    println!("PASS: 4,018,000 host IEEE results match rustc APFloat bit for bit");
}
