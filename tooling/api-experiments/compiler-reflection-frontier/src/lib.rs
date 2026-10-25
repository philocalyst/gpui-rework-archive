#![feature(type_info, ptr_metadata, try_as_dyn)]
#![allow(internal_features)]

use core::any::{TryAsDynCompatible, TypeId};
use core::mem::type_info::{FieldId, Type};

/// Compiler's type descriptor. `Type::of` is lowered during compilation and does not need a
/// user-authored derive/macro/registration table.
pub const fn reflect<T: ?Sized>() -> Type {
    Type::of::<T>()
}

/// Number of variants in this type. Structs, tuples, and unions each report one.
pub const fn variant_count<T: 'static>() -> usize {
    const { TypeId::of::<T>().variants() }
}

/// Compiler-reported name for a source-order enum variant.
pub const fn variant_name<T: 'static, const VARIANT: usize>() -> &'static str {
    const { TypeId::of::<T>().variant(VARIANT).name() }
}

/// Number of fields in one source-order variant, or the sole field set of a struct/tuple/union.
pub const fn variant_field_count<T: 'static, const VARIANT: usize>() -> usize {
    const { TypeId::of::<T>().fields(VARIANT) }
}

/// Number of fields in the only variant of a struct/tuple/union.
pub const fn field_count<T: 'static>() -> usize {
    variant_field_count::<T, 0>()
}

/// A compiler-selected field. The index is a const parameter because the compiler reflection
/// queries themselves are compile-time-only.
pub const fn field<T: 'static, const INDEX: usize>() -> FieldId {
    const { TypeId::of::<T>().field(0, INDEX) }
}

/// Compiler-selected field in a source-order enum variant.
pub const fn variant_field<T: 'static, const VARIANT: usize, const INDEX: usize>() -> FieldId {
    const { TypeId::of::<T>().field(VARIANT, INDEX) }
}

pub const fn field_name<T: 'static, const INDEX: usize>() -> &'static str {
    const { TypeId::of::<T>().field(0, INDEX).name() }
}

pub const fn variant_field_name<T: 'static, const VARIANT: usize, const INDEX: usize>()
-> &'static str {
    const { TypeId::of::<T>().field(VARIANT, INDEX).name() }
}

pub const fn field_offset<T: 'static, const INDEX: usize>() -> usize {
    const { TypeId::of::<T>().field(0, INDEX).offset() }
}

pub const fn field_type<T: 'static, const INDEX: usize>() -> TypeId {
    const { TypeId::of::<T>().field(0, INDEX).type_id() }
}

/// Gets a compiler-created native trait-object borrow if `T` implements `Trait`.
///
/// The query is compile-time-only and `T` must be a concrete `'static` type. This is native
/// compiler trait discovery at monomorphization time, not lookup from an erased runtime `TypeId`.
pub fn native_trait_object<T: 'static, Trait: TryAsDynCompatible<'static> + ?Sized + 'static>(
    value: &mut T,
) -> Option<&mut Trait> {
    let implementation = const { TypeId::of::<T>().trait_info_of::<Trait>() }?;
    let metadata = implementation.get_vtable();
    let data: *mut T = value;
    let object: *mut Trait = core::ptr::from_raw_parts_mut(data.cast::<()>(), metadata);
    // SAFETY: compiler returned the vtable for concrete T and Trait. The data pointer is derived
    // from the uniquely borrowed `value`, and the returned trait object is bounded by that borrow.
    Some(unsafe { &mut *object })
}
