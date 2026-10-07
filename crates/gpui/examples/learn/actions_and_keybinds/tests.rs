//! Exercise key routing through the focused view, including reset and blur.
use super::*;
use gpui::TestAppContext;

#[gpui::test]
fn shortcuts_follow_focus_and_reset_the_counter(cx: &mut TestAppContext) {
    cx.update(register_keybinds);
    let (view, cx) = cx.add_window_view(ActionsExample::new);
    cx.simulate_keystrokes("space space space");
    cx.read_entity(&view, |view, _| assert_eq!(view.count, 3));
    cx.simulate_keystrokes("backspace");
    cx.read_entity(&view, |view, _| assert_eq!(view.count, 0));
    cx.update(|window, cx| window.blur(cx));
    cx.simulate_keystrokes("space");
    cx.read_entity(&view, |view, _| {
        assert_eq!(view.count, 0, "a blurred counter must ignore shortcuts")
    });
}
