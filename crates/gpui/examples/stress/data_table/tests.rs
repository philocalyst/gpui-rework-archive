//! Sort and select real virtual rows; check that reordering never changes row identity.
use super::*;
use gpui::TestAppContext;

#[gpui::test]
fn sorts_both_directions_without_losing_selection(cx: &mut TestAppContext) {
    let (view, cx) = cx.add_window_view(|_, _| DataTable::new());
    cx.simulate_resize(size(px(960.), px(640.)));
    let first = cx
        .debug_bounds("quote-row-position-0")
        .expect("first virtual row should be rendered");
    cx.simulate_click(first.center(), gpui::Modifiers::default());
    let selected = cx.read_entity(&view, |view, _| view.selected.unwrap());
    for (selector, descending) in [
        ("sort-price", false),
        ("sort-price", true),
        ("sort-symbol", false),
    ] {
        let bounds = cx
            .debug_bounds(selector)
            .expect("sortable header should be rendered");
        cx.simulate_click(bounds.center(), gpui::Modifiers::default());
        cx.read_entity(&view, |view, _| {
            assert_eq!(
                view.descending, descending,
                "repeated header clicks must reverse sort direction"
            );
            assert_eq!(
                view.selected,
                Some(selected),
                "selection must use identity rather than visible position"
            );
            let mut identities = view.order.clone();
            identities.sort_unstable();
            assert_eq!(
                identities,
                (0..view.rows.len()).collect::<Vec<_>>(),
                "sorting must preserve every row exactly once"
            );
            if view.sort_by == SortBy::Price {
                assert!(view.order.windows(2).all(|rows| {
                    let a = view.rows[rows[0]].price;
                    let b = view.rows[rows[1]].price;
                    if descending { a >= b } else { a <= b }
                }));
            }
        });
    }
}
