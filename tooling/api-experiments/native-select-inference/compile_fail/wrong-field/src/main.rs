use native_select_inference::{Card, Node, Root, Select};

fn main() {
    let mut nodes = [Node { class: "card", value: Box::new(Card { title: String::new(), count: 0 }) }];
    let mut root = Root::new(&mut nodes);
    // The selector carries the field value type String, so it cannot lend u32.
    root.select(Select::descendants().class("card").field(Card::fields().title), |_wrong: &mut u32| {});
}
