//! Unicode navigation contracts independent of painting and platform input.
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
