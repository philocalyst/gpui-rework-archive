//! Declaration costs through the same child API used by application views.
use gpui::{El, View, prelude::*};

fn census<'a>(label: &str, build: impl FnOnce() -> El<'a>) {
    let mut declaration = None;
    let cost = allocation_counter::measure(|| declaration = Some(build()));
    println!(
        "CHILDREN {label} allocations={} requested={} retained={} peak={}",
        cost.count_total, cost.bytes_total, cost.bytes_current, cost.bytes_max
    );
    drop(declaration);
}

fn chain(depth: usize) -> El<'static> {
    (0..depth).fold(div(), |child, _| div().child(child))
}

#[test]
fn declaration_allocation_census() {
    census("leaf", div);
    census("single", || div().child(div()));
    census("optional-none", || div().child(None::<El<'_>>));
    census("optional-some", || div().child(Some(div())));
    census("tuple-six", || {
        row((div(), div(), div(), div(), div(), div()))
    });
    census("tuple-nested", || {
        row(((div(), div()), Some((div(), div())), None::<El<'_>>))
    });
    census("iterator-empty", || column(std::iter::empty::<El<'_>>()));
    census("iterator-wide", || column((0..10_000).map(|_| div())));
    census("iterator-pairs", || {
        column((0..5_000).map(|_| (div(), div())))
    });
    census("iterator-filtered", || {
        column((0..10_000).filter(|i| i % 2 == 0).map(|_| div()))
    });
    census("appended-groups", || {
        div().child(div()).child((0..10).map(|_| div()))
    });
    census("chain-129", || chain(129));
    census("chain-4096", || chain(4096));
    struct Leaf;
    impl View for Leaf {
        fn view(&self) -> El<'_> {
            div()
        }
    }
    let views = (0..10_000).map(|_| Leaf).collect::<Vec<_>>();
    census("borrowed-views", || column(&views));
}

#[test]
fn nested_child_families_keep_their_public_preorder() {
    struct Page;
    impl View for Page {
        fn view(&self) -> El<'_> {
            column((
                text("first"),
                Some((text("second"), text("third"))),
                None::<El<'_>>,
                (0..3).map(|_| (text("fourth"), text("fifth"))),
            ))
        }
    }
    let win = gpui::Win::demo(Page);
    let texts = win
        .snapshot()
        .unwrap()
        .nodes
        .into_iter()
        .filter_map(|node| node.text)
        .collect::<Vec<_>>();
    assert_eq!(
        texts,
        [
            "first", "second", "third", "fourth", "fifth", "fourth", "fifth", "fourth", "fifth"
        ]
    );
}

#[test]
fn known_child_counts_need_one_exact_declaration_allocation() {
    for count in [1, 2, 6, 129, 10_000] {
        let mut declaration = None;
        let cost = allocation_counter::measure(|| {
            declaration = Some(column((0..count).map(|_| div())));
        });
        assert_eq!(cost.count_total, 1, "child count {count}");
        assert_eq!(
            cost.bytes_total as usize,
            count * size_of::<El<'_>>(),
            "child count {count}"
        );
        drop(declaration);
    }
}
