//! Pointer state and a real drag/drop sequence, including release outside the source.
use super::*;
use gpui::TestAppContext;

#[gpui::test]
fn pointer_events_update_the_view(cx: &mut TestAppContext) {
    let (view, cx) = cx.add_window_view(InteractionLesson::new);
    cx.simulate_resize(size(px(920.), px(760.)));
    let bounds = cx
        .debug_bounds("click-button")
        .expect("click button should be rendered");
    cx.simulate_click(bounds.center(), gpui::Modifiers::default());
    cx.read_entity(&view, |view, _| assert_eq!(view.clicks, 1));
    let bounds = cx
        .debug_bounds("mouse-target")
        .expect("mouse panel should be rendered");
    cx.simulate_mouse_down(
        bounds.center(),
        gpui::MouseButton::Left,
        gpui::Modifiers::default(),
    );
    cx.read_entity(&view, |view, _| assert!(view.mouse_pressed));
    cx.simulate_mouse_up(
        bounds.center(),
        gpui::MouseButton::Left,
        gpui::Modifiers::default(),
    );
    cx.read_entity(&view, |view, _| assert!(!view.mouse_pressed));
    cx.simulate_mouse_down(
        bounds.center(),
        gpui::MouseButton::Left,
        gpui::Modifiers::default(),
    );
    cx.simulate_mouse_up(
        gpui::point(px(0.), px(0.)),
        gpui::MouseButton::Left,
        gpui::Modifiers::default(),
    );
    cx.read_entity(&view, |view, _| assert!(!view.mouse_pressed));
}

#[gpui::test]
fn dragging_transfers_payload_and_cleans_up_preview(cx: &mut TestAppContext) {
    let (view, cx) = cx.add_window_view(InteractionLesson::new);
    cx.simulate_resize(size(px(920.), px(760.)));
    let source = cx
        .debug_bounds("drag-item-1")
        .expect("drag source should be rendered")
        .center();
    let target = cx
        .debug_bounds("drop-target")
        .expect("drop target should be rendered")
        .center();
    cx.simulate_mouse_down(source, gpui::MouseButton::Left, gpui::Modifiers::default());
    cx.simulate_mouse_move(
        target,
        Some(gpui::MouseButton::Left),
        gpui::Modifiers::default(),
    );
    cx.simulate_mouse_up(target, gpui::MouseButton::Left, gpui::Modifiers::default());
    cx.read_entity(&view, |view, _| {
        assert_eq!(view.dropped.map(|item| item.index), Some(1))
    });
    assert!(
        cx.debug_bounds("drag-preview").is_none(),
        "drop must remove the preview"
    );
}
