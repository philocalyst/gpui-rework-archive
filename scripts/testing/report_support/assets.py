"""Bounded artifact loading and sanitized publication assets."""
from __future__ import annotations
import html
import gzip
import io
import json
from pathlib import Path
import re
import zlib
from xml.parsers import expat
from .common import MAX_FILE_BYTES, MAX_REPORT_BYTES, SVG_ATTRS, SVG_NS, SVG_TAGS, _safe_path, _trusted_viewer_sources
from .presentation import markdown_report
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

def report_assets(manifest: dict, root: Path) -> dict[str, bytes]:
    paths = {"manifest.json"}
    for scenario in manifest["scenarios"]:
        for checkpoint in scenario["checkpoints"]:
            paths.update(checkpoint[key] for key in ("png", "scene_json", "before_png", "diff_png", "heatmap_png") if checkpoint.get(key))
            native = checkpoint.get("native")
            if native:
                paths.update(native[key] for key in ("png", "diff_png", "heatmap_png") if native.get(key))
            motion = checkpoint.get("motion")
            if motion:
                paths.update(motion[key] for key in ("diff_png", "heatmap_png") if motion.get(key))
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
