#!/usr/bin/env python3
"""Reproducible physical-source ledger, with conservative Rust test subtraction.

Run --working for the experiment, or --ref 41a42eb96d --scope original for the
original checkout. See inventory.md for boundaries and interpretation.
"""

import argparse
import collections
import hashlib
import json
import os
import pathlib
import posixpath
import subprocess
import tomllib

REPO = pathlib.Path(__file__).resolve().parents[2]
LANGUAGES = {
    ".rs": "Rust", ".wgsl": "WGSL", ".py": "Python", ".sh": "Shell",
    ".bash": "Shell", ".c": "C", ".h": "C/C++ header", ".cc": "C++",
    ".cpp": "C++", ".cxx": "C++", ".hpp": "C++ header", ".m": "Objective-C",
    ".mm": "Objective-C++", ".js": "JavaScript", ".mjs": "JavaScript",
    ".ts": "TypeScript", ".tsx": "TSX", ".jsx": "JSX", ".go": "Go",
    ".zig": "Zig", ".java": "Java", ".kt": "Kotlin", ".kts": "Kotlin",
    ".frag": "GLSL", ".vert": "GLSL", ".glsl": "GLSL", ".metal": "Metal",
    ".html": "HTML", ".css": "CSS", ".nix": "Nix", ".s": "Assembly",
    ".asm": "Assembly",
}
DISASSEMBLY_DIRECTORIES = (
    "reactivity/benchmarks/bin-miss/asm/",
    "reactivity/crates/gpui/evidence/dimensions/",
    "reactivity/evidence/gpu-packet-reuse/",
    "reactivity/evidence/option-lookup/",
    "reactivity/evidence/paint-coupling/",
    "reactivity/evidence/paint-patch/",
    "reactivity/evidence/rounded-geometry/",
)
DISASSEMBLY_FILES = {
    f"reactivity/crates/canvas/evidence/text-selection-cut-{variant}.asm"
    for variant in ("baseline", "candidate", "eager")
}


def git(*args, binary=False, data=None):
    return subprocess.check_output(
        ["git", "-c", f"safe.directory={REPO}", "-C", str(REPO), *args],
        input=data, text=not binary,
    )


def source_language(path, content):
    p = pathlib.PurePosixPath(path)
    if p.name == "justfile":
        return "Just"
    if p.suffix in LANGUAGES:
        return LANGUAGES[p.suffix]
    if content.startswith(b"#!") and b"\x00" not in content:
        first = content.splitlines()[0].lower()
        if any(name in first for name in (b"python", b"bash", b"/sh", b"node")):
            return "Script (shebang)"
    return None


def read_sources(ref):
    """Git's file set avoids build products; untracked, nonignored source counts."""
    if ref:
        tree = git("ls-tree", "-rz", ref).split("\0")
        paths = [entry.split("\t", 1)[1] for entry in tree
                 if entry and entry.startswith(("100644 ", "100755 "))]
        paths = [path for path in paths if pathlib.PurePosixPath(path).suffix in LANGUAGES
                 or not pathlib.PurePosixPath(path).suffix]
        request = "".join(f"{ref}:{path}\n" for path in paths).encode()
        output = git("cat-file", "--batch", binary=True, data=request)
        offset = 0
        for path in paths:
            end = output.index(b"\n", offset)
            header = output[offset:end].split()
            size = int(header[2])
            content = output[end + 1:end + 1 + size]
            offset = end + size + 2
            language = source_language(path, content)
            if language:
                yield path, content, language
    else:
        paths = set(git("ls-files", "-z", "--cached", "--others", "--exclude-standard").split("\0"))
        for path in sorted(paths - {""}):
            disk = REPO / path
            if not disk.is_file() or disk.is_symlink():
                continue
            if pathlib.PurePosixPath(path).suffix and not source_language(path, b""):
                continue
            # Read extensionless files to identify executable source by shebang.
            with disk.open("rb") as source:
                content = source.read() if source_language(path, b"") else source.read(256)
                language = source_language(path, content)
                if language and not source_language(path, b""):
                    content += source.read()
            if language:
                yield path, content, language


def category(path, scope):
    """Ownership and purpose are independent; tests are a line-level dimension."""
    parts = pathlib.PurePosixPath(path).parts
    if scope == "experiment":
        if parts[0] != "reactivity":
            return "archived_legacy", "legacy_checkout"
        parts = parts[1:]
    elif parts[0] == "reactivity":
        return "archived_legacy", "experiment_excluded_from_original"
    if any(p in {"archive", "archives", "legacy"} for p in parts) or parts[:2] == ("docs", "inputs"):
        return "archived_legacy", "archived_inputs"
    if "vendor" in parts or "third_party" in parts or "third-party" in parts:
        return "vendor", "vendor"
    if parts[0] == "ports" and "upstream" in parts:
        return "vendor", "upstream_reference"
    if "examples" in parts:
        return "first_party", "examples"
    if "benchmarks" in parts or "benches" in parts:
        return "first_party", "benchmarks"
    if "evidence" in parts:
        return "first_party", "evidence_support"
    if parts[0] in {"tools", "tooling", "scripts", ".github"}:
        return "first_party", "tools"
    if parts[0] == "crates":
        return "first_party", "labs" if parts[1].endswith("-lab") else "libraries"
    if parts[0] in {"apps", "applications", "ports"}:
        return "first_party", "applications"
    return "first_party", "other_support"


def is_external_test(path):
    p = pathlib.PurePosixPath(path)
    return (any(part in {"tests", "test", "test_data", "test-data"} for part in p.parts)
            or p.name.startswith("test_") or p.name.endswith(("_test.go", ".test.js", ".test.ts")))


def generated_source(path, content):
    p = pathlib.PurePosixPath(path)
    # These directories hold emitted compiler/disassembler captures. Assembly
    # elsewhere may be authored source and must retain its first-party charge.
    captured_assembly = p.suffix in {".s", ".asm"} and (
        path.startswith(DISASSEMBLY_DIRECTORIES) or path in DISASSEMBLY_FILES
    )
    if captured_assembly or path.endswith(".min.js"):
        return True
    header = b"\n".join(content.splitlines()[:12]).lower()
    return any(marker in header for marker in (
        b"@generated", b"automatically generated", b"auto-generated", b"autogenerated",
        b"generated by bindgen", b"generated by the protocol buffer compiler",
    ))


def rust_analysis(sources, helper):
    if helper is None:
        manifest = pathlib.Path(__file__).with_name("inventory-rust") / "Cargo.toml"
        target = pathlib.Path(os.environ.get("CARGO_TARGET_DIR", REPO / "reactivity/target/inventory-rust"))
        subprocess.run(["cargo", "build", "--offline", "--locked", "--release", "--jobs", "2",
                        "--manifest-path", str(manifest), "--target-dir", str(target)], check=True)
        helper = target / "release/inventory-rust"
    request = "".join(json.dumps({"path": path, "text": content.decode("utf-8")}) + "\n"
                      for path, content, lang in sources if lang == "Rust")
    result = subprocess.run([str(helper)], input=request, text=True, stdout=subprocess.PIPE, check=True)
    return {entry["path"]: entry for entry in map(json.loads, result.stdout.splitlines())}


def cargo_targets(ref):
    """Read custom target paths without loading/building the Cargo workspace."""
    if ref:
        paths = git("ls-tree", "-rz", "--name-only", ref).split("\0")
    else:
        paths = git("ls-files", "-z", "--cached", "--others", "--exclude-standard").split("\0")
    tests, roots, manifests = set(), set(), {}
    for path in sorted(set(paths)):
        if pathlib.PurePosixPath(path).name != "Cargo.toml":
            continue
        if ref:
            content = git("show", f"{ref}:{path}", binary=True)
        elif (REPO / path).is_file():
            content = (REPO / path).read_bytes()
        else:
            continue
        data = tomllib.loads(content.decode())
        manifests[path] = hashlib.sha256(content).hexdigest()
        parent = pathlib.PurePosixPath(path).parent
        for kind in ("lib", "bin", "example", "bench", "test"):
            entries = [data[kind]] if kind == "lib" and kind in data else data.get(kind, [])
            for entry in entries:
                if "path" in entry:
                    target = posixpath.normpath(str(parent / entry["path"]))
                    (tests if kind == "test" else roots).add(target)
    return tests, roots, manifests


def resolve_modules(analyses, sources, explicit_tests=(), explicit_roots=()):
    """Propagate test-only files through module edges, retaining ambiguous cases.

    Unknown feature cfgs never eliminate a production edge. A file shared with
    production remains charged even if a test also imports it via #[path].
    """
    paths = {path for path, _, _ in sources}
    edges = []
    for path, analysis in analyses.items():
        p = pathlib.PurePosixPath(path)
        module_dir = p.parent if p.stem in {"lib", "main", "mod", "build"} or path in explicit_roots else p.parent / p.stem
        for module in analysis["modules"]:
            inline = pathlib.PurePosixPath(*(name.removeprefix("r#") for name in module["inline"]))
            if module["path"] is not None:
                # #[path] in non-inline modules is relative to the source file;
                # inline modules add their module directory components.
                base = module_dir / inline if module["inline"] else p.parent
                candidates = [str(base / module["path"])]
            else:
                base = module_dir / inline / module["name"].removeprefix("r#")
                candidates = [str(base) + ".rs", str(base / "mod.rs")]
            candidates = [posixpath.normpath(candidate) for candidate in candidates]
            alt_base = module_dir / inline if module["inline"] else p.parent
            candidates.extend(posixpath.normpath(str(alt_base / alternate))
                              for alternate in module.get("alternate_paths", []))
            candidates = list(dict.fromkeys(candidates))
            found = [candidate for candidate in candidates if candidate in paths]
            if len(found) == 1 and not module["uncertain"]:
                edges.append((path, found[0], module["test_only"]))
            else:
                # A possible production import must block test-only propagation,
                # including a cfg_attr-selected path also imported by a test.
                edges.extend((path, candidate, False) for candidate in found)
                analysis["unclassified"].append({"lines": module["lines"],
                    "reason": "unresolved or configuration-dependent out-of-line module",
                    "candidates": candidates})
        # Macro bodies are token trees, not expanded Rust AST. A possible module
        # import blocks exclusion even when another import is definitely a test.
        for module in analysis.get("macro_modules", []):
            inline = pathlib.PurePosixPath(*(name.removeprefix("r#") for name in module["inline"]))
            base = module_dir / inline / module["name"].removeprefix("r#")
            for candidate in (str(base) + ".rs", str(base / "mod.rs")):
                if candidate in paths:
                    edges.append((path, candidate, module["test_only"]))
    incoming = collections.defaultdict(list)
    for parent, child, test in edges:
        incoming[child].append((parent, test))
    test_files = {path for path in paths if is_external_test(path)} | set(explicit_tests)
    test_files.update(path for path, a in analyses.items() if a.get("file_test_only"))
    roots = {path for path in paths if pathlib.PurePosixPath(path).stem in {"lib", "main", "build"}} | set(explicit_roots)
    while True:
        newly_test = {child for child, imports in incoming.items()
                      if child not in roots and all(parent in test_files or test for parent, test in imports)}
        if newly_test <= test_files:
            break
        test_files.update(newly_test)
    return test_files


def excluded_test_lines(content, analysis):
    """Only subtract lines wholly inside known test spans; shared lines count."""
    lines = content.decode("utf-8").splitlines()
    excluded = set()
    for start, column, end, end_column in analysis.get("test_ranges", []):
        for number in range(start, end + 1):
            # proc_macro2 columns count Unicode characters. Another item's boundary text
            # keeps that physical line in the non-test count.
            line = lines[number - 1]
            prefix = line[:column] if number == start else ""
            suffix = line[end_column:] if number == end else ""
            if not prefix.strip() and not suffix.strip():
                excluded.add(number)
    return len(excluded)


def ledger_digest(files):
    payload = "".join(f"{entry['path']}\0{entry['sha256']}\n" for entry in files)
    return hashlib.sha256(payload.encode()).hexdigest()


def inventory(ref=None, scope="experiment", helper=None):
    head = git("rev-parse", ref or "HEAD").strip()
    sources = list(read_sources(ref))
    # Legacy/archived code is physically counted but has no active numerator.
    active = [(p, c, lang) for p, c, lang in sources if category(p, scope)[0] != "archived_legacy"]
    analyses = rust_analysis(active, helper)
    explicit_tests, explicit_roots, manifests = cargo_targets(ref)
    test_files = resolve_modules(analyses, active, explicit_tests, explicit_roots)
    files = []
    groups = collections.defaultdict(collections.Counter)
    totals = collections.Counter()
    for name in ("first_party_non_test_lines", "vendor_non_test_lines", "generated_non_test_lines"):
        totals[name] = 0
    for path, content, language in sorted(sources):
        origin, purpose = category(path, scope)
        generated = generated_source(path, content)
        physical = len(content.splitlines())
        analysis = analyses.get(path, {})
        test = physical if path in test_files else excluded_test_lines(content, analysis)
        non_test = physical - test
        charge = "archived_legacy" if origin == "archived_legacy" else "generated" if generated else origin
        entry = {"path": path, "language": language, "origin": origin, "purpose": purpose,
                 "charge": charge, "physical_lines": physical, "test_lines": test,
                 "non_test_lines": non_test, "sha256": hashlib.sha256(content).hexdigest()}
        if charge == "archived_legacy":
            # Only physical size is measured for excluded historical source.
            del entry["test_lines"], entry["non_test_lines"]
        if analysis.get("unclassified"):
            entry["unclassified"] = analysis["unclassified"]
        if path in test_files:
            entry["test_classification"] = "external test path or test-only module graph"
        files.append(entry)
        group = groups[f"{charge}/{purpose}"]
        group.update(files=1, physical_lines=physical)
        totals["all_repository_physical_source_lines"] += physical
        if charge == "archived_legacy":
            totals["excluded_archived_physical_source_lines"] += physical
            continue
        group.update(test_lines=test, non_test_lines=non_test)
        totals["all_active_physical_source_lines"] += physical
        totals["all_active_test_lines"] += test
        totals["all_active_non_test_lines"] += non_test
        totals[f"{charge}_non_test_lines"] += non_test
        if origin == "first_party":
            totals["first_party_including_generated_non_test_lines"] += non_test
        if entry.get("unclassified"):
            totals["unclassified_files"] += 1
            totals["unclassified_files_non_test_lines_included"] += non_test
    return {
        "schema": 2, "method": "physical source lines, including blanks/comments; conservative Rust AST test subtraction; no semantic SLOC or feature-equivalence claim",
        "scope": scope, "source_code_head": head, "source_ref": ref,
        "source_state": "pinned_git_blobs" if ref else "working_checkout",
        "working_status_porcelain": [] if ref else git("status", "--porcelain=v1", "--untracked-files=all").splitlines(),
        "source_ledger_sha256": ledger_digest(files),
        "active_source_ledger_sha256": ledger_digest([e for e in files if e["charge"] != "archived_legacy"]),
        "target_classification_manifests_sha256": manifests,
        "inventory_tool_sha256": {str(path.relative_to(REPO)): hashlib.sha256(path.read_bytes()).hexdigest()
                                  for path in [pathlib.Path(__file__), *[pathlib.Path(__file__).with_name("inventory-rust") / name
                                               for name in ("Cargo.toml", "Cargo.lock", "src/main.rs")]]},
        "reproduce": {"command": f"python3 reactivity/tools/inventory.py {'--ref ' + head if ref else '--working'} --scope {scope}",
                      "parser": "tools/inventory-rust/Cargo.lock pins Syn 2.0.119 and proc-macro2 1.0.107; cargo build --offline --locked --release --jobs 2",
                      "file_set": "git ls-tree -r at ref; or git ls-files --cached --others --exclude-standard in working checkout; symlinks excluded"},
        "totals": dict(sorted(totals.items())), "groups": dict(sorted(groups.items())), "files": files,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--working", action="store_true", help="include dirty tracked and nonignored untracked source (default)")
    parser.add_argument("--ref", help="inventory immutable Git source, e.g. 41a42eb96d")
    parser.add_argument("--scope", choices=("experiment", "original"), default="experiment")
    parser.add_argument("--helper", type=pathlib.Path, help="use an already built inventory-rust executable")
    args = parser.parse_args()
    if args.working and args.ref:
        parser.error("--working and --ref are mutually exclusive")
    print(json.dumps(inventory(args.ref, args.scope, args.helper), indent=2))


if __name__ == "__main__":
    main()
