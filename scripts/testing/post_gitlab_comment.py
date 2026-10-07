#!/usr/bin/env python3
"""Optionally update one GitLab merge-request note from a trusted report job."""

from __future__ import annotations

import os
from pathlib import Path
import re
from urllib.parse import quote

import report_support as report

MARKER = "<!-- gpui-visual-test-report -->"
SHA_RE = re.compile(r"^[0-9a-f]{40}$")


def api(method: str, url: str, token: str, payload: object | None = None):
    return report.json_request(method, url, {"PRIVATE-TOKEN": token}, payload, api_name="GitLab API")


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
    report.validate_report_head(manifest, mr["sha"])
    changes, baseline_available = report.comparison_summary(manifest)
    body = [MARKER, f"## GPUI visual report · {head_sha[:12]}", "", f"[Open job report artifact]({artifact_url})", ""]
    if baseline_available:
        body.append("**Visual comparison:**")
        if changes:
            body.append(report.markdown_change_summary(changes))
        if not changes:
            body.append("- No checkpoint, timeline, or pixel changes detected.")
    else:
        body.append("No baseline capture was available; current captures are shown without comparison diffs.")
    body.extend(["", report.markdown_metrics_table(manifest, limit=20)])
    previews = report.preview_checkpoints(manifest, baseline_available)
    for scenario, checkpoint in previews[:4]:
        body.extend(["", f"**{report.markdown_text(scenario.get('title', scenario['id']))} / {report.markdown_text(checkpoint.get('name', checkpoint['id']))}**"])
        stats = report.checkpoint_preview_text(checkpoint)
        if stats:
            body.append(stats)
        assets = []
        for field, label in (("before_png", "Before"), ("png", "Current"),
                             ("diff_png", "CPU changes in red"), ("heatmap_png", "CPU magnitude heatmap")):
            if checkpoint.get(field):
                assets.append((label, checkpoint[field]))
        motion = checkpoint.get("motion")
        if motion and motion["difference"]["changed_pixels"] > 0:
            if motion.get("diff_png"):
                assets.append(("Transition mask · previous → current", motion["diff_png"]))
            if motion.get("heatmap_png"):
                assets.append(("Transition heatmap · previous → current", motion["heatmap_png"]))
        if assets:
            hosted = [(label, path, report.hosted_report_asset_url(artifact_url, path)) for label, path in assets]
            if all(url for _label, _path, url in hosted):
                body.extend(f"**{label}:** ![{label}]({url})" for label, _path, url in hosted)
            else:
                body.append("Available in [report artifacts]({}): {}".format(
                    artifact_url, "; ".join(f"{label}: `{path}`" for label, path in assets),
                ))
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
