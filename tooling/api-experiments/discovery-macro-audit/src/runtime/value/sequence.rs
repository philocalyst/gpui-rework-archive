//! Safe structural access for actual standard-library containers.
use super::*;

impl Type {
    /// Returns a `Vec<T>` schema with lazy, checked index access.
    pub fn vec<T: Any>(item_shape: fn() -> Type) -> Type {
        Self::sequence::<Vec<T>>(
            item_shape,
            vec_len::<T>,
            vec_get::<T>,
            vec_get_mut::<T>,
            SequenceKind::Sequence,
            None,
        )
    }

    /// Returns an `Option<T>` schema with `Some`/`None` variants and index-zero access.
    pub fn option<T: Any>(item_shape: fn() -> Type) -> Type {
        Self::sequence::<Option<T>>(
            item_shape,
            option_len::<T>,
            option_get::<T>,
            option_get_mut::<T>,
            SequenceKind::EnumSequence,
            Some(|value| if value.is_some() { "Some" } else { "None" }),
        )
    }

    /// Returns a `Box<T>` schema with safe access to its pointee at index zero.
    pub fn boxed<T: Any>(item_shape: fn() -> Type) -> Type {
        Self::sequence::<Box<T>>(
            item_shape,
            box_len::<T>,
            box_get::<T>,
            box_get_mut::<T>,
            SequenceKind::BoxPointer,
            None,
        )
    }

    /// Returns a `[T; N]` schema with checked bounds and lazy element metadata.
    pub fn array<T: Any, const N: usize>(item_shape: fn() -> Type) -> Type {
        Self::sequence::<[T; N]>(
            item_shape,
            array_len::<T, N>,
            array_get::<T, N>,
            array_get_mut::<T, N>,
            SequenceKind::ArraySequence,
            None,
        )
    }

    fn sequence<Root: Any>(
        item_shape: fn() -> Type,
        len: fn(&dyn Any) -> Option<usize>,
        get: for<'a> fn(&'a dyn Any, usize) -> Option<&'a dyn Any>,
        get_mut: for<'a> fn(&'a mut dyn Any, usize) -> Option<&'a mut dyn Any>,
        kind: SequenceKind,
        variant: Option<fn(&Root) -> &'static str>,
    ) -> Type {
        let ty = Self::opaque::<Root>();
        ty.0.shape.get_or_init(|| {
            Schema::<Root>::sequence(item_shape, len, get, get_mut, kind, variant).shape
        });
        ty
    }
}

impl<Root: Any> Schema<Root> {
    fn sequence(
        item_shape: fn() -> Type,
        len: fn(&dyn Any) -> Option<usize>,
        get: for<'a> fn(&'a dyn Any, usize) -> Option<&'a dyn Any>,
        get_mut: for<'a> fn(&'a mut dyn Any, usize) -> Option<&'a mut dyn Any>,
        kind: SequenceKind,
        variant: Option<fn(&Root) -> &'static str>,
    ) -> Self {
        Self {
            shape: TypeShape {
                kind: match kind {
                    SequenceKind::Sequence => TypeKind::Sequence,
                    SequenceKind::EnumSequence => TypeKind::Enum,
                    SequenceKind::BoxPointer => TypeKind::BoxPointer,
                    SequenceKind::ArraySequence => TypeKind::ArraySequence,
                },
                fields: Box::new([]),
                variant: variant.map(|project| {
                    Box::new(BoundVariant::<Root>(project)) as Box<dyn VariantSchema>
                }),
                sequence: Some(SequenceSchema {
                    len,
                    get,
                    get_mut,
                    item_shape,
                    item_type: OnceLock::new(),
                }),
                roles: Box::new([]),
            },
            marker: PhantomData,
        }
    }
}

pub(super) struct SequenceSchema {
    pub(super) len: fn(&dyn Any) -> Option<usize>,
    pub(super) get: for<'a> fn(&'a dyn Any, usize) -> Option<&'a dyn Any>,
    pub(super) get_mut: for<'a> fn(&'a mut dyn Any, usize) -> Option<&'a mut dyn Any>,
    item_shape: fn() -> Type,
    item_type: OnceLock<Type>,
}
#[derive(Clone, Copy)]
pub(super) enum SequenceKind {
    Sequence,
    EnumSequence,
    BoxPointer,
    ArraySequence,
}
impl SequenceSchema {
    pub(super) fn item_type(&self) -> Type {
        *self.item_type.get_or_init(|| (self.item_shape)())
    }
}

fn vec_len<T: Any>(value: &dyn Any) -> Option<usize> {
    Some(value.downcast_ref::<Vec<T>>()?.len())
}
fn vec_get<T: Any>(value: &dyn Any, index: usize) -> Option<&dyn Any> {
    Some(value.downcast_ref::<Vec<T>>()?.get(index)?)
}
fn vec_get_mut<T: Any>(value: &mut dyn Any, index: usize) -> Option<&mut dyn Any> {
    Some(value.downcast_mut::<Vec<T>>()?.get_mut(index)?)
}
fn box_len<T: Any>(value: &dyn Any) -> Option<usize> {
    value.downcast_ref::<Box<T>>()?;
    Some(1)
}
fn box_get<T: Any>(value: &dyn Any, index: usize) -> Option<&dyn Any> {
    if index != 0 {
        return None;
    }
    Some(value.downcast_ref::<Box<T>>()?.as_ref())
}
fn box_get_mut<T: Any>(value: &mut dyn Any, index: usize) -> Option<&mut dyn Any> {
    if index != 0 {
        return None;
    }
    Some(value.downcast_mut::<Box<T>>()?.as_mut())
}
fn array_len<T: Any, const N: usize>(value: &dyn Any) -> Option<usize> {
    value.downcast_ref::<[T; N]>()?;
    Some(N)
}
fn array_get<T: Any, const N: usize>(value: &dyn Any, index: usize) -> Option<&dyn Any> {
    Some(value.downcast_ref::<[T; N]>()?.get(index)?)
}
fn array_get_mut<T: Any, const N: usize>(
    value: &mut dyn Any,
    index: usize,
) -> Option<&mut dyn Any> {
    Some(value.downcast_mut::<[T; N]>()?.get_mut(index)?)
}
fn option_len<T: Any>(value: &dyn Any) -> Option<usize> {
    Some(usize::from(value.downcast_ref::<Option<T>>()?.is_some()))
}
fn option_get<T: Any>(value: &dyn Any, index: usize) -> Option<&dyn Any> {
    if index != 0 {
        return None;
    }
    Some(value.downcast_ref::<Option<T>>()?.as_ref()?)
}
fn option_get_mut<T: Any>(value: &mut dyn Any, index: usize) -> Option<&mut dyn Any> {
    if index != 0 {
        return None;
    }
    Some(value.downcast_mut::<Option<T>>()?.as_mut()?)
}

impl<T: Describe> Describe for Vec<T> {
    fn build_type() -> Schema<Self> {
        Schema::sequence(
            T::type_shape,
            vec_len::<T>,
            vec_get::<T>,
            vec_get_mut::<T>,
            SequenceKind::Sequence,
            None,
        )
    }

    fn prepare_children() {
        let _ = T::type_shape();
    }
}
impl<T: Any> PartialDescribe for Vec<T> {
    fn partial_type_shape() -> Type {
        Type::vec::<T>(Type::discover::<T>)
    }
}
impl<T: Describe> Describe for Option<T> {
    fn build_type() -> Schema<Self> {
        Schema::sequence(
            T::type_shape,
            option_len::<T>,
            option_get::<T>,
            option_get_mut::<T>,
            SequenceKind::EnumSequence,
            Some(|value| if value.is_some() { "Some" } else { "None" }),
        )
    }

    fn prepare_children() {
        let _ = T::type_shape();
    }
}
impl<T: Any> PartialDescribe for Option<T> {
    fn partial_type_shape() -> Type {
        Type::option::<T>(Type::discover::<T>)
    }
}
impl<T: Describe> Describe for Box<T> {
    fn build_type() -> Schema<Self> {
        Schema::sequence(
            T::type_shape,
            box_len::<T>,
            box_get::<T>,
            box_get_mut::<T>,
            SequenceKind::BoxPointer,
            None,
        )
    }

    fn prepare_children() {
        let _ = T::type_shape();
    }
}
impl<T: Any> PartialDescribe for Box<T> {
    fn partial_type_shape() -> Type {
        Type::boxed::<T>(Type::discover::<T>)
    }
}
impl<T: Describe, const N: usize> Describe for [T; N] {
    fn build_type() -> Schema<Self> {
        Schema::sequence(
            T::type_shape,
            array_len::<T, N>,
            array_get::<T, N>,
            array_get_mut::<T, N>,
            SequenceKind::ArraySequence,
            None,
        )
    }

    fn prepare_children() {
        let _ = T::type_shape();
    }
}
impl<T: Any, const N: usize> PartialDescribe for [T; N] {
    fn partial_type_shape() -> Type {
        Type::array::<T, N>(Type::discover::<T>)
    }
}

// Atomic standard types terminate complete container chains. They retain exact native
// downcasts while deliberately exposing no structural fields.
macro_rules! atomic_describe {
    ($($ty:ty),* $(,)?) => {$ (
        impl Describe for $ty {
            fn build_type() -> Schema<Self> { Schema::opaque() }
        }
    )*};
}
atomic_describe!(
    (),
    bool,
    char,
    u8,
    u16,
    u32,
    u64,
    u128,
    usize,
    i8,
    i16,
    i32,
    i64,
    i128,
    isize,
    f32,
    f64,
    String,
    Box<str>
);
impl<T: ?Sized + 'static> Describe for &'static T {
    fn build_type() -> Schema<Self> {
        Schema::opaque()
    }
}
impl<T: ?Sized + 'static> Describe for &'static mut T {
    fn build_type() -> Schema<Self> {
        Schema::opaque()
    }
}
