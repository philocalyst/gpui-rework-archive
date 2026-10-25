use schema_slots_frontier::{Describe,FieldDescriptor,Schema,SchemaBuilder};
struct A(u8); struct B(u8);
impl Describe for A {fn describe()->SchemaBuilder<A>{SchemaBuilder::record(|_:&A|())}}
impl Describe for B {fn describe()->SchemaBuilder<B>{SchemaBuilder::record(|_:&B|())}}
fn main(){ let schema=Schema::<A>::of(); let _=schema.field(FieldDescriptor::new("x",|b:&B|&b.0,|b:&mut B|&mut b.0)); }
