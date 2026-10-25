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
    pub corner_radius: f32,
    pub clip_children: bool,
    pub resource: &'a Image,
    pub sampling: ImageSampling,
}
pub(crate) struct ImageDraft<'a> {
    pub node: u32,
    pub spec: ImageSpec<'a>,
}

impl ImageSpec<'_> {
    pub fn geometry(self) -> crate::property::GeometryStyle {
        crate::property::GeometryStyle {
            corner_radius: self.corner_radius,
            clip_children: self.clip_children,
        }
    }
    pub fn set_geometry(&mut self, geometry: crate::property::GeometryStyle) {
        self.corner_radius = geometry.corner_radius;
        self.clip_children = geometry.clip_children;
    }
}
