#!/usr/bin/env python3
"""Count committed port src using the repository Syn/Tokei test exclusion."""
import argparse, hashlib, json, pathlib, subprocess, sys, tempfile
repo = pathlib.Path(subprocess.check_output(["git", "rev-parse", "--show-toplevel"], text=True).strip())
sys.path.insert(0, str(repo / "reactivity/tools"))
import inventory
from core_lines import without_tests
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--ref", required=True)
parser.add_argument("--helper", type=pathlib.Path, required=True)
parser.add_argument("--tokei", type=pathlib.Path, required=True)
args = parser.parse_args()
commit = inventory.git("rev-parse", args.ref).strip()
root = "reactivity/ports/hummingbird/src/"
sources = [(p, data, lang) for p, data, lang in inventory.read_sources(commit) if p.startswith(root)]
analysis = inventory.rust_analysis(sources, args.helper)
test_targets, roots, manifests = inventory.cargo_targets(commit)
tests = inventory.resolve_modules(analysis, sources, test_targets, roots)
files = {}
with tempfile.TemporaryDirectory(prefix="hummingbird-lines-") as tmp:
    staging = pathlib.Path(tmp)
    for path, data, language in sources:
        detail = analysis.get(path, {})
        files[path] = {"sha256": hashlib.sha256(data).hexdigest(), "test_only": path in tests,
                       "unclassified": detail.get("unclassified", []), "code_lines": 0}
        if path in tests:
            continue
        content = without_tests(data.decode(), detail["test_ranges"]).encode() if language == "Rust" else data
        destination = staging / path
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(content)
    reports = json.loads(subprocess.check_output([str(args.tokei), "--no-ignore", "--files", "--output", "json", str(staging)], text=True))
    for language, summary in reports.items():
        if language != "Total":
            for report in summary["reports"]:
                path = pathlib.Path(report["name"]).relative_to(staging).as_posix()
                files[path]["code_lines"] = report["stats"]["code"]
print(json.dumps({"source_commit": commit, "scope": "Hummingbird port src including binary and all cfg features; excludes tests/comments/blanks/docs, examples and test targets", "non_test_code_lines": sum(f["code_lines"] for f in files.values()),
"tokei_sha256": hashlib.sha256(args.tokei.read_bytes()).hexdigest(), "helper_sha256": hashlib.sha256(args.helper.read_bytes()).hexdigest(),
"counter_sha256": hashlib.sha256(pathlib.Path(__file__).read_bytes()).hexdigest(), "files": files}, indent=2))
