"""Independent host-receipt audit; timestamps do not establish scanout or content.

Policy v1 was fixed before inspecting the primary animation captures. The
original runner and its acceptance flags remain unchanged. In particular, this
audit does not turn a complete capture into evidence that every tick was visible.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
from pathlib import Path


POLICY = {
    "version": 1,
    "scheduled_hz": 60,
    "endpoint_allowance_frames": 2,
    "frame_count_rule": "floor(requested_seconds * 60) - 2",
    "external_duration_rule": "at least the requested duration",
    "gap_rule": "gaps longer than two periods are reported, not hidden by medians",
    "eligibility_scope": "host receipt count and recording integrity",
    "limits": [
        "First pipe receipt aligns clocks approximately; its delay is unknown.",
        "Backend draw/submission boundaries differ and are retained separately.",
        "Receipts carry no presented source revision or drawable content hash.",
        "Counts do not prove every tick visible, physical GPU use, or scanout.",
    ],
}
NANOSECONDS = 1_000_000_000


def integer(value):
    return type(value) is int and value >= 0


def timestamps(value):
    return isinstance(value, list) and all(integer(item) for item in value)


def audit_animation(row):
    if row.get("mode") != "animation":
        return {"status": "not-applicable", "eligible": True}
    errors = []
    duration = row.get("measurement_requested_duration_s")
    if (type(duration) not in (int, float) or duration <= 0 or duration > 3600
            or not math.isfinite(duration)):
        return {"status": "invalid-evidence", "eligible": False,
                "errors": ["missing or invalid requested duration"]}
    requested_ns = round(duration * NANOSECONDS)
    expected = math.floor(duration * POLICY["scheduled_hz"])
    minimum = max(0, expected - POLICY["endpoint_allowance_frames"])
    raw = row.get("present_frame_times_elapsed_ns")
    window = row.get("present_measurement_window_elapsed_ns")
    observed = row.get("present_frame_times_in_measurement_window_ns")
    if not timestamps(raw) or not raw:
        errors.append("missing or invalid full receipt timestamps")
    elif any(right <= left for left, right in zip(raw, raw[1:])):
        errors.append("receipt timestamps are not globally unique and strictly increasing")
    if not timestamps(window) or len(window) != 2 or window[1] - window[0] != requested_ns:
        errors.append("internal measurement window does not equal the requested duration")
    if not timestamps(observed):
        errors.append("missing or invalid recorded measurement subset")
    if row.get("present_observer_overflow") != 0 or type(row.get("present_observer_overflow")) is not int:
        errors.append("observer overflow is nonzero or unproven")
    first = row.get("first_present_internal_elapsed_ns")
    if not integer(first) or (timestamps(raw) and raw and raw[0] != first):
        errors.append("first receipt differs from the first-presentation epoch")
    start = row.get("measurement_start_monotonic_ns")
    end = row.get("measurement_end_monotonic_ns")
    if not integer(start) or not integer(end) or end - start < requested_ns:
        errors.append("external measurement ended before the requested duration")
    receipt = row.get("first_present_internal_pipe_receipt_monotonic_ns")
    if (not integer(first) or not integer(start) or not integer(receipt)
            or start < receipt or not timestamps(window) or len(window) != 2
            or window[0] != first + start - receipt):
        errors.append("internal window does not match the recorded pipe-clock alignment")
    count = row.get("present_frame_count")
    computed = None
    if timestamps(raw) and timestamps(window) and len(window) == 2:
        computed = [time for time in raw if window[0] <= time <= window[1]]
        if computed != observed:
            errors.append("recorded measurement subset differs from full receipts")
        if not integer(count) or count != len(computed):
            errors.append("recorded frame count differs from full receipts")
        if len(computed) < minimum:
            errors.append("too few host receipts for the scheduled animation")
    gaps = []
    leading = trailing = None
    if computed and timestamps(window) and len(window) == 2:
        gaps = [right - left for left, right in zip(computed, computed[1:])]
        leading = computed[0] - window[0]
        trailing = window[1] - computed[-1]
    hz = POLICY["scheduled_hz"]
    # One nanosecond accounts for representing a rational period as integers.
    long_gaps = [gap for gap in gaps if gap * hz > 2 * NANOSECONDS + hz]
    return {
        "status": "pass" if not errors else "fail",
        "eligible": not errors,
        "errors": errors,
        "scheduled_frames": expected,
        "minimum_host_receipts": minimum,
        "observed_host_receipts": len(computed) if computed is not None else None,
        "receipt_count_ratio": len(computed) / expected if computed is not None and expected else None,
        "extra_receipts": max(0, len(computed) - expected) if computed is not None else None,
        "maximum_internal_gap_ns": max(gaps) if gaps else None,
        "gaps_longer_than_two_periods": len(long_gaps),
        "long_gap_ns": long_gaps,
        "leading_edge_gap_ns": leading,
        "trailing_edge_gap_ns": trailing,
        "cadence_warning": bool(long_gaps),
        "every_tick_visible": "not-established",
        "physical_display_smoothness": "unsupported",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    raw = args.results.read_bytes()
    rows = [json.loads(line) for line in raw.splitlines() if line.strip()]
    cells = [{"variant": row.get("variant"), "mode": row.get("mode"),
              "repeat": row.get("repeat"), "audit": audit_animation(row)} for row in rows]
    report = {
        "policy": POLICY,
        "audit_source_sha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        "input_sha256": hashlib.sha256(raw).hexdigest(),
        "input_bytes": len(raw),
        "original_results_modified": False,
        "cells": cells,
    }
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    return 0 if all(cell["audit"]["eligible"] for cell in cells) else 1


if __name__ == "__main__":
    raise SystemExit(main())
