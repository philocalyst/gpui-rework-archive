"""Portable report views and forge comment previews."""
from __future__ import annotations
import html
import json
import math
from collections import Counter
from urllib.parse import quote, urlsplit
from .common import _has_motion_error, REPORT_VIEWER_DIR, SHA_RE, _trusted_viewer_sources, validate_relative, validate_site_base
from .comparison import comparison_summary
from .metrics import format_ms, markdown_metrics_table, markdown_text
def markdown_change_summary(changes: list[dict], limit: int = 25) -> str:
    """Bound comment change details while retaining category counts and full subjects."""
    counts = Counter(item["label"] for item in changes)
    categories = ", ".join(f"{markdown_text(label)}: {count}" for label, count in sorted(counts.items()))
    lines = [f"{len(changes)} baseline changes" + (f" ({categories})" if categories else ":")]
    for change in changes[:limit]:
        detail = change["detail"]
        if len(detail) > 240:
            detail = detail[:237] + "..."
        lines.append(f"- **{change['label']}:** {markdown_text(change['subject'])} — {markdown_text(detail)}")
    if len(changes) > limit:
        lines.append(f"{len(changes) - limit} more change details omitted; the linked report/workflow artifact has the complete list.")
    return "\n".join(lines)

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
    comparisons = []
    for scenario in manifest["scenarios"]:
        for checkpoint in scenario["checkpoints"]:
            if not checkpoint.get("difference") and not _has_motion_error(checkpoint):
                continue
            motion = checkpoint.get("motion") or {}
            paths = [
                ("Exact red", checkpoint.get("diff_png")),
                ("Magnitude heatmap", checkpoint.get("heatmap_png")),
                ("Transition red", motion.get("diff_png")),
                ("Transition heatmap", motion.get("heatmap_png")),
            ]
            title = markdown_text(f"{scenario['id']} / {checkpoint['id']}")
            assets = " · ".join(f"[{label}]({quote(path, safe='/')})" for label, path in paths if path)
            comparisons.extend(["", f"### {title}", checkpoint_preview_text(checkpoint), assets])
    if comparisons:
        lines.extend(["", "## Image and transition differences", *comparisons])
    lines.extend(["", "## Metrics", markdown_metrics_table(manifest)])
    return ("\n".join(lines).rstrip() + "\n").encode("utf-8")

def hosted_report_asset_url(report_url: str, relative: str) -> str | None:
    """Resolve an asset only when the configured URL is a safe static report index."""
    parsed = urlsplit(report_url)
    if (parsed.scheme not in {"http", "https"} or not parsed.netloc or parsed.username or parsed.password
            or parsed.query or parsed.fragment or not parsed.path.endswith("/index.html")):
        return None
    safe = validate_relative(relative, (".png",))
    base_path = parsed.path.rsplit("/", 1)[0] + "/"
    return f"{parsed.scheme}://{parsed.netloc}{base_path}{quote(safe, safe='/')}"



def preview_checkpoints(manifest: dict, baseline_available: bool) -> list[tuple[dict, dict]]:
    checkpoints = [(scenario, checkpoint) for scenario in manifest["scenarios"] for checkpoint in scenario["checkpoints"]]
    if not baseline_available:
        return checkpoints
    def priority(item: tuple[dict, dict]) -> int:
        checkpoint = item[1]
        if _has_motion_error(checkpoint):
            return 0 if checkpoint.get("pixels_changed") is False else 1
        if checkpoint.get("status") in {"changed", "new"} or checkpoint.get("pixels_changed") is True:
            return 1
        return 2 if checkpoint.get("native") else 3
    return sorted((item for item in checkpoints if priority(item) < 3), key=priority)

def checkpoint_preview_text(checkpoint: dict) -> str:
    lines = []
    def concise(value: object) -> str:
        if isinstance(value, bool) or not isinstance(value, (int, float)) or not math.isfinite(value):
            return "n/a"
        return f"{value:.4g}"

    difference = checkpoint.get("difference")
    if difference:
        changed, total = difference.get("changed_pixels"), difference.get("total_pixels")
        percentage = f"{concise(100 * changed / total)}%" if isinstance(changed, int) and isinstance(total, int) and total else "n/a"
        visible = difference.get("visible") or {}
        visible_changed = visible.get("changed_pixels")
        visible_text = "n/a" if not isinstance(visible_changed, int) or not total else f"{visible_changed}/{total} ({concise(100 * visible_changed / total)}%)"
        lines.append(f"CPU pixel error: {changed}/{total} ({percentage}); visible {visible_text}; mean/peak {concise(difference.get('mean_channel_error'))}/{concise(difference.get('max_channel_error'))}.")
    motion = checkpoint.get("motion")
    if motion and motion["difference"]["changed_pixels"] > 0:
        difference = motion["difference"]
        changed, total = difference["changed_pixels"], difference["total_pixels"]
        percentage = f"{concise(100 * changed / total)}%" if total else "n/a"
        before, current = format_ms(motion.get("before_duration_ns")), format_ms(motion.get("current_duration_ns"))
        lines.append(f"Transition error: {changed}/{total} ({percentage}); signed premultiplied mean/peak {concise(difference['mean_channel_error'])}/{concise(difference['max_channel_error'])}; baseline/current elapsed {before}/{current}.")
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
