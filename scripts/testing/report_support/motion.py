"""Adjacent-frame comparison schema validation."""
from __future__ import annotations
import math
from .common import ID_RE, _nonnegative_int, _validate_uint_fields, validate_relative
def _validate_motion(value: object, previous: dict | None, checkpoint: dict, label: str, scenario_id: str, referenced_paths: set[str]) -> None:
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
    for field, suffix in (("diff_png", ".motion.diff.png"), ("heatmap_png", ".motion.heatmap.png")):
        path = value.get(field)
        if path is None:
            continue
        if changed == 0:
            raise ValueError(f"{label} motion {field} requires changed pixels")
        relative = validate_relative(path, (".png",))
        expected_path = f"{scenario_id}/{checkpoint['id']}{suffix}"
        if relative != expected_path:
            raise ValueError(f"{label} motion {field} must be {expected_path!r}")
        if relative in referenced_paths:
            raise ValueError(f"report asset is referenced more than once: {relative}")
        referenced_paths.add(relative)
        value[field] = relative
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
