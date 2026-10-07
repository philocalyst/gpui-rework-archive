#!/usr/bin/env python3
"""Add idempotent generated example links to public Rust declarations."""

from __future__ import annotations

import argparse
import hashlib
import os
from pathlib import Path
import re
import sys
import tomllib

ROOT = Path(__file__).resolve().parents[2]
BEGIN, END = "// docs:examples:begin", "// docs:examples:end"


def safe_symbol(symbol: str) -> str:
    # Preserve case so `gpui::Div` and `gpui::div` cannot collide.
    base = re.sub(r"[^a-zA-Z0-9]+", "-", symbol).strip("-")
    # macOS commonly uses a case-insensitive filesystem; disambiguate symbols
    # such as `Div` and `div` while keeping ordinary names readable.
    return base + ("-" + hashlib.sha1(symbol.encode()).hexdigest()[:8] if any(c.isupper() for c in symbol) else "")


def generated_block(path: Path, source: Path, symbol: str) -> str:
    crate_root = next((p for p in source.parents if (p / "Cargo.toml").is_file()), None)
    if crate_root is None:
        raise ValueError(f"{source}: cannot locate crate root")
    target = crate_root / "src" / "docs" / "examples" / f"{safe_symbol(symbol)}.md"
    # Callers create generated files only in write mode; this helper is also
    # used by --check, which must be entirely side-effect free.
    include = Path(os.path.relpath(target, path.parent)).as_posix()
    return f'{BEGIN}\n#[doc = include_str!("{include}")]\n{END}'


def sync(root: Path, check: bool = False) -> list[str]:
    metadata = root / "site" / "examples.toml"
    if not metadata.is_file(): return [f"missing {metadata}"]
    data = tomllib.loads(metadata.read_text(encoding="utf-8"))
    source_for: dict[str, Path] = {}
    uses: dict[str, list[tuple[str, str, str]]] = {}
    for item in data.get("examples", []):
        source = root / item["source"]
        for symbol in item.get("apis", []): source_for[symbol] = source
    # Also derive symbols from parsed steps, so metadata remains declarative.
    sys.path.insert(0, str(Path(__file__).parent))
    from parser import parse_source
    for item in data.get("examples", []):
        source = root / item["source"]
        for step in parse_source(source):
            for symbol in step.api:
                source_for[symbol] = source
                uses.setdefault(symbol, []).append((item["title"], item["slug"], step.slug))
    errors = []
    prepared_outputs: dict[Path, str] = {}
    processed_sources: set[Path] = set()
    for symbol, api in data.get("api", {}).items():
        source = root / api.get("source", source_for.get(symbol, ""))
        declaration = api.get("declaration", "")
        if not source.is_file() or not declaration:
            errors.append(f"{symbol}: source/declaration metadata is incomplete")
            continue
        if source in prepared_outputs:
            lines = prepared_outputs[source].splitlines()
        else:
            lines = source.read_text(encoding="utf-8").replace("\r\n", "\n").splitlines()
        # Remove only an earlier bounded generated block; authored docs survive.
        clean: list[str] = []
        skipping = False
        for line in lines:
            if source in processed_sources:
                clean = lines
                break
            if line.strip() == BEGIN:
                if skipping: errors.append(f"{source}: nested generated example marker")
                skipping = True; continue
            if line.strip() == END:
                if not skipping: errors.append(f"{source}: unmatched generated example end")
                skipping = False; continue
            if not skipping: clean.append(line)
        if skipping: errors.append(f"{source}: unterminated generated example block")
        needle = declaration.strip()
        token = re.compile(re.escape(needle) if needle.endswith(("<", "(", "{")) else re.escape(needle) + r"(?![A-Za-z0-9_])")
        matches = [i for i, line in enumerate(clean) if token.search(line)]
        if len(matches) != 1:
            errors.append(f"{source}: expected one declaration containing {declaration!r}, found {len(matches)}")
            continue
        crate_root = next(p for p in source.parents if (p / "Cargo.toml").is_file())
        doc_file = crate_root / "src" / "docs" / "examples" / f"{safe_symbol(symbol)}.md"
        if not check: doc_file.parent.mkdir(parents=True, exist_ok=True)
        rows = uses.get(symbol, [])
        doc_text = f"Examples for `{symbol}`.\n\n" + "\n".join(
            f"- [{title}](https://gpui-ce.github.io/examples/{slug}/#{step})"
            for title, slug, step in sorted(rows)
        ) + "\n"
        if check:
            if not doc_file.is_file() or doc_file.read_text(encoding="utf-8") != doc_text:
                errors.append(f"stale generated example doc: {doc_file}")
        else:
            doc_file.write_text(doc_text, encoding="utf-8", newline="\n")
        line_no = matches[0]
        block = generated_block(source, source, symbol).splitlines()
        result = clean[:line_no] + block + clean[line_no:]
        output = "\n".join(result).rstrip() + "\n"
        prepared_outputs[source] = output
        processed_sources.add(source)
    for source, output in prepared_outputs.items():
        if check:
            if source.read_text(encoding="utf-8").replace("\r\n", "\n") != output:
                errors.append(f"stale generated links: {source}")
        else:
            source.write_text(output, encoding="utf-8", newline="\n")
    # Remove bounded attributes for API symbols that no longer exist in the
    # registry. Only files containing our markers are candidates; authored
    # documentation and unrelated Rust files are never touched.
    valid_stems = {safe_symbol(symbol) for symbol in data.get("api", {})}
    for source in root.glob("crates/**/*.rs"):
        text = source.read_text(encoding="utf-8", errors="ignore")
        if BEGIN not in text and END not in text:
            continue
        lines = text.replace("\r\n", "\n").splitlines()
        result, i, changed = [], 0, False
        while i < len(lines):
            if lines[i].strip() != BEGIN:
                result.append(lines[i]); i += 1; continue
            end = next((j for j in range(i + 1, len(lines)) if lines[j].strip() == END), None)
            if end is None:
                errors.append(f"{source}: unterminated generated example block"); result.extend(lines[i:]); break
            block = lines[i:end + 1]
            include = next((line for line in block if "include_str!" in line), "")
            stem = Path(re.search(r'include_str!\("([^"]+)', include).group(1)).stem if re.search(r'include_str!\("([^"]+)', include) else ""
            if stem not in valid_stems:
                changed = True; i = end + 1; continue
            result.extend(block); i = end + 1
        output = "\n".join(result).rstrip() + "\n"
        if changed:
            if check:
                errors.append(f"stale generated links: {source}")
            else:
                source.write_text(output, encoding="utf-8", newline="\n")
    # Remove only files carrying the generator's unmistakable first line.
    for crate_src in root.glob("crates/*/src/docs/examples"):
        if not crate_src.is_dir():
            continue
        for stale in crate_src.glob("*.md"):
            text = stale.read_text(encoding="utf-8", errors="ignore")
            if text.startswith("Examples for `") and stale.stem not in {safe_symbol(s) for s in data.get("api", {})}:
                if check: errors.append(f"stale generated example doc: {stale}")
                else: stale.unlink()
    return errors


def main(argv=None):
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true")
    args = ap.parse_args(argv)
    errors = sync(ROOT, args.check)
    if errors:
        print("\n".join(errors), file=sys.stderr); return 1
    print("documentation links are up to date" if args.check else "synced documentation links")
    return 0


if __name__ == "__main__": raise SystemExit(main())
