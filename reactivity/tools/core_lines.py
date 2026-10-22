#!/usr/bin/env python3
"""Count committed shipping library code, excluding tests, comments and blanks.

Syn removes known Rust test syntax; Tokei classifies the remaining source.
Documentation's embedded examples are not added back as production code.
"""
import argparse
import hashlib
import json
import pathlib
import shutil
import subprocess
import tempfile

import inventory


LIBRARIES = ("canvas", "core", "gpui", "gpu", "host", "state")


def without_tests(text, ranges):
    lines = text.splitlines(keepends=True)
    for start_line, start_column, end_line, end_column in ranges:
        for number in range(start_line, end_line + 1):
            line = lines[number - 1]
            start = start_column if number == start_line else 0
            end = end_column if number == end_line else len(line.rstrip("\r\n"))
            lines[number - 1] = line[:start] + " " * (end - start) + line[end:]
    return "".join(lines)


def count(ref, original, helper, tokei):
    commit = inventory.git("rev-parse", ref).strip()
    roots = (["crates/gpui/src/"] if original else
             [f"reactivity/crates/{name}/src/" for name in LIBRARIES])
    sources = [(path, data, language) for path, data, language in inventory.read_sources(commit)
               if path.startswith(tuple(roots))]
    analysis = inventory.rust_analysis(sources, helper)
    test_targets, crate_roots, manifests = inventory.cargo_targets(commit)
    tests = inventory.resolve_modules(analysis, sources, test_targets, crate_roots)
    entries = {}
    with tempfile.TemporaryDirectory(prefix="gpui-core-lines-") as temporary:
        staging = pathlib.Path(temporary)
        for path, data, language in sources:
            details = analysis.get(path, {})
            entries[path] = {"source_sha256": hashlib.sha256(data).hexdigest(),
                             "test_only": path in tests,
                             "unclassified": details.get("unclassified", [])}
            if path in tests:
                entries[path]["code_lines"] = 0
                continue
            content = (without_tests(data.decode(), details["test_ranges"]).encode()
                       if language == "Rust" else data)
            destination = staging / path
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_bytes(content)
        output = json.loads(subprocess.check_output(
            [str(tokei), "--no-ignore", "--files", "--output", "json", str(staging)], text=True))
        for language, summary in output.items():
            if language == "Total":
                continue
            for report in summary["reports"]:
                path = pathlib.Path(report["name"]).relative_to(staging).as_posix()
                # Tokei's Total includes fenced documentation examples. Only
                # each actual source report's own code belongs to this ledger.
                entries[path]["code_lines"] = report["stats"]["code"]
    return {"source_commit": commit, "roots": roots,
            "scope": "original GPUI crate" if original else "six shipping first-party libraries",
            "core_non_test_code_lines": sum(row["code_lines"] for row in entries.values()),
            "excluded": "tests, comments, blanks, documentation examples, labs, application examples, benchmarks, tools, evidence, vendors",
            "uncertainty": "Unexpanded macro and conditional-import ambiguities stay charged; inspect per-file diagnostics.",
            "tokei_version": subprocess.check_output([str(tokei), "--version"], text=True).strip(),
            "tokei_sha256": hashlib.sha256(tokei.read_bytes()).hexdigest(),
            "rust_helper_sha256": hashlib.sha256(helper.read_bytes()).hexdigest(),
            "counter_sha256": hashlib.sha256(pathlib.Path(__file__).read_bytes()).hexdigest(),
            "inventory_sha256": hashlib.sha256(pathlib.Path(inventory.__file__).read_bytes()).hexdigest(),
            "cargo_manifests_sha256": manifests,
            "files": entries}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ref", default="HEAD")
    parser.add_argument("--original", action="store_true")
    parser.add_argument("--helper", type=pathlib.Path, required=True)
    parser.add_argument("--tokei", type=pathlib.Path, default=shutil.which("tokei"))
    args = parser.parse_args()
    if args.tokei is None:
        parser.error("provide --tokei /path/to/tokei")
    print(json.dumps(count(args.ref, args.original, args.helper, pathlib.Path(args.tokei)), indent=2))


if __name__ == "__main__":
    main()
