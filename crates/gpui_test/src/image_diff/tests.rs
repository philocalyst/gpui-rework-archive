use super::{DiffMode, compare_images, compare_transition_images, compare_transitions};
use crate::ImageDifference;
use image::{Rgba, RgbaImage};
use proptest::prelude::*;

#[test]
fn exact_metrics_keep_mismatches_resize_and_changed_bounds() {
    let before = RgbaImage::from_pixel(3, 2, Rgba([0, 0, 0, 255]));
    let mut current = RgbaImage::from_pixel(4, 2, Rgba([0, 0, 0, 255]));
    current.put_pixel(1, 0, Rgba([0, 0, 8, 255]));
    let compared = compare_images(&before, &current, DiffMode::Exact);
    assert_eq!(
        compared.difference,
        ImageDifference {
            changed_pixels: 3,
            total_pixels: 8,
            max_channel_error: 255,
            mean_channel_error: 16.1875,
            bounds: Some(crate::PixelRegion {
                x: 1,
                y: 0,
                width: 3,
                height: 2,
            }),
            visible: Some(crate::VisibleDifference {
                changed_pixels: 3,
                max_channel_error: 255.0,
                mean_channel_error: 16.1875,
            }),
            size_changed: true,
        }
    );
    assert_eq!(compared.image[(1, 0)], Rgba([255, 32, 32, 255]));
    assert_eq!(compared.image[(3, 1)], Rgba([255, 32, 32, 255]));
}

#[test]
fn invisible_transparent_rgb_changes_are_exact_but_not_visible() {
    let before = RgbaImage::from_pixel(1, 1, Rgba([255, 20, 40, 0]));
    let current = RgbaImage::from_pixel(1, 1, Rgba([0, 0, 0, 0]));
    let exact = compare_images(&before, &current, DiffMode::Exact);
    let magnitude = compare_images(&before, &current, DiffMode::Magnitude);
    assert_eq!(exact.difference.changed_pixels, 1);
    let visible = exact.difference.visible.as_ref().unwrap();
    assert_eq!(visible.changed_pixels, 0);
    assert_eq!(visible.max_channel_error, 0.0);
    assert_eq!(exact.image[(0, 0)], Rgba([255, 32, 32, 255]));
    assert_eq!(magnitude.image[(0, 0)], Rgba([224, 224, 224, 255]));
}

#[test]
fn alpha_only_change_contributes_visible_error() {
    let before = RgbaImage::from_pixel(1, 1, Rgba([90, 40, 10, 128]));
    let current = RgbaImage::from_pixel(1, 1, Rgba([90, 40, 10, 127]));
    let compared = compare_images(&before, &current, DiffMode::Magnitude);
    let current_context = compare_images(&current, &current, DiffMode::Magnitude).image[(0, 0)];
    let visible = compared.difference.visible.unwrap();
    assert_eq!(visible.changed_pixels, 1);
    assert_eq!(visible.max_channel_error, 1.0);
    assert!(visible.mean_channel_error > 0.25);
    assert!(compared.image[(0, 0)][0] > current_context[0]);
    assert!(compared.image[(0, 0)][0] < 255);
}

#[test]
fn magnitude_visualization_scales_without_erasing_exact_differences() {
    let before = RgbaImage::from_pixel(2, 1, Rgba([64, 64, 64, 255]));
    let mut current = before.clone();
    current.put_pixel(0, 0, Rgba([65, 64, 64, 255]));
    current.put_pixel(1, 0, Rgba([128, 64, 64, 255]));
    let exact = compare_images(&before, &current, DiffMode::Exact);
    let heatmap = compare_images(&before, &current, DiffMode::Magnitude);
    assert_eq!(exact.difference.changed_pixels, 2);
    assert_eq!(exact.image[(0, 0)], Rgba([255, 32, 32, 255]));
    assert!(heatmap.image[(1, 0)][0] > heatmap.image[(0, 0)][0]);
    assert!(heatmap.image[(0, 0)][0] < 255);
    assert!(heatmap.image[(1, 0)][0] < 255);
}

#[test]
fn empty_images_have_zero_statistics_and_empty_bounds() {
    let empty = RgbaImage::new(0, 0);
    let compared = compare_images(&empty, &empty, DiffMode::Magnitude);
    assert_eq!(compared.difference.changed_pixels, 0);
    assert_eq!(compared.difference.total_pixels, 0);
    assert_eq!(compared.difference.bounds, None);
    assert_eq!(compared.difference.visible.unwrap().mean_channel_error, 0.0);
    assert!(!compared.difference.size_changed);
}

#[test]
fn transparent_out_of_bounds_pixels_still_count_as_exact_size_changes() {
    let before = RgbaImage::new(1, 1);
    let current = RgbaImage::new(2, 1);
    let compared = compare_images(&before, &current, DiffMode::Exact);
    assert_eq!(compared.difference.changed_pixels, 1);
    assert_eq!(compared.difference.max_channel_error, 0);
    assert_eq!(compared.difference.bounds.unwrap().x, 1);
    assert_eq!(compared.difference.visible.unwrap().changed_pixels, 0);
    assert!(compared.difference.size_changed);
    assert_eq!(compared.image[(1, 0)], Rgba([255, 32, 32, 255]));
}

#[test]
fn equal_motion_cancels_a_static_color_offset() {
    let previous_before = RgbaImage::from_pixel(1, 1, Rgba([20, 30, 40, 255]));
    let before = RgbaImage::from_pixel(1, 1, Rgba([50, 30, 40, 255]));
    let previous_current = RgbaImage::from_pixel(1, 1, Rgba([10, 70, 90, 255]));
    let current = RgbaImage::from_pixel(1, 1, Rgba([40, 70, 90, 255]));
    let motion = compare_transitions(&previous_before, &before, &previous_current, &current);
    assert_eq!(motion.changed_pixels, 0);
    assert_eq!(motion.max_channel_error, 0.0);
    assert_eq!(motion.mean_channel_error, 0.0);
    assert_eq!(motion.bounds, None);
}

#[test]
fn motion_detects_a_frozen_frame_and_different_opacity() {
    let previous_before = RgbaImage::from_pixel(1, 1, Rgba([0, 0, 0, 255]));
    let before = RgbaImage::from_pixel(1, 1, Rgba([255, 0, 0, 255]));
    let previous_current = previous_before.clone();
    let frozen = previous_current.clone();
    let motion = compare_transitions(&previous_before, &before, &previous_current, &frozen);
    assert_eq!(motion.changed_pixels, 1);
    assert_eq!(motion.max_channel_error, 255.0);
    assert_eq!(motion.mean_channel_error, 51.0);

    let previous_before = RgbaImage::from_pixel(1, 1, Rgba([100, 20, 40, 128]));
    let before = RgbaImage::from_pixel(1, 1, Rgba([100, 20, 40, 255]));
    let previous_current = previous_before.clone();
    let current = RgbaImage::from_pixel(1, 1, Rgba([100, 20, 40, 200]));
    let opacity = compare_transitions(&previous_before, &before, &previous_current, &current);
    assert_eq!(opacity.changed_pixels, 1);
    assert!(opacity.max_channel_error > 0.0);
}

#[test]
fn motion_ignores_hidden_rgb_and_counts_extent_changes() {
    let previous_before = RgbaImage::from_pixel(1, 1, Rgba([255, 10, 20, 0]));
    let before = RgbaImage::from_pixel(1, 1, Rgba([0, 250, 240, 0]));
    let previous_current = RgbaImage::from_pixel(1, 1, Rgba([20, 30, 40, 0]));
    let current = RgbaImage::from_pixel(1, 1, Rgba([80, 90, 100, 0]));
    let hidden = compare_transitions(&previous_before, &before, &previous_current, &current);
    assert_eq!(hidden.changed_pixels, 0);

    let previous_before = RgbaImage::new(1, 1);
    let before = RgbaImage::new(2, 1);
    let previous_current = RgbaImage::new(1, 1);
    let current = RgbaImage::new(1, 1);
    let extent = compare_transitions(&previous_before, &before, &previous_current, &current);
    assert_eq!(extent.total_pixels, 2);
    assert_eq!(extent.changed_pixels, 1);
    assert_eq!(extent.max_channel_error, 255.0);
    assert_eq!(extent.bounds.unwrap().x, 1);
}

#[test]
fn opposite_motion_can_reach_510_channel_error() {
    let previous_before = RgbaImage::from_pixel(1, 1, Rgba([0, 0, 0, 0]));
    let before = RgbaImage::from_pixel(1, 1, Rgba([255, 255, 255, 255]));
    let previous_current = before.clone();
    let current = previous_before.clone();
    let motion = compare_transitions(&previous_before, &before, &previous_current, &current);
    assert_eq!(motion.changed_pixels, 1);
    assert_eq!(motion.max_channel_error, 510.0);
}

#[test]
fn transition_visualization_marks_motion_and_transparent_extent() {
    let previous_before = RgbaImage::from_pixel(2, 1, Rgba([0, 0, 0, 255]));
    let mut before = previous_before.clone();
    before.put_pixel(0, 0, Rgba([80, 0, 0, 255]));
    let previous_current = previous_before.clone();
    let mut current = previous_current.clone();
    current.put_pixel(0, 0, Rgba([40, 0, 0, 255]));

    let motion = compare_transition_images(
        &previous_before,
        &before,
        &previous_current,
        &current,
        DiffMode::Exact,
    );
    assert_eq!(motion.difference.changed_pixels, 1);
    assert_eq!(motion.image[(0, 0)], Rgba([255, 32, 32, 255]));
    assert_eq!(motion.image[(1, 0)], Rgba([0, 0, 0, 255]));

    let previous_before = RgbaImage::new(1, 1);
    let before = RgbaImage::new(2, 1);
    let previous_current = RgbaImage::new(1, 1);
    let current = RgbaImage::new(1, 1);
    let extent = compare_transition_images(
        &previous_before,
        &before,
        &previous_current,
        &current,
        DiffMode::Exact,
    );
    assert_eq!(extent.difference.bounds.unwrap().x, 1);
    assert_eq!(extent.image[(1, 0)], Rgba([255, 32, 32, 255]));

    // The current frames agree, but their prior frames differ, so the final frame must
    // still be marked as having different motion.
    let previous_before = RgbaImage::from_pixel(1, 1, Rgba([0, 0, 0, 255]));
    let before = RgbaImage::from_pixel(1, 1, Rgba([80, 0, 0, 255]));
    let previous_current = RgbaImage::from_pixel(1, 1, Rgba([40, 0, 0, 255]));
    let current = before.clone();
    let caught_up = compare_transition_images(
        &previous_before,
        &before,
        &previous_current,
        &current,
        DiffMode::Exact,
    );
    assert_eq!(caught_up.difference.changed_pixels, 1);
    assert_eq!(caught_up.image[(0, 0)], Rgba([255, 32, 32, 255]));
}

#[test]
fn identical_transition_visualizations_have_no_errors_and_match_statistics() {
    let previous_before = RgbaImage::from_pixel(2, 1, Rgba([20, 40, 60, 128]));
    let before = RgbaImage::from_pixel(2, 1, Rgba([80, 40, 60, 128]));
    let previous_current = previous_before.clone();
    let current = before.clone();

    let stats = compare_transitions(&previous_before, &before, &previous_current, &current);
    let exact = compare_transition_images(
        &previous_before,
        &before,
        &previous_current,
        &current,
        DiffMode::Exact,
    );
    let magnitude = compare_transition_images(
        &previous_before,
        &before,
        &previous_current,
        &current,
        DiffMode::Magnitude,
    );
    assert_eq!(stats.changed_pixels, 0);
    assert_eq!(stats, exact.difference);
    assert_eq!(stats, magnitude.difference);
    assert_eq!(exact.image, magnitude.image);

    let previous_current = RgbaImage::from_pixel(2, 1, Rgba([10, 40, 60, 128]));
    let current = RgbaImage::from_pixel(2, 1, Rgba([60, 40, 60, 128]));
    let stats = compare_transitions(&previous_before, &before, &previous_current, &current);
    let exact = compare_transition_images(
        &previous_before,
        &before,
        &previous_current,
        &current,
        DiffMode::Exact,
    );
    let magnitude = compare_transition_images(
        &previous_before,
        &before,
        &previous_current,
        &current,
        DiffMode::Magnitude,
    );
    assert!(stats.changed_pixels > 0);
    assert_eq!(stats, exact.difference);
    assert_eq!(stats, magnitude.difference);
    assert_eq!(exact.image[(0, 0)], Rgba([255, 32, 32, 255]));
    assert!(magnitude.image[(0, 0)][0] > 0);
}

proptest! {
    #![proptest_config(ProptestConfig { cases: 32, .. ProptestConfig::default() })]

    #[test]
    fn transition_comparison_is_reversal_symmetric_and_self_zero(
        a in any::<[u8; 4]>(),
        b in any::<[u8; 4]>(),
        c in any::<[u8; 4]>(),
        d in any::<[u8; 4]>(),
    ) {
        let previous_before = RgbaImage::from_pixel(1, 1, Rgba(a));
        let before = RgbaImage::from_pixel(1, 1, Rgba(b));
        let previous_current = RgbaImage::from_pixel(1, 1, Rgba(c));
        let current = RgbaImage::from_pixel(1, 1, Rgba(d));
        let forward = compare_transitions(
            &previous_before, &before, &previous_current, &current,
        );
        let reversed = compare_transitions(
            &before, &previous_before, &current, &previous_current,
        );
        let self_comparison = compare_transitions(
            &previous_before, &before, &previous_before, &before,
        );
        prop_assert_eq!(forward, reversed);
        prop_assert_eq!(self_comparison.changed_pixels, 0);
        prop_assert_eq!(self_comparison.max_channel_error, 0.0);
    }

    #[test]
    fn motion_cancels_under_bounded_rgb_offsets_at_shared_alpha(
        base_r in 0u8..=63, offset_r in 0u8..=63, step_r in 0u8..=63,
        base_g in 0u8..=63, offset_g in 0u8..=63, step_g in 0u8..=63,
        base_b in 0u8..=63, offset_b in 0u8..=63, step_b in 0u8..=63,
        alpha in any::<u8>(),
    ) {
        let previous_before = RgbaImage::from_pixel(
            1, 1, Rgba([base_r, base_g, base_b, alpha]),
        );
        let before = RgbaImage::from_pixel(
            1, 1, Rgba([base_r + step_r, base_g + step_g, base_b + step_b, alpha]),
        );
        let previous_current = RgbaImage::from_pixel(
            1, 1, Rgba([base_r + offset_r, base_g + offset_g, base_b + offset_b, alpha]),
        );
        let current = RgbaImage::from_pixel(
            1, 1,
            Rgba([
                base_r + offset_r + step_r,
                base_g + offset_g + step_g,
                base_b + offset_b + step_b,
                alpha,
            ]),
        );
        let motion = compare_transitions(
            &previous_before, &before, &previous_current, &current,
        );
        prop_assert_eq!(motion.changed_pixels, 0);
        prop_assert_eq!(motion.max_channel_error, 0.0);
    }

    #[test]
    fn exact_and_magnitude_modes_share_stats_for_small_rgba_images(
        before_width in 0u32..=3,
        before_height in 0u32..=3,
        current_width in 0u32..=3,
        current_height in 0u32..=3,
        seed in any::<u8>(),
        other_seed in any::<u8>(),
    ) {
        let before = RgbaImage::from_fn(before_width, before_height, |x, y| {
            Rgba([
                seed.wrapping_add(x as u8),
                seed.wrapping_add(y as u8),
                seed.wrapping_add(x as u8).wrapping_add(y as u8),
                seed.wrapping_mul(3),
            ])
        });
        let current = RgbaImage::from_fn(current_width, current_height, |x, y| {
            Rgba([
                other_seed.wrapping_add(x as u8),
                other_seed.wrapping_add(y as u8),
                other_seed.wrapping_add(x as u8).wrapping_add(y as u8),
                other_seed.wrapping_mul(3),
            ])
        });
        let exact = compare_images(&before, &current, DiffMode::Exact);
        let magnitude = compare_images(&before, &current, DiffMode::Magnitude);
        prop_assert_eq!(exact.difference, magnitude.difference);
    }
}
