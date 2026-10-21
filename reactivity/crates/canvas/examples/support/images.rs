use gpui_canvas::{
    Affine, AlphaMode, Canvas, Color, ColorConfig, Image, ImageProfile, ImageSampling, Rect,
};

pub fn scene(case: &str) -> Canvas {
    let mut canvas = Canvas::recording(384, 256, ColorConfig::default()).unwrap();
    canvas.clear(Color::WHITE);
    let clip = Rect::new(0., 0., 384., 256.);
    if case == "flat" {
        canvas
            .fill_rect(clip, Affine::IDENTITY, clip, Color::rgb(32, 80, 160))
            .unwrap();
        return canvas;
    }
    assert!(matches!(case, "one" | "shared48" | "unique48"));
    let make_image = |variant: usize| {
        let bytes = (0..128 * 128)
            .flat_map(|i| {
                [
                    (i * 31 + variant * 17) as u8,
                    (i / 128 * 13) as u8,
                    (i % 128 * 29) as u8,
                    [0, 63, 127, 255][i % 4],
                ]
            })
            .collect::<Vec<_>>()
            .into_boxed_slice();
        Image::rgba8(128, 128, ImageProfile::Srgb, AlphaMode::Straight, bytes).unwrap()
    };
    let shared = (case != "unique48").then(|| make_image(0));
    let count = if case == "one" { 1 } else { 48 };
    for i in 0..count {
        let unique;
        let image = if case == "unique48" {
            unique = make_image(i);
            &unique
        } else {
            shared.as_ref().unwrap()
        };
        let rect = if case == "one" {
            Rect::new(0., 0., 256., 256.)
        } else {
            Rect::new((i % 8 * 48) as f32, (i / 8 * 40) as f32, 48., 40.)
        };
        canvas
            .draw_image(image, rect, Affine::IDENTITY, clip, ImageSampling::Linear)
            .unwrap();
    }
    canvas
}
