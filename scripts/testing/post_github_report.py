#!/usr/bin/env python3
"""Publish validated captures and update one PR comment on GitHub or GHES."""

from __future__ import annotations

import base64
import json
import os
from pathlib import Path
import re
import sys
from urllib.error import HTTPError
from urllib.parse import quote, urlsplit
from urllib.request import Request, urlopen

from report_support import find_baseline, format_ms, load_report, markdown_text, metric, pages_index, pull_index, report_assets, trusted_index

MARKER = "<!-- gpui-visual-test-report -->"
OWNER_RE = re.compile(r"^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")
SHA_RE = re.compile(r"^[0-9a-f]{40}$")


def github_api_url() -> str:
    return os.environ.get("GITHUB_API_URL", "https://api.github.com").rstrip("/")


def github_server_url() -> str:
    return os.environ.get("GITHUB_SERVER_URL", "https://github.com").rstrip("/")


def api(method: str, endpoint: str, token: str, payload: object | None = None):
    body = None if payload is None else json.dumps(payload).encode()
    url = github_api_url() + "/" + endpoint.lstrip("/")
    request = Request(url, data=body, method=method, headers={
        "Accept": "application/vnd.github+json", "Authorization": f"Bearer {token}",
        "X-GitHub-Api-Version": "2022-11-28", "Content-Type": "application/json", "User-Agent": "gpui-visual-report",
    })
    try:
        with urlopen(request, timeout=30) as response:
            data = response.read()
            return json.loads(data) if data else None
    except HTTPError as error:
        detail = error.read().decode("utf-8", "replace")[:1000]
        raise RuntimeError(f"GitHub API {method} {endpoint} returned {error.code}: {detail}") from error


def validate_pages_url(value: str) -> str:
    parsed = urlsplit(value)
    if parsed.scheme not in {"http", "https"} or not parsed.netloc or parsed.username or parsed.password or parsed.query or parsed.fragment:
        raise ValueError("GPUI_VISUAL_PAGES_URL must be an HTTP(S) base URL without credentials, query, or fragment")
    return value.rstrip("/")


def _blob(repository: str, content: bytes, token: str) -> str:
    response = api("POST", f"repos/{repository}/git/blobs", token, {
        "content": base64.b64encode(content).decode(), "encoding": "base64",
    })
    return response["sha"]


def _read_registry(repository: str, tree_sha: str, token: str) -> list[dict]:
    tree = api("GET", f"repos/{repository}/git/trees/{tree_sha}", token)
    entry = next((item for item in tree.get("tree", []) if item.get("path") == "runs.json" and item.get("type") == "blob"), None)
    if entry is None:
        return []
    blob = api("GET", f"repos/{repository}/git/blobs/{entry['sha']}", token)
    if blob.get("encoding") != "base64" or not isinstance(blob.get("content"), str):
        raise ValueError("Pages run registry is not base64 blob data")
    encoded = re.sub(r"[ \t\r\n\f\v]+", "", blob["content"])
    data = base64.b64decode(encoded.encode("ascii"), validate=True)
    if len(data) > 16 * 1024 * 1024:
        raise ValueError("Pages run registry exceeds 16 MiB")
    records = json.loads(data)
    if not isinstance(records, list):
        raise ValueError("Pages run registry must be a list")
    seen = set()
    for record in records:
        if not isinstance(record, dict) or not SHA_RE.fullmatch(str(record.get("sha", ""))) or not str(record.get("pr", "")).isdigit():
            raise ValueError("Pages run registry contains an invalid entry")
        key = (record["sha"], str(record["pr"]))
        if key in seen:
            raise ValueError("Pages run registry contains duplicate commit/PR entries")
        seen.add(key)
    return [{"sha": record["sha"], "pr": str(record["pr"])} for record in records]


def publish_pages(repository: str, branch: str, head_sha: str, pull_request: str, page_url: str, assets: dict[str, bytes], manifest: dict, token: str) -> str:
    if not OWNER_RE.fullmatch(repository) or not SHA_RE.fullmatch(head_sha) or not pull_request.isdigit():
        raise ValueError("invalid repository, PR, or commit identifier for Pages publication")
    page_url = validate_pages_url(page_url)
    ref = quote(f"heads/{branch}", safe="/")
    branch_commit = api("GET", f"repos/{repository}/git/ref/{ref}", token)["object"]["sha"]
    parent = api("GET", f"repos/{repository}/git/commits/{branch_commit}", token)
    tree_sha = parent["tree"]["sha"]
    records = [record for record in _read_registry(repository, tree_sha, token) if (record["sha"], record["pr"]) != (head_sha, str(pull_request))]
    records.append({"sha": head_sha, "pr": str(pull_request)})

    entries = []
    for relative, content in assets.items():
        blob_sha = _blob(repository, content, token)
        entries.append({"path": f"runs/{head_sha}/{relative}", "mode": "100644", "type": "blob", "sha": blob_sha})
    generated = {
        f"runs/{head_sha}/index.html": trusted_index(manifest),
        "runs.json": (json.dumps(records, indent=2) + "\n").encode(),
        "index.html": pages_index(records, page_url),
        f"pulls/{pull_request}/index.html": pull_index(records, str(pull_request), page_url),
    }
    for path, content in generated.items():
        entries.append({"path": path, "mode": "100644", "type": "blob", "sha": _blob(repository, content, token)})
    tree = api("POST", f"repos/{repository}/git/trees", token, {"base_tree": tree_sha, "tree": entries})
    commit = api("POST", f"repos/{repository}/git/commits", token, {
        "message": f"Publish GPUI visual report for {head_sha}", "tree": tree["sha"], "parents": [branch_commit],
    })
    api("PATCH", f"repos/{repository}/git/refs/{ref}", token, {"sha": commit["sha"], "force": False})
    return page_url + "/runs/" + head_sha + "/index.html"


def _metric_pair(checkpoint: dict, prefix: str) -> str:
    p50, p95 = metric(checkpoint, prefix + "_p50_ns"), metric(checkpoint, prefix + "_p95_ns")
    return "n/a" if p50 is None and p95 is None else f"{format_ms(p50)} / {format_ms(p95)}"


def make_comment(repository: str, pr: str, run_id: str, head_sha: str, manifest: dict, page_url: str | None, changes: list[tuple[str, str]], baseline_available: bool) -> str:
    run_url = f"{github_server_url()}/{repository}/actions/runs/{quote(run_id)}"
    lines = [MARKER, f"## GPUI visual report · {head_sha[:12]}", "", f"[Open workflow run]({run_url})"]
    if page_url:
        lines.append(f" · [Open hosted report]({page_url})")
        graph_url = page_url.rsplit("/index.html", 1)[0] + "/metrics.svg"
        lines.append(f"\n\n**Timing graph:** ![Timing graph]({graph_url})")
    else:
        lines.append(" · Visual assets are available from the workflow run artifact.")
    lines.append("")
    if baseline_available:
        lines.append("**Visual comparison:**")
        if changes:
            pixel_keys = {detail.split()[-1] for kind, detail in changes if kind == "pixels_changed"}
            for kind, detail in changes:
                label = {
                    "scenario_added": "Added",
                    "scenario_removed": "Removed",
                    "checkpoint_added": "Added",
                    "checkpoint_removed": "Removed",
                    "scenario_metadata_changed": "Viewport or scenario metadata changed",
                    "checkpoint_metadata_changed": "Checkpoint timeline changed",
                    "pixels_changed": "Pixels changed",
                    "scene_changed": "Scene and pixels changed" if detail.split()[-1] in pixel_keys else "Scene-only change",
                }.get(kind, "Changed")
                lines.append(f"- **{label}:** {markdown_text(detail)}")
        else:
            lines.append("- No checkpoint, scene, timeline, or pixel changes detected.")
    else:
        lines.append("No baseline capture was available; current images are shown without comparison diffs.")
    lines.extend(["", "| Scenario | Checkpoint | Scene build p50 / p95 | CPU render p50 / p95 | Frames | Primitives | Bitmap bytes | GPU memory |", "|---|---|---:|---:|---:|---:|---:|---:|"])
    for scenario in manifest["scenarios"]:
        sid = scenario["id"]
        for checkpoint in scenario["checkpoints"]:
            cid = checkpoint["id"]
            frames, primitives = metric(checkpoint, "frame_count"), metric(checkpoint, "primitive_count")
            bitmap_bytes = metric(checkpoint, "bitmap_storage_bytes")
            gpu_memory = scenario.get("gpu_memory_bytes")
            if not isinstance(gpu_memory, int) or isinstance(gpu_memory, bool) or gpu_memory < 0:
                gpu_memory = None
            lines.append(
                "| " + markdown_text(scenario.get("title", sid)) + " | " + markdown_text(checkpoint.get("name", cid))
                + f" | {_metric_pair(checkpoint, 'scene_build')} | {_metric_pair(checkpoint, 'cpu_render')} | {frames if frames is not None else 'n/a'} | {primitives if primitives is not None else 'n/a'} | {bitmap_bytes if bitmap_bytes is not None else 'n/a'} | {gpu_memory if gpu_memory is not None else 'n/a'} |"
            )
    if page_url:
        image_checkpoints = [
            (scenario, checkpoint)
            for scenario in manifest["scenarios"]
            for checkpoint in scenario["checkpoints"]
            if not baseline_available or checkpoint.get("status") in {"changed", "new"}
        ]
        for scenario, checkpoint in image_checkpoints[:6]:
            lines.extend(["", "**" + markdown_text(scenario.get("title", scenario["id"]))
                + " / " + markdown_text(checkpoint.get("name", checkpoint["id"])) + "**", ""])
            for field, label in (("before_png", "Before"), ("png", "Current"), ("diff_png", "Changes in red")):
                asset = checkpoint.get(field)
                if asset:
                    asset_url = page_url.rsplit("/index.html", 1)[0] + "/" + quote(asset, safe="/")
                    lines.append(f"**{label}:** ![{label} image]({asset_url})")
        if len(image_checkpoints) > 6:
            lines.extend(["", f"{len(image_checkpoints) - 6} more checkpoint images are in the [hosted report]({page_url})."])
    return "\n".join(lines)


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: post_github_report.py <report-directory>", file=sys.stderr)
        return 2
    token = os.environ["GH_TOKEN"]
    repository = os.environ["REPOSITORY"]
    pr = os.environ["PR_NUMBER"]
    head_sha = os.environ["HEAD_SHA"].lower()
    run_id = os.environ["RUN_ID"]
    if not OWNER_RE.fullmatch(repository) or not SHA_RE.fullmatch(head_sha) or not pr.isdigit() or not run_id.isdigit():
        raise ValueError("invalid repository, pull request, run, or commit identifier")
    current = api("GET", f"repos/{repository}/pulls/{pr}", token)
    if current["head"]["sha"].lower() != head_sha:
        print("Pull request head changed while processing; skipping stale report.")
        return 0

    report_path = Path(sys.argv[1])
    manifest, root = load_report(report_path)
    try:
        changes, baseline_available = find_baseline(report_path, manifest, root)
    except (OSError, ValueError, json.JSONDecodeError) as error:
        print(f"::warning::Could not read the baseline report; current captures will still be posted: {error}")
        changes, baseline_available = [], False
    assets = report_assets(manifest, root)
    page_url = None
    branch = os.environ.get("PAGES_BRANCH", "").strip()
    base_url = os.environ.get("PAGES_URL", "").strip()
    if branch and base_url:
        current = api("GET", f"repos/{repository}/pulls/{pr}", token)
        if current["head"]["sha"].lower() != head_sha:
            print("Pull request head changed before report hosting; skipping stale report.")
            return 0
        try:
            page_url = publish_pages(repository, branch, head_sha, pr, base_url, assets, manifest, token)
        except Exception as error:
            print(f"::warning::Could not publish the optional GitHub Pages report: {error}")
    elif branch or base_url:
        print("::warning::Set both GPUI_VISUAL_PAGES_BRANCH and GPUI_VISUAL_PAGES_URL to enable report hosting.")

    current = api("GET", f"repos/{repository}/pulls/{pr}", token)
    if current["head"]["sha"].lower() != head_sha:
        print("Pull request head changed before comment update; skipping stale report.")
        return 0
    body = make_comment(repository, pr, run_id, head_sha, manifest, page_url, changes, baseline_available)
    endpoint = f"repos/{repository}/issues/{pr}/comments"
    comments = []
    for page in range(1, 11):
        batch = api("GET", f"{endpoint}?per_page=100&page={page}", token)
        comments.extend(batch)
        if len(batch) < 100:
            break
    existing = next((comment for comment in comments if comment.get("user", {}).get("type") == "Bot" and MARKER in comment.get("body", "")), None)
    if existing:
        api("PATCH", f"repos/{repository}/issues/comments/{existing['id']}", token, {"body": body})
    else:
        api("POST", endpoint, token, {"body": body})
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as error:
        print(f"visual report publisher: {error}", file=sys.stderr)
        raise SystemExit(1)
