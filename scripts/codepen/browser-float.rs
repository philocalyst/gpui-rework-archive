//! IEEE binary operations for the browser interpreter's deterministic mode.
//! NaNs and unsupported operations stay on rustc's software-float path, which
//! owns Miri's NaN policy. Rust/Wasm arithmetic uses nearest, ties-to-even.

#[derive(Clone, Copy, Debug)]
pub enum Op { Add, Sub, Mul, Div, Eq, Ne, Lt, Le, Gt, Ge }

#[derive(Clone, Copy, Debug, PartialEq)]
pub enum Value { Bits(u64), Bool(bool) }

macro_rules! evaluate {
    ($ty:ty, $left:expr, $right:expr, $op:expr) => {{
        let left = <$ty>::from_bits($left);
        let right = <$ty>::from_bits($right);
        if left.is_nan() || right.is_nan() { return None; }
        let result = match $op {
            Op::Eq => return Some(Value::Bool(left == right)),
            Op::Ne => return Some(Value::Bool(left != right)),
            Op::Lt => return Some(Value::Bool(left < right)),
            Op::Le => return Some(Value::Bool(left <= right)),
            Op::Gt => return Some(Value::Bool(left > right)),
            Op::Ge => return Some(Value::Bool(left >= right)),
            Op::Add => left + right,
            Op::Sub => left - right,
            Op::Mul => left * right,
            Op::Div => left / right,
        };
        if result.is_nan() { None } else { Some(Value::Bits(result.to_bits() as u64)) }
    }};
}

#[inline]
pub fn binary(width: u32, op: Op, left: u64, right: u64) -> Option<Value> {
    match width {
        32 => evaluate!(f32, left as u32, right as u32, op),
        64 => evaluate!(f64, left, right, op),
        _ => None,
    }
}
