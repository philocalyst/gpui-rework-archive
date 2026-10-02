use super::{
    Paint, Scalar, color, constant, reset_shader_cache_stats, rgba, shader, shader_cache_stats,
    vec2,
};
use crate::shader::ShaderError;

#[test]
fn rebuilt_recipe_reuses_program_and_updates_uniform_values() {
    fn stripes(phase: f32) -> Paint {
        shader(|pixel| {
            let phase: Scalar = phase.into();
            let x = pixel.uv().x();
            let bands = (x * 9.0 + phase).sin() * 0.5 + 0.5;
            rgba(bands, 0.2, 0.4, 1.0)
        })
    }

    let first = stripes(0.2).compile().expect("first recipe compiles");
    let second = stripes(0.7).compile().expect("same recipe compiles");
    assert_eq!(first.program_id(), second.program_id());
    assert_eq!(first.wgsl(), second.wgsl());
    assert_ne!(first.parameter_slots(), second.parameter_slots());
}

#[test]
fn cloned_paint_handles_share_the_per_paint_compile_memo() {
    reset_shader_cache_stats();
    let paint = rgba(0.1, 0.2, 0.3, 1.0);
    let cloned = paint.clone();

    cloned.compile().expect("clone compiles");
    let after_clone = shader_cache_stats();
    paint.compile().expect("original reuses clone result");
    let after_original = shader_cache_stats();

    assert_eq!(
        after_clone.packed_parameter_bytes,
        after_original.packed_parameter_bytes
    );
}

#[test]
fn equal_values_keep_shared_and_independent_uniforms_distinct() {
    let shared: Scalar = 0.25.into();
    let shared_paint = rgba(&shared, &shared, &shared, 1.0);
    let independent_paint = rgba(0.25, 0.25, 0.25, 1.0);

    let shared_compiled = shared_paint.compile().expect("shared recipe compiles");
    let independent_compiled = independent_paint
        .compile()
        .expect("independent recipe compiles");

    assert_eq!(shared_compiled.parameter_slots().len(), 1);
    assert_eq!(independent_compiled.parameter_slots().len(), 1);
    assert_ne!(
        shared_compiled.parameter_slots(),
        independent_compiled.parameter_slots()
    );
    assert_ne!(shared_compiled.wgsl(), independent_compiled.wgsl());
    assert!(independent_compiled.node_count() > shared_compiled.node_count());
    assert_ne!(shared_paint, independent_paint);
}

#[test]
fn scalar_lanes_resume_after_a_full_color_uniform() {
    let first: Scalar = 0.1.into();
    let second: Scalar = 0.2.into();
    let top = rgba(&first, &first, &first, 0.5);
    let middle = top.over(color([0.0, 0.4, 0.8, 1.0]));
    let bottom = rgba(&second, &second, &second, 0.5);

    let compiled = middle
        .over(bottom)
        .compile()
        .expect("layered recipe compiles");

    // The top and bottom scalar uniforms fit in the partially occupied scalar
    // slot even though a vec4 color uniform is visited between them.
    assert_eq!(compiled.parameter_slots().len(), 2);
}

#[test]
fn compiler_rejects_nonfinite_cpu_colors() {
    let paint = color([0.1, 0.2, 0.3, f32::INFINITY]);
    assert_eq!(paint.compile(), Err(ShaderError::NonFiniteValue));
    assert_eq!(paint.compile(), Err(ShaderError::NonFiniteValue));
}

#[test]
fn mapped_shared_paints_stop_at_the_expanded_context_budget() {
    let mut paint = color([0.2, 0.5, 0.8, 1.0]);
    for _ in 0..15 {
        let left = paint.map_uv(|uv| uv + vec2(0.01, 0.0));
        let right = paint.map_uv(|uv| uv - vec2(0.02, 0.0));
        paint = left.over(right);
    }

    assert_eq!(paint.compile(), Err(ShaderError::TooManyExpandedContexts));
}

#[test]
fn excessive_depth_is_reported_without_recursive_drop() {
    let mut paint = color([0.2, 0.5, 0.8, 1.0]);
    for _ in 0..=super::compiler::MAX_DEPTH {
        paint = paint.opacity(0.99);
    }
    assert_eq!(paint.compile(), Err(ShaderError::TooDeep));
}

#[test]
fn uniform_count_budget_is_enforced_before_lowering() {
    let mut level: Vec<_> = (0..=super::compiler::MAX_UNIFORMS)
        .map(|value| Scalar::uniform(value as f32))
        .collect();
    while level.len() > 1 {
        let mut next = Vec::with_capacity(level.len().div_ceil(2));
        let mut fields = level.into_iter();
        while let Some(left) = fields.next() {
            if let Some(right) = fields.next() {
                next.push(left + right);
            } else {
                next.push(left);
            }
        }
        level = next;
    }
    let sum = level
        .into_iter()
        .next()
        .unwrap_or_else(|| Scalar::constant(0.0));

    assert_eq!(
        rgba(sum, 0.0, 0.0, 1.0).compile(),
        Err(ShaderError::TooManyUniforms)
    );
}

#[test]
fn unique_node_budget_is_enforced_for_balanced_recipes() {
    let mut level: Vec<_> = (0..2048).map(|value| constant(value as f32)).collect();
    while level.len() > 1 {
        let mut next = Vec::with_capacity(level.len().div_ceil(2));
        let mut fields = level.into_iter();
        while let Some(left) = fields.next() {
            if let Some(right) = fields.next() {
                next.push(left + right);
            } else {
                next.push(left);
            }
        }
        level = next;
    }
    let sum = level.into_iter().next().unwrap_or_else(|| constant(0.0));

    assert_eq!(
        rgba(sum, 0.0, 0.0, 1.0).compile(),
        Err(ShaderError::TooManyNodes)
    );
}

#[test]
fn generated_wgsl_source_size_budget_is_enforced() {
    let shared: Scalar = 0.1.into();
    let mut level = vec![shared; 4050];
    while level.len() > 1 {
        let mut next = Vec::with_capacity(level.len().div_ceil(2));
        let mut fields = level.into_iter();
        while let Some(left) = fields.next() {
            if let Some(right) = fields.next() {
                next.push(left + right);
            } else {
                next.push(left);
            }
        }
        level = next;
    }
    let sum = level
        .into_iter()
        .next()
        .unwrap_or_else(|| Scalar::constant(0.0));

    assert_eq!(
        rgba(sum, 0.0, 0.0, 1.0).compile(),
        Err(ShaderError::SourceTooLarge)
    );
}

#[test]
fn constant_is_embedded_but_cpu_float_is_a_uniform() {
    let dynamic = rgba(0.1, 0.2, 0.3, 1.0)
        .compile()
        .expect("dynamic recipe compiles");
    let fixed = shader(|pixel| {
        let wave = (pixel.uv().x() * constant(8.0)).sin();
        rgba(wave, 0.2, 0.3, 1.0)
    })
    .compile()
    .expect("constant recipe compiles");

    assert!(dynamic.parameter_slots().len() > 0);
    assert!(fixed.wgsl().contains("8.0"));
}
