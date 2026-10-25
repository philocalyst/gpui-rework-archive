use value_shape_frontier_compile_fail::{dynamic, Pair};
fn main() {
    let mut pair = Pair { left: 1, right: 2 };
    let mut root = dynamic(&mut pair);
    let mut left = root.field("left").unwrap();
    let mut right = root.field("right").unwrap();
    *left.downcast_mut::<i32>().unwrap() += 1;
    *right.downcast_mut::<i32>().unwrap() += 1;
}
