//! Independent default-instance boundary: retain the full variable source here.
use gpui_canvas::{
    Affine, Canvas, Color, ColorConfig, FontFace, OutputProfile, Point, Rect, TextSystem,
};
use skrifa::{
    MetadataProvider as _,
    instance::{LocationRef, Size},
    outline::{DrawSettings, OutlinePen},
};
use swash::scale::{Render, ScaleContext, Source};

const VARIABLE: &[u8] = include_bytes!("../assets/NotoSans.ttf");
const STATIC: &[u8] = include_bytes!("../assets/NotoSans-default.ttf");
const SIZES: [f32; 6] = [1.0, 7.25, 16.0, 20.5, 63.75, 256.0];

#[derive(Default, Debug, PartialEq)]
struct Commands(Vec<(u8, Vec<u32>)>);
impl Commands {
    fn push(&mut self, tag: u8, values: &[f32]) {
        self.0
            .push((tag, values.iter().map(|value| value.to_bits()).collect()));
    }
}
impl OutlinePen for Commands {
    fn move_to(&mut self, x: f32, y: f32) {
        self.push(0, &[x, y]);
    }
    fn line_to(&mut self, x: f32, y: f32) {
        self.push(1, &[x, y]);
    }
    fn quad_to(&mut self, cx: f32, cy: f32, x: f32, y: f32) {
        self.push(2, &[cx, cy, x, y]);
    }
    fn curve_to(&mut self, ax: f32, ay: f32, bx: f32, by: f32, x: f32, y: f32) {
        self.push(3, &[ax, ay, bx, by, x, y]);
    }
    fn close(&mut self) {
        self.push(4, &[]);
    }
}

#[test]
fn exact_cmap_and_all_glyph_metrics_and_outline_commands() {
    let old = ttf_parser::Face::parse(VARIABLE, 0).unwrap();
    let new = ttf_parser::Face::parse(STATIC, 0).unwrap();
    assert!(old.is_variable());
    assert!(!new.is_variable());
    assert_eq!(old.number_of_glyphs(), 4515);
    assert_eq!(old.number_of_glyphs(), new.number_of_glyphs());
    for scalar in 0..=0x10ffff {
        if let Some(character) = char::from_u32(scalar) {
            assert_eq!(
                old.glyph_index(character),
                new.glyph_index(character),
                "U+{scalar:04X}"
            );
        }
    }
    for glyph in 0..old.number_of_glyphs() {
        let id = ttf_parser::GlyphId(glyph);
        assert_eq!(old.glyph_name(id), new.glyph_name(id), "name gid={glyph}");
        assert_eq!(
            old.glyph_bounding_box(id),
            new.glyph_bounding_box(id),
            "bounds gid={glyph}"
        );
    }
    let fonts = [VARIABLE, STATIC].map(|bytes| skrifa::FontRef::from_index(bytes, 0).unwrap());
    for size in SIZES {
        let font_metrics = fonts
            .each_ref()
            .map(|font| font.metrics(Size::new(size), LocationRef::default()));
        assert_eq!(font_metrics[0], font_metrics[1], "font metrics size={size}");
        let metrics = fonts
            .each_ref()
            .map(|font| font.glyph_metrics(Size::new(size), LocationRef::default()));
        let outlines = fonts.each_ref().map(|font| font.outline_glyphs());
        for glyph in 0..4515 {
            let id = skrifa::GlyphId::new(glyph);
            assert_eq!(
                metrics[0].advance_width(id).map(f32::to_bits),
                metrics[1].advance_width(id).map(f32::to_bits),
                "advance gid={glyph} size={size}"
            );
            assert_eq!(
                metrics[0].left_side_bearing(id).map(f32::to_bits),
                metrics[1].left_side_bearing(id).map(f32::to_bits),
                "lsb gid={glyph} size={size}"
            );
            let commands = outlines.each_ref().map(|outlines| {
                let mut pen = Commands::default();
                outlines
                    .get(id)
                    .unwrap()
                    .draw(
                        DrawSettings::unhinted(Size::new(size), LocationRef::default()),
                        &mut pen,
                    )
                    .unwrap();
                pen
            });
            assert_eq!(commands[0], commands[1], "commands gid={glyph} size={size}");
        }
    }
}

#[test]
fn all_glyph_swash_masks_have_exact_placement_and_coverage() {
    let fonts = [VARIABLE, STATIC].map(|bytes| swash::FontRef::from_index(bytes, 0).unwrap());
    let mut contexts = [ScaleContext::new(), ScaleContext::new()];
    for size in SIZES {
        let [old, new] = &mut contexts;
        let mut scalers = [
            old.builder(fonts[0]).size(size).hint(false).build(),
            new.builder(fonts[1]).size(size).hint(false).build(),
        ];
        for glyph in 0..4515 {
            let images = scalers.each_mut().map(|scaler| {
                Render::new(&[Source::Outline])
                    .format(swash::zeno::Format::Alpha)
                    .render(scaler, glyph)
            });
            let normalize = |image: Option<swash::scale::image::Image>| {
                image.map(|image| {
                    let p = image.placement;
                    (p.left, p.top, p.width, p.height, image.content, image.data)
                })
            };
            let [a, b] = images.map(normalize);
            assert_eq!(a, b, "mask gid={glyph} size={size}");
        }
    }
}

fn corpus() -> Vec<String> {
    vec![
        "office AVATAR ffi fi café Ελληνικά Привет नमस्ते".into(),
        "abc אבג 123 xyz العَرَبِيَّة نهاية".into(),
        "a\u{301}b\u{200d}c\u{fe0f}\u{00ad} office\r\nend".into(),
        "\u{2067}אבג 12\u{2069} x".into(),
        format!("a{}", "\u{301}".repeat(150)),
        "office café אבג and العربية ".repeat(12),
    ]
}

#[test]
fn independent_rustybuzz_shaping_is_exact() {
    let mut old = rustybuzz::Face::from_slice(VARIABLE, 0).unwrap();
    old.set_variations(&[
        rustybuzz::Variation {
            tag: rustybuzz::ttf_parser::Tag::from_bytes(b"wght"),
            value: 400.0,
        },
        rustybuzz::Variation {
            tag: rustybuzz::ttf_parser::Tag::from_bytes(b"wdth"),
            value: 100.0,
        },
    ]);
    let new = rustybuzz::Face::from_slice(STATIC, 0).unwrap();
    for source in corpus() {
        let output = [&old, &new].map(|font| {
            let mut buffer = rustybuzz::UnicodeBuffer::new();
            buffer.push_str(&source);
            buffer.guess_segment_properties();
            rustybuzz::shape(font, &[], buffer)
        });
        let infos = output.each_ref().map(|output| {
            output
                .glyph_infos()
                .iter()
                .map(|glyph| (glyph.glyph_id, glyph.cluster, glyph.unsafe_to_break()))
                .collect::<Vec<_>>()
        });
        assert_eq!(infos[0], infos[1], "infos {source:?}");
        let positions = output.each_ref().map(|output| {
            output
                .glyph_positions()
                .iter()
                .map(|glyph| {
                    (
                        glyph.x_advance,
                        glyph.y_advance,
                        glyph.x_offset,
                        glyph.y_offset,
                    )
                })
                .collect::<Vec<_>>()
        });
        assert_eq!(positions[0], positions[1], "positions {source:?}");
    }
}

#[test]
fn actual_cpu_sdr_and_hdr_pixels_are_exact() {
    let faces = [
        FontFace::new(VARIABLE).unwrap(),
        FontFace::new(STATIC).unwrap(),
    ];
    for source in [
        "office AVATAR ffi fi café Ελληνικά Привет नमस्ते".to_string(),
        "a\u{301}b\u{200d}c\u{fe0f}\u{00ad} office\r\nend".to_string(),
        format!("a{}", "\u{301}".repeat(150)),
    ] {
        for size in [7.25, 16.0, 20.5, 63.75] {
            for width in [None, Some(90.0), Some(210.0)] {
                for config in [
                    ColorConfig::default(),
                    ColorConfig::linear_hdr(OutputProfile::Srgb, 203.0).unwrap(),
                    ColorConfig::linear_hdr(OutputProfile::DisplayP3, 203.0).unwrap(),
                ] {
                    let pixels = faces.each_ref().map(|font| {
                        let mut system = TextSystem::from_font(font.clone());
                        let layout = system.shape(&source, size, width).unwrap();
                        let mut canvas = Canvas::with_color_config(360, 240, config).unwrap();
                        canvas.clear(Color::WHITE);
                        canvas
                            .draw_text(
                                &mut system,
                                &layout,
                                Point { x: 10.25, y: 10.5 },
                                Affine::IDENTITY,
                                Rect::new(0.0, 0.0, 360.0, 240.0),
                                Color::BLACK,
                            )
                            .unwrap();
                        canvas.pixels().to_vec()
                    });
                    assert_eq!(
                        pixels[0], pixels[1],
                        "pixels {source:?} size={size} width={width:?} config={config:?}"
                    );
                }
            }
        }
    }
}
