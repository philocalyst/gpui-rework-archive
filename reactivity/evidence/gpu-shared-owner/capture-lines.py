"""Count this pinned GPU source scope with Syn test spans and Tokei 15."""
import hashlib
import importlib.util
import json
import subprocess
import tempfile
from pathlib import Path

OUT = Path(__file__).resolve().parent
REPO = OUT.parents[2]
HELPER = Path("/tmp/gpui-inventory-sol-target/release/inventory-rust")
TOKEI = "/nix/store/4m90mv0fyihsdrnidw8gkgmx6zvd5vqm-tokei-15.0.0/bin/tokei"
spec = importlib.util.spec_from_file_location("inventory", REPO / "reactivity/tools/inventory.py")
inventory = importlib.util.module_from_spec(spec)
spec.loader.exec_module(inventory)


def git(*args):
    return subprocess.check_output(["git", "-C", REPO, *args])


rows = {}
for label, ref in (("baseline", "7f83fbc110"), ("final", (OUT / "final/source.txt").read_text().strip())):
    paths = git("ls-tree", "-r", "--name-only", ref, "--", "reactivity/crates/gpu/src").decode().splitlines()
    sources = [(path, git("show", f"{ref}:{path}"), "Rust") for path in paths if path.endswith(".rs")]
    analyses = inventory.rust_analysis(sources, HELPER)
    (OUT / f"{label}-source-analysis.json").write_text(json.dumps(analyses, indent=2) + "\n")
    physical = excluded = 0
    with tempfile.TemporaryDirectory(prefix="gpu-owner-lines-") as temp:
        for path, content, _ in sources:
            lines = content.decode().splitlines(keepends=True)
            physical += len(lines)
            omitted = set()
            for start, column, end, end_column in analyses[path].get("test_ranges", []):
                for number in range(start, end + 1):
                    line = lines[number - 1]
                    prefix = line[:column] if number == start else ""
                    suffix = line[end_column:] if number == end else ""
                    if not prefix.strip() and not suffix.strip():
                        omitted.add(number)
            assert len(omitted) == inventory.excluded_test_lines(content, analyses[path])
            excluded += len(omitted)
            dest = Path(temp) / path
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_text("".join("\n" if number in omitted else line for number, line in enumerate(lines, 1)))
        report = json.loads(subprocess.check_output([TOKEI, "--output", "json", temp], text=True))
    rows[label] = {"ref": git("rev-parse", ref).decode().strip(), "physical_gpu_src": physical,
                   "known_test_lines": excluded, "non_test_physical": physical - excluded,
                   "non_test_comment_free_code": report["Rust"]["code"]}
rows["tools"] = {"inventory_helper": str(HELPER), "inventory_helper_sha256": hashlib.sha256(HELPER.read_bytes()).hexdigest(),
                 "inventory_python_sha256": hashlib.sha256((REPO / "reactivity/tools/inventory.py").read_bytes()).hexdigest(),
                 "tokei": TOKEI, "tokei_version": subprocess.check_output([TOKEI, "--version"], text=True).strip(),
                 "scope": "GPU/src Rust only; blank/comments/doc comments and known AST test lines excluded from code. Fixtures/tests/evidence separate."}
(OUT / "source-lines.json").write_text(json.dumps(rows, indent=2) + "\n")
