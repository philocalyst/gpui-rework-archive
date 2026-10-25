"""Render campaign evidence without depending on its execution machinery."""
import pathlib
from typing import Sequence

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
