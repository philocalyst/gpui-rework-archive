// Private coordinated codec regression tests. Expected USV/UTF-16 offsets are
// independent counts, not values computed through the codec under test.
use crate::Tree;
use accesskit::{Node, NodeId, Role, TextPosition, TextSelection, TreeId, TreeInfo, TreeUpdate};
use alloc::{format, vec};

#[test]
fn long_grapheme_keeps_one_stop_across_usv_and_utf16_ranges() {
    let value = format!("La{}🦀e\u{301}\r\nא", "\u{301}".repeat(4096));
    let mut input = Node::new(Role::TextInput);
    input.push_child(NodeId(2));
    input.set_text_selection(TextSelection {
        anchor: TextPosition {
            node: NodeId(2),
            character_index: 4,
        },
        focus: TextPosition {
            node: NodeId(2),
            character_index: 1,
        },
    });
    let mut run = Node::new(Role::TextRun);
    run.set_value(value.clone());
    assert!(run.set_text_character_lengths([1, 8193, 4, 3, 2, 2]));
    assert_eq!(run.character_lengths(), &[1, 0, 4, 3, 2, 2]);
    let tree = Tree::new(
        TreeUpdate {
            nodes: vec![(NodeId(1), input), (NodeId(2), run)],
            tree: Some(TreeInfo::new(NodeId(1))),
            tree_id: TreeId::ROOT,
            focus: NodeId(1),
        },
        true,
    );
    let input = tree
        .state()
        .node_by_tree_local_id(NodeId(1), TreeId::ROOT)
        .unwrap();
    assert_eq!(input.document_range().text(), value);
    for (unit, usv, utf16) in [
        (0, 0, 0),
        (1, 1, 1),
        (2, 4098, 4098),
        (3, 4099, 4100),
        (4, 4101, 4102),
        (5, 4103, 4104),
        (6, 4104, 4105),
    ] {
        let p = input.text_position_from_global_usv_index(usv).unwrap();
        assert_eq!(
            p.to_degenerate_range()
                .to_text_selection()
                .anchor
                .character_index,
            unit
        );
        assert_eq!(p.to_global_utf16_index(), utf16);
        let p = input.text_position_from_global_utf16_index(utf16).unwrap();
        assert_eq!(p.to_global_usv_index(), usv);
    }
    for usv in 2..4098 {
        assert_eq!(
            input
                .text_position_from_global_usv_index(usv)
                .unwrap()
                .to_global_usv_index(),
            1
        );
    }
    assert_eq!(
        input
            .text_position_from_global_utf16_index(4099)
            .unwrap()
            .to_global_utf16_index(),
        4098
    );
    assert!(input.text_position_from_global_usv_index(4105).is_none());
    assert!(input.text_position_from_global_utf16_index(4106).is_none());
    assert_eq!(
        input.text_selection_anchor().unwrap().to_global_usv_index(),
        4101
    );
    assert_eq!(
        input.text_selection_focus().unwrap().to_global_usv_index(),
        1
    );
    assert_eq!(input.text_selection().unwrap().text(), &value[1..8201]);
}

#[test]
fn invalid_serialized_shape_cannot_upgrade_to_a_text_range() {
    let mut input = Node::new(Role::TextInput);
    input.push_child(NodeId(2));
    input.set_text_selection(TextSelection {
        anchor: TextPosition {
            node: NodeId(2),
            character_index: 0,
        },
        focus: TextPosition {
            node: NodeId(2),
            character_index: 1,
        },
    });
    let mut run = Node::new(Role::TextRun);
    run.set_value("é");
    run.set_character_lengths([1, 1]);
    let tree = Tree::new(
        TreeUpdate {
            nodes: vec![(NodeId(1), input), (NodeId(2), run)],
            tree: Some(TreeInfo::new(NodeId(1))),
            tree_id: TreeId::ROOT,
            focus: NodeId(1),
        },
        true,
    );
    let input = tree
        .state()
        .node_by_tree_local_id(NodeId(1), TreeId::ROOT)
        .unwrap();
    assert!(!input.supports_text_ranges());
    assert!(!input.has_text_selection());
    assert!(input.text_selection().is_none());
}
