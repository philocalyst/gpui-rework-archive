use value_shape_frontier::Path;
struct Pair { left: i32 }
fn main() {
    let path = Path::<Pair, i32>::new("left", |p| &p.left, |p| &mut p.left);
    let _ = path.get(&String::from("wrong root type"));
}
