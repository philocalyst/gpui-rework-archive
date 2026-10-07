"""Shared validation primitives, limits, and transport."""
from __future__ import annotations
import json
import math
from pathlib import Path, PurePosixPath
import re
from urllib.parse import urlsplit
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

REPORT_VIEWER_DIR = Path(__file__).resolve().parents[3] / "crates/gpui_test/assets/report"

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

PLATFORM_CAPABILITIES = (
    "native_visibility", "focus_handle", "native_render_capture", "resize_callback", "two_window_close",
)

def _trusted_viewer_sources() -> dict[str, bytes]:
    return {name: (REPORT_VIEWER_DIR / name).read_bytes() for name in ("viewer.js", "viewer.css")}

def _has_motion_error(checkpoint: dict) -> bool:
    return checkpoint.get("motion", {}).get("difference", {}).get("changed_pixels", 0) > 0
