use native_select_inference::{Card, Node, Root, Select, mutate_any, mutate_direct};
use std::any::Any;
use std::hint::black_box;
use std::time::Instant;

fn main() {
    let mut nodes = [
        Node {
            class: "card",
            value: Box::new(Card {
                title: "one".into(),
                count: 0,
            }),
        },
        Node {
            class: "card",
            value: Box::new(Card {
                title: "two".into(),
                count: 0,
            }),
        },
        Node {
            class: "label",
            value: Box::new(String::from("other")),
        },
    ];
    let mut root = Root::new(&mut nodes);
    root.select(Select::descendants().class("card"), |card: &mut Card| {
        card.count += 1;
    });
    root.select(
        Select::descendants()
            .class("card")
            .field(Card::fields().title),
        |title: &mut String| title.push('!'),
    );
    root.select_mut(
        Select::descendants().class("label"),
        |erased: &mut dyn Any| {
            if let Some(label) = erased.downcast_mut::<String>() {
                label.push('!');
            }
        },
    );
    drop(root);

    const N: usize = 30_000_000;
    let mut direct = Card {
        title: String::new(),
        count: 0,
    };
    let start = Instant::now();
    for _ in 0..N {
        mutate_direct(black_box(&mut direct));
    }
    let direct_time = start.elapsed();

    let mut erased = Card {
        title: String::new(),
        count: 0,
    };
    let start = Instant::now();
    for _ in 0..N {
        mutate_any(black_box(&mut erased as &mut dyn Any));
    }
    let any_time = start.elapsed();

    println!(
        "API smoke: {nodes:?}",
        nodes = nodes.iter().map(|n| n.class).collect::<Vec<_>>()
    );
    println!(
        "direct projection: {direct_time:?} ({:.2} ns/iter)",
        direct_time.as_nanos() as f64 / N as f64
    );
    println!(
        "Any downcast projection: {any_time:?} ({:.2} ns/iter), ratio {:.2}x",
        any_time.as_nanos() as f64 / N as f64,
        any_time.as_secs_f64() / direct_time.as_secs_f64()
    );
    black_box((direct.count, erased.count));
}
