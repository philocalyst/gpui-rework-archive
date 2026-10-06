#[wgsl_rs::wgsl]
pub mod underline {
    use super::super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct Underline {
        pub order: u32,
        pub padding: u32,
        pub bounds: Bounds,
        pub content_mask: ContentMask,
        pub color: Hsla,
        pub thickness: f32,
        pub wavy: ShaderBool,
    }
    storage!(group(1), binding(0), UNDERLINES: RuntimeArray<Underline>);

    #[derive(Clone, Copy, Wgsl)]
    pub struct WaveSample {
        pub distance: f32,
        pub gradient: Vec2f,
    }

    /// Differentiate the wave's slope-corrected scalar distance, including its denominator.
    pub fn wavy_underline_sample(bounds: Bounds, thickness: f32, position: Vec2f) -> WaveSample {
        let normalized_position = (position - bounds.origin) / bounds.size.y - vec2f(0.0, 0.5);
        let angular_frequency = PI * UNDERLINE_WAVE_FREQUENCY * thickness / bounds.size.y;
        let amplitude = thickness * UNDERLINE_WAVE_HEIGHT_RATIO / bounds.size.y;
        let wave_height = sin(normalized_position.x * angular_frequency) * amplitude;
        let wave_slope =
            cos(normalized_position.x * angular_frequency) * amplitude * angular_frequency;
        let wave_second_derivative = -wave_height * angular_frequency * angular_frequency;
        let numerator = normalized_position.y - wave_height;
        let denominator = sqrt(1.0 + wave_slope * wave_slope);
        let signed_distance = numerator / denominator * bounds.size.y;
        WaveSample {
            distance: abs(signed_distance) - thickness * 0.5,
            gradient: sign(signed_distance)
                * vec2f(
                    -wave_slope / denominator
                        - numerator * wave_slope * wave_second_derivative
                            / (denominator * denominator * denominator),
                    1.0 / denominator,
                ),
        }
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
    pub fn vertex_underline(
        #[builtin(vertex_index)] vertex_id: u32,
        #[builtin(instance_index)] instance_id: u32,
    ) -> UnderlineVarying {
        let underline = get!(UNDERLINES)[instance_id as usize];
        let vertex = space_rectangle_vertex(vertex_id, underline.bounds, underline.content_mask);
        UnderlineVarying {
            position: vertex.clip_position,
            color: hsla_to_rgba(underline.color),
            underline_id: instance_id,
            clip_distances: clip_distances(vertex.local_position, underline.content_mask.bounds),
        }
    }

    #[fragment]
    pub fn fragment_underline(input: UnderlineVarying) -> Vec4f {
        if is_clipped(input.clip_distances) {
            return transparent();
        }
        let underline = get!(UNDERLINES)[input.underline_id as usize];
        let local = local_position_from_clip_distances(
            underline.content_mask,
            input.position.xy(),
            input.clip_distances,
        );
        if !is_enabled(underline.wavy) {
            return blend_color(
                input.color,
                ContentMask::alpha_at_local_position(
                    underline.content_mask,
                    input.position.xy(),
                    local,
                ),
            );
        }
        let wave = wavy_underline_sample(underline.bounds, underline.thickness, local);
        blend_color(
            input.color,
            distance_coverage_from_gradient(
                wave.distance,
                wave.gradient,
                local_pixel_basis(underline.content_mask),
            ) * ContentMask::alpha_at_local_position(
                underline.content_mask,
                input.position.xy(),
                local,
            ),
        )
    }
}

#[cfg(test)]
mod tests {
    use super::super::common::Bounds;
    use super::underline::wavy_underline_sample;
    use wgsl_rs::std::vec2f;

    #[test]
    fn wavy_underline_gradient_matches_its_slope_corrected_distance() {
        let bounds = Bounds {
            origin: vec2f(3.0, 4.0),
            size: vec2f(80.0, 6.0),
        };
        let step = 0.001;
        for thickness in [0.5, 1.0, 2.0] {
            for point in [vec2f(5.3, 4.7), vec2f(8.1, 8.4), vec2f(13.7, 7.9)] {
                let sample = wavy_underline_sample(bounds, thickness, point);
                for (axis, analytic) in [
                    (vec2f(step, 0.0), sample.gradient.x),
                    (vec2f(0.0, step), sample.gradient.y),
                ] {
                    let finite = (wavy_underline_sample(bounds, thickness, point + axis).distance
                        - wavy_underline_sample(bounds, thickness, point - axis).distance)
                        / (2.0 * step);
                    assert!(
                        (finite - analytic).abs() < 0.002,
                        "thickness {thickness}, point {point:?}: {finite} vs {analytic}"
                    );
                }
            }
        }
    }
}

#[wgsl_rs::wgsl]
pub mod monochrome_sprite {
    use super::super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct MonochromeSprite {
        pub order: u32,
        pub padding: u32,
        pub bounds: Bounds,
        pub content_mask: ContentMask,
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
        #[location(2)]
        #[interpolate(flat)]
        pub sprite_id: u32,
        #[location(3)]
        pub clip_distances: Vec4f,
    }

    #[vertex]
    pub fn vertex_monochrome_sprite(
        #[builtin(vertex_index)] vertex_id: u32,
        #[builtin(instance_index)] instance_id: u32,
    ) -> MonochromeSpriteVarying {
        let sprite = get!(MONOCHROME_SPRITES)[instance_id as usize];
        let vertex = space_transformed_rectangle_vertex(
            vertex_id,
            sprite.bounds,
            sprite.transformation,
            sprite.content_mask,
        );
        MonochromeSpriteVarying {
            position: vertex.clip_position,
            tile_position: atlas_texture_coordinates(
                vertex.unit_position,
                sprite.tile,
                texture_dimensions(MONOCHROME_TEXTURE),
            ),
            color: hsla_to_rgba(sprite.color),
            sprite_id: instance_id,
            clip_distances: clip_distances(vertex.local_position, sprite.content_mask.bounds),
        }
    }

    #[fragment]
    pub fn fragment_monochrome_sprite(input: MonochromeSpriteVarying) -> Vec4f {
        if is_clipped(input.clip_distances) {
            return transparent();
        }
        let sprite = get!(MONOCHROME_SPRITES)[input.sprite_id as usize];
        let local = local_position_from_clip_distances(
            sprite.content_mask,
            input.position.xy(),
            input.clip_distances,
        );
        let tile_position = clamp_atlas_texture_coordinates(
            input.tile_position,
            sprite.tile,
            texture_dimensions(MONOCHROME_TEXTURE),
            should_clamp_atlas_for_sprite(sprite.content_mask, sprite.transformation),
        );
        let sample =
            texture_sample_level(MONOCHROME_TEXTURE, MONOCHROME_SAMPLER, tile_position, 0.0).x;
        let corrected = apply_contrast_and_gamma_correction(
            sample,
            input.color.rgb(),
            get!(FONT_RASTERIZATION).grayscale_enhanced_contrast,
            get!(FONT_RASTERIZATION).gamma_ratios,
        );
        blend_color(
            input.color,
            corrected
                * ContentMask::alpha_at_local_position(
                    sprite.content_mask,
                    input.position.xy(),
                    local,
                ),
        )
    }
}

#[wgsl_rs::wgsl]
pub mod polychrome_sprite {
    use super::super::common::*;
    use super::super::corner_smoothing::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct PolychromeSprite {
        pub order: u32,
        pub grayscale: ShaderBool,
        pub opacity: f32,
        pub corner_smoothing: f32,
        pub bounds: Bounds,
        pub content_mask: ContentMask,
        pub corner_radii: Corners,
        pub tile: AtlasTile,
    }
    storage!(group(1), binding(0), POLYCHROME_SPRITES: RuntimeArray<PolychromeSprite>);
    texture!(group(1), binding(1), POLYCHROME_TEXTURE: Texture2D<f32>);
    sampler!(group(1), binding(2), POLYCHROME_SAMPLER: Sampler);

    #[derive(Clone, Copy, Wgsl)]
    pub struct PolychromeVertexData {
        pub position: Vec4f,
        pub tile_position: Vec2f,
        pub sprite_id: u32,
        pub clip_distances: Vec4f,
    }

    pub fn prepare_polychrome_vertex(
        vertex_id: u32,
        instance_id: u32,
        sprite: PolychromeSprite,
    ) -> PolychromeVertexData {
        let vertex = space_rectangle_vertex(vertex_id, sprite.bounds, sprite.content_mask);
        PolychromeVertexData {
            position: vertex.clip_position,
            tile_position: atlas_texture_coordinates(
                vertex.unit_position,
                sprite.tile,
                texture_dimensions(POLYCHROME_TEXTURE),
            ),
            sprite_id: instance_id,
            clip_distances: clip_distances(vertex.local_position, sprite.content_mask.bounds),
        }
    }

    pub fn polychrome_color(sprite: PolychromeSprite, tile_position: Vec2f) -> Vec4f {
        let tile_position = clamp_atlas_texture_coordinates(
            tile_position,
            sprite.tile,
            texture_dimensions(POLYCHROME_TEXTURE),
            should_clamp_atlas_for_space(sprite.content_mask),
        );
        let sample =
            texture_sample_level(POLYCHROME_TEXTURE, POLYCHROME_SAMPLER, tile_position, 0.0);
        let grayscale = dot(sample.rgb(), LINEAR_RGB_LUMA_WEIGHTS);
        select(
            sample,
            vec4f(grayscale, grayscale, grayscale, sample.w),
            is_enabled(sprite.grayscale),
        )
    }

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
    pub fn vertex_polychrome_sprite(
        #[builtin(vertex_index)] vertex_id: u32,
        #[builtin(instance_index)] instance_id: u32,
    ) -> PolychromeSpriteVarying {
        let sprite = get!(POLYCHROME_SPRITES)[instance_id as usize];
        let vertex = prepare_polychrome_vertex(vertex_id, instance_id, sprite);
        PolychromeSpriteVarying {
            position: vertex.position,
            tile_position: vertex.tile_position,
            sprite_id: vertex.sprite_id,
            clip_distances: vertex.clip_distances,
        }
    }

    #[fragment]
    pub fn fragment_polychrome_sprite(input: PolychromeSpriteVarying) -> Vec4f {
        if is_clipped(input.clip_distances) {
            return transparent();
        }
        let sprite = get!(POLYCHROME_SPRITES)[input.sprite_id as usize];
        let local = local_position_from_clip_distances(
            sprite.content_mask,
            input.position.xy(),
            input.clip_distances,
        );
        let distance = rounded_rectangle_signed_distance(local, sprite.bounds, sprite.corner_radii);
        let coverage = distance_coverage_from_gradient(
            distance,
            rounded_rectangle_gradient(local, sprite.bounds, sprite.corner_radii),
            local_pixel_basis(sprite.content_mask),
        );
        let color = polychrome_color(sprite, input.tile_position);
        blend_color(
            color,
            sprite.opacity
                * coverage
                * ContentMask::alpha_at_local_position(
                    sprite.content_mask,
                    input.position.xy(),
                    local,
                ),
        )
    }

    #[derive(Wgsl)]
    pub struct SmoothedPolychromeSpriteVarying {
        #[builtin(position)]
        pub position: Vec4f,
        #[location(0)]
        pub tile_position: Vec2f,
        #[location(1)]
        #[interpolate(flat)]
        pub sprite_id: u32,
        #[location(2)]
        #[interpolate(flat)]
        pub horizontal_corner_reaches: Vec4f,
        #[location(3)]
        pub clip_distances: Vec4f,
        #[location(4)]
        #[interpolate(flat)]
        pub vertical_corner_reaches: Vec4f,
        #[location(5)]
        #[interpolate(flat)]
        pub smoothing_factors: Vec4f,
        #[location(6)]
        #[interpolate(flat)]
        pub superellipse_power: f32,
    }

    #[vertex]
    pub fn vertex_smoothed_polychrome_sprite(
        #[builtin(vertex_index)] vertex_id: u32,
        #[builtin(instance_index)] instance_id: u32,
    ) -> SmoothedPolychromeSpriteVarying {
        let sprite = get!(POLYCHROME_SPRITES)[instance_id as usize];
        let vertex = prepare_polychrome_vertex(vertex_id, instance_id, sprite);
        let prepared = prepare_corners(
            sprite.bounds.size,
            sprite.corner_radii,
            sprite.corner_smoothing,
            true,
        );

        SmoothedPolychromeSpriteVarying {
            position: vertex.position,
            tile_position: vertex.tile_position,
            sprite_id: vertex.sprite_id,
            horizontal_corner_reaches: prepared.horizontal_reaches,
            clip_distances: vertex.clip_distances,
            vertical_corner_reaches: prepared.vertical_reaches,
            smoothing_factors: prepared.smoothing_factors,
            superellipse_power: prepared.superellipse_power,
        }
    }

    #[fragment]
    pub fn fragment_smoothed_polychrome_sprite(input: SmoothedPolychromeSpriteVarying) -> Vec4f {
        if is_clipped(input.clip_distances) {
            return transparent();
        }
        let sprite = get!(POLYCHROME_SPRITES)[input.sprite_id as usize];
        let local = local_position_from_clip_distances(
            sprite.content_mask,
            input.position.xy(),
            input.clip_distances,
        );
        let contour = contour_sample(
            local,
            sprite.bounds,
            sprite.corner_radii,
            sprite.corner_smoothing,
            PreparedCorners {
                horizontal_reaches: input.horizontal_corner_reaches,
                vertical_reaches: input.vertical_corner_reaches,
                smoothing_factors: input.smoothing_factors,
                superellipse_power: input.superellipse_power,
            },
        );
        let coverage = distance_coverage_from_gradient(
            contour.distance,
            contour.gradient,
            local_pixel_basis(sprite.content_mask),
        );
        let color = polychrome_color(sprite, input.tile_position);
        blend_color(
            color,
            sprite.opacity
                * coverage
                * ContentMask::alpha_at_local_position(
                    sprite.content_mask,
                    input.position.xy(),
                    local,
                ),
        )
    }
}

/// Dual-source LCD glyph pipeline; a separate module keeps the shared instance slot legal.
#[wgsl_rs::wgsl(skip_validation)]
pub mod subpixel_sprite {
    use super::super::common::*;
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct SubpixelSprite {
        pub order: u32,
        pub padding: u32,
        pub bounds: Bounds,
        pub content_mask: ContentMask,
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
        #[location(2)]
        #[interpolate(flat)]
        pub sprite_id: u32,
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
    pub fn vertex_subpixel_sprite(
        #[builtin(vertex_index)] vertex_id: u32,
        #[builtin(instance_index)] instance_id: u32,
    ) -> SubpixelSpriteOutput {
        let sprite = get!(SUBPIXEL_SPRITES)[instance_id as usize];
        let vertex = space_transformed_rectangle_vertex(
            vertex_id,
            sprite.bounds,
            sprite.transformation,
            sprite.content_mask,
        );
        SubpixelSpriteOutput {
            position: vertex.clip_position,
            tile_position: atlas_texture_coordinates(
                vertex.unit_position,
                sprite.tile,
                texture_dimensions(SPRITE_TEXTURE),
            ),
            color: hsla_to_rgba(sprite.color),
            sprite_id: instance_id,
            clip_distances: clip_distances(vertex.local_position, sprite.content_mask.bounds),
        }
    }

    #[fragment]
    pub fn fragment_subpixel_sprite(input: SubpixelSpriteOutput) -> SubpixelSpriteFragmentOutput {
        if is_clipped(input.clip_distances) {
            return SubpixelSpriteFragmentOutput {
                foreground: transparent(),
                alpha: transparent(),
            };
        }
        let sprite = get!(SUBPIXEL_SPRITES)[input.sprite_id as usize];
        let local = local_position_from_clip_distances(
            sprite.content_mask,
            input.position.xy(),
            input.clip_distances,
        );
        let tile_position = clamp_atlas_texture_coordinates(
            input.tile_position,
            sprite.tile,
            texture_dimensions(SPRITE_TEXTURE),
            should_clamp_atlas_for_sprite(sprite.content_mask, sprite.transformation),
        );
        let sampled =
            texture_sample_level(SPRITE_TEXTURE, SPRITE_SAMPLER, tile_position, 0.0).rgb();
        let sample = select(
            sampled,
            sampled.bgr(),
            is_enabled(get!(FONT_RASTERIZATION).uses_blue_green_red_subpixel_order),
        );
        let alpha_corrected = apply_contrast_and_gamma_correction3(
            sample,
            input.color.rgb(),
            get!(FONT_RASTERIZATION).subpixel_enhanced_contrast,
            get!(FONT_RASTERIZATION).gamma_ratios,
        );
        let mask_alpha =
            ContentMask::alpha_at_local_position(sprite.content_mask, input.position.xy(), local);
        SubpixelSpriteFragmentOutput {
            foreground: vec4f(input.color.x, input.color.y, input.color.z, 1.0),
            alpha: vec4f(
                input.color.w * alpha_corrected.x * mask_alpha,
                input.color.w * alpha_corrected.y * mask_alpha,
                input.color.w * alpha_corrected.z * mask_alpha,
                1.0,
            ),
        }
    }
}
