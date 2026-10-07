//! Compare state ownership by dispatching input and forcing parent redraws.
use super::*;
use gpui::{TestAppContext, VisualTestContext};

fn click(cx: &mut VisualTestContext, selector: &'static str) {
    let bounds = cx
        .debug_bounds(selector)
        .expect("counter control should be rendered");
    cx.simulate_click(bounds.center(), gpui::Modifiers::default());
}

fn counts(cx: &VisualTestContext, view: &Entity<CreatingComponents>) -> [i32; 3] {
    cx.read_entity(view, |view, cx| {
        [
            view.rendered_element_count,
            view.prop_count,
            view.entity_counter.read(cx).count,
        ]
    })
}

#[gpui::test]
fn independent_counters_survive_parent_redraws_and_reset(cx: &mut TestAppContext) {
    let (view, cx) = cx.add_window_view(|_, cx| CreatingComponents::new(cx));
    cx.simulate_resize(size(px(760.), px(360.)));
    for (index, selector) in ["element-increment", "props-increment", "entity-increment"]
        .into_iter()
        .enumerate()
    {
        click(cx, selector);
        let expected = std::array::from_fn(|position| i32::from(position <= index));
        assert_eq!(counts(cx, &view), expected);
    }
    assert_eq!(counts(cx, &view), [1, 1, 1]);
    click(cx, "props-increment");
    cx.update_entity(&view, |_, cx| cx.notify());
    cx.run_until_parked();
    assert_eq!(
        counts(cx, &view),
        [1, 2, 1],
        "redrawing the parent must preserve element and entity state"
    );
    for selector in [
        "element-decrement",
        "props-decrement",
        "props-decrement",
        "entity-decrement",
    ] {
        click(cx, selector);
    }
    assert_eq!(counts(cx, &view), [0, 0, 0]);
}
