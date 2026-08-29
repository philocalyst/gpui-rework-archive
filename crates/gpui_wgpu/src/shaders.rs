//! Rust-authored shader sources.
//!
//! Each pipeline module imports [`common`]. Keeping pipeline-local bindings in
//! the leaf modules is intentional: all of GPUI's instance buffers occupy
//! group 1 / binding 0, but they are mutually exclusive pipeline layouts.

#![allow(dead_code, unused_assignments, unused_imports)]

use wgsl_rs::wgsl;

#[wgsl]
pub mod common {
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct GlobalParams {
        pub viewport_size: Vec2f,
        pub premultiplied_alpha: u32,
        pub pad: u32,
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct GammaParams {
        pub gamma_ratios: Vec4f,
        pub grayscale_enhanced_contrast: f32,
        pub subpixel_enhanced_contrast: f32,
        pub is_bgr: u32,
        pub pad: u32,
    }

    uniform!(group(0), binding(0), GLOBALS: GlobalParams);
    uniform!(group(0), binding(1), GAMMA_PARAMS: GammaParams);

    #[derive(Clone, Copy, Wgsl)]
    pub struct Bounds {
        pub origin: Vec2f,
        pub size: Vec2f,
    }
    #[derive(Clone, Copy, Wgsl)]
    pub struct Corners {
        pub top_left: f32,
        pub top_right: f32,
        pub bottom_right: f32,
        pub bottom_left: f32,
    }
    #[derive(Clone, Copy, Wgsl)]
    pub struct Edges {
        pub top: f32,
        pub right: f32,
        pub bottom: f32,
        pub left: f32,
    }
    #[derive(Clone, Copy, Wgsl)]
    pub struct Hsla {
        pub h: f32,
        pub s: f32,
        pub l: f32,
        pub a: f32,
    }
    #[derive(Clone, Copy, Wgsl)]
    pub struct LinearColorStop {
        pub color: Hsla,
        pub percentage: f32,
    }
    #[derive(Clone, Copy, Wgsl)]
    pub struct Background {
        pub tag: u32,
        pub color_space: u32,
        pub solid: Hsla,
        pub gradient_angle_or_pattern_height: f32,
        pub colors: [LinearColorStop; 2],
        pub pad: u32,
    }
    #[derive(Clone, Copy, Wgsl)]
    pub struct AtlasTextureId {
        pub index: u32,
        pub kind: u32,
    }
    #[derive(Clone, Copy, Wgsl)]
    pub struct AtlasBounds {
        pub origin: Vec2i,
        pub size: Vec2i,
    }
    #[derive(Clone, Copy, Wgsl)]
    pub struct AtlasTile {
        pub texture_id: AtlasTextureId,
        pub tile_id: u32,
        pub padding: u32,
        pub bounds: AtlasBounds,
    }
    #[derive(Clone, Copy, Wgsl)]
    pub struct TransformationMatrix {
        pub rotation_scale: Mat2x2f,
        pub translation: Vec2f,
    }

    pub fn color_brightness(color: Vec3f) -> f32 {
        dot(color, vec3f(0.30, 0.59, 0.11))
    }
    pub fn light_on_dark_contrast(enhanced_contrast: f32, color: Vec3f) -> f32 {
        enhanced_contrast * saturate(4.0 * (0.75 - color_brightness(color)))
    }
    pub fn enhance_contrast(alpha: f32, k: f32) -> f32 {
        alpha * (k + 1.0) / (alpha * k + 1.0)
    }
    pub fn enhance_contrast3(alpha: Vec3f, k: f32) -> Vec3f {
        alpha * (k + 1.0) / (alpha * k + 1.0)
    }
    pub fn apply_alpha_correction(a: f32, b: f32, g: Vec4f) -> f32 {
        let brightness_adjustment = g.x * b + g.y;
        let correction = brightness_adjustment * a + (g.z * b + g.w);
        a + a * (1.0 - a) * correction
    }
    pub fn apply_alpha_correction3(a: Vec3f, b: Vec3f, g: Vec4f) -> Vec3f {
        let brightness_adjustment = g.x * b + g.y;
        let correction = brightness_adjustment * a + (g.z * b + g.w);
        a + a * (1.0 - a) * correction
    }
    pub fn apply_contrast_and_gamma_correction(
        sample: f32,
        color: Vec3f,
        enhanced_contrast_factor: f32,
        gamma_ratios: Vec4f,
    ) -> f32 {
        let enhanced_contrast = light_on_dark_contrast(enhanced_contrast_factor, color);
        apply_alpha_correction(
            enhance_contrast(sample, enhanced_contrast),
            color_brightness(color),
            gamma_ratios,
        )
    }
    pub fn apply_contrast_and_gamma_correction3(
        sample: Vec3f,
        color: Vec3f,
        enhanced_contrast_factor: f32,
        gamma_ratios: Vec4f,
    ) -> Vec3f {
        let contrasted = enhance_contrast3(
            sample,
            light_on_dark_contrast(enhanced_contrast_factor, color),
        );
        apply_alpha_correction3(contrasted, color, gamma_ratios)
    }
    pub fn unit_vertex(vertex_id: u32) -> Vec2f {
        vec2f((vertex_id & 1u32) as f32, 0.5 * (vertex_id & 2u32) as f32)
    }
    pub fn to_device_position_impl(position: Vec2f) -> Vec4f {
        let device_position =
            position / get!(GLOBALS).viewport_size * vec2f(2.0, -2.0) + vec2f(-1.0, 1.0);
        vec4f(device_position.x, device_position.y, 0.0, 1.0)
    }
    pub fn to_device_position(unit_vertex: Vec2f, bounds: Bounds) -> Vec4f {
        to_device_position_impl(unit_vertex * bounds.size + bounds.origin)
    }
    pub fn to_device_position_transformed(
        unit_vertex: Vec2f,
        bounds: Bounds,
        transform: TransformationMatrix,
    ) -> Vec4f {
        let position = unit_vertex * bounds.size + bounds.origin;
        to_device_position_impl(
            transpose(transform.rotation_scale) * position + transform.translation,
        )
    }
    pub fn distance_from_clip_rect_impl(position: Vec2f, clip_bounds: Bounds) -> Vec4f {
        let tl = position - clip_bounds.origin;
        let br = clip_bounds.origin + clip_bounds.size - position;
        vec4f(tl.x, br.x, tl.y, br.y)
    }
    pub fn distance_from_clip_rect(
        unit_vertex: Vec2f,
        bounds: Bounds,
        clip_bounds: Bounds,
    ) -> Vec4f {
        distance_from_clip_rect_impl(unit_vertex * bounds.size + bounds.origin, clip_bounds)
    }
    pub fn distance_from_clip_rect_transformed(
        unit_vertex: Vec2f,
        bounds: Bounds,
        clip_bounds: Bounds,
        transform: TransformationMatrix,
    ) -> Vec4f {
        let position = unit_vertex * bounds.size + bounds.origin;
        distance_from_clip_rect_impl(
            transpose(transform.rotation_scale) * position + transform.translation,
            clip_bounds,
        )
    }
    pub fn is_clipped(distances: Vec4f) -> bool {
        distances.x < 0.0 || distances.y < 0.0 || distances.z < 0.0 || distances.w < 0.0
    }
    pub fn srgb_to_linear(srgb: Vec3f) -> Vec3f {
        let cutoff = vec3b(srgb.x < 0.04045, srgb.y < 0.04045, srgb.z < 0.04045);
        let higher = pow((srgb + 0.055) / 1.055, vec3f(2.4, 2.4, 2.4));
        select(higher, srgb / 12.92, cutoff)
    }
    pub fn linear_to_srgb(linear: Vec3f) -> Vec3f {
        let cutoff = vec3b(
            linear.x < 0.0031308,
            linear.y < 0.0031308,
            linear.z < 0.0031308,
        );
        let higher = 1.055 * pow(linear, vec3f(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) - 0.055;
        select(higher, linear * 12.92, cutoff)
    }
    pub fn linear_to_srgba(color: Vec4f) -> Vec4f {
        let rgb = linear_to_srgb(color.rgb());
        vec4f(rgb.x, rgb.y, rgb.z, color.w)
    }
    pub fn srgba_to_linear(color: Vec4f) -> Vec4f {
        let rgb = srgb_to_linear(color.rgb());
        vec4f(rgb.x, rgb.y, rgb.z, color.w)
    }
    pub fn hsla_to_rgba(hsla: Hsla) -> Vec4f {
        let h = hsla.h * 6.0;
        let c = (1.0 - abs(2.0 * hsla.l - 1.0)) * hsla.s;
        let x = c * (1.0 - abs(h % 2.0 - 1.0));
        let m = hsla.l - c / 2.0;
        let mut color = vec3f(m, m, m);
        if h >= 0.0 && h < 1.0 {
            color.x += c;
            color.y += x;
        } else if h >= 1.0 && h < 2.0 {
            color.x += x;
            color.y += c;
        } else if h >= 2.0 && h < 3.0 {
            color.y += c;
            color.z += x;
        } else if h >= 3.0 && h < 4.0 {
            color.y += x;
            color.z += c;
        } else if h >= 4.0 && h < 5.0 {
            color.x += x;
            color.z += c;
        } else {
            color.x += c;
            color.z += x;
        }
        vec4f(color.x, color.y, color.z, hsla.a)
    }
    pub fn linear_srgb_to_oklab(color: Vec4f) -> Vec4f {
        let l = 0.4122214708 * color.x + 0.5363325363 * color.y + 0.0514459929 * color.z;
        let m = 0.2119034982 * color.x + 0.6806995451 * color.y + 0.1073969566 * color.z;
        let s = 0.0883024619 * color.x + 0.2817188376 * color.y + 0.6299787005 * color.z;
        let l_ = pow(l, 1.0 / 3.0);
        let m_ = pow(m, 1.0 / 3.0);
        let s_ = pow(s, 1.0 / 3.0);
        vec4f(
            0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
            1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
            0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_,
            color.w,
        )
    }
    pub fn oklab_to_linear_srgb(color: Vec4f) -> Vec4f {
        let l_ = color.x + 0.3963377774 * color.y + 0.2158037573 * color.z;
        let m_ = color.x - 0.1055613458 * color.y - 0.0638541728 * color.z;
        let s_ = color.x - 0.0894841775 * color.y - 1.2914855480 * color.z;
        let l = l_ * l_ * l_;
        let m = m_ * m_ * m_;
        let s = s_ * s_ * s_;
        vec4f(
            4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
            -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
            -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s,
            color.w,
        )
    }
    pub fn over(below: Vec4f, above: Vec4f) -> Vec4f {
        let alpha = above.w + below.w * (1.0 - above.w);
        let rgb = (above.rgb() * above.w + below.rgb() * below.w * (1.0 - above.w)) / alpha;
        vec4f(rgb.x, rgb.y, rgb.z, alpha)
    }
    pub fn gaussian(x: f32, sigma: f32) -> f32 {
        exp(-(x * x) / (2.0 * sigma * sigma)) / (sqrt(2.0 * 3.1415926) * sigma)
    }
    pub fn erf(v: Vec2f) -> Vec2f {
        let signs = sign(v);
        let a = abs(v);
        let r1 = 1.0 + (0.278393 + (0.230389 + (0.000972 + 0.078108 * a) * a) * a) * a;
        let r2 = r1 * r1;
        signs - signs / (r2 * r2)
    }
    pub fn blur_along_x(x: f32, y: f32, sigma: f32, corner: f32, half_size: Vec2f) -> f32 {
        let delta = min(half_size.y - corner - abs(y), 0.0);
        let curved = half_size.x - corner + sqrt(max(0.0, corner * corner - delta * delta));
        let integral = 0.5 + 0.5 * erf((x + vec2f(-curved, curved)) * (sqrt(0.5) / sigma));
        integral.y - integral.x
    }
    pub fn pick_corner_radius(center_to_point: Vec2f, radii: Corners) -> f32 {
        if center_to_point.x < 0.0 {
            if center_to_point.y < 0.0 {
                radii.top_left
            } else {
                radii.bottom_left
            }
        } else if center_to_point.y < 0.0 {
            radii.top_right
        } else {
            radii.bottom_right
        }
    }
    pub fn quad_sdf_impl(corner_center_to_point: Vec2f, corner_radius: f32) -> f32 {
        if corner_radius == 0.0 {
            max(corner_center_to_point.x, corner_center_to_point.y)
        } else {
            length(max(vec2f(0.0, 0.0), corner_center_to_point))
                + min(0.0, max(corner_center_to_point.x, corner_center_to_point.y))
                - corner_radius
        }
    }
    pub fn quad_sdf(point: Vec2f, bounds: Bounds, corner_radii: Corners) -> f32 {
        let half_size = bounds.size / 2.0;
        let center_to_point = point - (bounds.origin + half_size);
        let corner_radius = pick_corner_radius(center_to_point, corner_radii);
        quad_sdf_impl(
            abs(center_to_point) - half_size + corner_radius,
            corner_radius,
        )
    }
    pub fn blend_color(color: Vec4f, alpha_factor: f32) -> Vec4f {
        let alpha = color.w * alpha_factor;
        let multiplier = select(1.0, alpha, get!(GLOBALS).premultiplied_alpha != 0u32);
        vec4f(
            color.x * multiplier,
            color.y * multiplier,
            color.z * multiplier,
            alpha,
        )
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct GradientColor {
        pub solid: Vec4f,
        pub color0: Vec4f,
        pub color1: Vec4f,
    }

    pub fn prepare_gradient_color(
        tag: u32,
        color_space: u32,
        solid: Hsla,
        colors: [LinearColorStop; 2],
    ) -> GradientColor {
        let mut result = GradientColor {
            solid: vec4f(0.0, 0.0, 0.0, 0.0),
            color0: vec4f(0.0, 0.0, 0.0, 0.0),
            color1: vec4f(0.0, 0.0, 0.0, 0.0),
        };
        if tag == 0u32 || tag == 2u32 || tag == 3u32 {
            result.solid = hsla_to_rgba(solid);
        } else if tag == 1u32 {
            result.color0 = hsla_to_rgba(colors[0usize].color);
            result.color1 = hsla_to_rgba(colors[1usize].color);
            if color_space == 0u32 {
                result.color0 = linear_to_srgba(result.color0);
                result.color1 = linear_to_srgba(result.color1);
            } else if color_space == 1u32 {
                result.color0 = linear_srgb_to_oklab(result.color0);
                result.color1 = linear_srgb_to_oklab(result.color1);
            }
        }
        result
    }
    pub fn gradient_color(
        background: Background,
        position: Vec2f,
        bounds: Bounds,
        solid_color: Vec4f,
        color0: Vec4f,
        color1: Vec4f,
    ) -> Vec4f {
        let mut background_color = vec4f(0.0, 0.0, 0.0, 0.0);
        match background.tag {
            1 => {
                let radians = (background.gradient_angle_or_pattern_height % 360.0 - 90.0)
                    * 3.1415926
                    / 180.0;
                let mut direction = vec2f(cos(radians), sin(radians));
                if bounds.size.x > bounds.size.y {
                    direction.y *= bounds.size.y / bounds.size.x;
                } else {
                    direction.x *= bounds.size.x / bounds.size.y;
                }
                let half_size = bounds.size / 2.0;
                let center_to_point = position - (bounds.origin + half_size);
                let mut t = dot(center_to_point, direction) / length(direction);
                if abs(direction.x) > abs(direction.y) {
                    t = (t + half_size.x) / bounds.size.x;
                } else {
                    t = (t + half_size.y) / bounds.size.y;
                }
                t = (t - background.colors[0usize].percentage)
                    / (background.colors[1usize].percentage - background.colors[0usize].percentage);
                t = clamp(t, 0.0, 1.0);
                let ratio = vec4f(t, t, t, t);
                if background.color_space == 1u32 {
                    background_color = oklab_to_linear_srgb(mix(color0, color1, ratio));
                } else {
                    background_color = srgba_to_linear(mix(color0, color1, ratio));
                }
            }
            2 => {
                let encoded = background.gradient_angle_or_pattern_height;
                let pattern_width = (encoded / 65535.0) / 255.0;
                let pattern_interval = (encoded % 65535.0) / 255.0;
                let pattern_height = pattern_width + pattern_interval;
                let stripe_angle = 3.1415926 / 4.0;
                let period = pattern_height * sin(stripe_angle);
                let rotation = mat2x2f(
                    vec2f(cos(stripe_angle), -sin(stripe_angle)),
                    vec2f(sin(stripe_angle), cos(stripe_angle)),
                );
                let pattern = (rotation * (position - bounds.origin)).x % period;
                let distance = min(pattern, period - pattern)
                    - period * (pattern_width / pattern_height) / 2.0;
                background_color = solid_color;
                background_color.w *= saturate(0.5 - distance);
            }
            3 => {
                let relative = position - bounds.origin;
                let colored = (floor(relative.x / background.gradient_angle_or_pattern_height)
                    + floor(relative.y / background.gradient_angle_or_pattern_height))
                    % 2.0;
                background_color = solid_color;
                background_color.w *= saturate(colored);
            }
            _ => {
                return solid_color;
            }
        }
        background_color
    }
    pub fn corner_dash_velocity(dv1: f32, dv2: f32) -> f32 {
        if dv1 == 0.0 {
            dv2
        } else if dv2 == 0.0 {
            dv1
        } else {
            min(dv1, dv2)
        }
    }
    pub fn fmod(a: f32, b: f32) -> f32 {
        a - b * trunc(a / b)
    }
    pub fn dash_alpha(
        t: f32,
        period: f32,
        length_: f32,
        dash_velocity: f32,
        antialias_threshold: f32,
    ) -> f32 {
        let centered = fmod(t + period / 2.0 - length_ / 2.0, period) - period / 2.0;
        let signed_distance = abs(centered) - length_ / 2.0;
        saturate(antialias_threshold - signed_distance / dash_velocity)
    }
    pub fn quarter_ellipse_sdf(point: Vec2f, radii: Vec2f) -> f32 {
        (length(point / radii) - 1.0) * (radii.x + radii.y) * -0.5
    }
}

#[wgsl]
pub mod quad {
    use super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct Quad {
        pub order: u32,
        pub border_style: u32,
        pub bounds: Bounds,
        pub content_mask: Bounds,
        pub background: Background,
        pub border_color: Hsla,
        pub corner_radii: Corners,
        pub border_widths: Edges,
    }
    storage!(group(1), binding(0), QUADS: RuntimeArray<Quad>);

    #[derive(Wgsl)]
    pub struct QuadVarying {
        #[builtin(position)]
        pub position: Vec4f,
        #[location(0)]
        #[interpolate(flat)]
        pub border_color: Vec4f,
        #[location(1)]
        #[interpolate(flat)]
        pub quad_id: u32,
        #[location(2)]
        pub clip_distances: Vec4f,
        #[location(3)]
        #[interpolate(flat)]
        pub background_solid: Vec4f,
        #[location(4)]
        #[interpolate(flat)]
        pub background_color0: Vec4f,
        #[location(5)]
        #[interpolate(flat)]
        pub background_color1: Vec4f,
    }

    #[vertex]
    pub fn vs_quad(
        #[builtin(vertex_index)] vertex_id: u32,
        #[builtin(instance_index)] instance_id: u32,
    ) -> QuadVarying {
        let vertex = unit_vertex(vertex_id);
        let quad = get!(QUADS)[instance_id as usize];
        let gradient = prepare_gradient_color(
            quad.background.tag,
            quad.background.color_space,
            quad.background.solid,
            quad.background.colors,
        );
        QuadVarying {
            position: to_device_position(vertex, quad.bounds),
            border_color: hsla_to_rgba(quad.border_color),
            quad_id: instance_id,
            clip_distances: distance_from_clip_rect(vertex, quad.bounds, quad.content_mask),
            background_solid: gradient.solid,
            background_color0: gradient.color0,
            background_color1: gradient.color1,
        }
    }

    #[fragment]
    pub fn fs_quad(input: QuadVarying) -> Vec4f {
        if is_clipped(input.clip_distances) {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        let quad = get!(QUADS)[input.quad_id as usize];
        let background_color = gradient_color(
            quad.background,
            input.position.xy(),
            quad.bounds,
            input.background_solid,
            input.background_color0,
            input.background_color1,
        );
        let unrounded = quad.corner_radii.top_left == 0.0
            && quad.corner_radii.bottom_left == 0.0
            && quad.corner_radii.top_right == 0.0
            && quad.corner_radii.bottom_right == 0.0;
        if quad.border_widths.top == 0.0
            && quad.border_widths.left == 0.0
            && quad.border_widths.right == 0.0
            && quad.border_widths.bottom == 0.0
            && unrounded
        {
            return blend_color(background_color, 1.0);
        }

        let size = quad.bounds.size;
        let half_size = size / 2.0;
        let point = input.position.xy() - quad.bounds.origin;
        let center_to_point = point - half_size;
        let antialias_threshold = 0.5;
        let corner_radius = pick_corner_radius(center_to_point, quad.corner_radii);
        let border = vec2f(
            select(
                quad.border_widths.right,
                quad.border_widths.left,
                center_to_point.x < 0.0,
            ),
            select(
                quad.border_widths.bottom,
                quad.border_widths.top,
                center_to_point.y < 0.0,
            ),
        );
        let reduced_border = vec2f(
            select(border.x, -antialias_threshold, border.x == 0.0),
            select(border.y, -antialias_threshold, border.y == 0.0),
        );
        let corner_to_point = abs(center_to_point) - half_size;
        let corner_center_to_point = corner_to_point + corner_radius;
        let is_near_rounded_corner =
            corner_center_to_point.x >= 0.0 && corner_center_to_point.y >= 0.0;
        let straight_border_inner_corner_to_point = corner_to_point + reduced_border;
        let is_beyond_inner_straight_border = straight_border_inner_corner_to_point.x > 0.0
            || straight_border_inner_corner_to_point.y > 0.0;
        let is_within_inner_straight_border = straight_border_inner_corner_to_point.x
            < -antialias_threshold
            && straight_border_inner_corner_to_point.y < -antialias_threshold;
        if is_within_inner_straight_border && !is_near_rounded_corner {
            return blend_color(background_color, 1.0);
        }

        let outer_sdf = quad_sdf_impl(corner_center_to_point, corner_radius);
        let mut inner_sdf = 0.0;
        if corner_center_to_point.x <= 0.0 || corner_center_to_point.y <= 0.0 {
            inner_sdf = -max(
                straight_border_inner_corner_to_point.x,
                straight_border_inner_corner_to_point.y,
            );
        } else if is_beyond_inner_straight_border {
            inner_sdf = -1.0;
        } else if reduced_border.x == reduced_border.y {
            inner_sdf = -(outer_sdf + reduced_border.x);
        } else {
            inner_sdf = quarter_ellipse_sdf(
                corner_center_to_point,
                max(vec2f(0.0, 0.0), corner_radius - reduced_border),
            );
        }

        let border_sdf = max(inner_sdf, outer_sdf);
        let mut color = background_color;
        if border_sdf < antialias_threshold {
            let mut border_color = input.border_color;
            if quad.border_style == 1u32 {
                let mut t = 0.0;
                let mut max_t = 0.0;
                let dash_length_per_width = 2.0;
                let dash_gap_per_width = 1.0;
                let dash_period_per_width = dash_length_per_width + dash_gap_per_width;
                let mut dash_velocity = 0.0;
                let dv_numerator = 1.0 / dash_period_per_width;

                if unrounded {
                    let is_horizontal = corner_center_to_point.x < corner_center_to_point.y;
                    let dashed_border = vec2f(
                        max(quad.border_widths.bottom, quad.border_widths.top),
                        max(quad.border_widths.right, quad.border_widths.left),
                    );
                    let border_width = select(dashed_border.y, dashed_border.x, is_horizontal);
                    dash_velocity = dv_numerator / border_width;
                    t = select(point.y, point.x, is_horizontal) * dash_velocity;
                    max_t = select(size.y, size.x, is_horizontal) * dash_velocity;
                } else {
                    let r_tr = quad.corner_radii.top_right;
                    let r_br = quad.corner_radii.bottom_right;
                    let r_bl = quad.corner_radii.bottom_left;
                    let r_tl = quad.corner_radii.top_left;
                    let w_t = quad.border_widths.top;
                    let w_r = quad.border_widths.right;
                    let w_b = quad.border_widths.bottom;
                    let w_l = quad.border_widths.left;
                    let dv_t = select(dv_numerator / w_t, 0.0, w_t <= 0.0);
                    let dv_r = select(dv_numerator / w_r, 0.0, w_r <= 0.0);
                    let dv_b = select(dv_numerator / w_b, 0.0, w_b <= 0.0);
                    let dv_l = select(dv_numerator / w_l, 0.0, w_l <= 0.0);
                    let s_t = (size.x - r_tl - r_tr) * dv_t;
                    let s_r = (size.y - r_tr - r_br) * dv_r;
                    let s_b = (size.x - r_br - r_bl) * dv_b;
                    let s_l = (size.y - r_bl - r_tl) * dv_l;
                    let corner_velocity_tr = corner_dash_velocity(dv_t, dv_r);
                    let corner_velocity_br = corner_dash_velocity(dv_b, dv_r);
                    let corner_velocity_bl = corner_dash_velocity(dv_b, dv_l);
                    let corner_velocity_tl = corner_dash_velocity(dv_t, dv_l);
                    let c_tr = r_tr * (3.1415926 / 2.0) * corner_velocity_tr;
                    let c_br = r_br * (3.1415926 / 2.0) * corner_velocity_br;
                    let c_bl = r_bl * (3.1415926 / 2.0) * corner_velocity_bl;
                    let c_tl = r_tl * (3.1415926 / 2.0) * corner_velocity_tl;
                    let upto_tr = s_t;
                    let upto_r = upto_tr + c_tr;
                    let upto_br = upto_r + s_r;
                    let upto_b = upto_br + c_br;
                    let upto_bl = upto_b + s_b;
                    let upto_l = upto_bl + c_bl;
                    let upto_tl = upto_l + s_l;
                    max_t = upto_tl + c_tl;

                    if is_near_rounded_corner {
                        let radians = atan2(corner_center_to_point.y, corner_center_to_point.x);
                        let corner_t = radians * corner_radius;
                        if center_to_point.x >= 0.0 {
                            if center_to_point.y < 0.0 {
                                dash_velocity = corner_velocity_tr;
                                t = upto_r - corner_t * dash_velocity;
                            } else {
                                dash_velocity = corner_velocity_br;
                                t = upto_br + corner_t * dash_velocity;
                            }
                        } else if center_to_point.y >= 0.0 {
                            dash_velocity = corner_velocity_bl;
                            t = upto_l - corner_t * dash_velocity;
                        } else {
                            dash_velocity = corner_velocity_tl;
                            t = upto_tl + corner_t * dash_velocity;
                        }
                    } else {
                        let is_horizontal = corner_center_to_point.x < corner_center_to_point.y;
                        if is_horizontal {
                            if center_to_point.y < 0.0 {
                                dash_velocity = dv_t;
                                t = (point.x - r_tl) * dash_velocity;
                            } else {
                                dash_velocity = dv_b;
                                t = upto_bl - (point.x - r_bl) * dash_velocity;
                            }
                        } else if center_to_point.x < 0.0 {
                            dash_velocity = dv_l;
                            t = upto_tl - (point.y - r_tl) * dash_velocity;
                        } else {
                            dash_velocity = dv_r;
                            t = upto_r + (point.y - r_tr) * dash_velocity;
                        }
                    }
                }

                let dash_length = dash_length_per_width / dash_period_per_width;
                max_t -= select(0.0, dash_length, unrounded);
                if max_t >= 1.0 {
                    let dash_count = floor(max_t);
                    let dash_period = max_t / dash_count;
                    border_color.w *= dash_alpha(
                        t,
                        dash_period,
                        dash_length,
                        dash_velocity,
                        antialias_threshold,
                    );
                } else if unrounded {
                    let dash_gap = max_t - dash_length;
                    if dash_gap > 0.0 {
                        border_color.w *= dash_alpha(
                            t,
                            dash_length + dash_gap,
                            dash_length,
                            dash_velocity,
                            antialias_threshold,
                        );
                    }
                }
            }

            let blended_border = over(background_color, border_color);
            let factor = saturate(antialias_threshold - inner_sdf);
            color = mix(
                background_color,
                blended_border,
                vec4f(factor, factor, factor, factor),
            );
        }
        blend_color(color, saturate(antialias_threshold - outer_sdf))
    }
}

#[wgsl]
pub mod shadow {
    use super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct Shadow {
        pub order: u32,
        pub blur_radius: f32,
        pub bounds: Bounds,
        pub corner_radii: Corners,
        pub content_mask: Bounds,
        pub color: Hsla,
        pub element_bounds: Bounds,
        pub element_corner_radii: Corners,
        pub inset: u32,
        pub pad: u32,
    }
    storage!(group(1), binding(0), SHADOWS: RuntimeArray<Shadow>);

    #[derive(Wgsl)]
    pub struct ShadowVarying {
        #[builtin(position)]
        pub position: Vec4f,
        #[location(0)]
        #[interpolate(flat)]
        pub color: Vec4f,
        #[location(1)]
        #[interpolate(flat)]
        pub shadow_id: u32,
        #[location(3)]
        pub clip_distances: Vec4f,
    }

    #[vertex]
    pub fn vs_shadow(
        #[builtin(vertex_index)] vertex_id: u32,
        #[builtin(instance_index)] instance_id: u32,
    ) -> ShadowVarying {
        let vertex = unit_vertex(vertex_id);
        let shadow = get!(SHADOWS)[instance_id as usize];
        let mut geometry = shadow.bounds;
        if shadow.inset != 0u32 {
            geometry = shadow.element_bounds;
        } else {
            let margin = 3.0 * shadow.blur_radius;
            geometry.origin = geometry.origin - vec2f(margin, margin);
            geometry.size = geometry.size + vec2f(2.0 * margin, 2.0 * margin);
        }
        ShadowVarying {
            position: to_device_position(vertex, geometry),
            color: hsla_to_rgba(shadow.color),
            shadow_id: instance_id,
            clip_distances: distance_from_clip_rect(vertex, geometry, shadow.content_mask),
        }
    }

    #[fragment]
    pub fn fs_shadow(input: ShadowVarying) -> Vec4f {
        if is_clipped(input.clip_distances) {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        let shadow = get!(SHADOWS)[input.shadow_id as usize];
        let half_size = shadow.bounds.size / 2.0;
        let center_to_point = input.position.xy() - (shadow.bounds.origin + half_size);
        let corner_radius = pick_corner_radius(center_to_point, shadow.corner_radii);
        let mut alpha = 0.0;
        if shadow.blur_radius == 0.0 {
            alpha =
                saturate(0.5 - quad_sdf(input.position.xy(), shadow.bounds, shadow.corner_radii));
        } else {
            let low = center_to_point.y - half_size.y;
            let high = center_to_point.y + half_size.y;
            let start = clamp(-3.0 * shadow.blur_radius, low, high);
            let end = clamp(3.0 * shadow.blur_radius, low, high);
            let step = (end - start) / 4.0;
            let mut y = start + step * 0.5;
            for _i in 0..4 {
                alpha += blur_along_x(
                    center_to_point.x,
                    center_to_point.y - y,
                    shadow.blur_radius,
                    corner_radius,
                    half_size,
                ) * gaussian(y, shadow.blur_radius)
                    * step;
                y += step;
            }
        }
        if shadow.inset != 0u32 {
            alpha = 1.0 - alpha;
            alpha *= saturate(
                0.5 - quad_sdf(
                    input.position.xy(),
                    shadow.element_bounds,
                    shadow.element_corner_radii,
                ),
            );
        }
        blend_color(input.color, alpha)
    }
}

#[wgsl]
pub mod path_rasterization {
    use super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct PathRasterizationVertex {
        pub xy_position: Vec2f,
        pub st_position: Vec2f,
        pub color: Background,
        pub bounds: Bounds,
    }
    storage!(group(1), binding(0), PATH_VERTICES: RuntimeArray<PathRasterizationVertex>);

    #[derive(Wgsl)]
    pub struct PathRasterizationVarying {
        #[builtin(position)]
        pub position: Vec4f,
        #[location(0)]
        pub st_position: Vec2f,
        #[location(1)]
        #[interpolate(flat)]
        pub vertex_id: u32,
        #[location(3)]
        pub clip_distances: Vec4f,
    }

    #[vertex]
    pub fn vs_path_rasterization(
        #[builtin(vertex_index)] vertex_id: u32,
    ) -> PathRasterizationVarying {
        let vertex = get!(PATH_VERTICES)[vertex_id as usize];
        PathRasterizationVarying {
            position: to_device_position_impl(vertex.xy_position),
            st_position: vertex.st_position,
            vertex_id,
            clip_distances: distance_from_clip_rect_impl(vertex.xy_position, vertex.bounds),
        }
    }

    #[fragment]
    pub fn fs_path_rasterization(input: PathRasterizationVarying) -> Vec4f {
        let dx = dpdx(input.st_position);
        let dy = dpdy(input.st_position);
        if is_clipped(input.clip_distances) {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        let vertex = get!(PATH_VERTICES)[input.vertex_id as usize];
        let mut alpha = 1.0;
        if length(vec2f(dx.x, dy.x)) >= 0.001 {
            let gradient = 2.0 * input.st_position.xx() * vec2f(dx.x, dy.x) - vec2f(dx.y, dy.y);
            let distance = (input.st_position.x * input.st_position.x - input.st_position.y)
                / length(gradient);
            alpha = saturate(0.5 - distance);
        }
        let prepared = prepare_gradient_color(
            vertex.color.tag,
            vertex.color.color_space,
            vertex.color.solid,
            vertex.color.colors,
        );
        let color = gradient_color(
            vertex.color,
            input.position.xy(),
            vertex.bounds,
            prepared.solid,
            prepared.color0,
            prepared.color1,
        );
        vec4f(
            color.x * color.w * alpha,
            color.y * color.w * alpha,
            color.z * color.w * alpha,
            color.w * alpha,
        )
    }
}

#[wgsl]
pub mod path {
    use super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct PathSprite {
        pub bounds: Bounds,
    }
    storage!(group(1), binding(0), PATH_SPRITES: RuntimeArray<PathSprite>);
    texture!(group(1), binding(1), PATH_TEXTURE: Texture2D<f32>);
    sampler!(group(1), binding(2), PATH_SAMPLER: Sampler);

    #[derive(Wgsl)]
    pub struct PathVarying {
        #[builtin(position)]
        pub position: Vec4f,
        #[location(0)]
        pub texture_coords: Vec2f,
    }

    #[vertex]
    pub fn vs_path(
        #[builtin(vertex_index)] vertex_id: u32,
        #[builtin(instance_index)] instance_id: u32,
    ) -> PathVarying {
        let vertex = unit_vertex(vertex_id);
        let sprite = get!(PATH_SPRITES)[instance_id as usize];
        PathVarying {
            position: to_device_position(vertex, sprite.bounds),
            texture_coords: (sprite.bounds.origin + vertex * sprite.bounds.size)
                / get!(GLOBALS).viewport_size,
        }
    }

    #[fragment]
    pub fn fs_path(input: PathVarying) -> Vec4f {
        texture_sample(PATH_TEXTURE, PATH_SAMPLER, input.texture_coords)
    }
}

#[wgsl]
pub mod underline {
    use super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct Underline {
        pub order: u32,
        pub pad: u32,
        pub bounds: Bounds,
        pub content_mask: Bounds,
        pub color: Hsla,
        pub thickness: f32,
        pub wavy: u32,
    }
    storage!(group(1), binding(0), UNDERLINES: RuntimeArray<Underline>);

    #[derive(Wgsl)]
    pub struct UnderlineVarying {
        #[builtin(position)]
        pub position: Vec4f,
        #[location(0)]
        #[interpolate(flat)]
        pub color: Vec4f,
        #[location(1)]
        #[interpolate(flat)]
        pub underline_id: u32,
        #[location(3)]
        pub clip_distances: Vec4f,
    }

    #[vertex]
    pub fn vs_underline(
        #[builtin(vertex_index)] vertex_id: u32,
        #[builtin(instance_index)] instance_id: u32,
    ) -> UnderlineVarying {
        let vertex = unit_vertex(vertex_id);
        let underline = get!(UNDERLINES)[instance_id as usize];
        UnderlineVarying {
            position: to_device_position(vertex, underline.bounds),
            color: hsla_to_rgba(underline.color),
            underline_id: instance_id,
            clip_distances: distance_from_clip_rect(
                vertex,
                underline.bounds,
                underline.content_mask,
            ),
        }
    }

    #[fragment]
    pub fn fs_underline(input: UnderlineVarying) -> Vec4f {
        if is_clipped(input.clip_distances) {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        let underline = get!(UNDERLINES)[input.underline_id as usize];
        if underline.wavy == 0u32 {
            return blend_color(input.color, input.color.w);
        }
        let half_thickness = underline.thickness * 0.5;
        let st = (input.position.xy() - underline.bounds.origin) / underline.bounds.size.y
            - vec2f(0.0, 0.5);
        let frequency = 3.1415926 * 2.0 * underline.thickness / underline.bounds.size.y;
        let amplitude = underline.thickness * 0.8 / underline.bounds.size.y;
        let sine = sin(st.x * frequency) * amplitude;
        let derivative = cos(st.x * frequency) * amplitude * frequency;
        let distance_in_pixels =
            (st.y - sine) / sqrt(1.0 + derivative * derivative) * underline.bounds.size.y;
        let alpha = saturate(
            0.5 - max(
                -(distance_in_pixels + half_thickness),
                distance_in_pixels - half_thickness,
            ),
        );
        blend_color(input.color, alpha * input.color.w)
    }
}

#[wgsl]
pub mod mono_sprite {
    use super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct MonochromeSprite {
        pub order: u32,
        pub pad: u32,
        pub bounds: Bounds,
        pub content_mask: Bounds,
        pub color: Hsla,
        pub tile: AtlasTile,
        pub transformation: TransformationMatrix,
    }
    storage!(group(1), binding(0), MONO_SPRITES: RuntimeArray<MonochromeSprite>);
    texture!(group(1), binding(1), MONO_TEXTURE: Texture2D<f32>);
    sampler!(group(1), binding(2), MONO_SAMPLER: Sampler);

    #[derive(Wgsl)]
    pub struct MonoSpriteVarying {
        #[builtin(position)]
        pub position: Vec4f,
        #[location(0)]
        pub tile_position: Vec2f,
        #[location(1)]
        #[interpolate(flat)]
        pub color: Vec4f,
        #[location(3)]
        pub clip_distances: Vec4f,
    }

    pub fn mono_tile_position(vertex: Vec2f, tile: AtlasTile) -> Vec2f {
        let atlas_size = texture_dimensions(MONO_TEXTURE);
        (vec2f(tile.bounds.origin.x as f32, tile.bounds.origin.y as f32)
            + vertex * vec2f(tile.bounds.size.x as f32, tile.bounds.size.y as f32))
            / vec2f(atlas_size.x as f32, atlas_size.y as f32)
    }

    #[vertex]
    pub fn vs_mono_sprite(
        #[builtin(vertex_index)] vertex_id: u32,
        #[builtin(instance_index)] instance_id: u32,
    ) -> MonoSpriteVarying {
        let vertex = unit_vertex(vertex_id);
        let sprite = get!(MONO_SPRITES)[instance_id as usize];
        MonoSpriteVarying {
            position: to_device_position_transformed(vertex, sprite.bounds, sprite.transformation),
            tile_position: mono_tile_position(vertex, sprite.tile),
            color: hsla_to_rgba(sprite.color),
            clip_distances: distance_from_clip_rect_transformed(
                vertex,
                sprite.bounds,
                sprite.content_mask,
                sprite.transformation,
            ),
        }
    }

    #[fragment]
    pub fn fs_mono_sprite(input: MonoSpriteVarying) -> Vec4f {
        let sample = texture_sample(MONO_TEXTURE, MONO_SAMPLER, input.tile_position).x;
        let corrected = apply_contrast_and_gamma_correction(
            sample,
            input.color.rgb(),
            get!(GAMMA_PARAMS).grayscale_enhanced_contrast,
            get!(GAMMA_PARAMS).gamma_ratios,
        );
        if is_clipped(input.clip_distances) {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        blend_color(input.color, corrected)
    }
}

#[wgsl]
pub mod poly_sprite {
    use super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct PolychromeSprite {
        pub order: u32,
        pub pad: u32,
        pub grayscale: u32,
        pub opacity: f32,
        pub bounds: Bounds,
        pub content_mask: Bounds,
        pub corner_radii: Corners,
        pub tile: AtlasTile,
    }
    storage!(group(1), binding(0), POLY_SPRITES: RuntimeArray<PolychromeSprite>);
    texture!(group(1), binding(1), POLY_TEXTURE: Texture2D<f32>);
    sampler!(group(1), binding(2), POLY_SAMPLER: Sampler);

    #[derive(Wgsl)]
    pub struct PolySpriteVarying {
        #[builtin(position)]
        pub position: Vec4f,
        #[location(0)]
        pub tile_position: Vec2f,
        #[location(1)]
        #[interpolate(flat)]
        pub sprite_id: u32,
        #[location(3)]
        pub clip_distances: Vec4f,
    }

    pub fn poly_tile_position(vertex: Vec2f, tile: AtlasTile) -> Vec2f {
        let atlas_size = texture_dimensions(POLY_TEXTURE);
        (vec2f(tile.bounds.origin.x as f32, tile.bounds.origin.y as f32)
            + vertex * vec2f(tile.bounds.size.x as f32, tile.bounds.size.y as f32))
            / vec2f(atlas_size.x as f32, atlas_size.y as f32)
    }

    #[vertex]
    pub fn vs_poly_sprite(
        #[builtin(vertex_index)] vertex_id: u32,
        #[builtin(instance_index)] instance_id: u32,
    ) -> PolySpriteVarying {
        let vertex = unit_vertex(vertex_id);
        let sprite = get!(POLY_SPRITES)[instance_id as usize];
        PolySpriteVarying {
            position: to_device_position(vertex, sprite.bounds),
            tile_position: poly_tile_position(vertex, sprite.tile),
            sprite_id: instance_id,
            clip_distances: distance_from_clip_rect(vertex, sprite.bounds, sprite.content_mask),
        }
    }

    #[fragment]
    pub fn fs_poly_sprite(input: PolySpriteVarying) -> Vec4f {
        let sample = texture_sample(POLY_TEXTURE, POLY_SAMPLER, input.tile_position);
        if is_clipped(input.clip_distances) {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        let sprite = get!(POLY_SPRITES)[input.sprite_id as usize];
        let mut color = sample;
        if sprite.grayscale != 0u32 {
            let grayscale = dot(color.rgb(), vec3f(0.2126, 0.7152, 0.0722));
            color = vec4f(grayscale, grayscale, grayscale, sample.w);
        }
        blend_color(
            color,
            sprite.opacity
                * saturate(0.5 - quad_sdf(input.position.xy(), sprite.bounds, sprite.corner_radii)),
        )
    }
}

#[wgsl]
pub mod surface {
    use super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct SurfaceParams {
        pub bounds: Bounds,
        pub content_mask: Bounds,
        pub yuv: u32,
        pub pad0: u32,
        pub pad1: u32,
        pub pad2: u32,
    }
    uniform!(group(1), binding(0), SURFACE_LOCALS: SurfaceParams);
    texture!(group(1), binding(1), SURFACE_TEXTURE: Texture2D<f32>);
    texture!(group(1), binding(2), SURFACE_CHROMA_TEXTURE: Texture2D<f32>);
    sampler!(group(1), binding(3), SURFACE_SAMPLER: Sampler);

    #[derive(Wgsl)]
    pub struct SurfaceVarying {
        #[builtin(position)]
        pub position: Vec4f,
        #[location(0)]
        pub texture_position: Vec2f,
        #[location(3)]
        pub clip_distances: Vec4f,
    }

    #[vertex]
    pub fn vs_surface(#[builtin(vertex_index)] vertex_id: u32) -> SurfaceVarying {
        let vertex = unit_vertex(vertex_id);
        SurfaceVarying {
            position: to_device_position(vertex, get!(SURFACE_LOCALS).bounds),
            texture_position: vertex,
            clip_distances: distance_from_clip_rect(
                vertex,
                get!(SURFACE_LOCALS).bounds,
                get!(SURFACE_LOCALS).content_mask,
            ),
        }
    }

    #[fragment]
    pub fn fs_surface(input: SurfaceVarying) -> Vec4f {
        if is_clipped(input.clip_distances) {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        if get!(SURFACE_LOCALS).yuv != 0u32 {
            let y = texture_sample_level(
                SURFACE_TEXTURE,
                SURFACE_SAMPLER,
                input.texture_position,
                0.0,
            )
            .x;
            let chroma = texture_sample_level(
                SURFACE_CHROMA_TEXTURE,
                SURFACE_SAMPLER,
                input.texture_position,
                0.0,
            )
            .xy();
            return vec4f(
                y + 1.4020 * chroma.y - 0.7010,
                y - 0.3441 * chroma.x - 0.7141 * chroma.y + 0.5291,
                y + 1.7720 * chroma.x - 0.8860,
                1.0,
            );
        }
        texture_sample_level(
            SURFACE_TEXTURE,
            SURFACE_SAMPLER,
            input.texture_position,
            0.0,
        )
    }
}

#[wgsl]
pub mod blur {
    use super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct BlurParams {
        pub bounds: Bounds,
        pub content_mask: Bounds,
        pub corner_radii: Vec4f,
        pub direction: Vec2f,
        pub sigma: f32,
        pub opacity: f32,
        pub tap_count: f32,
        pub tap_step: f32,
        pub clip_rounded: f32,
        pub downsample: f32,
    }
    uniform!(group(1), binding(0), BLUR_LOCALS: BlurParams);
    texture!(group(1), binding(1), BLUR_TEXTURE: Texture2D<f32>);
    sampler!(group(1), binding(2), BLUR_SAMPLER: Sampler);

    #[derive(Wgsl)]
    pub struct BlurVarying {
        #[builtin(position)]
        pub position: Vec4f,
        #[location(0)]
        pub uv: Vec2f,
        #[location(3)]
        pub clip_distances: Vec4f,
    }

    #[vertex]
    pub fn vs_blur_fullscreen(#[builtin(vertex_index)] vertex_id: u32) -> BlurVarying {
        let uv = vec2f(
            ((vertex_id << 1u32) & 2u32) as f32,
            (vertex_id & 2u32) as f32,
        );
        BlurVarying {
            position: vec4f(uv.x * 2.0 - 1.0, 1.0 - uv.y * 2.0, 0.0, 1.0),
            uv,
            clip_distances: vec4f(1.0, 1.0, 1.0, 1.0),
        }
    }

    #[fragment]
    pub fn fs_blur_downsample(input: BlurVarying) -> Vec4f {
        if get!(BLUR_LOCALS).downsample > 0.5 {
            let destination = floor(input.position.xy());
            let source_uv = (destination * 2.0 + 1.0) / get!(GLOBALS).viewport_size;
            return texture_sample_level(BLUR_TEXTURE, BLUR_SAMPLER, source_uv, 0.0);
        }
        texture_sample_level(BLUR_TEXTURE, BLUR_SAMPLER, input.uv, 0.0)
    }

    #[fragment]
    pub fn fs_blur(input: BlurVarying) -> Vec4f {
        let sigma = get!(BLUR_LOCALS).sigma;
        let taps = get!(BLUR_LOCALS).tap_count as i32;
        let step = get!(BLUR_LOCALS).tap_step;
        let mut color = vec4f(0.0, 0.0, 0.0, 0.0);
        let mut weight_sum = 0.0;
        let mut i = -taps;
        while i <= taps {
            let offset = i as f32 * step;
            let weight = gaussian(offset, sigma);
            let uv = input.uv + get!(BLUR_LOCALS).direction * offset;
            color = color + texture_sample_level(BLUR_TEXTURE, BLUR_SAMPLER, uv, 0.0) * weight;
            weight_sum += weight;
            i += 1;
        }
        color / max(weight_sum, 0.00001)
    }

    #[vertex]
    pub fn vs_blur_composite(#[builtin(vertex_index)] vertex_id: u32) -> BlurVarying {
        let vertex = unit_vertex(vertex_id);
        BlurVarying {
            position: to_device_position(vertex, get!(BLUR_LOCALS).bounds),
            uv: vertex,
            clip_distances: distance_from_clip_rect(
                vertex,
                get!(BLUR_LOCALS).bounds,
                get!(BLUR_LOCALS).content_mask,
            ),
        }
    }

    #[fragment]
    pub fn fs_blur_composite(input: BlurVarying) -> Vec4f {
        if is_clipped(input.clip_distances) {
            return vec4f(0.0, 0.0, 0.0, 0.0);
        }
        let blur_span = 2.0 * floor(get!(GLOBALS).viewport_size * 0.5);
        let blurred = texture_sample_level(
            BLUR_TEXTURE,
            BLUR_SAMPLER,
            input.position.xy() / blur_span,
            0.0,
        );
        let radii = get!(BLUR_LOCALS).corner_radii;
        let corners = Corners {
            top_left: radii.x,
            top_right: radii.y,
            bottom_right: radii.z,
            bottom_left: radii.w,
        };
        let distance = quad_sdf(input.position.xy(), get!(BLUR_LOCALS).bounds, corners);
        let coverage = select(
            1.0,
            saturate(0.5 - distance),
            get!(BLUR_LOCALS).clip_rounded > 0.5,
        );
        let factor = coverage * get!(BLUR_LOCALS).opacity;
        vec4f(
            blurred.x * factor,
            blurred.y * factor,
            blurred.z * factor,
            blurred.w * factor,
        )
    }
}

/// All standard pipelines share one WGPU shader module so drivers can reuse the
/// parsed common code and compile only each entry point's reachable resources.
#[wgsl]
pub mod base {
    use super::blur::*;
    use super::mono_sprite::*;
    use super::path::*;
    use super::path_rasterization::*;
    use super::poly_sprite::*;
    use super::quad::*;
    use super::shadow::*;
    use super::surface::*;
    use super::underline::*;
}

/// Dual-source LCD glyph pipeline.  Its separate module keeps the shared
/// `group(1), binding(0)` instance-buffer slot legal while retaining the
/// existing `vs_subpixel_sprite` / `fs_subpixel_sprite` entry-point contract.
#[wgsl(skip_validation)]
pub mod subpixel_sprite {
    use super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct SubpixelSprite {
        pub order: u32,
        pub pad: u32,
        pub bounds: Bounds,
        pub content_mask: Bounds,
        pub color: Hsla,
        pub tile: AtlasTile,
        pub transformation: TransformationMatrix,
    }
    storage!(group(1), binding(0), SUBPIXEL_SPRITES: RuntimeArray<SubpixelSprite>);
    texture!(group(1), binding(1), SPRITE_TEXTURE: Texture2D<f32>);
    sampler!(group(1), binding(2), SPRITE_SAMPLER: Sampler);

    #[derive(Wgsl)]
    pub struct SubpixelSpriteOutput {
        #[builtin(position)]
        pub position: Vec4f,
        #[location(0)]
        pub tile_position: Vec2f,
        #[location(1)]
        #[interpolate(flat)]
        pub color: Vec4f,
        #[location(3)]
        pub clip_distances: Vec4f,
    }
    #[derive(Wgsl)]
    pub struct SubpixelSpriteFragmentOutput {
        #[location(0)]
        #[blend_src(0)]
        pub foreground: Vec4f,
        #[location(0)]
        #[blend_src(1)]
        pub alpha: Vec4f,
    }

    pub fn to_tile_position(unit_vertex: Vec2f, tile: AtlasTile) -> Vec2f {
        let atlas_size = texture_dimensions(SPRITE_TEXTURE);
        (vec2f(tile.bounds.origin.x as f32, tile.bounds.origin.y as f32)
            + unit_vertex * vec2f(tile.bounds.size.x as f32, tile.bounds.size.y as f32))
            / vec2f(atlas_size.x as f32, atlas_size.y as f32)
    }

    #[vertex]
    pub fn vs_subpixel_sprite(
        #[builtin(vertex_index)] vertex_id: u32,
        #[builtin(instance_index)] instance_id: u32,
    ) -> SubpixelSpriteOutput {
        let unit_vertex = vec2f((vertex_id & 1u32) as f32, 0.5 * (vertex_id & 2u32) as f32);
        let sprite = get!(SUBPIXEL_SPRITES)[instance_id as usize];
        SubpixelSpriteOutput {
            position: to_device_position_transformed(
                unit_vertex,
                sprite.bounds,
                sprite.transformation,
            ),
            tile_position: to_tile_position(unit_vertex, sprite.tile),
            color: hsla_to_rgba(sprite.color),
            clip_distances: distance_from_clip_rect_transformed(
                unit_vertex,
                sprite.bounds,
                sprite.content_mask,
                sprite.transformation,
            ),
        }
    }

    #[fragment]
    pub fn fs_subpixel_sprite(input: SubpixelSpriteOutput) -> SubpixelSpriteFragmentOutput {
        let mut sample = texture_sample(SPRITE_TEXTURE, SPRITE_SAMPLER, input.tile_position).rgb();
        if get!(GAMMA_PARAMS).is_bgr != 0u32 {
            sample = sample.bgr();
        }
        let alpha_corrected = apply_contrast_and_gamma_correction3(
            sample,
            input.color.rgb(),
            get!(GAMMA_PARAMS).subpixel_enhanced_contrast,
            get!(GAMMA_PARAMS).gamma_ratios,
        );
        if input.clip_distances.x < 0.0
            || input.clip_distances.y < 0.0
            || input.clip_distances.z < 0.0
            || input.clip_distances.w < 0.0
        {
            return SubpixelSpriteFragmentOutput {
                foreground: vec4f(0.0, 0.0, 0.0, 0.0),
                alpha: vec4f(0.0, 0.0, 0.0, 0.0),
            };
        }
        SubpixelSpriteFragmentOutput {
            foreground: vec4f(input.color.x, input.color.y, input.color.z, 1.0),
            alpha: vec4f(
                input.color.w * alpha_corrected.x,
                input.color.w * alpha_corrected.y,
                input.color.w * alpha_corrected.z,
                1.0,
            ),
        }
    }
}

#[cfg(test)]
#[test]
fn validates_subpixel_shader() {
    let generated = subpixel_sprite::WGSL_SOURCE.wgsl_source().unwrap();
    wgsl_rs::validate_wgsl_source(&format!("enable dual_source_blending;\n{generated}")).unwrap();
}
