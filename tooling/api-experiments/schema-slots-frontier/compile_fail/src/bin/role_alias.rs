use schema_slots_frontier::{Describe,RoleRegistration,Schema,SchemaBuilder};
struct A; struct B;
impl Describe for A {fn describe()->SchemaBuilder<A>{SchemaBuilder::record(|_:&A|())}}
impl Describe for B {fn describe()->SchemaBuilder<B>{SchemaBuilder::record(|_:&B|())}}
fn main(){ let role=RoleRegistration::new("a",&Schema::<A>::of()); let _:RoleRegistration<B>=role; }
