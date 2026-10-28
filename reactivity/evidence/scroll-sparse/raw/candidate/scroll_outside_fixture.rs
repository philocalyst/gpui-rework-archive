//! Shared public-interface scenes for independent CPU/GPU final-image oracles.
use gpui_canvas::{
    Affine, AlphaMode, Canvas, CanvasScene, ClipShape, Color, Extend, Gradient,
    GradientGeometry, GradientStop, Image, ImageProfile, ImageSampling, Interpolation,
    Point, Rect, TextSystem,
};

pub const SIZE: [u32; 2] = [192, 160];
pub const VIEW: [u32; 4] = [40, 48, 152, 128];
pub const CASES: usize = 12;
pub fn offset(tick: usize) -> i32 {
    (tick % 3) as i32 * 8
}
pub fn stage<'a>(
    canvas: &'a mut Canvas,
    text: &mut TextSystem,
    case: usize,
    tick: usize,
) -> CanvasScene<'a> {
    let mut s = canvas.stage();
    let clip = Rect::new(0., 0., 192., 160.);
    let changed = tick % 2 != 0;
    s.clear(if case == 8 && changed { Color::WHITE } else { Color::TRANSPARENT });
    s.fill_rect(clip, Affine::IDENTITY, clip, Color::rgba(20, 40, 60, 60)).unwrap();
    // Inserting/removing commands before the list must not lose either tail.
    if case == 1 && changed {
        s.fill_rect(Rect::new(2., 2., 7., 5.), Affine::IDENTITY, clip, Color::WHITE).unwrap();
    }
    let row_clip = Rect::new(40., 48., 112., 80.);
    for row in 0..16 {
        let y = 48. + row as f32 * 16. - offset(tick) as f32;
        let map = Affine::translation(40., y);
        s.fill_rect(Rect::new(0., 0., 112., 16.), map, row_clip,
            Color::rgba((row * 31) as u8, 90, 150, 180)).unwrap();
        let layout = text.shape(&format!("row {row}"), 9., None).unwrap();
        s.draw_text(text, &layout, Point::default(), Affine::translation(42., y + 1.),
            row_clip, Color::BLACK).unwrap();
    }
    // Exact unchanged images, gradients, clipping and glyphs outside the copy
    // remain legal; none of these materials can certify a translated overlap.
    let image = Image::rgba8(1, 1, ImageProfile::Srgb, AlphaMode::Straight,
        vec![if case == 11 && changed { 220 } else { 60 }, 120, 180, 170].into_boxed_slice()).unwrap();
    s.draw_image(&image, Rect::new(165., 60., 12., 13.), Affine::IDENTITY,
        clip, ImageSampling::Linear).unwrap();
    let gradient = Gradient::new(
        GradientGeometry::Linear { start: Point::default(), end: Point { x: 1., y: 0. } },
        &[GradientStop::new(0., Color::BLACK), GradientStop::new(1.,
            if case == 11 && changed { Color::WHITE } else { Color::rgb(40, 120, 90) })],
        Extend::Pad, Interpolation::LinearSrgb).unwrap();
    s.fill_gradient(&gradient, Rect::new(165., 85., 12., 15.), 0., Affine::IDENTITY, clip).unwrap();
    let shape = s.create_clip(None, ClipShape::RoundedRect {
        rect: Rect::new(4., 70., 22., 22.), radius: if case == 10 && changed { 8. } else { 2. },
    }, Affine::IDENTITY).unwrap();
    s.fill_rect(Rect::new(0., 65., 30., 35.), Affine::IDENTITY, shape,
        Color::rgba(180, 90, 30, 180)).unwrap();
    let label = if case == 2 { ["a long header", "x", "", "another header"][tick % 4] }
        else if case == 3 && changed { "changed glyphs" } else { "fixed header" };
    let layout = text.shape(label, 11., None).unwrap();
    s.draw_text(text, &layout, Point { x: 30., y: 5. }, Affine::IDENTITY, clip, Color::BLACK).unwrap();
    match case {
        0 | 3 => {
            s.fill_rect(Rect::new(3., 22., 7., 5.), Affine::IDENTITY, clip,
                if changed { Color::WHITE } else { Color::BLACK }).unwrap();
        }
        4 => {
            for i in 0..80 {
                s.fill_rect(Rect::new(2. + (i % 16) as f32 * 11., 20. + (i / 16) as f32 * 5., 2., 2.),
                    Affine::IDENTITY, clip, if changed { Color::WHITE } else { Color::BLACK }).unwrap();
            }
        }
        5 => {
            for rect in [Rect::new(4., 110., 10., 8.), Rect::new(165., 110., 10., 8.),
                Rect::new(45., 140., 10., 8.)] {
                s.fill_rect(rect, Affine::IDENTITY, clip,
                    if changed { Color::WHITE } else { Color::BLACK }).unwrap();
            }
        }
        6 if changed => {
            // Cross the viewport's lower boundary, but remain below the copied
            // destination on an upward scroll. Reverse motion must fall back.
            s.fill_rect(Rect::new(38., 122., 118., 14.), Affine::IDENTITY, clip, Color::BLACK).unwrap();
        }
        7 => {
            for layer in 0..2 {
                let color = if (layer == 0) ^ changed { Color::rgba(220, 30, 80, 170) }
                    else { Color::rgba(20, 130, 220, 140) };
                s.fill_rect(Rect::new(60., 135., 30., 12.), Affine::IDENTITY, clip, color).unwrap();
            }
        }
        9 => {
            s.fill_rect(Rect::new(50., 70., 20., 20.), Affine::IDENTITY, clip,
                if changed { Color::WHITE } else { Color::BLACK }).unwrap();
        }
        _ => {}
    }
    s
}
