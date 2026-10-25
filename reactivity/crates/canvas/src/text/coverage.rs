//! Ordered coverage events for an immutable font with certified ASCII coverage.
use fearless_simd::{prelude::*, u8x16};
use fearless_simd_macros::simd;

/// Custom fonts validate every character. The bundled font validates only
/// controls and non-ASCII scalars; its printable ASCII coverage is certified.
pub(super) fn characters(text: &str, certified: bool) -> impl Iterator<Item = char> + '_ {
    enum Characters<'a> {
        All(std::str::Chars<'a>),
        Events(Events<'a>),
    }
    impl Iterator for Characters<'_> {
        type Item = char;
        fn next(&mut self) -> Option<char> {
            match self {
                Self::All(characters) => characters.next(),
                Self::Events(events) => events.next().map(|(_, character)| character),
            }
        }
    }
    if certified {
        Characters::Events(Events::new(text))
    } else {
        Characters::All(text.chars())
    }
}

struct Events<'a> {
    text: &'a str,
    next_block: usize,
    bits: u16,
}
impl<'a> Events<'a> {
    fn new(text: &'a str) -> Self {
        Self {
            text,
            next_block: 0,
            bits: 0,
        }
    }
}
impl Iterator for Events<'_> {
    type Item = (usize, char);
    fn next(&mut self) -> Option<Self::Item> {
        #[cfg(feature = "simd")]
        return fearless_simd::dispatch!(fearless_simd::Level::baseline(), simd => advance(simd, self));
        #[cfg(not(feature = "simd"))]
        advance(fearless_simd::Fallback::new(), self)
    }
}

#[simd]
fn advance<S: Simd>(simd: S, events: &mut Events<'_>) -> Option<(usize, char)> {
    loop {
        if events.bits != 0 {
            let index = events.next_block - 16 + events.bits.trailing_zeros() as usize;
            events.bits &= events.bits - 1;
            // A set bit is an ASCII control or UTF-8 leading byte. Safe
            // indexing makes a classifier error observable in every build.
            let character = events.text[index..].chars().next().expect("coverage event");
            return Some((index, character));
        }
        let tail = events.text.as_bytes().get(events.next_block..)?;
        if tail.is_empty() {
            return None;
        }
        events.bits = if let Some((block, _)) = tail.split_first_chunk::<16>() {
            exceptions(simd, block)
        } else {
            // Padding never emits an event. No load crosses the input.
            let mut block = [b' '; 16];
            block[..tail.len()].copy_from_slice(tail);
            exceptions(simd, &block)
        };
        events.next_block += 16;
    }
}

fn exceptions<S: Simd>(simd: S, block: &[u8; 16]) -> u16 {
    let bytes = u8x16::load_array_ref(simd, block);
    let printable = (bytes - 32).simd_lt(u8x16::splat(simd, 95));
    let newline =
        bytes.simd_eq(u8x16::splat(simd, b'\n')) | bytes.simd_eq(u8x16::splat(simd, b'\r'));
    let continuation = (bytes & 0xc0).simd_eq(u8x16::splat(simd, 0x80));
    let known = printable | newline | continuation;
    if known.any_false() {
        (!known).to_bitmask() as u16
    } else {
        0
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn known(character: char) -> bool {
        character.is_ascii_graphic() || matches!(character, ' ' | '\r' | '\n')
    }

    fn check_backend<S: Simd>(simd: S, text: &str) {
        let mut reference = text.char_indices().filter(|&(_, c)| !known(c));
        let mut events = Events::new(text);
        while let Some(event) = advance(simd, &mut events) {
            assert_eq!(reference.next(), Some(event), "{text:?}");
        }
        assert_eq!(reference.next(), None, "{text:?}");
    }

    fn check(text: &str) {
        check_backend(fearless_simd::Fallback::new(), text);
        fearless_simd::dispatch!(fearless_simd::Level::baseline(), simd => check_backend(simd, text));
        fearless_simd::dispatch!(fearless_simd::Level::new(), simd => check_backend(simd, text));
    }

    #[test]
    fn all_ascii_values_at_every_short_and_vector_boundary() {
        for length in 0..=65 {
            let mut bytes = vec![b' '; length];
            check(std::str::from_utf8(&bytes).unwrap());
            for index in 0..length {
                for byte in 0..=127 {
                    bytes[index] = byte;
                    check(std::str::from_utf8(&bytes).unwrap());
                }
                bytes[index] = b' ';
            }
        }
    }

    #[test]
    fn every_unicode_scalar_crossing_a_vector_boundary() {
        let mut text = "ASCII prefix 15".to_owned();
        assert_eq!(text.len(), 15);
        for value in 0..=0x10ffff {
            let Some(character) = char::from_u32(value) else {
                continue;
            };
            text.truncate(15);
            text.push(character);
            text.push_str(" ASCII tail\r\n");
            check(&text);
        }
    }

    #[test]
    fn mixed_scripts_continuations_and_controls_keep_source_order() {
        for padding in 0..=33 {
            let mut text = " ".repeat(padding);
            text.push_str("a\0é\tאבג\u{85}العربية\u{2028}हिन्दी\u{2029}👩‍💻\x7f𐀀\u{10ffff}\r\nz");
            check(&text);
        }
    }

    #[test]
    fn immutable_primary_font_covers_the_skipped_ascii_domain() {
        let face = ttf_parser::Face::parse(&super::super::PRIMARY_BYTES, 0).unwrap();
        for byte in b' '..=b'~' {
            assert!(
                face.glyph_index(char::from(byte))
                    .is_some_and(|glyph| glyph.0 != 0)
            );
        }
    }

    #[test]
    fn callback_rejection_stops_before_any_later_event() {
        let text = "ASCII é more العربية \0 tail";
        let mut expected = text.char_indices().filter(|&(_, c)| !known(c));
        let first = expected.next().unwrap();
        let second = expected.next().unwrap();
        let mut seen = 0;
        let result = characters(text, true).try_for_each(|character| {
            seen += 1;
            if seen == 1 {
                assert_eq!(character, first.1);
                Ok(())
            } else {
                assert_eq!(character, second.1);
                Err(second)
            }
        });
        assert_eq!(result, Err(second));
        assert_eq!(seen, 2);
    }
}
