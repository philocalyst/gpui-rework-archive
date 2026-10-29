"""Verify a documentation/source audit. This is not an implementation test."""
from pathlib import Path
import hashlib
import json
import subprocess

root = Path(__file__).resolve().parent
repo = root.parents[2]
base = "773cd5d4543a130f071a830782b01bbae746c2d6"


def sha(data):
    return hashlib.sha256(data).hexdigest()


manifest = json.loads((root / "MANIFEST.json").read_text())
actual = {
    p.relative_to(root).as_posix()
    for p in root.rglob("*")
    if p.is_file() and p.name != "MANIFEST.json"
}
assert set(manifest) == actual
for name, digest in manifest.items():
    assert sha((root / name).read_bytes()) == digest, name

inputs = json.loads((root / "SOURCE_INPUTS.json").read_text())
assert inputs["source_commit"] == base
assert inputs["kind"] == "source-audit-only-no-new-execution"
for name, entry in inputs["files"].items():
    frozen = (root / "frozen" / name).read_bytes()
    original = subprocess.check_output(["git", "show", f"{base}:{name}"], cwd=repo)
    assert frozen == original == (repo / name).read_bytes(), name
    assert sha(frozen) == entry["sha256"], name
    assert len(frozen.splitlines()) == entry["lines"], name
changed = subprocess.check_output(
    ["git", "diff", "--name-only", base, "--", "reactivity/crates", ".cargo",
     "reactivity/Cargo.toml", "reactivity/Cargo.lock"], cwd=repo
)
assert not changed, changed.decode()
print(f"verified {len(manifest)} dossier files and {len(inputs['files'])} unchanged source files; "
      "design/source audit only; no implementation, execution or timing claim")
