#!/usr/bin/env python3
"""Run focused pseudo-source mutants in an isolated archive of HEAD.

The runner never edits the caller's checkout. Each trial restores its exact source file bytes
before running the next trial; a fresh temporary archive is discarded at exit. Cargo commands
share the caller's target directory and execute serially to avoid corrupting Cargo's build cache.
"""
from __future__ import annotations

import argparse
import dataclasses
import datetime as dt
import os
import pathlib
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


CPU = "crates/gpui_render/src/cpu.rs"
CPU_FRAME = "crates/gpui_render/src/cpu/frame.rs"
RUNNER = "crates/gpui_test/src/runner.rs"
GALLERY = "crates/gpui_test/src/gallery/views.rs"
CAPTURE = "crates/gpui/src/scene/capture.rs"
REPORT = "crates/gpui_test/src/report.rs"

MUTANTS: tuple[Mutant, ...] = (
    Mutant(
        "skip-underlines",
        "Skip drawing compiled underline batches.",
        CPU,
        "target.draw_underline(item);",
        "let _ = item;",
        "colored multiline Parley underline pixels",
        ("cargo", "test", "--offline", "-p", "gpui_ce_test", "--test", "state_regressions", "wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines"),
    ),
    Mutant(
        "source-over-alpha",
        "Replace accumulated alpha with foreground alpha in source-over.",
        CPU_FRAME,
        "below[3] = color[3] + below[3] * inverse;",
        "below[3] = color[3];",
        "source-over alpha property and unit law",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--test", "cpu_properties", "overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs"),
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
        "ignore-path-content-clip",
        "Rasterize a path using its full bounds instead of its clipped bounds.",
        CPU_FRAME,
        "let bounds = path.clipped_bounds();",
        "let bounds = path.bounds;",
        "path source-over alpha and clipped pixel bounds",
        ("cargo", "test", "--offline", "-p", "gpui_ce_render", "--features", "cpu", "--test", "cpu_properties", "path_coverage_composites_with_quad_alpha_and_respects_its_clip"),
    ),
    Mutant(
        "freeze-animation-clock",
        "Ignore elapsed simulated time at each scenario checkpoint.",
        RUNNER,
        "cx.advance_clock(checkpoint.at - previous_at);",
        "cx.advance_clock(Duration::ZERO);",
        "animation time advances and repeat phase",
        ("cargo", "test", "--offline", "-p", "gpui_ce_test", "--test", "state_regressions", "fixed_animation_times_are_idempotent_and_cross_repeat_boundaries"),
    ),
    Mutant(
        "disable-animation-repeat",
        "Remove repeat behavior from the gallery motion scenario.",
        GALLERY,
        ".repeat()",
        "",
        "repeat phase at 1250 ms returns near start",
        ("cargo", "test", "--offline", "-p", "gpui_ce_test", "--test", "state_regressions", "fixed_animation_times_are_idempotent_and_cross_repeat_boundaries"),
    ),
    Mutant(
        "linearize-animation-easing",
        "Replace ease-in-out with linear progress.",
        GALLERY,
        ".with_easing(ease_in_out)",
        ".with_easing(|progress| progress)",
        "analytic eased marker position at 250 ms",
        ("cargo", "test", "--offline", "-p", "gpui_ce_test", "--test", "state_regressions", "fixed_animation_times_are_idempotent_and_cross_repeat_boundaries"),
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
)


def git_root(path: pathlib.Path) -> pathlib.Path:
    result = subprocess.run(
        ["git", "-C", str(path), "rev-parse", "--show-toplevel"],
        check=True,
        capture_output=True,
        text=True,
    )
    return pathlib.Path(result.stdout.strip()).resolve()


def archive_head(repo: pathlib.Path, destination: pathlib.Path) -> None:
    archive_path = destination.parent / "head.tar"
    with archive_path.open("wb") as archive:
        subprocess.run(["git", "-C", str(repo), "archive", "--format=tar", "HEAD"], check=True, stdout=archive)
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


def classify(returncode: int, output: str) -> str:
    lowered = output.lower()
    if "running 0 tests" in lowered or "0 passed; 0 failed" in lowered:
        return "invalid"
    if any(token in lowered for token in ("could not compile", "error[e", "rustc-llvm error", "failed to run custom build command")):
        return "invalid"
    if returncode == 0:
        return "survived"
    if "test result: failed" in lowered or "panicked at" in lowered or "assertion `left == right` failed" in lowered or "assertion failed:" in lowered:
        return "killed"
    return "invalid"


def run_command(root: pathlib.Path, target_dir: pathlib.Path, command: tuple[str, ...], timeout: int) -> dict[str, object]:
    env = os.environ.copy()
    env["CARGO_TARGET_DIR"] = str(target_dir)
    env["CARGO_INCREMENTAL"] = "0"
    started = time.monotonic()
    try:
        process = subprocess.run(
            command,
            cwd=root,
            env=env,
            capture_output=True,
            text=True,
            timeout=timeout,
            check=False,
        )
        output = process.stdout + process.stderr
        return {
            "status": classify(process.returncode, output),
            "elapsed_seconds": round(time.monotonic() - started, 2),
            "exit_code": process.returncode,
            "output": output[-5000:],
        }
    except subprocess.TimeoutExpired as error:
        def text_output(value: str | bytes | None) -> str:
            if isinstance(value, bytes):
                return value.decode("utf-8", errors="replace")
            return value or ""
        output = text_output(error.stdout) + text_output(error.stderr)
        return {
            "status": "timeout",
            "elapsed_seconds": round(time.monotonic() - started, 2),
            "exit_code": None,
            "output": str(output)[-5000:],
        }


def run_mutant(root: pathlib.Path, target_dir: pathlib.Path, mutant: Mutant, timeout: int) -> dict[str, object]:
    original = apply_mutation(root, mutant)
    try:
        result = run_command(root, target_dir, mutant.command, timeout)
        return {
            "name": mutant.name,
            "description": mutant.description,
            "command_name": mutant.command_name,
            "command": " ".join(mutant.command),
            **result,
        }
    finally:
        (root / mutant.source).write_bytes(original)

def markdown_report(results: Sequence[dict[str, object]], baselines: dict[str, dict[str, object]], commit: str, date: str) -> str:
    lines = [
        "# Pseudo-mutation campaign",
        "",
        f"Source revision: `{commit}`  ",
        f"Run date: {date}  ",
        "Mutations ran one at a time in a disposable `git archive HEAD` checkout. Source files were restored after each trial, and the caller's working tree was not modified.",
        "",
        "| Mutant | Focused check | Result | Time |",
        "|---|---|---:|---:|",
    ]
    for result in results:
        lines.append(
            f"| `{result['name']}` | {result['command_name']} | **{result['status']}** | {result['elapsed_seconds']} s |"
        )
    lines.extend(["", "## Luna baseline checks", "", "Each focused test command ran once against the unmutated archived source first. Only baseline-passing checks count as mutation evidence.", "", "| Focused check | Result | Time |", "|---|---:|---:|"])
    for command_name, result in baselines.items():
        lines.append(f"| {command_name} | **{result['status']}** | {result['elapsed_seconds']} s |")
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
    parser.add_argument("--target-dir", type=pathlib.Path, help="Cargo target cache (defaults to <repo>/target)")
    parser.add_argument("--timeout-seconds", type=int, default=300)
    parser.add_argument("--only", action="append", help="run only this mutant (repeat the option to select several)")
    parser.add_argument("--report", type=pathlib.Path, default=pathlib.Path("docs/testing-mutations.md"), help="Markdown result report written in the main checkout")
    parser.add_argument("--list", action="store_true", help="list mutants and focused tests without running them")
    args = parser.parse_args()

    repo = git_root(args.repo.resolve())
    target_dir = (args.target_dir or repo / "target").resolve()
    if args.list:
        for mutant in MUTANTS:
            print(f"{mutant.name}: {mutant.command_name}\n  {' '.join(mutant.command)}")
        return 0
    if args.timeout_seconds <= 0:
        parser.error("--timeout-seconds must be positive")
    selected = {mutant.name for mutant in MUTANTS} if not args.only else set(args.only)
    unknown = selected - {mutant.name for mutant in MUTANTS}
    if unknown:
        parser.error("unknown mutant name(s): " + ", ".join(sorted(unknown)))
    mutants = tuple(mutant for mutant in MUTANTS if mutant.name in selected)
    commit = subprocess.run(["git", "-C", str(repo), "rev-parse", "--short", "HEAD"], check=True, capture_output=True, text=True).stdout.strip()
    date = dt.datetime.now(dt.timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    results: list[dict[str, object]] = []
    with tempfile.TemporaryDirectory(prefix="gpui-pseudo-mutants-") as temporary:
        archive_root = pathlib.Path(temporary) / "checkout"
        archive_root.mkdir()
        archive_head(repo, archive_root)
        baselines: dict[str, dict[str, object]] = {}
        for mutant in mutants:
            key = " ".join(mutant.command)
            if key not in baselines:
                print(f"[baseline] {mutant.command_name}", flush=True)
                baseline = run_command(archive_root, target_dir, mutant.command, args.timeout_seconds)
                baseline["status"] = "passed" if baseline["status"] == "survived" else baseline["status"]
                baselines[key] = {
                    "command_name": mutant.command_name,
                    "command": key,
                    **baseline,
                }
        for mutant in mutants:
            print(f"[{mutant.name}] {mutant.command_name}", flush=True)
            baseline = baselines[" ".join(mutant.command)]
            if baseline["status"] != "passed":
                result = {
                    "name": mutant.name,
                    "description": mutant.description,
                    "command_name": mutant.command_name,
                    "command": " ".join(mutant.command),
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
                        "command": " ".join(mutant.command),
                        "status": "invalid",
                        "elapsed_seconds": 0,
                        "exit_code": None,
                        "output": f"mutation setup failed: {error}",
                    }
            results.append(result)
            print(f"  {result['status']} ({result['elapsed_seconds']} s)", flush=True)

    report_path = args.report if args.report.is_absolute() else repo / args.report
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(markdown_report(results, baselines, commit, date), encoding="utf-8")
    counts = {status: sum(result["status"] == status for result in results) for status in ("killed", "survived", "invalid", "timeout")}
    print(f"Report: {report_path}")
    print("Results: " + ", ".join(f"{key}={value}" for key, value in counts.items()))
    if counts["invalid"] or counts["timeout"]:
        return 2
    return 1 if counts["survived"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
