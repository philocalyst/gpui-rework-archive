use gpui_canvas::{Affine, AlphaMode, Canvas, Color, Image, ImageProfile, ImageSampling, Rect};

#[test]
fn constant_images_match_independent_solid_geometry_for_every_sample() {
    for sampling in [ImageSampling::Nearest, ImageSampling::Linear] {
        for map in [
            Affine::IDENTITY,
            Affine::scale(0.7, 1.3),
            Affine {
                a: -1.,
                b: 0.,
                c: 0.,
                d: 1.,
                tx: 10.125,
                ty: 0.375,
            },
            Affine {
                a: 1.,
                b: -0.3,
                c: 0.2,
                d: 0.8,
                tx: 3.125,
                ty: 2.375,
            },
        ] {
            for alpha in [0, 1, 127, 255] {
                let color = Color::rgba(37, 149, 219, alpha);
                let image = Image::rgba8(
                    1,
                    1,
                    ImageProfile::Srgb,
                    AlphaMode::Straight,
                    vec![37, 149, 219, alpha].into_boxed_slice(),
                )
                .unwrap();
                let mut actual = Canvas::new(16, 16).unwrap();
                let mut reference = Canvas::new(16, 16).unwrap();
                actual.clear(Color::WHITE);
                reference.clear(Color::WHITE);
                let rect = Rect::new(0.125, 0.375, 9.2, 7.3);
                let clip = Rect::new(1.125, 0.375, 12.1, 14.2);
                actual
                    .draw_image(&image, rect, map, clip, sampling)
                    .unwrap();
                reference.fill_rect(rect, map, clip, color).unwrap();
                assert_eq!(
                    actual.pixels(),
                    reference.pixels(),
                    "{sampling:?} {map:?} {alpha}"
                );
            }
        }
    }
}

#[test]
fn nearest_packed_texels_match_independent_color_rectangles() {
    let bytes = [255, 0, 0, 255, 0, 255, 0, 127, 0, 0, 255, 63, 17, 29, 49, 0];
    let image = Image::rgba8(
        2,
        2,
        ImageProfile::Srgb,
        AlphaMode::Straight,
        bytes.to_vec().into_boxed_slice(),
    )
    .unwrap();
    let mut actual = Canvas::new(2, 2).unwrap();
    let mut reference = Canvas::new(2, 2).unwrap();
    actual.clear(Color::WHITE);
    reference.clear(Color::WHITE);
    let clip = Rect::new(0., 0., 2., 2.);
    actual
        .draw_image(&image, clip, Affine::IDENTITY, clip, ImageSampling::Nearest)
        .unwrap();
    for (index, pixel) in bytes.chunks_exact(4).enumerate() {
        reference
            .fill_rect(
                Rect::new((index % 2) as f32, (index / 2) as f32, 1., 1.),
                Affine::IDENTITY,
                clip,
                Color::rgba(pixel[0], pixel[1], pixel[2], pixel[3]),
            )
            .unwrap();
    }
    assert_eq!(actual.pixels(), reference.pixels());
}

#[test]
fn distinct_payload_budget_is_checked_before_publishing_a_new_resource_or_draw() {
    let full = Image::linear_srgb(
        2048,
        2048,
        AlphaMode::Premultiplied,
        vec![[0.25, 0.5, 0.75, 1.]; 2048 * 2048].into_boxed_slice(),
    )
    .unwrap();
    assert_eq!(full.pixel_bytes(), gpui_canvas::MAX_IMAGE_SCENE_BYTES);
    let extra = Image::rgba8(
        1,
        1,
        ImageProfile::Srgb,
        AlphaMode::Straight,
        vec![255; 4].into_boxed_slice(),
    )
    .unwrap();
    let mut canvas = Canvas::new(1, 1).unwrap();
    let rect = Rect::new(0., 0., 1., 1.);
    for sampling in [ImageSampling::Nearest, ImageSampling::Linear] {
        canvas
            .draw_image(&full, rect, Affine::IDENTITY, rect, sampling)
            .unwrap();
    }
    let old = canvas.pixels().to_vec();
    assert_eq!(
        canvas.draw_image(&extra, rect, Affine::IDENTITY, rect, ImageSampling::Linear),
        Err(gpui_canvas::Error::ResourceLimit)
    );
    assert_eq!(canvas.prepared_scene().images().count(), 1);
    assert_eq!(canvas.prepared_scene().draws().len(), 2);
    assert_eq!(canvas.pixels(), old);
}

#[cfg(feature = "parallel")]
#[test]
fn immutable_images_and_correlated_samples_are_identical_across_scoped_workers() {
    use gpui_canvas::RenderPool;
    let image = Image::rgba8(
        7,
        5,
        ImageProfile::DisplayP3,
        AlphaMode::Straight,
        (0..35)
            .flat_map(|i| {
                [
                    (i * 31) as u8,
                    (i * 57) as u8,
                    (i * 13) as u8,
                    [0, 63, 127, 255][i % 4],
                ]
            })
            .collect::<Vec<_>>()
            .into_boxed_slice(),
    )
    .unwrap();
    let mut canvas = Canvas::new(65, 49).unwrap();
    canvas.clear(Color::WHITE);
    let clip = Rect::new(1.125, 0.375, 60.3, 46.1);
    for (sampling, map) in [
        (
            ImageSampling::Linear,
            Affine {
                a: 0.9,
                b: 0.13,
                c: -0.17,
                d: 0.75,
                tx: 5.125,
                ty: 0.125,
            },
        ),
        (
            ImageSampling::Nearest,
            Affine {
                a: -0.8,
                d: 0.9,
                tx: 59.125,
                ..Affine::IDENTITY
            },
        ),
    ] {
        canvas
            .draw_image(
                &image,
                Rect::new(0.125, 0.375, 58.5, 46.25),
                map,
                clip,
                sampling,
            )
            .unwrap();
    }
    let mut expected = vec![0; 65 * 49];
    canvas.render_bgrx(&mut expected).unwrap();
    for workers in [1, 2, 4] {
        let pool = RenderPool::new(workers).unwrap().with_min_work(0);
        let mut actual = vec![0; expected.len()];
        canvas.render_bgrx_with(&mut actual, &pool).unwrap();
        assert_eq!(actual, expected, "workers{workers}");
    }
}

#[test]
fn image_identity_filter_and_removal_damage_repair_preserved_pixels() {
    let a = Image::rgba8(
        2,
        1,
        ImageProfile::Srgb,
        AlphaMode::Straight,
        vec![255, 0, 0, 255, 0, 0, 255, 63].into_boxed_slice(),
    )
    .unwrap();
    let b = Image::rgba8(
        2,
        1,
        ImageProfile::Srgb,
        AlphaMode::Straight,
        vec![0, 255, 0, 127, 255, 0, 255, 255].into_boxed_slice(),
    )
    .unwrap();
    for proofs in [false, true] {
        let mut canvas = Canvas::recording(33, 17, Default::default()).unwrap();
        canvas.set_tile_proofs(proofs);
        let mut preserved = vec![0xffffff; 33 * 17];
        for draw in [
            Some((&a, ImageSampling::Linear)),
            Some((&a, ImageSampling::Linear)),
            Some((&a, ImageSampling::Nearest)),
            Some((&b, ImageSampling::Nearest)),
            None,
        ] {
            let mut candidate = canvas.stage();
            candidate.clear(Color::WHITE);
            if let Some((image, sampling)) = draw {
                candidate
                    .draw_image(
                        image,
                        Rect::new(1.125, 0.375, 23.25, 13.5),
                        Affine {
                            a: -0.9,
                            d: 0.9,
                            tx: 27.125,
                            ty: 0.125,
                            ..Affine::IDENTITY
                        },
                        Rect::new(0., 0., 33., 17.),
                        sampling,
                    )
                    .unwrap();
            }
            let damage = candidate.commit_with_damage();
            let mut expected = vec![0; preserved.len()];
            canvas.render_bgrx(&mut expected).unwrap();
            for (i, (&old, &new)) in preserved.iter().zip(&expected).enumerate() {
                if old != new {
                    let [left, top, right, bottom] =
                        damage.bounds().expect("changed image pixel has support");
                    let (x, y) = ((i % 33) as u32, (i / 33) as u32);
                    assert!(x >= left && x < right && y >= top && y < bottom);
                }
            }
            canvas.render_bgrx_region(&mut preserved, damage).unwrap();
            assert_eq!(preserved, expected, "proofs{proofs}");
            assert_eq!(canvas.output_bytes(), 0);
        }
    }
}
