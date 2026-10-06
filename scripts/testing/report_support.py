"""Forge-neutral validation, comparison, and static-view helpers for GPUI reports."""

from __future__ import annotations

import html
import json
from pathlib import Path, PurePosixPath
import re
from xml.parsers import expat
from urllib.parse import quote, urlsplit

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
    if status is not None and (not isinstance(status, str) or status not in STATUSES):
        raise ValueError(f"{label} has an invalid comparison status")
    for field in ("pixels_changed", "scene_changed", "metadata_changed"):
        flag = value.get(field)
        if flag is not None and not isinstance(flag, bool):
            raise ValueError(f"{label} field {field} must be boolean")


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
        for checkpoint in checkpoints:
            if not isinstance(checkpoint, dict):
                raise ValueError(f"scenario {sid} checkpoint must be an object")
            cid = checkpoint.get("id")
            if not isinstance(cid, str) or not ID_RE.fullmatch(cid) or (sid, cid) in checkpoint_ids:
                raise ValueError(f"scenario {sid} has an invalid or duplicate checkpoint id: {cid!r}")
            checkpoint_ids.add((sid, cid))
            _validate_status_fields(checkpoint, f"checkpoint {sid}/{cid}")
            if "time_ns" in checkpoint and (not isinstance(checkpoint["time_ns"], int) or isinstance(checkpoint["time_ns"], bool) or checkpoint["time_ns"] < 0):
                raise ValueError(f"checkpoint {sid}/{cid} time_ns must be a non-negative integer")
            for field in ("png", "scene_json", "before_png", "diff_png"):
                value = checkpoint.get(field)
                if field in ("png", "scene_json") and value is None:
                    raise ValueError(f"checkpoint {sid}/{cid} is missing {field}")
                if value is not None:
                    suffix = (".png",) if field.endswith("png") else (".json",)
                    relative = validate_relative(value, suffix)
                    if relative in referenced_paths:
                        raise ValueError(f"report asset is referenced more than once: {relative}")
                    referenced_paths.add(relative)
                    checkpoint[field] = relative
    return manifest, report_root


def find_baseline(report_path: Path, current: dict, current_root: Path) -> tuple[list[tuple[str, str]], bool]:
    candidates = [report_path / "visual-baseline", report_path.parent / "visual-baseline"]
    baseline_dir = next((path for path in candidates if (path / "manifest.json").is_file()), None)
    if baseline_dir is None:
        return [], False
    baseline, baseline_root = load_report(baseline_dir)
    return compare_manifests(current, current_root, baseline, baseline_root), True


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
    if relative.endswith(".json"):
        json.loads(data)
    return data


def report_assets(manifest: dict, root: Path) -> dict[str, bytes]:
    paths = {"manifest.json"}
    for scenario in manifest["scenarios"]:
        for checkpoint in scenario["checkpoints"]:
            paths.update(checkpoint[key] for key in ("png", "scene_json", "before_png", "diff_png") if checkpoint.get(key))
    assets: dict[str, bytes] = {}
    total = 0
    for relative in sorted(paths):
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


def _entity_map(manifest: dict, kind: str) -> dict[str, dict]:
    result = {}
    if kind == "scenario":
        for scenario in manifest["scenarios"]:
            result[scenario["id"]] = scenario
    else:
        for scenario in manifest["scenarios"]:
            for checkpoint in scenario["checkpoints"]:
                result[f"{scenario['id']}/{checkpoint['id']}"] = checkpoint
    return result


def compare_manifests(current: dict, current_root: Path, baseline: dict, baseline_root: Path) -> list[tuple[str, str]]:
    changes: list[tuple[str, str]] = []
    old_scenarios = _entity_map(baseline, "scenario")
    new_scenarios = _entity_map(current, "scenario")
    for sid in sorted(old_scenarios.keys() - new_scenarios.keys()):
        changes.append(("scenario_removed", f"Removed scenario {sid}"))
    for sid in sorted(new_scenarios.keys() - old_scenarios.keys()):
        changes.append(("scenario_added", f"Added scenario {sid}"))
    for sid in sorted(old_scenarios.keys() & new_scenarios.keys()):
        old, new = old_scenarios[sid], new_scenarios[sid]
        if (old.get("title"), old.get("viewport")) != (new.get("title"), new.get("viewport")) or new.get("metadata_changed") is True:
            changes.append(("scenario_metadata_changed", f"Scenario viewport or title changed {sid}"))

    old_checkpoints = _entity_map(baseline, "checkpoint")
    new_checkpoints = _entity_map(current, "checkpoint")
    shared_scenarios = old_scenarios.keys() & new_scenarios.keys()
    for key in sorted(old_checkpoints.keys() - new_checkpoints.keys()):
        if key.split("/", 1)[0] in shared_scenarios:
            changes.append(("checkpoint_removed", f"Removed checkpoint {key}"))
    for key in sorted(new_checkpoints.keys() - old_checkpoints.keys()):
        if key.split("/", 1)[0] in shared_scenarios:
            changes.append(("checkpoint_added", f"Added checkpoint {key}"))
    for key in sorted(old_checkpoints.keys() & new_checkpoints.keys()):
        old, new = old_checkpoints[key], new_checkpoints[key]
        if old.get("name") != new.get("name") or old.get("time_ns") != new.get("time_ns") or new.get("metadata_changed") is True:
            changes.append(("checkpoint_metadata_changed", f"Checkpoint timeline changed {key}"))
        pixel_flag = new.get("pixels_changed")
        scene_flag = new.get("scene_changed")
        metadata_flag = new.get("metadata_changed")
        old_png, new_png = old.get("png"), new.get("png")
        if old_png and new_png:
            pixels_changed = read_asset(baseline_root, validate_relative(old_png, (".png",))) != read_asset(current_root, validate_relative(new_png, (".png",)))
        else:
            pixels_changed = None
        old_scene, new_scene = old.get("scene_json"), new.get("scene_json")
        if old_scene and new_scene:
            scene_changed = read_asset(baseline_root, validate_relative(old_scene, (".json",))) != read_asset(current_root, validate_relative(new_scene, (".json",)))
        else:
            scene_changed = None
        if pixels_changed or pixel_flag is True:
            changes.append(("pixels_changed", f"Pixels changed {key}"))
        if scene_changed or scene_flag is True:
            changes.append(("scene_changed", f"Scene changed {key}"))
    return changes


def trusted_index(manifest: dict) -> bytes:
    title = html.escape("GPUI visual scenario report", quote=True)
    parts = [
        "<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width\">",
        f"<title>{title}</title><style>body{{font:16px system-ui;margin:2rem;max-width:1200px;color:#20242b}}img{{max-width:100%;height:auto;border:1px solid #bbb}}figure{{margin:1rem 0}}.images{{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:1rem}}table{{border-collapse:collapse}}th,td{{border:1px solid #aaa;padding:.4rem;text-align:left}}.status{{font-weight:600}}</style></head><body>",
        f"<header><h1>{title}</h1><p>Backend: {html.escape(str(manifest.get('backend', 'unknown')))} · Renderer: {html.escape(str(manifest.get('environment', {}).get('renderer', 'n/a')))} · Font pack: {html.escape(str(manifest.get('environment', {}).get('font_pack', 'n/a')))}</p>",
        '<p><a href="manifest.json">Manifest JSON</a> · <a href="metrics.svg">Timing graph</a></p></header><main>',
        '<figure id="timing-graph"><figcaption>Timing graph</figcaption><a href="metrics.svg"><img src="metrics.svg" alt="Scenario frame timing graph"></a></figure>',
    ]
    for scenario in manifest["scenarios"]:
        sid = scenario["id"]
        parts.append(f"<section><h2>{html.escape(str(scenario.get('title', sid)))}</h2><p>Scenario: <code>{html.escape(sid)}</code> · {scenario.get('viewport', {}).get('width', 'n/a')} × {scenario.get('viewport', {}).get('height', 'n/a')} @ {scenario.get('viewport', {}).get('scale_factor', 'n/a')}x <span class=\"status\">{html.escape(str(scenario.get('status', 'baseline unavailable')))}</span></p>")
        for checkpoint in scenario["checkpoints"]:
            cid = checkpoint["id"]
            name = html.escape(str(checkpoint.get("name", cid)))
            parts.append(f"<article><h3>{name}</h3><p><code>{html.escape(sid)}/{html.escape(cid)}</code> · {checkpoint.get('time_ns', 'n/a')} ns · <span class=\"status\">{html.escape(str(checkpoint.get('status', 'baseline unavailable')))}</span> · <a href=\"{quote(checkpoint['scene_json'], safe='/')}\">Scene JSON</a></p>")
            parts.append('<div class="images">')
            figures = [("Current", checkpoint.get("png")), ("Before", checkpoint.get("before_png")), ("Difference", checkpoint.get("diff_png"))]
            for label, asset in figures:
                if not asset:
                    continue
                url = quote(asset, safe="/")
                alt = html.escape(label + " " + str(scenario.get("title", sid)) + " / " + str(checkpoint.get("name", cid)), quote=True)
                parts.append(f"<figure><figcaption>{label}</figcaption><a href=\"{url}\"><img loading=\"lazy\" src=\"{url}\" alt=\"{alt}\"></a></figure>")
            parts.append("</div>")
            metrics = checkpoint.get("metrics")
            values = [metric(checkpoint, key) for key in ("scene_build_p50_ns", "scene_build_p95_ns", "scene_build_p99_ns", "cpu_render_p50_ns", "cpu_render_p95_ns", "cpu_render_p99_ns", "frame_count", "primitive_count", "batch_count", "bitmap_storage_bytes")]
            labels = ("Scene build p50", "p95", "p99", "CPU render p50", "p95", "p99", "Frames", "Primitives", "Batches", "Bitmap bytes")
            parts.append("<table><caption>Checkpoint metrics</caption><tbody>")
            for label, value in zip(labels, values):
                display = "n/a" if value is None else (f"{value / 1_000_000:.2f} ms" if "p" in label or label.startswith("Scene build") or label.startswith("CPU render") else str(value))
                parts.append(f"<tr><th>{html.escape(label)}</th><td>{display}</td></tr>")
            parts.append("</tbody></table></article>")
        parts.append("</section>")
    parts.append("</main></body></html>")
    return "".join(parts).encode()


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
        sha, pr = record.get("sha"), record.get("pr")
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
