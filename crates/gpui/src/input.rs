use crate::{
    App, Bounds, ClipboardItem, Context, Entity, InputHandler, Pixels, TextInputConfiguration,
    UTF16Selection, Window,
};
use std::ops::Range;

/// Converts a UTF-8 byte offset into a UTF-16 code-unit offset.
///
/// Offsets past the end of `text` clamp to its UTF-16 length. An offset inside a UTF-8
/// character snaps to the end of that character. The returned offset is suitable for the
/// platform text-input APIs, which use UTF-16 ranges.
///
/// ```
/// # use gpui::utf8_to_utf16_offset;
/// assert_eq!(utf8_to_utf16_offset("a🦀", 1), 1);
/// assert_eq!(utf8_to_utf16_offset("a🦀", 2), 3);
/// ```
pub fn utf8_to_utf16_offset(text: &str, utf8_offset: usize) -> usize {
    text.char_indices()
        .take_while(|(offset, _)| *offset < utf8_offset)
        .map(|(_, character)| character.len_utf16())
        .sum()
}

/// Converts a UTF-16 code-unit offset into a UTF-8 byte offset.
///
/// Offsets past the end of `text` clamp to its UTF-8 length. An offset inside a surrogate pair
/// snaps to the end of the corresponding character. This is the inverse coordinate conversion
/// for text-input ranges; it does not validate that the input offset is on a grapheme boundary.
///
/// ```
/// # use gpui::utf16_to_utf8_offset;
/// assert_eq!(utf16_to_utf8_offset("a🦀", 3), 5);
/// assert_eq!(utf16_to_utf8_offset("a🦀", usize::MAX), 5);
/// ```
pub fn utf16_to_utf8_offset(text: &str, utf16_offset: usize) -> usize {
    let mut consumed_utf16 = 0;
    for (utf8_offset, character) in text.char_indices() {
        if consumed_utf16 >= utf16_offset {
            return utf8_offset;
        }
        consumed_utf16 += character.len_utf16();
    }
    text.len()
}

/// Lets an entity participate in the platform's text-editing protocol.
///
/// Implement this for an editor or text field. The entity owns its buffer,
/// selection, and provisional [IME](https://en.wikipedia.org/wiki/Input_method)
/// composition; GPUI forwards requests to read or change that state. Ordinary
/// key listeners cannot replace this protocol: one composition can replace the
/// same candidate text several times before committing it.
///
/// # Attach the handler during paint
///
/// Keep a [`FocusHandle`](crate::FocusHandle) on the editor and attach it to the rendered subtree
/// with [`InteractiveElement::track_focus`](crate::InteractiveElement::track_focus). During the text element's paint,
/// install an adapter using that element's logical window-coordinate bounds:
///
/// ```
/// use gpui::{App, Bounds, ElementInputHandler, Entity, EntityInputHandler,
///            FocusHandle, Pixels, Window};
///
/// fn install_editor_input<T: EntityInputHandler>(
///     editor: Entity<T>,
///     focus: &FocusHandle,
///     bounds: Bounds<Pixels>,
///     window: &mut Window,
///     cx: &mut App,
/// ) {
///     window.handle_input(focus, ElementInputHandler::new(bounds, editor), cx);
/// }
/// ```
///
/// Installing the handler does not request focus. GPUI selects the handler for
/// the focused node while finishing the frame. Reinstall it when the element
/// paints again; a cached subtree carries its recorded handler forward.
///
/// # Keep one buffer and one selection
///
/// All ranges use UTF-16 code units, as in [`InputHandler`]. Rust strings and
/// text layouts use UTF-8 bytes. Convert at this boundary with
/// [`utf16_to_utf8_offset`] and [`utf8_to_utf16_offset`]; the adapter does not
/// convert for you. Track the active selection end separately from its sorted
/// range so [`selected_text_range`](Self::selected_text_range) can preserve
/// selection direction.
///
/// For a replacement without an explicit range, target the existing marked
/// range, or the selection when no composition is active. A marked replacement
/// leaves the inserted text provisional; a committed replacement clears that
/// mark. [`unmark_text`](Self::unmark_text) also clears the mark, keeping the
/// text. Notify after editing or changing visible selection state.
///
/// Geometry must describe the buffer being queried. Reuse the layout that
/// painted it, and return `None` when an edit has made that layout stale.
/// Callbacks can arrive during painting; use the supplied [`Window`] and
/// [`Context`] for each call. The [input chapter](crate::_documentation::input)
/// follows a composition through its replacements, and [`InputHandler`]
/// documents the platform contract for each callback.
pub trait EntityInputHandler: 'static + Sized {
    /// Return the text overlapping a UTF-16 document range.
    ///
    /// Set `adjusted_range` to the actual range represented by the returned string when the
    /// requested range cannot be returned exactly. Return `None` when this handler cannot answer
    /// the query. See [`InputHandler::text_for_range`] for the platform callback contract.
    fn text_for_range(
        &mut self,
        range: Range<usize>,
        adjusted_range: &mut Option<Range<usize>>,
        window: &mut Window,
        cx: &mut Context<Self>,
    ) -> Option<String>;

    /// Return the current selection, including which end is the active head.
    ///
    /// Return `None` when no selection can be reported. The `ignore_disabled_input` flag comes
    /// from the platform query and lets the view decide whether to report selection while text
    /// input is disabled. See [`InputHandler::selected_text_range`].
    fn selected_text_range(
        &mut self,
        ignore_disabled_input: bool,
        window: &mut Window,
        cx: &mut Context<Self>,
    ) -> Option<UTF16Selection>;

    /// Return the UTF-16 range currently owned by an IME composition, if any.
    ///
    /// `None` means there is no marked/composing range. See [`InputHandler::marked_text_range`].
    fn marked_text_range(
        &self,
        window: &mut Window,
        cx: &mut Context<Self>,
    ) -> Option<Range<usize>>;

    /// End the current marked/composing range without replacing it.
    ///
    /// See [`InputHandler::unmark_text`].
    fn unmark_text(&mut self, window: &mut Window, cx: &mut Context<Self>);

    /// Handle a platform-initiated paste.
    ///
    /// The default implementation commits the item's plain text through
    /// [`Self::replace_text_in_range`] with no explicit range. That targets
    /// marked text during composition, or the selection otherwise. Override
    /// this for richer clipboard content. See [`InputHandler::paste`].
    fn paste(&mut self, item: ClipboardItem, window: &mut Window, cx: &mut Context<Self>) {
        if let Some(text) = item.text() {
            self.replace_text_in_range(None, &text, window, cx);
        }
    }

    /// Commit text by replacing a UTF-16 document range.
    ///
    /// `None` targets the marked range during composition, or the current
    /// selection otherwise. Clear composition and update the selection as
    /// described in [`InputHandler::replace_text_in_range`].
    fn replace_text_in_range(
        &mut self,
        range: Option<Range<usize>>,
        text: &str,
        window: &mut Window,
        cx: &mut Context<Self>,
    );

    /// Replace a UTF-16 document range and mark the inserted text as active IME composition.
    ///
    /// `range: None` targets the previous marked range, or the selection when
    /// starting composition. `new_selected_range`, when supplied, is relative
    /// to the newly inserted text. When it is `None`, choose the view's default
    /// selection placement. See
    /// [`InputHandler::replace_and_mark_text_in_range`].
    fn replace_and_mark_text_in_range(
        &mut self,
        range: Option<Range<usize>>,
        new_text: &str,
        new_selected_range: Option<Range<usize>>,
        window: &mut Window,
        cx: &mut Context<Self>,
    );

    /// Return logical window-coordinate bounds for a UTF-16 document range.
    ///
    /// The supplied `element_bounds` locates this handler's painted element. An empty range asks
    /// for caret bounds; return `None` when the text layout cannot provide geometry. See
    /// [`InputHandler::bounds_for_range`].
    fn bounds_for_range(
        &mut self,
        range_utf16: Range<usize>,
        element_bounds: Bounds<Pixels>,
        window: &mut Window,
        cx: &mut Context<Self>,
    ) -> Option<Bounds<Pixels>>;

    /// Map a logical window-coordinate point to a UTF-16 document offset.
    ///
    /// Return `None` when no text position can be determined for the point. See
    /// [`InputHandler::character_index_for_point`].
    fn character_index_for_point(
        &mut self,
        point: crate::Point<Pixels>,
        window: &mut Window,
        cx: &mut Context<Self>,
    ) -> Option<usize>;

    /// Apply a selection change requested by platform text UI.
    ///
    /// The default implementation does nothing. Override it when system selection handles or
    /// commands such as Select All should update the view's model. See
    /// [`InputHandler::set_selected_text_range`].
    fn set_selected_text_range(
        &mut self,
        _range_utf16: Range<usize>,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) {
    }

    /// Return the document length in UTF-16 code units when it is available.
    ///
    /// `None` leaves the platform without a known length. See [`InputHandler::text_length_utf16`].
    fn text_length_utf16(
        &mut self,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<usize> {
        None
    }

    /// Report whether this view currently accepts inserted text.
    ///
    /// The default is `true`. Return `false` for states such as read-only content; this does not
    /// remove key, pointer, or accessibility handlers. See [`InputHandler::accepts_text_input`].
    fn accepts_text_input(&self, _window: &mut Window, _cx: &mut Context<Self>) -> bool {
        true
    }

    /// Return platform preferences for keyboard and text assistance.
    ///
    /// The default is [`TextInputConfiguration::default`]. GPUI re-queries the configuration while
    /// drawing and forwards changes to the platform, so keep this method inexpensive. See
    /// [`InputHandler::text_input_configuration`].
    fn text_input_configuration(
        &mut self,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> TextInputConfiguration {
        TextInputConfiguration::default()
    }

    /// Bound the UTF-16 region that platform text input may read or edit around the selection.
    ///
    /// Return `None` for no bound. When set, include the current selection when possible. See
    /// [`InputHandler::text_input_editable_range`].
    fn text_input_editable_range(
        &mut self,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<Range<usize>> {
        None
    }
}

/// Forwards platform text callbacks to an entity implementing [`EntityInputHandler`].
///
/// Install it with [`Window::handle_input`] during the element's paint. It keeps
/// a strong entity handle and the bounds from that frame; each callback updates
/// the entity through the supplied app context. Its IME preference follows
/// [`EntityInputHandler::accepts_text_input`].
pub struct ElementInputHandler<V> {
    view: Entity<V>,
    element_bounds: Bounds<Pixels>,
}

impl<V: 'static> ElementInputHandler<V> {
    /// Create the adapter that forwards platform text callbacks to `view`.
    ///
    /// Call this during the element's paint with that element's window-coordinate bounds and the
    /// entity implementing [`EntityInputHandler`], then pass it to [`Window::handle_input`]. The
    /// adapter owns an entity handle, not a borrow of the view, so the view is updated only while
    /// servicing each platform callback.
    pub fn new(element_bounds: Bounds<Pixels>, view: Entity<V>) -> Self {
        ElementInputHandler {
            view,
            element_bounds,
        }
    }
}

impl<V: EntityInputHandler> InputHandler for ElementInputHandler<V> {
    fn selected_text_range(
        &mut self,
        ignore_disabled_input: bool,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<UTF16Selection> {
        self.view.update(cx, |view, cx| {
            view.selected_text_range(ignore_disabled_input, window, cx)
        })
    }

    fn marked_text_range(&mut self, window: &mut Window, cx: &mut App) -> Option<Range<usize>> {
        self.view
            .update(cx, |view, cx| view.marked_text_range(window, cx))
    }

    fn text_for_range(
        &mut self,
        range_utf16: Range<usize>,
        adjusted_range: &mut Option<Range<usize>>,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<String> {
        self.view.update(cx, |view, cx| {
            view.text_for_range(range_utf16, adjusted_range, window, cx)
        })
    }

    fn replace_text_in_range(
        &mut self,
        replacement_range: Option<Range<usize>>,
        text: &str,
        window: &mut Window,
        cx: &mut App,
    ) {
        self.view.update(cx, |view, cx| {
            view.replace_text_in_range(replacement_range, text, window, cx)
        });
    }

    fn replace_and_mark_text_in_range(
        &mut self,
        range_utf16: Option<Range<usize>>,
        new_text: &str,
        new_selected_range: Option<Range<usize>>,
        window: &mut Window,
        cx: &mut App,
    ) {
        self.view.update(cx, |view, cx| {
            view.replace_and_mark_text_in_range(
                range_utf16,
                new_text,
                new_selected_range,
                window,
                cx,
            )
        });
    }

    fn unmark_text(&mut self, window: &mut Window, cx: &mut App) {
        self.view
            .update(cx, |view, cx| view.unmark_text(window, cx));
    }

    fn paste(&mut self, item: ClipboardItem, window: &mut Window, cx: &mut App) {
        self.view
            .update(cx, |view, cx| view.paste(item, window, cx));
    }

    fn bounds_for_range(
        &mut self,
        range_utf16: Range<usize>,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<Bounds<Pixels>> {
        self.view.update(cx, |view, cx| {
            view.bounds_for_range(range_utf16, self.element_bounds, window, cx)
        })
    }

    fn character_index_for_point(
        &mut self,
        point: crate::Point<Pixels>,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<usize> {
        self.view.update(cx, |view, cx| {
            view.character_index_for_point(point, window, cx)
        })
    }

    fn set_selected_text_range(
        &mut self,
        range_utf16: Range<usize>,
        window: &mut Window,
        cx: &mut App,
    ) {
        self.view.update(cx, |view, cx| {
            view.set_selected_text_range(range_utf16, window, cx)
        })
    }

    fn element_bounds(&mut self, _window: &mut Window, _cx: &mut App) -> Option<Bounds<Pixels>> {
        Some(self.element_bounds)
    }

    fn text_length_utf16(&mut self, window: &mut Window, cx: &mut App) -> Option<usize> {
        self.view
            .update(cx, |view, cx| view.text_length_utf16(window, cx))
    }

    fn accepts_text_input(&mut self, window: &mut Window, cx: &mut App) -> bool {
        self.view
            .update(cx, |view, cx| view.accepts_text_input(window, cx))
    }

    fn prefers_ime_for_printable_keys(&mut self, window: &mut Window, cx: &mut App) -> bool {
        self.view
            .update(cx, |view, cx| view.accepts_text_input(window, cx))
    }

    fn text_input_configuration(
        &mut self,
        window: &mut Window,
        cx: &mut App,
    ) -> TextInputConfiguration {
        self.view
            .update(cx, |view, cx| view.text_input_configuration(window, cx))
    }

    fn text_input_editable_range(
        &mut self,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<Range<usize>> {
        self.view
            .update(cx, |view, cx| view.text_input_editable_range(window, cx))
    }
}

#[cfg(test)]
mod configuration_tests {
    use super::*;
    use crate::{
        AnyWindowHandle, AppContext as _, FocusHandle, InteractiveElement as _, IntoElement,
        ParentElement as _, Render, Styled as _, TestAppContext, TextInputAction,
        TextInputStateChange, canvas, div,
    };

    #[gpui::test]
    fn text_input_configuration_and_focus_state_are_forwarded_on_change(cx: &mut TestAppContext) {
        let custom = TextInputConfiguration {
            autocorrect: true,
            input_action: TextInputAction::Send,
            ..Default::default()
        };
        let window = cx.add_window({
            let custom = custom.clone();
            move |_, cx| ConfigurationTestView {
                focus_handle: cx.focus_handle(),
                configuration: custom,
            }
        });
        let view = window.root(cx).unwrap();
        let test_window = cx.test_window(window.into());
        let window = AnyWindowHandle::from(window);
        let draw = |cx: &mut TestAppContext| {
            cx.update_window(window, |_, window, cx| window.draw(cx).clear(cx))
                .unwrap();
        };

        // Nothing is focused, so the platform learns the default configuration.
        draw(cx);
        assert_eq!(
            test_window.text_input_configurations(),
            vec![TextInputConfiguration::default()]
        );
        assert!(test_window.text_input_state_changes().is_empty());

        // Focusing the view routes its configuration to the platform.
        cx.update_window(window, |_, window, cx| {
            let focus_handle = view.read(cx).focus_handle.clone();
            window.focus(&focus_handle, cx);
        })
        .unwrap();
        draw(cx);
        assert_eq!(
            test_window.text_input_configurations(),
            vec![TextInputConfiguration::default(), custom.clone()]
        );
        assert_eq!(
            test_window.text_input_state_changes(),
            vec![TextInputStateChange::FocusGained]
        );

        // Redrawing without a change forwards nothing.
        draw(cx);
        assert_eq!(test_window.text_input_configurations().len(), 2);
        assert_eq!(test_window.text_input_state_changes().len(), 1);

        // Changing the configuration forwards the new value.
        let updated = TextInputConfiguration {
            suggestions: true,
            ..custom
        };
        view.update(cx, {
            let updated = updated.clone();
            |view, cx| {
                view.configuration = updated;
                cx.notify();
            }
        });
        draw(cx);
        assert_eq!(
            test_window.text_input_configurations().last(),
            Some(&updated)
        );
        assert_eq!(test_window.text_input_configurations().len(), 3);
        assert_eq!(test_window.text_input_state_changes().len(), 1);

        // Losing focus reverts the platform to the default configuration.
        cx.update_window(window, |_, window, cx| window.blur(cx))
            .unwrap();
        draw(cx);
        assert_eq!(
            test_window.text_input_configurations().last(),
            Some(&TextInputConfiguration::default())
        );
        assert_eq!(test_window.text_input_configurations().len(), 4);
        assert_eq!(
            test_window.text_input_state_changes(),
            vec![
                TextInputStateChange::FocusGained,
                TextInputStateChange::FocusLost
            ]
        );
    }

    struct ConfigurationTestView {
        focus_handle: FocusHandle,
        configuration: TextInputConfiguration,
    }

    impl Render for ConfigurationTestView {
        fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
            let view = cx.entity();
            let focus_handle = self.focus_handle.clone();
            div().size_full().track_focus(&self.focus_handle).child(
                canvas(
                    |_, _, _| {},
                    move |bounds, _, window, cx| {
                        window.handle_input(
                            &focus_handle,
                            ElementInputHandler::new(bounds, view),
                            cx,
                        );
                    },
                )
                .size_full(),
            )
        }
    }

    impl EntityInputHandler for ConfigurationTestView {
        fn text_for_range(
            &mut self,
            _range: std::ops::Range<usize>,
            _adjusted_range: &mut Option<std::ops::Range<usize>>,
            _window: &mut Window,
            _cx: &mut Context<Self>,
        ) -> Option<String> {
            None
        }

        fn selected_text_range(
            &mut self,
            _ignore_disabled_input: bool,
            _window: &mut Window,
            _cx: &mut Context<Self>,
        ) -> Option<UTF16Selection> {
            None
        }

        fn marked_text_range(
            &self,
            _window: &mut Window,
            _cx: &mut Context<Self>,
        ) -> Option<std::ops::Range<usize>> {
            None
        }

        fn unmark_text(&mut self, _window: &mut Window, _cx: &mut Context<Self>) {}

        fn replace_text_in_range(
            &mut self,
            _range: Option<std::ops::Range<usize>>,
            _text: &str,
            _window: &mut Window,
            _cx: &mut Context<Self>,
        ) {
        }

        fn replace_and_mark_text_in_range(
            &mut self,
            _range: Option<std::ops::Range<usize>>,
            _new_text: &str,
            _new_selected_range: Option<std::ops::Range<usize>>,
            _window: &mut Window,
            _cx: &mut Context<Self>,
        ) {
        }

        fn bounds_for_range(
            &mut self,
            _range_utf16: std::ops::Range<usize>,
            _element_bounds: Bounds<Pixels>,
            _window: &mut Window,
            _cx: &mut Context<Self>,
        ) -> Option<Bounds<Pixels>> {
            None
        }

        fn character_index_for_point(
            &mut self,
            _point: crate::Point<Pixels>,
            _window: &mut Window,
            _cx: &mut Context<Self>,
        ) -> Option<usize> {
            None
        }

        fn text_input_configuration(
            &mut self,
            _window: &mut Window,
            _cx: &mut Context<Self>,
        ) -> TextInputConfiguration {
            self.configuration.clone()
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn text_offsets_convert_across_unicode_encodings() {
        let cases = [
            ("", vec![(0, 0)]),
            ("plain", vec![(0, 0), (1, 1), (5, 5)]),
            (
                "A😀日本e\u{301}",
                vec![(0, 0), (1, 1), (5, 3), (8, 4), (11, 5), (12, 6), (14, 7)],
            ),
        ];

        for (text, boundaries) in cases {
            for (utf8, utf16) in boundaries {
                assert_eq!(utf8_to_utf16_offset(text, utf8), utf16, "{text:?}");
                assert_eq!(utf16_to_utf8_offset(text, utf16), utf8, "{text:?}");
            }

            assert_eq!(
                utf8_to_utf16_offset(text, usize::MAX),
                text.encode_utf16().count()
            );
            assert_eq!(utf16_to_utf8_offset(text, usize::MAX), text.len());
        }

        let text = "A😀B";
        assert_eq!(utf16_to_utf8_offset(text, 2), 5);
        assert_eq!(utf8_to_utf16_offset(text, 2), 3);
    }
}
