#!/usr/bin/env python3
"""Instrument exact private copies; the ordinary Canvas client stays unchanged."""
from pathlib import Path
import argparse
import difflib
import hashlib
import json
import subprocess
import sys

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--repo", type=Path, required=True)
parser.add_argument("--ref", required=True)
parser.add_argument("--output", type=Path, required=True)
args = parser.parse_args()
args.output.mkdir(exist_ok=False)
parley = args.output / "parley"
subprocess.run([sys.executable, str(Path(__file__).with_name("prepare.py")),
                "--repo", str(args.repo), "--ref", args.ref, "--output", str(parley)], check=True)
before = {}


def edit(name, old, new):
    path = parley / name
    text = path.read_text()
    before.setdefault(name, text)
    assert text.count(old) == 1, (name, old)
    path.write_text(text.replace(old, new, 1))


edit("src/editing/geometry.rs", ") -> Option<ControlFlow<E>> {\n        if layout.data.text_len",
     ') -> Option<ControlFlow<E>> {\n        std::eprintln!("CENSUS_STREAM_BEGIN bytes={}", layout.data.text_len);\n        if layout.data.text_len')
path = parley / "src/editing/geometry.rs"
text = path.read_text()
start = text.index("        Some(visit_source_pairs(")
end = text.index("\n    }\n\n    pub fn new", start)
body = text[start:end]
assert body.endswith("        ))")
body = body.replace("        Some(", "        let census_result = Some(", 1)
path.write_text(text[:start] + body + ';\n        std::eprintln!("CENSUS_STREAM_END");\n        census_result' + text[end:])
edit("src/editing/geometry.rs",
     "fn direct_pair<B: Brush>(layout: &Layout<B>, byte: usize, width: f32) -> Option<[BoundingBox; 2]> {",
     'fn direct_pair<B: Brush>(layout: &Layout<B>, byte: usize, width: f32) -> Option<[BoundingBox; 2]> {\n    std::eprintln!("CENSUS_DIRECT_PAIR");')
if "fn cached_pair" in path.read_text():
    edit("src/editing/geometry.rs", "    let downstream = next.and_then(|entry| entry.path.cluster(layout));",
         '    std::eprintln!("CENSUS_CACHED_PAIR");\n    let downstream = next.and_then(|entry| entry.path.cluster(layout));')
edit("src/editing/cursor.rs",
     "    pub fn geometry<B: Brush>(&self, layout: &Layout<B>, width: f32) -> BoundingBox {",
     '    pub fn geometry<B: Brush>(&self, layout: &Layout<B>, width: f32) -> BoundingBox {\n        std::eprintln!("CENSUS_CURSOR_GEOMETRY");')
edit("src/layout/cluster.rs", "    pub fn visual_offset(&self) -> Option<f32> {",
     '    pub fn visual_offset(&self) -> Option<f32> {\n        std::eprintln!("CENSUS_VISUAL_OFFSET");')
edit("src/layout/cluster.rs", "                        offset += run.advance();",
     '                        std::eprintln!("CENSUS_PREFIX_RUN");\n                        offset += run.advance();')
edit("src/layout/cluster.rs", "                            offset += cluster.advance();",
     '                            std::eprintln!("CENSUS_PREFIX_CLUSTER");\n                            offset += cluster.advance();')

patch = []
for name, original in before.items():
    prefix = "reactivity/vendor/parley/" + name
    patch.extend(difflib.unified_diff(original.splitlines(True), (parley / name).read_text().splitlines(True),
                                      fromfile="a/" + prefix, tofile="b/" + prefix))
(args.output / "probe.patch").write_text("".join(patch))
git = ["git", "-c", f"safe.directory={args.repo}", "-C", str(args.repo)]
source = subprocess.check_output(git + ["rev-parse", args.ref], text=True).strip()
client = args.output / "src"
client.mkdir()
client_source = subprocess.check_output(git + ["show", source + ":reactivity/crates/canvas/examples/caret_pair_measure.rs"])
(client / "main.rs").write_bytes(client_source)
manifest = f'''[package]
name = "monotonic-caret-census"
version = "0.0.0"
edition = "2024"
[dependencies]
gpui_canvas = {{ path = "{args.repo}/reactivity/crates/canvas" }}
allocation-counter = "=0.8.1"
[patch.crates-io]
parley = {{ path = "{parley}" }}
parley_engine = {{ path = "{args.repo}/reactivity/vendor/parley_engine" }}
'''
(args.output / "Cargo.toml").write_text(manifest)
(args.output / "Cargo.lock").write_bytes(subprocess.check_output(git + ["show", source + ":reactivity/Cargo.lock"]))
(args.output / "census-provenance.json").write_text(json.dumps({
    "source": source, "client_sha256": hashlib.sha256(client_source).hexdigest(),
    "probe_sha256": hashlib.sha256((args.output / "probe.patch").read_bytes()).hexdigest(),
    "instrumented_sha256": {name: hashlib.sha256((parley / name).read_bytes()).hexdigest() for name in before},
    "limits": "Markers change code, timing and allocator behavior. This probe qualifies operation counts and checksum only; no speed or allocation claim. Each process primes fonts and may perform 2 cold or 3 warm shapes. STREAM markers delimit bulk calls; ordinary direct-path work outside them is retained separately.",
}, indent=2) + "\n")
print(args.output)
