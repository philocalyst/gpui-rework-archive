"""Read and validate a portable report manifest."""
from __future__ import annotations
import json
from pathlib import Path
import re
from .common import ID_RE, _nonnegative_int, _validate_image_difference, _validate_status_fields, validate_relative
from .comparison import comparison_summary
from .motion import _validate_motion
from .native import _validate_native_checkpoint, _validate_native_replay, _validate_platform_checks
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
    _validate_native_replay(manifest)
    _validate_platform_checks(manifest.get("platform_checks"))
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
        for checkpoint_index, checkpoint in enumerate(checkpoints):
            if not isinstance(checkpoint, dict):
                raise ValueError(f"scenario {sid} checkpoint must be an object")
            cid = checkpoint.get("id")
            if not isinstance(cid, str) or not ID_RE.fullmatch(cid) or (sid, cid) in checkpoint_ids:
                raise ValueError(f"scenario {sid} has an invalid or duplicate checkpoint id: {cid!r}")
            checkpoint_ids.add((sid, cid))
            _validate_status_fields(checkpoint, f"checkpoint {sid}/{cid}")
            if "time_ns" in checkpoint and (not isinstance(checkpoint["time_ns"], int) or isinstance(checkpoint["time_ns"], bool) or checkpoint["time_ns"] < 0):
                raise ValueError(f"checkpoint {sid}/{cid} time_ns must be a non-negative integer")
            if "before_time_ns" in checkpoint and checkpoint["before_time_ns"] is not None:
                _nonnegative_int(checkpoint["before_time_ns"], f"checkpoint {sid}/{cid} before_time_ns")
            for field in ("png", "scene_json", "before_png", "diff_png", "heatmap_png"):
                value = checkpoint.get(field)
                if field in ("png", "scene_json") and value is None:
                    raise ValueError(f"checkpoint {sid}/{cid} is missing {field}")
                if value is not None:
                    suffix = (".png",) if field.endswith("png") else (".json", ".json.gz")
                    relative = validate_relative(value, suffix)
                    if relative in referenced_paths:
                        raise ValueError(f"report asset is referenced more than once: {relative}")
                    referenced_paths.add(relative)
                    checkpoint[field] = relative
            expected_heatmap = f"{sid}/{cid}.heatmap.png"
            if checkpoint.get("heatmap_png") is not None and checkpoint["heatmap_png"] != expected_heatmap:
                raise ValueError(f"checkpoint {sid}/{cid} heatmap_png must be {expected_heatmap!r}")
            if checkpoint.get("difference") is not None:
                _validate_image_difference(checkpoint["difference"], f"checkpoint {sid}/{cid}")
            if checkpoint.get("motion") is not None:
                _validate_motion(
                    checkpoint["motion"],
                    checkpoints[checkpoint_index - 1] if checkpoint_index > 0 else None,
                    checkpoint, f"checkpoint {sid}/{cid}", sid, referenced_paths,
                )
            if checkpoint.get("heatmap_png") is not None and checkpoint.get("difference") is None:
                raise ValueError(f"checkpoint {sid}/{cid} heatmap_png requires difference statistics")
            if checkpoint.get("native") is not None:
                if manifest.get("native_replay") is None:
                    raise ValueError(f"checkpoint {sid}/{cid} has native data without native_replay metadata")
                _validate_native_checkpoint(checkpoint["native"], scenario, checkpoint, manifest["native_replay"], referenced_paths)
    comparison_summary(manifest)
    return manifest, report_root

def validate_report_head(manifest: dict, expected_head: str) -> None:
    """Require embedded capture provenance to match the forge-verified head."""
    if not isinstance(expected_head, str) or not re.fullmatch(r"[0-9a-fA-F]{40}", expected_head):
        raise ValueError("expected publication head must be a full commit SHA")
    recorded = (manifest.get("environment") or {}).get("git_sha")
    if recorded is None:
        return
    if not isinstance(recorded, str) or not re.fullmatch(r"[0-9a-fA-F]{40}", recorded):
        raise ValueError("manifest environment.git_sha must be a full commit SHA")
    if recorded.lower() != expected_head.lower():
        raise ValueError("manifest environment.git_sha does not match the expected publication head")
