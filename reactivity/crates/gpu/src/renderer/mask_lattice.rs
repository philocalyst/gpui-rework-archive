//! Address-equivalent lowering on the fixed 4x4 lattice; canonical geometry
//! stays in the scene for admission, clipping, binning and publication.
use gpui_canvas::{PreparedDraw, Rect};

pub(super) fn lowered_mask_rect(draw: &PreparedDraw<'_>, error: [f32; 2]) -> Option<Rect> {
    let mask = draw.source.mask()?;
    if draw.inverse[..4] != [1.0, 0.0, 0.0, 1.0]
        || draw.local_rect.width as f64 != mask.width as f64
        || draw.local_rect.height as f64 != mask.height as f64
    {
        return None;
    }
    let mut rect = draw.local_rect;
    for ((origin, translation, extent), error) in [
        (&mut rect.x, draw.inverse[4], rect.width),
        (&mut rect.y, draw.inverse[5], rect.height),
    ]
    .into_iter()
    .zip(error)
    {
        // Scaling by 2^32 leaves integral operands below 2^49. Including the
        // viewport point and subtracting the other operand stays below 2^51:
        // every canonical f64 map/subtraction is exact, including sample ties.
        if [f64::from(*origin), translation]
            .into_iter()
            .any(|v| !v.is_finite() || v.abs() > 131_072.0 || (v * 4_294_967_296.0).fract() != 0.0)
        {
            return None;
        }
        let device_origin = f64::from(*origin) - translation;
        // Also preserve the existing GPU sampler, whose two-float correction
        // can differ from the scalar oracle immediately beside a texel tie.
        // CSR visits extend at most one 16px tile beyond these unit bounds.
        // Stay beyond both its position error and normalization/correction
        // envelope, with fourfold headroom; ambiguous phases keep that path.
        let phase = (device_origin - 0.125) * 4.0;
        let distance = (phase - phase.round()).abs() * 0.25;
        let margin = 4.0 * (f64::from(error) + (f64::from(extent) + 32.0) * 3.8146973e-6);
        if distance <= margin {
            return None;
        }
        // At odd-eighth sample points this quarter boundary gives the same
        // floor(point-origin). Integer extents preserve the half-open edges.
        // The bounded quarter origin and their f32 differences are exact.
        *origin = (((device_origin - 0.125) * 4.0).ceil() * 0.25) as f32;
    }
    Some(rect)
}

#[cfg(test)]
#[path = "mask_lattice_tests.rs"]
mod tests;
