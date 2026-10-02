//! Tests for the private fluent builder fixture shared with the GPU probe.

#[path = "fixtures/shader_builder.rs"]
mod shader_builder;

use std::time::{Duration, Instant};

use shader_builder::{
    CompiledShader, Scalar, bands, color, diamond_recipe, realistic_recipe, rgba, shader,
};

fn validate(source: &str) -> Result<(), String> {
    let module =
        naga::front::wgsl::parse_str(source).map_err(|error| error.emit_to_string(source))?;
    naga::valid::Validator::new(
        naga::valid::ValidationFlags::all(),
        naga::valid::Capabilities::empty(),
    )
    .validate(&module)
    .map(|_| ())
    .map_err(|error| error.emit_to_string(source))
}

fn count_uniform_component(compiled: &CompiledShader, target: f32) -> usize {
    compiled
        .uniforms
        .iter()
        .flat_map(|slot| slot.iter())
        .filter(|value| **value == target)
        .count()
}

fn assert_uniform_slot_close(compiled: &CompiledShader, expected: [f32; 4]) {
    assert!(
        compiled.uniforms.iter().any(|slot| {
            slot.iter()
                .zip(expected)
                .all(|(actual, expected)| (actual - expected).abs() < 0.000001)
        }),
        "missing premultiplied slot {expected:?} in {:?}",
        compiled.uniforms
    );
}

#[test]
fn fluent_nested_recipe_lowers_to_valid_wgsl_and_occurrence_uniforms() {
    let first = realistic_recipe(
        0.17,
        [0.08, 0.18, 0.72, 0.8],
        0.61,
        [0.75, 0.12, 0.08, 0.9],
        0.7,
    )
    .compile();
    let changed = realistic_recipe(
        0.37,
        [0.22, 0.31, 0.64, 0.8],
        0.83,
        [0.6, 0.2, 0.14, 0.9],
        0.4,
    )
    .compile();

    assert_eq!(first.source, changed.source);
    assert_ne!(first.uniforms, changed.uniforms);
    assert!(first.stats.uniform_values > first.uniforms.len());
    assert!(first.source.contains("struct Params"));
    assert!(first.source.contains("values: array<vec4f,"));
    assert!(
        first
            .source
            .contains("@group(0) @binding(0) var<uniform> params: Params")
    );
    assert!(
        first
            .source
            .contains("fn shade(fragment: Fragment) -> vec4f")
    );
    assert_eq!(first.source.matches("clamp(fragment.coverage").count(), 1);
    assert_eq!(count_uniform_component(&first, 0.17), 1);
    assert_eq!(count_uniform_component(&first, 0.61), 1);
    assert_uniform_slot_close(&first, [0.08 * 0.8, 0.18 * 0.8, 0.72 * 0.8, 0.8]);
    assert_uniform_slot_close(&first, [0.75 * 0.9, 0.12 * 0.9, 0.08 * 0.9, 0.9]);

    validate(&first.source).unwrap_or_else(|error| panic!("invalid generated WGSL:\n{error}"));
}

#[test]
fn equal_values_are_independent_per_node_but_clones_share_a_slot() {
    let separate = shader(|pixel| {
        let front = bands(pixel, 0.37, [0.2, 0.4, 0.7, 1.0]);
        let back = bands(pixel, 0.37, [0.2, 0.4, 0.7, 1.0]);
        front.over(back)
    })
    .compile();
    let shared = shader(|pixel| {
        let paint = bands(pixel, 0.37, [0.2, 0.4, 0.7, 1.0]);
        paint.clone().over(paint)
    })
    .compile();

    assert_eq!(count_uniform_component(&separate, 0.37), 2);
    assert_eq!(count_uniform_component(&shared, 0.37), 1);
    assert_eq!(
        separate
            .uniforms
            .iter()
            .filter(|slot| **slot == [0.2, 0.4, 0.7, 1.0])
            .count(),
        2
    );
    assert_eq!(
        shared
            .uniforms
            .iter()
            .filter(|slot| **slot == [0.2, 0.4, 0.7, 1.0])
            .count(),
        1
    );
    assert_eq!(separate.source.matches("sin(").count(), 2);
    assert_eq!(shared.source.matches("sin(").count(), 1);
    validate(&separate.source).unwrap();
    validate(&shared.source).unwrap();
}

#[test]
fn shared_paint_under_two_uv_maps_reuses_values_not_coordinate_math() {
    let compiled = shader(|pixel| {
        let base = bands(pixel, 0.37, [0.2, 0.4, 0.7, 1.0]);
        base.clone()
            .shift_x(0.12)
            .over(base.clone().shift_x(-0.08))
            .over(base)
    })
    .compile();

    assert_eq!(compiled.stats.domain_expressions, 2);
    assert_eq!(compiled.source.matches("sin(").count(), 3);
    assert_eq!(count_uniform_component(&compiled, 0.37), 1);
    assert_eq!(
        compiled
            .uniforms
            .iter()
            .filter(|slot| **slot == [0.2, 0.4, 0.7, 1.0])
            .count(),
        1
    );
    assert_eq!(count_uniform_component(&compiled, 0.12), 1);
    assert_eq!(count_uniform_component(&compiled, -0.08), 1);
    validate(&compiled.source).unwrap();
}

#[test]
fn same_domain_shared_diamond_lowering_and_source_grow_linearly() {
    let shallow = diamond_recipe(4).compile();
    let deep = diamond_recipe(24).compile();

    assert_eq!(
        deep.stats.reachable_nodes - shallow.stats.reachable_nodes,
        2 * (24 - 4)
    );
    assert!(deep.stats.emitted_expressions <= shallow.stats.emitted_expressions + 4 * (24 - 4));
    assert!(deep.stats.expression_cache_hits >= 24);
    assert!(deep.source.len() < shallow.source.len() * 12);
    assert!(deep.stats.uniform_values > deep.uniforms.len());
    validate(&deep.source).unwrap();
}

fn mapped_diamond_recipe(depth: usize) -> shader_builder::Color {
    shader(|pixel| {
        let mut paint = bands(pixel, 0.29, [0.3, 0.5, 0.7, 1.0]);
        for _ in 0..depth {
            paint = paint.clone().shift_x(0.01).mix(paint.shift_x(-0.01), 0.5);
        }
        paint
    })
}

#[test]
fn distinct_map_domains_expand_shared_dags_and_need_a_budget() {
    // This deliberately shows why production budgets must count lowered
    // (node, coordinate-domain) pairs, not only unique Arc nodes.
    let shallow = mapped_diamond_recipe(4).compile();
    let deep = mapped_diamond_recipe(6).compile();

    assert!(deep.stats.reachable_nodes < shallow.stats.reachable_nodes * 2);
    assert!(deep.stats.domain_expressions > shallow.stats.domain_expressions * 3);
    assert!(deep.stats.emitted_expressions > shallow.stats.emitted_expressions * 3);
}

#[test]
fn mix_and_over_emit_grouped_weights_and_match_premultiplied_reference() {
    let front_straight = [0.8_f32, 0.2, 0.1, 0.5];
    let second_straight = [0.2_f32, 0.4, 0.6, 1.0];
    let back_straight = [0.1_f32, 0.1, 0.1, 1.0];
    let compiled = shader(|_| {
        color(front_straight)
            .mix(color(second_straight), 0.25)
            .over(color(back_straight))
    })
    .compile();

    assert!(!compiled.source.contains(" * 1.0 - "));
    assert!(
        compiled
            .source
            .lines()
            .any(|line| line.contains(": f32 = 1.0 - ") && line.contains(".w;"))
    );
    assert!(
        compiled
            .source
            .lines()
            .any(|line| { line.contains(": f32 = 1.0 - ") && !line.contains(".w;") })
    );

    let premultiply = |[r, g, b, a]: [f32; 4]| {
        let a = a.clamp(0.0, 1.0);
        [r * a, g * a, b * a, a]
    };
    let front = premultiply(front_straight);
    let second = premultiply(second_straight);
    let back = premultiply(back_straight);
    let mixed = std::array::from_fn::<_, 4, _>(|i| front[i] * 0.75 + second[i] * 0.25);
    let expected = std::array::from_fn::<_, 4, _>(|i| mixed[i] + back[i] * (1.0 - mixed[3]));
    for (actual, expected) in expected.into_iter().zip([0.3875, 0.2125, 0.225, 1.0]) {
        assert!(
            (actual - expected).abs() < 0.00001,
            "{actual} != {expected}"
        );
    }
    validate(&compiled.source).unwrap();
}

fn duration_per(total: Duration, iterations: usize) -> Duration {
    total / iterations as u32
}

/// Manual, ignored harness with no timing thresholds or allocator hooks.
#[test]
#[ignore = "manual prototype benchmark; run with --ignored --nocapture"]
fn benchmark_builder_phases_and_report_dag_size() {
    const CONSTRUCTION_ITERATIONS: usize = 10_000;
    const CLONE_ITERATIONS: usize = 100_000;
    const LOWER_ITERATIONS: usize = 200;
    const EMIT_ITERATIONS: usize = 200;
    const VALIDATE_ITERATIONS: usize = 50;
    const DEPTH: usize = 24;

    let construction_start = Instant::now();
    for index in 0..CONSTRUCTION_ITERATIONS {
        std::hint::black_box(realistic_recipe(
            index as f32 * 0.01,
            [0.2, 0.3, 0.4, 1.0],
            0.7,
            [0.7, 0.2, 0.1, 1.0],
            0.8,
        ));
    }
    let construction = construction_start.elapsed();

    let paint = diamond_recipe(DEPTH);
    let clone_start = Instant::now();
    for _ in 0..CLONE_ITERATIONS {
        std::hint::black_box(paint.clone());
    }
    let cloning = clone_start.elapsed();

    let lower_start = Instant::now();
    let mut lowered = None;
    for _ in 0..LOWER_ITERATIONS {
        lowered = Some(paint.lower());
    }
    let lowering = lower_start.elapsed();
    let lowered = lowered.expect("benchmark has at least one iteration");

    let emit_start = Instant::now();
    for _ in 0..EMIT_ITERATIONS {
        std::hint::black_box(lowered.emit());
    }
    let emission = emit_start.elapsed();
    let compiled = lowered.compile();

    let validation_start = Instant::now();
    for _ in 0..VALIDATE_ITERATIONS {
        validate(std::hint::black_box(&compiled.source)).unwrap();
    }
    let validation = validation_start.elapsed();

    eprintln!(
        "builder probe: construction_workload=realistic_recipe, \
         other_workloads=diamond_recipe, depth={DEPTH}, reachable_nodes={}, scalar_nodes={}, color_nodes={}, \
         node_payload_bytes_lower_bound={}, unique_uniforms={}, vec4_slots={}, \
         uniform_bytes={}, emitted_expressions={}, source_bytes={}; \
         construction={:?}, clone={:?}, lower_ir={:?}, emit_wgsl={:?}, naga_parse_validate={:?} \
         (per iteration: {:?}, {:?}, {:?}, {:?}, {:?})",
        compiled.stats.reachable_nodes,
        compiled.stats.scalar_nodes,
        compiled.stats.color_nodes,
        compiled.stats.node_payload_bytes_lower_bound,
        compiled.stats.uniform_values,
        compiled.uniforms.len(),
        compiled.uniforms.len() * 16,
        compiled.stats.emitted_expressions,
        compiled.source.len(),
        construction,
        cloning,
        lowering,
        emission,
        validation,
        duration_per(construction, CONSTRUCTION_ITERATIONS),
        duration_per(cloning, CLONE_ITERATIONS),
        duration_per(lowering, LOWER_ITERATIONS),
        duration_per(emission, EMIT_ITERATIONS),
        duration_per(validation, VALIDATE_ITERATIONS),
    );
}

#[test]
fn direct_color_and_paint_helpers_compose_with_the_same_concrete_type() {
    let show_procedural = std::hint::black_box(true);
    let selected_by_host_control_flow = if show_procedural {
        color([0.4, 0.2, 0.1, 1.0])
    } else {
        shader(|pixel| bands(pixel, 0.3, [0.2, 0.3, 0.4, 1.0]))
    };
    let compiled = selected_by_host_control_flow
        .mix(color([0.1, 0.3, 0.7, 1.0]), 0.4)
        .opacity(0.8)
        .compile();

    assert_eq!(
        compiled.source.matches("clamp(fragment.coverage").count(),
        1
    );
    validate(&compiled.source).unwrap();
}

#[test]
fn pixel_math_can_build_premultiplied_custom_rgba() {
    let compiled = shader(|pixel| {
        let x = pixel.uv().x();
        let y = pixel.uv().y();
        rgba(
            x.clone().sin() * 0.5 + 0.5,
            y.clone().sin() * 0.5 + 0.5,
            (x + y).sin() * 0.5 + 0.5,
            0.75,
        )
        .over(color([0.0, 0.0, 0.0, 1.0]))
    })
    .compile();

    assert!(compiled.source.contains("fragment.uv.x"));
    assert!(compiled.source.contains("fragment.uv.y"));
    let premultiply = compiled
        .source
        .lines()
        .find(|line| line.contains(": vec4f = vec4f("))
        .expect("rgba helper should emit a vector constructor");
    assert!(premultiply.contains(" * "));
    assert_eq!(count_uniform_component(&compiled, 0.75), 1);
    assert_eq!(
        compiled.source.matches("clamp(fragment.coverage").count(),
        1
    );
    validate(&compiled.source).unwrap();
}

#[test]
fn rgba_siblings_keep_clamped_alphas_and_changed_values_keep_source() {
    let first =
        shader(|_| rgba(0.91, 0.31, 0.22, 0.23).over(rgba(0.11, 0.42, 0.93, 0.83))).compile();
    let changed =
        shader(|_| rgba(0.91, 0.31, 0.22, 0.37).over(rgba(0.11, 0.42, 0.93, 0.71))).compile();

    assert_eq!(first.source, changed.source);
    assert_eq!(count_uniform_component(&first, 0.23), 1);
    assert_eq!(count_uniform_component(&first, 0.83), 1);
    assert_ne!(first.uniforms, changed.uniforms);
    assert_eq!(first.source.matches("clamp(").count(), 3);
    validate(&first.source).unwrap();
}

#[test]
fn default_float_values_are_uniforms_and_constants_are_explicit() {
    let dynamic_a =
        shader(|_| color([0.3, 0.4, 0.5, 1.0]).mix(color([0.6, 0.2, 0.1, 1.0]), 0.25)).compile();
    let dynamic_b =
        shader(|_| color([0.3, 0.4, 0.5, 1.0]).mix(color([0.6, 0.2, 0.1, 1.0]), 0.75)).compile();
    assert_eq!(dynamic_a.source, dynamic_b.source);
    assert_ne!(dynamic_a.uniforms, dynamic_b.uniforms);

    let constant_a = shader(|_| {
        color([0.3, 0.4, 0.5, 1.0]).mix(color([0.6, 0.2, 0.1, 1.0]), Scalar::constant(0.25))
    })
    .compile();
    let constant_b = shader(|_| {
        color([0.3, 0.4, 0.5, 1.0]).mix(color([0.6, 0.2, 0.1, 1.0]), Scalar::constant(0.75))
    })
    .compile();
    assert_ne!(constant_a.source, constant_b.source);
    assert_eq!(constant_a.uniforms, constant_b.uniforms);
}
