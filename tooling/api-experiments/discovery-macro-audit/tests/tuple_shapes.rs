extern crate discovery_macro_audit as gpui;

use discovery_macro_audit::reflect;
use discovery_macro_audit::reflection::{Describe, Type, Value, ValueMut};

#[reflect]
mod tuple_shapes {
    pub struct NamedField {
        pub field_0: u32,
        pub other: u8,
    }

    // The reflected names remain tied to source positions after cfg removes fields. At runtime
    // this is a two-field tuple, but its surviving fields are still named "1" and "3".
    pub struct Sparse(
        #[cfg(any())] pub u8,
        pub u16,
        #[cfg(any())] pub u32,
        pub u64,
        #[cfg(any())] pub u128,
    );

    pub enum SparseVariant {
        Payload(
            #[cfg(any())] u8,
            u16,
            #[cfg(any())] u32,
            u64,
            #[cfg(any())] u128,
        ),
        Unit,
    }

    // These exercise descriptor generation when cfg removes every tuple field.
    pub struct NoFields(#[cfg(any())] u32, #[cfg(any())] u64);
    pub enum NoPayload {
        Empty(#[cfg(any())] u32, #[cfg(any())] u64),
        Unit,
    }

    pub struct Conditional(#[cfg_attr(unix, cfg(any()))] pub u8, pub u16);

    pub struct Borrowed<'a, T>(#[cfg(any())] pub u8, pub &'a mut T, pub T);

    pub enum GatedVariant {
        Visible(u8),
        #[cfg(any())]
        Gone(u16, u32),
    }

    #[cfg(any())]
    pub struct GatedType(pub u8, pub u16);
}

fn names(ty: Type) -> Vec<&'static str> {
    ty.fields().map(|field| field.name).collect()
}

#[test]
fn tuple_fields_keep_source_positions_through_cfg_and_value_access() {
    use tuple_shapes::{Sparse, SparseVariant};

    let mut tuple = Sparse(11, 33);
    let accessors = Sparse::fields();
    assert_eq!(accessors.field_1.name(), "1");
    assert_eq!(accessors.field_3.name(), "3");
    assert_eq!(*accessors.field_1.get(&tuple), 11);
    *accessors.field_3.get_mut(&mut tuple) = 44;
    assert_eq!(tuple.1, 44);

    let ty = Sparse::type_shape();
    assert_eq!(names(ty), ["1", "3"]);
    let value = Value::from_parts(&tuple, ty);
    assert_eq!(
        *value.field("1").unwrap().downcast_ref::<u16>().unwrap(),
        11
    );
    assert_eq!(
        *value.field("3").unwrap().downcast_ref::<u64>().unwrap(),
        44
    );
    assert!(value.field("0").is_none());

    let mut payload = SparseVariant::Payload(12, 34);
    let variant_fields = SparseVariant::variant_fields();
    assert_eq!(variant_fields.payload.field_1.name(), "1");
    assert_eq!(variant_fields.payload.field_3.name(), "3");
    assert_eq!(*variant_fields.payload.field_1.get(&payload).unwrap(), 12);
    *variant_fields
        .payload
        .field_3
        .get_mut(&mut payload)
        .unwrap() = 45;
    assert!(matches!(payload, SparseVariant::Payload(12, 45)));

    let value = Value::new(&payload);
    assert_eq!(value.variant(), Some("Payload"));
    assert_eq!(
        *value.field("1").unwrap().downcast_ref::<u16>().unwrap(),
        12
    );
    assert_eq!(
        *value.field("3").unwrap().downcast_ref::<u64>().unwrap(),
        45
    );
    assert!(
        variant_fields
            .payload
            .field_1
            .get(&SparseVariant::Unit)
            .is_none()
    );
}

#[test]
fn named_field_field_0_and_mutable_value_lookup_remain_unambiguous() {
    use tuple_shapes::NamedField;

    let mut instance = NamedField {
        field_0: 7,
        other: 1,
    };
    let fields = NamedField::fields();
    assert_eq!(fields.field_0.name(), "field_0");
    assert_eq!(*fields.field_0.get(&instance), 7);
    *fields.field_0.get_mut(&mut instance) = 9;

    let mut value = ValueMut::new(&mut instance);
    *value
        .field("field_0")
        .unwrap()
        .downcast_mut::<u32>()
        .unwrap() = 12;
    assert_eq!(instance.field_0, 12);
    assert_eq!(names(NamedField::type_shape()), ["field_0", "other"]);
}

#[test]
fn cfg_attr_and_empty_tuple_shapes_are_supported() {
    use tuple_shapes::{Conditional, NoFields, NoPayload};

    #[cfg(unix)]
    let conditional = Conditional(23);
    #[cfg(not(unix))]
    let conditional = Conditional(17, 23);

    let conditional_type = Conditional::type_shape();
    #[cfg(unix)]
    assert_eq!(names(conditional_type), ["1"]);
    #[cfg(not(unix))]
    assert_eq!(names(conditional_type), ["0", "1"]);
    let conditional_value = Value::from_parts(&conditional, conditional_type);
    assert!(conditional_value.field("1").is_some());

    assert!(names(NoFields::type_shape()).is_empty());
    assert!(Value::new(&NoFields()).fields().next().is_none());
    assert!(names(NoPayload::type_shape()).is_empty());
    assert_eq!(Value::new(&NoPayload::Empty()).variant(), Some("Empty"));
    assert_eq!(Value::new(&NoPayload::Unit).variant(), Some("Unit"));
}

#[test]
fn generic_borrowed_tuple_accessors_and_cfg_gates_compile() {
    use tuple_shapes::{Borrowed, GatedVariant};

    let mut first = 5u32;
    let mut borrowed = Borrowed(&mut first, 8u32);
    let fields = Borrowed::<u32>::fields();
    assert_eq!(**fields.field_1.get(&borrowed), 5);
    assert_eq!(*fields.field_2.get(&borrowed), 8);
    **fields.field_1.get_mut(&mut borrowed) = 9;
    *fields.field_2.get_mut(&mut borrowed) = 12;
    assert_eq!(**fields.field_1.get(&borrowed), 9);
    assert_eq!(*fields.field_2.get(&borrowed), 12);

    let ty = GatedVariant::type_shape();
    assert_eq!(ty.variant(&GatedVariant::Visible(3)), Some("Visible"));
    assert_eq!(
        ty.fields()
            .filter(|field| field.variant == Some("Gone"))
            .count(),
        0
    );
}
