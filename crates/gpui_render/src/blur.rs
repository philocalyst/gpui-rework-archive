//! Shared CPU-side contracts for downsampled Gaussian blur passes.
//!
//! Blur dimensions are texture dimensions in physical pixels. The downsample
//! pass uses [`DOWNSAMPLE_FACTOR`], while scene bounds and radii remain
//! [`gpui::ScaledPixels`]. The constructors here only prepare uniform data;
//! they do not allocate textures or submit work.

pub use crate::shaders::{
    blur::BlurUniforms,
    common::{
        BlurCompositeClip as ShaderBlurCompositeClip, Bounds as ShaderBounds,
        Corners as ShaderCorners, DownsampleMode,
    },
};
use gpui::{Bounds, Corners, ScaledPixels};
use wgsl_rs::std::vec2f;

/// The source-to-intermediate texture dimension ratio used by blur passes.
pub const DOWNSAMPLE_FACTOR: u32 = 2;

/// Texture dimension for a downsampled blur pass; allocations must agree.
pub fn downsampled_dimension(dimension: u32) -> u32 {
    dimension.div_ceil(DOWNSAMPLE_FACTOR).max(1)
}
const RADIUS_TO_STANDARD_DEVIATION: f32 = 0.5;
/// Number of standard deviations retained by the Gaussian kernel.
pub const GAUSSIAN_CUTOFF_STANDARD_DEVIATIONS: f32 = 3.0;
/// Upper bound on samples taken on one side of a Gaussian blur.
pub const MAX_GAUSSIAN_SAMPLES_PER_SIDE: u32 = 32;

/// Direction in which a blur kernel samples neighboring texels.
#[derive(Clone, Copy)]
pub enum BlurAxis {
    /// Samples vary along the x axis.
    Horizontal,
    /// Samples vary along the y axis.
    Vertical,
}

/// Shape used to clip a filtered composite.
#[derive(Clone, Copy)]
pub enum FilterCompositeClip {
    /// Clip to the rounded bounds supplied to the composite operation.
    RoundedBounds,
    /// Clip to the content mask supplied by the caller.
    ContentShape,
}

/// Inputs shared by a blur composite pass.
#[derive(Clone, Copy)]
pub struct FilterCompositeParameters {
    /// Scene-space bounds of the composited result.
    pub bounds: Bounds<ScaledPixels>,
    /// Scene-space content mask bounds.
    pub content_mask: Bounds<ScaledPixels>,
    /// Scene-space corner radii.
    pub corner_radii: Corners<ScaledPixels>,
    /// Corner smoothing factor used by the coverage shader.
    pub corner_smoothing: f32,
    /// Blur radius in scene pixels.
    pub blur_radius: f32,
    /// Opacity multiplied into the composited result.
    pub opacity: f32,
    /// Shape used to clip the composite.
    pub clip: FilterCompositeClip,
}

/// Bounded Gaussian-kernel parameters derived from a blur radius.
#[derive(Clone, Copy)]
pub struct BlurKernel {
    /// Standard deviation in scene pixels.
    pub standard_deviation: f32,
    /// Samples taken on one side of the kernel.
    pub sample_count: u32,
    /// Distance between samples in standard-deviation units.
    pub sample_step: f32,
}

impl BlurKernel {
    /// Converts a logical blur radius into a bounded Gaussian kernel.
    ///
    /// Returns `None` for zero, negative, or non-finite radii. Large radii are
    /// represented by the maximum sample count and a larger sample step.
    pub fn for_radius(blur_radius: f32) -> Option<Self> {
        let standard_deviation = (blur_radius * RADIUS_TO_STANDARD_DEVIATION).max(0.0);
        if standard_deviation <= 0.0 {
            return None;
        }

        let ideal_sample_count = (GAUSSIAN_CUTOFF_STANDARD_DEVIATIONS * standard_deviation).ceil();
        let sample_count = (ideal_sample_count as u32).clamp(1, MAX_GAUSSIAN_SAMPLES_PER_SIDE);
        Some(Self {
            standard_deviation,
            sample_count,
            sample_step: (ideal_sample_count / sample_count as f32).max(1.0),
        })
    }
}

impl BlurUniforms {
    pub fn copy(size: [f32; 2]) -> Self {
        with_texture_sizes(empty_uniforms(DownsampleMode::Copy), size, size)
    }

    pub fn downsample(source_size: [f32; 2], target_size: [f32; 2]) -> Self {
        with_texture_sizes(
            empty_uniforms(DownsampleMode::HalfResolution),
            source_size,
            target_size,
        )
    }

    pub fn gaussian(axis: BlurAxis, texture_size: [f32; 2], kernel: BlurKernel) -> Self {
        let direction = match axis {
            BlurAxis::Horizontal => vec2f(1.0 / texture_size[0], 0.0),
            BlurAxis::Vertical => vec2f(0.0, 1.0 / texture_size[1]),
        };
        Self {
            direction,
            standard_deviation: kernel.standard_deviation,
            sample_count: kernel.sample_count,
            sample_step: kernel.sample_step,
            ..with_texture_sizes(
                empty_uniforms(DownsampleMode::Copy),
                texture_size,
                texture_size,
            )
        }
    }

    pub fn composite(
        bounds: Bounds<ScaledPixels>,
        content_mask: Bounds<ScaledPixels>,
        corner_radii: Corners<ScaledPixels>,
        corner_smoothing: f32,
        opacity: f32,
        clip: FilterCompositeClip,
        source_size: [f32; 2],
        target_size: [f32; 2],
    ) -> Self {
        Self {
            bounds: bounds.into(),
            content_mask: content_mask.into(),
            corner_radii: corner_radii.into(),
            corner_smoothing,
            opacity,
            composite_clip: match clip {
                FilterCompositeClip::RoundedBounds => ShaderBlurCompositeClip::RoundedBounds,
                FilterCompositeClip::ContentShape => ShaderBlurCompositeClip::None,
            },
            ..with_texture_sizes(
                empty_uniforms(DownsampleMode::Copy),
                source_size,
                target_size,
            )
        }
    }
}

/// A physical-pixel scissor rectangle for an intermediate blur texture.
#[derive(Clone, Copy)]
pub struct ScissorRectangle {
    /// Left coordinate in downsampled texture pixels.
    pub x: u32,
    /// Top coordinate in downsampled texture pixels.
    pub y: u32,
    /// Width in downsampled texture pixels.
    pub width: u32,
    /// Height in downsampled texture pixels.
    pub height: u32,
}

impl ScissorRectangle {
    /// Computes an outward-rounded scissor around blurred scene bounds.
    ///
    /// `full_width` and `full_height` are full-resolution texture dimensions;
    /// `dilation` is a scene-pixel radius added on every side.
    pub fn for_blurred_bounds(
        bounds: Bounds<ScaledPixels>,
        dilation: f32,
        full_width: u32,
        full_height: u32,
    ) -> Self {
        let downsampled_width = full_width.div_ceil(DOWNSAMPLE_FACTOR).max(1);
        let downsampled_height = full_height.div_ceil(DOWNSAMPLE_FACTOR).max(1);
        let minimum_x = downsampled_coordinate(
            bounds.origin.x.0 - dilation,
            downsampled_width,
            EdgeRounding::OutwardMinimum,
        );
        let minimum_y = downsampled_coordinate(
            bounds.origin.y.0 - dilation,
            downsampled_height,
            EdgeRounding::OutwardMinimum,
        );
        let maximum_x = downsampled_coordinate(
            bounds.origin.x.0 + bounds.size.width.0 + dilation,
            downsampled_width,
            EdgeRounding::OutwardMaximum,
        )
        .max(minimum_x);
        let maximum_y = downsampled_coordinate(
            bounds.origin.y.0 + bounds.size.height.0 + dilation,
            downsampled_height,
            EdgeRounding::OutwardMaximum,
        )
        .max(minimum_y);
        Self {
            x: minimum_x,
            y: minimum_y,
            width: maximum_x - minimum_x,
            height: maximum_y - minimum_y,
        }
    }

    /// Returns whether either dimension is zero.
    pub fn is_empty(self) -> bool {
        self.width == 0 || self.height == 0
    }
}

#[derive(Clone, Copy)]
enum EdgeRounding {
    OutwardMinimum,
    OutwardMaximum,
}

fn downsampled_coordinate(value: f32, maximum: u32, rounding: EdgeRounding) -> u32 {
    let downsampled = value / DOWNSAMPLE_FACTOR as f32;
    let rounded = match rounding {
        EdgeRounding::OutwardMinimum => downsampled.floor(),
        EdgeRounding::OutwardMaximum => downsampled.ceil(),
    };
    (rounded.max(0.0) as u32).min(maximum)
}

fn with_texture_sizes(
    mut uniforms: BlurUniforms,
    source_size: [f32; 2],
    target_size: [f32; 2],
) -> BlurUniforms {
    uniforms.source_size = vec2f(source_size[0], source_size[1]);
    uniforms.target_size = vec2f(target_size[0], target_size[1]);
    uniforms
}

fn empty_uniforms(downsample_mode: DownsampleMode) -> BlurUniforms {
    let bounds = ShaderBounds {
        origin: vec2f(0.0, 0.0),
        size: vec2f(0.0, 0.0),
    };
    BlurUniforms {
        bounds,
        content_mask: bounds,
        corner_radii: ShaderCorners {
            top_left: 0.0,
            top_right: 0.0,
            bottom_right: 0.0,
            bottom_left: 0.0,
        },
        direction: vec2f(0.0, 0.0),
        standard_deviation: 0.0,
        opacity: 0.0,
        sample_count: 0,
        sample_step: 0.0,
        composite_clip: ShaderBlurCompositeClip::None,
        downsample_mode,
        source_size: vec2f(1.0, 1.0),
        target_size: vec2f(1.0, 1.0),
        corner_smoothing: 0.0,
        padding0: 0,
        padding1: 0,
        padding2: 0,
    }
}

#[cfg(test)]
mod tests {
    use super::downsampled_dimension;

    #[test]
    fn downsampled_dimensions_cover_odd_edges() {
        assert_eq!(downsampled_dimension(0), 1);
        assert_eq!(downsampled_dimension(1), 1);
        assert_eq!(downsampled_dimension(2), 1);
        assert_eq!(downsampled_dimension(3), 2);
        assert_eq!(downsampled_dimension(33), 17);
    }
}
