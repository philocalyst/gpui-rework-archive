use shape_api_experiment::Shape;
#[derive(Shape)]
struct Generic<T: 'static> {
    value: T,
}
fn main() {}
