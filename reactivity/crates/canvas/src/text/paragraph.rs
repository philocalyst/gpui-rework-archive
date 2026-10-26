//! Paragraph boundaries preserve document bytes, including the entire CRLF pair.
//! Adapted from the existing GPUI Parley adapter's tested byte/CRLF laws.
//! U+2028 stays inside its bidi paragraph; it is a mandatory line break only.
use std::ops::Range;

#[derive(Debug, PartialEq, Eq)]
pub(super) struct Paragraph {
    pub content: Range<usize>,
    pub separator: Range<usize>,
}

pub(super) fn ranges(text: &str) -> impl Iterator<Item = Paragraph> + '_ {
    let mut characters = text.char_indices().peekable();
    let mut start = 0;
    let mut finished = false;
    std::iter::from_fn(move || {
        if finished {
            return None;
        }
        while let Some((index, character)) = characters.next() {
            if !matches!(character, '\r' | '\n' | '\u{85}' | '\u{2029}') {
                continue;
            }
            let mut end = index + character.len_utf8();
            if character == '\r' && characters.peek().is_some_and(|&(_, next)| next == '\n') {
                characters.next();
                end += 1;
            }
            let content = start..index;
            start = end;
            return Some(Paragraph {
                content,
                separator: index..end,
            });
        }
        finished = true;
        Some(Paragraph {
            content: start..text.len(),
            separator: text.len()..text.len(),
        })
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn original_utf8_ranges_empty_and_crlf_are_exact() {
        let text = "é\r\n\nא\u{2029}";
        let paragraphs = ranges(text).collect::<Vec<_>>();
        assert_eq!(
            paragraphs,
            [
                Paragraph {
                    content: 0..2,
                    separator: 2..4
                },
                Paragraph {
                    content: 4..4,
                    separator: 4..5
                },
                Paragraph {
                    content: 5..7,
                    separator: 7..10
                },
                Paragraph {
                    content: 10..10,
                    separator: 10..10
                },
            ]
        );
        for p in paragraphs {
            assert!(text.get(p.content).is_some());
            assert!(text.get(p.separator).is_some());
        }
        assert_eq!(ranges("").count(), 1);
        assert_eq!(ranges("\r\n").count(), 2);
        assert_eq!(ranges("\r\r\n").count(), 3);
    }
}
