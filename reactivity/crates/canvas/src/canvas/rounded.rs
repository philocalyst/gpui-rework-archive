use super::{Mapping, validate_rect};
use crate::{Affine, Error, Point, Rect};

pub(super) fn validate_radius(radius: f32) -> Result<(), Error> {
    if radius.is_finite() && radius >= 0.0 {
        Ok(())
    } else {
        Err(Error::InvalidGeometry)
    }
}

/// Shared local predicate for paint samples and position-based input.
/// The enclosing rectangle is half-open; circular boundaries are closed.
pub(super) fn contains(rect: Rect, radius: f32, x: f64, y: f64) -> bool {
    let px = x - f64::from(rect.x);
    let py = y - f64::from(rect.y);
    let width = f64::from(rect.width);
    let height = f64::from(rect.height);
    if !(x >= f64::from(rect.x)
        && y >= f64::from(rect.y)
        && x < f64::from(rect.x) + width
        && y < f64::from(rect.y) + height)
    {
        return false;
    }
    let radius = f64::from(radius).min(width * 0.5).min(height * 0.5);
    // Distances from the inner rectangle avoid subtracting a large center
    // before a small corner radius. All admitted operands and squares fit f64.
    let dx = (radius - px).max(px - (width - radius)).max(0.0);
    let dy = (radius - py).max(py - (height - radius)).max(0.0);
    dx * dx + dy * dy <= radius * radius
}

/// Test a point against the same analytic local shape used by Canvas paint.
///
/// Radius is finite and nonnegative, then clamped to half each local extent.
/// The transform and rectangle obey the ordinary Canvas geometry admission
/// limits. This tests the shape itself, without a canvas clip or descendants.
pub fn rounded_rect_contains(
    rect: Rect,
    radius: f32,
    transform: Affine,
    point: Point,
) -> Result<bool, Error> {
    validate_radius(radius)?;
    validate_rect(rect)?;
    let mapping = Mapping::new(transform)?;
    let (x, y) = mapping.local(f64::from(point.x), f64::from(point.y));
    Ok(contains(rect, radius, x, y))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn closed_circle_and_half_open_box() {
        let rect = Rect::new(0.0, 0.0, 10.0, 10.0);
        // Exact 3-4-5 boundary in the upper-left corner.
        assert!(contains(rect, 5.0, 2.0, 1.0));
        assert!(!contains(
            rect,
            5.0,
            2.0,
            f64::from(f32::from_bits(1.0_f32.to_bits() - 1))
        ));
        assert!(contains(rect, 5.0, 0.0, 5.0));
        assert!(!contains(rect, 5.0, 10.0, 5.0));
        assert!(!contains(rect, 5.0, f64::NAN, 5.0));
        assert!(!contains(rect, 5.0, 5.0, f64::INFINITY));
    }
}

#[cfg(test)]
mod storage {
    use super::super::*;
    #[test]
    fn rounded_sources_keep_retained_strides_without_image_extension_allocations() {
        eprintln!(
            "rounded_canvas,Canvas={},DisplayList={},Inline={},Placement={},Common={},BorrowedSource={},PreparedSource={},PreparedDraw={},ImageResources={}",
            size_of::<Canvas>(),
            size_of::<DisplayList>(),
            size_of::<InlineDraw>(),
            size_of::<Placement>(),
            size_of::<Common>(),
            size_of::<BorrowedSource<'_>>(),
            size_of::<PreparedSource<'_>>(),
            size_of::<PreparedDraw<'_>>(),
            size_of::<ImageResources>()
        );
        let rect = Rect::new(0.0, 0.0, 32.0, 32.0);
        let mut plain = Canvas::recording(32, 32, ColorConfig::default()).unwrap();
        let mut rounded = Canvas::recording(32, 32, ColorConfig::default()).unwrap();
        let p = allocation_counter::measure(|| {
            plain
                .fill_rect(rect, Affine::IDENTITY, rect, Color::BLACK)
                .unwrap()
        });
        let r = allocation_counter::measure(|| {
            rounded
                .fill_rounded_rect(rect, 8.0, Affine::IDENTITY, rect, Color::BLACK)
                .unwrap()
        });
        assert_eq!(
            (p.count_total, p.bytes_total),
            (r.count_total, r.bytes_total)
        );
        assert_eq!(
            plain.prepared_scene().storage().lane_bytes(),
            rounded.prepared_scene().storage().lane_bytes()
        );
        eprintln!(
            "rounded_command_alloc,plain={},{};rounded={},{}",
            p.count_total, p.bytes_total, r.count_total, r.bytes_total
        );
        let image = Image::rgba8(
            1,
            1,
            crate::ImageProfile::Srgb,
            crate::AlphaMode::Straight,
            vec![0, 0, 0, 255].into_boxed_slice(),
        )
        .unwrap();
        plain
            .draw_image(&image, rect, Affine::IDENTITY, rect, ImageSampling::Linear)
            .unwrap();
        let before = plain.prepared_scene().storage();
        let r = allocation_counter::measure(|| {
            plain
                .draw_image_with(
                    &image,
                    rect,
                    Affine::IDENTITY,
                    rect,
                    crate::ImageOptions {
                        sampling: ImageSampling::Linear,
                        corner_radius: 8.0,
                    },
                )
                .unwrap()
        });
        let after = plain.prepared_scene().storage();
        assert_eq!(after.resource_entries, 1);
        assert_eq!(after.resource_header_bytes, before.resource_header_bytes);
        assert_eq!(after.resource_handles_bytes, before.resource_handles_bytes);
        assert_eq!((r.count_total, r.bytes_total), (0, 0));
        eprintln!(
            "rounded_image_existing_resource,allocations={},bytes={},header={},handles={}",
            r.count_total, r.bytes_total, after.resource_header_bytes, after.resource_handles_bytes
        );
        for radius in [1.0, 2.0, 3.0, 4.0] {
            plain
                .draw_image_with(
                    &image,
                    rect,
                    Affine::IDENTITY,
                    rect,
                    crate::ImageOptions {
                        sampling: ImageSampling::Nearest,
                        corner_radius: radius,
                    },
                )
                .unwrap();
        }
        assert_eq!(plain.prepared_scene().images().count(), 1);
        plain.clear(Color::WHITE);
        assert_eq!(plain.prepared_scene().storage().resource_header_bytes, 0);
    }
}
