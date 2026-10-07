#!/usr/bin/env python3
"""Run focused pseudo-source mutants in an isolated archive of HEAD.

The runner never edits the caller's checkout. Each trial restores its exact source file bytes
before running the next trial; a fresh temporary archive is discarded at exit. Each campaign gets
a unique Cargo cache under target/pseudo-mutation, keeping mutant executables out of normal builds
and ensuring prior campaigns cannot contaminate baseline checks.
"""
from __future__ import annotations

import argparse
import dataclasses
import datetime as dt
import os
import pathlib
import signal
import subprocess
import sys
import tarfile
import tempfile
import time
from typing import Sequence


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
        CPU_FRAME,
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
        CPU_FRAME,
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
        REPORT,
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
        REPORT,
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
        "undo-underline-y-down-offset",
        "Pass Parley's y-up underline offset directly into GPUI's y-down paint coordinates.",
        PARLEY_TEXT,
        "underline_offset: Some(px(-run_metrics.underline_offset)),",
        "underline_offset: Some(px(run_metrics.underline_offset)),",
        "bundled-font underline offset sign law",
        ("cargo", "test", "--offline", "-p", "gpui_ce_parley", "decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts"),
        failure_marker="underline offset",
    ),
    Mutant(
        "undo-strikethrough-y-down-offset",
        "Pass Parley's y-up strikethrough offset directly into GPUI's y-down paint coordinates.",
        PARLEY_TEXT,
        "strikethrough_offset: Some(px(-run_metrics.strikethrough_offset)),",
        "strikethrough_offset: Some(px(run_metrics.strikethrough_offset)),",
        "bundled-font strikethrough offset sign law",
        ("cargo", "test", "--offline", "-p", "gpui_ce_parley", "decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts"),
        failure_marker="strikethrough offset",
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
        REPORT,
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
        REPORT,
        "Ok(read_capture(&artifact_path(root, &previous.scene_json)?)?\n                        != checkpoint.capture)",
        "Ok(fs::read(artifact_path(root, &previous.scene_json)?)?\n                        != gzip_scene_json(&serde_json::to_vec(&checkpoint.capture)?)?)",
        "legacy JSON baseline compares semantically equal to gzip output",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--test", "report_collection", "gzip_scene_artifacts_are_deterministic_and_compare_equal_to_legacy_json"),
    ),
    Mutant(
        "ignore-alpha-only-visible-error",
        "Omit alpha differences from the alpha-aware visible error metrics.",
        IMAGE_DIFF,
        "let visible_error = if channel == 3 {\n                    f64::from(a[3].abs_diff(b[3]))\n                } else {",
        "let visible_error = if channel == 3 {\n                    0.0\n                } else {",
        "alpha-only changes count as visible differences",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--lib", "alpha_only_change_contributes_visible_error"),
    ),
    Mutant(
        "count-hidden-transparent-rgb-as-visible",
        "Compare straight RGB values instead of alpha-premultiplied channels when measuring visibility.",
        IMAGE_DIFF,
        "let a_premultiplied = u16::from(a[channel]) * u16::from(a[3]);\n                    let b_premultiplied = u16::from(b[channel]) * u16::from(b[3]);\n                    f64::from(a_premultiplied.abs_diff(b_premultiplied)) / 255.0",
        "f64::from(a[channel].abs_diff(b[channel]))",
        "hidden transparent RGB changes stay invisible",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--lib", "invisible_transparent_rgb_changes_are_exact_but_not_visible"),
    ),
    Mutant(
        "ignore-transparent-image-extent",
        "Treat transparent pixels outside one image's bounds as unchanged instead of exact extent changes.",
        IMAGE_DIFF,
        "let mut exact_changed = resized_pixel;",
        "let mut exact_changed = false;",
        "transparent out-of-bounds pixels count as exact size changes",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--lib", "transparent_out_of_bounds_pixels_still_count_as_exact_size_changes"),
    ),
    Mutant(
        "drop-motion-transition-error",
        "Ignore per-pixel signed motion deltas when comparing adjacent frames.",
        IMAGE_DIFF,
        "let error = f64::from((before_delta - current_delta).unsigned_abs()) / 255.0;",
        "let error = 0.0;",
        "motion comparison detects a frozen current frame",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--lib", "motion_detects_a_frozen_frame_and_different_opacity"),
    ),
    Mutant(
        "publish-after-failed-add",
        "Allow ReportWriter::finish to publish a staged report after an add operation failed.",
        REPORT,
        "self.failed |= result.is_err();",
        "let _ = result.is_err();",
        "failed report writes preserve the prior published report",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--test", "report_collection", "failed_report_write_preserves_existing_report_and_refuses_unrelated_directories"),
    ),
    Mutant(
        "drop-transition-exact-mask",
        "Render the checkerboard context instead of a red mask for motion-difference pixels.",
        IMAGE_DIFF,
        "DiffMode::Exact if changed => image::Rgba([255, 32, 32, 255]),",
        "DiffMode::Exact if changed => context,",
        "transition visualization marks motion, transparent extent, and catch-up differences",
        ("cargo", "test", "--offline", "--locked", "-p", "gpui_ce_test", "--lib", "transition_visualization_marks_motion_and_transparent_extent"),
    ),
)


def git_root(path: pathlib.Path) -> pathlib.Path:
    result = subprocess.run(
        ["git", "-C", str(path), "rev-parse", "--show-toplevel"],
        check=True,
        capture_output=True,
        text=True,
    )
    return pathlib.Path(result.stdout.strip()).resolve()


def campaign_target_dir(cache_root: pathlib.Path, commit: str, run_id: str) -> pathlib.Path:
    return cache_root / f"{commit}-{run_id}"


def baseline_key(mutant: Mutant) -> tuple[tuple[str, ...], tuple[tuple[str, str], ...]]:
    return mutant.command, mutant.environment


def preflight_anchors(root: pathlib.Path, mutants: Sequence[Mutant]) -> list[str]:
    problems = []
    for mutant in mutants:
        path = root / mutant.source
        if not path.is_file():
            problems.append(f"{mutant.name}: missing mutation source {mutant.source}")
            continue
        occurrences = path.read_bytes().count(mutant.before.encode())
        if occurrences != 1:
            problems.append(
                f"{mutant.name}: expected one exact anchor in {mutant.source}, found {occurrences}"
            )
    return problems


def archive_revision(repo: pathlib.Path, destination: pathlib.Path, revision: str) -> None:
    archive_path = destination.parent / "head.tar"
    with archive_path.open("wb") as archive:
        subprocess.run(
            ["git", "-C", str(repo), "archive", "--format=tar", revision],
            check=True,
            stdout=archive,
        )
    with tarfile.open(archive_path, "r:") as archive:
        archive.extractall(destination, filter="data")
    archive_path.unlink()


def apply_mutation(root: pathlib.Path, mutant: Mutant) -> bytes:
    path = root / mutant.source
    original = path.read_bytes()
    needle = mutant.before.encode()
    occurrences = original.count(needle)
    if occurrences != 1:
        raise RuntimeError(
            f"{mutant.name}: expected one exact mutation anchor in {mutant.source}, found {occurrences}"
        )
    path.write_bytes(original.replace(needle, mutant.after.encode(), 1))
    return original


def classify(returncode: int, output: str, failure_marker: str | None = None) -> str:
    lowered = output.lower()
    if "running 0 tests" in lowered or "0 passed; 0 failed" in lowered:
        return "invalid"
    if any(token in lowered for token in ("could not compile", "error[e", "rustc-llvm error", "failed to run custom build command")):
        return "invalid"
    if returncode == 0:
        return "survived"
    assertion_output = any(
        token in lowered
        for token in (
            "assertion `left == right` failed",
            "assertion failed:",
            "assertion failed",
            "test failed: assertion",
        )
    )
    marked_failure = failure_marker is not None and failure_marker.lower() in lowered
    if "test result: failed" in lowered and (assertion_output or marked_failure):
        return "killed"
    return "invalid"


def concise_test_output(output: str) -> str:
    lines = output.splitlines()
    run_markers = [
        index
        for index, line in enumerate(lines)
        if line.startswith("Running ") or line.startswith("running ")
    ]
    if run_markers:
        lines = lines[run_markers[-1] :]
        concise: list[str] = []
        skip_warning = False
        for line in lines:
            if line.startswith("warning:"):
                skip_warning = True
                continue
            if skip_warning:
                if not line.strip():
                    skip_warning = False
                continue
            concise.append(line)
        return "\n".join(concise)[-5000:]

    error_markers = [
        index
        for index, line in enumerate(lines)
        if "error:" in line.lower() or "error[" in line.lower()
    ]
    if error_markers:
        start = max(0, error_markers[0] - 4)
        return "\n".join(lines[start:])[-5000:]
    return "\n".join(lines[-80:])[-5000:]


def terminate_process_tree(pid: int, *, force: bool = False) -> None:
    if os.name == "posix":
        # `Popen(start_new_session=True)` makes the child PID the new process-group ID.
        # Negative PIDs are portable through os.kill even on Python builds without os.killpg.
        os.kill(-pid, signal.SIGKILL if force else signal.SIGTERM)
    else:
        command = ["taskkill", "/PID", str(pid), "/T"]
        if force:
            command.append("/F")
        try:
            subprocess.run(
                command,
                check=False,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                timeout=5,
            )
        except subprocess.TimeoutExpired:
            # Do not let a broken taskkill invocation hang the runner indefinitely.
            pass


def display_command(
    command: tuple[str, ...], environment: tuple[tuple[str, str], ...] = ()
) -> str:
    command = prepared_command(command)
    prefix = " ".join(f"{key}={value}" for key, value in environment)
    return f"{prefix} {' '.join(command)}" if prefix else " ".join(command)


def prepared_command(command: tuple[str, ...]) -> tuple[str, ...]:
    if command[:2] == ("cargo", "test"):
        command = (
            "cargo",
            "+nightly-2026-09-30",
            "-Zchecksum-freshness",
            "test",
            "--quiet",
            *command[2:],
        )
    return command


def run_command(
    root: pathlib.Path,
    target_dir: pathlib.Path,
    command: tuple[str, ...],
    timeout: int,
    environment: tuple[tuple[str, str], ...] = (),
    failure_marker: str | None = None,
) -> dict[str, object]:
    env = os.environ.copy()
    env["CARGO_TARGET_DIR"] = str(target_dir)
    env["CARGO_INCREMENTAL"] = "0"
    env.update(environment)
    started = time.monotonic()
    quiet_command = prepared_command(command)
    process = subprocess.Popen(
        quiet_command,
        cwd=root,
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        start_new_session=(os.name == "posix"),
    )
    try:
        stdout, stderr = process.communicate(timeout=timeout)
    except subprocess.TimeoutExpired:
        cleanup_notes = []
        try:
            terminate_process_tree(process.pid)
        except (ProcessLookupError, OSError) as error:
            cleanup_notes.append(f"process-tree termination warning: {error}")
        try:
            stdout, stderr = process.communicate(timeout=2)
        except subprocess.TimeoutExpired as graceful_timeout:
            stdout, stderr = timeout_output(graceful_timeout)
            try:
                terminate_process_tree(process.pid, force=True)
            except (ProcessLookupError, OSError) as error:
                cleanup_notes.append(f"forced process-tree termination warning: {error}")
            try:
                forced_stdout, forced_stderr = process.communicate(timeout=2)
                stdout = forced_stdout or stdout
                stderr = forced_stderr or stderr
            except subprocess.TimeoutExpired as forced_timeout:
                forced_stdout, forced_stderr = timeout_output(forced_timeout)
                stdout = forced_stdout or stdout
                stderr = forced_stderr or stderr
                try:
                    process.kill()
                    process.wait(timeout=2)
                except (OSError, subprocess.TimeoutExpired) as error:
                    cleanup_notes.append(f"direct child cleanup warning: {error}")
                for stream in (process.stdout, process.stderr):
                    if stream is not None:
                        stream.close()
                cleanup_notes.append("output pipes remained open after forced process-tree termination")
        output = stdout + stderr
        if cleanup_notes:
            output += "\n" + "\n".join(cleanup_notes)
        output = concise_test_output(output)
        return {
            "status": "timeout",
            "elapsed_seconds": round(time.monotonic() - started, 2),
            "exit_code": None,
            "output": output,
        }
    output = stdout + stderr
    return {
        "status": classify(process.returncode, output, failure_marker),
        "elapsed_seconds": round(time.monotonic() - started, 2),
        "exit_code": process.returncode,
        "output": concise_test_output(output),
    }


def timeout_output(error: subprocess.TimeoutExpired) -> tuple[str, str]:
    def as_text(value: str | bytes | None) -> str:
        if value is None:
            return ""
        return value.decode(errors="replace") if isinstance(value, bytes) else value

    return as_text(error.output), as_text(error.stderr)


def run_mutant(root: pathlib.Path, target_dir: pathlib.Path, mutant: Mutant, timeout: int) -> dict[str, object]:
    original = apply_mutation(root, mutant)
    try:
        result = run_command(
            root,
            target_dir,
            mutant.command,
            timeout,
            mutant.environment,
            mutant.failure_marker,
        )
        return {
            "name": mutant.name,
            "description": mutant.description,
            "command_name": mutant.command_name,
            "command": display_command(mutant.command, mutant.environment),
            **result,
        }
    finally:
        (root / mutant.source).write_bytes(original)

def markdown_report(
    results: Sequence[dict[str, object]],
    baselines: dict[tuple[tuple[str, ...], tuple[tuple[str, str], ...]], dict[str, object]],
    commit: str,
    date: str,
    target_dir: pathlib.Path,
    complete: bool = False,
) -> str:
    lines = [
        "# Pseudo-mutation campaign",
        "",
        f"Source revision: `{commit}`",
        "",
        f"Run date: {date}",
        "",
        f"Cargo target directory: `{target_dir}`",
        "",
        f"Campaign status: **{'complete' if complete else 'in progress'}**",
        "",
        "Mutations ran one at a time in a disposable archive of the selected Git revision. Source files were restored after each trial, and the caller's working tree was not modified.",
        "",
        "| Mutant | Focused check | Result | Time |",
        "|---|---|---:|---:|",
    ]
    for result in results:
        lines.append(
            f"| `{result['name']}` | {result['command_name']} | **{result['status']}** | {result['elapsed_seconds']} s |"
        )
    lines.extend(["", "## Luna baseline checks", "", "Each focused test command ran once against the unmutated archived source first. Only baseline-passing checks count as mutation evidence.", "", "| Focused check | Result | Time |", "|---|---:|---:|"])
    for result in baselines.values():
        lines.append(
            f"| {result['command_name']} | **{result['status']}** | {result['elapsed_seconds']} s |"
        )
    for result in baselines.values():
        if result["status"] != "passed" and str(result.get("output", "")).strip():
            lines.extend(
                [
                    "",
                    f"Baseline failure for {result['command_name']}: `{result['command']}`",
                    "",
                    "```text",
                    str(result["output"]).strip().replace("```", "'''"),
                    "```",
                ]
            )
    lines.extend(["", "## Trial details", ""])
    for result in results:
        lines.extend([
            f"### `{result['name']}` — {result['status']}",
            "",
            str(result["description"]),
            "",
            f"Command: `{result['command']}`",
            "",
        ])
        output = str(result.get("output", "")).strip()
        if output:
            lines.extend(["```text", output.replace("```", "'''"), "```", ""])
    lines.extend([
        "## Interpretation",
        "",
        "`killed` means a test ran and failed by assertion. `survived` means the focused check completed successfully after the source mutation. `invalid` means the mutant did not provide behavioral evidence because compilation, setup, or test selection failed. `timeout` is inconclusive.",
        "",
        "The independent semantic checks use analytic alpha and geometry expectations, transformed sprite placement, fixed dispatcher times, restored scene capture validation, and explicit report checkpoint membership. Their results do not depend on frozen raster hash constants.",
        "",
    ])
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", type=pathlib.Path, default=pathlib.Path(__file__).resolve().parents[2], help="main checkout containing the committed HEAD")
    parser.add_argument("--revision", default="HEAD", help="committed revision to archive and test (defaults to HEAD)")
    parser.add_argument(
        "--target-dir",
        type=pathlib.Path,
        help="exact isolated Cargo cache to reuse; by default, a unique cache is created under <repo>/target/pseudo-mutation",
    )
    parser.add_argument("--timeout-seconds", type=int, default=300)
    parser.add_argument("--only", action="append", help="run only this mutant (repeat the option to select several)")
    parser.add_argument("--report", type=pathlib.Path, default=pathlib.Path("docs/testing-mutations-run.md"), help="standalone Markdown result report written in the main checkout")
    parser.add_argument("--list", action="store_true", help="list mutants and focused tests without running them")
    args = parser.parse_args()

    repo = git_root(args.repo.resolve())
    cache_root = (repo / "target" / "pseudo-mutation").resolve()
    revision_sha = subprocess.run(
        ["git", "-C", str(repo), "rev-parse", args.revision],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    commit = revision_sha
    run_id = f"{time.time_ns()}-{os.getpid()}"
    target_dir = (
        args.target_dir.resolve()
        if args.target_dir
        else campaign_target_dir(cache_root, commit, run_id)
    )
    if args.list:
        for mutant in MUTANTS:
            print(
                f"{mutant.name}: {mutant.command_name}\n  "
                f"{display_command(mutant.command, mutant.environment)}"
            )
        return 0
    if args.timeout_seconds <= 0:
        parser.error("--timeout-seconds must be positive")
    selected = {mutant.name for mutant in MUTANTS} if not args.only else set(args.only)
    unknown = selected - {mutant.name for mutant in MUTANTS}
    if unknown:
        parser.error("unknown mutant name(s): " + ", ".join(sorted(unknown)))
    mutants = tuple(mutant for mutant in MUTANTS if mutant.name in selected)
    date = dt.datetime.now(dt.timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    report_path = args.report if args.report.is_absolute() else repo / args.report

    def save_report(
        results: Sequence[dict[str, object]],
        baselines: dict[
            tuple[tuple[str, ...], tuple[tuple[str, str], ...]], dict[str, object]
        ],
        *,
        complete: bool = False,
    ) -> None:
        report_path.parent.mkdir(parents=True, exist_ok=True)
        report_path.write_text(
            markdown_report(results, baselines, commit, date, target_dir, complete),
            encoding="utf-8",
        )

    results: list[dict[str, object]] = []
    with tempfile.TemporaryDirectory(prefix="gpui-pseudo-mutants-") as temporary:
        archive_root = pathlib.Path(temporary) / "checkout"
        archive_root.mkdir()
        archive_revision(repo, archive_root, revision_sha)
        anchor_problems = preflight_anchors(archive_root, mutants)
        if anchor_problems:
            results = [
                {
                    "name": mutant.name,
                    "description": mutant.description,
                    "command_name": mutant.command_name,
                    "command": display_command(mutant.command, mutant.environment),
                    "status": "invalid",
                    "elapsed_seconds": 0,
                    "exit_code": None,
                    "output": next(
                        (
                            problem
                            for problem in anchor_problems
                            if problem.startswith(f"{mutant.name}:")
                        ),
                        "preflight failed because another selected mutation anchor is invalid",
                    ),
                }
                for mutant in mutants
            ]
            save_report(results, {}, complete=True)
            print("Mutation preflight failed before Cargo baselines:", file=sys.stderr)
            for problem in anchor_problems:
                print(f"  {problem}", file=sys.stderr)
            print(f"Report: {report_path}")
            return 2
        baselines: dict[tuple[tuple[str, ...], tuple[tuple[str, str], ...]], dict[str, object]] = {}
        for mutant in mutants:
            key = baseline_key(mutant)
            if key not in baselines:
                print(f"[baseline] {mutant.command_name}", flush=True)
                baseline = run_command(
                    archive_root,
                    target_dir,
                    mutant.command,
                    args.timeout_seconds,
                    mutant.environment,
                )
                baseline["status"] = "passed" if baseline["status"] == "survived" else baseline["status"]
                baselines[key] = {
                    "command_name": mutant.command_name,
                    "command": display_command(mutant.command, mutant.environment),
                    **baseline,
                }
                save_report(results, baselines)
        for mutant in mutants:
            print(f"[{mutant.name}] {mutant.command_name}", flush=True)
            baseline = baselines[baseline_key(mutant)]
            if baseline["status"] != "passed":
                result = {
                    "name": mutant.name,
                    "description": mutant.description,
                    "command_name": mutant.command_name,
                    "command": display_command(mutant.command, mutant.environment),
                    "status": "invalid",
                    "elapsed_seconds": 0,
                    "exit_code": None,
                    "output": f"focused check did not pass before mutation ({baseline['status']})",
                }
            else:
                try:
                    result = run_mutant(archive_root, target_dir, mutant, args.timeout_seconds)
                except Exception as error:
                    result = {
                        "name": mutant.name,
                        "description": mutant.description,
                        "command_name": mutant.command_name,
                        "command": display_command(mutant.command, mutant.environment),
                        "status": "invalid",
                        "elapsed_seconds": 0,
                        "exit_code": None,
                        "output": f"mutation setup failed: {error}",
                    }
            results.append(result)
            save_report(results, baselines)
            print(f"  {result['status']} ({result['elapsed_seconds']} s)", flush=True)

    save_report(results, baselines, complete=True)
    counts = {status: sum(result["status"] == status for result in results) for status in ("killed", "survived", "invalid", "timeout")}
    print(f"Report: {report_path}")
    print("Results: " + ", ".join(f"{key}={value}" for key, value in counts.items()))
    if counts["invalid"] or counts["timeout"]:
        return 2
    return 1 if counts["survived"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
