use std::{
    marker::PhantomData,
    ops::{Add, Div, Mul, Neg, Sub},
    sync::Arc,
};

use super::expr::{self, BinaryOp, Builtin, Kind, Node, Type, UnaryOp};

mod sealed {
    pub trait Sealed: Copy {
        const TYPE_TAG: u8;
        fn shader_components(self) -> [f32; 4];
    }
}

/// A type supported by GPUI's typed shader values.
///
/// This trait is sealed. Implementations cover `f32`, `bool`, and float vectors
/// with two, three, or four components.
pub trait ShaderValue: sealed::Sealed + Copy + Send + Sync + 'static {}

impl sealed::Sealed for f32 {
    const TYPE_TAG: u8 = 0;
    fn shader_components(self) -> [f32; 4] {
        [self, 0.0, 0.0, 0.0]
    }
}
impl ShaderValue for f32 {}

impl sealed::Sealed for bool {
    const TYPE_TAG: u8 = 1;
    fn shader_components(self) -> [f32; 4] {
        [if self { 1.0 } else { 0.0 }, 0.0, 0.0, 0.0]
    }
}
impl ShaderValue for bool {}

macro_rules! vector_value {
    ($n:literal, $ty:ident, $tag:literal) => {
        impl sealed::Sealed for [f32; $n] {
            const TYPE_TAG: u8 = $tag;
            fn shader_components(self) -> [f32; 4] {
                let mut result = [0.0; 4];
                result[..$n].copy_from_slice(&self);
                result
            }
        }
        impl ShaderValue for [f32; $n] {}
    };
}

vector_value!(2, Vec2, 2);
vector_value!(3, Vec3, 3);
vector_value!(4, Vec4, 4);

trait NumericValue: ShaderValue {}
impl NumericValue for f32 {}
impl NumericValue for [f32; 2] {}
impl NumericValue for [f32; 3] {}
impl NumericValue for [f32; 4] {}

fn type_of<T: ShaderValue>() -> Type {
    match <T as sealed::Sealed>::TYPE_TAG {
        0 => Type::F32,
        1 => Type::Bool,
        2 => Type::Vec2,
        3 => Type::Vec3,
        4 => Type::Vec4,
        _ => unreachable!("sealed shader value type tag is valid"),
    }
}

/// A typed value in a GPUI fragment shader expression.
///
/// Ordinary CPU values convert into dynamic uniform inputs. Use
/// [`constant`] when a value should be embedded in shader code instead.
pub struct Field<T: ShaderValue> {
    pub(super) node: Arc<Node>,
    marker: PhantomData<T>,
}

impl<T: ShaderValue> Clone for Field<T> {
    fn clone(&self) -> Self {
        Self {
            node: self.node.clone(),
            marker: PhantomData,
        }
    }
}

impl<T: ShaderValue> std::fmt::Debug for Field<T> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Field")
            .field("type", &type_of::<T>())
            .finish_non_exhaustive()
    }
}

impl<T: ShaderValue> Field<T> {
    fn from_node(node: Arc<Node>) -> Self {
        debug_assert_eq!(node.ty, type_of::<T>());
        Self {
            node,
            marker: PhantomData,
        }
    }

    /// Create a dynamic uniform value.
    pub fn uniform(value: T) -> Self {
        let components = <T as sealed::Sealed>::shader_components(value).map(f32::to_bits);
        Self::from_node(expr::make(type_of::<T>(), Kind::Uniform(components)))
    }

    /// Embed a constant value into generated WGSL.
    pub fn constant(value: T) -> Self {
        let components = <T as sealed::Sealed>::shader_components(value).map(f32::to_bits);
        Self::from_node(expr::make(type_of::<T>(), Kind::Constant(components)))
    }

    pub(super) fn from_arc(node: Arc<Node>) -> Self {
        Self::from_node(node)
    }
}

impl<T: ShaderValue> From<T> for Field<T> {
    fn from(value: T) -> Self {
        Self::uniform(value)
    }
}

impl<T: ShaderValue> From<&Field<T>> for Field<T> {
    fn from(value: &Field<T>) -> Self {
        value.clone()
    }
}

/// A floating-point scalar expression.
pub type Scalar = Field<f32>;
/// A two-component floating-point expression.
pub type Vec2 = Field<[f32; 2]>;
/// A three-component floating-point expression.
pub type Vec3 = Field<[f32; 3]>;
/// A four-component floating-point expression.
pub type Vec4 = Field<[f32; 4]>;
/// A per-fragment boolean expression.
pub type Predicate = Field<bool>;

/// Embed a compile-time constant in WGSL.
pub fn constant<T: ShaderValue>(value: T) -> Field<T> {
    Field::constant(value)
}

fn unary<T: ShaderValue>(op: UnaryOp, value: &Field<T>) -> Field<T> {
    Field::from_node(expr::make(
        type_of::<T>(),
        Kind::Unary(op, value.node.clone()),
    ))
}

fn binary<T: ShaderValue>(op: BinaryOp, left: &Field<T>, right: &Field<T>) -> Field<T> {
    Field::from_node(expr::make(
        type_of::<T>(),
        Kind::Binary(op, left.node.clone(), right.node.clone()),
    ))
}

fn binary_nodes<T: ShaderValue>(op: BinaryOp, left: &Field<T>, right: Arc<Node>) -> Field<T> {
    Field::from_node(expr::make(
        type_of::<T>(),
        Kind::Binary(op, left.node.clone(), right),
    ))
}

fn binary_arcs<T: ShaderValue>(op: BinaryOp, left: Arc<Node>, right: Arc<Node>) -> Field<T> {
    Field::from_node(expr::make(type_of::<T>(), Kind::Binary(op, left, right)))
}

fn builtin1<T: ShaderValue>(builtin: Builtin, value: &Arc<Node>) -> Field<T> {
    Field::from_node(expr::make(
        type_of::<T>(),
        Kind::Builtin1(builtin, value.clone()),
    ))
}

fn builtin2<T: ShaderValue>(builtin: Builtin, left: Arc<Node>, right: Arc<Node>) -> Field<T> {
    Field::from_node(expr::make(
        type_of::<T>(),
        Kind::Builtin2(builtin, left, right),
    ))
}

fn builtin3<T: ShaderValue>(
    builtin: Builtin,
    first: Arc<Node>,
    second: Arc<Node>,
    third: Arc<Node>,
) -> Field<T> {
    Field::from_node(expr::make(
        type_of::<T>(),
        Kind::Builtin3(builtin, first, second, third),
    ))
}

impl Field<f32> {
    /// Compare this scalar with another scalar.
    pub fn lt(&self, other: impl Into<Scalar>) -> Predicate {
        compare(BinaryOp::Lt, self, other.into())
    }
    /// Compare this scalar with another scalar.
    pub fn le(&self, other: impl Into<Scalar>) -> Predicate {
        compare(BinaryOp::Le, self, other.into())
    }
    /// Compare this scalar with another scalar.
    pub fn gt(&self, other: impl Into<Scalar>) -> Predicate {
        compare(BinaryOp::Gt, self, other.into())
    }
    /// Compare this scalar with another scalar.
    pub fn ge(&self, other: impl Into<Scalar>) -> Predicate {
        compare(BinaryOp::Ge, self, other.into())
    }
    /// Test whether this scalar equals another scalar.
    pub fn eq(&self, other: impl Into<Scalar>) -> Predicate {
        compare(BinaryOp::Eq, self, other.into())
    }
    /// Test whether this scalar differs from another scalar.
    pub fn ne(&self, other: impl Into<Scalar>) -> Predicate {
        compare(BinaryOp::Ne, self, other.into())
    }
}

fn compare(op: BinaryOp, left: &Scalar, right: Scalar) -> Predicate {
    Field::from_node(expr::make(
        Type::Bool,
        Kind::Binary(op, left.node.clone(), right.node),
    ))
}

impl Predicate {
    /// Select `when_true` when this predicate is true, otherwise `when_false`.
    pub fn select<T: ShaderValue>(
        &self,
        when_true: impl Into<Field<T>>,
        when_false: impl Into<Field<T>>,
    ) -> Field<T> {
        let when_true = when_true.into();
        let when_false = when_false.into();
        Field::from_node(expr::make(
            type_of::<T>(),
            Kind::Select(self.node.clone(), when_false.node, when_true.node),
        ))
    }

    /// Combine this condition with another using WGSL `&&`.
    pub fn and(&self, other: impl Into<Predicate>) -> Predicate {
        binary(BinaryOp::And, self, &other.into())
    }

    /// Combine this condition with another using WGSL `||`.
    pub fn or(&self, other: impl Into<Predicate>) -> Predicate {
        binary(BinaryOp::Or, self, &other.into())
    }

    /// Negate this condition.
    pub fn negate(&self) -> Predicate {
        unary(UnaryOp::Not, self)
    }
}

macro_rules! float_builtins {
    ($ty:ty) => {
        impl Field<$ty> {
            /// Apply WGSL `sin` component-wise.
            pub fn sin(&self) -> Self {
                builtin1(Builtin::Sin, &self.node)
            }
            /// Apply WGSL `cos` component-wise.
            pub fn cos(&self) -> Self {
                builtin1(Builtin::Cos, &self.node)
            }
            /// Apply WGSL `abs` component-wise.
            pub fn abs(&self) -> Self {
                builtin1(Builtin::Abs, &self.node)
            }
            /// Apply WGSL `fract` component-wise.
            pub fn fract(&self) -> Self {
                builtin1(Builtin::Fract, &self.node)
            }
            /// Apply WGSL `floor` component-wise.
            pub fn floor(&self) -> Self {
                builtin1(Builtin::Floor, &self.node)
            }
            /// Apply WGSL `sqrt` component-wise.
            pub fn sqrt(&self) -> Self {
                builtin1(Builtin::Sqrt, &self.node)
            }
            /// Apply WGSL `exp` component-wise.
            pub fn exp(&self) -> Self {
                builtin1(Builtin::Exp, &self.node)
            }
            /// Apply WGSL `pow` component-wise.
            pub fn pow(&self, exponent: impl Into<Self>) -> Self {
                builtin2(Builtin::Pow, self.node.clone(), exponent.into().node)
            }
            /// Apply WGSL `min` component-wise.
            pub fn min(&self, other: impl Into<Self>) -> Self {
                builtin2(Builtin::Min, self.node.clone(), other.into().node)
            }
            /// Apply WGSL `max` component-wise.
            pub fn max(&self, other: impl Into<Self>) -> Self {
                builtin2(Builtin::Max, self.node.clone(), other.into().node)
            }
            /// Clamp to component-wise bounds.
            pub fn clamp(&self, low: impl Into<Self>, high: impl Into<Self>) -> Self {
                builtin3(
                    Builtin::Clamp,
                    self.node.clone(),
                    low.into().node,
                    high.into().node,
                )
            }
            /// Apply WGSL `smoothstep(edge0, edge1, self)`.
            pub fn smoothstep(&self, edge0: impl Into<Self>, edge1: impl Into<Self>) -> Self {
                builtin3(
                    Builtin::Smoothstep,
                    edge0.into().node,
                    edge1.into().node,
                    self.node.clone(),
                )
            }
            /// Compute the screen-space x derivative. This requires fragment-stage derivatives.
            pub fn dpdx(&self) -> Self {
                builtin1(Builtin::Dpdx, &self.node)
            }
            /// Compute the screen-space y derivative. This requires fragment-stage derivatives.
            pub fn dpdy(&self) -> Self {
                builtin1(Builtin::Dpdy, &self.node)
            }
            /// Compute the sum of absolute screen-space derivatives.
            pub fn fwidth(&self) -> Self {
                builtin1(Builtin::Fwidth, &self.node)
            }
        }
    };
}

float_builtins!(f32);
float_builtins!([f32; 2]);
float_builtins!([f32; 3]);
float_builtins!([f32; 4]);

macro_rules! vector_methods {
    ($n:literal, $ty:ty, $($field:ident => $component:literal),+ $(,)?) => {
        impl Field<$ty> {
            $(
                #[doc = concat!("Read vector component `", $component, "`.")]
                pub fn $field(&self) -> Scalar {
                    Field::from_node(expr::make(
                        Type::F32,
                        Kind::Swizzle(self.node.clone(), $component),
                    ))
                }
            )+

            /// Compute the Euclidean vector length.
            pub fn length(&self) -> Scalar {
                builtin1(Builtin::Length, &self.node)
            }

            /// Normalize this vector.
            pub fn normalize(&self) -> Self {
                builtin1(Builtin::Normalize, &self.node)
            }

            /// Compute a vector dot product.
            pub fn dot(&self, other: impl Into<Self>) -> Scalar {
                let other = other.into();
                builtin2(Builtin::Dot, self.node.clone(), other.node)
            }
        }
    };
}

vector_methods!(2, [f32; 2], x => "x", y => "y");
vector_methods!(3, [f32; 3], x => "x", y => "y", z => "z");
vector_methods!(4, [f32; 4], x => "x", y => "y", z => "z", w => "w");

impl Field<[f32; 2]> {
    /// Read the vector unchanged.
    pub fn xy(&self) -> Vec2 {
        self.clone()
    }
}
impl Field<[f32; 3]> {
    /// Select the x and y components.
    pub fn xy(&self) -> Vec2 {
        Field::from_node(expr::make(
            Type::Vec2,
            Kind::Swizzle(self.node.clone(), "xy"),
        ))
    }
    /// Select the x, y, and z components.
    pub fn xyz(&self) -> Vec3 {
        self.clone()
    }
}
impl Field<[f32; 4]> {
    /// Select the x and y components.
    pub fn xy(&self) -> Vec2 {
        Field::from_node(expr::make(
            Type::Vec2,
            Kind::Swizzle(self.node.clone(), "xy"),
        ))
    }
    /// Select the x, y, and z components.
    pub fn xyz(&self) -> Vec3 {
        Field::from_node(expr::make(
            Type::Vec3,
            Kind::Swizzle(self.node.clone(), "xyz"),
        ))
    }
    /// Select the red, green, and blue components.
    pub fn rgb(&self) -> Vec3 {
        self.xyz()
    }
    /// Select the alpha component.
    pub fn alpha(&self) -> Scalar {
        self.w()
    }
}

impl<T: NumericValue> Neg for Field<T> {
    type Output = Self;
    fn neg(self) -> Self::Output {
        unary(UnaryOp::Neg, &self)
    }
}
impl<T: NumericValue> Neg for &Field<T> {
    type Output = Field<T>;
    fn neg(self) -> Self::Output {
        unary(UnaryOp::Neg, self)
    }
}

macro_rules! same_type_operator {
    ($trait:ident, $method:ident, $op:ident) => {
        impl<T: NumericValue> $trait for Field<T> {
            type Output = Field<T>;
            fn $method(self, rhs: Field<T>) -> Self::Output {
                binary(BinaryOp::$op, &self, &rhs)
            }
        }
        impl<T: NumericValue> $trait<&Field<T>> for Field<T> {
            type Output = Field<T>;
            fn $method(self, rhs: &Field<T>) -> Self::Output {
                binary(BinaryOp::$op, &self, rhs)
            }
        }
        impl<T: NumericValue> $trait<Field<T>> for &Field<T> {
            type Output = Field<T>;
            fn $method(self, rhs: Field<T>) -> Self::Output {
                binary(BinaryOp::$op, self, &rhs)
            }
        }
        impl<T: NumericValue> $trait<&Field<T>> for &Field<T> {
            type Output = Field<T>;
            fn $method(self, rhs: &Field<T>) -> Self::Output {
                binary(BinaryOp::$op, self, rhs)
            }
        }
        impl<T: NumericValue> $trait<T> for Field<T> {
            type Output = Field<T>;
            fn $method(self, rhs: T) -> Self::Output {
                binary_nodes(BinaryOp::$op, &self, Field::<T>::uniform(rhs).node)
            }
        }
        impl<T: NumericValue> $trait<T> for &Field<T> {
            type Output = Field<T>;
            fn $method(self, rhs: T) -> Self::Output {
                binary_nodes(BinaryOp::$op, self, Field::<T>::uniform(rhs).node)
            }
        }
    };
}

same_type_operator!(Add, add, Add);
same_type_operator!(Sub, sub, Sub);
same_type_operator!(Mul, mul, Mul);
same_type_operator!(Div, div, Div);

macro_rules! scalar_left_operator {
    ($trait:ident, $method:ident, $op:ident) => {
        impl $trait<Field<f32>> for f32 {
            type Output = Field<f32>;
            fn $method(self, rhs: Field<f32>) -> Self::Output {
                binary_nodes(BinaryOp::$op, &Field::<f32>::uniform(self), rhs.node)
            }
        }
        impl $trait<&Field<f32>> for f32 {
            type Output = Field<f32>;
            fn $method(self, rhs: &Field<f32>) -> Self::Output {
                binary_nodes(
                    BinaryOp::$op,
                    &Field::<f32>::uniform(self),
                    rhs.node.clone(),
                )
            }
        }
    };
}

scalar_left_operator!(Add, add, Add);
scalar_left_operator!(Sub, sub, Sub);
scalar_left_operator!(Mul, mul, Mul);
scalar_left_operator!(Div, div, Div);

macro_rules! vector_scalar_operator {
    ($trait:ident, $method:ident, $op:ident, $vec_ty:ty) => {
        impl $trait<Scalar> for Field<$vec_ty> {
            type Output = Field<$vec_ty>;
            fn $method(self, rhs: Scalar) -> Self::Output {
                binary_arcs(BinaryOp::$op, self.node, rhs.node)
            }
        }
        impl $trait<&Scalar> for Field<$vec_ty> {
            type Output = Field<$vec_ty>;
            fn $method(self, rhs: &Scalar) -> Self::Output {
                binary_arcs(BinaryOp::$op, self.node, rhs.node.clone())
            }
        }
        impl $trait<Scalar> for &Field<$vec_ty> {
            type Output = Field<$vec_ty>;
            fn $method(self, rhs: Scalar) -> Self::Output {
                binary_arcs(BinaryOp::$op, self.node.clone(), rhs.node)
            }
        }
        impl $trait<&Scalar> for &Field<$vec_ty> {
            type Output = Field<$vec_ty>;
            fn $method(self, rhs: &Scalar) -> Self::Output {
                binary_arcs(BinaryOp::$op, self.node.clone(), rhs.node.clone())
            }
        }
        impl $trait<f32> for Field<$vec_ty> {
            type Output = Field<$vec_ty>;
            fn $method(self, rhs: f32) -> Self::Output {
                binary_arcs(BinaryOp::$op, self.node, Scalar::uniform(rhs).node)
            }
        }
        impl $trait<f32> for &Field<$vec_ty> {
            type Output = Field<$vec_ty>;
            fn $method(self, rhs: f32) -> Self::Output {
                binary_arcs(BinaryOp::$op, self.node.clone(), Scalar::uniform(rhs).node)
            }
        }
    };
}

vector_scalar_operator!(Mul, mul, Mul, [f32; 2]);
vector_scalar_operator!(Mul, mul, Mul, [f32; 3]);
vector_scalar_operator!(Mul, mul, Mul, [f32; 4]);
vector_scalar_operator!(Div, div, Div, [f32; 2]);
vector_scalar_operator!(Div, div, Div, [f32; 3]);
vector_scalar_operator!(Div, div, Div, [f32; 4]);

macro_rules! scalar_vector_multiply {
    ($vec_ty:ty) => {
        impl Mul<Field<$vec_ty>> for Scalar {
            type Output = Field<$vec_ty>;
            fn mul(self, rhs: Field<$vec_ty>) -> Self::Output {
                binary_arcs(BinaryOp::Mul, self.node, rhs.node)
            }
        }
        impl Mul<&Field<$vec_ty>> for Scalar {
            type Output = Field<$vec_ty>;
            fn mul(self, rhs: &Field<$vec_ty>) -> Self::Output {
                binary_arcs(BinaryOp::Mul, self.node, rhs.node.clone())
            }
        }
        impl Mul<Field<$vec_ty>> for &Scalar {
            type Output = Field<$vec_ty>;
            fn mul(self, rhs: Field<$vec_ty>) -> Self::Output {
                binary_arcs(BinaryOp::Mul, self.node.clone(), rhs.node)
            }
        }
        impl Mul<&Field<$vec_ty>> for &Scalar {
            type Output = Field<$vec_ty>;
            fn mul(self, rhs: &Field<$vec_ty>) -> Self::Output {
                binary_arcs(BinaryOp::Mul, self.node.clone(), rhs.node.clone())
            }
        }
        impl Mul<Field<$vec_ty>> for f32 {
            type Output = Field<$vec_ty>;
            fn mul(self, rhs: Field<$vec_ty>) -> Self::Output {
                binary_arcs(BinaryOp::Mul, Scalar::uniform(self).node, rhs.node)
            }
        }
        impl Mul<&Field<$vec_ty>> for f32 {
            type Output = Field<$vec_ty>;
            fn mul(self, rhs: &Field<$vec_ty>) -> Self::Output {
                binary_arcs(BinaryOp::Mul, Scalar::uniform(self).node, rhs.node.clone())
            }
        }
    };
}

scalar_vector_multiply!([f32; 2]);
scalar_vector_multiply!([f32; 3]);
scalar_vector_multiply!([f32; 4]);

/// Construct a two-component vector expression.
pub fn vec2(x: impl Into<Scalar>, y: impl Into<Scalar>) -> Vec2 {
    let x = x.into();
    let y = y.into();
    Field::from_node(expr::make(Type::Vec2, Kind::Compose2(x.node, y.node)))
}

/// Construct a three-component vector expression.
pub fn vec3(x: impl Into<Scalar>, y: impl Into<Scalar>, z: impl Into<Scalar>) -> Vec3 {
    let x = x.into();
    let y = y.into();
    let z = z.into();
    Field::from_node(expr::make(
        Type::Vec3,
        Kind::Compose3(x.node, y.node, z.node),
    ))
}

/// Construct a four-component vector expression.
pub fn vec4(
    x: impl Into<Scalar>,
    y: impl Into<Scalar>,
    z: impl Into<Scalar>,
    w: impl Into<Scalar>,
) -> Vec4 {
    let x = x.into();
    let y = y.into();
    let z = z.into();
    let w = w.into();
    Field::from_node(expr::make(
        Type::Vec4,
        Kind::Compose4(x.node, y.node, z.node, w.node),
    ))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn vector_construction_and_borrowed_math_keep_types() {
        let uv = vec2(1.0, 2.0);
        let offset = vec2(0.5, 0.75);
        let result = &uv + &offset * 2.0;
        let _: Vec2 = result;
        let scale: Scalar = 2.0.into();
        let _: Vec2 = &offset / &scale;
        let _: Vec2 = &offset / 2.0;
        let _: Vec2 = 2.0 * &offset;
        let _: Vec2 = &scale * &offset;
        let _: Scalar = uv.length();
    }

    #[test]
    fn predicate_select_keeps_branch_type() {
        let condition = Scalar::uniform(0.5).gt(0.2);
        let selected: Vec3 = condition.select([0.0, 0.0, 0.0], [1.0, 1.0, 1.0]);
        assert_eq!(selected.node.ty, Type::Vec3);
    }
}
