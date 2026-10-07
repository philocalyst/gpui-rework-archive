//! Sample real dispatcher time and restart animations through their controls.
use super::*;
use gpui::{TestAppContext, VisualTestContext};
use std::time::Duration;

fn click(cx: &mut VisualTestContext, selector: &'static str) {
    let bounds = cx
        .debug_bounds(selector)
        .expect("animation control should be rendered");
    cx.simulate_click(bounds.center(), gpui::Modifiers::default());
}

#[gpui::test]
fn motion_advances_completes_and_restarts(cx: &mut TestAppContext) {
    let (view, cx) = cx.add_window_view(|_, cx| AnimationLesson::new(cx));
    cx.simulate_resize(size(px(720.), px(640.)));
    click(cx, "play-motion");
    for (elapsed, expected) in [(0, 0.), (450, 0.5), (450, 1.)] {
        cx.dispatcher.advance_clock(Duration::from_millis(elapsed));
        let progress = cx.read_entity(&view, |view, cx| {
            view.sample_motion(cx.background_executor().now())
                .map(|sample| sample.progress.get())
                .unwrap()
        });
        assert!(
            (progress - expected).abs() < 0.01,
            "expected progress {expected}, got {progress}"
        );
    }
    click(cx, "play-motion");
    cx.read_entity(&view, |view, cx| {
        assert_eq!(
            view.sample_motion(cx.background_executor().now())
                .map(|sample| sample.progress.get()),
            Some(0.)
        )
    });
    click(cx, "keyed-bounce");
    click(cx, "keyed-bounce");
    cx.read_entity(&view, |view, _| {
        assert_eq!(
            view.bounce_generation, 2,
            "each replay must remount keyed animation state"
        )
    });
}
