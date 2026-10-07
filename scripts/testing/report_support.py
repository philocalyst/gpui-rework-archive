"""Forge-neutral validation, comparison, and static-view helpers for GPUI reports."""

from __future__ import annotations

import html
import gzip
import io
import json
import math
from pathlib import Path, PurePosixPath
import re
import zlib
from xml.parsers import expat
from urllib.parse import quote, urlsplit
from urllib.error import HTTPError
from urllib.request import Request, urlopen

MAX_FILE_BYTES = 12 * 1024 * 1024
MAX_REPORT_BYTES = 48 * 1024 * 1024
ID_RE = re.compile(r"^[a-z0-9][a-z0-9_-]*$")
PATH_SEGMENT_RE = re.compile(r"^[a-z0-9][a-z0-9_.-]*$")
SHA_RE = re.compile(r"^[0-9a-f]{40}$")
SVG_NS = "http://www.w3.org/2000/svg"
SVG_TAGS = {"svg", "g", "path", "line", "polyline", "polygon", "rect", "circle", "text", "tspan", "defs", "clipPath"}
SVG_ATTRS = {
    "xmlns", "viewBox", "width", "height", "x", "y", "x1", "x2", "y1", "y2", "cx", "cy", "r",
    "d", "points", "fill", "stroke", "stroke-width", "stroke-linecap", "stroke-linejoin", "transform",
    "font-family", "font-size", "font-weight", "text-anchor", "dominant-baseline", "id", "clip-path",
}
STATUSES = {"baseline_unavailable", "new", "unchanged", "changed"}
CHANGE_LABELS = {
    "scenario_added": "Scenario added",
    "scenario_removed": "Scenario removed",
    "scenario_metadata_changed": "Scenario metadata changed",
    "checkpoint_added": "Checkpoint added",
    "checkpoint_removed": "Checkpoint removed",
    "checkpoint_metadata_changed": "Checkpoint timeline changed",
    "pixels_changed": "Pixels changed",
}
CHECKPOINT_CHANGE_KINDS = {
    "checkpoint_added", "checkpoint_removed", "checkpoint_metadata_changed", "pixels_changed", "scene_changed",
}
REPORT_VIEWER_DIR = Path(__file__).resolve().parents[2] / "crates/gpui_test/assets/report"


def validate_relative(raw: object, suffixes: tuple[str, ...]) -> str:
    if not isinstance(raw, str) or "\\" in raw:
        raise ValueError("report path must be a relative POSIX path")
    path = PurePosixPath(raw)
    if path.is_absolute() or not path.parts or any(not PATH_SEGMENT_RE.fullmatch(part) for part in path.parts):
        raise ValueError(f"unsafe report path: {raw!r}")
    if not raw.endswith(suffixes) or path.as_posix() != raw:
        raise ValueError(f"unsupported report asset: {raw!r}")
    return path.as_posix()


def validate_site_base(value: str) -> str:
    parsed = urlsplit(value)
    if parsed.scheme not in {"http", "https"} or not parsed.netloc or parsed.username or parsed.password or parsed.query or parsed.fragment:
        raise ValueError("Pages URL must be an HTTP(S) base URL without credentials, query, or fragment")
    return value.rstrip("/")


def json_request(method: str, url: str, headers: dict[str, str], payload: object | None = None, *, api_name: str = "API"):
    """Send one JSON API request while leaving forge-specific auth and URLs to callers."""
    body = None if payload is None else json.dumps(payload).encode()
    request_headers = {"Content-Type": "application/json", "User-Agent": "gpui-visual-report", **headers}
    request = Request(url, data=body, method=method, headers=request_headers)
    try:
        with urlopen(request, timeout=30) as response:
            data = response.read()
            return json.loads(data) if data else None
    except HTTPError as error:
        detail = error.read().decode("utf-8", "replace")[:1000]
        error.close()
        raise RuntimeError(f"{api_name} {method} returned {error.code}: {detail}") from error


def _safe_path(root: Path, relative: str) -> Path:
    if root.is_symlink():
        raise ValueError("report directory must not be a symbolic link")
    root = root.resolve()
    current = root
    for part in PurePosixPath(relative).parts:
        current = current / part
        if current.is_symlink():
            raise ValueError(f"symbolic links are not allowed in report assets: {relative}")
    path = current.resolve()
    if root not in path.parents:
        raise ValueError(f"report path escapes its directory: {relative}")
    return path


def _validate_status_fields(value: dict, label: str) -> None:
    status = value.get("status")
    if not isinstance(status, str) or status not in STATUSES:
        raise ValueError(f"{label} has an invalid comparison status")
    for field in ("pixels_changed", "scene_changed", "metadata_changed"):
        flag = value.get(field)
        if flag is not None and not isinstance(flag, bool):
            raise ValueError(f"{label} field {field} must be boolean")


def _nonnegative_int(value: object, label: str, *, maximum: int | None = None) -> int:
    if not isinstance(value, int) or isinstance(value, bool) or value < 0 or (maximum is not None and value > maximum):
        raise ValueError(f"{label} must be a non-negative integer" + (f" no greater than {maximum}" if maximum is not None else ""))
    return value


def _validate_uint_fields(
    value: dict,
    label: str,
    fields: tuple[str, ...],
    *,
    maximum: int | None = None,
    optional: bool = False,
) -> None:
    for field in fields:
        raw = value.get(field)
        if optional and raw is None:
            continue
        _nonnegative_int(raw, f"{label} {field}", maximum=maximum)


def _validate_native_replay(manifest: dict) -> None:
    replay = manifest.get("native_replay")
    if replay is None:
        return
    if not isinstance(replay, dict):
        raise ValueError("manifest native_replay must be an object")
    for field in ("adapter", "driver", "backend", "device_type"):
        if not isinstance(replay.get(field), str):
            raise ValueError(f"native_replay {field} must be text")
    if replay.get("timestamp_reason") is not None and not isinstance(replay["timestamp_reason"], str):
        raise ValueError("native_replay timestamp_reason must be text or null")


def _validate_image_difference(value: object, label: str) -> None:
    if not isinstance(value, dict):
        raise ValueError(f"{label} difference must be an object")
    changed = _nonnegative_int(value.get("changed_pixels"), f"{label} changed_pixels")
    total = value.get("total_pixels")
    if total is not None:
        total = _nonnegative_int(total, f"{label} total_pixels")
        if changed > total:
            raise ValueError(f"{label} changed_pixels exceeds total_pixels")
    _validate_uint_fields(value, label, ("max_channel_error",), maximum=255)
    mean_error = value.get("mean_channel_error")
    if isinstance(mean_error, bool) or not isinstance(mean_error, (int, float)) or not math.isfinite(mean_error) or not 0 <= mean_error <= 255:
        raise ValueError(f"{label} mean_channel_error must be finite and between 0 and 255")
    bounds = value.get("bounds")
    if bounds is not None:
        if not isinstance(bounds, dict):
            raise ValueError(f"{label} bounds must be an object or null")
        _validate_uint_fields(bounds, f"{label} bounds", ("x", "y", "width", "height"), maximum=0xFFFFFFFF)
        if bounds["width"] == 0 or bounds["height"] == 0 or bounds["x"] + bounds["width"] > 0xFFFFFFFF or bounds["y"] + bounds["height"] > 0xFFFFFFFF:
            raise ValueError(f"{label} bounds are invalid")
        if total is not None and bounds["width"] * bounds["height"] > total:
            raise ValueError(f"{label} bounds area exceeds total_pixels")
    visible = value.get("visible")
    if visible is not None:
        if not isinstance(visible, dict):
            raise ValueError(f"{label} visible difference must be an object or null")
        visible_changed = _nonnegative_int(visible.get("changed_pixels"), f"{label} visible changed_pixels")
        if visible_changed > changed:
            raise ValueError(f"{label} visible changed_pixels exceeds exact changed_pixels")
        if total is not None and visible_changed > total:
            raise ValueError(f"{label} visible changed_pixels exceeds total_pixels")
        for field in ("max_channel_error", "mean_channel_error"):
            error = visible.get(field)
            if isinstance(error, bool) or not isinstance(error, (int, float)) or not math.isfinite(error) or not 0 <= error <= 255:
                raise ValueError(f"{label} visible {field} must be finite and between 0 and 255")
    if "size_changed" in value and not isinstance(value["size_changed"], bool):
        raise ValueError(f"{label} size_changed must be a boolean")


def _validate_motion(value: object, previous: dict | None, checkpoint: dict, label: str) -> None:
    if not isinstance(value, dict):
        raise ValueError(f"{label} motion must be an object")
    if not {"previous_checkpoint_id", "before_duration_ns", "current_duration_ns", "difference"}.issubset(value):
        raise ValueError(f"{label} motion is missing required fields")
    previous_id = value.get("previous_checkpoint_id")
    if not isinstance(previous_id, str) or not ID_RE.fullmatch(previous_id):
        raise ValueError(f"{label} motion previous_checkpoint_id is invalid")
    if previous is None or previous_id != previous.get("id"):
        raise ValueError(f"{label} motion must reference the immediately previous checkpoint")
    matched = {"unchanged", "changed"}
    if previous.get("status") not in matched or checkpoint.get("status") not in matched:
        raise ValueError(f"{label} motion requires adjacent matched baseline/current checkpoints")

    for field in ("before_duration_ns", "current_duration_ns"):
        _validate_uint_fields(value, f"{label} motion", (field,), optional=True)
    expected = []
    for current_time, previous_time in (
        (checkpoint.get("before_time_ns"), previous.get("before_time_ns")),
        (checkpoint.get("time_ns"), previous.get("time_ns")),
    ):
        expected.append(current_time - previous_time if isinstance(current_time, int) and not isinstance(current_time, bool)
                        and isinstance(previous_time, int) and not isinstance(previous_time, bool)
                        and current_time >= previous_time else None)
    if value.get("before_duration_ns") != expected[0] or value.get("current_duration_ns") != expected[1]:
        raise ValueError(f"{label} motion durations must match non-decreasing baseline/current timestamps")

    difference = value.get("difference")
    if not isinstance(difference, dict):
        raise ValueError(f"{label} motion difference must be an object")
    if not {"total_pixels", "changed_pixels", "max_channel_error", "mean_channel_error", "bounds"}.issubset(difference):
        raise ValueError(f"{label} motion difference is missing required fields")
    changed = _nonnegative_int(difference.get("changed_pixels"), f"{label} motion changed_pixels")
    total = _nonnegative_int(difference.get("total_pixels"), f"{label} motion total_pixels")
    if changed > total:
        raise ValueError(f"{label} motion changed_pixels exceeds total_pixels")
    for field in ("max_channel_error", "mean_channel_error"):
        error = difference.get(field)
        if isinstance(error, bool) or not isinstance(error, (int, float)) or not math.isfinite(error) or not 0 <= error <= 510:
            raise ValueError(f"{label} motion {field} must be finite and between 0 and 510")
    bounds = difference.get("bounds")
    if bounds is not None:
        if not isinstance(bounds, dict):
            raise ValueError(f"{label} motion bounds must be an object or null")
        _validate_uint_fields(bounds, f"{label} motion bounds", ("x", "y", "width", "height"), maximum=0xFFFFFFFF)
        if bounds["width"] == 0 or bounds["height"] == 0 or bounds["x"] + bounds["width"] > 0xFFFFFFFF or bounds["y"] + bounds["height"] > 0xFFFFFFFF:
            raise ValueError(f"{label} motion bounds are invalid")
        if bounds["width"] * bounds["height"] > total:
            raise ValueError(f"{label} motion bounds area exceeds total_pixels")


def _validate_native_checkpoint(native: object, scenario: dict, checkpoint: dict, replay: dict, referenced_paths: set[str]) -> None:
    sid, cid = scenario["id"], checkpoint["id"]
    label = f"native replay {sid}/{cid}"
    if not isinstance(native, dict):
        raise ValueError(f"{label} must be an object")
    for field, expected in (
        ("png", f"{sid}/{cid}.native.png"),
        ("diff_png", f"{sid}/{cid}.native.diff.png"),
        ("heatmap_png", f"{sid}/{cid}.native.heatmap.png"),
    ):
        if field == "heatmap_png" and native.get(field) is None:
            continue
        relative = validate_relative(native.get(field), (".png",))
        if relative != expected:
            raise ValueError(f"{label} {field} must be {expected!r}")
        if relative in referenced_paths:
            raise ValueError(f"report asset is referenced more than once: {relative}")
        referenced_paths.add(relative)
        native[field] = relative

    metrics = native.get("metrics")
    if not isinstance(metrics, dict):
        raise ValueError(f"{label} metrics must be an object")
    samples = _nonnegative_int(metrics.get("samples"), f"{label} samples")
    if samples == 0:
        raise ValueError(f"{label} samples must be greater than zero")
    _nonnegative_int(metrics.get("tracked_owned_bytes"), f"{label} tracked_owned_bytes")
    for field in ("encode_submit_completion", "gpu"):
        percentiles = metrics.get(field)
        if field == "gpu" and percentiles is None:
            continue
        if not isinstance(percentiles, dict):
            raise ValueError(f"{label} {field} timing must be an object" + (" or null" if field == "gpu" else ""))
        _validate_uint_fields(percentiles, f"{label} {field}", ("p50_ns", "p95_ns", "p99_ns"))
        if not percentiles["p50_ns"] <= percentiles["p95_ns"] <= percentiles["p99_ns"]:
            raise ValueError(f"{label} {field} percentiles must be monotonic")
    if metrics.get("gpu") is not None and replay.get("timestamp_reason") is not None:
        raise ValueError(f"{label} GPU timing conflicts with native_replay timestamp_reason")
    _validate_uint_fields(metrics, label, ("device_allocated_bytes",), optional=True)
    if not isinstance(metrics.get("allocation_scope"), str):
        raise ValueError(f"{label} allocation_scope must be text")
    for field in ("allocation_reason", "device_allocation_scope"):
        value = metrics.get(field)
        if value is not None and not isinstance(value, str):
            raise ValueError(f"{label} {field} must be text or null")

    difference = native.get("difference")
    _validate_image_difference(difference, label)
    changed = difference["changed_pixels"]
    viewport = scenario.get("viewport") or {}
    width, height, scale = viewport.get("width"), viewport.get("height"), viewport.get("scale_factor", 1)
    if (
        isinstance(width, bool) or not isinstance(width, (int, float)) or not math.isfinite(width) or width <= 0
        or isinstance(height, bool) or not isinstance(height, (int, float)) or not math.isfinite(height) or height <= 0
        or isinstance(scale, bool) or not isinstance(scale, (int, float)) or not math.isfinite(scale) or scale <= 0
    ):
        raise ValueError(f"{label} requires a viewport to validate pixel counts")
    max_pixels = math.ceil(width * scale) * math.ceil(height * scale)
    total = _nonnegative_int(difference.get("total_pixels"), f"{label} total_pixels", maximum=max_pixels)
    if changed > total:
        raise ValueError(f"{label} changed_pixels exceeds total_pixels")


PLATFORM_CAPABILITIES = (
    "native_visibility", "focus_handle", "native_render_capture", "resize_callback", "two_window_close",
)


def _validate_platform_checks(value: object) -> None:
    if value is None:
        return
    version = value.get("schema_version") if isinstance(value, dict) else None
    if not isinstance(version, int) or isinstance(version, bool) or version != 1:
        raise ValueError("platform_checks has an unsupported schema")
    if not isinstance(value.get("platform"), str) or value.get("status") not in {"passed", "failed"}:
        raise ValueError("platform_checks platform or status is malformed")

    capabilities = value.get("capabilities")
    if not isinstance(capabilities, dict) or not set(PLATFORM_CAPABILITIES).issubset(capabilities):
        raise ValueError("platform_checks capabilities are malformed")
    if any(not isinstance(enabled, bool) for enabled in capabilities.values()):
        raise ValueError("platform_checks capability values must be boolean")

    events = value.get("events")
    if not isinstance(events, list):
        raise ValueError("platform_checks events must be a list")
    for event in events:
        if not isinstance(event, dict) or not isinstance(event.get("name"), str):
            raise ValueError("platform_checks event is malformed")
        _validate_uint_fields(event, "platform_checks event", ("polls", "elapsed_ms"))

    frame = value.get("frame")
    if frame is not None:
        if not isinstance(frame, dict):
            raise ValueError("platform_checks frame is malformed")
        frame_fields = (
            "render_count", "quads", "monochrome_sprites", "subpixel_sprites", "polychrome_sprites",
            "capture_width", "capture_height", "painted_pixels",
        )
        _validate_uint_fields(frame, "platform_checks frame", frame_fields)
        if frame["capture_width"] == 0 or frame["capture_height"] == 0 or frame["painted_pixels"] > frame["capture_width"] * frame["capture_height"]:
            raise ValueError("platform_checks frame capture dimensions or painted_pixels are invalid")

    resize = value.get("resize")
    if resize is not None:
        if not isinstance(resize, dict):
            raise ValueError("platform_checks resize is malformed")
        _validate_uint_fields(resize, "platform_checks resize", ("callback_count",))
        for dimension in ("width", "height"):
            size = resize.get(dimension)
            if isinstance(size, bool) or not isinstance(size, (int, float)) or not math.isfinite(size) or size <= 0:
                raise ValueError(f"platform_checks resize {dimension} must be a positive finite number")

    errors = value.get("errors")
    if not isinstance(errors, list) or any(not isinstance(error, str) for error in errors):
        raise ValueError("platform_checks errors must be a list of strings")


def comparison_summary(manifest: dict) -> tuple[list[dict], bool]:
    """Validate and format the comparison already recorded by the Rust harness."""
    raw_changes = manifest.get("changes")
    if not isinstance(raw_changes, list):
        raise ValueError("manifest changes must be a list")
    statuses = []
    for scenario in manifest.get("scenarios", []):
        statuses.append(scenario["status"])
        statuses.extend(checkpoint["status"] for checkpoint in scenario["checkpoints"])

    normalized = []
    pixels_changed = {
        (change.get("scenario_id"), change.get("checkpoint_id"))
        for change in raw_changes
        if isinstance(change, dict)
        and change.get("kind") == "pixels_changed"
        and isinstance(change.get("scenario_id"), str)
        and isinstance(change.get("checkpoint_id"), str)
    }
    for change in raw_changes:
        if not isinstance(change, dict):
            raise ValueError("manifest change must be an object")
        kind, scenario_id = change.get("kind"), change.get("scenario_id")
        checkpoint_id, detail = change.get("checkpoint_id"), change.get("detail")
        if not isinstance(kind, str) or (kind not in CHANGE_LABELS and kind != "scene_changed"):
            raise ValueError(f"manifest change has an unknown kind: {kind!r}")
        if not isinstance(scenario_id, str) or not ID_RE.fullmatch(scenario_id):
            raise ValueError("manifest change has an invalid scenario_id")
        if not isinstance(detail, str):
            raise ValueError("manifest change detail must be text")
        if kind in CHECKPOINT_CHANGE_KINDS:
            if not isinstance(checkpoint_id, str) or not ID_RE.fullmatch(checkpoint_id):
                raise ValueError("checkpoint change has an invalid checkpoint_id")
            subject = f"{scenario_id}/{checkpoint_id}"
        else:
            if checkpoint_id is not None:
                raise ValueError("scenario change cannot include a checkpoint_id")
            subject = scenario_id
        label = CHANGE_LABELS.get(kind)
        if kind == "scene_changed":
            label = "Scene and pixels changed" if (scenario_id, checkpoint_id) in pixels_changed else "Scene-only change"
        normalized.append({
            "kind": kind,
            "label": label,
            "scenario_id": scenario_id,
            "checkpoint_id": checkpoint_id,
            "subject": subject,
            "detail": detail,
        })
    baseline_available = bool(raw_changes) or any(status != "baseline_unavailable" for status in statuses)
    return normalized, baseline_available


def load_report(root: Path) -> tuple[dict, Path]:
    if root.is_symlink():
        raise ValueError("report directory must not be a symbolic link")
    safe_root = root.resolve()
    preferred = safe_root / "visual-report" / "manifest.json"
    candidates = [preferred] if preferred.is_file() else [safe_root / "manifest.json", *safe_root.glob("*/manifest.json")]
    manifests = [path for path in candidates if path.is_file()]
    if len(manifests) != 1:
        raise ValueError(f"expected exactly one manifest.json under {safe_root}, found {len(manifests)}")
    path = manifests[0]
    relative_manifest = path.relative_to(safe_root)
    current = safe_root
    if any((current := current / part).is_symlink() for part in relative_manifest.parts):
        raise ValueError("manifest.json is linked")
    if path.stat().st_size > 1024 * 1024:
        raise ValueError("manifest.json is linked or exceeds the 1 MiB limit")
    report_root = path.parent.resolve()
    manifest = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(manifest, dict) or manifest.get("schema_version") != 1 or manifest.get("backend") != "cpu":
        raise ValueError("unsupported visual report schema or backend")
    environment = manifest.get("environment")
    if environment is not None and (not isinstance(environment, dict) or any(not isinstance(environment.get(key), str) for key in ("renderer", "font_pack"))):
        raise ValueError("manifest environment is malformed")
    _validate_native_replay(manifest)
    _validate_platform_checks(manifest.get("platform_checks"))
    scenarios = manifest.get("scenarios")
    if not isinstance(scenarios, list):
        raise ValueError("manifest scenarios must be a list")
    scenario_ids: set[str] = set()
    checkpoint_ids: set[tuple[str, str]] = set()
    referenced_paths: set[str] = set()
    for scenario in scenarios:
        if not isinstance(scenario, dict):
            raise ValueError("manifest scenario must be an object")
        sid = scenario.get("id")
        if not isinstance(sid, str) or not ID_RE.fullmatch(sid) or sid in scenario_ids:
            raise ValueError(f"scenario has an invalid or duplicate id: {sid!r}")
        scenario_ids.add(sid)
        if not isinstance(scenario.get("title", sid), str):
            raise ValueError(f"scenario {sid} title must be text")
        viewport = scenario.get("viewport")
        if viewport is not None:
            if not isinstance(viewport, dict) or any(not isinstance(viewport.get(key), (int, float)) for key in ("width", "height", "scale_factor")):
                raise ValueError(f"scenario {sid} viewport is malformed")
        _validate_status_fields(scenario, f"scenario {sid}")
        checkpoints = scenario.get("checkpoints")
        if not isinstance(checkpoints, list):
            raise ValueError(f"scenario {sid} checkpoints must be a list")
        for checkpoint_index, checkpoint in enumerate(checkpoints):
            if not isinstance(checkpoint, dict):
                raise ValueError(f"scenario {sid} checkpoint must be an object")
            cid = checkpoint.get("id")
            if not isinstance(cid, str) or not ID_RE.fullmatch(cid) or (sid, cid) in checkpoint_ids:
                raise ValueError(f"scenario {sid} has an invalid or duplicate checkpoint id: {cid!r}")
            checkpoint_ids.add((sid, cid))
            _validate_status_fields(checkpoint, f"checkpoint {sid}/{cid}")
            if "time_ns" in checkpoint and (not isinstance(checkpoint["time_ns"], int) or isinstance(checkpoint["time_ns"], bool) or checkpoint["time_ns"] < 0):
                raise ValueError(f"checkpoint {sid}/{cid} time_ns must be a non-negative integer")
            if "before_time_ns" in checkpoint and checkpoint["before_time_ns"] is not None:
                _nonnegative_int(checkpoint["before_time_ns"], f"checkpoint {sid}/{cid} before_time_ns")
            for field in ("png", "scene_json", "before_png", "diff_png", "heatmap_png"):
                value = checkpoint.get(field)
                if field in ("png", "scene_json") and value is None:
                    raise ValueError(f"checkpoint {sid}/{cid} is missing {field}")
                if value is not None:
                    suffix = (".png",) if field.endswith("png") else (".json", ".json.gz")
                    relative = validate_relative(value, suffix)
                    if relative in referenced_paths:
                        raise ValueError(f"report asset is referenced more than once: {relative}")
                    referenced_paths.add(relative)
                    checkpoint[field] = relative
            expected_heatmap = f"{sid}/{cid}.heatmap.png"
            if checkpoint.get("heatmap_png") is not None and checkpoint["heatmap_png"] != expected_heatmap:
                raise ValueError(f"checkpoint {sid}/{cid} heatmap_png must be {expected_heatmap!r}")
            if checkpoint.get("difference") is not None:
                _validate_image_difference(checkpoint["difference"], f"checkpoint {sid}/{cid}")
            if checkpoint.get("motion") is not None:
                _validate_motion(
                    checkpoint["motion"],
                    checkpoints[checkpoint_index - 1] if checkpoint_index > 0 else None,
                    checkpoint, f"checkpoint {sid}/{cid}",
                )
            if checkpoint.get("heatmap_png") is not None and checkpoint.get("difference") is None:
                raise ValueError(f"checkpoint {sid}/{cid} heatmap_png requires difference statistics")
            if checkpoint.get("native") is not None:
                if manifest.get("native_replay") is None:
                    raise ValueError(f"checkpoint {sid}/{cid} has native data without native_replay metadata")
                _validate_native_checkpoint(checkpoint["native"], scenario, checkpoint, manifest["native_replay"], referenced_paths)
    comparison_summary(manifest)
    return manifest, report_root


def validate_report_head(manifest: dict, expected_head: str) -> None:
    """Require embedded capture provenance to match the forge-verified head."""
    if not isinstance(expected_head, str) or not re.fullmatch(r"[0-9a-fA-F]{40}", expected_head):
        raise ValueError("expected publication head must be a full commit SHA")
    recorded = (manifest.get("environment") or {}).get("git_sha")
    if recorded is None:
        return
    if not isinstance(recorded, str) or not re.fullmatch(r"[0-9a-fA-F]{40}", recorded):
        raise ValueError("manifest environment.git_sha must be a full commit SHA")
    if recorded.lower() != expected_head.lower():
        raise ValueError("manifest environment.git_sha does not match the expected publication head")


def read_asset(root: Path, relative: str) -> bytes:
    path = _safe_path(root, relative)
    if not path.is_file():
        raise ValueError(f"report asset is missing: {relative}")
    if path.stat().st_size > MAX_FILE_BYTES:
        raise ValueError(f"report asset is too large: {relative}")
    data = path.read_bytes()
    if len(data) > MAX_FILE_BYTES:
        raise ValueError(f"report asset is too large: {relative}")
    if relative.endswith(".png") and not data.startswith(b"\x89PNG\r\n\x1a\n"):
        raise ValueError(f"report image is not a PNG: {relative}")
    if relative.endswith(".json.gz"):
        try:
            with gzip.GzipFile(fileobj=io.BytesIO(data)) as compressed:
                expanded = compressed.read(MAX_FILE_BYTES + 1)
        except (OSError, EOFError, zlib.error) as error:
            raise ValueError(f"scene JSON gzip is invalid: {relative}") from error
        if len(expanded) > MAX_FILE_BYTES:
            raise ValueError(f"expanded scene JSON exceeds the 12 MiB limit: {relative}")
        json.loads(expanded)
    elif relative.endswith(".json"):
        json.loads(data)
    return data


def _trusted_viewer_sources() -> dict[str, bytes]:
    return {name: (REPORT_VIEWER_DIR / name).read_bytes() for name in ("viewer.js", "viewer.css")}


def markdown_report(manifest: dict) -> bytes:
    changes, baseline_available = comparison_summary(manifest)
    lines = ["# GPUI visual report", "", "**Baseline comparison:** " + ("available" if baseline_available else "unavailable") + "."]
    lines.extend(["", "## Visual comparison"])
    if baseline_available and changes:
        lines.extend(f"- **{item['label']}:** {markdown_text(item['subject'])} — {markdown_text(item['detail'])}" for item in changes)
    elif baseline_available:
        lines.append("No typed checkpoint, timeline, scene, or pixel changes were recorded.")
    else:
        lines.append("No baseline capture was available; current captures are shown without comparison diffs.")
    lines.extend(["", "## Metrics", markdown_metrics_table(manifest)])
    return ("\n".join(lines).rstrip() + "\n").encode("utf-8")


def report_assets(manifest: dict, root: Path) -> dict[str, bytes]:
    paths = {"manifest.json"}
    for scenario in manifest["scenarios"]:
        for checkpoint in scenario["checkpoints"]:
            paths.update(checkpoint[key] for key in ("png", "scene_json", "before_png", "diff_png", "heatmap_png") if checkpoint.get(key))
            native = checkpoint.get("native")
            if native:
                paths.update(native[key] for key in ("png", "diff_png", "heatmap_png") if native.get(key))
    assets: dict[str, bytes] = {}
    total = 0
    generated = {"report.md": markdown_report(manifest), **_trusted_viewer_sources()}
    for relative, data in sorted({**generated, **{path: None for path in paths}}.items()):
        if data is None:
            data = read_asset(root, relative)
        total += len(data)
        if total > MAX_REPORT_BYTES:
            raise ValueError("report assets exceed the 48 MiB hosting limit")
        assets[relative] = data
    graph_path = _safe_path(root, "metrics.svg")
    if graph_path.is_file():
        if graph_path.stat().st_size > MAX_FILE_BYTES:
            raise ValueError("timing graph is too large")
        data = sanitize_svg(graph_path.read_bytes())
        total += len(data)
        if total > MAX_REPORT_BYTES:
            raise ValueError("report assets exceed the 48 MiB hosting limit")
        assets["metrics.svg"] = data
    return assets


def sanitize_svg(data: bytes) -> bytes:
    if len(data) > MAX_FILE_BYTES:
        raise ValueError("timing graph is too large")
    if re.search(br"<!\s*(?:DOCTYPE|ENTITY)\b", data, re.IGNORECASE):
        raise ValueError("metrics.svg must not contain a DTD or entity declaration")
    parser = expat.ParserCreate(namespace_separator="}")
    output: list[str] = ['<?xml version="1.0" encoding="utf-8"?>']
    stack: list[tuple[str, bool]] = []
    root_seen = False

    def start(name: str, attrs: dict[str, str]) -> None:
        nonlocal root_seen
        namespace, separator, local = name.rpartition("}")
        if not root_seen:
            root_seen = True
            if not separator or namespace != SVG_NS or local != "svg":
                raise ValueError("metrics.svg does not have an SVG root")
        inherited_suppression = bool(stack and stack[-1][1])
        suppress = inherited_suppression or not separator or namespace != SVG_NS or local not in SVG_TAGS
        stack.append((local, suppress))
        if suppress:
            return
        rendered = []
        for key, value in attrs.items():
            if key not in SVG_ATTRS:
                continue
            if key in {"fill", "stroke", "clip-path"} and "url(" in value.lower() and not re.fullmatch(r"url\(#[A-Za-z0-9_.-]+\)", value):
                continue
            if key == "id" and not re.fullmatch(r"[A-Za-z0-9_.-]+", value):
                continue
            rendered.append(f' {key}="{html.escape(value, quote=True)}"')
        if local == "svg":
            rendered = [item for item in rendered if not item.startswith(" xmlns=")]
            rendered.append(f' xmlns="{SVG_NS}"')
        output.append("<" + local + "".join(rendered) + ">")

    def end(name: str) -> None:
        local, suppressed = stack.pop()
        if not suppressed:
            output.append(f"</{local}>")

    def text_content(value: str) -> None:
        if not stack or stack[-1][1]:
            return
        output.append(html.escape(value))

    def reject_doctype(*_args) -> None:
        raise ValueError("metrics.svg must not contain a DTD or entity declaration")

    parser.StartElementHandler = start
    parser.EndElementHandler = end
    parser.CharacterDataHandler = text_content
    parser.StartDoctypeDeclHandler = reject_doctype
    parser.EntityDeclHandler = reject_doctype
    parser.ExternalEntityRefHandler = lambda *_args: 0
    parser.Parse(data, True)
    if not root_seen or stack:
        raise ValueError("metrics.svg is incomplete")
    return "".join(output).encode("utf-8")


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


def markdown_metrics_table(manifest: dict) -> str:
    """Render one consistent timing and memory table for either forge adapter."""
    output = []
    cpu_headers = (
        "Scenario / checkpoint", "Samples", "Scene build p50/p95/p99", "CPU render p50/p95/p99",
        "Primitives", "Batches", "Bitmap bytes", "Status",
    )
    captures = [(scenario, checkpoint) for scenario in manifest["scenarios"] for checkpoint in scenario["checkpoints"]]
    if captures:
        rows = ["| " + " | ".join(cpu_headers) + " |", "|---|---|---:|---:|---:|---:|---:|---|"]
        for scenario, checkpoint in captures:
            values = [
                markdown_text(f"{scenario.get('title', scenario['id'])} / {checkpoint.get('name', checkpoint['id'])}"),
                _count_text(metric(checkpoint, "frame_count")),
                _timing_triplet(checkpoint.get("metrics", {}), "scene_build"),
                _timing_triplet(checkpoint.get("metrics", {}), "cpu_render"),
                _count_text(metric(checkpoint, "primitive_count")),
                _count_text(metric(checkpoint, "batch_count")),
                _count_text(metric(checkpoint, "bitmap_storage_bytes")),
                markdown_text(checkpoint.get("status", "n/a")),
            ]
            rows.append("| " + " | ".join(values) + " |")
        output.append("\n".join(rows))
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
        tracked_scopes = sorted({checkpoint["native"]["metrics"]["allocation_scope"] for _scenario, checkpoint in checkpoints}) or ["not reported"]
        device_scopes = sorted({checkpoint["native"]["metrics"]["device_allocation_scope"] for _scenario, checkpoint in checkpoints if checkpoint["native"]["metrics"].get("device_allocation_scope")})
        allocation_reasons = sorted({checkpoint["native"]["metrics"]["allocation_reason"] for _scenario, checkpoint in checkpoints if checkpoint["native"]["metrics"].get("allocation_reason")})
        provenance = "**Allocation provenance:** tracked-owned bytes: " + ", ".join(markdown_text(value) for value in tracked_scopes)
        provenance += "; device-allocation scopes: " + (", ".join(markdown_text(value) for value in device_scopes) or "not exposed")
        provenance += "; unavailable reason: " + (", ".join(markdown_text(value) for value in allocation_reasons) or "not reported") + "."
        for scenario in manifest["scenarios"]:
            for checkpoint in scenario["checkpoints"]:
                native = checkpoint.get("native")
                if not native:
                    continue
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
        output.extend([intro, provenance, "\n".join(native_rows)])
    platform_summary = markdown_platform_checks(manifest.get("platform_checks"))
    if platform_summary:
        output.append(platform_summary)
    return "\n\n".join(output)


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


def trusted_index(manifest: dict) -> bytes:
    """Embed a validated manifest in the checked-in, dependency-free report viewer."""
    template = (REPORT_VIEWER_DIR / "index.html").read_text(encoding="utf-8")
    sources = _trusted_viewer_sources()
    style = sources["viewer.css"].decode("utf-8")
    script = sources["viewer.js"].decode("utf-8")
    data = json.dumps(manifest, ensure_ascii=False, allow_nan=False, separators=(",", ":"))
    data = data.replace("<", r"\u003c")
    page = template.replace("{{STYLE}}", style).replace("{{SCRIPT}}", script)
    return page.replace("{{DATA}}", data).encode("utf-8")


def pages_index(reports: list[dict], page_url: str) -> bytes:
    """Build a trusted root index with the latest commit report for each PR and all reports."""
    page_url = validate_site_base(page_url)
    safe_records = validate_records(reports)
    safe_base = quote(page_url, safe=":/")
    latest: dict[str, dict] = {}
    for record in safe_records:
        latest[record["pr"]] = record
    parts = ["<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width\"><title>GPUI visual reports</title></head><body><main><h1>GPUI visual reports</h1><h2>Latest per pull request</h2><ul>"]
    for pr, record in sorted(latest.items(), key=lambda item: int(item[0]), reverse=True):
        url = safe_base + "/pulls/" + pr + "/index.html"
        parts.append(f"<li><a href=\"{html.escape(url, quote=True)}\">PR #{pr} · {record['sha'][:12]}</a></li>")
    parts.append("</ul><h2>All published reports</h2><ol>")
    for record in reversed(safe_records):
        url = safe_base + "/runs/" + record["sha"] + "/index.html"
        parts.append(f"<li><a href=\"{html.escape(url, quote=True)}\">PR #{record['pr']} · {record['sha']}</a></li>")
    parts.append("</ol></main></body></html>")
    return "".join(parts).encode()


def validate_records(reports: list[dict]) -> list[dict]:
    if not isinstance(reports, list):
        raise ValueError("report index must be a list")
    safe_records = []
    seen = set()
    for record in reports:
        if not isinstance(record, dict):
            raise ValueError("invalid entry in report index")
        sha, pr = record.get("sha"), record.get("pr")
        if isinstance(pr, int) and not isinstance(pr, bool):
            pr = str(pr)
        if not isinstance(sha, str) or not SHA_RE.fullmatch(sha) or not isinstance(pr, str) or not pr.isdigit():
            raise ValueError("invalid entry in report index")
        if (sha, pr) in seen:
            raise ValueError("duplicate entry in report index")
        seen.add((sha, pr))
        safe_records.append({"sha": sha, "pr": pr})
    return safe_records


def pull_index(reports: list[dict], pull_request: str, page_url: str) -> bytes:
    if not pull_request.isdigit():
        raise ValueError("invalid pull request id")
    page_url = validate_site_base(page_url)
    safe_base = quote(page_url, safe=":/")
    matching = [record for record in validate_records(reports) if record["pr"] == pull_request]
    parts = [f"<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width\"><title>GPUI visual reports for PR #{pull_request}</title></head><body><main><h1>Visual reports for PR #{pull_request}</h1><ol>"]
    for record in reversed(matching):
        url = safe_base + "/runs/" + record["sha"] + "/index.html"
        parts.append(f"<li><a href=\"{html.escape(url, quote=True)}\">{record['sha']}</a></li>")
    parts.extend(["</ol><p><a href=\"../../index.html\">All pull requests</a></p></main></body></html>"])
    return "".join(parts).encode()
