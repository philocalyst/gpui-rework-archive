use compiler_reflection_frontier::{
    field_count, field_name, field_offset, field_type, native_trait_object, reflect, variant_count,
    variant_field_count, variant_field_name, variant_name,
};
use core::any::TypeId;

#[repr(C)]
struct Pair {
    left: u32,
    right: u64,
}

#[allow(dead_code)]
enum SecretChoice {
    Empty,
    Tuple(u16),
    Named { hidden: String },
}

trait Speak {
    fn speak_mut(&mut self) -> &'static str;
}
struct Dog(u8);
impl Speak for Dog {
    fn speak_mut(&mut self) -> &'static str {
        self.0 += 1;
        "woof-mut"
    }
}
struct Cat;

#[test]
fn compiler_metadata_is_real_and_const_materializable() {
    const COUNT: usize = field_count::<Pair>();
    const NAME0: &str = field_name::<Pair, 0>();
    const NAME1: &str = field_name::<Pair, 1>();
    const OFFSET1: usize = field_offset::<Pair, 1>();
    const TYPE0: TypeId = field_type::<Pair, 0>();
    assert_eq!(COUNT, 2);
    assert_eq!((NAME0, NAME1), ("left", "right"));
    assert_eq!(OFFSET1, 8);
    assert_eq!(TYPE0, TypeId::of::<u32>());
}

#[test]
fn compiler_enumerates_enum_variants_and_private_field_names() {
    const VARIANTS: usize = variant_count::<SecretChoice>();
    const NAME0: &str = variant_name::<SecretChoice, 0>();
    const NAME2: &str = variant_name::<SecretChoice, 2>();
    const COUNT2: usize = variant_field_count::<SecretChoice, 2>();
    const PRIVATE_NAME: &str = variant_field_name::<SecretChoice, 2, 0>();
    assert_eq!(VARIANTS, 3);
    assert_eq!((NAME0, NAME2), ("Empty", "Named"));
    assert_eq!(COUNT2, 1);
    assert_eq!(PRIVATE_NAME, "hidden");
}

#[test]
fn direct_type_descriptor_works_for_primitive() {
    let info = const { reflect::<u32>() };
    assert!(format!("{info:?}").contains("Int"));
}

#[test]
fn compiler_returns_native_vtable_and_borrowed_mut_trait_object() {
    let mut dog = Dog(0);
    {
        let speak: &mut dyn Speak = native_trait_object(&mut dog).unwrap();
        assert_eq!(speak.speak_mut(), "woof-mut");
    }
    assert_eq!(dog.0, 1);
    let mut cat = Cat;
    assert!(native_trait_object::<Cat, dyn Speak>(&mut cat).is_none());
}
