extern crate discovery_macro_audit as gpui;

use discovery_macro_audit::reflect;
use discovery_macro_audit::reflection::{HasFields, HasMethods, HasVariantFields};

#[reflect]
mod probe {
    pub struct Bounded<T>
    where
        T: Clone,
    {
        pub value: T,
    }

    impl<T> Bounded<T>
    where
        T: Clone,
    {
        pub fn cloned(&self) -> T {
            self.value.clone()
        }
    }

    pub enum BoundedEnum<T>
    where
        T: Clone,
    {
        Empty,
        Value(T),
    }

    pub struct BoundedTuple<T>(pub T)
    where
        T: Clone;
}

#[test]
fn reflected_accessors_preserve_where_bounds() {
    let value = probe::Bounded {
        value: String::from("value"),
    };
    let fields = <probe::Bounded<String> as HasFields>::fields();
    assert_eq!(fields.value.get(&value), "value");
    let methods = <probe::Bounded<String> as HasMethods>::methods();
    assert_eq!(methods.cloned.call(&value), "value");

    let variant = probe::BoundedEnum::Value(String::from("enum"));
    let _ = <probe::BoundedEnum<String> as HasVariantFields>::variant_fields();
    match variant {
        probe::BoundedEnum::Value(value) => assert_eq!(value, "enum"),
        probe::BoundedEnum::Empty => panic!("expected value variant"),
    }

    let tuple = probe::BoundedTuple(String::from("tuple"));
    let tuple_fields = <probe::BoundedTuple<String> as HasFields>::fields();
    assert_eq!(tuple_fields.field_0.get(&tuple), "tuple");
}
