#!/usr/bin/env python3
"""Count physical Rust lines at pinned refs; include tests and vendor honestly."""

import json
import pathlib
import subprocess
import sys

REPO = pathlib.Path(__file__).resolve().parents[2]


def git(*args):
    return subprocess.check_output(
        ["git", "-c", f"safe.directory={REPO}", "-C", str(REPO), *args],
        text=True,
    )


def rust_lines(ref):
    paths = [p for p in git("ls-tree", "-r", "--name-only", ref).splitlines()
             if p.endswith(".rs")]
    groups = {}
    for path in paths:
        group = "/".join(path.split("/")[:2])
        entry = groups.setdefault(group, {"files": 0, "physical_lines": 0})
        entry["files"] += 1
        entry["physical_lines"] += len(git("show", f"{ref}:{path}").splitlines())
    return {
        "commit": git("rev-parse", ref).strip(),
        "rust_files": len(paths),
        "physical_rust_lines": sum(g["physical_lines"] for g in groups.values()),
        "groups": dict(sorted(groups.items())),
    }


def branch_delta(ref):
    base = git("merge-base", "41a42eb96d", ref).strip()
    return {
        "commit": git("rev-parse", ref).strip(),
        "merge_base_with_checkout": base,
        "shortstat_all_files": git("diff", "--shortstat", base, ref).strip(),
        "shortstat_rust_files": git("diff", "--shortstat", base, ref, "--", "*.rs").strip(),
    }


def working_counts():
    """Count experiment/vendor Rust on disk, separately from the old checkout."""
    root = REPO / "reactivity"
    crates = {}
    for path in sorted((root / "crates").rglob("*.rs")):
        parts = path.relative_to(root / "crates").parts
        group = "library" if parts[1] == "src" else (
            "examples" if parts[1] == "examples" else "tests")
        entry = crates.setdefault(parts[0], {})
        entry[group] = entry.get(group, 0) + len(path.read_text().splitlines())
    vendors = {}
    for directory in sorted((root / "vendor").iterdir()):
        if not directory.is_dir():
            continue
        paths = [path for path in directory.rglob("*.rs")
                 if "target" not in path.relative_to(directory).parts]
        vendors[directory.name] = {"rust_files": len(paths), "physical_lines": sum(
            len(path.read_text().splitlines()) for path in paths)}
    return {
        "method": "Physical Rust lines including comments, blanks and embedded tests. Library means src/, not production acceptance. Counts on-disk first-party crates/ and vendor/; excludes target/ and archived original design examples under docs/inputs/.",
        "source_code_head": git("rev-parse", "HEAD").strip(),
        "crates": crates,
        "vendor": vendors,
    }


if sys.argv[1:] == ["--working"]:
    print(json.dumps(working_counts(), indent=2))
    raise SystemExit(0)


print(json.dumps({
    "method": "Physical lines, including blank lines, comments, generated Rust and tests. Not semantic SLOC. Deltas are branch-to-merge-base, not feature-attributable LOC.",
    "baseline": rust_lines("41a42eb96d"),
    "branches": {ref: branch_delta(ref) for ref in (
        "origin/inspector", "codex/element-coordinate-spaces", "testing",
        "upstream/reflection", "upstream/selectors",
    )},
}, indent=2))
