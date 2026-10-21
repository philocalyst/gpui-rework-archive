//! Borrowed image declarations; the runtime freezes distinct resource leases.
use crate::{El, Image, ImageSampling};

/// Draws immutable pixels, with intrinsic pixel dimensions when no size is
/// authored and flex layout leaves the image unconstrained. A single known
/// dimension preserves aspect; two dimensions stretch to the content rectangle.
/// Linear-premultiplied bilinear reconstruction is the default; decoding/I/O
/// remain caller work. Supply a semantic `.name(...)` for meaningful images.
pub fn image(resource: &Image) -> El<'_> {
    El::image(resource)
}

#[derive(Clone, Copy)]
pub(crate) struct ImageSpec<'a> {
    pub geometry: crate::property::GeometryStyle,
    pub resource: &'a Image,
    pub sampling: ImageSampling,
}
pub(crate) struct ImageDraft<'a> {
    pub node: u32,
    pub spec: ImageSpec<'a>,
}
