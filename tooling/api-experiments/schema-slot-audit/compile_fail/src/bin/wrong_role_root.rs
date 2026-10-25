use schema_slot_audit::production::{Role, Schema};

trait View {}
struct A;
struct B;
impl View for A {}

fn main() {
    let role = Role::<A, dyn View>::new(|a| a).into_schema();
    let _ = Schema::<B>::with_roles(vec![], None, vec![role]);
}
