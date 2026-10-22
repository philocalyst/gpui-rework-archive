#!/usr/bin/env python3
"""Prepare a private Parley unit-test overlay from immutable production bytes."""
import argparse
import hashlib
import json
import pathlib
import re
import shutil
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--repo", type=pathlib.Path, required=True)
parser.add_argument("--ref", required=True)
parser.add_argument("--output", type=pathlib.Path, required=True)
args = parser.parse_args()
git = ["git", "-c", f"safe.directory={args.repo}", "-C", str(args.repo)]
pin = subprocess.check_output(git + ["rev-parse", args.ref], text=True).strip()
args.output.mkdir(parents=True, exist_ok=False)
prefix = "reactivity/vendor/parley/"
paths = subprocess.check_output(
    git + ["ls-tree", "-r", "--name-only", pin, "--", prefix], text=True
).splitlines()
hashes = {}
for path in paths:
    data = subprocess.check_output(git + ["show", f"{pin}:{path}"])
    target = args.output / path.removeprefix(prefix)
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(data)
    hashes[path] = hashlib.sha256(data).hexdigest()

# The crates.io archive has unit modules depending on unpublished parley_dev.
# Replace only the test module root; production modules remain byte-identical.
(args.output / "src/tests/mod.rs").write_text("mod span_tests;\n")
shutil.copy2(pathlib.Path(__file__).with_name("span_tests.rs"), args.output / "src/tests/span_tests.rs")
manifest = args.output / "Cargo.toml"
sections = re.split(r"(?=^\[)", manifest.read_text(), flags=re.MULTILINE)
manifest.write_text("".join(s for s in sections if not re.match(
    r"\[(?:dev-dependencies[.\]]|target\..*\.dev-dependencies[.\]])", s
)).replace('    "peniko/libm",\n', '').replace('    "peniko/std",\n', '')
    + '\n[patch.crates-io]\nparley_engine = { path = "' + str(args.repo / "reactivity/vendor/parley_engine") + '" }\n')
lock = subprocess.check_output(git + ["show", f"{pin}:reactivity/Cargo.lock"])
(args.output / "Cargo.lock").write_bytes(lock)
hashes["reactivity/Cargo.lock"] = hashlib.sha256(lock).hexdigest()
engine = "reactivity/vendor/parley_engine/"
for path in subprocess.check_output(
    git + ["ls-tree", "-r", "--name-only", pin, "--", engine], text=True
).splitlines():
    expected = subprocess.check_output(git + ["show", f"{pin}:{path}"])
    if (args.repo / path).read_bytes() != expected:
        raise RuntimeError(f"Engine dependency differs from source pin: {path}")
    hashes[path] = hashlib.sha256(expected).hexdigest()
fonts = args.output / "fonts"
fonts.mkdir()
for source, name in [
    ("NotoSans.ttf", "primary.ttf"),
    ("arabic/NotoSansArabic-Regular.ttf", "arabic.ttf"),
    ("hebrew/NotoSansHebrew-Regular.ttf", "hebrew.ttf"),
]:
    path = "reactivity/crates/canvas/assets/" + source
    data = subprocess.check_output(git + ["show", f"{pin}:{path}"])
    (fonts / name).write_bytes(data)
    hashes[path] = hashlib.sha256(data).hexdigest()
(args.output / "provenance.json").write_text(json.dumps({
    "source": pin,
    "copied_source_sha256": hashes,
    "test_module": "src/tests/mod.rs replaced; src/tests/span_tests.rs added",
    "manifest": "unused dev-dependencies and their peniko feature references removed; existing vendored Engine selected",
    "production_source_mutated": False,
    "test_sha256": hashlib.sha256((args.output / "src/tests/span_tests.rs").read_bytes()).hexdigest(),
}, indent=2) + "\n")
print(args.output)
