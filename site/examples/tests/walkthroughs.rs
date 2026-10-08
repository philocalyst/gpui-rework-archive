//! Draw the canonical programs, rather than separate approximations of their trees.

fn draw_twice<V: gpui::Render + 'static>(
    build: impl FnOnce(&mut gpui::Window, &mut gpui::App) -> gpui::Entity<V> + 'static,
) {
    let mut app = gpui::TestApp::new();
    let handle: gpui::AnyWindowHandle = app
        .update(|cx| {
            cx.open_window(gpui::WindowOptions::default(), build)
                .expect("open the canonical walkthrough")
        })
        .into();
    for _ in 0..2 {
        app.update(|cx| {
            handle
                .update(cx, |_, window, cx| {
                    window.refresh();
                    window.draw(cx).clear(cx);
                })
                .expect("draw the canonical walkthrough");
        });
    }
}

macro_rules! walkthrough {
    ($name:ident, $source:literal) => {
        #[allow(dead_code)]
        mod $name {
            include!($source);

            #[::core::prelude::v1::test]
            fn initial_and_rebuilt_frames() {
                super::draw_twice(component);
            }
        }
    };
}

walkthrough!(first_window, "../examples/first-window.rs");
walkthrough!(counter, "../examples/counter.rs");
walkthrough!(layout, "../examples/layout.rs");
walkthrough!(actions, "../examples/actions.rs");
walkthrough!(lists, "../examples/lists.rs");
walkthrough!(drawing, "../examples/drawing.rs");
walkthrough!(custom_element, "../examples/custom-element.rs");
walkthrough!(animation, "../examples/animation.rs");
walkthrough!(async_task, "../examples/async-task.rs");
walkthrough!(subscriptions, "../examples/subscriptions.rs");
walkthrough!(text, "../examples/text.rs");
walkthrough!(text_hit_testing, "../examples/text-hit-testing.rs");
