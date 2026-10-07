"""Small portable report fixtures shared by forge contract tests."""
import base64
import copy
import gzip
import json
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch
from xml.parsers import expat

import post_github_report as github_report
import post_gitlab_comment as gitlab_report
import report_support as support

PNG = b"\x89PNG\r\n\x1a\nfixture"


def fixture_manifest(*, title="Gallery", metrics=None, status="unchanged", pixel=False, scene=False, changes=None):
    return {
        "schema_version": 1,
        "backend": "cpu",
        "environment": {"renderer": "gpui-ce-cpu", "font_pack": "bundled", "git_sha": None},
        "changes": list(changes or []),
        "scenarios": [{
            "id": "gallery", "title": title, "viewport": {"width": 320, "height": 200, "scale_factor": 1.0},
            "status": status,
            "checkpoints": [{
                "id": "initial", "name": "Initial", "time_ns": 0, "status": status,
                "pixels_changed": pixel, "scene_changed": scene, "metadata_changed": False,
                "scene_json": "gallery/initial.scene.json", "png": "gallery/initial.png",
                "before_png": "gallery/initial.before.png" if status == "changed" else None,
                "diff_png": "gallery/initial.diff.png" if status == "changed" else None,
                "metrics": metrics,
            }],
        }],
    }


def add_native_replay(manifest):
    manifest["native_replay"] = {
        "adapter": "adapter <trusted>", "driver": "driver &amp; info", "backend": "Vulkan", "device_type": "Discrete GPU",
        "timestamp_reason": None,
    }
    manifest["scenarios"][0]["checkpoints"][0]["native"] = {
        "png": "gallery/initial.native.png",
        "diff_png": "gallery/initial.native.diff.png",
        "heatmap_png": "gallery/initial.native.heatmap.png",
        "metrics": {
            "samples": 4,
            "encode_submit_completion": {"p50_ns": 1_000_000, "p95_ns": 1_200_000, "p99_ns": 1_300_000},
            "gpu": {"p50_ns": 800_000, "p95_ns": 900_000, "p99_ns": 1_000_000},
            "tracked_owned_bytes": 8192, "device_allocated_bytes": None,
            "allocation_scope": "per checkpoint", "device_allocation_scope": None,
            "allocation_reason": "allocator unavailable",
        },
        "difference": {
            "changed_pixels": 12, "total_pixels": 64000,
            "max_channel_error": 8, "mean_channel_error": 0.125,
            "bounds": {"x": 2, "y": 3, "width": 4, "height": 5},
            "visible": {"changed_pixels": 8, "max_channel_error": 6.5, "mean_channel_error": 0.125},
            "size_changed": False,
        },
    }
    return manifest


def add_platform_checks(manifest):
    manifest["platform_checks"] = {
        "schema_version": 1,
        "platform": "Linux <runner>", "status": "passed",
        "capabilities": {
            "native_visibility": True, "focus_handle": True, "native_render_capture": True,
            "resize_callback": True, "two_window_close": False,
        },
        "events": [{"name": "window <visible>", "polls": 3, "elapsed_ms": 12}],
        "frame": {
            "render_count": 2, "quads": 3, "monochrome_sprites": 1, "subpixel_sprites": 1,
            "polychrome_sprites": 1, "capture_width": 320, "capture_height": 200, "painted_pixels": 12000,
        },
        "resize": {"callback_count": 1, "width": 640.0, "height": 480.0},
        "errors": [],
    }
    return manifest


def write_report(root: Path, manifest: dict, *, png=PNG, scene=b'{"scene":1}') -> Path:
    root.mkdir(parents=True, exist_ok=True)
    for scenario in manifest["scenarios"]:
        for checkpoint in scenario["checkpoints"]:
            for field in ("png", "before_png", "diff_png", "heatmap_png"):
                if checkpoint.get(field):
                    path = root / checkpoint[field]
                    path.parent.mkdir(parents=True, exist_ok=True)
                    path.write_bytes(png)
            path = root / checkpoint["scene_json"]
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(scene)
            for data, fields in ((checkpoint.get("native"), ("png", "diff_png", "heatmap_png")),
                                 (checkpoint.get("motion"), ("diff_png", "heatmap_png"))):
                if data:
                    for field in fields:
                        if data.get(field):
                            path = root / data[field]
                            path.parent.mkdir(parents=True, exist_ok=True)
                            path.write_bytes(png)
    (root / "manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
    return root


class Response:
    def __init__(self, payload: bytes):
        self.payload = payload

    def __enter__(self):
        return self

    def __exit__(self, *args):
        return False

    def read(self):
        return self.payload


