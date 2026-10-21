use gpui_canvas::{
    Affine, Canvas, Color, ColorConfig, Error, OutputProfile, Point, Rect, SdrMapping, TextSystem,
};

fn record(canvas: &mut Canvas, text: &mut TextSystem) {
    canvas.clear(Color::linear_srgb(0.2, 0.3, 0.4, 1.0).unwrap());
    let clip = Rect::new(0.3, 0.7, canvas.width() as f32, canvas.height() as f32);
    canvas
        .fill_rect(
            Rect::new(-3., -2., 47.3, 31.1),
            Affine {
                a: -1.,
                b: 0.2,
                c: 0.3,
                d: 1.,
                tx: 29.7,
                ty: 3.3,
            },
            clip,
            Color::linear_display_p3(1.1, -0.1, 0.4, 0.5).unwrap(),
        )
        .unwrap();
    let layout = text.shape("office café", 15.5, None).unwrap();
    canvas
        .draw_text_scaled(
            text,
            &layout,
            Point { x: 0.7, y: 4.3 },
            Affine::scale(1.25, 1.25),
            clip,
            Color::rgba(220, 30, 70, 180),
            1.25,
        )
        .unwrap();
}
fn packed(rgba: &[u8]) -> Vec<u32> {
    rgba.chunks_exact(4)
        .map(|p| {
            assert_eq!(p[3], 255);
            u32::from(p[0]) << 16 | u32::from(p[1]) << 8 | u32::from(p[2])
        })
        .collect()
}
#[test]
fn external_native_words_match_rgba_and_preserve_lazy_image_coherence() {
    let mut text = TextSystem::bundled().unwrap();
    for mapping in [
        SdrMapping::Clip,
        SdrMapping::ReinhardPerChannel { exposure: 1.3 },
    ] {
        for proofs in [false, true] {
            let mut canvas = Canvas::recording(
                113,
                37,
                ColorConfig {
                    mapping,
                    ..Default::default()
                },
            )
            .unwrap();
            canvas.set_tile_proofs(proofs);
            record(&mut canvas, &mut text);
            let mut words = vec![0xdeadbeef; 113 * 37];
            canvas.render_bgrx(&mut words).unwrap();
            assert_eq!(canvas.output_bytes(), 0);
            assert_eq!(canvas.stats().render_count, 1);
            let first = canvas.try_pixels().unwrap().to_vec();
            assert_eq!(words, packed(&first));
            assert_eq!(canvas.stats().render_count, 2);
            let pointer = canvas.pixels().as_ptr();
            let mut another = vec![0x12345678; words.len()];
            canvas.render_bgrx(&mut another).unwrap();
            assert_eq!(another, words); // A new external buffer is always rendered.
            assert_eq!(canvas.stats().render_count, 3);
            assert_eq!(canvas.pixels(), first);
            assert_eq!(canvas.pixels().as_ptr(), pointer);
            assert_eq!(canvas.stats().render_count, 3); // Internal clean cache stays clean.
            let mut candidate = canvas.stage();
            candidate.clear(Color::rgb(30, 60, 90));
            candidate.commit();
            canvas.render_bgrx(&mut words).unwrap();
            assert!(words.iter().all(|&pixel| pixel == words[0]));
            if mapping == SdrMapping::Clip {
                assert_eq!(words[0], 0x001e3c5a);
            }
            assert_eq!(canvas.stats().render_count, 4);
            assert_eq!(packed(canvas.pixels()), words); // External write didn't clear internal dirty.
            assert_eq!(canvas.stats().render_count, 5);
            assert_eq!(canvas.pixels().as_ptr(), pointer);
        }
    }
}
#[test]
fn invalid_external_targets_leave_buffer_and_scene_untouched() {
    for (config, clear, expected) in [
        (
            ColorConfig::default(),
            Color::TRANSPARENT,
            Error::NonOpaqueOutput,
        ),
        (
            ColorConfig {
                profile: OutputProfile::DisplayP3,
                ..Default::default()
            },
            Color::WHITE,
            Error::UnsupportedOutputProfile,
        ),
        (
            ColorConfig::linear_hdr(OutputProfile::Srgb, 203.).unwrap(),
            Color::WHITE,
            Error::UnsupportedPixelFormat,
        ),
    ] {
        let mut canvas = Canvas::recording(17, 19, config).unwrap();
        canvas.clear(clear);
        let mut target = vec![0xdeadbeef; 17 * 19];
        assert_eq!(canvas.render_bgrx(&mut target), Err(expected));
        assert!(target.iter().all(|&pixel| pixel == 0xdeadbeef));
        assert_eq!(canvas.stats().render_count, 0);
        assert_eq!(canvas.output_bytes(), 0);
        assert_eq!(canvas.prepared_scene().clear, clear.to_linear_srgb());
    }
    let mut canvas = Canvas::recording(17, 19, Default::default()).unwrap();
    canvas.clear(Color::WHITE);
    let mut target = vec![0xdeadbeef; 17 * 19 - 1];
    assert_eq!(
        canvas.render_bgrx(&mut target),
        Err(Error::InvalidDimensions)
    );
    assert!(target.iter().all(|&pixel| pixel == 0xdeadbeef));
    assert_eq!(canvas.stats().render_count, 0);
}
#[cfg(feature = "parallel")]
#[test]
fn external_parallel_word_bands_are_exact_and_allocate_no_internal_image() {
    use gpui_canvas::RenderPool;
    let mut text = TextSystem::bundled().unwrap();
    let mut canvas = Canvas::recording(113, 37, Default::default()).unwrap();
    record(&mut canvas, &mut text);
    let mut expected = vec![0; 113 * 37];
    canvas.render_bgrx(&mut expected).unwrap();
    for workers in [1, 2, 4, 8] {
        let pool = RenderPool::new(workers).unwrap().with_min_work(0);
        let mut output = vec![0xdeadbeef; expected.len()];
        canvas.render_bgrx_with(&mut output, &pool).unwrap();
        assert_eq!(output, expected);
        assert_eq!(canvas.output_bytes(), 0);
        assert!(canvas.stats().parallel);
    }
}
