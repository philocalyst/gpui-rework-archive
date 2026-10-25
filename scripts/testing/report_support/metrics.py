"""Format timing, memory, and platform summaries."""
from __future__ import annotations
import html
import math
from .common import _has_motion_error
def metric(checkpoint: dict, key: str) -> int | None:
    metrics = checkpoint.get("metrics")
    value = metrics.get(key) if isinstance(metrics, dict) else None
    return value if isinstance(value, int) and not isinstance(value, bool) and value >= 0 else None

def format_ms(value_ns: int | None) -> str:
    return "n/a" if value_ns is None else f"{value_ns / 1_000_000:.2f} ms"

def markdown_text(value: object) -> str:
    text = html.escape(str(value), quote=False).replace("|", "&#124;").replace("\n", " ").replace("\r", " ")
    return f"<code>{text}</code>"

METRIC_COLUMNS = (
    ("Scene build p50", "scene_build_p50_ns", "time"),
    ("Scene build p95", "scene_build_p95_ns", "time"),
    ("Scene build p99", "scene_build_p99_ns", "time"),
    ("CPU render p50", "cpu_render_p50_ns", "time"),
    ("CPU render p95", "cpu_render_p95_ns", "time"),
    ("CPU render p99", "cpu_render_p99_ns", "time"),
    ("Frames", "frame_count", "count"),
    ("Primitives", "primitive_count", "count"),
    ("Batches", "batch_count", "count"),
    ("Bitmap bytes", "bitmap_storage_bytes", "count"),
)

METRIC_HEADERS = tuple(column[0] for column in METRIC_COLUMNS)

def _count_text(value: object) -> str:
    if not isinstance(value, int) or isinstance(value, bool) or value < 0:
        return "n/a"
    return str(value)

def checkpoint_metric_values(checkpoint: dict) -> list[str]:
    values = []
    for _label, key, kind in METRIC_COLUMNS:
        value = metric(checkpoint, key)
        values.append(format_ms(value) if kind == "time" else _count_text(value))
    return values

def _timing_triplet(metrics: dict, prefix: str) -> str:
    metrics = metrics if isinstance(metrics, dict) else {}
    return "/".join(format_ms(metrics.get(f"{prefix}_{percentile}_ns")) for percentile in ("p50", "p95", "p99"))

def markdown_metrics_table(manifest: dict, *, limit: int | None = None) -> str:
    """Render compact timing tables; callers may cap rows for comment size limits."""
    output = []
    cpu_headers = (
        "Scenario / checkpoint", "Samples", "Scene build p50/p95/p99", "CPU render p50/p95/p99",
        "Primitives", "Batches", "Bitmap bytes", "Status",
    )
    captures = [(scenario, checkpoint) for scenario in manifest["scenarios"] for checkpoint in scenario["checkpoints"]]
    if captures:
        shown, omitted = _limit_metric_rows(captures, limit)
        rows = ["| " + " | ".join(cpu_headers) + " |", "|---|---|---:|---:|---:|---:|---:|---|"]
        for scenario, checkpoint in shown:
            values = [
                markdown_text(f"{scenario.get('title', scenario['id'])} / {checkpoint.get('name', checkpoint['id'])}"),
                _count_text(metric(checkpoint, "frame_count")),
                _timing_triplet(checkpoint.get("metrics", {}), "scene_build"),
                _timing_triplet(checkpoint.get("metrics", {}), "cpu_render"),
                _count_text(metric(checkpoint, "primitive_count")),
                _count_text(metric(checkpoint, "batch_count")),
                _count_text(metric(checkpoint, "bitmap_storage_bytes")),
                markdown_text("motion changed" if checkpoint.get("status") == "unchanged" and _has_motion_error(checkpoint)
                              else checkpoint.get("status", "n/a")),
            ]
            rows.append("| " + " | ".join(values) + " |")
        output.append("\n".join(rows))
        if omitted:
            output.append(f"*Showing {len(shown)} of {len(captures)} CPU checkpoints; full metrics are in the linked report artifact.*")
    replay = manifest.get("native_replay")
    if replay is not None:
        reason = replay.get("timestamp_reason")
        timestamp_status = "available" if reason is None else f"unavailable: {markdown_text(reason)}"
        intro = (
            "**Native replay diagnostics (native minus CPU differences are diagnostic only; CPU captures determine correctness).** "
            f"Adapter: {markdown_text(replay['adapter'])}; driver: {markdown_text(replay['driver'].strip() or 'n/a')}; "
            f"backend: {markdown_text(replay['backend'])}; "
            f"device: {markdown_text(replay['device_type'])}; GPU timestamps: {timestamp_status}"
        )
        native_headers = (
            "Scenario / checkpoint", "Samples", "GPU p50/p95/p99",
            "Encode/submit/completion p50/p95/p99", "Tracked owned bytes", "Device allocated bytes",
            "Changed / total pixels", "Max / mean channel error",
        )
        native_rows = ["| " + " | ".join(native_headers) + " |", "|---|---|" + "---:|" * (len(native_headers) - 2)]
        checkpoints = [
            (scenario, checkpoint)
            for scenario in manifest["scenarios"]
            for checkpoint in scenario["checkpoints"]
            if checkpoint.get("native")
        ]
        shown, omitted = _limit_metric_rows(checkpoints, limit)
        tracked_scopes = sorted({checkpoint["native"]["metrics"]["allocation_scope"] for _scenario, checkpoint in checkpoints}) or ["not reported"]
        device_scopes = sorted({checkpoint["native"]["metrics"]["device_allocation_scope"] for _scenario, checkpoint in checkpoints if checkpoint["native"]["metrics"].get("device_allocation_scope")})
        allocation_reasons = sorted({checkpoint["native"]["metrics"]["allocation_reason"] for _scenario, checkpoint in checkpoints if checkpoint["native"]["metrics"].get("allocation_reason")})
        provenance = "**Allocation provenance:** tracked-owned bytes: " + ", ".join(markdown_text(value) for value in tracked_scopes)
        provenance += "; device-allocation scopes: " + (", ".join(markdown_text(value) for value in device_scopes) or "not exposed")
        provenance += "; unavailable reason: " + (", ".join(markdown_text(value) for value in allocation_reasons) or "not reported") + "."
        for scenario, checkpoint in shown:
            native = checkpoint["native"]
            metrics = native["metrics"]
            gpu = metrics.get("gpu") or {}
            completion = metrics["encode_submit_completion"]
            difference = native["difference"]
            values = [
                markdown_text(f"{scenario.get('title', scenario['id'])} / {checkpoint.get('name', checkpoint['id'])}"),
                _count_text(metrics.get("samples")),
                "/".join(format_ms(gpu.get(key)) for key in ("p50_ns", "p95_ns", "p99_ns")),
                "/".join(format_ms(completion.get(key)) for key in ("p50_ns", "p95_ns", "p99_ns")),
                _count_text(metrics.get("tracked_owned_bytes")),
                _count_text(metrics.get("device_allocated_bytes")),
                f"{_count_text(difference.get('changed_pixels'))}/{_count_text(difference.get('total_pixels'))}",
                f"{_count_text(difference.get('max_channel_error'))}/{_float_text(difference.get('mean_channel_error'))}",
            ]
            native_rows.append("| " + " | ".join(values) + " |")
        if omitted:
            provenance += f"; showing {len(shown)} of {len(checkpoints)} native checkpoints; full metrics are in the linked report artifact."
        output.extend([intro, provenance, "\n".join(native_rows)])
    platform_summary = markdown_platform_checks(manifest.get("platform_checks"))
    if platform_summary:
        output.append(platform_summary)
    return "\n\n".join(output)

def _limit_metric_rows(rows: list[tuple[dict, dict]], limit: int | None) -> tuple[list[tuple[dict, dict]], int]:
    if limit is None or len(rows) <= limit:
        return rows, 0
    if limit <= 0:
        raise ValueError("metrics table row limit must be positive")
    def priority(item: tuple[dict, dict]) -> tuple:
        scenario, checkpoint = item
        changed = checkpoint.get("status") == "changed" or checkpoint.get("pixels_changed") is True or _has_motion_error(checkpoint)
        return (not changed, -(metric(checkpoint, "cpu_render_p95_ns") or 0),
                -(metric(checkpoint, "scene_build_p95_ns") or 0), scenario["id"], checkpoint["id"])
    chosen = sorted(rows, key=priority)[:limit]
    return chosen, len(rows) - len(chosen)

def _float_text(value: object) -> str:
    if isinstance(value, bool) or not isinstance(value, (int, float)) or not math.isfinite(value):
        return "n/a"
    return f"{value:.3f}"

def _platform_rows(checks: dict) -> list[tuple[str, str, str]]:
    rows = [("Capability", name.replace("_", " "), "available" if enabled else "unavailable")
            for name, enabled in sorted(checks["capabilities"].items())]
    rows.extend(("Event", event["name"], f"{event['polls']} polls · {event['elapsed_ms']} ms") for event in checks["events"])
    for title, data in (("Frame", checks["frame"]), ("Resize", checks["resize"])):
        if data:
            rows.extend((title, name.replace("_", " "), str(value)) for name, value in data.items())
    rows.extend(("Error", "Platform check", error) for error in checks["errors"])
    return rows

def markdown_platform_checks(checks: dict | None) -> str:
    if not checks:
        return ""
    lines = [
        f"**Platform integration checks: {markdown_text(checks['status'])} · {markdown_text(checks['platform'])}.**",
        "| Check | Name | Result |", "|---|---|---|",
    ]
    lines.extend("| " + " | ".join(markdown_text(value) for value in row) + " |" for row in _platform_rows(checks))
    return "\n".join(lines)
