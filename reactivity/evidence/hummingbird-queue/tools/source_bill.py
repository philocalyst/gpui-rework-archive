#!/usr/bin/env python3
"""Count immutable app Rust separately from tests with the existing Syn helper."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

sys.path.insert(0, str(Path("reactivity/tools").resolve()))
from core_lines import without_tests

HELPER = Path("/tmp/gpui-checkbox-inventory-target/debug/inventory-rust")
TOKEI = Path("/nix/store/4m90mv0fyihsdrnidw8gkgmx6zvd5vqm-tokei-15.0.0/bin/tokei")
ROOT = "reactivity/ports/hummingbird/"


def count(ref):
    paths = subprocess.check_output(["git", "ls-tree", "-r", "--name-only", ref, ROOT]).decode().splitlines()
    inputs = []
    for path in paths:
        if path.endswith(".rs") and (path.startswith(ROOT + "src/") or path.startswith(ROOT + "tests/")):
            text = subprocess.check_output(["git", "show", f"{ref}:{path}"]).decode()
            inputs.append({"path": path, "text": text})
    output = subprocess.check_output([str(HELPER)], input="".join(json.dumps(row) + "\n" for row in inputs).encode())
    analyses = {row["path"]: row for row in map(json.loads, output.splitlines())}
    entries = {}
    with tempfile.TemporaryDirectory(prefix="hummingbird-source-bill-") as directory:
        staging = Path(directory)
        for row in inputs:
            path, text = row["path"], row["text"]
            analysis = analyses[path]
            tests = "/tests/" in path or analysis.get("file_test_only", False)
            entry = {"sha256": hashlib.sha256(text.encode()).hexdigest(), "physical_lines": len(text.splitlines()),
                     "external_test": tests, "test_ranges": analysis["test_ranges"], "unclassified": analysis["unclassified"]}
            entries[path] = entry
            for group, content in (("all", text), ("shipping", "" if tests else without_tests(text, analysis["test_ranges"]))):
                target = staging / group / path
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_text(content)
        summary = json.loads(subprocess.check_output([str(TOKEI), "--no-ignore", "--files", "--output", "json", str(staging)]))
        for report in summary["Rust"]["reports"]:
            relative = Path(report["name"]).relative_to(staging)
            entries[str(Path(*relative.parts[1:]))][relative.parts[0] + "_code_lines"] = report["stats"]["code"]
    for row in entries.values():
        row.setdefault("shipping_code_lines", 0)
        row["test_code_lines"] = row["all_code_lines"] - row["shipping_code_lines"]
    return {"commit": subprocess.check_output(["git", "rev-parse", ref]).decode().strip(), "files": entries,
            "shipping_code_lines": sum(row["shipping_code_lines"] for row in entries.values()),
            "test_code_lines": sum(row["test_code_lines"] for row in entries.values())}


if __name__ == "__main__":
    snapshots = [count(ref) for ref in sys.argv[1:]]
    print(json.dumps({"scope": "Committed app src/ and tests/ Rust; shipping excludes AST test spans and external tests. Copied, uncompiled upstream reference source is charged separately. No macro expansion; ambiguity remains charged.",
                      "helper_sha256": hashlib.sha256(HELPER.read_bytes()).hexdigest(),
                      "tokei_sha256": hashlib.sha256(TOKEI.read_bytes()).hexdigest(), "snapshots": snapshots}, indent=2))
