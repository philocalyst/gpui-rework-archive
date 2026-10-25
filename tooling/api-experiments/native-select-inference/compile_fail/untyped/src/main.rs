use native_select_inference::{Card, Node, Root, Select};

fn main() {
    let mut nodes = [Node { class: "card", value: Box::new(Card { title: String::new(), count: 0 }) }];
    let mut root = Root::new(&mut nodes);
    // A structural class selector cannot tell Rust the concrete callback target on its own.
    root.select(Select::descendants().class("card"), |card| card.count += 1);
}
