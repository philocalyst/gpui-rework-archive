//! Executable research probe for a small, typed WGSL paint-composition shape.
//!
//! The shared fixture stays under `tests/fixtures`, so other integration-test
//! crates can import it without adding a production API.

#[path = "fixtures/shader_recipes.rs"]
mod shader_recipes;

use shader_recipes::fixtures;
use shader_recipes::{pulse_recipe, recipe_shader, recipe_types, wave_recipe};

#[allow(dead_code)]
#[wgsl_rs::wgsl]
mod collision_left {
    pub fn shade(value: f32) -> f32 {
        value + 1.0
    }
}

#[allow(dead_code)]
#[wgsl_rs::wgsl]
mod collision_right {
    pub fn shade(value: f32) -> f32 {
        value * 2.0
    }
}

#[wgsl_rs::wgsl(skip_validation)]
mod collision_root {
    #[allow(unused_imports)]
    use super::collision_left::*;
    #[allow(unused_imports)]
    use super::collision_right::*;
}

#[allow(dead_code)]
#[wgsl_rs::wgsl]
mod rename_scope_probe {
    pub fn shade(shade: f32) -> f32 {
        let captured_argument = shade;
        captured_argument
    }
}

fn close(actual: f32, expected: f32) {
    assert!(
        (actual - expected).abs() < 0.00001,
        "{actual} != {expected}"
    );
}

fn pixel(color: wgsl_rs::std::Vec4f) -> fixtures::Pixel {
    [color.x, color.y, color.z, color.w]
}

fn assert_pixel_close(actual: fixtures::Pixel, expected: fixtures::Pixel) {
    for (actual, expected) in actual.into_iter().zip(expected) {
        close(actual, expected);
    }
}

#[test]
fn assembled_recipe_validates_and_deduplicates_diamond_imports() {
    let source = fixtures::full_shader_source();

    // wave_recipe and pulse_recipe both import recipe_color, which imports
    // recipe_types. Source assembly emits each module once by source identity.
    assert_eq!(source.matches("fn premultiply(").count(), 1, "{source}");
    assert_eq!(source.matches("fn source_over(").count(), 1, "{source}");
    assert_eq!(source.matches("struct Settings").count(), 1, "{source}");
    assert!(
        source.contains("fn paint_fragment(fragment: Fragment) -> vec4f"),
        "{source}"
    );
    assert!(
        source.contains("fn compose(fragment: Fragment, params: Params) -> vec4f"),
        "{source}"
    );
    assert!(source.contains("wave_paint(fragment, wave_settings)"));
    assert!(source.contains("wave_paint(fragment, pulse_settings)"));

    let module = naga::front::wgsl::parse_str(&source).unwrap_or_else(|error| {
        panic!(
            "generated WGSL did not parse:\n{}",
            error.emit_to_string(&source)
        )
    });
    naga::valid::Validator::new(
        naga::valid::ValidationFlags::all(),
        naga::valid::Capabilities::all(),
    )
    .validate(&module)
    .unwrap_or_else(|error| {
        panic!(
            "generated WGSL did not validate:\n{}",
            error.emit_to_string(&source)
        )
    });

    assert!(
        module
            .entry_points
            .iter()
            .any(|entry| entry.name == "vertex_recipe")
    );
    assert!(
        module
            .entry_points
            .iter()
            .any(|entry| entry.name == "fragment_recipe")
    );
}

#[test]
fn cpu_composition_checks_overlap_mask_layer_order_and_instance_reuse() {
    use wgsl_rs::std::vec2f;

    let params = fixtures::params();
    let mut fragment = recipe_types::Fragment {
        coordinate: vec2f(0.65, 0.32),
        mask_opacity: 0.65,
    };
    let wave = wave_recipe::wave_paint(fragment, params.wave);
    let pulse = pulse_recipe::pulse_paint(fragment, params.pulse);
    let alpha_before_mask = fixtures::source_over_reference(pixel(wave), pixel(pulse))[3];
    assert!(wave.w > 0.0 && pulse.w > 0.0);
    assert!(alpha_before_mask > wave.w.max(pulse.w));
    assert!(alpha_before_mask < wave.w + pulse.w);

    let actual = pixel(recipe_shader::compose(fragment, params));
    assert_pixel_close(actual, fixtures::cpu_evaluate(fragment, params));
    assert!(actual[0] <= actual[3] && actual[1] <= actual[3] && actual[2] <= actual[3]);

    fragment.mask_opacity = 0.0;
    assert_eq!(fixtures::cpu_evaluate(fragment, params), [0.0; 4]);
    fragment.mask_opacity = 1.0;
    let full = fixtures::cpu_evaluate(fragment, params);
    fragment.mask_opacity = 0.25;
    let quarter = fixtures::cpu_evaluate(fragment, params);
    for (actual, unmasked) in quarter.iter().zip(full) {
        close(*actual, unmasked * 0.25);
    }

    fragment.mask_opacity = 0.8;
    let forward_params = params;
    let mut reverse_params = params;
    reverse_params.reverse_order = 1;
    let forward = pixel(recipe_shader::compose(fragment, forward_params));
    let reverse = pixel(recipe_shader::compose(fragment, reverse_params));
    assert!((forward[0] - reverse[0]).abs() > 0.001);
    assert!((forward[2] - reverse[2]).abs() > 0.001);

    let mut repeated_params = params;
    repeated_params.same_recipe = 1;
    let repeated_first = wave_recipe::wave_paint(fragment, repeated_params.wave);
    let repeated_second = wave_recipe::wave_paint(fragment, repeated_params.pulse);
    assert!((repeated_first.x - repeated_second.x).abs() > 0.001);
    assert!((repeated_first.z - repeated_second.z).abs() > 0.001);
    assert_pixel_close(
        pixel(recipe_shader::compose(fragment, repeated_params)),
        fixtures::cpu_evaluate(fragment, repeated_params),
    );
}

#[test]
fn source_assembly_exposes_same_named_function_collision() {
    let source = collision_root::WGSL_SOURCE.wgsl_source().unwrap();

    // Source assembly concatenates the imported declarations without namespacing
    // or alpha-renaming. The collision is therefore an explicit limitation.
    assert_eq!(source.matches("fn shade(").count(), 2, "{source}");
    assert!(naga::front::wgsl::parse_str(&source).is_err());
}

#[test]
fn ir_name_rewrite_does_not_respect_argument_scope() {
    let mut module = (rename_scope_probe::WGSL_SOURCE.ir_constructor)();
    wgsl_rs::ir::rename_items(&mut module.items, "shade", "shade_specialized");
    let source = wgsl_rs::ir::render_module(&module);

    // The declaration of the argument stays `shade`, while its expression
    // reference is blindly changed to `shade_specialized`.
    assert!(
        source.contains("fn shade_specialized(shade: f32)"),
        "{source}"
    );
    assert!(
        source.contains("let captured_argument = shade_specialized;"),
        "{source}"
    );
    assert!(naga::front::wgsl::parse_str(&source).is_err());
}
