use super::super::common;

pub(crate) fn hsla(color: gpui::Hsla) -> [f32; 4] {
    use wgsl_rs::std::*;
    let shader_color = common::Hsla {
        h: color.hue.into_degrees().rem_euclid(360.0) / 360.0,
        s: color.saturation,
        l: color.lightness,
        a: color.alpha,
    };
    let result = common::hsla_to_rgba(shader_color);
    [result.x, result.y, result.z, result.w]
}

pub(crate) fn content_alpha(
    mask: gpui::ContentMask<gpui::ScaledPixels>,
    point: wgsl_rs::std::Vec2f,
) -> f32 {
    common::ContentMask::alpha(mask.into(), point)
}

pub(crate) fn is_clipped(
    mask: gpui::ContentMask<gpui::ScaledPixels>,
    point: wgsl_rs::std::Vec2f,
) -> bool {
    let bounds: common::Bounds = mask.bounds.into();
    point.x < bounds.origin.x
        || point.x >= bounds.origin.x + bounds.size.x
        || point.y < bounds.origin.y
        || point.y >= bounds.origin.y + bounds.size.y
}

fn shader_hsla(color: gpui::Hsla) -> common::Hsla {
    common::Hsla {
        h: color.hue.into_degrees().rem_euclid(360.0) / 360.0,
        s: color.saturation,
        l: color.lightness,
        a: color.alpha,
    }
}

fn shader_background(background: gpui::Background) -> common::Background {
    use gpui::{BackgroundKind, ColorSpace};
    let mut result = common::Background {
        tag: common::BackgroundTag::Solid,
        color_space: common::ColorSpace::Srgb,
        solid: shader_hsla(gpui::Hsla::new(0.0, 0.0, 0.0, 0.0)),
        gradient_angle_or_pattern_height: 0.0,
        colors: [common::LinearColorStop {
            color: shader_hsla(gpui::Hsla::new(0.0, 0.0, 0.0, 0.0)),
            percentage: 0.0,
        }; 2],
        padding: 0,
    };
    result.color_space = match background.interpolation_space() {
        ColorSpace::Srgb => common::ColorSpace::Srgb,
        ColorSpace::Oklab => common::ColorSpace::Oklab,
    };
    match background.kind() {
        BackgroundKind::Solid(color) => {
            result.tag = common::BackgroundTag::Solid;
            result.solid = shader_hsla(color);
        }
        BackgroundKind::LinearGradient { angle, stops } => {
            result.tag = common::BackgroundTag::LinearGradient;
            result.gradient_angle_or_pattern_height = angle;
            result.colors = stops.map(|stop| common::LinearColorStop {
                color: shader_hsla(stop.color.into()),
                percentage: stop.percentage,
            });
        }
        BackgroundKind::PatternSlash {
            color,
            width,
            interval,
        } => {
            result.tag = common::BackgroundTag::PatternSlash;
            result.solid = shader_hsla(color);
            result.gradient_angle_or_pattern_height =
                (width * 255.0).floor() * 65535.0 + (interval * 255.0).floor();
        }
        BackgroundKind::Checkerboard { color, size } => {
            result.tag = common::BackgroundTag::Checkerboard;
            result.solid = shader_hsla(color);
            result.gradient_angle_or_pattern_height = size;
        }
    }
    result
}

pub(crate) fn background_color(
    background: gpui::Background,
    bounds: gpui::Bounds<gpui::ScaledPixels>,
    point: wgsl_rs::std::Vec2f,
) -> [f32; 4] {
    use wgsl_rs::std::*;
    let paint = common::Paint::new(shader_background(background), bounds.into());
    let color = common::paint_color(paint, point, common::prepare_paint(paint));
    [color.x, color.y, color.z, color.w]
}

/// Paint inputs prepared once per primitive, as the GPU vertex stage does.
pub(crate) struct PaintShader {
    paint: common::Paint,
    prepared: common::PreparedPaint,
}

impl PaintShader {
    pub(crate) fn new(background: gpui::Background, bounds: gpui::Bounds<gpui::ScaledPixels>) -> Self {
        Self::from_paint(common::Paint::new(shader_background(background), bounds.into()))
    }

    fn from_paint(paint: common::Paint) -> Self {
        Self { paint, prepared: common::prepare_paint(paint) }
    }

    pub(crate) fn sample(&self, point: wgsl_rs::std::Vec2f) -> [f32; 4] {
        let color = common::paint_color(self.paint, point, self.prepared);
        [color.x, color.y, color.z, color.w]
    }
}

pub(crate) struct QuadShader {
    quad: super::super::quad::Quad,
    fill: common::PreparedPaint,
    border: common::PreparedPaint,
    corners: Option<(super::super::corner_smoothing::PreparedCorners, wgsl_rs::std::Vec4f)>,
}

impl QuadShader {
    pub(crate) fn new(quad: &gpui::Quad, smoothed: bool) -> Self {
        let quad = super::super::quad::Quad {
            order: 0,
            border_style: match quad.border_style {
                gpui::BorderStyle::Solid => common::BorderStyle::Solid,
                gpui::BorderStyle::Dashed => common::BorderStyle::Dashed,
            },
            border_dashed_length: quad.border_dashed_length,
            border_dashed_gap: quad.border_dashed_gap,
            bounds: quad.bounds.into(),
            content_mask: quad.content_mask.into(),
            background: shader_background(quad.background),
            border_color: shader_background(quad.border_color),
            corner_radii: quad.corner_radii.into(),
            border_widths: quad.border_widths.into(),
            corner_smoothing: quad.corner_smoothing,
            padding: 0,
        };
        let prepare = |background| common::prepare_paint(common::Paint::new(background, quad.bounds));
        let corners = smoothed.then(|| {
            let prepared = super::super::corner_smoothing::prepare_corners(
                quad.bounds.size, quad.corner_radii, quad.corner_smoothing,
                quad.border_style == common::BorderStyle::Solid && common::Edges::is_zero(quad.border_widths),
            );
            (prepared, super::super::quad::smoothed_corner_lengths(quad, prepared))
        });
        Self { quad, fill: prepare(quad.background), border: prepare(quad.border_color), corners }
    }

    pub(crate) fn sample(&self, point: wgsl_rs::std::Vec2f) -> [f32; 4] {
        let color = match self.corners {
            Some((prepared, lengths)) => super::super::quad::shade_smoothed_quad(
                self.quad, point, self.fill, self.border, prepared, lengths, common::ShaderBool::Enabled,
            ),
            None => super::super::quad::shade_quad(
                self.quad, point, self.fill, self.border, common::ShaderBool::Enabled,
            ),
        };
        [color.x, color.y, color.z, color.w]
    }
}

pub(crate) fn wavy_underline_coverage(
    underline: &gpui::Underline,
    point: wgsl_rs::std::Vec2f,
) -> f32 {
    let shader = super::super::underline::Underline {
        order: 0,
        padding: 0,
        bounds: underline.bounds.into(),
        content_mask: underline.content_mask.into(),
        color: shader_hsla(underline.color.into()),
        thickness: underline.thickness.0,
        wavy: (underline.wavy == gpui::ShaderBool::Enabled).into(),
    };
    super::super::underline::wavy_underline_coverage(shader, point)
}

pub(crate) struct ShadowShader {
    shadow: super::super::shadow::Shadow,
    paint: PaintShader,
    corners: Option<(super::super::corner_smoothing::PreparedCorners, super::super::corner_smoothing::PreparedCorners)>,
}

impl ShadowShader {
    pub(crate) fn new(shadow: &gpui::Shadow, smoothed: bool) -> Self {
        let shadow = super::super::shadow::Shadow {
            order: 0,
            blur_radius: shadow.blur_radius.0,
            bounds: shadow.bounds.into(),
            corner_radii: shadow.corner_radii.into(),
            content_mask: shadow.content_mask.into(),
            color: shader_background(shadow.color),
            element_bounds: shadow.element_bounds.into(),
            element_corner_radii: shadow.element_corner_radii.into(),
            inset: (shadow.inset == gpui::ShaderBool::Enabled).into(),
            corner_smoothing: shadow.corner_smoothing,
        };
        let corners = smoothed.then(|| (
            super::super::corner_smoothing::prepare_corners(shadow.bounds.size, shadow.corner_radii, shadow.corner_smoothing, true),
            super::super::corner_smoothing::prepare_corners(shadow.element_bounds.size, shadow.element_corner_radii, shadow.corner_smoothing, true),
        ));
        Self { shadow, paint: PaintShader::from_paint(super::super::shadow::shadow_paint(shadow)), corners }
    }

    pub(crate) fn bounds(&self) -> common::Bounds {
        super::super::shadow::shadow_geometry(self.shadow)
    }

    pub(crate) fn sample(&self, point: wgsl_rs::std::Vec2f) -> [f32; 4] {
        let coverage = match self.corners {
            Some((outer, element)) => super::super::shadow::smoothed_shadow_coverage(self.shadow, point, outer, element),
            None => super::super::shadow::shadow_coverage(self.shadow, point),
        } * common::ContentMask::alpha(self.shadow.content_mask, point);
        let color = self.paint.sample(point);
        let alpha = color[3] * coverage;
        [color[0] * alpha, color[1] * alpha, color[2] * alpha, alpha]
    }
}

pub(crate) fn rounded_rect_coverage(
    bounds: gpui::Bounds<gpui::ScaledPixels>,
    radii: gpui::Corners<gpui::ScaledPixels>,
    point: wgsl_rs::std::Vec2f,
    smoothing: f32,
) -> f32 {
    if smoothing <= 0. {
        return common::antialiased_coverage(common::rounded_rectangle_signed_distance(
            point,
            bounds.into(),
            radii.into(),
        ));
    }
    let bounds: common::Bounds = bounds.into();
    let radii: common::Corners = radii.into();
    let prepared = super::super::corner_smoothing::prepare_corners(bounds.size, radii, smoothing, true);
    common::antialiased_coverage(super::super::corner_smoothing::prepared_corner_signed_distance(
        point, bounds, radii, smoothing, prepared,
    ))
}

pub(crate) fn sprite_corner_coverage(
    bounds: gpui::Bounds<gpui::ScaledPixels>,
    radii: gpui::Corners<gpui::ScaledPixels>,
    smoothing: f32,
    point: wgsl_rs::std::Vec2f,
    smoothed: bool,
) -> f32 {
    let sprite = super::super::polychrome_sprite::PolychromeSprite {
        order: 0,
        grayscale: common::ShaderBool::Disabled,
        opacity: 1.0,
        corner_smoothing: smoothing,
        bounds: bounds.into(),
        content_mask: common::ContentMask {
            bounds: bounds.into(),
            fade_out: common::Edges {
                top: 0.,
                right: 0.,
                bottom: 0.,
                left: 0.,
            },
        },
        corner_radii: radii.into(),
        tile: common::AtlasTile {
            texture_id: common::AtlasTextureId { index: 0, kind: 1 },
            tile_id: 0,
            padding: 0,
            bounds: common::AtlasBounds {
                origin: wgsl_rs::std::vec2i(0, 0),
                size: wgsl_rs::std::vec2i(0, 0),
            },
        },
    };
    if smoothed {
        let prepared = super::super::corner_smoothing::prepare_corners(
            sprite.bounds.size,
            sprite.corner_radii,
            smoothing,
            true,
        );
        super::super::polychrome_sprite::smoothed_polychrome_sprite_coverage(sprite, point, prepared)
    } else {
        super::super::polychrome_sprite::polychrome_sprite_coverage(sprite, point)
    }
}

pub(crate) fn linear_luma(rgb: [f32; 3]) -> f32 {
    rgb[0] * common::LINEAR_RGB_LUMA_WEIGHTS.x
        + rgb[1] * common::LINEAR_RGB_LUMA_WEIGHTS.y
        + rgb[2] * common::LINEAR_RGB_LUMA_WEIGHTS.z
}

pub(crate) fn polychrome_color(sample: [f32; 4], grayscale: bool) -> [f32; 3] {
    use wgsl_rs::std::*;
    let color = super::super::polychrome_sprite::polychrome_color_from_sample(
        vec4f(sample[0], sample[1], sample[2], sample[3]),
        grayscale.into(),
    );
    [color.x, color.y, color.z]
}

pub(crate) fn monochrome_correction(sample: f32, color: [f32; 3]) -> f32 {
    use wgsl_rs::std::*;
    common::apply_contrast_and_gamma_correction(
        sample,
        vec3f(color[0], color[1], color[2]),
        0.0,
        vec4f(0.0, 0.0, 0.0, 0.0),
    )
}

pub(crate) fn subpixel_correction(sample: [f32; 3], color: [f32; 3]) -> [f32; 3] {
    use wgsl_rs::std::*;
    let result = common::apply_contrast_and_gamma_correction3(
        vec3f(sample[0], sample[1], sample[2]),
        vec3f(color[0], color[1], color[2]),
        0.0,
        vec4f(0.0, 0.0, 0.0, 0.0),
    );
    [result.x, result.y, result.z]
}

pub(crate) fn gaussian(position: f32, sigma: f32) -> f32 {
    common::gaussian(position, sigma)
}

pub(crate) fn quadratic_path_coverage(curve: [f32; 2], dx: [f32; 2], dy: [f32; 2]) -> f32 {
    use wgsl_rs::std::*;
    super::super::path_rasterization::quadratic_bezier_coverage_with_derivatives(
        vec2f(curve[0], curve[1]),
        vec2f(dx[0], dx[1]),
        vec2f(dy[0], dy[1]),
    )
}
