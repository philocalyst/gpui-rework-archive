#!/usr/bin/env python3
"""Compile public constructor contracts against the actual Cargo-built library."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

artifacts, destination = map(Path, sys.argv[1:])
destination.mkdir(parents=True, exist_ok=False)
library = None
dependency_dirs = set()
for line in artifacts.read_text().splitlines():
    try:
        message = json.loads(line)
    except json.JSONDecodeError:
        continue
    if message.get("reason") == "compiler-artifact":
        for filename in message["filenames"]:
            if filename.endswith((".rlib", ".rmeta")):
                dependency_dirs.add(Path(filename).parent)
        if message["target"]["name"] == "gpui" and "lib" in message["target"]["kind"]:
            candidates = [Path(f) for f in message["filenames"] if f.endswith(".rmeta")]
            assert len(candidates) == 1
            library = candidates[0]
assert library is not None
before = hashlib.sha256(library.read_bytes()).hexdigest()
environment = os.environ.copy()
environment.pop("RUSTC_BOOTSTRAP", None)
cases = {
    "inline_exact": ("E0277", "struct Nested { child: Signal<String> }\nstruct Model { outer: Signal<Nested> }\nconst OUTER: Source<Model, Nested> = Source::new(FieldId::new(1), \"outer\", |m| &m.outer, |m| &mut m.outer);"),
    "inline_owner_dependency": ("E0277", "struct Nested { child: Signal<String> }\nstruct Model { outer: Signal<Nested> }\nconst OUTER: Source<Model, Nested> = Source::new(FieldId::new(1), \"outer\", |m| &m.outer, |m| &mut m.outer);\nfn register() -> Sources<Model> { Sources::new().field(OUTER) }"),
    "heap_in_place": ("E0277", "struct Model { outer: Signal<Vec<Signal<String>>> }\nconst OUTER: Source<Model, Vec<Signal<String>>> = Source::new(FieldId::new(1), \"outer\", |m| &m.outer, |m| &mut m.outer);"),
    "generic_without_bound": ("E0277", "fn declare<M,T>(r: fn(&M)->&Signal<T>, w: fn(&mut M)->&mut Signal<T>) -> Source<M,T> { Source::new(FieldId::new(0), \"value\", r, w) }"),
    "erased_without_bound": ("E0277", "struct Model(Signal<Box<dyn std::any::Any>>);\nconst VALUE: Source<Model, Box<dyn std::any::Any>> = Source::new(FieldId::new(0), \"value\", |m| &m.0, |m| &mut m.0);"),
    "cannot_impl_alias": ("E0404", "struct Escape(Signal<String>);\nimpl gpui::SourceValue for Escape {}"),
    "cannot_name_seal": ("E0603", "struct Escape(Signal<String>);\nimpl gpui::source::value::representation::Leaf for Escape {}"),
    "cannot_construct_fields": ("E0451", "struct Model(Signal<Signal<String>>);\nconst VALUE: Source<Model,Signal<String>> = Source { id: FieldId::new(0), name: \"value\", read: |m| &m.0, write: |m| &mut m.0 };"),
    "cannot_copy_into_different_type": ("E0308", "struct Model { leaf: Signal<String>, nested: Signal<Signal<String>> }\nconst LEAF: Source<Model,String> = Source::new(FieldId::new(0), \"leaf\", |m| &m.leaf, |m| &mut m.leaf);\nconst NESTED: Source<Model,Signal<String>> = LEAF;"),
    "generic_leaf_and_trait_object": (None, "fn declare<M,T: gpui::SourceValue>(r: fn(&M)->&Signal<T>, w: fn(&mut M)->&mut Signal<T>) -> Source<M,T> { Source::new(FieldId::new(0), \"value\", r, w) }\nstruct Model(Signal<Box<dyn std::any::Any + gpui::SourceValue>>);\nconst VALUE: Source<Model, Box<dyn std::any::Any + gpui::SourceValue>> = Source::new(FieldId::new(0), \"value\", |m| &m.0, |m| &mut m.0);\nconst COPY: Source<Model, Box<dyn std::any::Any + gpui::SourceValue>> = VALUE;"),
}
results = []
for name, (expected, body) in cases.items():
    source = destination / f"{name}.rs"
    source.write_text("#![forbid(unsafe_code)]\n#![allow(dead_code, unused_imports)]\nuse gpui::{FieldId, Signal, Source, Sources};\n" + body + "\nfn main() {}\n")
    command = ["rustc", "--edition=2024", "--emit=metadata", "--out-dir", str(destination), "--extern", f"gpui={library}", *[arg for directory in sorted(dependency_dirs) for arg in ["-L", f"dependency={directory}"]], str(source)]
    result = subprocess.run(command, env=environment, capture_output=True, text=True, timeout=30)
    (destination / f"{name}.log").write_text(result.stdout + result.stderr)
    passed = result.returncode == 0 if expected is None else result.returncode != 0 and f"[{expected}]" in result.stderr
    results.append({"case": name, "expected": expected, "exit": result.returncode, "pass": passed, "command": command})
after = hashlib.sha256(library.read_bytes()).hexdigest()
assert before == after
report = {"library": str(library), "library_sha256": before, "bootstrap_in_consumer": False, "metadata_format": "Rust1.101 separate full rmeta, rlib contains metadata stub", "dependency_search_directories": [str(p) for p in sorted(dependency_dirs)], "results": results}
(destination / "results.json").write_text(json.dumps(report, indent=2) + "\n")
print(json.dumps({"cases": len(results), "passed": sum(result["pass"] for result in results), "library_sha256": before}))
assert all(result["pass"] for result in results)
