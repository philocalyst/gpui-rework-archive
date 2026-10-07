"""Native replay and window-check schema validation."""
from __future__ import annotations
import math
from .common import PLATFORM_CAPABILITIES, _nonnegative_int, _validate_image_difference, _validate_uint_fields, validate_relative
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
