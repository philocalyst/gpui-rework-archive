use gpui::{
    FallbackFontClass, Font, LineLayout, MissingGlyph, MissingGlyphSink, PlatformTextSystem,
    TextLayoutOptions, TextLayoutRequest, TextRun, font, px,
};
use std::{
    borrow::Cow,
    ops::Range,
    sync::{Arc, Mutex},
};
use wasm_bindgen::prelude::*;

fn main() {}

#[derive(Default)]
struct Reports(Mutex<Vec<MissingGlyph>>);

impl MissingGlyphSink for Reports {
    fn report(&self, missing: Vec<MissingGlyph>) {
        self.0.lock().expect("report lock").extend(missing);
    }
}

fn layout(text_system: &dyn PlatformTextSystem, text: &str, font: &Font) -> LineLayout {
    let runs = [TextRun {
        len: text.len(),
        font: font.clone(),
        ..Default::default()
    }];
    text_system.layout_text(TextLayoutRequest {
        text,
        font_size: px(24.),
        runs: &runs,
        options: TextLayoutOptions::default(),
    })
}

#[wasm_bindgen]
pub fn test_missing_glyph_notifications() -> Result<(), JsValue> {
    let platform = gpui_platform::current_platform(false);
    let text_system = platform.text_system();
    text_system
        .add_fonts(vec![Cow::Borrowed(include_bytes!(
            "../../../../assets/fonts/lilex/Lilex-Regular.ttf"
        ))])
        .map_err(|error| JsValue::from_str(&error.to_string()))?;
    let font = font("Lilex");
    let font_id = text_system
        .font_id(&font)
        .map_err(|error| JsValue::from_str(&error.to_string()))?;
    let reports = Arc::new(Reports::default());
    text_system.set_missing_glyph_sink(Some(reports.clone()));
    let text = "A界😀👨‍👩‍👧‍👦か\u{3099}";
    let shaped = layout(text_system.as_ref(), text, &font);
    assert!(
        shaped
            .paint_fragments
            .iter()
            .flat_map(|fragment| fragment.glyphs.iter())
            .any(|glyph| glyph.is_emoji)
    );
    let missing = reports.0.lock().expect("report lock").clone();
    let missing_graphemes = missing.iter().map(|report| report.grapheme()).collect::<Vec<_>>();
    web_sys::console::log_1(&JsValue::from_str(&format!(
        "actual missing graphemes before assertion: {missing_graphemes:?}"
    )));
    assert_eq!(
        missing
            .iter()
            .map(|report| report.grapheme())
            .collect::<Vec<_>>(),
        ["界", "か\u{3099}"],
    );
    assert!(
        missing
            .iter()
            .all(|report| report.font_class() == FallbackFontClass::Monospace)
    );

    for graphemes in [
        vec!["🕸", "🕸", "🕸"],
        vec!["🕸", "🕸\u{fe0f}", "🕸\u{fe0e}", "🕸"],
    ] {
        reports.0.lock().expect("report lock").clear();
        let text = graphemes.concat();
        let shaped = layout(text_system.as_ref(), &text, &font);
        let glyphs = shaped
            .paint_fragments
            .iter()
            .flat_map(|fragment| {
                fragment
                    .glyphs
                    .iter()
                    .map(move |glyph| (fragment.font_id, glyph))
            })
            .collect::<Vec<_>>();
        assert_eq!(glyphs.len(), graphemes.len());
        assert!(
            glyphs
                .iter()
                .all(|(resolved_font, _)| *resolved_font != font_id)
        );
        assert!(
            glyphs
                .iter()
                .zip(&graphemes)
                .all(|((_, glyph), grapheme)| { glyph.is_emoji == grapheme.ends_with('\u{fe0f}') }),
        );
        let mut source_index = 0;
        let expected_ranges = graphemes
            .iter()
            .map(|grapheme| {
                let start = source_index;
                source_index += grapheme.len();
                start..source_index
            })
            .collect::<Vec<Range<usize>>>();
        let source_ranges = shaped
            .paint_fragments
            .iter()
            .flat_map(|fragment| {
                fragment
                    .glyph_source_ranges
                    .as_deref()
                    .unwrap_or_default()
                    .iter()
                    .cloned()
            })
            .collect::<Vec<_>>();
        assert_eq!(source_ranges, expected_ranges);
        assert_eq!(source_index, text.len());
        assert!(
            reports.0.lock().expect("report lock").is_empty(),
            "Every spider-web glyph must resolve, not just the first cached raster"
        );
    }

    reports.0.lock().expect("report lock").clear();
    let bundled = "Hello ©";
    let bundled_layout = layout(text_system.as_ref(), bundled, &font);
    assert!(
        bundled_layout
            .paint_fragments
            .iter()
            .all(|fragment| fragment.font_id == font_id)
    );
    assert!(reports.0.lock().expect("report lock").is_empty());

    reports.0.lock().expect("report lock").clear();
    text_system.set_missing_glyph_sink(None);
    let _ = layout(text_system.as_ref(), text, &font);
    assert!(reports.0.lock().expect("report lock").is_empty());
    Ok(())
}
