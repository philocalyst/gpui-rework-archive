use gpui_canvas::{Affine, Canvas, Color, ColorConfig, OutputProfile, PaintEdit, Rect};

const RECT: Rect = Rect::new(0.0, 0.0, 16.0, 16.0);

fn scene(proofs: bool, red: f32) -> Canvas {
    let mut canvas = Canvas::recording(
        16,
        16,
        ColorConfig::linear_hdr(OutputProfile::Srgb, 203.0).unwrap(),
    )
    .unwrap();
    canvas.set_tile_proofs(proofs);
    canvas.clear(Color::linear_srgb(0.0, 0.0, 0.0, 1.0).unwrap());
    for red in [-1.0, red] {
        canvas
            .fill_rect(
                RECT,
                Affine::IDENTITY,
                RECT,
                Color::linear_srgb(red, 0.0, 0.0, 1.0).unwrap(),
            )
            .unwrap();
    }
    canvas
}

fn red(canvas: &mut Canvas) -> u16 {
    u16::from_le_bytes(canvas.pixels()[..2].try_into().unwrap())
}

#[test]
fn fresh_negative_zero_opaque_cut_matches_scalar_hdr() {
    let mut scalar = scene(false, -0.0);
    let mut optimized = scene(true, -0.0);
    assert_eq!(red(&mut scalar), 0x8000);
    assert_eq!(red(&mut optimized), red(&mut scalar));
    assert_eq!(optimized.pixels(), scalar.pixels());
}

#[test]
fn same_alpha_exceptional_color_retires_a_cached_opaque_cut() {
    let mut canvas = scene(true, 1.0);
    canvas.pixels();
    assert_eq!(canvas.stats().skipped_command_tiles, 1);
    let bins = canvas.stats().bin_bytes;
    let edits = [PaintEdit::new(
        canvas.paint_index(1).unwrap(),
        Color::linear_srgb(-0.0, 0.0, 0.0, 1.0).unwrap(),
    )];
    canvas.prepare_paint(&edits).unwrap().commit();
    let mut scalar = scene(false, -0.0);
    assert_eq!(red(&mut canvas), red(&mut scalar));
    assert_eq!(canvas.pixels(), scalar.pixels());
    assert!(canvas.stats().bins_reused);
    assert_eq!(canvas.stats().bin_bytes, bins);
}
