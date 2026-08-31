use crate::shaders::interface as shader_interface;
use crate::shaders::{
    blur::BlurUniforms,
    common::{
        BlurCompositeClip as ShaderBlurCompositeClip, Bounds as ShaderBounds,
        Corners as ShaderCorners, DownsampleMode,
    },
};
use gpui::{BackdropFilter, Bounds, Corners, ScaledPixels};
use wgsl_rs::std::vec2f;

use super::{WgpuRenderer, begin_color_render_pass, pipelines};

impl BlurUniforms {
    pub(super) fn copy() -> Self {
        empty_uniforms(DownsampleMode::Copy)
    }

    pub(super) fn downsample() -> Self {
        empty_uniforms(DownsampleMode::HalfResolution)
    }

    pub(super) fn gaussian(axis: BlurAxis, texture_size: [f32; 2], kernel: BlurKernel) -> Self {
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
pub(super) const FILTER_UNIFORMS_PER_COMPOSITE: u64 = 4;

impl BlurKernel {
    pub(super) fn for_radius(blur_radius: f32) -> Option<Self> {
        let standard_deviation = (blur_radius * BLUR_RADIUS_TO_STANDARD_DEVIATION).max(0.0);
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

#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub(super) struct FrameUniformRequirements {
    pub(super) filter_count: u64,
    pub(super) surface_count: u64,
}

const _: () = assert!(std::mem::size_of::<BlurUniforms>() == 80);

impl WgpuRenderer {
    fn make_blur_bind_group(
        &self,
        uniforms: BlurUniforms,
        source: &wgpu::TextureView,
    ) -> (wgpu::BindGroup, u32) {
        let resources = self.resources();
        let uniform_offset = resources.filter_uniforms.write(&uniforms);
        (resources.blur_bind_group(source), uniform_offset)
    }

    fn run_blur_pass(
        &self,
        encoder: &mut wgpu::CommandEncoder,
        label: &str,
        pipeline: &pipelines::WgpuRenderPipeline,
        target: &wgpu::TextureView,
        source: &wgpu::TextureView,
        uniforms: BlurUniforms,
        scissor: ScissorRectangle,
    ) {
        let (bind_group, uniform_offset) = self.make_blur_bind_group(uniforms, source);
        let resources = self.resources();
        let mut pass = begin_color_render_pass(
            encoder,
            label,
            target,
            wgpu::LoadOp::Clear(wgpu::Color::TRANSPARENT),
        );
        pass.set_pipeline(pipeline);
        pass.set_bind_group(
            shader_interface::GLOBAL_BIND_GROUP,
            &resources.globals_bind_group,
            &[],
        );
        pass.set_bind_group(
            shader_interface::DATA_BIND_GROUP,
            &bind_group,
            &[uniform_offset],
        );
        pass.set_scissor_rect(scissor.x, scissor.y, scissor.width, scissor.height);
        pass.draw(0..pipeline.fixed_vertex_count(), 0..1);
    }

    pub(super) fn blur_and_composite(
        &self,
        encoder: &mut wgpu::CommandEncoder,
        source: &wgpu::TextureView,
        target: &wgpu::TextureView,
        parameters: FilterCompositeParameters,
    ) {
        let Some(kernel) = BlurKernel::for_radius(parameters.blur_radius) else {
            return;
        };
        let full_width = self.target.width();
        let full_height = self.target.height();
        let blur_size = [
            (full_width / BLUR_DOWNSAMPLE_FACTOR).max(1) as f32,
            (full_height / BLUR_DOWNSAMPLE_FACTOR).max(1) as f32,
        ];
        let dilation = GAUSSIAN_CUTOFF_STANDARD_DEVIATIONS * parameters.blur_radius;
        let scissor = ScissorRectangle::for_blurred_bounds(
            parameters.bounds,
            dilation,
            full_width,
            full_height,
        );
        if scissor.is_empty() {
            return;
        }

        let (horizontal_target, vertical_target) = {
            let resources = self.resources();
            match (
                resources.blur_ping_view.as_ref(),
                resources.blur_pong_view.as_ref(),
            ) {
                (Some(horizontal), Some(vertical)) => (horizontal.clone(), vertical.clone()),
                _ => return,
            }
        };

        self.run_blur_pass(
            encoder,
            "blur_downsample",
            &self.resources().pipelines.blur_downsample,
            &horizontal_target,
            source,
            BlurUniforms::downsample(),
            scissor,
        );
        self.run_blur_pass(
            encoder,
            "blur_horizontal",
            &self.resources().pipelines.blur,
            &vertical_target,
            &horizontal_target,
            BlurUniforms::gaussian(BlurAxis::Horizontal, blur_size, kernel),
            scissor,
        );
        self.run_blur_pass(
            encoder,
            "blur_vertical",
            &self.resources().pipelines.blur,
            &horizontal_target,
            &vertical_target,
            BlurUniforms::gaussian(BlurAxis::Vertical, blur_size, kernel),
            scissor,
        );

        let clips_to_bounds = matches!(parameters.clip, FilterCompositeClip::RoundedBounds);
        let composite_bounds = if clips_to_bounds {
            parameters.bounds
        } else {
            parameters.bounds.dilate(ScaledPixels(dilation))
        };
        let uniforms = BlurUniforms::composite(
            composite_bounds,
            parameters.content_mask,
            parameters.corner_radii,
            parameters.opacity,
            parameters.clip,
        );
        let (bind_group, uniform_offset) = self.make_blur_bind_group(uniforms, &horizontal_target);
        let resources = self.resources();
        let mut pass =
            begin_color_render_pass(encoder, "blur_composite", target, wgpu::LoadOp::Load);
        pass.set_pipeline(&resources.pipelines.blur_composite);
        pass.set_bind_group(
            shader_interface::GLOBAL_BIND_GROUP,
            &resources.globals_bind_group,
            &[],
        );
        pass.set_bind_group(
            shader_interface::DATA_BIND_GROUP,
            &bind_group,
            &[uniform_offset],
        );
        pass.draw(
            0..resources.pipelines.blur_composite.fixed_vertex_count(),
            0..1,
        );
    }

    pub(super) fn draw_backdrop_filter(
        &self,
        encoder: &mut wgpu::CommandEncoder,
        filter: &BackdropFilter,
        scene_color_view: &wgpu::TextureView,
    ) {
        self.blur_and_composite(
            encoder,
            scene_color_view,
            scene_color_view,
            FilterCompositeParameters {
                bounds: filter.bounds,
                content_mask: filter.content_mask.bounds,
                corner_radii: filter.corner_radii,
                blur_radius: filter.max_blur_radius(),
                opacity: filter.opacity,
                clip: FilterCompositeClip::RoundedBounds,
            },
        );
    }

    pub(super) fn blit_to_frame(
        &self,
        encoder: &mut wgpu::CommandEncoder,
        source: &wgpu::TextureView,
        frame_view: &wgpu::TextureView,
    ) {
        let (bind_group, uniform_offset) = self.make_blur_bind_group(BlurUniforms::copy(), source);
        let resources = self.resources();
        let mut pass = begin_color_render_pass(
            encoder,
            "scene_blit",
            frame_view,
            wgpu::LoadOp::Clear(wgpu::Color::TRANSPARENT),
        );
        pass.set_pipeline(&resources.pipelines.blur_downsample);
        pass.set_bind_group(
            shader_interface::GLOBAL_BIND_GROUP,
            &resources.globals_bind_group,
            &[],
        );
        pass.set_bind_group(
            shader_interface::DATA_BIND_GROUP,
            &bind_group,
            &[uniform_offset],
        );
        pass.draw(
            0..resources.pipelines.blur_downsample.fixed_vertex_count(),
            0..1,
        );
    }
}
