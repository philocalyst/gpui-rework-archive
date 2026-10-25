use schema_slot_audit::production::Field;

struct A(u8);

fn main() {
    let field = Field::new("0", |a: &A| &a.0, |a: &mut A| &mut a.0);
    let mut a = A(1);
    let first = field.get_mut(&mut a);
    let second = field.get_mut(&mut a);
    *first += *second;
}
