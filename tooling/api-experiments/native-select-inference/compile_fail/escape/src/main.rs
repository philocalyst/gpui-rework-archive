use native_select_inference::{Card, Node, Root, Select};

fn main() {
    let mut nodes = [Node { class: "card", value: Box::new(Card { title: String::new(), count: 0 }) }];
    let mut root = Root::new(&mut nodes);
    let mut escaped: Option<&mut Card> = None;
    root.select(Select::descendants().class("card"), |card: &mut Card| escaped = Some(card));
    let _ = escaped;
}
