#!/usr/bin/env python3
"""Publish validated captures and update one PR comment on GitHub or GHES."""

from __future__ import annotations

import base64
import json
import os
from pathlib import Path
import re
import sys
from urllib.parse import quote

from report_support import (
    comparison_summary,
    checkpoint_preview_text,
    preview_checkpoints,
    load_report,
    markdown_metrics_table,
    markdown_change_summary,
    markdown_text,
    pages_index,
    pull_index,
    report_assets,
    trusted_index,
    validate_records,
    validate_site_base as validate_pages_url,
    validate_report_head,
    json_request,
)

MARKER = "<!-- gpui-visual-test-report -->"
OWNER_RE = re.compile(r"^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")
SHA_RE = re.compile(r"^[0-9a-f]{40}$")


def github_api_url() -> str:
    return os.environ.get("GITHUB_API_URL", "https://api.github.com").rstrip("/")


def github_server_url() -> str:
    return os.environ.get("GITHUB_SERVER_URL", "https://github.com").rstrip("/")


def api(method: str, endpoint: str, token: str, payload: object | None = None):
    url = github_api_url() + "/" + endpoint.lstrip("/")
    return json_request(method, url, {
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {token}",
        "X-GitHub-Api-Version": "2022-11-28",
    }, payload, api_name=f"GitHub API {endpoint}")


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
    return validate_records(records)


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
    blob_shas: dict[bytes, str] = {}

    def add_blob(path: str, content: bytes) -> None:
        blob_sha = blob_shas.get(content)
        if blob_sha is None:
            blob_sha = _blob(repository, content, token)
            blob_shas[content] = blob_sha
        entries.append({"path": path, "mode": "100644", "type": "blob", "sha": blob_sha})

    for relative, content in assets.items():
        add_blob(f"runs/{head_sha}/{relative}", content)
    generated = {
        f"runs/{head_sha}/index.html": trusted_index(manifest),
        "runs.json": (json.dumps(records, indent=2) + "\n").encode(),
        "index.html": pages_index(records, page_url),
        f"pulls/{pull_request}/index.html": pull_index(records, str(pull_request), page_url),
    }
    for path, content in generated.items():
        add_blob(path, content)
    tree = api("POST", f"repos/{repository}/git/trees", token, {"base_tree": tree_sha, "tree": entries})
    commit = api("POST", f"repos/{repository}/git/commits", token, {
        "message": f"Publish GPUI visual report for {head_sha}", "tree": tree["sha"], "parents": [branch_commit],
    })
    api("PATCH", f"repos/{repository}/git/refs/{ref}", token, {"sha": commit["sha"], "force": False})
    return page_url + "/runs/" + head_sha + "/index.html"


def make_comment(repository: str, pr: str, run_id: str, head_sha: str, manifest: dict, page_url: str | None, changes: list[dict], baseline_available: bool) -> str:
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
            lines.append(markdown_change_summary(changes))
        else:
            lines.append("- No checkpoint, scene, timeline, or pixel changes detected.")
    else:
        lines.append("No baseline capture was available; current images are shown without comparison diffs.")
    lines.extend(["", markdown_metrics_table(manifest, limit=20)])
    if page_url:
        image_checkpoints = preview_checkpoints(manifest, baseline_available)
        for scenario, checkpoint in image_checkpoints[:6]:
            lines.extend(["", "**" + markdown_text(scenario.get("title", scenario["id"]))
                + " / " + markdown_text(checkpoint.get("name", checkpoint["id"])) + "**", ""])
            stats = checkpoint_preview_text(checkpoint)
            if stats:
                lines.append(stats)
            for field, label in (("before_png", "Before"), ("png", "Current"), ("diff_png", "Changes in red"), ("heatmap_png", "Magnitude heatmap")):
                asset = checkpoint.get(field)
                if asset:
                    asset_url = page_url.rsplit("/index.html", 1)[0] + "/" + quote(asset, safe="/")
                    lines.append(f"**{label}:** ![{label} image]({asset_url})")
            native = checkpoint.get("native")
            if native:
                lines.append("")
                for field, label in (("png", "Native GPU replay (diagnostic)"), ("diff_png", "Native minus CPU (diagnostic difference)"), ("heatmap_png", "Native visible magnitude heatmap")):
                    asset = native.get(field)
                    if asset:
                        asset_url = page_url.rsplit("/index.html", 1)[0] + "/" + quote(asset, safe="/")
                        lines.append(f"**{label}:** ![{label} image]({asset_url})")
            motion = checkpoint.get("motion")
            if motion and motion["difference"]["changed_pixels"] > 0:
                for field, label in (("diff_png", "Transition changes in red (previous → current)"),
                                     ("heatmap_png", "Transition magnitude heatmap (previous → current)")):
                    asset = motion.get(field)
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
    validate_report_head(manifest, current["head"]["sha"])
    changes, baseline_available = comparison_summary(manifest)
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
