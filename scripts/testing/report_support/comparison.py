"""Interpret the authoritative typed comparison results."""
from __future__ import annotations
from .common import CHANGE_LABELS, CHECKPOINT_CHANGE_KINDS, ID_RE
def comparison_summary(manifest: dict) -> tuple[list[dict], bool]:
    """Validate and format the comparison already recorded by the Rust harness."""
    raw_changes = manifest.get("changes")
    if not isinstance(raw_changes, list):
        raise ValueError("manifest changes must be a list")
    statuses = []
    for scenario in manifest.get("scenarios", []):
        statuses.append(scenario["status"])
        statuses.extend(checkpoint["status"] for checkpoint in scenario["checkpoints"])

    normalized = []
    pixels_changed = {
        (change.get("scenario_id"), change.get("checkpoint_id"))
        for change in raw_changes
        if isinstance(change, dict)
        and change.get("kind") == "pixels_changed"
        and isinstance(change.get("scenario_id"), str)
        and isinstance(change.get("checkpoint_id"), str)
    }
    for change in raw_changes:
        if not isinstance(change, dict):
            raise ValueError("manifest change must be an object")
        kind, scenario_id = change.get("kind"), change.get("scenario_id")
        checkpoint_id, detail = change.get("checkpoint_id"), change.get("detail")
        if not isinstance(kind, str) or (kind not in CHANGE_LABELS and kind != "scene_changed"):
            raise ValueError(f"manifest change has an unknown kind: {kind!r}")
        if not isinstance(scenario_id, str) or not ID_RE.fullmatch(scenario_id):
            raise ValueError("manifest change has an invalid scenario_id")
        if not isinstance(detail, str):
            raise ValueError("manifest change detail must be text")
        if kind in CHECKPOINT_CHANGE_KINDS:
            if not isinstance(checkpoint_id, str) or not ID_RE.fullmatch(checkpoint_id):
                raise ValueError("checkpoint change has an invalid checkpoint_id")
            subject = f"{scenario_id}/{checkpoint_id}"
        else:
            if checkpoint_id is not None:
                raise ValueError("scenario change cannot include a checkpoint_id")
            subject = scenario_id
        label = CHANGE_LABELS.get(kind)
        if kind == "scene_changed":
            label = "Scene and pixels changed" if (scenario_id, checkpoint_id) in pixels_changed else "Scene-only change"
        normalized.append({
            "kind": kind,
            "label": label,
            "scenario_id": scenario_id,
            "checkpoint_id": checkpoint_id,
            "subject": subject,
            "detail": detail,
        })
    baseline_available = bool(raw_changes) or any(status != "baseline_unavailable" for status in statuses)
    return normalized, baseline_available
