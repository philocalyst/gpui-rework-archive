use gpui_canvas::{
    Affine, AlphaMode, Canvas, Color, ColorConfig, DamageRegion, Image, ImageSampling, PaintColor,
    PaintEdit, PaintIndex, Point, Rect, SlotEdit, TextLayout, TextSystem,
};

const CLIP: Rect = Rect::new(0.0, 0.0, 64.0, 48.0);

fn canvas() -> Canvas {
    Canvas::recording(64, 48, ColorConfig::default()).unwrap()
}
fn region(rect: Rect) -> DamageRegion {
    let mut canvas = canvas();
    let mut pending = canvas.stage();
    pending
        .fill_rect(rect, Affine::IDENTITY, CLIP, Color::BLACK)
        .unwrap();
    pending.commit_with_damage()
}
fn render(canvas: &mut Canvas) -> Vec<u32> {
    let mut words = vec![0; 64 * 48];
    canvas.render_bgrx(&mut words).unwrap();
    words
}

fn hdr_opaque_scene(proofs: bool, red: f32) -> Canvas {
    let rect = Rect::new(0.0, 0.0, 16.0, 16.0);
    let mut canvas = Canvas::recording(
        16,
        16,
        ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap(),
    )
    .unwrap();
    canvas.set_tile_proofs(proofs);
    canvas.clear(Color::linear_srgb(0.0, 0.0, 0.0, 1.0).unwrap());
    for red in [-1.0, red] {
        canvas
            .fill_rect(
                rect,
                Affine::IDENTITY,
                rect,
                Color::linear_srgb(red, 0.0, 0.0, 1.0).unwrap(),
            )
            .unwrap();
    }
    canvas
}

fn hdr_red(canvas: &mut Canvas) -> u16 {
    u16::from_le_bytes(canvas.pixels()[..2].try_into().unwrap())
}

#[test]
fn fresh_negative_zero_opaque_cut_matches_scalar_hdr() {
    let mut scalar = hdr_opaque_scene(false, -0.0);
    let mut optimized = hdr_opaque_scene(true, -0.0);
    assert_eq!(hdr_red(&mut scalar), 0x8000);
    assert_eq!(hdr_red(&mut optimized), hdr_red(&mut scalar));
    assert_eq!(optimized.pixels(), scalar.pixels());
}

#[test]
fn exceptional_paint_retires_cached_cuts_only_after_commit_and_reuses_geometry() {
    let mut canvas = hdr_opaque_scene(true, 1.0);
    canvas.pixels();
    assert_eq!(canvas.stats().skipped_command_tiles, 1);
    let bins = canvas.stats().bin_bytes;
    let index = canvas.paint_index(1).unwrap();
    for value in [-0.0, -f32::from_bits(1), 1.0, -0.0] {
        let edits = [PaintEdit::new(
            index,
            Color::linear_srgb(value, 0.0, 0.0, 1.0).unwrap(),
        )];
        let old = canvas.pixels().to_vec();
        drop(canvas.prepare_paint(&edits).unwrap());
        assert_eq!(canvas.pixels(), old);
        let bad = [edits[0], edits[0]];
        assert!(canvas.prepare_paint(&bad).is_err());
        assert_eq!(canvas.pixels(), old);
        let allocation = allocation_counter::measure(|| {
            canvas.prepare_paint(&edits).unwrap().commit();
        });
        assert_eq!((allocation.count_total, allocation.bytes_total), (0, 0));
        let mut scalar = hdr_opaque_scene(false, value);
        assert_eq!(hdr_red(&mut canvas), hdr_red(&mut scalar));
        assert_eq!(canvas.pixels(), scalar.pixels());
        assert!(canvas.stats().bins_reused);
        assert_eq!(canvas.stats().bin_bytes, bins);
        assert_eq!(
            canvas.stats().skipped_command_tiles,
            usize::from(value == 1.0)
        );
    }
}

#[test]
fn shared_colors_revoke_cached_cuts_without_touching_geometry_or_allocating() {
    let mut canvas = hdr_opaque_scene(true, -1.0);
    let rect = Rect::new(0.0, 0.0, 16.0, 16.0);
    let slot = canvas.paint_slot(PaintColor::new(Color::WHITE)).unwrap();
    canvas
        .fill_rect_slot(rect, Affine::IDENTITY, rect, slot)
        .unwrap();
    canvas.pixels();
    assert_eq!(canvas.stats().skipped_command_tiles, 2);
    let bins = canvas.stats().bin_bytes;
    for red in [-0.0, -f32::from_bits(1), 1.0, -0.0] {
        let color = Color::linear_srgb(red, 0.0, 0.0, 1.0).unwrap();
        let edits = [SlotEdit::new(slot, PaintColor::new(color))];
        let before = canvas.pixels().to_vec();
        {
            let _uncommitted = canvas.prepare_slots(&edits).unwrap();
        }
        assert_eq!(canvas.pixels(), before);
        assert!(canvas.prepare_slots(&[edits[0], edits[0]]).is_err());
        assert_eq!(canvas.pixels(), before);
        let cost = allocation_counter::measure(|| {
            canvas.prepare_slots(&edits).unwrap().commit();
        });
        assert_eq!((cost.count_total, cost.bytes_total), (0, 0));
        let mut scalar = hdr_opaque_scene(false, red);
        assert_eq!(canvas.pixels(), scalar.pixels());
        assert!(canvas.stats().bins_reused);
        assert_eq!(canvas.stats().bin_bytes, bins);
        assert_eq!(
            canvas.stats().skipped_command_tiles,
            if red == 1.0 { 2 } else { 1 }
        );
    }
}

struct Fixture {
    text: TextSystem,
    layout: TextLayout,
    images: [Image; 2],
}
impl Fixture {
    fn new() -> Self {
        let text = TextSystem::bundled().unwrap();
        let layout = text.shape("ABA café", 16.0, None).unwrap();
        Self {
            text,
            layout,
            images: [
                Image::linear_srgb(1, 1, AlphaMode::Straight, Box::new([[0.0, 0.2, 0.8, 0.5]]))
                    .unwrap(),
                Image::linear_srgb(1, 1, AlphaMode::Straight, Box::new([[0.8, 0.2, 0.0, 0.5]]))
                    .unwrap(),
            ],
        }
    }
    fn scene(&mut self, canvas: &mut Canvas, variant: usize, color: Color) -> PaintIndex {
        canvas.clear(Color::WHITE);
        let at = canvas.paint_cursor();
        canvas
            .fill_rect(CLIP, Affine::IDENTITY, CLIP, color)
            .unwrap();
        let index = canvas.paint_index(at).unwrap();
        let rounded = |canvas: &mut Canvas| {
            canvas
                .fill_rounded_rect(
                    Rect::new(2.25, 3.5, 39.0, 23.0),
                    5.0,
                    Affine {
                        c: variant as f32 * 0.125,
                        ..Affine::IDENTITY
                    },
                    CLIP,
                    Color::rgba(255, 0, 0, 128),
                )
                .unwrap();
        };
        let image = |canvas: &mut Canvas| {
            canvas
                .draw_image(
                    &self.images[variant % 2],
                    Rect::new(8.0, 6.0, 32.0, 24.0),
                    Affine::IDENTITY,
                    CLIP,
                    ImageSampling::Nearest,
                )
                .unwrap();
        };
        if variant < 2 {
            rounded(canvas);
            image(canvas);
        } else {
            image(canvas);
            rounded(canvas);
        }
        canvas
            .draw_text(
                &mut self.text,
                &self.layout,
                Point { x: 1.0, y: 12.0 },
                Affine::IDENTITY,
                CLIP,
                Color::BLACK,
            )
            .unwrap();
        index
    }
}

#[test]
fn color_patches_reuse_unpruned_bins_and_match_fresh_full_scenes() {
    let mut fixture = Fixture::new();
    for proofs in [false, true] {
        let mut patched = canvas();
        patched.set_tile_proofs(proofs);
        let index = fixture.scene(&mut patched, 0, Color::BLACK);
        let mut output = render(&mut patched);
        assert!(!patched.stats().bins_reused);
        let bins = patched.stats().bin_bytes;
        for color in [
            Color::WHITE,
            Color::linear_srgb(-0.0, f32::from_bits(1), -f32::from_bits(1), 1.0).unwrap(),
            Color::linear_display_p3(-0.25, 2.0, 0.3, 1.0).unwrap(),
            Color::rgb(30, 100, 200),
        ] {
            let edits = [PaintEdit::new(index, color)];
            let damage = patched.prepare_paint(&edits).unwrap().commit();
            patched.render_bgrx_region(&mut output, damage).unwrap();
            assert!(patched.stats().bins_reused);
            assert_eq!(patched.stats().bin_bytes, bins);
            let mut fresh = canvas();
            fresh.set_tile_proofs(proofs);
            fixture.scene(&mut fresh, 0, color);
            assert_eq!(output, render(&mut fresh));
            assert_eq!(
                patched.pixels(),
                fresh.pixels(),
                "external repair keeps diagnostic dirty"
            );
            assert!(patched.stats().bins_reused);
        }
        patched.set_tile_proofs(!proofs);
        assert_eq!(render(&mut patched), output);
        assert!(patched.stats().bins_reused);
    }
}

#[test]
fn containing_tile_envelopes_survive_empty_regions_and_diagnostic_interleaving() {
    let mut canvas = canvas();
    canvas.clear(Color::WHITE);
    let mut output = vec![0x123456; 64 * 48];
    let small = region(Rect::new(2.0, 3.0, 2.0, 3.0));
    canvas.render_bgrx_region(&mut output, small).unwrap();
    assert!(
        !canvas.stats().bins_reused,
        "first regional render primes only itself"
    );
    let same_tiles = region(Rect::new(8.0, 9.0, 4.0, 4.0));
    canvas.render_bgrx_region(&mut output, same_tiles).unwrap();
    assert!(canvas.stats().bins_reused);
    canvas
        .render_bgrx_region(&mut output, DamageRegion::default())
        .unwrap();
    assert!(!canvas.stats().bins_reused);
    canvas.render_bgrx_region(&mut output, same_tiles).unwrap();
    assert!(
        canvas.stats().bins_reused,
        "empty region preserved cached bins"
    );
    canvas.pixels();
    assert!(
        !canvas.stats().bins_reused,
        "full diagnostic needs larger bins"
    );
    render(&mut canvas);
    assert!(canvas.stats().bins_reused);
    for rect in [
        Rect::new(2.0, 3.0, 2.0, 3.0),
        Rect::new(49.0, 33.0, 2.0, 2.0),
    ] {
        canvas
            .render_bgrx_region(&mut output, region(rect))
            .unwrap();
        assert!(
            canvas.stats().bins_reused,
            "full cache covers distant repairs"
        );
    }
    canvas
        .fill_rect(CLIP, Affine::IDENTITY, CLIP, Color::BLACK)
        .unwrap();
    let output = render(&mut canvas);
    assert!(
        !canvas.stats().bins_reused,
        "append invalidates empty-scene CSR"
    );
    assert!(output.iter().all(|&pixel| pixel == 0));
}

#[test]
fn cached_origin_and_stride_do_not_change_regional_output_or_reference_stats() {
    let mut fixture = Fixture::new();
    for proofs in [false, true] {
        let mut patched = canvas();
        patched.set_tile_proofs(proofs);
        fixture.scene(&mut patched, 0, Color::BLACK);
        let mut fresh = canvas();
        fresh.set_tile_proofs(proofs);
        fixture.scene(&mut fresh, 0, Color::BLACK);
        let oracle = render(&mut fresh);
        let sentinel = 0x00123456;
        let mut output = vec![sentinel; 64 * 48];
        let prime = region(Rect::new(17.0, 17.0, 46.0, 30.0));
        patched.render_bgrx_region(&mut output, prime).unwrap();
        assert!(!patched.stats().bins_reused);
        let capacity = patched.stats().bin_bytes;
        for y in 0..48 {
            for x in 0..64 {
                assert_eq!(
                    output[y * 64 + x],
                    if x >= 16 && y >= 16 {
                        oracle[y * 64 + x]
                    } else {
                        sentinel
                    }
                );
            }
        }
        for rect in [
            Rect::new(33.0, 33.0, 14.0, 14.0),
            Rect::new(17.0, 17.0, 14.0, 14.0),
        ] {
            let damage = region(rect);
            let mut repaired = vec![sentinel; 64 * 48];
            patched.render_bgrx_region(&mut repaired, damage).unwrap();
            assert!(patched.stats().bins_reused);
            assert_eq!(patched.stats().bin_bytes, capacity);
            let mut regional = canvas();
            regional.set_tile_proofs(proofs);
            fixture.scene(&mut regional, 0, Color::BLACK);
            let mut expected = vec![sentinel; 64 * 48];
            regional.render_bgrx_region(&mut expected, damage).unwrap();
            assert!(!regional.stats().bins_reused);
            assert_eq!(repaired, expected);
            assert_eq!(
                patched.stats().tile_references,
                regional.stats().tile_references,
                "references count requested tiles, not the larger cached CSR"
            );
        }
        let outside = region(Rect::new(0.0, 0.0, 16.0, 16.0));
        patched.render_bgrx_region(&mut output, outside).unwrap();
        assert!(
            !patched.stats().bins_reused,
            "noncontained request rebuilds"
        );
        assert_eq!(render(&mut patched), oracle);
        assert!(
            !patched.stats().bins_reused,
            "regional miss did not prebuild full viewport"
        );
    }
}

#[test]
fn structural_commits_reject_stale_bins_even_with_identical_counts_and_bounds() {
    let mut fixture = Fixture::new();
    let mut canvas = canvas();
    fixture.scene(&mut canvas, 0, Color::BLACK);
    render(&mut canvas);
    let count = canvas.stats().commands;
    for variant in [1, 2, 0] {
        // Changed resource, transform and painter order are separate from the
        // broad full-frame support and unchanged command count.
        fixture.scene(&mut canvas, variant, Color::BLACK);
        let output = render(&mut canvas);
        assert!(!canvas.stats().bins_reused);
        assert_eq!(canvas.stats().commands, count);
        let mut fresh = self::canvas();
        fixture.scene(&mut fresh, variant, Color::BLACK);
        assert_eq!(output, render(&mut fresh));
    }
    let mut pending = canvas.stage();
    pending.clear(Color::BLACK);
    pending
        .fill_rect(CLIP, Affine::IDENTITY, CLIP, Color::WHITE)
        .unwrap();
    pending.commit();
    assert!(
        render(&mut canvas)
            .iter()
            .all(|&pixel| pixel == 0x00ff_ffff)
    );
    assert!(!canvas.stats().bins_reused);
}

#[test]
fn failed_and_dropped_work_preserves_valid_bins_and_prior_pixels() {
    let mut canvas = canvas();
    canvas.clear(Color::WHITE);
    canvas
        .fill_rounded_rect(
            Rect::new(3.0, 3.0, 20.0, 20.0),
            4.0,
            Affine::IDENTITY,
            CLIP,
            Color::BLACK,
        )
        .unwrap();
    let before = render(&mut canvas);
    assert!(!canvas.stats().bins_reused);
    assert!(
        canvas
            .fill_rect(
                CLIP,
                Affine {
                    a: f32::NAN,
                    ..Affine::IDENTITY
                },
                CLIP,
                Color::BLACK
            )
            .is_err()
    );
    let mut pending = canvas.stage();
    pending.clear(Color::BLACK);
    pending
        .fill_rect(CLIP, Affine::IDENTITY, CLIP, Color::WHITE)
        .unwrap();
    drop(pending);
    let index = canvas.paint_index(0).unwrap();
    let invalid = [PaintEdit::new(index, Color::TRANSPARENT)];
    assert!(canvas.prepare_paint(&invalid).is_err());
    let valid = [PaintEdit::new(index, Color::WHITE)];
    drop(canvas.prepare_paint(&valid).unwrap());
    assert!(canvas.render_bgrx(&mut [0; 1]).is_err());
    assert_eq!(render(&mut canvas), before);
    assert!(canvas.stats().bins_reused);
}

#[cfg(feature = "parallel")]
#[test]
fn serial_and_parallel_raster_share_the_same_current_geometry_cache() {
    let mut fixture = Fixture::new();
    let pool = gpui_canvas::RenderPool::new(2).unwrap().with_min_work(0);
    let mut patched = canvas();
    let index = fixture.scene(&mut patched, 0, Color::BLACK);
    patched.pixels_with(&pool);
    assert!(patched.stats().parallel);
    assert!(!patched.stats().bins_reused);
    let color = Color::rgb(110, 20, 70);
    patched
        .prepare_paint(&[PaintEdit::new(index, color)])
        .unwrap()
        .commit();
    let mut fresh = canvas();
    fixture.scene(&mut fresh, 0, color);
    assert_eq!(patched.pixels_with(&pool), fresh.pixels());
    assert!(patched.stats().bins_reused);
    assert!(patched.stats().parallel);
    patched.set_tile_proofs(false);
    assert_eq!(patched.pixels(), fresh.pixels());
    assert!(patched.stats().bins_reused);
    assert!(!patched.stats().parallel);
}

#[cfg(feature = "parallel")]
#[test]
fn parallel_repairs_use_cached_stride_but_visit_only_requested_bands() {
    let mut fixture = Fixture::new();
    let pool = gpui_canvas::RenderPool::new(2).unwrap().with_min_work(0);
    let mut cached = canvas();
    fixture.scene(&mut cached, 0, Color::BLACK);
    let mut words = vec![0; 64 * 48];
    cached.render_bgrx_with(&mut words, &pool).unwrap();
    assert!(!cached.stats().bins_reused);
    for rect in [
        Rect::new(33.0, 17.0, 30.0, 30.0),
        Rect::new(1.0, 1.0, 14.0, 30.0),
    ] {
        let damage = region(rect);
        let mut parallel = vec![0x123456; 64 * 48];
        cached
            .render_bgrx_region_with(&mut parallel, damage, &pool)
            .unwrap();
        assert!(cached.stats().parallel);
        assert!(cached.stats().bins_reused);
        assert_eq!(cached.stats().output_bands, 2);
        let mut fresh = canvas();
        fixture.scene(&mut fresh, 0, Color::BLACK);
        let mut serial = vec![0x123456; 64 * 48];
        fresh.render_bgrx_region(&mut serial, damage).unwrap();
        assert_eq!(parallel, serial);
        assert_eq!(
            cached.stats().tile_references,
            fresh.stats().tile_references
        );
    }
}
