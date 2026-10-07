/// Raw and visible pixel differences between two captured images.
#[derive(Clone, Debug, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct ImageDifference {
    /// Pixels with an RGBA difference or present in only one input image.
    pub changed_pixels: u64,
    /// Pixels in the comparison canvas spanning both image dimensions.
    pub total_pixels: u64,
    /// Largest absolute raw RGBA channel difference in an 8-bit channel.
    pub max_channel_error: u8,
    /// Mean absolute difference across all RGBA channels, in the range 0–255.
    pub mean_channel_error: f64,
    /// Half-open bounding rectangle containing every exact changed pixel.
    #[serde(default)]
    pub bounds: Option<PixelRegion>,
    /// Alpha-aware premultiplied-pixel difference statistics.
    #[serde(default)]
    pub visible: Option<VisibleDifference>,
    /// Whether the input dimensions differed. Inputs are compared over their union bounds.
    #[serde(default)]
    pub size_changed: bool,
}

/// Pixel rectangle containing exact image differences.
#[derive(Clone, Copy, Debug, PartialEq, Eq, serde::Serialize, serde::Deserialize)]
pub struct PixelRegion {
    /// Left edge of the region.
    pub x: u32,
    /// Top edge of the region.
    pub y: u32,
    /// Width of the half-open region.
    pub width: u32,
    /// Height of the half-open region.
    pub height: u32,
}

/// Differences after treating RGB as alpha-premultiplied for visibility.
#[derive(Clone, Debug, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct VisibleDifference {
    /// Pixels with any visible premultiplied RGB or alpha difference.
    pub changed_pixels: u64,
    /// Largest visible channel difference in the range 0–255.
    pub max_channel_error: f64,
    /// Mean visible channel difference across RGBA channels, in the range 0–255.
    pub mean_channel_error: f64,
}

/// How a comparison image marks differences.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum DiffMode {
    /// Mark every exact RGBA difference with solid red.
    Exact,
    /// Blend red in proportion to visible pixel error over the current image.
    Magnitude,
}

/// Image comparison statistics and a visualization with the dimensions of the union of inputs.
#[derive(Clone, Debug)]
pub struct ImageComparison {
    /// The selected exact-mask or magnitude heatmap visualization.
    pub image: image::RgbaImage,
    /// Exact RGBA statistics plus alpha-aware visible statistics.
    pub difference: ImageDifference,
}

/// Pixel-motion differences between two pairs of RGBA frames.
#[derive(Clone, Debug, Default, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct MotionDifference {
    /// Pixels in the comparison canvas spanning all four image dimensions.
    pub total_pixels: u64,
    /// Pixels with a visible motion or image-extent difference.
    pub changed_pixels: u64,
    /// Largest per-channel difference between signed frame deltas, in the range 0–510.
    pub max_channel_error: f64,
    /// Mean difference across premultiplied RGBA and image-presence deltas.
    pub mean_channel_error: f64,
    /// Half-open bounding rectangle containing every changed pixel.
    pub bounds: Option<PixelRegion>,
}

/// Pixel-motion statistics paired with a transition-difference visualization.
#[derive(Clone, Debug)]
pub struct TransitionComparison {
    /// The exact transition mask or magnitude heatmap over the current frame.
    pub image: image::RgbaImage,
    /// Visible motion and frame-extent difference statistics.
    pub difference: MotionDifference,
}

/// Compare two straight-alpha RGBA images without resizing either input.
///
/// Pixels outside either input's bounds are treated as transparent black. Exact statistics count
/// raw RGBA differences; visible statistics compare premultiplied RGB and alpha so hidden RGB
/// values under fully transparent pixels do not appear as visible errors.
pub fn compare_images(
    before: &image::RgbaImage,
    current: &image::RgbaImage,
    mode: DiffMode,
) -> ImageComparison {
    let width = before.width().max(current.width());
    let height = before.height().max(current.height());
    let mut image = image::RgbaImage::new(width, height);
    let mut changed_pixels = 0;
    let mut max_channel_error = 0;
    let mut channel_error_sum = 0u64;
    let mut visible_changed_pixels = 0;
    let mut max_visible_channel_error = 0.0f64;
    let mut visible_channel_error_sum = 0.0f64;
    let mut changed_bounds: Option<(u32, u32, u32, u32)> = None;

    for y in 0..height {
        for x in 0..width {
            let before_pixel = before.get_pixel_checked(x, y);
            let current_pixel = current.get_pixel_checked(x, y);
            let resized_pixel = before_pixel.is_none() != current_pixel.is_none();
            let a = before_pixel.map(|pixel| pixel.0).unwrap_or([0; 4]);
            let b = current_pixel.map(|pixel| pixel.0).unwrap_or([0; 4]);
            let mut exact_changed = resized_pixel;
            let mut visible_changed = false;
            let mut visible_pixel_error = 0.0f64;
            for channel in 0..4 {
                let error = a[channel].abs_diff(b[channel]);
                max_channel_error = max_channel_error.max(error);
                channel_error_sum = channel_error_sum.saturating_add(u64::from(error));
                exact_changed |= error != 0;

                let visible_error = if channel == 3 {
                    f64::from(a[3].abs_diff(b[3]))
                } else {
                    let a_premultiplied = u16::from(a[channel]) * u16::from(a[3]);
                    let b_premultiplied = u16::from(b[channel]) * u16::from(b[3]);
                    f64::from(a_premultiplied.abs_diff(b_premultiplied)) / 255.0
                };
                visible_changed |= visible_error > 0.0;
                visible_pixel_error = visible_pixel_error.max(visible_error);
                max_visible_channel_error = max_visible_channel_error.max(visible_error);
                visible_channel_error_sum += visible_error;
            }

            if exact_changed {
                changed_pixels += 1;
                changed_bounds = Some(match changed_bounds {
                    Some((min_x, min_y, max_x, max_y)) => {
                        (min_x.min(x), min_y.min(y), max_x.max(x), max_y.max(y))
                    }
                    None => (x, y, x, y),
                });
            }
            if visible_changed {
                visible_changed_pixels += 1;
            }

            let context = composite_over_checker(b, x, y);
            image.put_pixel(
                x,
                y,
                match mode {
                    DiffMode::Exact if exact_changed => image::Rgba([255, 32, 32, 255]),
                    DiffMode::Magnitude if visible_pixel_error > 0.0 => {
                        blend_red(context, (visible_pixel_error / 255.0).sqrt())
                    }
                    _ => context,
                },
            );
        }
    }

    let total_pixels = u64::from(width) * u64::from(height);
    let total_channels = total_pixels.saturating_mul(4);
    let difference = ImageDifference {
        changed_pixels,
        total_pixels,
        max_channel_error,
        mean_channel_error: mean(channel_error_sum as f64, total_channels),
        bounds: changed_bounds.map(|(min_x, min_y, max_x, max_y)| PixelRegion {
            x: min_x,
            y: min_y,
            width: max_x - min_x + 1,
            height: max_y - min_y + 1,
        }),
        visible: Some(VisibleDifference {
            changed_pixels: visible_changed_pixels,
            max_channel_error: max_visible_channel_error,
            mean_channel_error: mean(visible_channel_error_sum, total_channels),
        }),
        size_changed: before.dimensions() != current.dimensions(),
    };
    ImageComparison { image, difference }
}

/// Compare visible per-pixel motion between two pairs of frames without making an output image.
///
/// Each side's signed frame-to-frame delta is compared over the union of all four image bounds.
/// RGB is premultiplied by alpha before differencing, so hidden RGB changes under zero alpha do
/// not count. A fifth presence channel records extent entering or leaving the frame, including
/// fully transparent areas. The mean is across these five channels, each scaled to 0–255 per
/// frame; opposite motion can therefore produce errors up to 510.
pub fn compare_transitions(
    previous_before: &image::RgbaImage,
    before: &image::RgbaImage,
    previous_current: &image::RgbaImage,
    current: &image::RgbaImage,
) -> MotionDifference {
    // Matching frame pairs imply matching transitions, including extent. A byte comparison
    // avoids walking every channel again for the common unchanged-baseline case.
    if previous_before == previous_current && before == current {
        let (width, height) =
            transition_dimensions([previous_before, before, previous_current, current]);
        return MotionDifference {
            total_pixels: u64::from(width) * u64::from(height),
            ..Default::default()
        };
    }
    compare_transitions_with(
        previous_before,
        before,
        previous_current,
        current,
        |_, _, _, _| {},
    )
}

/// Compare and visualize visible motion between two pairs of frames.
///
/// Exact mode marks every pixel whose visible frame-to-frame delta or image extent differs.
/// Magnitude mode blends red in proportion to the largest per-channel motion error, scaled over
/// the full 0–510 range. Both modes show the current image over the standard checker context.
pub fn compare_transition_images(
    previous_before: &image::RgbaImage,
    before: &image::RgbaImage,
    previous_current: &image::RgbaImage,
    current: &image::RgbaImage,
    mode: DiffMode,
) -> TransitionComparison {
    let (width, height) =
        transition_dimensions([previous_before, before, previous_current, current]);
    let mut image = image::RgbaImage::new(width, height);
    let difference = compare_transitions_with(
        previous_before,
        before,
        previous_current,
        current,
        |x, y, changed, error| {
            let context = composite_over_checker(
                current
                    .get_pixel_checked(x, y)
                    .map(|pixel| pixel.0)
                    .unwrap_or([0; 4]),
                x,
                y,
            );
            image.put_pixel(
                x,
                y,
                match mode {
                    DiffMode::Exact if changed => image::Rgba([255, 32, 32, 255]),
                    DiffMode::Magnitude if error > 0.0 => {
                        blend_red(context, (error / 510.0).sqrt())
                    }
                    _ => context,
                },
            );
        },
    );
    TransitionComparison { image, difference }
}

fn compare_transitions_with(
    previous_before: &image::RgbaImage,
    before: &image::RgbaImage,
    previous_current: &image::RgbaImage,
    current: &image::RgbaImage,
    mut visit_pixel: impl FnMut(u32, u32, bool, f64),
) -> MotionDifference {
    let (width, height) =
        transition_dimensions([previous_before, before, previous_current, current]);
    let mut changed_pixels = 0;
    let mut max_channel_error = 0.0f64;
    let mut channel_error_sum = 0.0f64;
    let mut bounds: Option<(u32, u32, u32, u32)> = None;

    for y in 0..height {
        for x in 0..width {
            let previous_before_pixel = previous_before.get_pixel_checked(x, y);
            let before_pixel = before.get_pixel_checked(x, y);
            let previous_current_pixel = previous_current.get_pixel_checked(x, y);
            let current_pixel = current.get_pixel_checked(x, y);
            let previous_before_value = previous_before_pixel.map(|p| p.0).unwrap_or([0; 4]);
            let before_value = before_pixel.map(|p| p.0).unwrap_or([0; 4]);
            let previous_current_value = previous_current_pixel.map(|p| p.0).unwrap_or([0; 4]);
            let current_value = current_pixel.map(|p| p.0).unwrap_or([0; 4]);
            let mut pixel_changed = false;
            let mut pixel_error = 0.0f64;

            for channel in 0..4 {
                let before_delta = premultiplied_channel(before_value, channel)
                    - premultiplied_channel(previous_before_value, channel);
                let current_delta = premultiplied_channel(current_value, channel)
                    - premultiplied_channel(previous_current_value, channel);
                // Subtract integer products before normalization: identical fractional-alpha
                // motion must stay exactly equal rather than accumulate floating-point noise.
                let error = f64::from((before_delta - current_delta).unsigned_abs()) / 255.0;
                pixel_changed |= error > 0.0;
                pixel_error = pixel_error.max(error);
                max_channel_error = max_channel_error.max(error);
                channel_error_sum += error;
            }

            let before_extent_delta =
                before_pixel.is_some() as i16 - previous_before_pixel.is_some() as i16;
            let current_extent_delta =
                current_pixel.is_some() as i16 - previous_current_pixel.is_some() as i16;
            let extent_error =
                f64::from(before_extent_delta.abs_diff(current_extent_delta)) * 255.0;
            pixel_changed |= extent_error > 0.0;
            pixel_error = pixel_error.max(extent_error);
            max_channel_error = max_channel_error.max(extent_error);
            channel_error_sum += extent_error;

            visit_pixel(x, y, pixel_changed, pixel_error);

            if pixel_changed {
                changed_pixels += 1;
                bounds = Some(match bounds {
                    Some((min_x, min_y, max_x, max_y)) => {
                        (min_x.min(x), min_y.min(y), max_x.max(x), max_y.max(y))
                    }
                    None => (x, y, x, y),
                });
            }
        }
    }

    let total_pixels = u64::from(width) * u64::from(height);
    MotionDifference {
        total_pixels,
        changed_pixels,
        max_channel_error,
        mean_channel_error: mean(channel_error_sum, total_pixels.saturating_mul(5)),
        bounds: bounds.map(|(min_x, min_y, max_x, max_y)| PixelRegion {
            x: min_x,
            y: min_y,
            width: max_x - min_x + 1,
            height: max_y - min_y + 1,
        }),
    }
}

fn transition_dimensions(frames: [&image::RgbaImage; 4]) -> (u32, u32) {
    frames.into_iter().fold((0, 0), |(width, height), frame| {
        (width.max(frame.width()), height.max(frame.height()))
    })
}

fn premultiplied_channel(pixel: [u8; 4], channel: usize) -> i32 {
    if channel == 3 {
        i32::from(pixel[3]) * 255
    } else {
        i32::from(pixel[channel]) * i32::from(pixel[3])
    }
}

fn composite_over_checker(pixel: [u8; 4], x: u32, y: u32) -> image::Rgba<u8> {
    let checker: u8 = if (x / 8 + y / 8).is_multiple_of(2) {
        224
    } else {
        192
    };
    let alpha = u16::from(pixel[3]);
    let channel = |value: u8| {
        ((u16::from(value) * alpha + u16::from(checker) * (255 - alpha) + 127) / 255) as u8
    };
    image::Rgba([channel(pixel[0]), channel(pixel[1]), channel(pixel[2]), 255])
}

fn blend_red(context: image::Rgba<u8>, strength: f64) -> image::Rgba<u8> {
    let strength = strength.clamp(0.0, 1.0);
    let blend =
        |channel: u8| (f64::from(channel) * (1.0 - strength) + 255.0 * strength).round() as u8;
    image::Rgba([
        blend(context[0]),
        (f64::from(context[1]) * (1.0 - strength)).round() as u8,
        (f64::from(context[2]) * (1.0 - strength)).round() as u8,
        255,
    ])
}

fn mean(sum: f64, total_channels: u64) -> f64 {
    if total_channels == 0 {
        0.0
    } else {
        sum / total_channels as f64
    }
}

#[cfg(test)]
mod tests {
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
}
