use crate::shaders::{
    blur::BlurUniforms,
    common::{
        BlurCompositeClip as ShaderBlurCompositeClip, Bounds as ShaderBounds,
        Corners as ShaderCorners, DownsampleMode,
    },
};
use gpui::{Bounds, Corners, FilterRenderTarget, RenderCommand, ScaledPixels, Scene};
use wgsl_rs::std::vec2f;

impl BlurUniforms {
    pub(super) fn copy() -> Self {
        empty_uniforms(DownsampleMode::Copy)
    }

    pub(super) fn downsample() -> Self {
        empty_uniforms(DownsampleMode::HalfResolution)
    }

    pub(super) fn gaussian(
        axis: BlurAxis,
        texture_size: [f32; 2],
        kernel: BlurKernel,
    ) -> Self {
        let direction = match axis {
            BlurAxis::Horizontal => vec2f(1.0 / texture_size[0], 0.0),
            BlurAxis::Vertical => vec2f(0.0, 1.0 / texture_size[1]),
        };
        Self {
            direction,
            standard_deviation: kernel.standard_deviation,
            sample_count: kernel.sample_count,
            sample_step: kernel.sample_step,
            ..empty_uniforms(DownsampleMode::Copy)
        }
    }

    pub(super) fn composite(
        bounds: Bounds<ScaledPixels>,
        content_mask: Bounds<ScaledPixels>,
        corner_radii: Corners<ScaledPixels>,
        opacity: f32,
        clip: FilterCompositeClip,
    ) -> Self {
        Self {
            bounds: bounds.into(),
            content_mask: content_mask.into(),
            corner_radii: corner_radii.into(),
            opacity,
            composite_clip: match clip {
                FilterCompositeClip::RoundedBounds => ShaderBlurCompositeClip::RoundedBounds,
                FilterCompositeClip::ContentShape => ShaderBlurCompositeClip::None,
            },
            ..empty_uniforms(DownsampleMode::Copy)
        }
    }
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
    }
}

#[derive(Clone, Copy)]
pub(super) enum BlurAxis {
    Horizontal,
    Vertical,
}

#[derive(Clone, Copy)]
pub(super) enum FilterCompositeClip {
    RoundedBounds,
    ContentShape,
}

#[derive(Clone, Copy)]
pub(super) struct FilterCompositeParameters {
    pub(super) bounds: Bounds<ScaledPixels>,
    pub(super) content_mask: Bounds<ScaledPixels>,
    pub(super) corner_radii: Corners<ScaledPixels>,
    pub(super) blur_radius: f32,
    pub(super) opacity: f32,
    pub(super) clip: FilterCompositeClip,
}

#[derive(Clone, Copy)]
pub(super) struct ScissorRectangle {
    pub(super) x: u32,
    pub(super) y: u32,
    pub(super) width: u32,
    pub(super) height: u32,
}

impl ScissorRectangle {
    pub(super) fn for_blurred_bounds(
        bounds: Bounds<ScaledPixels>,
        dilation: f32,
        full_width: u32,
        full_height: u32,
    ) -> Self {
        let downsampled_width = (full_width / BLUR_DOWNSAMPLE_FACTOR).max(1);
        let downsampled_height = (full_height / BLUR_DOWNSAMPLE_FACTOR).max(1);
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

    pub(super) fn is_empty(self) -> bool {
        self.width == 0 || self.height == 0
    }
}

#[derive(Clone, Copy)]
enum EdgeRounding {
    OutwardMinimum,
    OutwardMaximum,
}

fn downsampled_coordinate(value: f32, maximum: u32, rounding: EdgeRounding) -> u32 {
    let downsampled = value / BLUR_DOWNSAMPLE_FACTOR as f32;
    let rounded = match rounding {
        EdgeRounding::OutwardMinimum => downsampled.floor(),
        EdgeRounding::OutwardMaximum => downsampled.ceil(),
    };
    (rounded.max(0.0) as u32).min(maximum)
}

#[derive(Clone, Copy)]
pub(super) struct BlurKernel {
    pub(super) standard_deviation: f32,
    pub(super) sample_count: u32,
    pub(super) sample_step: f32,
}

pub(super) const BLUR_DOWNSAMPLE_FACTOR: u32 = 2;
const BLUR_RADIUS_TO_STANDARD_DEVIATION: f32 = 0.5;
pub(super) const GAUSSIAN_CUTOFF_STANDARD_DEVIATIONS: f32 = 3.0;
pub(super) const MAX_GAUSSIAN_SAMPLES_PER_SIDE: u32 = 32;
const FILTER_UNIFORMS_PER_COMPOSITE: u64 = 4;

impl BlurKernel {
    pub(super) fn for_radius(blur_radius: f32) -> Option<Self> {
        let standard_deviation = (blur_radius * BLUR_RADIUS_TO_STANDARD_DEVIATION).max(0.0);
        if standard_deviation <= 0.0 {
            return None;
        }

        let ideal_sample_count =
            (GAUSSIAN_CUTOFF_STANDARD_DEVIATIONS * standard_deviation).ceil();
        let sample_count =
            (ideal_sample_count as u32).clamp(1, MAX_GAUSSIAN_SAMPLES_PER_SIDE);
        Some(Self {
            standard_deviation,
            sample_count,
            sample_step: (ideal_sample_count / sample_count as f32).max(1.0),
        })
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub(super) struct FrameUniformRequirements {
    pub(super) filter_count: u64,
    pub(super) surface_count: u64,
}

impl FrameUniformRequirements {
    pub(super) fn for_scene(scene: &Scene) -> Self {
        let isolated_filter_count = if scene.filter_boundaries.is_empty() {
            0
        } else {
            scene
                .render_commands()
                .filter(|command| {
                    matches!(
                        command,
                        RenderCommand::EndFilter {
                            target: FilterRenderTarget::Isolated(_),
                            ..
                        }
                    )
                })
                .count() as u64
        };
        let composite_count = scene.backdrop_filters.len() as u64 + isolated_filter_count;
        let requires_offscreen_rendering =
            !scene.backdrop_filters.is_empty() || isolated_filter_count > 0;
        Self {
            filter_count: composite_count
                .saturating_mul(FILTER_UNIFORMS_PER_COMPOSITE)
                .saturating_add(u64::from(requires_offscreen_rendering)),
            surface_count: scene.surfaces.len() as u64,
        }
    }
}

const _: () = assert!(std::mem::size_of::<BlurUniforms>() == 80);
