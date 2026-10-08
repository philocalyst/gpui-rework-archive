//! Tests for the input composition. Require the `test-support` feature:
//!
//! ```sh
//! cargo test -p gpui-ce --example view_example --features test-support
//! ```

#[cfg(test)]
mod tests {
    use gpui::{
        Context, Entity, EntityInputHandler, KeyBinding, TestAppContext, Window, prelude::*,
    };

    use crate::example_editor::Editor;
    use crate::example_input::Input;
    use crate::{Backspace, Delete, End, Home, Left, Right};

    /// Two inputs, each backed by an editor we own (so the test can focus and
    /// read them). Proves data flows through the shared `String` and that
    /// sibling inputs stay isolated.
    struct TwoInputs {
        a: Entity<Editor>,
        b: Entity<Editor>,
    }

    impl Render for TwoInputs {
        fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
            gpui::div()
                .child(Input::editor(self.a.clone(), "First input"))
                .child(Input::editor(self.b.clone(), "Second input"))
        }
    }

    fn bind_keys(cx: &mut TestAppContext) {
        cx.update(|cx| {
            cx.bind_keys([
                KeyBinding::new("backspace", Backspace, Some("TextInput")),
                KeyBinding::new("delete", Delete, Some("TextInput")),
                KeyBinding::new("left", Left, Some("TextInput")),
                KeyBinding::new("right", Right, Some("TextInput")),
                KeyBinding::new("home", Home, Some("TextInput")),
                KeyBinding::new("end", End, Some("TextInput")),
            ]);
        });
    }

    fn setup(
        cx: &mut TestAppContext,
    ) -> (
        Entity<Editor>,
        Entity<String>,
        Entity<String>,
        &mut gpui::VisualTestContext,
    ) {
        bind_keys(cx);

        let (inputs, cx) = cx.add_window_view(|window, cx| {
            let a_value = cx.new(|_| String::new());
            let b_value = cx.new(|_| String::new());
            let a = cx.new(|cx| Editor::over(a_value, window, cx));
            let b = cx.new(|cx| Editor::over(b_value, window, cx));
            TwoInputs { a, b }
        });

        let a = cx.read_entity(&inputs, |h, _| h.a.clone());
        let b = cx.read_entity(&inputs, |h, _| h.b.clone());
        let a_value = cx.read_entity(&a, |e, _| e.value.clone());
        let b_value = cx.read_entity(&b, |e, _| e.value.clone());

        // Focus the first input's editor.
        cx.update(|window, cx| {
            let focus_handle = a.read(cx).focus_handle.clone();
            window.focus(&focus_handle, cx);
        });

        (a, a_value, b_value, cx)
    }

    #[gpui::test]
    fn typing_updates_the_shared_string(cx: &mut TestAppContext) {
        let (editor, a_value, _b_value, cx) = setup(cx);

        cx.simulate_input("hello");

        cx.read_entity(&a_value, |value, _| assert_eq!(value, "hello"));
        cx.read_entity(&editor, |editor, _| assert_eq!(editor.cursor, 5));
    }

    #[gpui::test]
    fn sibling_inputs_are_isolated(cx: &mut TestAppContext) {
        let (_editor, a_value, b_value, cx) = setup(cx);

        cx.simulate_input("x");

        cx.read_entity(&a_value, |value, _| assert_eq!(value, "x"));
        cx.read_entity(&b_value, |value, _| {
            assert_eq!(value, "", "typing in input A must not touch input B")
        });
    }

    #[gpui::test]
    fn external_writes_clamp_the_cursor(cx: &mut TestAppContext) {
        let (editor, a_value, _b_value, cx) = setup(cx);

        cx.simulate_input("hello");
        cx.read_entity(&editor, |editor, _| assert_eq!(editor.cursor, 5));

        // Write the shared value from outside the editor. The old cursor (5)
        // now points into the middle of a multi-byte character; the editor's
        // observation must clamp it back onto a boundary.
        cx.update(|_, cx| {
            a_value.update(cx, |value, cx| {
                *value = "日本".to_string();
                cx.notify();
            })
        });

        cx.read_entity(&a_value, |value, _| assert_eq!(value, "日本"));
        cx.read_entity(&editor, |editor, _| {
            assert_eq!(editor.cursor, 3, "cursor must clamp to a char boundary");
        });
    }

    #[gpui::test]
    fn arrows_move_the_cursor(cx: &mut TestAppContext) {
        let (editor, _a_value, _b_value, cx) = setup(cx);

        cx.simulate_input("abc");
        cx.read_entity(&editor, |editor, _| assert_eq!(editor.cursor, 3));

        cx.simulate_keystrokes("left left");
        cx.read_entity(&editor, |editor, _| assert_eq!(editor.cursor, 1));
    }

    #[gpui::test]
    fn composition_replaces_candidates_then_commits(cx: &mut TestAppContext) {
        let (editor, value, _, cx) = setup(cx);
        cx.simulate_input("a🦀z");
        cx.update(|window, cx| {
            editor.update(cx, |editor, cx| {
                // UTF-16 1..3 covers the four-byte crab. The inserted selection
                // is relative to the candidate, not to the document.
                editor.replace_and_mark_text_in_range(Some(1..3), "に", Some(1..1), window, cx);
                assert_eq!(editor.marked_text_range(window, cx), Some(1..2));
                assert_eq!(
                    editor.selected_text_range(false, window, cx).unwrap().range,
                    2..2
                );
                editor.replace_and_mark_text_in_range(None, "日本", Some(0..2), window, cx);
                assert_eq!(editor.marked_text_range(window, cx), Some(1..3));
                assert_eq!(
                    editor.selected_text_range(false, window, cx).unwrap().range,
                    1..3
                );
            })
        });
        cx.read_entity(&value, |value, _| assert_eq!(value, "a日本z"));
        // Observing our own buffer notification must not end composition.
        cx.update(|window, cx| {
            editor.update(cx, |editor, cx| {
                assert_eq!(editor.marked_text_range(window, cx), Some(1..3));
                editor.replace_text_in_range(None, "日本語", window, cx);
                assert_eq!(editor.marked_text_range(window, cx), None);
                assert_eq!(
                    editor.selected_text_range(false, window, cx).unwrap().range,
                    4..4
                );
            })
        });
        cx.read_entity(&value, |value, _| assert_eq!(value, "a日本語z"));
    }

    #[gpui::test]
    fn reversed_selection_and_invalid_offsets_are_normalized(cx: &mut TestAppContext) {
        let (editor, value, _, cx) = setup(cx);
        cx.simulate_input("a🦀z");
        cx.update(|window, cx| {
            editor.update(cx, |editor, cx| {
                // A reversed selection keeps the active end at byte one.
                editor.set_selected_text_range(3..1, window, cx);
                let selection = editor.selected_text_range(false, window, cx).unwrap();
                assert_eq!(selection.range, 1..3);
                assert!(selection.reversed);
                assert_eq!(editor.text_length_utf16(window, cx), Some(4));
                editor.replace_text_in_range(None, "x", window, cx);
                let mut adjusted = None;
                assert_eq!(
                    editor
                        .text_for_range(usize::MAX..0, &mut adjusted, window, cx)
                        .as_deref(),
                    Some("axz")
                );
                assert_eq!(adjusted, Some(0..3));
            })
        });
        cx.read_entity(&value, |value, _| assert_eq!(value, "axz"));
        cx.simulate_keystrokes("home delete");
        cx.read_entity(&value, |value, _| assert_eq!(value, "xz"));
    }

    #[gpui::test]
    fn unmark_keeps_text_and_external_replacement_ends_composition(cx: &mut TestAppContext) {
        let (editor, value, _, cx) = setup(cx);
        cx.update(|window, cx| {
            editor.update(cx, |editor, cx| {
                editor.replace_and_mark_text_in_range(None, "に", None, window, cx);
                editor.unmark_text(window, cx);
                assert_eq!(editor.text(cx), "に");
                assert_eq!(editor.marked_text_range(window, cx), None);
                editor.replace_and_mark_text_in_range(Some(0..1), "日本", Some(0..2), window, cx);
            })
        });
        cx.update(|_, cx| {
            value.update(cx, |value, cx| {
                *value = "a".into();
                cx.notify();
            })
        });
        cx.update(|window, cx| {
            editor.update(cx, |editor, cx| {
                assert_eq!(editor.marked_text_range(window, cx), None);
                assert_eq!(
                    editor.selected_text_range(false, window, cx).unwrap().range,
                    0..1
                );
                editor.replace_text_in_range(None, "b", window, cx);
            })
        });
        cx.read_entity(&value, |value, _| assert_eq!(value, "b"));
    }
    #[gpui::test]
    fn editing_respects_graphemes_across_scripts_and_emoji(cx: &mut TestAppContext) {
        let (editor, value, _, cx) = setup(cx);
        for (initial, keys, expected, cursor) in [
            ("日本", "left backspace", "本", 0),
            ("ab👩🏽‍💻cd", "left left backspace", "abcd", 2),
            ("e\u{301}x", "left backspace", "x", 0),
            ("αβγ", "home delete end", "βγ", 4),
        ] {
            cx.update(|_, cx| {
                value.update(cx, |value, cx| {
                    value.clear();
                    cx.notify();
                })
            });
            cx.simulate_input(initial);
            cx.simulate_keystrokes(keys);
            cx.read_entity(&value, |value, _| {
                assert_eq!(value, expected, "editing {initial:?} with {keys:?}")
            });
            cx.read_entity(&editor, |editor, _| assert_eq!(editor.cursor, cursor));
        }
    }
}
