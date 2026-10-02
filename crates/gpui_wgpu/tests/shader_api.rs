//! Public consumer permutations for the typed shader-paint builder.

use gpui::shader::{Paint, Scalar, Vec2, backdrop, color, constant, rgba, shader, vec2};
use gpui::{Styled, div, rgb};

fn stripes(uv: &Vec2, phase: &Scalar) -> Paint {
    let wave = (uv.x() * 8.0 + phase * 0.31).sin() * 0.5 + 0.5;
    color(rgb(0x19324b)).mix(color(rgb(0xf08b66)), wave)
}

fn mapped_recipe(phase: f32) -> Paint {
    shader(move |pixel| {
        let uv = pixel.uv();
        let phase = Scalar::uniform(phase);
        let base = stripes(&uv, &phase);
        let left = base.map_uv(|uv| vec2(uv.x() + constant(0.125), uv.y()));
        let right = base.map_uv(|uv| vec2(uv.x() - constant(0.125), uv.y()));

        // Reusing one recipe under two coordinate maps should share its input
        // values, but still evaluate its coordinate-dependent math twice.
        left.over(right).over(base)
    })
}

fn count_uniform(compiled: &gpui::shader::CompiledPaint, value: f32) -> usize {
    compiled
        .parameter_slots()
        .iter()
        .flatten()
        .filter(|component| **component == value)
        .count()
}

fn stateful_paint(active: bool, phase: f32) -> Paint {
    if active {
        mapped_recipe(phase)
    } else {
        color(rgb(0x19212b))
    }
}

#[test]
fn rebuilding_a_helper_changes_values_without_changing_program_identity() {
    let first_paint = mapped_recipe(0.314_159_27);
    let changed_paint = mapped_recipe(0.271_828_18);
    assert_eq!(first_paint, mapped_recipe(0.314_159_27));
    assert_ne!(first_paint, changed_paint);

    let first = first_paint.compile().unwrap();
    let changed = changed_paint.compile().unwrap();

    assert_eq!(first.program_id(), changed.program_id());
    assert_eq!(first.wgsl(), changed.wgsl());
    assert_ne!(first.parameter_slots(), changed.parameter_slots());
    assert_eq!(count_uniform(&first, 0.314_159_27), 1);
    assert_eq!(count_uniform(&changed, 0.271_828_18), 1);
}

#[test]
fn ordinary_rust_branches_return_one_concrete_paint_type() {
    let active = stateful_paint(true, 0.5).compile().unwrap();
    let inactive = stateful_paint(false, 0.5).compile().unwrap();

    assert_ne!(active.program_id(), inactive.program_id());
}

#[test]
fn separately_created_equal_inputs_stay_independent_but_a_shared_input_is_shared() {
    const PHASE: f32 = 0.314_159_27;

    let independent = shader(|pixel| {
        let uv = pixel.uv();
        let left = stripes(&uv, &Scalar::uniform(PHASE));
        let right = stripes(&uv, &Scalar::uniform(PHASE));
        left.over(right)
    })
    .compile()
    .unwrap();

    let shared = shader(|pixel| {
        let uv = pixel.uv();
        let phase = Scalar::uniform(PHASE);
        let paint = stripes(&uv, &phase);
        paint.over(paint.clone())
    })
    .compile()
    .unwrap();

    assert_eq!(count_uniform(&independent, PHASE), 2);
    assert_eq!(count_uniform(&shared, PHASE), 1);
}

#[test]
fn field_math_channels_select_and_backdrop_compose_into_element_styles() {
    let glass = shader(|pixel| {
        let uv = pixel.uv();
        let size = pixel.size();

        // Deliberately exercise scalar-left arithmetic, borrowed division,
        // vec2 construction/array constants, and aspect-corrected coordinates.
        let mirrored_x = 1.0 - &uv.x();
        let biased_y = 0.25 + &uv.y();
        let gain = 2.0 * &mirrored_x;
        let inverse_height = 1.0 / &size.y();
        let aspect = &size.x() / &size.y();
        let point = vec2(&gain * &aspect, &biased_y * inverse_height);
        let shifted = &point + &constant([0.07, -0.03]);
        let distance = shifted.dot(&constant([0.6, 0.8])).abs();

        // Predicate.select is true-first, matching the established GPUI API.
        let rim = uv.x().lt(0.08).or(uv.x().gt(0.92));
        let amount = rim.select(distance.smoothstep(0.1, 0.8), distance.smoothstep(0.3, 0.9));

        let source = backdrop().sample(&uv + constant([0.004, 0.0]));
        let transmitted = rgba(source.red(), source.green(), source.blue(), source.alpha());

        // Channel reads from transparent colors must stay finite and return
        // zero RGB instead of dividing by zero.
        let transparent = rgba(0.91, 0.21, 0.87, 0.0);
        let safe_rgb = rgba(
            transparent.red(),
            transparent.green(),
            transparent.blue(),
            1.0,
        );

        safe_rgb.mix(transmitted, amount)
    });

    let compiled = glass.compile().unwrap();
    assert!(compiled.uses_backdrop());
    assert!(compiled.wgsl().contains("gpui_sample_backdrop"));

    // The same closed paint is accepted by both ordinary GPUI destinations.
    let _element = div().bg(&glass).border_2().border_color(&glass);
}

#[test]
fn mapping_a_composite_does_not_mutate_the_original_paint() {
    let base = mapped_recipe(0.41);
    let original = base.compile().unwrap();
    let mapped_once = base.map_uv(|uv| {
        let recentered = &uv - &constant([0.5, 0.5]);
        &recentered * 1.7 + constant([0.5, 0.5])
    });
    let mapped = mapped_once.map_uv(|uv| vec2(uv.x() + constant(0.03), 1.0 - &uv.y()));
    let mapped_program = mapped.compile().unwrap();
    let original_after_mapping = base.compile().unwrap();

    assert_ne!(original.program_id(), mapped_program.program_id());
    assert_eq!(original.program_id(), original_after_mapping.program_id());
    assert_eq!(original.wgsl(), original_after_mapping.wgsl());
}
