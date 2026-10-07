//! Text coverage settings shared by software and GPU renderers.

use crate::shaders::common::{FontRasterizationUniforms, ShaderBool};
use gpui::get_gamma_correction_ratios;

/// Physical order of an LCD's color components.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum SubpixelOrder {
    /// Red, green, then blue.
    RedGreenBlue,
    /// Blue, green, then red.
    BlueGreenRed,
}

/// Validated text coverage settings, independent of a renderer or display server.
#[derive(Clone, Copy, Debug)]
pub struct FontRasterizationSettings {
    gamma_ratios: [f32; 4],
    grayscale_enhanced_contrast: f32,
    subpixel_enhanced_contrast: f32,
    subpixel_order: SubpixelOrder,
}

impl Default for FontRasterizationSettings {
    fn default() -> Self {
        Self::uncorrected()
    }
}

impl FontRasterizationSettings {
    /// Creates platform text settings. Non-finite inputs fall back to neutral correction.
    pub fn new(
        gamma: f32,
        grayscale_enhanced_contrast: f32,
        subpixel_enhanced_contrast: f32,
        subpixel_order: SubpixelOrder,
    ) -> Self {
        let gamma = if gamma.is_finite() {
            gamma.clamp(1.0, 2.2)
        } else {
            1.0
        };
        Self {
            gamma_ratios: get_gamma_correction_ratios(gamma),
            grayscale_enhanced_contrast: finite_contrast(grayscale_enhanced_contrast),
            subpixel_enhanced_contrast: finite_contrast(subpixel_enhanced_contrast),
            subpixel_order,
        }
    }

    /// Disables contrast and gamma correction for portable default captures.
    pub fn uncorrected() -> Self {
        Self::new(1.0, 0.0, 0.0, SubpixelOrder::RedGreenBlue)
    }

    /// Selects a physical LCD component order.
    pub fn with_subpixel_order(mut self, order: SubpixelOrder) -> Self {
        self.subpixel_order = order;
        self
    }

    /// Returns the selected LCD component order.
    pub fn subpixel_order(self) -> SubpixelOrder {
        self.subpixel_order
    }

    /// Produces the same shader inputs for either rendering backend.
    pub fn uniforms(self) -> FontRasterizationUniforms {
        let [x, y, z, w] = self.gamma_ratios;
        FontRasterizationUniforms {
            gamma_ratios: wgsl_rs::std::vec4f(x, y, z, w),
            grayscale_enhanced_contrast: self.grayscale_enhanced_contrast,
            subpixel_enhanced_contrast: self.subpixel_enhanced_contrast,
            uses_blue_green_red_subpixel_order: ShaderBool::from(
                self.subpixel_order == SubpixelOrder::BlueGreenRed,
            ),
            padding: 0,
        }
    }
}

fn finite_contrast(value: f32) -> f32 {
    if value.is_finite() {
        value.max(0.0)
    } else {
        0.0
    }
}
