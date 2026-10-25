//! The public example model runs through the ordinary exclusive window API.
#[path = "../examples/support/library.rs"]
mod library;

use gpui::{Application, Error, ItemKey, Role, Target, Win, WindowOptions};
use library::{LIBRARY, Library, catalogue::TrackId};

fn play_target(win: &Win<Library>, list: Target, key: u64) -> Target {
    let item = win.list_item(list, ItemKey::new(key)).unwrap();
    win.role(Role::Button)
        .within(item)
        .text("Play")
        .one()
        .unwrap()
}

fn open() -> Win<Library> {
    Application::demo()
        .options(WindowOptions {
            size: [760, 600],
            ..Default::default()
        })
        .open(Library::new(250_000))
        .unwrap()
}

#[test]
fn quarter_million_catalogue_uses_bounded_visible_rows_and_real_actions() {
    let mut win = open();
    let list = win.list(LIBRARY).unwrap();
    let state = win.list_state(list).unwrap();
    assert_eq!(state.len, 250_000);
    assert_eq!(state.visible_range, 0..13);
    assert_eq!(win.role(Role::Button).count().unwrap(), 15);

    let old = play_target(&win, list, 0);
    let before = win.counters();
    win.scroll_to_key(list, ItemKey::new(200_000)).unwrap();
    assert_eq!(win.counters().source_operations, before.source_operations);
    assert_eq!(win.bounds(old), Err(Error::StaleTarget));
    assert!(win.list_state(list).unwrap().visible_range.start >= 200_000);
    let play = play_target(&win, list, 200_000);
    win.click(play).unwrap();
    assert_eq!(
        win.with_model(|model| (model.selected, model.play_requests))
            .unwrap(),
        (Some(TrackId(200_000)), 1)
    );
    assert_eq!(play_target(&win, list, 200_000), play);

    win.scroll_to_index(list, 0).unwrap();
    assert_ne!(play_target(&win, list, 0), old);
    assert!(win.inspect().unwrap().nodes.len() < 100);
}

#[test]
fn catalogue_reorder_and_prepend_preserve_key_routes_and_anchor() {
    let mut win = open();
    let list = win.list(LIBRARY).unwrap();
    win.scroll_to_key(list, ItemKey::new(120_000)).unwrap();
    let before = play_target(&win, list, 120_000);

    let prepend = win
        .role(Role::Button)
        .text("Prepend recording")
        .one()
        .unwrap();
    win.click(prepend).unwrap();
    assert_eq!(play_target(&win, list, 120_000), before);
    assert_eq!(win.list_state(list).unwrap().visible_range.start, 120_001);

    let reverse = win.role(Role::Button).text("Reverse order").one().unwrap();
    win.click(reverse).unwrap();
    assert_eq!(play_target(&win, list, 120_000), before);
    win.click(before).unwrap();
    assert_eq!(
        win.with_model(|model| model.selected).unwrap(),
        Some(TrackId(120_000))
    );
}

#[test]
fn far_tail_geometry_stays_local_and_borrowed_queries_do_not_allocate() {
    let mut win = open();
    let list = win.list(LIBRARY).unwrap();
    win.scroll_to_index(list, 249_999).unwrap();
    let item = win.list_item(list, ItemKey::new(249_999)).unwrap();
    let counted = allocation_counter::measure(|| {
        for _ in 0..100 {
            assert_eq!(win.role(Role::Button).within(item).count().unwrap(), 1);
            let target = win.role(Role::Button).within(item).one().unwrap();
            assert!(win.bounds(target).unwrap().height > 0.0);
        }
    });
    assert_eq!(counted.count_total, 0);
    let snapshot = win.inspect().unwrap();
    assert!(snapshot.nodes.len() < 100);
    for node in &snapshot.nodes {
        assert!(
            node.bounds
                .iter()
                .all(|value| value.is_finite() && value.abs() < 1_000_000.0)
        );
        if let Some(transform) = node.transform {
            assert!(
                transform
                    .iter()
                    .all(|value| value.is_finite() && value.abs() < 1_000_000.0)
            );
        }
    }
}

#[test]
fn the_same_library_component_routes_to_its_exclusive_parent_field() {
    use gpui::{Component, El, FieldId, ListId, Sources, View, row};
    struct Pair {
        left: Library,
        right: Library,
    }
    impl Pair {
        const LEFT: Component<Self, Library> = Component::new(
            FieldId::new(1),
            "left",
            |pair| &pair.left,
            |pair| &mut pair.left,
        );
        const RIGHT: Component<Self, Library> = Component::new(
            FieldId::new(2),
            "right",
            |pair| &pair.right,
            |pair| &mut pair.right,
        );
    }
    impl View for Pair {
        fn sources() -> Sources<Self> {
            Sources::new().component(Self::LEFT).component(Self::RIGHT)
        }
        fn view(&self) -> El<'_> {
            row((Self::LEFT.view(self), Self::RIGHT.view(self))).gap(8)
        }
    }
    let mut win = Application::demo()
        .options(WindowOptions {
            size: [1520, 600],
            ..Default::default()
        })
        .open(Pair {
            left: Library::with_id(100, ListId::new(1)),
            right: Library::with_id(100, ListId::new(2)),
        })
        .unwrap();
    let list = win.list(ListId::new(2)).unwrap();
    let item = win.list_item(list, ItemKey::new(5)).unwrap();
    let play = win.role(Role::Button).within(item).one().unwrap();
    win.click(play).unwrap();
    assert_eq!(
        win.with_model(|pair| (pair.left.selected, pair.right.selected))
            .unwrap(),
        (None, Some(TrackId(5)))
    );
}
