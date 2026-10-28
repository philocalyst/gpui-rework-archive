use cephal::style::{Dimension, Display};
use gpui_reactivity_core::NodeKind;
use gpui_reactivity_core::layout::{AvailableSpace, LayoutTree, Size, Style};

fn main() {
    let mut tree = LayoutTree::new();
    let root = tree
        .insert(
            None,
            NodeKind::Element,
            Style {
                display: Display::Flex,
                size: Size {
                    width: Dimension::length(300.0),
                    height: Dimension::AUTO,
                },
                ..Style::DEFAULT
            },
        )
        .unwrap();
    let item = Style {
        flex_grow: 1.0,
        size: Size {
            width: Dimension::AUTO,
            height: Dimension::length(40.0),
        },
        ..Style::DEFAULT
    };
    let a = tree
        .insert(Some(root), NodeKind::Element, item.clone())
        .unwrap();
    let b = tree
        .insert(Some(root), NodeKind::Element, item.clone())
        .unwrap();
    let viewport = Size {
        width: AvailableSpace::Definite(300.0),
        height: AvailableSpace::MaxContent,
    };
    tree.compute(root, viewport).unwrap();
    assert_eq!(tree.layout(b).unwrap().location.x, 150.0);
    tree.set_style(
        a,
        Style {
            flex_grow: 3.0,
            ..item
        },
    )
    .unwrap();
    tree.compute(root, viewport).unwrap();
    assert_eq!(tree.layout(b).unwrap().location.x, 225.0);
    let before = tree.stats();
    assert!(!tree.compute(root, viewport).unwrap());
    assert_eq!(tree.stats(), before);
    println!(
        "unrounded layout {:?}; storage {:?}; stats {:?}",
        tree.layout(b).unwrap(),
        tree.storage(),
        tree.stats()
    );
    println!(
        "Style={} Layout={} NodeCache={}",
        std::mem::size_of::<Style>(),
        std::mem::size_of::<cephal::Layout>(),
        std::mem::size_of::<cephal::NodeCache>()
    );
}
