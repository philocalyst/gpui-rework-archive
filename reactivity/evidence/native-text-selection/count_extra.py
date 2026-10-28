#!/usr/bin/env python3
"""Charge imported library source and evidence tooling separately from core."""
import hashlib
import json
import pathlib
import subprocess
import sys
import tempfile

repo = pathlib.Path(__file__).resolve().parents[2]
sys.path.insert(0, str(repo / "tools"))
import inventory
import core_lines

helper, tokei = map(pathlib.Path, sys.argv[1:3])
packages = ("accesskit", "accesskit_consumer", "accesskit_macos", "accesskit_atspi_common", "accesskit_unix")
groups = {name: list((repo / "vendor" / name / "src").rglob("*.rs")) for name in packages}
groups["evidence_tooling"] = [pathlib.Path(__file__), pathlib.Path(__file__).parent / "codec-probe/src/main.rs"]
sources = [(str(p), p.read_bytes(), "Rust" if p.suffix == ".rs" else "Python") for paths in groups.values() for p in paths]
analysis = inventory.rust_analysis(sources, helper)
tests = inventory.resolve_modules(analysis, sources, (), [str(p) for paths in groups.values() for p in paths if p.name == "lib.rs"])
result = {"helper_sha256": hashlib.sha256(helper.read_bytes()).hexdigest(), "tokei_sha256": hashlib.sha256(tokei.read_bytes()).hexdigest(), "groups": {}}
for name, paths in groups.items():
    with tempfile.TemporaryDirectory() as temporary:
        for i, path in enumerate(paths):
            if str(path) in tests:
                continue
            content = path.read_text()
            if path.suffix == ".rs":
                content = core_lines.without_tests(content, analysis[str(path)]["test_ranges"])
            (pathlib.Path(temporary) / f"{i}{path.suffix}").write_text(content)
        counts = json.loads(subprocess.check_output([str(tokei), "--files", "--output", "json", temporary], text=True))
        result["groups"][name] = {"shipping_non_test_code_lines": sum(report["stats"]["code"] for language, data in counts.items() if language != "Total" for report in data["reports"]), "files": {str(p.relative_to(repo)): hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}}
print(json.dumps(result, indent=2))
