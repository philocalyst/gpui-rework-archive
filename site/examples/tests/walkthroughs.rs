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
    ($name:ident, $source:literal $(, $test:item)*) => {
        #[allow(dead_code)]
        mod $name {
            include!($source);

            #[::core::prelude::v1::test]
            fn initial_and_rebuilt_frames() {
                super::draw_twice(component);
            }

            $($test)*
        }
    };
}

walkthrough!(first_window, "../examples/first-window.rs");
walkthrough!(
    counter,
    "../examples/counter.rs",
    #[test]
    fn tab_then_keyboard_activation_changes_the_canonical_counter() {
        use gpui::{InputEvent, KeyDownEvent, KeyUpEvent, Keystroke, TestApp, WindowOptions};
        let mut app = TestApp::new();
        let handle = app.update(|cx| cx.open_window(WindowOptions::default(), component).unwrap());
        let window: gpui::AnyWindowHandle = handle.into();
        let tab = app.update(|cx| {
            window
                .update(cx, |_, window, cx| {
                    window.dispatch_event(
                        KeyDownEvent {
                            keystroke: Keystroke::parse("tab").unwrap(),
                            is_held: false,
                            prefer_character_input: false,
                        }
                        .to_platform_input(),
                        cx,
                    )
                })
                .unwrap()
        });
        assert!(
            !tab.propagate,
            "Tab must not escape to the containing browser page"
        );
        app.update(|cx| {
            window
                .update(cx, |_, window, cx| {
                    assert!(window.focused(cx).is_some());
                    for key in ["enter", "space"] {
                        let keystroke = Keystroke::parse(key).unwrap();
                        window.dispatch_event(
                            KeyDownEvent {
                                keystroke: keystroke.clone(),
                                is_held: false,
                                prefer_character_input: false,
                            }
                            .to_platform_input(),
                            cx,
                        );
                        window.dispatch_event(KeyUpEvent { keystroke }.to_platform_input(), cx);
                    }
                })
                .unwrap()
        });
        assert_eq!(app.read(|cx| handle.read(cx).unwrap().count), 2);
    }
);
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
