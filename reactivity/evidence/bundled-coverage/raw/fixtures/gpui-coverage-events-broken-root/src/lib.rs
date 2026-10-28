//! Ordered coverage events for an immutable font with certified ASCII coverage.
#![forbid(unsafe_code)]

use fearless_simd::{prelude::*, u8x16};
use fearless_simd_macros::simd;

/// Visits controls and non-ASCII characters in source order. Printable ASCII,
/// CR and LF need no coverage lookup for the certified bundled font.
///
/// The input is already valid UTF-8: a continuation byte is never an event,
/// including when its leading byte belongs to the preceding vector block.
pub fn visit<E>(text: &str, visit: impl FnMut(usize, char) -> Result<(), E>) -> Result<(), E> {
    #[cfg(feature = "simd")]
    return fearless_simd::dispatch!(fearless_simd::Level::baseline(), simd => walk(simd, text, visit));
    #[cfg(not(feature = "simd"))]
    walk(fearless_simd::Fallback::new(), text, visit)
}

#[simd]
fn walk<S: Simd, E>(
    simd: S,
    text: &str,
    mut visit: impl FnMut(usize, char) -> Result<(), E>,
) -> Result<(), E> {
    let (blocks, tail) = text.as_bytes().as_chunks::<16>();
    for (index, block) in blocks.iter().enumerate() {
        let bits = exceptions(simd, block);
        if bits != 0 {
            emit(text, index * 16, bits, &mut visit)?;
        }
    }
    if !tail.is_empty() {
        // Padding is certified ASCII, so it can never emit an event beyond
        // the borrowed string. No load crosses the actual input allocation.
        let mut block = [b' '; 16];
        block[..tail.len()].copy_from_slice(tail);
        let bits = exceptions(simd, &block);
        if bits != 0 {
            emit(text, blocks.len() * 16, bits, &mut visit)?;
        }
    }
    Ok(())
}

fn exceptions<S: Simd>(simd: S, block: &[u8; 16]) -> u16 {
    let bytes = u8x16::load_array_ref(simd, block);
    let printable = (bytes - 32).simd_lt(u8x16::splat(simd, 95));
    let newline =
        bytes.simd_eq(u8x16::splat(simd, b'\n')) | bytes.simd_eq(u8x16::splat(simd, b'\r'));
    let continuation = (bytes & 0xc0).simd_eq(u8x16::splat(simd, 0xc0));
    let known = printable | newline | continuation;
    if known.any_false() {
        (!known).to_bitmask() as u16
    } else {
        0
    }
}

fn emit<E>(
    text: &str,
    start: usize,
    mut bits: u16,
    visit: &mut impl FnMut(usize, char) -> Result<(), E>,
) -> Result<(), E> {
    while bits != 0 {
        let index = start + bits.trailing_zeros() as usize;
        bits &= bits - 1;
        // The mask contains only ASCII controls or UTF-8 leading bytes.
        // Safe indexing keeps a classifier error observable in every build.
        let character = text[index..]
            .chars()
            .next()
            .expect("nonempty coverage event");
        visit(index, character)?;
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn known(character: char) -> bool {
        character.is_ascii_graphic() || matches!(character, ' ' | '\r' | '\n')
    }

    fn check_backend<S: Simd>(simd: S, text: &str) {
        let mut reference = text.char_indices().filter(|&(_, c)| !known(c));
        let result = walk(simd, text, |index, character| {
            assert_eq!(reference.next(), Some((index, character)), "{text:?}");
            Ok::<(), ()>(())
        });
        assert_eq!(result, Ok(()));
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
    fn callback_rejection_stops_before_any_later_event() {
        let text = "ASCII é more العربية \0 tail";
        let mut expected = text.char_indices().filter(|&(_, c)| !known(c));
        let first = expected.next().unwrap();
        let second = expected.next().unwrap();
        let mut seen = 0;
        let result = visit(text, |index, character| {
            seen += 1;
            if seen == 1 {
                assert_eq!((index, character), first);
                Ok(())
            } else {
                assert_eq!((index, character), second);
                Err(second)
            }
        });
        assert_eq!(result, Err(second));
        assert_eq!(seen, 2);
    }
}
