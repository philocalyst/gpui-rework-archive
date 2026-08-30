use crate::shaders::interface::BufferData;
use gpui::{Background, Bounds, ScaledPixels};

#[derive(Clone, Debug)]
#[repr(C)]
pub(super) struct PathSprite {
    pub(super) bounds: Bounds<ScaledPixels>,
}

#[derive(Clone, Debug)]
#[repr(C)]
pub(super) struct PathRasterizationVertex {
    pub(super) xy_position: gpui::Point<ScaledPixels>,
    pub(super) curve_position: gpui::Point<f32>,
    pub(super) color: Background,
    pub(super) bounds: Bounds<ScaledPixels>,
}

unsafe impl BufferData for PathSprite {}
unsafe impl BufferData for PathRasterizationVertex {}

const _: () = {
    assert!(std::mem::size_of::<PathSprite>() == 16);
    assert!(std::mem::size_of::<PathRasterizationVertex>() == 104);
};
