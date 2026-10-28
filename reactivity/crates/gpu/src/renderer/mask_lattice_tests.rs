use super::*;
use gpui_canvas::{Affine, Canvas, Color, Point, TextSystem};

fn scene() -> Canvas {
    let mut canvas = Canvas::new(96, 72).unwrap();
    canvas.clear(Color::WHITE);
    let mut text = TextSystem::bundled().unwrap();
    let layout = text.shape("HgW", 18., None).unwrap();
    canvas
        .draw_text(
            &mut text,
            &layout,
            Point::default(),
            Affine::IDENTITY,
            Rect::new(0., 0., 96., 72.),
            Color::BLACK,
        )
        .unwrap();
    canvas
}

#[test]
fn every_admitted_mask_address_matches_scalar_membership_and_cell() {
    let canvas = scene();
    let original = canvas
        .prepared_scene()
        .draws()
        .find(|d| d.source.mask().is_some())
        .unwrap();
    let mut admitted = 0;
    for axis in 0..2 {
        for phase in -256..=256 {
            for extent_scale in [0.5, 1., 2.] {
                let mut draw = original;
                draw.local_rect.x = phase as f32 / 256.;
                draw.local_rect.y = phase as f32 / 256.;
                if axis == 0 {
                    draw.local_rect.width *= extent_scale;
                } else {
                    draw.local_rect.height *= extent_scale;
                }
                for translation in [0., 0.125, -0.125, 131_072., -131_072.] {
                    draw.inverse = [1., 0., 0., 1., translation, translation];
                    let Some(lowered) = lowered_mask_rect(&draw) else {
                        continue;
                    };
                    admitted += 1;
                    let mask = draw.source.mask().unwrap();
                    let (origin, extent, mapped, texels) = if axis == 0 {
                        (
                            draw.local_rect.x,
                            draw.local_rect.width,
                            lowered.x,
                            mask.width,
                        )
                    } else {
                        (
                            draw.local_rect.y,
                            draw.local_rect.height,
                            lowered.y,
                            mask.height,
                        )
                    };
                    for i in 0..256 {
                        let point = i as f64 / 4. + 0.125;
                        let local = point + translation - f64::from(origin);
                        let expected = (local >= 0. && local < f64::from(extent))
                            .then(|| (local * (texels as f64 / f64::from(extent))).floor() as i64);
                        let device = point as f32 - mapped;
                        let actual =
                            (device >= 0. && device < extent).then(|| device.floor() as i64);
                        assert_eq!(
                            actual, expected,
                            "mask cell axis={axis} phase={phase} scale={extent_scale} translation={translation} point={point}"
                        );
                    }
                }
            }
        }
    }
    assert_eq!(admitted, 513 * 2 * 5);
}

#[test]
fn certificate_rejects_nonunit_and_unbounded_or_unresolved_maps() {
    let canvas = scene();
    let original = canvas
        .prepared_scene()
        .draws()
        .find(|d| d.source.mask().is_some())
        .unwrap();
    assert!(lowered_mask_rect(&original).is_some());
    for inverse in [
        [1.25, 0., 0., 1., 0., 0.],
        [1., 0.01, 0., 1., 0., 0.],
        [-1., 0., 0., 1., 0., 0.],
        [1., 0., 0., 1., 131_072.0001, 0.],
        [1., 0., 0., 1., 2f64.powi(-33), 0.],
        [1., 0., 0., 1., f64::NAN, 0.],
    ] {
        assert!(
            lowered_mask_rect(&PreparedDraw {
                inverse,
                ..original
            })
            .is_none()
        );
    }
    for value in [
        131_072_f32.next_up(),
        -131_072_f32.next_up(),
        f32::from_bits(1),
        f32::INFINITY,
    ] {
        let mut draw = original;
        draw.local_rect.x = value;
        assert!(lowered_mask_rect(&draw).is_none());
    }
    for value in [
        0.125_f32.next_down(),
        0.125,
        0.125_f32.next_up(),
        131_072.,
        -131_072.,
    ] {
        let mut draw = original;
        draw.local_rect.x = value;
        let lowered = lowered_mask_rect(&draw).unwrap();
        for i in 0..64 {
            let point = i as f64 * 0.25 + 0.125;
            assert_eq!(
                (point - f64::from(value)).floor(),
                f64::from((point as f32 - lowered.x).floor())
            );
        }
    }
}

#[cfg(feature = "gpu-tests")]
#[test]
fn placement_tags_survive_inline_compact_and_banked_packets() {
    use super::super::{LOWERED_MASK, Renderer, compact_group, slots};
    pollster::block_on(async {
        let (_, adapter) = crate::test_adapter::request().await;
        let mut gpu = Renderer::request(&adapter, crate::wgpu::TextureFormat::Rgba8UnormSrgb)
            .await
            .unwrap();
        for banked in [false, true] {
            let mut canvas = scene();
            let mut text = TextSystem::bundled().unwrap();
            let run = text.shape("abc H", 18., None).unwrap();
            let clip = Rect::new(0.125, 0.375, 90.125_f32.next_up(), 70.);
            let paint = Color::rgba(31, 91, 197, 127);
            let slot = banked.then(|| {
                canvas
                    .paint_slot(gpui_canvas::PaintColor::new(paint))
                    .unwrap()
            });
            for density in [1., 2.] {
                if let Some(slot) = slot {
                    canvas
                        .draw_text_scaled_slot(
                            &mut text,
                            &run,
                            Point {
                                x: 3.125,
                                y: 24.375,
                            },
                            Affine::IDENTITY,
                            clip,
                            slot,
                            density,
                        )
                        .unwrap();
                } else {
                    canvas
                        .draw_text_scaled(
                            &mut text,
                            &run,
                            Point {
                                x: 3.125,
                                y: 24.375,
                            },
                            Affine::IDENTITY,
                            clip,
                            paint,
                            density,
                        )
                        .unwrap();
                }
            }
            let target = gpu
                .device()
                .create_texture(&crate::wgpu::TextureDescriptor {
                    label: None,
                    size: crate::wgpu::Extent3d {
                        width: 96,
                        height: 72,
                        depth_or_array_layers: 1,
                    },
                    mip_level_count: 1,
                    sample_count: 1,
                    dimension: crate::wgpu::TextureDimension::D2,
                    format: gpu.format(),
                    usage: crate::wgpu::TextureUsages::RENDER_ATTACHMENT,
                    view_formats: &[],
                });
            for grouped in [false, true] {
                gpu.set_grouped_records(grouped);
                gpu.render(
                    canvas.prepared_scene(),
                    &target.create_view(&Default::default()),
                )
                .unwrap();
                let mut cursor = slots::prefix_words(canvas.prepared_scene().paint_bank().len());
                let (mut admitted, mut fallback) = (0, 0);
                for group in canvas.prepared_scene().groups() {
                    let compact = compact_group(group, grouped);
                    if compact {
                        cursor += 5;
                    }
                    for placement in group.placements() {
                        let draw = super::super::prepared(group, placement);
                        let lowered = lowered_mask_rect(&draw);
                        let tag = gpu.state.records[cursor + if compact { 1 } else { 5 }][0]
                            & LOWERED_MASK;
                        assert_eq!(tag != 0, lowered.is_some());
                        if let Some(rect) = lowered {
                            admitted += 1;
                            assert_eq!(
                                gpu.state.records[cursor],
                                [rect.x, rect.y, rect.width, rect.height].map(f32::to_bits)
                            );
                        } else {
                            fallback += 1;
                        }
                        cursor += if compact { 2 } else { 6 };
                    }
                }
                assert!(admitted >= 5 && fallback >= 4);
                eprintln!(
                    "MASK_LATTICE_PACKET banked={banked} grouped={grouped} admitted={admitted} fallback={fallback}"
                );
            }
        }
    });
}
