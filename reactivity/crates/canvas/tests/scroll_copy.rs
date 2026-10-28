use gpui_canvas::{Affine, Canvas, CanvasScene, Color, Point, Rect, ScrollCopy, TextSystem};

#[path = "support/scroll_outside.rs"]
mod scroll_outside;

#[test]
fn copied_overlap_and_outside_insert_remove_material_order_and_overflow_are_exact() {
    use scroll_outside::{CASES, SIZE, VIEW, offset, stage};
    for case in 0..CASES {
        let mut canvas = Canvas::recording(SIZE[0], SIZE[1], Default::default()).unwrap();
        let mut text = TextSystem::bundled().unwrap();
        stage(&mut canvas, &mut text, case, 0).commit();
        let mut pixels = canvas.pixels().to_vec();
        for tick in 1..6 {
            let (damage, plan) = stage(&mut canvas, &mut text, case, tick)
                .commit_with_scroll_damage(VIEW, offset(tick - 1) - offset(tick));
            let expected = canvas.pixels().to_vec();
            if let Some(plan) = &plan {
                let [l, t, r, b] = plan.source();
                let [x, y, _, _] = plan.destination();
                let old = pixels.clone();
                for dy in 0..b - t {
                    for dx in 0..r - l {
                        let from = (((t + dy) * SIZE[0] + l + dx) * 4) as usize;
                        let to = (((y + dy) * SIZE[0] + x + dx) * 4) as usize;
                        pixels[to..to + 4].copy_from_slice(&old[from..from + 4]);
                    }
                }
                assert!(plan.repairs().count() <= 256);
            }
            // Copy precisely the certified repairs from the complete CPU
            // oracle. Unlike the BGRX tile API, this accepts transparent pixels
            // and cannot hide missing repair pixels through tile expansion.
            let repairs: Vec<_> = plan
                .as_ref()
                .map_or_else(|| vec![damage], |p| p.repairs().collect());
            for repair in repairs {
                if let Some([l, t, r, b]) = repair.bounds() {
                    for y in t..b {
                        let from = ((y * SIZE[0] + l) * 4) as usize;
                        let to = ((y * SIZE[0] + r) * 4) as usize;
                        pixels[from..to].copy_from_slice(&expected[from..to]);
                    }
                }
            }
            assert!(pixels == expected, "outside case={case}, tick={tick}");
            if ![6, 8, 9].contains(&case) {
                assert!(plan.is_some(), "supported outside case={case}, tick={tick}");
            }
        }
    }
}

const WIDTH: usize = 80;
const HEIGHT: usize = 64;
const VIEW: [u32; 4] = [5, 7, 65, 55];

fn scene<'a>(
    canvas: &'a mut Canvas,
    text: &mut TextSystem,
    offset: f32,
    labels: bool,
    header: u8,
    changed_row: bool,
    overlay: bool,
) -> CanvasScene<'a> {
    let mut scene = canvas.stage();
    scene.clear(Color::BLACK);
    scene
        .fill_rect(
            Rect::new(0., 0., 80., 64.),
            Affine::IDENTITY,
            Rect::new(0., 0., 80., 64.),
            Color::WHITE,
        )
        .unwrap();
    scene
        .fill_rect(
            Rect::new(1., 1., 20., 4.),
            Affine::IDENTITY,
            Rect::new(0., 0., 80., 64.),
            Color::rgb(header, 40, 70),
        )
        .unwrap();
    let clip = Rect::new(5., 7., 60., 48.);
    for row in 0..20 {
        let y = 7. + row as f32 * 12. - offset;
        let color = if changed_row && row == 2 {
            Color::BLACK
        } else {
            Color::linear_srgb(0.1 + (row % 3) as f32 * 0.2, 0.3, 0.4, 0.7).unwrap()
        };
        scene
            .fill_rect(
                Rect::new(0., 0., 60., 12.),
                Affine::translation(5., y),
                clip,
                color,
            )
            .unwrap();
        if labels {
            let layout = text.shape(&format!("row {row}"), 9., None).unwrap();
            scene
                .draw_text(
                    text,
                    &layout,
                    Point { x: 0., y: 0. },
                    Affine::translation(7., y + 1.),
                    clip,
                    Color::BLACK,
                )
                .unwrap();
        }
    }
    if overlay {
        scene
            .fill_rect(
                Rect::new(20., 20., 10., 10.),
                Affine::IDENTITY,
                clip,
                Color::BLACK,
            )
            .unwrap();
    }
    scene
}
fn full(canvas: &mut Canvas) -> Vec<u32> {
    let mut pixels = vec![0; WIDTH * HEIGHT];
    canvas.render_bgrx(&mut pixels).unwrap();
    pixels
}
fn apply(canvas: &mut Canvas, pixels: &mut [u32], plan: ScrollCopy) {
    let [sx, sy, sr, sb] = plan.source();
    let [dx, dy, dr, db] = plan.destination();
    assert_eq!((sr - sx, sb - sy), (dr - dx, db - dy));
    let prior = pixels.to_vec();
    for y in 0..sb - sy {
        for x in 0..sr - sx {
            pixels[(dy + y) as usize * WIDTH + (dx + x) as usize] =
                prior[(sy + y) as usize * WIDTH + (sx + x) as usize];
        }
    }
    for repair in plan.repairs() {
        canvas.render_bgrx_region(pixels, repair).unwrap();
    }
}

#[test]
fn exact_scroll_copy_and_other_damage_match_complete_pixels() {
    for labels in [false, true] {
        let mut canvas =
            Canvas::recording(WIDTH as u32, HEIGHT as u32, Default::default()).unwrap();
        let mut text = TextSystem::bundled().unwrap();
        scene(&mut canvas, &mut text, 0., labels, 0, false, false).commit();
        let mut pixels = full(&mut canvas);
        let mut offset = 0;
        for (tick, next) in [6, 12, 24, 18, 0, 40, 7].into_iter().enumerate() {
            let (_, plan) = scene(
                &mut canvas,
                &mut text,
                next as f32,
                labels,
                tick as u8 + 1,
                false,
                false,
            )
            .commit_with_scroll_damage(VIEW, offset - next);
            let plan = plan.expect("supported translated rows must certify");
            apply(&mut canvas, &mut pixels, plan);
            assert!(
                pixels == full(&mut canvas),
                "labels={labels}, {offset}->{next}"
            );
            offset = next;
        }
    }
}

#[test]
fn changed_overlap_stationary_overlay_fractional_maps_and_bad_proposals_fall_back() {
    let mut text = TextSystem::bundled().unwrap();
    for (changed, overlay, offset, bounds, delta) in [
        (true, false, 6., VIEW, -6),
        (false, true, 6., VIEW, -6),
        (false, false, 6.5, VIEW, -6),
        (false, false, 6., [5, 7, 81, 55], -6),
        (false, false, 6., VIEW, i32::MIN),
        (false, false, 6., VIEW, 0),
        (false, false, 6., VIEW, -48),
        (false, false, 6., VIEW, -5),
    ] {
        let mut canvas =
            Canvas::recording(WIDTH as u32, HEIGHT as u32, Default::default()).unwrap();
        scene(&mut canvas, &mut text, 0., true, 0, false, overlay).commit();
        let mut pixels = full(&mut canvas);
        let (damage, plan) = scene(&mut canvas, &mut text, offset, true, 1, changed, overlay)
            .commit_with_scroll_damage(bounds, delta);
        assert!(
            plan.is_none(),
            "changed={changed}, overlay={overlay}, offset={offset}, delta={delta}"
        );
        canvas.render_bgrx_region(&mut pixels, damage).unwrap();
        assert!(pixels == full(&mut canvas));
    }
}

#[test]
fn moved_reused_gradient_falls_back_before_staged_lease_transfer() {
    use gpui_canvas::{Extend, Gradient, GradientGeometry, GradientStop, Interpolation};
    let gradient = Gradient::new(
        GradientGeometry::Linear {
            start: Point::default(),
            end: Point { x: 1., y: 0. },
        },
        &[
            GradientStop::new(0., Color::BLACK),
            GradientStop::new(1., Color::WHITE),
        ],
        Extend::Pad,
        Interpolation::LinearSrgb,
    )
    .unwrap();
    let mut canvas = Canvas::recording(WIDTH as u32, HEIGHT as u32, Default::default()).unwrap();
    let clip = Rect::new(0., 0., WIDTH as f32, HEIGHT as f32);
    let mut before = canvas.stage();
    before.clear(Color::WHITE);
    before
        .fill_gradient(
            &gradient,
            Rect::new(5., 1., 10., 4.),
            0.,
            Affine::IDENTITY,
            clip,
        )
        .unwrap();
    before.commit();
    let mut pixels = full(&mut canvas);
    let mut after = canvas.stage();
    after.clear(Color::WHITE);
    after
        .fill_gradient(
            &gradient,
            Rect::new(5., 20., 10., 4.),
            0.,
            Affine::IDENTITY,
            clip,
        )
        .unwrap();
    let (damage, plan) = after.commit_with_scroll_damage(VIEW, -6);
    assert!(plan.is_none());
    canvas.render_bgrx_region(&mut pixels, damage).unwrap();
    assert!(pixels == full(&mut canvas));
}

#[test]
fn unsupported_materials_clips_and_maps_keep_the_full_damage_fallback() {
    use gpui_canvas::{AlphaMode, Clip, ClipShape, Image, ImageProfile, ImageSampling};
    let image = Image::rgba8(
        1,
        1,
        ImageProfile::Srgb,
        AlphaMode::Straight,
        vec![60, 120, 180, 170].into_boxed_slice(),
    )
    .unwrap();
    for case in 0..8 {
        let mut canvas =
            Canvas::recording(WIDTH as u32, HEIGHT as u32, Default::default()).unwrap();
        let mut pixels = Vec::new();
        for offset in [0., 6.] {
            let mut scene = canvas.stage();
            scene.clear(Color::WHITE);
            let rect = Rect::new(0., 0., 30., 30.);
            let mut map = Affine::translation(10., 15. - offset);
            match case {
                0 => map.a = 1.25,
                1 => {
                    map.b = 0.25;
                    map.c = -0.25;
                }
                2 => map.tx += 0.5,
                _ => {}
            }
            let clip = Rect::new(5., 7., 60., 48.);
            let clip: Clip = if case == 3 {
                scene
                    .create_clip(
                        None,
                        ClipShape::RoundedRect {
                            rect: clip,
                            radius: 3.,
                        },
                        Affine::IDENTITY,
                    )
                    .unwrap()
                    .into()
            } else if case == 4 {
                Rect::new(5.5, 7., 59.5, 48.).into()
            } else {
                clip.into()
            };
            match case {
                5 => scene
                    .draw_image(&image, rect, map, clip, ImageSampling::Linear)
                    .unwrap(),
                6 => scene
                    .fill_rounded_rect(rect, 3., map, clip, Color::BLACK)
                    .unwrap(),
                7 => scene
                    .fill_rect(Rect::new(0.5, 0., 29.5, 30.), map, clip, Color::BLACK)
                    .unwrap(),
                _ => scene.fill_rect(rect, map, clip, Color::BLACK).unwrap(),
            }
            if offset == 0. {
                scene.commit();
                pixels = full(&mut canvas);
            } else {
                let (damage, plan) = scene.commit_with_scroll_damage(VIEW, -6);
                assert!(plan.is_none(), "unsupported case {case}");
                canvas.render_bgrx_region(&mut pixels, damage).unwrap();
                assert!(pixels == full(&mut canvas), "fallback case {case}");
            }
        }
    }
}

#[test]
fn changed_clear_order_glyph_identity_and_color_cannot_reuse_overlap() {
    use gpui_canvas::FontFace;
    for case in 0..5 {
        let mut canvas =
            Canvas::recording(WIDTH as u32, HEIGHT as u32, Default::default()).unwrap();
        let mut text = TextSystem::bundled().unwrap();
        let mut pixels = Vec::new();
        for after in [false, true] {
            if case == 3 && after {
                text = TextSystem::from_font(
                    FontFace::new(include_bytes!("../assets/NotoSans.ttf")).unwrap(),
                );
            }
            let mut scene = canvas.stage();
            scene.clear(if case == 0 && after {
                Color::WHITE
            } else {
                Color::BLACK
            });
            let clip = Rect::new(5., 7., 60., 48.);
            let map = Affine::translation(10., if after { 9. } else { 15. });
            for layer in 0..2 {
                let color = if (layer == 0) ^ (case == 1 && after) {
                    Color::rgba(200, 50, 30, 180)
                } else {
                    Color::rgba(30, 50, 200, 180)
                };
                scene
                    .fill_rect(Rect::new(0., 0., 30., 30.), map, clip, color)
                    .unwrap();
            }
            let label = if case == 2 && after {
                "changed"
            } else {
                "before"
            };
            let layout = text.shape(label, 9., None).unwrap();
            scene
                .draw_text(
                    &mut text,
                    &layout,
                    Point::default(),
                    map,
                    clip,
                    if case == 4 && after {
                        Color::BLACK
                    } else {
                        Color::WHITE
                    },
                )
                .unwrap();
            if after {
                let (damage, plan) = scene.commit_with_scroll_damage(VIEW, -6);
                assert!(plan.is_none(), "changed contribution case {case}");
                canvas.render_bgrx_region(&mut pixels, damage).unwrap();
                assert!(pixels == full(&mut canvas), "fallback case {case}");
            } else {
                scene.commit();
                pixels = full(&mut canvas);
            }
        }
    }
}

#[test]
fn changed_content_copy_would_fail_the_complete_pixel_oracle() {
    let mut text = TextSystem::bundled().unwrap();
    let mut canvas = Canvas::recording(WIDTH as u32, HEIGHT as u32, Default::default()).unwrap();
    scene(&mut canvas, &mut text, 0., true, 0, false, false).commit();
    let mut pixels = full(&mut canvas);
    let (damage, plan) =
        scene(&mut canvas, &mut text, 6., true, 1, true, false).commit_with_scroll_damage(VIEW, -6);
    // Exercise the complete operation before inspecting admission. A mutant
    // that admits the changed row must fail pixels, not only an Option assertion.
    if let Some(plan) = plan {
        apply(&mut canvas, &mut pixels, plan);
    } else {
        canvas.render_bgrx_region(&mut pixels, damage).unwrap();
    }
    assert!(
        pixels == full(&mut canvas),
        "changed overlap reused stale pixels"
    );
}
