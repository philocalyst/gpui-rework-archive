use std::any::{Any, TypeId};
use value_shape_frontier::{DynValue, Field, FieldSchema, RecordSchema, Shape, ValueShape};
pub struct Pair { pub left: i32, pub right: i32 }
struct I32Shape;
impl Shape for I32Shape {
    fn name(&self) -> &'static str { "i32" }
    fn type_id(&self) -> TypeId { TypeId::of::<i32>() }
    fn accepts(&self, v: &dyn Any) -> bool { v.is::<i32>() }
    fn field<'a>(&self, _: &'a mut dyn Any, _: &str) -> Option<DynValue<'a>> { None }
    fn variant(&self, _: &dyn Any) -> Option<&'static str> { None }
}
static I32: I32Shape = I32Shape;
static LEFT: Field<Pair, i32> = Field::new("left", &I32, |p| Some(&mut p.left));
static RIGHT: Field<Pair, i32> = Field::new("right", &I32, |p| Some(&mut p.right));
static FIELDS: &[&dyn FieldSchema] = &[&LEFT, &RIGHT];
static SCHEMA: RecordSchema<Pair> = RecordSchema::new("Pair", FIELDS);
impl ValueShape for Pair { fn schema() -> &'static dyn Shape { &SCHEMA } }
pub fn dynamic(pair: &mut Pair) -> DynValue<'_> { DynValue::new(pair) }
