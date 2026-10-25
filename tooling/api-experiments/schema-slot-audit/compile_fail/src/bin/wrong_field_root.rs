use schema_slot_audit::production::{Field, Schema, Type};

struct A {
    value: u32,
}
struct B {
    value: u32,
}

fn main() {
    let field = Field::new("value", |a: &A| &a.value, |a: &mut A| &mut a.value);
    let _ = Schema::<B>::new(vec![field.into_schema(|| Type::opaque::<u32>())], None);
}
