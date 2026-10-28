#![feature(auto_traits, negative_impls, trait_alias, type_alias_impl_trait)]
mod private {
    pub auto trait Leaf {}
    pub struct Signal<T>(pub T);
    impl<T> !Leaf for Signal<T> {}
}
trait SourceValue = private::Leaf;
fn accepts<T: SourceValue>(value: T) -> T { value }
type Product = impl Iterator<Item = u32>;
#[define_opaque(Product)]
fn product() -> Product { [2, 3, 5].into_iter() }
fn main() {
    assert_eq!(accepts(product()).sum::<u32>(), 10);
    assert_eq!(accepts(vec![1, 2, 3]), [1, 2, 3]);
}
