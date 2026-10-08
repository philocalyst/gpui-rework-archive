//! Unicode navigation and the geometry used by the platform input protocol.
use super::*;
use proptest::prelude::*;

proptest! {
    #[test]
    fn navigation_preserves_text_and_is_reversible(characters in prop::collection::vec(any::<char>(), 0..32)) {
        let text: String = characters.into_iter().collect();
        let mut cursor = 0;
        let mut pieces = Vec::new();
        while cursor < text.len() {
            let next = next_boundary(&text, cursor);
            prop_assert!(next > cursor && next <= text.len());
            prop_assert!(text.is_char_boundary(next));
            prop_assert_eq!(previous_boundary(&text, next), cursor);
            pieces.push(&text[cursor..next]);
            cursor = next;
        }
        prop_assert_eq!(pieces.concat(), text.as_str());
        prop_assert_eq!(previous_boundary(&text, 0), 0);
        prop_assert_eq!(next_boundary(&text, text.len()), text.len());
    }
}

#[test]
fn navigation_keeps_combining_marks_and_joined_emoji_together() {
    for grapheme in ["e\u{301}", "👩🏽‍💻", "🇨🇦"] {
        let text = format!("a{grapheme}b");
        assert_eq!(next_boundary(&text, 1), 1 + grapheme.len());
        assert_eq!(previous_boundary(&text, 1 + grapheme.len()), 1);
    }
}

#[test]
fn utf16_queries_clamp_surrogates_and_order_reversed_ranges() {
    assert_eq!(utf16_range("a🦀z", 2..usize::MAX), 5..6);
    assert_eq!(utf16_range("a🦀z", 3..1), 1..5);
    assert_eq!(utf16_range("a🦀z", usize::MAX..0), 0..6);
}

#[test]
fn painted_geometry_uses_document_offsets_and_rejects_stale_text() {
    use gpui::PlatformTextSystem as _;
    use gpui_parley::{ParleyTextSystem, SystemFonts};
    use std::borrow::Cow;

    // The simulated text system has one row even for text containing newlines.
    // This assertion needs real shaping with a font owned by the fixture.
    let backend = Arc::new(
        ParleyTextSystem::new(SystemFonts::Skip).with_fallback_families(["IBM Plex Sans"]),
    );
    backend
        .add_fonts(vec![Cow::Borrowed(include_bytes!(concat!(
            env!("CARGO_MANIFEST_DIR"),
            "/../../assets/fonts/ibm-plex-sans/IBMPlexSans-Regular.ttf",
        )))])
        .unwrap();
    let mut app = gpui::TestApp::with_text_system(backend);
    let mut window = app.open_window(|window, cx| Editor::new("a🦀\n日本", window, cx));
    window.draw();
    window.update(|editor, window, cx| {
        let origin = editor.painted.as_ref().unwrap().origin;
        let line_height = editor.painted.as_ref().unwrap().line_height;
        let bounds = Bounds::new(origin, size(px(400.), px(120.)));
        // Offset four is the beginning of the second row in UTF-16, not UTF-8.
        let caret = editor.bounds_for_range(4..4, bounds, window, cx).unwrap();
        assert_eq!(caret.origin.y, origin.y + line_height);
        assert_eq!(
            editor.character_index_for_point(
                caret.origin + point(px(0.1), line_height / 2.),
                window,
                cx,
            ),
            Some(4)
        );
        let selected = editor.bounds_for_range(4..6, bounds, window, cx).unwrap();
        assert!(selected.size.width > px(0.));
        assert_eq!(selected.origin.y, caret.origin.y);
        editor.select_at(
            caret.origin + point(px(0.1), line_height / 2.),
            false,
            window,
            cx,
        );
        assert_eq!(editor.selection(), 6..6);
        assert!(editor.focus_handle.is_focused(window));
        editor.select_at(origin + point(px(0.1), line_height / 2.), true, window, cx);
        assert_eq!(editor.selection(), 0..6);
        assert!(
            editor
                .selected_text_range(false, window, cx)
                .unwrap()
                .reversed
        );
        editor.replace_text_in_range(Some(0..6), "changed", window, cx);
        assert!(editor.bounds_for_range(0..0, bounds, window, cx).is_none());
        assert!(
            editor
                .character_index_for_point(origin, window, cx)
                .is_none()
        );
    });
}
