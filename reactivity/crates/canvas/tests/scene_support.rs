use gpui_canvas::{Affine, Canvas, Color, ColorConfig, Rect, TextSystem};
#[expect(
    dead_code,
    reason = "Shared fixture also exports a viewport for scroll-only tests."
)]
#[path = "support/scroll_outside.rs"]
mod scroll_outside;

#[test]
fn complete_support_repairs_exact_cpu_pixels_with_order_material_and_tail_changes() {
    use scroll_outside::{CASES, SIZE, stage};
    for config in [
        ColorConfig::default(),
        ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.).unwrap(),
    ] {
        let bytes = if config == ColorConfig::default() {
            4
        } else {
            8
        };
        for case in 0..CASES {
            let mut canvas = Canvas::recording(SIZE[0], SIZE[1], config).unwrap();
            let mut text = TextSystem::bundled().unwrap();
            stage(&mut canvas, &mut text, case, 0, true).commit();
            let mut pixels = canvas.pixels().to_vec();
            for tick in 1..6 {
                let support =
                    stage(&mut canvas, &mut text, case, tick, true).commit_with_damage_regions();
                assert!(support.regions().len() <= 64);
                let expected = canvas.pixels();
                for repair in support.regions() {
                    if let Some([l, t, r, b]) = repair.bounds() {
                        for y in t..b {
                            let start = ((y * SIZE[0] + l) * bytes) as usize;
                            let end = ((y * SIZE[0] + r) * bytes) as usize;
                            pixels[start..end].copy_from_slice(&expected[start..end]);
                        }
                    }
                }
                assert!(
                    pixels == expected,
                    "case={case}, tick={tick}, bytes={bytes}"
                );
            }
        }
    }
}

#[test]
fn separated_support_stays_bounded_and_aborted_scene_preserves_its_predecessor() {
    let mut canvas = Canvas::recording(512, 64, Default::default()).unwrap();
    let clip = Rect::new(0., 0., 512., 64.);
    for count in [2, 64, 65, 80] {
        let mut initial = canvas.stage();
        initial.clear(Color::TRANSPARENT);
        for i in 0..count {
            initial
                .fill_rect(
                    Rect::new(i as f32 * 6., 2., 2., 2.),
                    Affine::IDENTITY,
                    clip,
                    Color::BLACK,
                )
                .unwrap();
        }
        initial.commit();
        let old = canvas.pixels().to_vec();
        {
            let mut aborted = canvas.stage();
            aborted.clear(Color::WHITE);
            assert!(
                aborted
                    .fill_rect(
                        Rect::new(f32::NAN, 0., 2., 2.),
                        Affine::IDENTITY,
                        clip,
                        Color::BLACK
                    )
                    .is_err()
            );
        }
        assert_eq!(canvas.pixels(), old);
        let mut next = canvas.stage();
        next.clear(Color::TRANSPARENT);
        for i in 0..count {
            next.fill_rect(
                Rect::new(i as f32 * 6., 2., 2., 2.),
                Affine::IDENTITY,
                clip,
                Color::WHITE,
            )
            .unwrap();
        }
        let support = next.commit_with_damage_regions();
        assert_eq!(support.regions().len(), if count > 64 { 1 } else { count });
        let expected = canvas.pixels().to_vec();
        let mut repaired = old;
        for region in support.regions() {
            if let Some([l, t, r, b]) = region.bounds() {
                for y in t..b {
                    let start = ((y * 512 + l) * 4) as usize;
                    let end = ((y * 512 + r) * 4) as usize;
                    repaired[start..end].copy_from_slice(&expected[start..end]);
                }
            }
        }
        assert_eq!(repaired, expected);
    }
}
