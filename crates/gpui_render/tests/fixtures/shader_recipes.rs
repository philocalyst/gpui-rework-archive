//! Shared shader fixture used by render-crate and GPU-backed integration tests.
#![allow(dead_code)]

#[wgsl_rs::wgsl]
pub mod recipe_types {
    use wgsl_rs::std::*;

    /// Fragment-local inputs shared by ordinary Rust/WGSL paint functions.
    #[derive(Clone, Copy, Wgsl)]
    pub struct Fragment {
        pub coordinate: Vec2f,
        /// Shape coverage applied once after all component paints are composed.
        pub mask_opacity: f32,
    }

    /// Uniform settings for one independently configured paint instance.
    #[derive(Clone, Copy, Wgsl)]
    pub struct Settings {
        pub tint: Vec4f,
        pub frequency: f32,
        pub phase: f32,
        pub opacity: f32,
        pub padding: f32,
    }

    /// A combined uniform block for two independent paints and composition modes.
    #[derive(Clone, Copy, Wgsl)]
    pub struct Params {
        pub wave: Settings,
        pub pulse: Settings,
        pub reverse_order: u32,
        pub same_recipe: u32,
    }
}

#[wgsl_rs::wgsl]
pub mod recipe_color {
    use wgsl_rs::std::*;

    /// Convert straight-alpha color to premultiplied form after opacity masks.
    pub fn premultiply(color: Vec4f, opacity: f32) -> Vec4f {
        let alpha = color.w * clamp(opacity, 0.0, 1.0);
        vec4f(color.x * alpha, color.y * alpha, color.z * alpha, alpha)
    }

    /// Composite a premultiplied source over a premultiplied destination.
    pub fn source_over(destination: Vec4f, source: Vec4f) -> Vec4f {
        source + destination * (1.0 - source.w)
    }
}

#[wgsl_rs::wgsl]
pub mod wave_recipe {
    use super::recipe_color::*;
    use super::recipe_types::*;
    use wgsl_rs::std::*;

    /// A soft sinusoidal stripe, scaled by its independent paint opacity.
    pub fn wave_paint(fragment: Fragment, settings: Settings) -> Vec4f {
        let angle = fragment.coordinate.x * settings.frequency + settings.phase;
        let stripe_y = 0.5 + 0.2 * sin(angle);
        let coverage = max(0.0, 1.0 - abs(fragment.coordinate.y - stripe_y) * 10.0);
        premultiply(settings.tint, settings.opacity * coverage)
    }
}

#[wgsl_rs::wgsl]
pub mod pulse_recipe {
    use super::recipe_color::*;
    use super::recipe_types::*;
    use wgsl_rs::std::*;

    /// A soft radial pulse, independently driven by its own settings.
    pub fn pulse_paint(fragment: Fragment, settings: Settings) -> Vec4f {
        let centered = fragment.coordinate - vec2f(0.5, 0.5);
        let radius = length(centered);
        let ring_radius = 0.18 + 0.04 * sin(settings.phase);
        let coverage = max(0.0, 1.0 - abs(radius - ring_radius) * settings.frequency);
        premultiply(settings.tint, settings.opacity * coverage)
    }
}

#[wgsl_rs::wgsl]
pub mod recipe_shader {
    use super::pulse_recipe::*;
    use super::recipe_color::*;
    use super::recipe_types::*;
    use super::wave_recipe::*;
    use wgsl_rs::std::*;

    uniform!(group(0), binding(0), PAINT_PARAMS: Params);

    /// A plain typed `Fragment -> Vec4f` function suitable for composition.
    pub fn paint_fragment(fragment: Fragment) -> Vec4f {
        let params = get!(PAINT_PARAMS);
        compose_layers(
            fragment,
            params.wave,
            params.pulse,
            params.reverse_order,
            params.same_recipe,
        )
    }

    /// Compose two independently configured paints in premultiplied space.
    pub fn compose(fragment: Fragment, params: Params) -> Vec4f {
        compose_layers(
            fragment,
            params.wave,
            params.pulse,
            params.reverse_order,
            params.same_recipe,
        )
    }

    /// Shared layer composer used by the uniform-backed fragment and CPU calls.
    pub fn compose_layers(
        fragment: Fragment,
        wave_settings: Settings,
        pulse_settings: Settings,
        reverse_order: u32,
        same_recipe: u32,
    ) -> Vec4f {
        let wave = wave_paint(fragment, wave_settings);
        let mut second = wave_paint(fragment, pulse_settings);
        if same_recipe == 0 {
            second = pulse_paint(fragment, pulse_settings);
        }
        let mut layered = source_over(wave, second);
        if reverse_order != 0 {
            layered = source_over(second, wave);
        }
        layered * clamp(fragment.mask_opacity, 0.0, 1.0)
    }

    /// Vertex/fragment interface carries unit coordinates and a soft edge mask.
    #[derive(Wgsl)]
    pub struct Varying {
        #[builtin(position)]
        pub position: Vec4f,
        #[location(0)]
        pub coordinate: Vec2f,
    }

    pub fn vertex_position(vertex_index: u32) -> Vec2f {
        const POSITIONS: [Vec2f; 3] = [vec2f(-1.0, -1.0), vec2f(3.0, -1.0), vec2f(-1.0, 3.0)];
        POSITIONS[vertex_index as usize]
    }

    pub fn mask_opacity(coordinate: Vec2f) -> f32 {
        let edge = min(
            min(coordinate.x, 1.0 - coordinate.x),
            min(coordinate.y, 1.0 - coordinate.y),
        );
        clamp(edge * 12.0, 0.0, 1.0)
    }

    #[vertex]
    pub fn vertex_recipe(#[builtin(vertex_index)] vertex_index: u32) -> Varying {
        let position = vertex_position(vertex_index);
        let coordinate = (position + vec2f(1.0, 1.0)) * 0.5;
        Varying {
            position: vec4f(position.x, position.y, 0.0, 1.0),
            coordinate,
        }
    }

    #[fragment]
    pub fn fragment_recipe(input: Varying) -> Vec4f {
        paint_fragment(Fragment {
            coordinate: input.coordinate,
            mask_opacity: mask_opacity(input.coordinate),
        })
    }
}

/// Test-only fixture generator, reusable from another integration-test crate.
pub mod fixtures {
    /// RGBA pixel in premultiplied-alpha form.
    pub type Pixel = [f32; 4];

    /// Generate the complete assembled shader, including its deduplicated imports.
    pub fn full_shader_source() -> String {
        super::recipe_shader::WGSL_SOURCE
            .wgsl_source()
            .expect("recipe fixture is a concrete WGSL source")
    }

    /// Return deterministic settings that exercise both independent paint instances.
    pub fn params() -> super::recipe_types::Params {
        use wgsl_rs::std::{Vec4f, vec4f};

        let wave_tint: Vec4f = vec4f(0.8, 0.15, 0.05, 0.75);
        let pulse_tint: Vec4f = vec4f(0.05, 0.25, 0.9, 0.6);
        super::recipe_types::Params {
            wave: super::recipe_types::Settings {
                tint: wave_tint,
                frequency: 6.0,
                phase: 0.35,
                opacity: 0.7,
                padding: 0.0,
            },
            pulse: super::recipe_types::Settings {
                tint: pulse_tint,
                frequency: 8.0,
                phase: 1.2,
                opacity: 0.5,
                padding: 0.0,
            },
            reverse_order: 0,
            same_recipe: 0,
        }
    }

    /// Evaluate both procedural paints on the CPU, then apply reference source-over.
    pub fn cpu_evaluate(
        fragment: super::recipe_types::Fragment,
        params: super::recipe_types::Params,
    ) -> Pixel {
        let wave = super::wave_recipe::wave_paint(fragment, params.wave);
        let mut second = super::wave_recipe::wave_paint(fragment, params.pulse);
        if params.same_recipe == 0 {
            second = super::pulse_recipe::pulse_paint(fragment, params.pulse);
        }
        let (destination, source) = if params.reverse_order == 0 {
            (to_pixel(wave), to_pixel(second))
        } else {
            (to_pixel(second), to_pixel(wave))
        };
        let mut composed = source_over_reference(destination, source);
        let mask = fragment.mask_opacity.clamp(0.0, 1.0);
        for channel in &mut composed {
            *channel *= mask;
        }
        composed
    }

    /// Independent CPU implementation of premultiplied source-over.
    pub fn source_over_reference(destination: Pixel, source: Pixel) -> Pixel {
        let keep_destination = 1.0 - source[3];
        [
            source[0] + destination[0] * keep_destination,
            source[1] + destination[1] * keep_destination,
            source[2] + destination[2] * keep_destination,
            source[3] + destination[3] * keep_destination,
        ]
    }

    fn to_pixel(color: wgsl_rs::std::Vec4f) -> Pixel {
        [color.x, color.y, color.z, color.w]
    }
}
