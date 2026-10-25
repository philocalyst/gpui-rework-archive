use compiler_reflection_frontier::native_trait_object;

trait Touch { fn touch(&mut self); }
struct Item(u8);
impl Touch for Item { fn touch(&mut self) { self.0 += 1; } }

fn main() {
    let mut value = Item(0);
    let trait_borrow = native_trait_object::<Item, dyn Touch>(&mut value).unwrap();
    let second_borrow = &mut value;
    trait_borrow.touch();
    second_borrow.0 += 1;
}
