#!/usr/bin/env python3
"""Optionally update one GitLab merge-request note from a trusted report job."""

from __future__ import annotations

import html
import json
import os
from pathlib import Path
import re
from urllib.error import HTTPError
from urllib.parse import quote
from urllib.request import Request, urlopen

import report_support as report

MARKER = "<!-- gpui-visual-test-report -->"
SHA_RE = re.compile(r"^[0-9a-f]{40}$")


def api(method: str, url: str, token: str, payload: object | None = None):
    body = None if payload is None else json.dumps(payload).encode()
    request = Request(url, data=body, method=method, headers={
        "PRIVATE-TOKEN": token,
        "Content-Type": "application/json",
        "User-Agent": "gpui-visual-report",
    })
    try:
        with urlopen(request, timeout=30) as response:
            data = response.read()
            return json.loads(data) if data else None
    except HTTPError as error:
        detail = error.read().decode("utf-8", "replace")[:1000]
        raise RuntimeError(f"GitLab API {method} returned {error.code}: {detail}") from error


def main() -> int:
    token = os.environ["GITLAB_API_TOKEN"]
    api_root = os.environ["CI_API_V4_URL"].rstrip("/")
    project_id = quote(os.environ["CI_PROJECT_ID"], safe="")
    merge_request = os.environ["CI_MERGE_REQUEST_IID"]
    head_sha = os.environ["CI_COMMIT_SHA"].lower()
    bot_username = os.environ["GPUI_GITLAB_BOT_USERNAME"]
    artifact_url = os.environ["GPUI_VISUAL_REPORT_URL"]
    if not merge_request.isdigit() or not SHA_RE.fullmatch(head_sha):
        raise ValueError("invalid merge-request IID or commit SHA")

    endpoint = f"{api_root}/projects/{project_id}/merge_requests/{merge_request}"
    mr = api("GET", endpoint, token)
    if mr.get("sha", "").lower() != head_sha:
        print("Merge request head changed; skipping stale visual report.")
        return 0

    manifest, report_root = report.load_report(Path("visual-report"))
    try:
        changes, baseline_available = report.find_baseline(Path("visual-report"), manifest, report_root)
    except (OSError, ValueError, json.JSONDecodeError) as error:
        print(f"Could not read the baseline report; current captures will still be posted: {error}")
        changes, baseline_available = [], False
    body = [MARKER, f"## GPUI visual report · {head_sha[:12]}", "", f"[Open job report artifact]({artifact_url})", ""]
    if baseline_available:
        body.append("**Visual comparison:**")
        pixel_keys = {detail.rsplit(" ", 1)[-1] for kind, detail in changes if kind == "pixels_changed"}
        for kind, detail in changes:
            label = {
                "scenario_added": "Scenario added",
                "scenario_removed": "Scenario removed",
                "checkpoint_added": "Checkpoint added",
                "checkpoint_removed": "Checkpoint removed",
                "scenario_metadata_changed": "Viewport or scenario metadata changed",
                "checkpoint_metadata_changed": "Checkpoint timeline changed",
                "pixels_changed": "Pixels changed",
                "scene_changed": "Scene and pixels changed" if detail.rsplit(" ", 1)[-1] in pixel_keys else "Scene-only change",
            }.get(kind, "Changed")
            body.append(f"- **{label}:** {report.markdown_text(detail)}")
        if not changes:
            body.append("- No checkpoint, timeline, or pixel changes detected.")
    else:
        body.append("No baseline capture was available; current captures are shown without comparison diffs.")
    body.extend(["", "| Scenario | Checkpoint | Scene build p50 | CPU render p50 | Frames | Primitives |", "|---|---|---:|---:|---:|---:|"])
    for scenario in manifest["scenarios"]:
        for checkpoint in scenario["checkpoints"]:
            title = html.escape(str(scenario.get("title", scenario["id"])), quote=False).replace("|", "&#124;")
            name = html.escape(str(checkpoint.get("name", checkpoint["id"])), quote=False).replace("|", "&#124;")
            build = report.metric(checkpoint, "scene_build_p50_ns")
            render = report.metric(checkpoint, "cpu_render_p50_ns")
            frames, primitives = report.metric(checkpoint, "frame_count"), report.metric(checkpoint, "primitive_count")
            body.append(f"| {title} | {name} | {report.format_ms(build)} | {report.format_ms(render)} | {frames if frames is not None else 'n/a'} | {primitives if primitives is not None else 'n/a'} |")
    text = "\n".join(body)

    if api("GET", endpoint, token).get("sha", "").lower() != head_sha:
        print("Merge request head changed before note update; skipping stale visual report.")
        return 0
    notes = []
    for page in range(1, 11):
        batch = api("GET", endpoint + f"/notes?per_page=100&page={page}", token)
        notes.extend(batch)
        if len(batch) < 100:
            break
    existing = next((note for note in notes if note.get("author", {}).get("username") == bot_username and MARKER in note.get("body", "")), None)
    if existing:
        api("PUT", endpoint + f"/notes/{existing['id']}", token, {"body": text})
    else:
        api("POST", endpoint + "/notes", token, {"body": text})
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as error:
        print(f"GitLab visual report publisher: {error}")
        raise SystemExit(1)
