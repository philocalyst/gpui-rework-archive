use module_reflection_frontier::reflect;

#[reflect]
mod model {
    pub struct Node;

    pub trait HasValue {
        type Value;
        fn value(&self) -> Self::Value;
    }

    impl HasValue for Node {
        type Value = usize;
        fn value(&self) -> usize { 0 }
    }
}

fn main() {}
