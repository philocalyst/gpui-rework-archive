//! Unchanged public producer output adapter for frozen cursor/shared-lower roots.
use super::*;

pub(super) fn packed_words(layout: &TextLayout) -> Vec<u64> {
    let mut words = vec![u64::from(layout.width.to_bits()), u64::from(layout.height.to_bits()),
        u64::from(layout.baseline.to_bits()), u64::from(layout.font_size().to_bits()), layout.text_len() as u64];
    words.push(layout.fonts.fallbacks.iter().enumerate().fold(0u64, |mask, (i, font)| mask | (u64::from(font.is_some()) << i)));
    words.push(layout.glyphs.len() as u64);
    for glyph in layout.glyphs.iter() {
        words.extend([u64::from(glyph.meta), u64::from(glyph.x.to_bits()), u64::from(glyph.baseline.to_bits())]);
    }
    words.push(u64::from(layout.mapping.is_some()));
    if let Some(details) = &layout.mapping {
        words.extend([u64::from(details.len), u64::from(details.font_size.to_bits()), details.lines.len() as u64]);
        for line in &details.lines {
            words.extend([u64::from(line.start), u64::from(line.end), u64::from(line.top.to_bits()),
                u64::from(line.height.to_bits()), u64::from(line.baseline.to_bits()), u64::from(line.width.to_bits())]);
        }
        words.push(details.runs.len() as u64);
        for run in &details.runs {
            words.extend([u64::from(run.start), u64::from(run.end), u64::from(run.glyph_start), u64::from(run.glyph_end),
                u64::from(run.line), u64::from(run.font.0), u64::from(run.direction == TextDirection::RightToLeft)]);
        }
        words.push(u64::from(details.carets.is_some()));
        if let Some(carets) = &details.carets {
            words.push(carets.len() as u64);
            for stop in carets { words.extend([u64::from(stop.byte), u64::from(stop.x.to_bits()), u64::from(stop.affinities)]); }
        }
    }
    words
}
#[test]
fn ordinary_lowering_frozen_control_output() {
    let _registry = super::super::BUNDLED_TEST_LOCK.lock().unwrap();
    let face = FontFace::bundled().unwrap();
    let corpus = [String::new(), "a".into(), "office affinity AVATAR trailing  ".into(),
        "abc אבג 123 xyz العربية office".into(), "a\u{200d}b\u{2066}אבג\u{2069}".into(),
        "line\u{2028}next end".into(), format!("a{} end", "\u{301}".repeat(512)),
        "office café\r\n\r\nאבג العربية\nlast\r\n".into()];
    let mut records = 0;
    for (case, content) in corpus.into_iter().enumerate() {
        for size in [14.1, 23.75] {
            for width in [None, Some(1.), Some(40.), Some(60.), Some(120.)] {
                for interactive in [false, true] {
                    let mut shaper = face.shaper();
                    let layout = if interactive { shaper.shape_interactive(&content, size, width) }
                        else { shaper.shape(&content, size, width) }.unwrap();
                    let measured = shaper.measure(&content, size, width).unwrap();
                    assert_eq!([measured.width, measured.height, measured.baseline].map(f32::to_bits),
                        [layout.width, layout.height, layout.baseline].map(f32::to_bits));
                    eprintln!("SHARED-LOWERING-ORACLE case={case} size={} width={:?} interactive={interactive} words={:?}",
                        size.to_bits(), width.map(f32::to_bits), packed_words(&layout));
                    records += 1;
                }
            }
        }
    }
    assert_eq!(records, 160);
}
