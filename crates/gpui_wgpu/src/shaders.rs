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

    pub const PI: f32 = 3.141592653589793;
    pub const HALF_TURN_DEGREES: f32 = 180.0;
    pub const FULL_TURN_DEGREES: f32 = 360.0;
    pub const CSS_GRADIENT_OFFSET_DEGREES: f32 = 90.0;
    pub const PIXEL_ANTIALIAS_RADIUS: f32 = 0.5;
    pub const GAUSSIAN_CUTOFF_STANDARD_DEVIATIONS: f32 = 3.0;
    pub const PATTERN_COMPONENT_SCALE: f32 = 255.0;
    pub const PATTERN_PACKING_RADIX: f32 = 65535.0;
    pub const MIN_NORMALIZED_WEIGHT: f32 = 0.00001;
    pub const MIN_PATH_GRADIENT: f32 = 0.001;
    pub const UNDERLINE_WAVE_FREQUENCY: f32 = 2.0;
    pub const UNDERLINE_WAVE_HEIGHT_RATIO: f32 = 0.8;
    pub const GRADIENT_DITHER_SCALE: f32 = 0.6180339887;
    pub const GRADIENT_DITHER_RGB_STRENGTH: f32 = 2.0 / PATTERN_COMPONENT_SCALE;
    pub const GRADIENT_DITHER_ALPHA_STRENGTH: f32 = 3.0 / PATTERN_COMPONENT_SCALE;
    pub const GRADIENT_DITHER_SEED_A: Vec2f = vec2f(12.9898, 78.233);
    pub const GRADIENT_DITHER_SEED_B: Vec2f = vec2f(39.3460, 11.135);
    pub const GRADIENT_DITHER_MULTIPLIER_A: f32 = 43758.5453;
    pub const GRADIENT_DITHER_MULTIPLIER_B: f32 = 24634.6345;
    pub const DIAGONAL_STRIPE_ANGLE: f32 = PI / 4.0;
    pub const REC_601_LUMA_WEIGHTS: Vec3f = vec3f(0.30, 0.59, 0.11);
    pub const LINEAR_RGB_LUMA_WEIGHTS: Vec3f = vec3f(0.2126, 0.7152, 0.0722);
    pub const SRGB_DECODE_CUTOFF: f32 = 0.04045;
    pub const SRGB_ENCODE_CUTOFF: f32 = 0.0031308;
    pub const SRGB_TRANSFER_OFFSET: f32 = 0.055;
    pub const SRGB_TRANSFER_SCALE: f32 = 1.055;
    pub const SRGB_DECODE_EXPONENT: f32 = 2.4;
    pub const SRGB_LINEAR_SCALE: f32 = 12.92;
    pub const ERROR_FUNCTION_LINEAR_COEFFICIENT: f32 = 0.278393;
    pub const ERROR_FUNCTION_QUADRATIC_COEFFICIENT: f32 = 0.230389;
    pub const ERROR_FUNCTION_CUBIC_COEFFICIENT: f32 = 0.000972;
    pub const ERROR_FUNCTION_QUARTIC_COEFFICIENT: f32 = 0.078108;
    pub const DARK_TEXT_CONTRAST_SCALE: f32 = 4.0;
    pub const DARK_TEXT_BRIGHTNESS_CUTOFF: f32 = 0.75;
    pub const LINEAR_SRGB_TO_CONE_RESPONSE: Mat3x3f = mat3x3f(
        vec3f(0.4122214708, 0.2119034982, 0.0883024619),
        vec3f(0.5363325363, 0.6806995451, 0.2817188376),
        vec3f(0.0514459929, 0.1073969566, 0.6299787005),
    );
    pub const CONE_RESPONSE_TO_OKLAB: Mat3x3f = mat3x3f(
        vec3f(0.2104542553, 1.9779984951, 0.0259040371),
        vec3f(0.7936177850, -2.4285922050, 0.7827717662),
        vec3f(-0.0040720468, 0.4505937099, -0.8086757660),
    );
    pub const OKLAB_TO_CONE_RESPONSE: Mat3x3f = mat3x3f(
        vec3f(1.0, 1.0, 1.0),
        vec3f(0.3963377774, -0.1055613458, -0.0894841775),
        vec3f(0.2158037573, -0.0638541728, -1.2914855480),
    );
    pub const CONE_RESPONSE_TO_LINEAR_SRGB: Mat3x3f = mat3x3f(
        vec3f(4.0767416621, -1.2684380046, -0.0041960863),
        vec3f(-3.3077115913, 2.6097574011, -0.7034186147),
        vec3f(0.2309699292, -0.3413193965, 1.7076147010),
    );

    #[repr(u32)]
    #[derive(Clone, Copy, Debug, PartialEq, Eq, Wgsl)]
    pub enum ShaderBool {
        Disabled = 0,
        Enabled = 1,
    }

    #[repr(u32)]
    #[derive(Clone, Copy, Debug, PartialEq, Eq, Wgsl)]
    pub enum BackgroundTag {
        Solid = 0,
        LinearGradient = 1,
        PatternSlash = 2,
        Checkerboard = 3,
    }

    #[repr(u32)]
    #[derive(Clone, Copy, Debug, PartialEq, Eq, Wgsl)]
    pub enum ColorSpace {
        Srgb = 0,
        Oklab = 1,
    }

    #[repr(u32)]
    #[derive(Clone, Copy, Debug, PartialEq, Eq, Wgsl)]
    pub enum BorderStyle {
        Solid = 0,
        Dashed = 1,
    }

    #[repr(u32)]
    #[derive(Clone, Copy, Debug, PartialEq, Eq, Wgsl)]
    pub enum SurfaceColorFormat {
        Rgba = 0,
        Yuv = 1,
    }

    #[repr(u32)]
    #[derive(Clone, Copy, Debug, PartialEq, Eq, Wgsl)]
    pub enum BlurCompositeClip {
        None = 0,
        RoundedBounds = 1,
    }

    #[repr(u32)]
    #[derive(Clone, Copy, Debug, PartialEq, Eq, Wgsl)]
    pub enum DownsampleMode {
        Copy = 0,
        HalfResolution = 1,
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct GlobalUniforms {
        pub viewport_size: Vec2f,
        pub premultiplied_alpha: ShaderBool,
        pub padding: u32,
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct FontRasterizationUniforms {
        pub gamma_ratios: Vec4f,
        pub grayscale_enhanced_contrast: f32,
        pub subpixel_enhanced_contrast: f32,
        pub uses_blue_green_red_subpixel_order: ShaderBool,
        pub padding: u32,
    }

    uniform!(group(0), binding(0), GLOBALS: GlobalUniforms);
    uniform!(group(0), binding(1), FONT_RASTERIZATION: FontRasterizationUniforms);

    #[derive(Clone, Copy, Wgsl)]
    pub struct Bounds {
        pub origin: Vec2f,
        pub size: Vec2f,
    }

    impl Bounds {
        pub fn position(bounds: Bounds, unit_position: Vec2f) -> Vec2f {
            bounds.origin + unit_position * bounds.size
        }

        pub fn half_size(bounds: Bounds) -> Vec2f {
            bounds.size / 2.0
        }

        pub fn center(bounds: Bounds) -> Vec2f {
            bounds.origin + Bounds::half_size(bounds)
        }
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct Corners {
        pub top_left: f32,
        pub top_right: f32,
        pub bottom_right: f32,
        pub bottom_left: f32,
    }

    impl Corners {
        pub fn is_zero(corners: Corners) -> bool {
            corners.top_left == 0.0
                && corners.top_right == 0.0
                && corners.bottom_right == 0.0
                && corners.bottom_left == 0.0
        }
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct Edges {
        pub top: f32,
        pub right: f32,
        pub bottom: f32,
        pub left: f32,
    }

    impl Edges {
        pub fn is_zero(edges: Edges) -> bool {
            edges.top == 0.0 && edges.right == 0.0 && edges.bottom == 0.0 && edges.left == 0.0
        }
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
        pub tag: BackgroundTag,
        pub color_space: ColorSpace,
        pub solid: Hsla,
        pub gradient_angle_or_pattern_height: f32,
        pub colors: [LinearColorStop; 2],
        pub padding: u32,
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

    impl TransformationMatrix {
        pub fn transform_position(transform: TransformationMatrix, position: Vec2f) -> Vec2f {
            transpose(transform.rotation_scale) * position + transform.translation
        }
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct RectangleVertex {
        pub unit_position: Vec2f,
        pub viewport_position: Vec2f,
        pub clip_position: Vec4f,
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct FullscreenVertex {
        pub texture_coordinates: Vec2f,
        pub clip_position: Vec4f,
    }

    pub fn is_enabled(value: ShaderBool) -> bool {
        value == ShaderBool::Enabled
    }

    pub fn transparent() -> Vec4f {
        vec4f(0.0, 0.0, 0.0, 0.0)
    }

    pub fn antialiased_coverage(signed_distance: f32) -> f32 {
        saturate(PIXEL_ANTIALIAS_RADIUS - signed_distance)
    }

    pub fn premultiply(color: Vec4f, coverage: f32) -> Vec4f {
        let alpha = color.w * coverage;
        vec4f(color.x * alpha, color.y * alpha, color.z * alpha, alpha)
    }

    pub fn atlas_texture_coordinates(
        unit_position: Vec2f,
        tile: AtlasTile,
        atlas_size: Vec2u,
    ) -> Vec2f {
        let tile_origin = vec2f(tile.bounds.origin.x as f32, tile.bounds.origin.y as f32);
        let tile_size = vec2f(tile.bounds.size.x as f32, tile.bounds.size.y as f32);
        let texture_size = vec2f(atlas_size.x as f32, atlas_size.y as f32);
        (tile_origin + unit_position * tile_size) / texture_size
    }

    pub fn color_brightness(color: Vec3f) -> f32 {
        dot(color, REC_601_LUMA_WEIGHTS)
    }
    pub fn light_on_dark_contrast(enhanced_contrast: f32, color: Vec3f) -> f32 {
        let darkness = saturate(
            DARK_TEXT_CONTRAST_SCALE
                * (DARK_TEXT_BRIGHTNESS_CUTOFF - color_brightness(color)),
        );
        enhanced_contrast * darkness
    }

    pub fn enhance_contrast<T>(alpha: T, contrast: f32) -> T
    where
        T: Copy
            + std::ops::Mul<f32, Output = T>
            + std::ops::Add<f32, Output = T>
            + std::ops::Div<T, Output = T>,
    {
        alpha * (contrast + 1.0) / (alpha * contrast + 1.0)
    }

    pub fn apply_alpha_correction<T>(alpha: T, brightness: T, gamma_ratios: Vec4f) -> T
    where
        T: Copy
            + std::ops::Mul<f32, Output = T>
            + std::ops::Mul<T, Output = T>
            + std::ops::Add<f32, Output = T>
            + std::ops::Add<T, Output = T>,
        f32: std::ops::Sub<T, Output = T>,
    {
        let brightness_adjustment = brightness * gamma_ratios.x + gamma_ratios.y;
        let correction =
            brightness_adjustment * alpha + (brightness * gamma_ratios.z + gamma_ratios.w);
        alpha + alpha * (1.0 - alpha) * correction
    }
    pub fn apply_contrast_and_gamma_correction(
        sample: f32,
        color: Vec3f,
        enhanced_contrast_factor: f32,
        gamma_ratios: Vec4f,
    ) -> f32 {
        let enhanced_contrast = light_on_dark_contrast(enhanced_contrast_factor, color);
        apply_alpha_correction::<f32>(
            enhance_contrast::<f32>(sample, enhanced_contrast),
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
        let contrasted = enhance_contrast::<Vec3f>(
            sample,
            light_on_dark_contrast(enhanced_contrast_factor, color),
        );
        apply_alpha_correction::<Vec3f>(contrasted, color, gamma_ratios)
    }
    pub fn rectangle_corner(vertex_id: u32) -> Vec2f {
        vec2f((vertex_id & 1u32) as f32, 0.5 * (vertex_id & 2u32) as f32)
    }

    pub fn viewport_to_clip_position(position: Vec2f) -> Vec4f {
        let clip_position =
            position / get!(GLOBALS).viewport_size * vec2f(2.0, -2.0) + vec2f(-1.0, 1.0);
        vec4f(clip_position.x, clip_position.y, 0.0, 1.0)
    }

    pub fn rectangle_vertex(vertex_id: u32, bounds: Bounds) -> RectangleVertex {
        let unit_position = rectangle_corner(vertex_id);
        let viewport_position = Bounds::position(bounds, unit_position);
        RectangleVertex {
            unit_position,
            viewport_position,
            clip_position: viewport_to_clip_position(viewport_position),
        }
    }

    pub fn transformed_rectangle_vertex(
        vertex_id: u32,
        bounds: Bounds,
        transform: TransformationMatrix,
    ) -> RectangleVertex {
        let unit_position = rectangle_corner(vertex_id);
        let viewport_position = TransformationMatrix::transform_position(
            transform,
            Bounds::position(bounds, unit_position),
        );
        RectangleVertex {
            unit_position,
            viewport_position,
            clip_position: viewport_to_clip_position(viewport_position),
        }
    }

    pub fn fullscreen_vertex(vertex_id: u32) -> FullscreenVertex {
        let texture_coordinates = vec2f(
            ((vertex_id << 1u32) & 2u32) as f32,
            (vertex_id & 2u32) as f32,
        );
        FullscreenVertex {
            texture_coordinates,
            clip_position: vec4f(
                texture_coordinates.x * 2.0 - 1.0,
                1.0 - texture_coordinates.y * 2.0,
                0.0,
                1.0,
            ),
        }
    }

    pub fn clip_distances(position: Vec2f, clip_bounds: Bounds) -> Vec4f {
        let distance_from_top_left = position - clip_bounds.origin;
        let distance_from_bottom_right = clip_bounds.origin + clip_bounds.size - position;
        vec4f(
            distance_from_top_left.x,
            distance_from_bottom_right.x,
            distance_from_top_left.y,
            distance_from_bottom_right.y,
        )
    }

    pub fn is_clipped(distances: Vec4f) -> bool {
        distances.x < 0.0 || distances.y < 0.0 || distances.z < 0.0 || distances.w < 0.0
    }

    pub fn unclipped_distances() -> Vec4f {
        vec4f(1.0, 1.0, 1.0, 1.0)
    }
    pub fn srgb_to_linear(srgb: Vec3f) -> Vec3f {
        let cutoff = vec3b(
            srgb.x < SRGB_DECODE_CUTOFF,
            srgb.y < SRGB_DECODE_CUTOFF,
            srgb.z < SRGB_DECODE_CUTOFF,
        );
        let higher = pow(
            (srgb + SRGB_TRANSFER_OFFSET) / SRGB_TRANSFER_SCALE,
            vec3f(
                SRGB_DECODE_EXPONENT,
                SRGB_DECODE_EXPONENT,
                SRGB_DECODE_EXPONENT,
            ),
        );
        select(higher, srgb / SRGB_LINEAR_SCALE, cutoff)
    }
    pub fn linear_to_srgb(linear: Vec3f) -> Vec3f {
        let cutoff = vec3b(
            linear.x < SRGB_ENCODE_CUTOFF,
            linear.y < SRGB_ENCODE_CUTOFF,
            linear.z < SRGB_ENCODE_CUTOFF,
        );
        let inverse_exponent = 1.0 / SRGB_DECODE_EXPONENT;
        let higher = SRGB_TRANSFER_SCALE
            * pow(
                linear,
                vec3f(inverse_exponent, inverse_exponent, inverse_exponent),
            )
            - SRGB_TRANSFER_OFFSET;
        select(higher, linear * SRGB_LINEAR_SCALE, cutoff)
    }
    pub fn linear_to_srgba(color: Vec4f) -> Vec4f {
        let red_green_blue = linear_to_srgb(color.rgb());
        vec4f(
            red_green_blue.x,
            red_green_blue.y,
            red_green_blue.z,
            color.w,
        )
    }
    pub fn srgba_to_linear(color: Vec4f) -> Vec4f {
        let red_green_blue = srgb_to_linear(color.rgb());
        vec4f(
            red_green_blue.x,
            red_green_blue.y,
            red_green_blue.z,
            color.w,
        )
    }
    pub fn hue_to_unit_rgb(hue: f32) -> Vec3f {
        let phases = fract(vec3f(hue, hue + 2.0 / 3.0, hue + 1.0 / 3.0));
        saturate(abs(phases * 6.0 - 3.0) - 1.0)
    }

    pub fn hsla_to_rgba(hsla: Hsla) -> Vec4f {
        let chroma = hsla.s * (1.0 - abs(2.0 * hsla.l - 1.0));
        let red_green_blue = (hue_to_unit_rgb(hsla.h) - 0.5) * chroma + hsla.l;
        vec4f(
            red_green_blue.x,
            red_green_blue.y,
            red_green_blue.z,
            hsla.a,
        )
    }
    pub fn linear_srgb_to_oklab(color: Vec4f) -> Vec4f {
        let cone_response = LINEAR_SRGB_TO_CONE_RESPONSE * color.rgb();
        let cube_root = vec3f(1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0);
        let oklab = CONE_RESPONSE_TO_OKLAB * pow(cone_response, cube_root);
        vec4f(oklab.x, oklab.y, oklab.z, color.w)
    }
    pub fn oklab_to_linear_srgb(color: Vec4f) -> Vec4f {
        let cone_root = OKLAB_TO_CONE_RESPONSE * color.rgb();
        let cone_response = cone_root * cone_root * cone_root;
        let linear_srgb = CONE_RESPONSE_TO_LINEAR_SRGB * cone_response;
        vec4f(linear_srgb.x, linear_srgb.y, linear_srgb.z, color.w)
    }
    pub fn over(below: Vec4f, above: Vec4f) -> Vec4f {
        let alpha = above.w + below.w * (1.0 - above.w);
        if alpha == 0.0 {
            return transparent();
        }
        let red_green_blue =
            (above.rgb() * above.w + below.rgb() * below.w * (1.0 - above.w)) / alpha;
        vec4f(
            red_green_blue.x,
            red_green_blue.y,
            red_green_blue.z,
            alpha,
        )
    }
    pub fn gaussian(position: f32, standard_deviation: f32) -> f32 {
        let variance = standard_deviation * standard_deviation;
        exp(-(position * position) / (2.0 * variance))
            / (sqrt(2.0 * PI) * standard_deviation)
    }
    pub fn approximate_error_function(value: Vec2f) -> Vec2f {
        let signs = sign(value);
        let absolute_value = abs(value);
        let polynomial = 1.0
            + absolute_value
                * (ERROR_FUNCTION_LINEAR_COEFFICIENT
                    + absolute_value
                        * (ERROR_FUNCTION_QUADRATIC_COEFFICIENT
                            + absolute_value
                                * (ERROR_FUNCTION_CUBIC_COEFFICIENT
                                    + absolute_value * ERROR_FUNCTION_QUARTIC_COEFFICIENT)));
        let polynomial_squared = polynomial * polynomial;
        signs - signs / (polynomial_squared * polynomial_squared)
    }
    pub fn integrated_rounded_rectangle_coverage(
        horizontal_position: f32,
        vertical_position: f32,
        standard_deviation: f32,
        corner_radius: f32,
        half_size: Vec2f,
    ) -> f32 {
        let distance_beyond_corner = min(
            half_size.y - corner_radius - abs(vertical_position),
            0.0,
        );
        let curved_extent = half_size.x - corner_radius
            + sqrt(max(
                0.0,
                corner_radius * corner_radius
                    - distance_beyond_corner * distance_beyond_corner,
            ));
        let integration_bounds = horizontal_position + vec2f(-curved_extent, curved_extent);
        let normalized_bounds = integration_bounds * (sqrt(0.5) / standard_deviation);
        let integral = 0.5 + 0.5 * approximate_error_function(normalized_bounds);
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
    pub fn rounded_rectangle_signed_distance_from_corner(
        corner_center_to_point: Vec2f,
        corner_radius: f32,
    ) -> f32 {
        if corner_radius == 0.0 {
            max(corner_center_to_point.x, corner_center_to_point.y)
        } else {
            length(max(vec2f(0.0, 0.0), corner_center_to_point))
                + min(0.0, max(corner_center_to_point.x, corner_center_to_point.y))
                - corner_radius
        }
    }
    pub fn rounded_rectangle_signed_distance(
        point: Vec2f,
        bounds: Bounds,
        corner_radii: Corners,
    ) -> f32 {
        let half_size = Bounds::half_size(bounds);
        let center_to_point = point - Bounds::center(bounds);
        let corner_radius = pick_corner_radius(center_to_point, corner_radii);
        rounded_rectangle_signed_distance_from_corner(
            abs(center_to_point) - half_size + corner_radius,
            corner_radius,
        )
    }
    pub fn blend_color(color: Vec4f, alpha_factor: f32) -> Vec4f {
        let alpha = color.w * alpha_factor;
        let multiplier = select(
            1.0,
            alpha,
            is_enabled(get!(GLOBALS).premultiplied_alpha),
        );
        vec4f(
            color.x * multiplier,
            color.y * multiplier,
            color.z * multiplier,
            alpha,
        )
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct PreparedBackground {
        pub solid: Vec4f,
        pub color0: Vec4f,
        pub color1: Vec4f,
    }

    pub fn prepare_background(background: Background) -> PreparedBackground {
        let mut prepared = PreparedBackground {
            solid: transparent(),
            color0: transparent(),
            color1: transparent(),
        };

        if background.tag == BackgroundTag::LinearGradient {
            prepared.color0 = hsla_to_rgba(background.colors[0usize].color);
            prepared.color1 = hsla_to_rgba(background.colors[1usize].color);
            if background.color_space == ColorSpace::Srgb {
                prepared.color0 = linear_to_srgba(prepared.color0);
                prepared.color1 = linear_to_srgba(prepared.color1);
            } else {
                prepared.color0 = linear_srgb_to_oklab(prepared.color0);
                prepared.color1 = linear_srgb_to_oklab(prepared.color1);
            }
        } else {
            prepared.solid = hsla_to_rgba(background.solid);
        }
        prepared
    }

    pub fn linear_gradient_ratio(background: Background, position: Vec2f, bounds: Bounds) -> f32 {
        let radians = (background.gradient_angle_or_pattern_height % FULL_TURN_DEGREES
            - CSS_GRADIENT_OFFSET_DEGREES)
            * PI
            / HALF_TURN_DEGREES;
        let mut direction = vec2f(cos(radians), sin(radians));
        if bounds.size.x > bounds.size.y {
            direction.y *= bounds.size.y / bounds.size.x;
        } else {
            direction.x *= bounds.size.x / bounds.size.y;
        }

        let half_size = Bounds::half_size(bounds);
        let mut ratio = dot(position - Bounds::center(bounds), direction) / length(direction);
        if abs(direction.x) > abs(direction.y) {
            ratio = (ratio + half_size.x) / bounds.size.x;
        } else {
            ratio = (ratio + half_size.y) / bounds.size.y;
        }

        let first_stop = background.colors[0usize].percentage;
        let last_stop = background.colors[1usize].percentage;
        saturate((ratio - first_stop) / (last_stop - first_stop))
    }

    pub fn gradient_dither(position: Vec2f) -> Vec4f {
        let seed = position * GRADIENT_DITHER_SCALE;
        let noise_a = fract(sin(dot(seed, GRADIENT_DITHER_SEED_A)) * GRADIENT_DITHER_MULTIPLIER_A);
        let noise_b = fract(sin(dot(seed, GRADIENT_DITHER_SEED_B)) * GRADIENT_DITHER_MULTIPLIER_B);
        let triangular_noise = noise_a + noise_b - 1.0;
        vec4f(
            triangular_noise * GRADIENT_DITHER_RGB_STRENGTH,
            triangular_noise * GRADIENT_DITHER_RGB_STRENGTH,
            triangular_noise * GRADIENT_DITHER_RGB_STRENGTH,
            triangular_noise * GRADIENT_DITHER_ALPHA_STRENGTH,
        )
    }

    pub fn linear_gradient_color(
        background: Background,
        position: Vec2f,
        bounds: Bounds,
        prepared: PreparedBackground,
    ) -> Vec4f {
        let ratio = linear_gradient_ratio(background, position, bounds);
        let ratio4 = vec4f(ratio, ratio, ratio, ratio);
        let interpolated = mix(prepared.color0, prepared.color1, ratio4);
        let color = if background.color_space == ColorSpace::Oklab {
            oklab_to_linear_srgb(interpolated)
        } else {
            srgba_to_linear(interpolated)
        };
        color + gradient_dither(position)
    }

    pub fn slash_pattern_color(
        background: Background,
        position: Vec2f,
        bounds: Bounds,
        solid: Vec4f,
    ) -> Vec4f {
        let encoded = background.gradient_angle_or_pattern_height;
        let pattern_width = (encoded / PATTERN_PACKING_RADIX) / PATTERN_COMPONENT_SCALE;
        let pattern_interval = (encoded % PATTERN_PACKING_RADIX) / PATTERN_COMPONENT_SCALE;
        let pattern_height = pattern_width + pattern_interval;
        let period = pattern_height * sin(DIAGONAL_STRIPE_ANGLE);
        let rotation = mat2x2f(
            vec2f(cos(DIAGONAL_STRIPE_ANGLE), -sin(DIAGONAL_STRIPE_ANGLE)),
            vec2f(sin(DIAGONAL_STRIPE_ANGLE), cos(DIAGONAL_STRIPE_ANGLE)),
        );
        let pattern = (rotation * (position - bounds.origin)).x % period;
        let distance = min(pattern, period - pattern)
            - period * (pattern_width / pattern_height) / 2.0;
        let mut color = solid;
        color.w *= antialiased_coverage(distance);
        color
    }

    pub fn checkerboard_color(
        background: Background,
        position: Vec2f,
        bounds: Bounds,
        solid: Vec4f,
    ) -> Vec4f {
        let relative = position - bounds.origin;
        let square_size = background.gradient_angle_or_pattern_height;
        let colored = (floor(relative.x / square_size) + floor(relative.y / square_size)) % 2.0;
        let mut color = solid;
        color.w *= saturate(colored);
        color
    }

    pub fn background_color(
        background: Background,
        position: Vec2f,
        bounds: Bounds,
        prepared: PreparedBackground,
    ) -> Vec4f {
        #[wgsl_allow(non_literal_match_statement_patterns)]
        match background.tag {
            BackgroundTag::Solid => prepared.solid,
            BackgroundTag::LinearGradient => {
                linear_gradient_color(background, position, bounds, prepared)
            }
            BackgroundTag::PatternSlash => {
                slash_pattern_color(background, position, bounds, prepared.solid)
            }
            BackgroundTag::Checkerboard => {
                checkerboard_color(background, position, bounds, prepared.solid)
            }
        }
    }
    pub fn corner_dash_velocity(first: f32, second: f32) -> f32 {
        if first == 0.0 {
            second
        } else if second == 0.0 {
            first
        } else {
            min(first, second)
        }
    }
    pub fn signed_modulo(value: f32, modulus: f32) -> f32 {
        value - modulus * trunc(value / modulus)
    }
    pub fn dash_coverage(
        position: f32,
        period: f32,
        dash_length: f32,
        dash_velocity: f32,
    ) -> f32 {
        let half_period = period / 2.0;
        let half_dash_length = dash_length / 2.0;
        let centered = signed_modulo(
            position + half_period - half_dash_length,
            period,
        ) - half_period;
        let signed_distance = abs(centered) - half_dash_length;
        antialiased_coverage(signed_distance / dash_velocity)
    }
    pub fn quarter_ellipse_signed_distance(point: Vec2f, radii: Vec2f) -> f32 {
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
        pub border_style: BorderStyle,
        pub bounds: Bounds,
        pub content_mask: Bounds,
        pub background: Background,
        pub border_color: Hsla,
        pub corner_radii: Corners,
        pub border_widths: Edges,
    }
    storage!(group(1), binding(0), QUADS: RuntimeArray<Quad>);

    pub const DASH_LENGTH_PER_BORDER_WIDTH: f32 = 2.0;
    pub const DASH_GAP_PER_BORDER_WIDTH: f32 = 1.0;
    pub const DEFINITELY_OUTSIDE_INNER_BORDER: f32 = -1.0;

    #[derive(Clone, Copy, Wgsl)]
    pub struct QuadGeometry {
        pub point: Vec2f,
        pub center_to_point: Vec2f,
        pub corner_radius: f32,
        pub corner_center_to_point: Vec2f,
        pub reduced_border: Vec2f,
        pub straight_border_inner_corner_to_point: Vec2f,
        pub near_rounded_corner: bool,
        pub unrounded: bool,
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct BorderDistances {
        pub outer: f32,
        pub inner: f32,
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct DashPosition {
        pub position: f32,
        pub perimeter: f32,
        pub velocity: f32,
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct RoundedDashLayout {
        pub side_velocities: Edges,
        pub corner_velocities: Corners,
        pub right_start: f32,
        pub bottom_right_start: f32,
        pub bottom_left_start: f32,
        pub left_start: f32,
        pub top_left_start: f32,
        pub perimeter: f32,
    }

    pub fn quad_geometry(quad: Quad, position: Vec2f) -> QuadGeometry {
        let half_size = Bounds::half_size(quad.bounds);
        let point = position - quad.bounds.origin;
        let center_to_point = point - half_size;
        let corner_radius = pick_corner_radius(center_to_point, quad.corner_radii);
        let corner_to_point = abs(center_to_point) - half_size;
        let corner_center_to_point = corner_to_point + corner_radius;
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
            select(
                border.x,
                -PIXEL_ANTIALIAS_RADIUS,
                border.x == 0.0,
            ),
            select(
                border.y,
                -PIXEL_ANTIALIAS_RADIUS,
                border.y == 0.0,
            ),
        );
        QuadGeometry {
            point,
            center_to_point,
            corner_radius,
            corner_center_to_point,
            reduced_border,
            straight_border_inner_corner_to_point: corner_to_point + reduced_border,
            near_rounded_corner: corner_center_to_point.x >= 0.0
                && corner_center_to_point.y >= 0.0,
            unrounded: Corners::is_zero(quad.corner_radii),
        }
    }

    pub fn is_unaffected_background(geometry: QuadGeometry) -> bool {
        geometry.straight_border_inner_corner_to_point.x < -PIXEL_ANTIALIAS_RADIUS
            && geometry.straight_border_inner_corner_to_point.y < -PIXEL_ANTIALIAS_RADIUS
            && !geometry.near_rounded_corner
    }

    pub fn inner_border_signed_distance(
        geometry: QuadGeometry,
        outer_signed_distance: f32,
    ) -> f32 {
        if geometry.corner_center_to_point.x <= 0.0
            || geometry.corner_center_to_point.y <= 0.0
        {
            return -max(
                geometry.straight_border_inner_corner_to_point.x,
                geometry.straight_border_inner_corner_to_point.y,
            );
        }
        if geometry.straight_border_inner_corner_to_point.x > 0.0
            || geometry.straight_border_inner_corner_to_point.y > 0.0
        {
            return DEFINITELY_OUTSIDE_INNER_BORDER;
        }
        if geometry.reduced_border.x == geometry.reduced_border.y {
            return -(outer_signed_distance + geometry.reduced_border.x);
        }

        let ellipse_radii = max(
            vec2f(0.0, 0.0),
            geometry.corner_radius - geometry.reduced_border,
        );
        quarter_ellipse_signed_distance(geometry.corner_center_to_point, ellipse_radii)
    }

    pub fn border_distances(geometry: QuadGeometry) -> BorderDistances {
        let outer = rounded_rectangle_signed_distance_from_corner(
            geometry.corner_center_to_point,
            geometry.corner_radius,
        );
        BorderDistances {
            outer,
            inner: inner_border_signed_distance(geometry, outer),
        }
    }

    pub fn dash_velocity(border_width: f32) -> f32 {
        if border_width <= 0.0 {
            0.0
        } else {
            1.0 / (DASH_LENGTH_PER_BORDER_WIDTH + DASH_GAP_PER_BORDER_WIDTH) / border_width
        }
    }

    pub fn straight_dash_position(quad: Quad, geometry: QuadGeometry) -> DashPosition {
        let horizontal = geometry.corner_center_to_point.x < geometry.corner_center_to_point.y;
        let border_width = select(
            max(quad.border_widths.right, quad.border_widths.left),
            max(quad.border_widths.bottom, quad.border_widths.top),
            horizontal,
        );
        let velocity = dash_velocity(border_width);
        DashPosition {
            position: select(geometry.point.y, geometry.point.x, horizontal) * velocity,
            perimeter: select(quad.bounds.size.y, quad.bounds.size.x, horizontal) * velocity,
            velocity,
        }
    }

    pub fn side_dash_velocities(border_widths: Edges) -> Edges {
        Edges {
            top: dash_velocity(border_widths.top),
            right: dash_velocity(border_widths.right),
            bottom: dash_velocity(border_widths.bottom),
            left: dash_velocity(border_widths.left),
        }
    }

    pub fn straight_side_dash_lengths(
        bounds: Bounds,
        radii: Corners,
        velocities: Edges,
    ) -> Edges {
        Edges {
            top: (bounds.size.x - radii.top_left - radii.top_right) * velocities.top,
            right: (bounds.size.y - radii.top_right - radii.bottom_right) * velocities.right,
            bottom: (bounds.size.x - radii.bottom_right - radii.bottom_left) * velocities.bottom,
            left: (bounds.size.y - radii.bottom_left - radii.top_left) * velocities.left,
        }
    }

    pub fn corner_dash_velocities(side_velocities: Edges) -> Corners {
        Corners {
            top_left: corner_dash_velocity(side_velocities.top, side_velocities.left),
            top_right: corner_dash_velocity(side_velocities.top, side_velocities.right),
            bottom_right: corner_dash_velocity(side_velocities.bottom, side_velocities.right),
            bottom_left: corner_dash_velocity(side_velocities.bottom, side_velocities.left),
        }
    }

    pub fn corner_dash_lengths(radii: Corners, velocities: Corners) -> Corners {
        let quarter_turn = PI / 2.0;
        Corners {
            top_left: radii.top_left * quarter_turn * velocities.top_left,
            top_right: radii.top_right * quarter_turn * velocities.top_right,
            bottom_right: radii.bottom_right * quarter_turn * velocities.bottom_right,
            bottom_left: radii.bottom_left * quarter_turn * velocities.bottom_left,
        }
    }

    pub fn rounded_dash_layout(quad: Quad) -> RoundedDashLayout {
        let side_velocities = side_dash_velocities(quad.border_widths);
        let side_lengths =
            straight_side_dash_lengths(quad.bounds, quad.corner_radii, side_velocities);
        let corner_velocities = corner_dash_velocities(side_velocities);
        let corner_lengths = corner_dash_lengths(quad.corner_radii, corner_velocities);
        let right_start = side_lengths.top + corner_lengths.top_right;
        let bottom_right_start = right_start + side_lengths.right;
        let bottom_left_start =
            bottom_right_start + corner_lengths.bottom_right + side_lengths.bottom;
        let left_start = bottom_left_start + corner_lengths.bottom_left;
        let top_left_start = left_start + side_lengths.left;
        RoundedDashLayout {
            side_velocities,
            corner_velocities,
            right_start,
            bottom_right_start,
            bottom_left_start,
            left_start,
            top_left_start,
            perimeter: top_left_start + corner_lengths.top_left,
        }
    }

    pub fn rounded_dash_position(quad: Quad, geometry: QuadGeometry) -> DashPosition {
        let radii = quad.corner_radii;
        let layout = rounded_dash_layout(quad);
        let horizontal = geometry.corner_center_to_point.x < geometry.corner_center_to_point.y;
        let on_right = geometry.center_to_point.x >= 0.0;
        let on_bottom = geometry.center_to_point.y >= 0.0;

        let top_position =
            (geometry.point.x - radii.top_left) * layout.side_velocities.top;
        let right_position = layout.right_start
            + (geometry.point.y - radii.top_right) * layout.side_velocities.right;
        let bottom_position = layout.bottom_left_start
            - (geometry.point.x - radii.bottom_left) * layout.side_velocities.bottom;
        let left_position = layout.top_left_start
            - (geometry.point.y - radii.top_left) * layout.side_velocities.left;
        let horizontal_position = select(top_position, bottom_position, on_bottom);
        let vertical_position = select(left_position, right_position, on_right);
        let side_position = select(vertical_position, horizontal_position, horizontal);
        let horizontal_velocity = select(
            layout.side_velocities.top,
            layout.side_velocities.bottom,
            on_bottom,
        );
        let vertical_velocity = select(
            layout.side_velocities.left,
            layout.side_velocities.right,
            on_right,
        );
        let side_velocity = select(vertical_velocity, horizontal_velocity, horizontal);

        if geometry.near_rounded_corner {
            let corner_position = atan2(
                geometry.corner_center_to_point.y,
                geometry.corner_center_to_point.x,
            ) * geometry.corner_radius;
            let top_right_position = layout.right_start
                - corner_position * layout.corner_velocities.top_right;
            let bottom_right_position = layout.bottom_right_start
                + corner_position * layout.corner_velocities.bottom_right;
            let bottom_left_position = layout.left_start
                - corner_position * layout.corner_velocities.bottom_left;
            let top_left_position = layout.top_left_start
                + corner_position * layout.corner_velocities.top_left;
            let right_position = select(top_right_position, bottom_right_position, on_bottom);
            let left_position = select(top_left_position, bottom_left_position, on_bottom);
            let position = select(left_position, right_position, on_right);
            let right_velocity = select(
                layout.corner_velocities.top_right,
                layout.corner_velocities.bottom_right,
                on_bottom,
            );
            let left_velocity = select(
                layout.corner_velocities.top_left,
                layout.corner_velocities.bottom_left,
                on_bottom,
            );
            return DashPosition {
                position,
                perimeter: layout.perimeter,
                velocity: select(left_velocity, right_velocity, on_right),
            };
        }

        DashPosition {
            position: side_position,
            perimeter: layout.perimeter,
            velocity: side_velocity,
        }
    }

    pub fn dashed_border_alpha(quad: Quad, geometry: QuadGeometry) -> f32 {
        let dash = if geometry.unrounded {
            straight_dash_position(quad, geometry)
        } else {
            rounded_dash_position(quad, geometry)
        };
        let dash_period_per_width = DASH_LENGTH_PER_BORDER_WIDTH + DASH_GAP_PER_BORDER_WIDTH;
        let dash_length = DASH_LENGTH_PER_BORDER_WIDTH / dash_period_per_width;
        let perimeter = dash.perimeter - select(0.0, dash_length, geometry.unrounded);

        if perimeter >= 1.0 {
            let period = perimeter / floor(perimeter);
            dash_coverage(dash.position, period, dash_length, dash.velocity)
        } else if geometry.unrounded && perimeter > dash_length {
            dash_coverage(dash.position, perimeter, dash_length, dash.velocity)
        } else {
            1.0
        }
    }

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
        let quad = get!(QUADS)[instance_id as usize];
        let vertex = rectangle_vertex(vertex_id, quad.bounds);
        let gradient = prepare_background(quad.background);
        QuadVarying {
            position: vertex.clip_position,
            border_color: hsla_to_rgba(quad.border_color),
            quad_id: instance_id,
            clip_distances: clip_distances(vertex.viewport_position, quad.content_mask),
            background_solid: gradient.solid,
            background_color0: gradient.color0,
            background_color1: gradient.color1,
        }
    }

    #[fragment]
    pub fn fs_quad(input: QuadVarying) -> Vec4f {
        if is_clipped(input.clip_distances) {
            return transparent();
        }
        let quad = get!(QUADS)[input.quad_id as usize];
        let background_color = background_color(
            quad.background,
            input.position.xy(),
            quad.bounds,
            PreparedBackground {
                solid: input.background_solid,
                color0: input.background_color0,
                color1: input.background_color1,
            },
        );
        if Edges::is_zero(quad.border_widths) && Corners::is_zero(quad.corner_radii) {
            return blend_color(background_color, 1.0);
        }

        let geometry = quad_geometry(quad, input.position.xy());
        if is_unaffected_background(geometry) {
            return blend_color(background_color, 1.0);
        }

        let distances = border_distances(geometry);
        let mut color = background_color;
        if max(distances.inner, distances.outer) < PIXEL_ANTIALIAS_RADIUS {
            let mut border_color = input.border_color;
            if quad.border_style == BorderStyle::Dashed {
                border_color.w *= dashed_border_alpha(quad, geometry);
            }
            let blended_border = over(background_color, border_color);
            let factor = antialiased_coverage(distances.inner);
            color = mix(
                background_color,
                blended_border,
                vec4f(factor, factor, factor, factor),
            );
        }
        blend_color(color, antialiased_coverage(distances.outer))
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
        pub inset: ShaderBool,
        pub padding: u32,
    }
    storage!(group(1), binding(0), SHADOWS: RuntimeArray<Shadow>);

    pub const SHADOW_INTEGRATION_SAMPLE_COUNT: i32 = 4;

    pub fn shadow_geometry(shadow: Shadow) -> Bounds {
        if is_enabled(shadow.inset) {
            return shadow.element_bounds;
        }

        let margin = GAUSSIAN_CUTOFF_STANDARD_DEVIATIONS * shadow.blur_radius;
        Bounds {
            origin: shadow.bounds.origin - vec2f(margin, margin),
            size: shadow.bounds.size + vec2f(2.0 * margin, 2.0 * margin),
        }
    }

    pub fn blurred_shadow_coverage(shadow: Shadow, position: Vec2f) -> f32 {
        let half_size = Bounds::half_size(shadow.bounds);
        let center_to_point = position - Bounds::center(shadow.bounds);
        let corner_radius = pick_corner_radius(center_to_point, shadow.corner_radii);
        let vertical_minimum = center_to_point.y - half_size.y;
        let vertical_maximum = center_to_point.y + half_size.y;
        let integration_radius = GAUSSIAN_CUTOFF_STANDARD_DEVIATIONS * shadow.blur_radius;
        let integration_start = clamp(-integration_radius, vertical_minimum, vertical_maximum);
        let integration_end = clamp(integration_radius, vertical_minimum, vertical_maximum);
        let sample_step =
            (integration_end - integration_start) / SHADOW_INTEGRATION_SAMPLE_COUNT as f32;

        let mut coverage = 0.0;
        let mut sample_index = 0;
        let mut sample_position = integration_start + sample_step * 0.5;
        while sample_index < SHADOW_INTEGRATION_SAMPLE_COUNT {
            coverage += integrated_rounded_rectangle_coverage(
                center_to_point.x,
                center_to_point.y - sample_position,
                shadow.blur_radius,
                corner_radius,
                half_size,
            ) * gaussian(sample_position, shadow.blur_radius)
                * sample_step;
            sample_position += sample_step;
            sample_index += 1;
        }
        coverage
    }

    pub fn shadow_coverage(shadow: Shadow, position: Vec2f) -> f32 {
        let mut coverage = if shadow.blur_radius == 0.0 {
            antialiased_coverage(rounded_rectangle_signed_distance(
                position,
                shadow.bounds,
                shadow.corner_radii,
            ))
        } else {
            blurred_shadow_coverage(shadow, position)
        };

        if is_enabled(shadow.inset) {
            coverage = (1.0 - coverage)
                * antialiased_coverage(rounded_rectangle_signed_distance(
                    position,
                    shadow.element_bounds,
                    shadow.element_corner_radii,
                ));
        }
        coverage
    }

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
        let shadow = get!(SHADOWS)[instance_id as usize];
        let geometry = shadow_geometry(shadow);
        let vertex = rectangle_vertex(vertex_id, geometry);
        ShadowVarying {
            position: vertex.clip_position,
            color: hsla_to_rgba(shadow.color),
            shadow_id: instance_id,
            clip_distances: clip_distances(vertex.viewport_position, shadow.content_mask),
        }
    }

    #[fragment]
    pub fn fs_shadow(input: ShadowVarying) -> Vec4f {
        if is_clipped(input.clip_distances) {
            return transparent();
        }
        let shadow = get!(SHADOWS)[input.shadow_id as usize];
        blend_color(input.color, shadow_coverage(shadow, input.position.xy()))
    }
}

#[wgsl]
pub mod path_rasterization {
    use super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct PathRasterizationVertex {
        pub xy_position: Vec2f,
        pub curve_position: Vec2f,
        pub color: Background,
        pub bounds: Bounds,
    }
    storage!(group(1), binding(0), PATH_VERTICES: RuntimeArray<PathRasterizationVertex>);

    pub fn quadratic_bezier_coverage(curve_position: Vec2f) -> f32 {
        let horizontal_derivative = dpdx(curve_position);
        let vertical_derivative = dpdy(curve_position);
        let horizontal_gradient = vec2f(horizontal_derivative.x, vertical_derivative.x);
        if length(horizontal_gradient) < MIN_PATH_GRADIENT {
            return 1.0;
        }

        let implicit_gradient = 2.0 * curve_position.xx() * horizontal_gradient
            - vec2f(horizontal_derivative.y, vertical_derivative.y);
        let implicit_value = curve_position.x * curve_position.x - curve_position.y;
        antialiased_coverage(implicit_value / length(implicit_gradient))
    }

    #[derive(Wgsl)]
    pub struct PathRasterizationVarying {
        #[builtin(position)]
        pub position: Vec4f,
        #[location(0)]
        pub curve_position: Vec2f,
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
            position: viewport_to_clip_position(vertex.xy_position),
            curve_position: vertex.curve_position,
            vertex_id,
            clip_distances: clip_distances(vertex.xy_position, vertex.bounds),
        }
    }

    #[fragment]
    pub fn fs_path_rasterization(input: PathRasterizationVarying) -> Vec4f {
        let coverage = quadratic_bezier_coverage(input.curve_position);
        if is_clipped(input.clip_distances) {
            return transparent();
        }
        let vertex = get!(PATH_VERTICES)[input.vertex_id as usize];
        let color = background_color(
            vertex.color,
            input.position.xy(),
            vertex.bounds,
            prepare_background(vertex.color),
        );
        premultiply(color, coverage)
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
        let sprite = get!(PATH_SPRITES)[instance_id as usize];
        let vertex = rectangle_vertex(vertex_id, sprite.bounds);
        PathVarying {
            position: vertex.clip_position,
            texture_coords: vertex.viewport_position / get!(GLOBALS).viewport_size,
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
        pub padding: u32,
        pub bounds: Bounds,
        pub content_mask: Bounds,
        pub color: Hsla,
        pub thickness: f32,
        pub wavy: ShaderBool,
    }
    storage!(group(1), binding(0), UNDERLINES: RuntimeArray<Underline>);

    pub fn wavy_underline_coverage(underline: Underline, position: Vec2f) -> f32 {
        let normalized_position = (position - underline.bounds.origin) / underline.bounds.size.y
            - vec2f(0.0, 0.5);
        let angular_frequency = PI * UNDERLINE_WAVE_FREQUENCY * underline.thickness
            / underline.bounds.size.y;
        let amplitude = underline.thickness * UNDERLINE_WAVE_HEIGHT_RATIO
            / underline.bounds.size.y;
        let wave_height = sin(normalized_position.x * angular_frequency) * amplitude;
        let wave_slope =
            cos(normalized_position.x * angular_frequency) * amplitude * angular_frequency;
        let signed_distance = (normalized_position.y - wave_height)
            / sqrt(1.0 + wave_slope * wave_slope)
            * underline.bounds.size.y;
        let stroke_distance = abs(signed_distance) - underline.thickness * 0.5;
        antialiased_coverage(stroke_distance)
    }

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
        let underline = get!(UNDERLINES)[instance_id as usize];
        let vertex = rectangle_vertex(vertex_id, underline.bounds);
        UnderlineVarying {
            position: vertex.clip_position,
            color: hsla_to_rgba(underline.color),
            underline_id: instance_id,
            clip_distances: clip_distances(vertex.viewport_position, underline.content_mask),
        }
    }

    #[fragment]
    pub fn fs_underline(input: UnderlineVarying) -> Vec4f {
        if is_clipped(input.clip_distances) {
            return transparent();
        }
        let underline = get!(UNDERLINES)[input.underline_id as usize];
        if !is_enabled(underline.wavy) {
            return blend_color(input.color, 1.0);
        }
        blend_color(
            input.color,
            wavy_underline_coverage(underline, input.position.xy()),
        )
    }
}

#[wgsl]
pub mod monochrome_sprite {
    use super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct MonochromeSprite {
        pub order: u32,
        pub padding: u32,
        pub bounds: Bounds,
        pub content_mask: Bounds,
        pub color: Hsla,
        pub tile: AtlasTile,
        pub transformation: TransformationMatrix,
    }
    storage!(group(1), binding(0), MONOCHROME_SPRITES: RuntimeArray<MonochromeSprite>);
    texture!(group(1), binding(1), MONOCHROME_TEXTURE: Texture2D<f32>);
    sampler!(group(1), binding(2), MONOCHROME_SAMPLER: Sampler);

    #[derive(Wgsl)]
    pub struct MonochromeSpriteVarying {
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

    #[vertex]
    pub fn vs_mono_sprite(
        #[builtin(vertex_index)] vertex_id: u32,
        #[builtin(instance_index)] instance_id: u32,
    ) -> MonochromeSpriteVarying {
        let sprite = get!(MONOCHROME_SPRITES)[instance_id as usize];
        let vertex = transformed_rectangle_vertex(vertex_id, sprite.bounds, sprite.transformation);
        MonochromeSpriteVarying {
            position: vertex.clip_position,
            tile_position: atlas_texture_coordinates(
                vertex.unit_position,
                sprite.tile,
                texture_dimensions(MONOCHROME_TEXTURE),
            ),
            color: hsla_to_rgba(sprite.color),
            clip_distances: clip_distances(vertex.viewport_position, sprite.content_mask),
        }
    }

    #[fragment]
    pub fn fs_mono_sprite(input: MonochromeSpriteVarying) -> Vec4f {
        let sample = texture_sample(
            MONOCHROME_TEXTURE,
            MONOCHROME_SAMPLER,
            input.tile_position,
        )
        .x;
        let corrected = apply_contrast_and_gamma_correction(
            sample,
            input.color.rgb(),
            get!(FONT_RASTERIZATION).grayscale_enhanced_contrast,
            get!(FONT_RASTERIZATION).gamma_ratios,
        );
        if is_clipped(input.clip_distances) {
            return transparent();
        }
        blend_color(input.color, corrected)
    }
}

#[wgsl]
pub mod polychrome_sprite {
    use super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct PolychromeSprite {
        pub order: u32,
        pub padding: u32,
        pub grayscale: ShaderBool,
        pub opacity: f32,
        pub bounds: Bounds,
        pub content_mask: Bounds,
        pub corner_radii: Corners,
        pub tile: AtlasTile,
    }
    storage!(group(1), binding(0), POLYCHROME_SPRITES: RuntimeArray<PolychromeSprite>);
    texture!(group(1), binding(1), POLYCHROME_TEXTURE: Texture2D<f32>);
    sampler!(group(1), binding(2), POLYCHROME_SAMPLER: Sampler);

    #[derive(Wgsl)]
    pub struct PolychromeSpriteVarying {
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

    #[vertex]
    pub fn vs_poly_sprite(
        #[builtin(vertex_index)] vertex_id: u32,
        #[builtin(instance_index)] instance_id: u32,
    ) -> PolychromeSpriteVarying {
        let sprite = get!(POLYCHROME_SPRITES)[instance_id as usize];
        let vertex = rectangle_vertex(vertex_id, sprite.bounds);
        PolychromeSpriteVarying {
            position: vertex.clip_position,
            tile_position: atlas_texture_coordinates(
                vertex.unit_position,
                sprite.tile,
                texture_dimensions(POLYCHROME_TEXTURE),
            ),
            sprite_id: instance_id,
            clip_distances: clip_distances(vertex.viewport_position, sprite.content_mask),
        }
    }

    #[fragment]
    pub fn fs_poly_sprite(input: PolychromeSpriteVarying) -> Vec4f {
        let sample = texture_sample(
            POLYCHROME_TEXTURE,
            POLYCHROME_SAMPLER,
            input.tile_position,
        );
        if is_clipped(input.clip_distances) {
            return transparent();
        }
        let sprite = get!(POLYCHROME_SPRITES)[input.sprite_id as usize];
        let mut color = sample;
        if is_enabled(sprite.grayscale) {
            let grayscale = dot(color.rgb(), LINEAR_RGB_LUMA_WEIGHTS);
            color = vec4f(grayscale, grayscale, grayscale, sample.w);
        }
        blend_color(
            color,
            sprite.opacity
                * antialiased_coverage(rounded_rectangle_signed_distance(
                    input.position.xy(),
                    sprite.bounds,
                    sprite.corner_radii,
                )),
        )
    }
}

#[wgsl]
pub mod surface {
    use super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct SurfaceUniforms {
        pub bounds: Bounds,
        pub content_mask: Bounds,
        pub color_format: SurfaceColorFormat,
        pub padding0: u32,
        pub padding1: u32,
        pub padding2: u32,
    }
    uniform!(group(1), binding(0), SURFACE_LOCALS: SurfaceUniforms);
    texture!(group(1), binding(1), SURFACE_TEXTURE: Texture2D<f32>);
    texture!(group(1), binding(2), SURFACE_CHROMA_TEXTURE: Texture2D<f32>);
    sampler!(group(1), binding(3), SURFACE_SAMPLER: Sampler);

    pub const YCBCR_TO_LINEAR_RGB: Mat4x4f = mat4x4f(
        vec4f(1.0000, 1.0000, 1.0000, 0.0),
        vec4f(0.0000, -0.3441, 1.7720, 0.0),
        vec4f(1.4020, -0.7141, 0.0000, 0.0),
        vec4f(-0.7010, 0.5291, -0.8860, 1.0),
    );

    pub fn sample_yuv_surface(texture_position: Vec2f) -> Vec4f {
        let luma = texture_sample_level(
            SURFACE_TEXTURE,
            SURFACE_SAMPLER,
            texture_position,
            0.0,
        )
        .x;
        let chroma = texture_sample_level(
            SURFACE_CHROMA_TEXTURE,
            SURFACE_SAMPLER,
            texture_position,
            0.0,
        )
        .xy();
        YCBCR_TO_LINEAR_RGB * vec4f(luma, chroma.x, chroma.y, 1.0)
    }

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
        let vertex = rectangle_vertex(vertex_id, get!(SURFACE_LOCALS).bounds);
        SurfaceVarying {
            position: vertex.clip_position,
            texture_position: vertex.unit_position,
            clip_distances: clip_distances(
                vertex.viewport_position,
                get!(SURFACE_LOCALS).content_mask,
            ),
        }
    }

    #[fragment]
    pub fn fs_surface(input: SurfaceVarying) -> Vec4f {
        if is_clipped(input.clip_distances) {
            return transparent();
        }
        if get!(SURFACE_LOCALS).color_format == SurfaceColorFormat::Yuv {
            return sample_yuv_surface(input.texture_position);
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
    pub struct BlurUniforms {
        pub bounds: Bounds,
        pub content_mask: Bounds,
        pub corner_radii: Corners,
        pub direction: Vec2f,
        pub standard_deviation: f32,
        pub opacity: f32,
        pub sample_count: u32,
        pub sample_step: f32,
        pub composite_clip: BlurCompositeClip,
        pub downsample_mode: DownsampleMode,
    }
    uniform!(group(1), binding(0), BLUR_LOCALS: BlurUniforms);
    texture!(group(1), binding(1), BLUR_TEXTURE: Texture2D<f32>);
    sampler!(group(1), binding(2), BLUR_SAMPLER: Sampler);

    #[derive(Wgsl)]
    pub struct BlurVarying {
        #[builtin(position)]
        pub position: Vec4f,
        #[location(0)]
        pub texture_coordinates: Vec2f,
        #[location(3)]
        pub clip_distances: Vec4f,
    }

    #[vertex]
    pub fn vs_blur_fullscreen(#[builtin(vertex_index)] vertex_id: u32) -> BlurVarying {
        let vertex = fullscreen_vertex(vertex_id);
        BlurVarying {
            position: vertex.clip_position,
            texture_coordinates: vertex.texture_coordinates,
            clip_distances: unclipped_distances(),
        }
    }

    #[fragment]
    pub fn fs_blur_downsample(input: BlurVarying) -> Vec4f {
        if get!(BLUR_LOCALS).downsample_mode == DownsampleMode::HalfResolution {
            let destination = floor(input.position.xy());
            let source_coordinates = (destination * 2.0 + 1.0) / get!(GLOBALS).viewport_size;
            return texture_sample_level(
                BLUR_TEXTURE,
                BLUR_SAMPLER,
                source_coordinates,
                0.0,
            );
        }
        texture_sample_level(BLUR_TEXTURE, BLUR_SAMPLER, input.texture_coordinates, 0.0)
    }

    pub fn sample_blur_texture(texture_coordinates: Vec2f) -> Vec4f {
        texture_sample_level(BLUR_TEXTURE, BLUR_SAMPLER, texture_coordinates, 0.0)
    }

    pub fn gaussian_blur(texture_coordinates: Vec2f) -> Vec4f {
        let uniforms = get!(BLUR_LOCALS);
        let center_weight = gaussian(0.0, uniforms.standard_deviation);
        let mut weighted_color = sample_blur_texture(texture_coordinates) * center_weight;
        let mut weight_sum = center_weight;
        let mut sample_index = 1u32;

        while sample_index <= uniforms.sample_count {
            let distance = sample_index as f32 * uniforms.sample_step;
            let weight = gaussian(distance, uniforms.standard_deviation);
            let coordinate_offset = uniforms.direction * distance;
            let symmetric_pair = sample_blur_texture(texture_coordinates - coordinate_offset)
                + sample_blur_texture(texture_coordinates + coordinate_offset);
            weighted_color = weighted_color + symmetric_pair * weight;
            weight_sum += 2.0 * weight;
            sample_index += 1u32;
        }
        weighted_color / max(weight_sum, MIN_NORMALIZED_WEIGHT)
    }

    #[fragment]
    pub fn fs_blur(input: BlurVarying) -> Vec4f {
        gaussian_blur(input.texture_coordinates)
    }

    #[vertex]
    pub fn vs_blur_composite(#[builtin(vertex_index)] vertex_id: u32) -> BlurVarying {
        let vertex = rectangle_vertex(vertex_id, get!(BLUR_LOCALS).bounds);
        BlurVarying {
            position: vertex.clip_position,
            texture_coordinates: vertex.unit_position,
            clip_distances: clip_distances(
                vertex.viewport_position,
                get!(BLUR_LOCALS).content_mask,
            ),
        }
    }

    #[fragment]
    pub fn fs_blur_composite(input: BlurVarying) -> Vec4f {
        if is_clipped(input.clip_distances) {
            return transparent();
        }
        let sampled_blur_extent = 2.0 * floor(get!(GLOBALS).viewport_size * 0.5);
        let blurred = texture_sample_level(
            BLUR_TEXTURE,
            BLUR_SAMPLER,
            input.position.xy() / sampled_blur_extent,
            0.0,
        );
        let coverage = select(
            1.0,
            antialiased_coverage(rounded_rectangle_signed_distance(
                input.position.xy(),
                get!(BLUR_LOCALS).bounds,
                get!(BLUR_LOCALS).corner_radii,
            )),
            get!(BLUR_LOCALS).composite_clip == BlurCompositeClip::RoundedBounds,
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
    use super::monochrome_sprite::*;
    use super::path::*;
    use super::path_rasterization::*;
    use super::polychrome_sprite::*;
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
        pub padding: u32,
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

    #[vertex]
    pub fn vs_subpixel_sprite(
        #[builtin(vertex_index)] vertex_id: u32,
        #[builtin(instance_index)] instance_id: u32,
    ) -> SubpixelSpriteOutput {
        let sprite = get!(SUBPIXEL_SPRITES)[instance_id as usize];
        let vertex = transformed_rectangle_vertex(vertex_id, sprite.bounds, sprite.transformation);
        SubpixelSpriteOutput {
            position: vertex.clip_position,
            tile_position: atlas_texture_coordinates(
                vertex.unit_position,
                sprite.tile,
                texture_dimensions(SPRITE_TEXTURE),
            ),
            color: hsla_to_rgba(sprite.color),
            clip_distances: clip_distances(vertex.viewport_position, sprite.content_mask),
        }
    }

    #[fragment]
    pub fn fs_subpixel_sprite(input: SubpixelSpriteOutput) -> SubpixelSpriteFragmentOutput {
        let mut sample = texture_sample(SPRITE_TEXTURE, SPRITE_SAMPLER, input.tile_position).rgb();
        if is_enabled(get!(FONT_RASTERIZATION).uses_blue_green_red_subpixel_order) {
            sample = sample.bgr();
        }
        let alpha_corrected = apply_contrast_and_gamma_correction3(
            sample,
            input.color.rgb(),
            get!(FONT_RASTERIZATION).subpixel_enhanced_contrast,
            get!(FONT_RASTERIZATION).gamma_ratios,
        );
        if is_clipped(input.clip_distances) {
            return SubpixelSpriteFragmentOutput {
                foreground: transparent(),
                alpha: transparent(),
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

#[cfg(test)]
#[test]
fn linear_gradients_preserve_native_dithering() {
    use common::*;
    use wgsl_rs::std::*;

    let color = Hsla {
        h: 0.0,
        s: 0.0,
        l: 0.5,
        a: 0.5,
    };
    let background = Background {
        tag: BackgroundTag::LinearGradient,
        color_space: ColorSpace::Srgb,
        solid: color,
        gradient_angle_or_pattern_height: 90.0,
        colors: [
            LinearColorStop {
                color,
                percentage: 0.0,
            },
            LinearColorStop {
                color,
                percentage: 1.0,
            },
        ],
        padding: 0,
    };
    let bounds = Bounds {
        origin: vec2f(0.0, 0.0),
        size: vec2f(100.0, 100.0),
    };
    let prepared = prepare_background(background);
    let first = background_color(
        background,
        vec2f(10.0, 10.0),
        bounds,
        prepared,
    );
    let second = background_color(
        background,
        vec2f(11.0, 10.0),
        bounds,
        prepared,
    );

    assert_ne!(first.w, second.w);
}
