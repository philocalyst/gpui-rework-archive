//! Exact coverage of the three immutable bundled fonts, shared across planners.
// Each LE24 word holds an inclusive 21-bit Unicode endpoint and three font
// flags. Starts are implicit; the final endpoint covers every valid scalar.
const TABLE: &[u8] = include_bytes!("font-coverage.bin");
const END: u32 = (1 << 21) - 1;

fn word(bytes: &[u8; 3]) -> u32 {
    u32::from_le_bytes([bytes[0], bytes[1], bytes[2], 0])
}

pub(super) fn mask(character: char) -> u8 {
    let (ranges, _) = TABLE.as_chunks::<3>();
    let index = ranges.partition_point(|range| word(range) & END < u32::from(character));
    (word(&ranges[index]) >> 21) as u8
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn certificate_is_a_complete_maximal_partition() {
        let (ranges, tail) = TABLE.as_chunks::<3>();
        assert!(tail.is_empty());
        assert_eq!(word(ranges.last().unwrap()) & END, 0x10ffff);
        for adjacent in ranges.windows(2) {
            let left = word(&adjacent[0]);
            let right = word(&adjacent[1]);
            assert!((left & END) < (right & END));
            assert_ne!(left >> 21, right >> 21);
        }
    }

    #[test]
    fn every_unicode_scalar_matches_original_font_coverage() {
        let faces = [
            &super::super::PRIMARY_BYTES[..],
            &super::super::ARABIC_BYTES[..],
            &super::super::HEBREW_BYTES[..],
        ]
        .map(|bytes| ttf_parser::Face::parse(bytes, 0).unwrap());
        for scalar in 0..=0x10ffff {
            let Some(character) = char::from_u32(scalar) else {
                continue;
            };
            let mut expected = 0;
            for (index, face) in faces.iter().enumerate() {
                if face
                    .glyph_index(character)
                    .is_some_and(|glyph| glyph.0 != 0)
                {
                    expected |= 1 << index;
                }
            }
            assert_eq!(mask(character), expected, "U+{scalar:04X}");
        }
    }
}
