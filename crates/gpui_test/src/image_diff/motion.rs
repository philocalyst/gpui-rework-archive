//! Signed temporal differences between adjacent frame pairs.
use super::*;

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
