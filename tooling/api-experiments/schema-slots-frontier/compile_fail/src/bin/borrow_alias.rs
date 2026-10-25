use schema_slots_frontier::{Describe,FieldDescriptor,Schema,SchemaBuilder};
struct A(u8);
impl Describe for A {fn describe()->SchemaBuilder<A>{SchemaBuilder::record(|_:&A|())}}
fn main(){let schema=Schema::<A>::of();let field=schema.field(FieldDescriptor::new("x",|a:&A|&a.0,|a:&mut A|&mut a.0));let mut a=A(1);let first=field.get_mut(&mut a);let second=field.get_mut(&mut a);*first+=*second;}
