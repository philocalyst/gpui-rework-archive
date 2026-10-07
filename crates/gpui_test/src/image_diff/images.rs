//! Exact and magnitude differences between still images.
use super::*;

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
