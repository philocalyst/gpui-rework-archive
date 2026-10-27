use super::*;
use gpui_canvas::{TextLayout, TextRunSlot};
use gpui_gpu::{RetainedRenderer, TextPacketError};
const CLIP: Rect = Rect::new(0., 0., 128., 96.);
fn scene(
    text: &mut TextSystem,
    labels: [&str; 2],
    positions: [Point; 2],
    map: Affine,
    config: ColorConfig,
    second_color: Color,
) -> (Canvas, [TextRunSlot; 2]) {
    let layouts: [TextLayout; 2] = labels.map(|s| text.shape(s, 12., None).unwrap());
    let seed = text.shape("01234567890123456789", 12., None).unwrap();
    let mut canvas = Canvas::recording(128, 96, config).unwrap();
    let mut stage = canvas.stage();
    stage.clear(Color::WHITE);
    stage
        .fill_rect(CLIP, Affine::IDENTITY, CLIP, Color::rgb(210, 220, 230))
        .unwrap();
    let a = stage
        .draw_text_scaled_tracked(text, &layouts[0], positions[0], map, CLIP, Color::BLACK, 1.)
        .unwrap()
        .unwrap();
    // This opaque draw hides the earlier run, but never the later one.
    stage
        .fill_rect(
            Rect::new(40., 0., 32., 48.),
            Affine::IDENTITY,
            CLIP,
            Color::rgb(50, 110, 180),
        )
        .unwrap();
    let b = stage
        .draw_text_scaled_tracked(text, &layouts[1], positions[1], map, CLIP, second_color, 1.)
        .unwrap()
        .unwrap();
    for y in [52., 66., 80.] {
        stage
            .draw_text(
                text,
                &seed,
                Point { x: 2., y },
                Affine::IDENTITY,
                CLIP,
                Color::BLACK,
            )
            .unwrap();
    }
    stage.commit();
    (canvas, [a, b])
}
fn edits<'a>(
    canvas: &'a Canvas,
    slots: [TextRunSlot; 2],
) -> [(TextRunSlot, gpui_canvas::PreparedGroup<'a>); 2] {
    slots.map(|slot| (slot, canvas.prepared_scene().text_run(slot).unwrap()))
}
#[test]
fn text_packets_repair_new_tiles_in_painter_order_and_match_fresh_images() {
    pollster::block_on(async {
        for (format, config) in [
            (wgpu::TextureFormat::Rgba8UnormSrgb, ColorConfig::default()),
            (
                wgpu::TextureFormat::Rgba16Float,
                ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.).unwrap(),
            ),
        ] {
            for map in [Affine::IDENTITY, Affine::translation(0.25, 0.5)] {
                let mut text = TextSystem::bundled().unwrap();
                let mut gpu = RetainedRenderer::new(renderer(format).await);
                let mut full = renderer(format).await;
                let initial_positions = [Point { x: 2., y: 2. }, Point { x: 6., y: 24. }];
                let (initial, slots) = scene(
                    &mut text,
                    ["0011", "1100"],
                    initial_positions,
                    map,
                    config,
                    Color::BLACK,
                );
                let target = output_texture(&gpu, &initial);
                let view = target.create_view(&Default::default());
                gpu.render(initial.prepared_scene(), &view, None).unwrap();
                assert_eq!(read_texture(&gpu, &target), readback(&mut full, &initial));
                assert!(gpu.text_packet_capacity_bytes() > 0);
                // Cross multiple tile boundaries, including uniform background
                // tiles and the opaque cutoff before the later text run.
                for turn in 0..4 {
                    let positions = if turn % 2 == 0 {
                        [Point { x: 48., y: 2. }, Point { x: 82., y: 24. }]
                    } else {
                        initial_positions
                    };
                    let labels = if turn % 2 == 0 {
                        ["1100", "0011"]
                    } else {
                        ["0011", "1100"]
                    };
                    let (next, next_slots) =
                        scene(&mut text, labels, positions, map, config, Color::BLACK);
                    assert_eq!(slots, next_slots);
                    gpu.patch_texts(&edits(&next, slots), &view, None).unwrap();
                    let stats = gpu.stats();
                    assert!(stats.packet_reused);
                    assert_eq!(stats.mask_upload_bytes, 0);
                    assert_eq!(stats.validated_draws, 8);
                    assert_eq!(
                        read_texture(&gpu, &target),
                        readback(&mut full, &next),
                        "new tile membership / painter order"
                    );
                }
            }
        }
    });
}
#[test]
fn a_late_text_packet_rejection_keeps_the_old_image_and_replay() {
    pollster::block_on(async {
        let mut text = TextSystem::bundled().unwrap();
        let mut gpu = RetainedRenderer::new(renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await);
        let positions = [Point { x: 2., y: 2. }, Point { x: 6., y: 24. }];
        let (initial, slots) = scene(
            &mut text,
            ["0011", "1100"],
            positions,
            Affine::IDENTITY,
            ColorConfig::default(),
            Color::BLACK,
        );
        let target = output_texture(&gpu, &initial);
        let view = target.create_view(&Default::default());
        gpu.render(initial.prepared_scene(), &view, None).unwrap();
        let before = read_texture(&gpu, &target);
        for (labels, color, expected) in [
            (
                ["1100", "ΩΩΩΩ"],
                Color::BLACK,
                TextPacketError::MissingResource,
            ),
            (
                ["1100", "0011"],
                Color::rgb(220, 10, 20),
                TextPacketError::ChangedCommon,
            ),
            (
                ["1100", "001100"],
                Color::BLACK,
                TextPacketError::ChangedShape,
            ),
        ] {
            let (next, _) = scene(
                &mut text,
                labels,
                positions,
                Affine::IDENTITY,
                ColorConfig::default(),
                color,
            );
            assert_eq!(
                gpu.patch_texts(&edits(&next, slots), &view, None)
                    .unwrap_err(),
                expected
            );
            gpu.redraw(&view).unwrap().unwrap();
            assert_eq!(gpu.retained_stats().composited_pixels, 0);
            assert_eq!(
                read_texture(&gpu, &target),
                before,
                "late member must not partly commit"
            );
        }
        let batch = edits(&initial, slots);
        assert_eq!(
            gpu.patch_texts(&[batch[0], batch[0]], &view, None)
                .unwrap_err(),
            TextPacketError::InvalidBatch
        );
        assert_eq!(
            gpu.patch_texts(&[batch[1], batch[0]], &view, None)
                .unwrap_err(),
            TextPacketError::InvalidBatch
        );
        let wrong = Canvas::recording(32, 32, ColorConfig::default()).unwrap();
        let wrong_target = output_texture(&gpu, &wrong);
        assert_eq!(
            gpu.patch_texts(&batch, &wrong_target.create_view(&Default::default()), None)
                .unwrap_err(),
            TextPacketError::InvalidTarget
        );
        gpu.redraw(&view).unwrap().unwrap();
        assert_eq!(read_texture(&gpu, &target), before);
        gpu.set_grouped_records(false);
        gpu.render(initial.prepared_scene(), &view, None).unwrap();
        assert_eq!(
            gpu.patch_texts(&batch, &view, None).unwrap_err(),
            TextPacketError::MissingRun
        );
        gpu.redraw(&view).unwrap().unwrap();
        assert_eq!(read_texture(&gpu, &target), before);
    });
}

fn rect_damage(size: [u32; 2], rect: Rect) -> gpui_canvas::DamageRegion {
    let mut canvas = Canvas::recording(size[0], size[1], ColorConfig::default()).unwrap();
    let mut stage = canvas.stage();
    stage
        .fill_rect(rect, Affine::IDENTITY, rect, Color::BLACK)
        .unwrap();
    stage.commit_with_damage()
}

#[test]
fn text_tile_repairs_preserve_old_support_and_explicit_full_repaint() {
    pollster::block_on(async {
        for (format, config) in [
            (wgpu::TextureFormat::Rgba8UnormSrgb, ColorConfig::default()),
            (
                wgpu::TextureFormat::Rgba16Float,
                ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.).unwrap(),
            ),
        ] {
            for map in [Affine::IDENTITY, Affine::translation(0.25, 0.5)] {
                let mut text = TextSystem::bundled().unwrap();
                let mut gpu = RetainedRenderer::new(renderer(format).await);
                let mut full = renderer(format).await;
                let (initial, slots) = scene(
                    &mut text,
                    ["0011", "1100"],
                    [Point { x: 2., y: 2. }, Point { x: 6., y: 24. }],
                    map,
                    config,
                    Color::BLACK,
                );
                let target = output_texture(&gpu, &initial);
                let view = target.create_view(&Default::default());
                gpu.render(initial.prepared_scene(), &view, None).unwrap();
                let partial = rect_damage([128, 96], Rect::new(0., 0., 128., 51.));
                // Same records produce a copy-only submit even with broad damage.
                gpu.patch_texts(&edits(&initial, slots), &view, Some(partial))
                    .unwrap();
                assert_eq!(gpu.retained_stats().composited_pixels, 0);
                assert_eq!(read_texture(&gpu, &target), readback(&mut full, &initial));
                for (labels, positions) in [
                    (
                        ["0010", "1100"],
                        [Point { x: 2., y: 2. }, Point { x: 6., y: 24. }],
                    ),
                    (
                        ["1100", "0011"],
                        [Point { x: 48., y: 2. }, Point { x: 82., y: 24. }],
                    ),
                    (
                        ["0011", "1100"],
                        [Point { x: 2., y: 2. }, Point { x: 6., y: 24. }],
                    ),
                    (
                        ["0011", "1100"],
                        [
                            Point {
                                x: 15.999999,
                                y: 2.,
                            },
                            Point { x: 6., y: 24. },
                        ],
                    ),
                    (
                        ["0011", "1100"],
                        [
                            Point {
                                x: 16.000002,
                                y: 2.,
                            },
                            Point { x: 6., y: 24. },
                        ],
                    ),
                ] {
                    let (next, next_slots) =
                        scene(&mut text, labels, positions, map, config, Color::BLACK);
                    assert_eq!(slots, next_slots);
                    gpu.patch_texts(&edits(&next, slots), &view, Some(partial))
                        .unwrap();
                    assert!(gpu.retained_stats().composited_pixels < 128 * 51);
                    assert_eq!(
                        read_texture(&gpu, &target),
                        readback(&mut full, &next),
                        "old dirty tile membership must survive movement"
                    );
                    // None remains explicit full repaint, including unchanged words.
                    gpu.patch_texts(&edits(&next, slots), &view, None).unwrap();
                    assert_eq!(gpu.retained_stats().composited_pixels, 128 * 96);
                    assert_eq!(read_texture(&gpu, &target), readback(&mut full, &next));
                    gpu.patch_texts(
                        &edits(&next, slots),
                        &view,
                        Some(gpui_canvas::DamageRegion::default()),
                    )
                    .unwrap();
                    assert_eq!(gpu.retained_stats().composited_pixels, 0);
                }
            }
        }
    });
}

fn paragraphs(
    text: &mut TextSystem,
    labels: [&str; 2],
    size: [u32; 2],
    x: [f32; 2],
) -> (Canvas, [TextRunSlot; 2]) {
    let layouts = labels.map(|label| text.shape(label, 12., None).unwrap());
    let clip = Rect::new(0., 0., size[0] as f32, size[1] as f32);
    let mut canvas = Canvas::recording(size[0], size[1], ColorConfig::default()).unwrap();
    let mut stage = canvas.stage();
    stage.clear(Color::WHITE);
    let slots = std::array::from_fn(|i| {
        stage
            .draw_text_scaled_tracked(
                text,
                &layouts[i],
                Point { x: x[i], y: 2. },
                Affine::IDENTITY,
                clip,
                Color::BLACK,
                1.,
            )
            .unwrap()
            .unwrap()
    });
    stage.commit();
    (canvas, slots)
}

#[test]
fn text_tile_repairs_skip_unchanged_paragraphs_and_bound_scissor_count() {
    pollster::block_on(async {
        let mut text = TextSystem::bundled().unwrap();
        let mut gpu = RetainedRenderer::new(renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await);
        let mut full = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let label = "0000000000000000\n".repeat(12);
        let mut changed = label.clone();
        changed.replace_range(100..101, "1");
        let size = [256, 256];
        let (initial, slots) = paragraphs(&mut text, [&label, "11"], size, [2., 230.]);
        let target = output_texture(&gpu, &initial);
        let view = target.create_view(&Default::default());
        gpu.render(initial.prepared_scene(), &view, None).unwrap();
        let (next, _) = paragraphs(&mut text, [&changed, "11"], size, [2., 230.]);
        let broad = rect_damage(size, Rect::new(0., 0., 256., 256.));
        gpu.patch_texts(&edits(&next, slots), &view, Some(broad))
            .unwrap();
        assert!(gpu.retained_stats().composited_pixels > 0);
        assert!(
            gpu.retained_stats().composited_pixels < 256 * 32,
            "one changed glyph must not repaint the whole paragraph"
        );
        assert_eq!(read_texture(&gpu, &target), readback(&mut full, &next));
        // Two separated columns over more than128 tile rows exceed256 spans.
        let zeros = "0\n".repeat(180);
        let ones = "1\n".repeat(180);
        let size = [128, 4096];
        let (initial, slots) = paragraphs(&mut text, [&zeros, &ones], size, [2., 98.]);
        let target = output_texture(&gpu, &initial);
        let view = target.create_view(&Default::default());
        gpu.render(initial.prepared_scene(), &view, None).unwrap();
        let (next, _) = paragraphs(&mut text, [&ones, &zeros], size, [2., 98.]);
        let broad = rect_damage(size, Rect::new(0., 0., 128., 4096.));
        gpu.patch_texts(&edits(&next, slots), &view, Some(broad))
            .unwrap();
        assert_eq!(
            gpu.retained_stats().composited_pixels,
            128 * 4096,
            "bounded command count must fall back to caller damage"
        );
        assert_eq!(read_texture(&gpu, &target), readback(&mut full, &next));
    });
}

#[test]
fn identical_shader_words_can_have_different_conservative_memberships() {
    pollster::block_on(async {
        let mut text = TextSystem::bundled().unwrap();
        // Inverse translation loses this perturbation when subtracting it from
        //3000 in f64, while outward bounds near32 can still distinguish it. Both are
        // ordinary Canvas scenes; no packet or prepared geometry is forged.
        let map = Affine {
            a: 1.,
            b: 1.,
            c: 0.,
            d: 1.,
            tx: 3000.,
            ty: 0.,
        };
        let mut positions = [
            Point {
                x: -2984.,
                y: 3000.,
            },
            Point {
                x: -2920.,
                y: 2940.,
            },
        ];
        let (provisional, slots) = scene(
            &mut text,
            ["0011", "1100"],
            positions,
            map,
            ColorConfig::default(),
            Color::BLACK,
        );
        let r = provisional
            .prepared_scene()
            .text_run(slots[0])
            .unwrap()
            .placements()
            .next()
            .unwrap()
            .local_rect;
        // Canvas adds a one-pixel outward guard: geometric max31 gives bound32.
        positions[0].y += 31. - (r.x + r.y + r.width + r.height);
        let (initial, slots) = scene(
            &mut text,
            ["0011", "1100"],
            positions,
            map,
            ColorConfig::default(),
            Color::BLACK,
        );
        let (next, next_slots) = scene(
            &mut text,
            ["0011", "1100"],
            positions,
            Affine { ty: 1e-13, ..map },
            ColorConfig::default(),
            Color::BLACK,
        );
        assert_eq!(slots, next_slots);
        let old = edits(&initial, slots);
        let new = edits(&next, slots);
        for ((_, a), (_, b)) in old.iter().zip(&new) {
            assert_eq!(a.inverse.map(f64::to_bits), b.inverse.map(f64::to_bits));
            assert_eq!(a.clip, b.clip);
            assert_eq!(a.color.map(f32::to_bits), b.color.map(f32::to_bits));
            for (a, b) in a.placements().zip(b.placements()) {
                assert_eq!(a.local_rect, b.local_rect);
                assert_eq!(a.source.mask().unwrap().key, b.source.mask().unwrap().key);
            }
        }
        let a = old[0].1.bounds().next().unwrap();
        let b = new[0].1.bounds().next().unwrap();
        assert_eq!(a.y + a.height, 32.);
        assert_eq!(b.y + b.height, 33.);
        let mut gpu = RetainedRenderer::new(renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await);
        let mut full = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let target = output_texture(&gpu, &initial);
        let view = target.create_view(&Default::default());
        gpu.render(initial.prepared_scene(), &view, None).unwrap();
        let before = read_texture(&gpu, &target);
        let damage = rect_damage([128, 96], CLIP);
        gpu.patch_texts(&new, &view, Some(damage)).unwrap();
        assert!(
            gpu.retained_stats().composited_pixels > 0,
            "changed memberships must be considered even with identical shader words"
        );
        let after = read_texture(&gpu, &target);
        assert_eq!(after, before);
        assert_eq!(after, readback(&mut full, &next));
    });
}
