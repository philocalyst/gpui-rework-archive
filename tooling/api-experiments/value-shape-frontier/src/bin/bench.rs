use std::any::Any;
use std::any::TypeId;
use std::hint::black_box;
use std::time::Instant;
use value_shape_frontier::{DynValue, Field, FieldSchema, Path, RecordSchema, Shape};

struct Row {
    key: u64,
    value: u64,
}
struct U64Shape;
impl Shape for U64Shape {
    fn name(&self) -> &'static str {
        "u64"
    }
    fn type_id(&self) -> TypeId {
        TypeId::of::<u64>()
    }
    fn accepts(&self, v: &dyn Any) -> bool {
        v.is::<u64>()
    }
    fn field<'a>(&self, _: &'a mut dyn Any, _: &str) -> Option<DynValue<'a>> {
        None
    }
    fn variant(&self, _: &dyn Any) -> Option<&'static str> {
        None
    }
}
static U64: U64Shape = U64Shape;
static KEY: Field<Row, u64> = Field::new("key", &U64, |r| Some(&mut r.key));
static VAL: Field<Row, u64> = Field::new("value", &U64, |r| Some(&mut r.value));
static FIELDS: &[&dyn FieldSchema] = &[&KEY, &VAL];
static SCHEMA: RecordSchema<Row> = RecordSchema::new("Row", FIELDS);

fn main() {
    const N: usize = 2_000_000;
    let typed_path = Path::<Row, u64>::new("value", |r| &r.value, |r| &mut r.value);
    let mut row = Row { key: 0, value: 0 };
    let start = Instant::now();
    let mut typed_sum = 0u64;
    for i in 0..N {
        row.key = i as u64;
        row.value = (i * 3) as u64;
        typed_sum = typed_sum.wrapping_add(*typed_path.get(&row));
        *typed_path.get_mut(&mut row) += 1;
        black_box(&row);
    }
    let typed = start.elapsed();

    let start = Instant::now();
    let mut dynamic_sum = 0u64;
    for i in 0..N {
        let mut row: Box<dyn Any> = Box::new(Row {
            key: i as u64,
            value: (i * 3) as u64,
        });
        let schema: &'static dyn Shape = &SCHEMA;
        let mut dynamic = DynValue::erased(row.as_mut(), schema).unwrap();
        let mut field = dynamic.field("value").unwrap();
        dynamic_sum = dynamic_sum.wrapping_add(*field.downcast_ref::<u64>().unwrap());
        *field.downcast_mut::<u64>().unwrap() += 1;
        black_box(&row);
    }
    let dynamic = start.elapsed();
    println!(
        "iterations={N} typed_path={:.2} ns/op dynamic_named_field={:.2} ns/op checksums={typed_sum}:{dynamic_sum}",
        typed.as_nanos() as f64 / N as f64,
        dynamic.as_nanos() as f64 / N as f64
    );
}
