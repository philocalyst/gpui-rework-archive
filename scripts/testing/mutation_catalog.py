"""Focused mutation operators and the tests expected to reject them."""
import dataclasses

@dataclasses.dataclass(frozen=True)
class Mutant:
    name: str
    description: str
    source: str
    before: str
    after: str
    command_name: str
    command: tuple[str, ...]
    environment: tuple[tuple[str, str], ...] = ()
    failure_marker: str | None = None


CPU = "crates/gpui_render/src/cpu.rs"
CPU_FRAME = "crates/gpui_render/src/cpu/frame.rs"
PATH_TYPES = "crates/gpui_render/src/path_types.rs"
RUNNER = "crates/gpui_test/src/runner.rs"
GALLERY = "crates/gpui_test/src/gallery/views.rs"
CAPTURE = "crates/gpui/src/scene/capture.rs"
REPORT = "crates/gpui_test/src/report.rs"
IMAGE_DIFF = "crates/gpui_test/src/image_diff.rs"
FONT = "crates/gpui_render/src/font.rs"
GPUI_TEST = "crates/gpui/src/test.rs"
PARLEY_TEXT = "crates/gpui_ce_parley/src/text_system.rs"
SHADER_COMMON = "crates/gpui_render/src/shaders/common.rs"
WGPU_CONTEXT = "crates/gpui_wgpu/src/wgpu_context.rs"
WGPU_PIPELINES = "crates/gpui_wgpu/src/wgpu_renderer/pipelines.rs"
SCENE = "crates/gpui/src/scene.rs"
IMAGE = "crates/gpui/src/elements/img.rs"
WGPU_HEADLESS = "crates/gpui_wgpu/src/wgpu_renderer/headless.rs"
REPORT_COLLECTION_TEST = (
    "cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--test",
    "report_collection", "collect_reports_rejects_pixel_conflicts_for_duplicate_ids",
)

GPU_CAPTURE_TEST = (
    "cargo", "test", "--offline", "-p", "gpui_ce_wgpu", "--features", "test-support",
    "--test", "capture_parity", "captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles",
)

MUTANTS: tuple[Mutant, ...] = (
    Mutant(
        "skip-underlines",
        "Skip drawing compiled underline batches.",
        CPU,
        "target.draw_underline(item);",
        "let _ = item;",
        "colored multiline Parley underline pixels",
        ("cargo", "test", "--offline", "-p", "gpui_ce_test", "--test", "state_regressions", "wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines"),
        failure_marker="the CPU raster must include colored underline pixels",
    ),
    Mutant(
        "source-over-alpha",
        "Replace accumulated alpha with foreground alpha in source-over.",
        CPU_FRAME,
        "below[3] = color[3] + below[3] * inverse;",
        "below[3] = color[3];",
        "source-over alpha property and unit law",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--test", "cpu_properties", "overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs"),
        failure_marker="actual channel",
    ),
    Mutant(
        "ignore-glyph-transform",
        "Render monochrome glyphs without their scene transform.",
        CPU,
        "item.color.into(),\n                            item.tile,\n                            Some(item.transformation),\n                            SpriteKind::Mono,",
        "item.color.into(),\n                            item.tile,\n                            None,\n                            SpriteKind::Mono,",
        "transformed monochrome glyph destination pixels",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--test", "cpu_properties", "monochrome_glyph_samples_at_transformed_destination_coordinates"),
    ),
    Mutant(
        "ignore-font-gamma",
        "Force neutral coverage correction even when a platform requests gamma correction.",
        FONT,
        "gamma_ratios: get_gamma_correction_ratios(gamma),",
        "gamma_ratios: get_gamma_correction_ratios(1.0),",
        "analytic half-glyph gamma correction",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--test", "cpu_properties", "font_gamma_correction_preserves_neutral_and_corrects_half_coverage"),
        failure_marker="gamma 2.2 should map half coverage",
    ),
    Mutant(
        "ignore-subpixel-order",
        "Ignore the configured panel order when packing font rasterization uniforms.",
        FONT,
        "self.subpixel_order == SubpixelOrder::BlueGreenRed,",
        "false,",
        "RGB and BGR channel mapping",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--test", "cpu_properties", "subpixel_order_reverses_red_and_blue_coverage_channels"),
    ),
    Mutant(
        "drop-filter-opacity",
        "Ignore the content-filter group's opacity during compositing.",
        'crates/gpui_render/src/cpu/frame/filters.rs',
        "let factor = mask * boundary.opacity;",
        "let factor = mask;",
        "nested filter composite opacity and inline depth",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--lib", "nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target"),
    ),
    Mutant(
        "inline-boundary-not-stacked",
        "Fail to push the inline filter's matching stack marker.",
        CPU,
        "} else {\n                    stack.push(None);\n                }",
        "} else {\n                    let _ = render_target;\n                }",
        "nested inline filter boundary stack law",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--lib", "nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target"),
        failure_marker="mismatched CPU filter command stream",
    ),
    Mutant(
        "path-half-open-edges",
        "Treat every path triangle edge as included, double-covering shared pixels.",
        CPU_FRAME,
        "*weight > EDGE_EPSILON || {",
        "*weight > EDGE_EPSILON || true || {",
        "path shared-edge pixel is rasterized once",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--test", "cpu_properties", "adjacent_path_triangles_assign_shared_edge_pixels_once"),
    ),
    Mutant(
        "ignore-path-raster-clip",
        "Use the un-clipped path bounds when preparing the path paint gradient.",
        'crates/gpui_render/src/cpu/frame/primitives.rs',
        "let bounds = path.clipped_bounds();",
        "let bounds = path.bounds;",
        "clipped path gradient uses clipped paint bounds",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--test", "cpu_properties", "clipped_path_gradient_uses_the_clipped_paint_bounds"),
        failure_marker="clipped 0-to-1 sRGB gradient",
    ),
    Mutant(
        "ignore-path-content-clip",
        "Build the path composite sprite using raw path bounds rather than clipped bounds.",
        PATH_TYPES,
        "bounds: path.clipped_bounds(),",
        "bounds: path.bounds,",
        "path composite sprite bounds match the content clip",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--test", "cpu_properties", "path_composite_sprite_bounds_match_the_content_clip"),
    ),
    Mutant(
        "freeze-animation-clock",
        "Ignore elapsed simulated time at each scenario checkpoint.",
        RUNNER,
        "cx.advance_clock(checkpoint.at - previous_at);",
        "cx.advance_clock(Duration::ZERO);",
        "animation time advances and repeat phase",
        ("cargo", "test", "--offline", "-p", "gpui_ce_test", "--test", "state_regressions", "fixed_animation_times_are_idempotent_and_cross_repeat_boundaries"),
        failure_marker="ease-in-out at 250 ms",
    ),
    Mutant(
        "disable-animation-repeat",
        "Remove repeat behavior from the gallery motion scenario.",
        GALLERY,
        ".repeat()",
        "",
        "repeat phase at 1250 ms returns near start",
        ("cargo", "test", "--offline", "-p", "gpui_ce_test", "--test", "state_regressions", "fixed_animation_times_are_idempotent_and_cross_repeat_boundaries"),
        failure_marker="repeat phase at 1250 ms",
    ),
    Mutant(
        "linearize-animation-easing",
        "Replace ease-in-out with linear progress.",
        GALLERY,
        ".with_easing(ease_in_out)",
        ".with_easing(|progress| progress)",
        "analytic eased marker position at 250 ms",
        ("cargo", "test", "--offline", "-p", "gpui_ce_test", "--test", "state_regressions", "fixed_animation_times_are_idempotent_and_cross_repeat_boundaries"),
        failure_marker="ease-in-out at 250 ms",
    ),
    Mutant(
        "accept-unsupported-capture-version",
        "Accept any positive serialized scene-capture version.",
        CAPTURE,
        "self.version == SCENE_CAPTURE_VERSION,",
        "self.version > 0,",
        "capture rejects unsupported format versions",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--test", "capture_validation", "rejects_version_mutation_and_non_finite_filter_encoding"),
    ),
    Mutant(
        "ignore-removed-checkpoints",
        "Omit baseline checkpoints that are absent from the current report.",
        'crates/gpui_test/src/report/comparison.rs',
        '''                changes.push(change(
                    ReportChangeKind::CheckpointRemoved,
                    id,
                    Some(checkpoint_id),
                    "checkpoint removed",
                ));''',
        "                let _ = checkpoint_id;",
        "report comparison detects removed checkpoints",
        ("cargo", "test", "--offline", "-p", "gpui_ce_test", "--test", "state_regressions", "report_comparison_reports_removed_checkpoints"),
    ),
    Mutant(
        "drop-observation-events",
        "Do not enqueue observer notifications in the test observation stream.",
        GPUI_TEST,
        "let _ = tx.try_send(());",
        "let _ = ();",
        "entity observation receives successive notify events",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui-ce", "--lib", "observation_stream_receives_each_notify_and_unsubscribes_on_drop"),
    ),
    Mutant(
        "ignore-selected-report-scenarios",
        "Compare every current scenario even when the report call selects a subset.",
        'crates/gpui_test/src/report/comparison.rs',
        '''    let new_scenarios: BTreeMap<_, _> = current
        .scenarios
        .iter()
        .filter(|scenario| selected_ids.is_empty() || selected_ids.contains(&scenario.id))
        .map(|scenario| (scenario.id.as_str(), scenario))
        .collect();''',
        '''    let new_scenarios: BTreeMap<_, _> = current
        .scenarios
        .iter()
        .map(|scenario| (scenario.id.as_str(), scenario))
        .collect();''',
        "selected report comparison excludes unrelated scenario changes",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--test", "state_regressions", "report_comparison_reports_removed_checkpoints"),
        failure_marker="unselected additions and removals must be excluded",
    ),
    Mutant(
        "retain-cpu-frame-ghosts",
        "Skip clearing the retained CPU target before replaying the next scene.",
        CPU_FRAME,
        "self.pixels.fill([0.; 4]);",
        "let _ = self.pixels.len();",
        "retained frame matches fresh renderer after removals and resizes",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--test", "cpu_properties", "retained_cpu_frame_matches_fresh_renderer_after_generated_removals_and_resizes"),
        failure_marker="retained frame differs",
    ),
    Mutant(
        "drop-above-alpha-clamp",
        "Allow dithered foreground alpha outside the fixed-function blend range.",
        SHADER_COMMON,
        "let above_alpha = saturate(above.w);",
        "let above_alpha = above.w;",
        "generated source-over alpha and out-of-range foreground edge",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--test", "cpu_properties", "shader_source_over_matches_independent_straight_alpha_reference"),
        failure_marker="alpha above one over opaque black",
    ),
    Mutant(
        "drop-below-alpha-clamp",
        "Allow dithered destination alpha outside the fixed-function blend range.",
        SHADER_COMMON,
        "let below_alpha = saturate(below.w);",
        "let below_alpha = below.w;",
        "generated source-over alpha reference",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--test", "cpu_properties", "shader_source_over_matches_independent_straight_alpha_reference"),
        failure_marker="source-over channel",
    ),
    Mutant(
        "gpu-alpha-adds-destination-alpha",
        "Use additive destination alpha in WGPU source-over replay.",
        WGPU_PIPELINES,
        '''fn source_over_blend_state(source_color_factor: wgpu::BlendFactor) -> wgpu::BlendState {
    wgpu::BlendState {
        color: wgpu::BlendComponent {
            src_factor: source_color_factor,
            dst_factor: wgpu::BlendFactor::OneMinusSrcAlpha,
            operation: wgpu::BlendOperation::Add,
        },
        alpha: wgpu::BlendComponent {
            src_factor: wgpu::BlendFactor::One,
            dst_factor: wgpu::BlendFactor::OneMinusSrcAlpha,
            operation: wgpu::BlendOperation::Add,
        },
    }
}''',
        '''fn source_over_blend_state(source_color_factor: wgpu::BlendFactor) -> wgpu::BlendState {
    wgpu::BlendState {
        color: wgpu::BlendComponent {
            src_factor: source_color_factor,
            dst_factor: wgpu::BlendFactor::OneMinusSrcAlpha,
            operation: wgpu::BlendOperation::Add,
        },
        alpha: wgpu::BlendComponent {
            src_factor: wgpu::BlendFactor::One,
            dst_factor: wgpu::BlendFactor::One,
            operation: wgpu::BlendOperation::Add,
        },
    }
}''',
        "native WGPU replay preserves analytic source-over alpha",
        GPU_CAPTURE_TEST,
        (("GPUI_REQUIRE_GPU", "1"),),
        "blue over red GPU",
    ),
    Mutant(
        "omit-supported-gpu-timestamps",
        "Never request optional encoder timestamp-query features for measured replay.",
        WGPU_CONTEXT,
        "Self::new_headless_internal(None, true)",
        "Self::new_headless_internal(None, false)",
        "measured renderer enables timestamps supported by its selected adapter",
        GPU_CAPTURE_TEST,
        (("GPUI_REQUIRE_GPU", "1"),),
        "measurement renderer should enable timestamp queries",
    ),
    Mutant(
        "transpose-cpu-sprite-transform",
        "Transpose the row-major matrix when preparing CPU sprite coordinates.",
        CPU_FRAME,
        "rotation_scale: mat2x2f(vec2f(rows[0][0], rows[0][1]), vec2f(rows[1][0], rows[1][1])),",
        "rotation_scale: mat2x2f(vec2f(rows[0][0], rows[1][0]), vec2f(rows[0][1], rows[1][1])),",
        "CPU transformed position follows the scene matrix law",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--lib", "transformed_position_matches_the_scene_matrix_law"),
    ),
    Mutant(
        "ignore-transformed-scene-paint-bounds",
        "Cull transformed sprites using their untransformed bounds.",
        SCENE,
        "let paint_bounds = primitive.paint_bounds();",
        "let paint_bounds = *primitive.bounds();",
        "transformed sprite culling uses screen-space bounds",
        ("cargo", "test", "--offline", "-p", "gpui-ce", "--lib", "rotated_sprite_is_culled_when_only_its_untransformed_bounds_hit_the_mask"),
    ),
    Mutant(
        "freeze-animated-image-clock",
        "Return the current image frame without consuming simulated elapsed time.",
        IMAGE,
        "if elapsed < current_delay {",
        "if elapsed < current_delay || elapsed >= current_delay {",
        "animated image advances from the simulated clock",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui-ce", "--lib", "animation_clock_preserves_elapsed_time_across_frame_delays"),
    ),
    Mutant(
        "drop-animated-image-remainder",
        "Discard elapsed time remaining after a GIF frame-cycle boundary.",
        IMAGE,
        "let remainder_ns = elapsed.as_nanos() % cycle_ns;",
        "let remainder_ns = 0;",
        "animated image preserves elapsed time across frame delays",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui-ce", "--lib", "animation_clock_preserves_elapsed_time_across_frame_delays"),
    ),
    Mutant(
        "accept-conflicting-duplicate-report-pixels",
        "Skip comparing canonical checkpoint images when duplicate scenario IDs are collected.",
        'crates/gpui_test/src/report/reader.rs',
        "&& left.image == right.image",
        "&& true",
        "report collection rejects duplicate pixel conflicts",
        REPORT_COLLECTION_TEST,
        failure_marker="called `Result::unwrap_err()` on an `Ok` value",
    ),
    Mutant(
        "accept-reversed-gpu-timestamps",
        "Saturate a reversed GPU timestamp interval to zero instead of rejecting it.",
        WGPU_HEADLESS,
        "let ticks = end\n        .checked_sub(start)\n        .ok_or_else(|| anyhow::anyhow!(\"GPU timestamp end ({end}) precedes start ({start})\"))?;",
        "let ticks = end.saturating_sub(start);",
        "GPU timestamp conversion rejects reversed intervals",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_wgpu", "--features", "test-support", "--lib", "timestamp_duration_requires_a_valid_order_and_finite_range"),
    ),
    Mutant(
        "use-submission-order-for-gpu-timestamp-envelope",
        "Use submission order instead of the minimum start and maximum end across overlapping passes.",
        WGPU_HEADLESS,
        "Some((first_start, last_end)) => (first_start.min(start), last_end.max(end)),",
        "Some((first_start, _last_end)) => (first_start, end),",
        "GPU timestamp envelope covers overlapping render passes",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_wgpu", "--features", "test-support", "--lib", "timestamp_envelope_contains_overlapping_passes_and_rejects_bad_pairs"),
    ),
    Mutant(
        "compare-scene-storage-bytes",
        "Compare stored scene bytes instead of the validated capture value, misclassifying equivalent legacy JSON and gzip encodings.",
        'crates/gpui_test/src/report/writer/scenario.rs',
        "Ok(read_capture(&artifact_path(root, &previous.scene_json)?)?\n                        != checkpoint.capture)",
        "Ok(fs::read(artifact_path(root, &previous.scene_json)?)?\n                        != gzip_scene_json(&serde_json::to_vec(&checkpoint.capture)?)?)",
        "legacy JSON baseline compares semantically equal to gzip output",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--test", "report_collection", "gzip_scene_artifacts_are_deterministic_and_compare_equal_to_legacy_json"),
    ),
    Mutant(
        "ignore-alpha-only-visible-error",
        "Omit alpha differences from the alpha-aware visible error metrics.",
        'crates/gpui_test/src/image_diff/images.rs',
        "let visible_error = if channel == 3 {\n                    f64::from(a[3].abs_diff(b[3]))\n                } else {",
        "let visible_error = if channel == 3 {\n                    0.0\n                } else {",
        "alpha-only changes count as visible differences",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--lib", "alpha_only_change_contributes_visible_error"),
    ),
    Mutant(
        "count-hidden-transparent-rgb-as-visible",
        "Compare straight RGB values instead of alpha-premultiplied channels when measuring visibility.",
        'crates/gpui_test/src/image_diff/images.rs',
        "let a_premultiplied = u16::from(a[channel]) * u16::from(a[3]);\n                    let b_premultiplied = u16::from(b[channel]) * u16::from(b[3]);\n                    f64::from(a_premultiplied.abs_diff(b_premultiplied)) / 255.0",
        "f64::from(a[channel].abs_diff(b[channel]))",
        "hidden transparent RGB changes stay invisible",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--lib", "invisible_transparent_rgb_changes_are_exact_but_not_visible"),
    ),
    Mutant(
        "ignore-transparent-image-extent",
        "Treat transparent pixels outside one image's bounds as unchanged instead of exact extent changes.",
        'crates/gpui_test/src/image_diff/images.rs',
        "let mut exact_changed = resized_pixel;",
        "let mut exact_changed = false;",
        "transparent out-of-bounds pixels count as exact size changes",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--lib", "transparent_out_of_bounds_pixels_still_count_as_exact_size_changes"),
    ),
    Mutant(
        "drop-motion-transition-error",
        "Ignore per-pixel signed motion deltas when comparing adjacent frames.",
        'crates/gpui_test/src/image_diff/motion.rs',
        "let error = f64::from((before_delta - current_delta).unsigned_abs()) / 255.0;",
        "let error = 0.0;",
        "motion comparison detects a frozen current frame",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--lib", "motion_detects_a_frozen_frame_and_different_opacity"),
    ),
    Mutant(
        "publish-after-failed-add",
        "Allow ReportWriter::finish to publish a staged report after an add operation failed.",
        'crates/gpui_test/src/report/writer.rs',
        "self.failed |= result.is_err();",
        "let _ = result.is_err();",
        "failed report writes preserve the prior published report",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--test", "report_collection", "failed_report_write_preserves_existing_report_and_refuses_unrelated_directories"),
    ),
    Mutant(
        "drop-transition-exact-mask",
        "Render the checkerboard context instead of a red mask for motion-difference pixels.",
        'crates/gpui_test/src/image_diff/motion.rs',
        "DiffMode::Exact if changed => image::Rgba([255, 32, 32, 255]),",
        "DiffMode::Exact if changed => context,",
        "transition visualization marks motion, transparent extent, and catch-up differences",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--lib", "transition_visualization_marks_motion_and_transparent_extent"),
    ),
)


