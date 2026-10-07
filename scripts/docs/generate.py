#!/usr/bin/env python3
"""Generate Zola example chapters, source downloads, and API backlinks."""

from __future__ import annotations

import argparse
import hashlib
import html
import io
import json
from pathlib import Path
import re
import shutil
import sys
import tomllib
import zipfile

sys.path.insert(0, str(Path(__file__).resolve().parent))
from parser import DocumentationError, Step, parse_source, _REFERENCE  # noqa: E402


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_META = ROOT / "site" / "examples.toml"


def load_metadata(path: Path = DEFAULT_META):
    if not path.is_file():
        raise SystemExit(f"missing {path}; add [[examples]] and [api.\"symbol\"] entries")
    with path.open("rb") as handle:
        data = tomllib.load(handle)
    examples = data.get("examples", [])
    if not isinstance(examples, list):
        raise SystemExit("examples.toml: [[examples]] entries are required")
    seen = set()
    for item in examples:
        for key in ("slug", "title", "summary", "source", "run", "weight"):
            if key not in item:
                raise SystemExit(f"examples.toml: example missing {key}")
        if item["slug"] in seen:
            raise SystemExit(f"examples.toml: duplicate example {item['slug']!r}")
        seen.add(item["slug"])
    return data, examples, data.get("api", {})


def docs_url(symbol: str, api: dict) -> str:
    item = api.get(symbol)
    if not item:
        raise ValueError(f"unknown API symbol {symbol!r}; add it to [api.\"{symbol}\"]")
    crate = item.get("crate", "gpui-ce")
    version = item.get("version", "0.2.2")
    path = item.get("path", "")
    if path:
        if not path.startswith("gpui/"):
            path = "gpui/" + path.lstrip("/")
        return f"https://docs.rs/{crate}/{version}/{path.lstrip('/')}"
    return f"https://docs.rs/{crate}/{version}/{symbol.split('::')[-1].lower()}/index.html"


def source_lines(source: Path) -> str:
    return source.read_text(encoding="utf-8").replace("\r\n", "\n").replace("\r", "\n")


def stripped_source(source: Path, steps: list[Step]) -> str:
    lines = source_lines(source).splitlines()
    remove: set[int] = set()
    for step in steps:
        remove.add(step.source_start)
        remove.update(range(step.source_start + 1, step.code_start))
    # Preserve every ordinary line, including imports, support functions, and
    # comments outside the narrative blocks.
    return "\n".join(line for number, line in enumerate(lines, 1) if number not in remove).rstrip() + "\n"


def remove_support_decl(text: str) -> str:
    return re.sub(r'^\s*#\[path\s*=\s*"\.\./(?:src/)?support\.rs"\]\s*\n\s*mod\s+support\s*;\s*\n', "", text, count=1, flags=re.M)


def inline_support(main: str, support: str) -> str:
    main = remove_support_decl(main)
    body = "\n".join("    " + line if line else "" for line in support.rstrip().splitlines())
    return main.rstrip() + "\n\nmod support {\n" + body + "\n}\n"


def component_source(source: Path, steps: list[Step]) -> str:
    """Keep the canonical component; remove only the native platform entry."""
    text = remove_support_decl(stripped_source(source, steps))
    text, removed = re.subn(r'pub fn main\(\) \{\n    support::run\(component\);\n\}\n?', '', text)
    if removed != 1 or not re.search(r'^fn component\(', text, re.M):
        raise DocumentationError(source, 1, "use fn component(...) and pub fn main() { support::run(component); }")
    return text.strip() + "\n"


def cargo_zip(root: Path, item: dict, source: Path, steps: list[Step]) -> bytes | None:
    manifest_name = item.get("downloadable_manifest")
    if not manifest_name:
        return None
    manifest = root / manifest_name
    if not manifest.is_file():
        raise SystemExit(f"{manifest}: downloadable manifest does not exist")
    main = stripped_source(source, steps)
    support_text = ""
    if item.get("support"):
        support = root / item["support"]
        support_text = support.read_text(encoding="utf-8").replace("\r\n", "\n").rstrip() + "\n"
        main = inline_support(main, support_text)
    files = {
        "Cargo.toml": manifest.read_text(encoding="utf-8").replace("{slug}", item["slug"]),
        "src/main.rs": main,
    }
    output = io.BytesIO()
    with zipfile.ZipFile(output, "w", zipfile.ZIP_DEFLATED) as archive:
        for name in sorted(files):
            info = zipfile.ZipInfo(name, (1980, 1, 1, 0, 0, 0)); info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o644 << 16
            archive.writestr(info, files[name].encode("utf-8"))
    return output.getvalue()


def example_page(item: dict, source: Path, steps: list[Step], api: dict) -> str:
    out = [
        "+++",
        f"title = {json.dumps(item['title'])}",
        f"description = {json.dumps(item['summary'])}",
        f"weight = {int(item['weight'])}",
        "[extra]",
        f"example_slug = {json.dumps(item['slug'])}",
        f"example_source = {json.dumps(item['source'])}",
        f"example_run = {json.dumps(item['run'])}",
        "+++", "", "<!-- generated by scripts/docs/generate.py -->", "",
    ]
    if item.get("preview"):
        out += [f'{{{{ <playground example="{html.escape(item["preview"], quote=True)}" title="{html.escape(item["title"], quote=True)}" /> }}}}', ""]
    for step in steps:
        out += [f'<a id="{html.escape(step.slug, quote=True)}"></a>', f"## {step.title}", ""]
        prose = "\n".join(step.prose)
        prose = _REFERENCE.sub(lambda m: f"[`{m.group(1)}`]({docs_url(m.group(1) if m.group(1).startswith('gpui::') else 'gpui::' + m.group(1), api)})", prose)
        out += [prose, ""]
        out += ["```rust", *step.code, "```", ""]
        source_link = f'{{{{ get_url(path="sources/{item["slug"]}/") }}}}#L{step.code_start}'
        out += [f"[View this step in the source]({source_link}).", ""]
    out += [f"[Download the complete source]({{{{ get_url(path=\"examples/{item['slug']}.rs\") }}}}).", ""]
    return "\n".join(out).rstrip() + "\n"


def source_page(item: dict, source: Path) -> str:
    lines = source_lines(source).splitlines()
    listing = "\n".join(
        f'<span id="L{number}" class="source-line"><a href="#L{number}" class="line-number" data-line="{number}" aria-label="Line {number}" tabindex="-1"></a>{html.escape(line).replace(chr(123), "&#123;").replace(chr(125), "&#125;")}</span>'
        for number, line in enumerate(lines, 1)
    )
    return (
        f'+++\ntitle = {json.dumps(item["title"] + ": source")}\n'
        f'description = {json.dumps("The annotated Rust source used to build this walkthrough.")}\n'
        '+++\n\n<!-- generated by scripts/docs/generate.py -->\n\n'
        f'[Return to the walkthrough](@/examples/{item["slug"]}.md). '
        f'[Download the complete program]({{{{ get_url(path="examples/{item["slug"]}.rs") }}}}).\n\n'
        f'<pre class="source-listing"><code>{listing}</code></pre>\n'
    )


def render(root: Path, *, check: bool = False) -> list[str]:
    data, examples, api = load_metadata(root / "site" / "examples.toml")
    content = root / "site" / "content" / "examples"
    downloads = root / "site" / "static" / "examples"
    index_path = root / "site" / "static" / "api-examples.json"
    if not check:
        content.mkdir(parents=True, exist_ok=True)
        downloads.mkdir(parents=True, exist_ok=True)
    expected: dict[Path, str] = {}
    backlinks: dict[str, list[dict]] = {}
    components = []
    for item in sorted(examples, key=lambda x: (int(x["weight"]), x["slug"])):
        source = root / item["source"]
        if not source.is_file():
            raise SystemExit(f"{source}: source does not exist")
        try:
            steps = parse_source(source, catalog=api)
        except DocumentationError as error:
            raise SystemExit(str(error)) from error
        if not steps:
            raise SystemExit(f"{source}: no documentation steps found")
        page = example_page(item, source, steps, api)
        page_path = content / f"{item['slug']}.md"
        source_text = "// Generated by scripts/docs/generate.py; edit the annotated Rust source.\n"
        if item.get("support"):
            support = root / item["support"]
            if not support.is_file(): raise SystemExit(f"{support}: support source does not exist")
            source_text = inline_support(source_text + stripped_source(source, steps), support.read_text(encoding="utf-8").replace("\r\n", "\n"))
        else:
            source_text += stripped_source(source, steps)
        download_path = downloads / f"{item['slug']}.rs"
        expected[page_path] = page
        expected[root / "site/content/sources" / f"{item['slug']}.md"] = source_page(item, source)
        expected[download_path] = source_text
        if item.get("preview"):
            expected[root / "site/static/components" / f"{item['slug']}.rs"] = component_source(source, steps)
            components.append(item['slug'])
        archive = cargo_zip(root, item, source, steps)
        if archive is not None:
            zip_path = downloads / f"{item['slug']}.zip"
            expected[zip_path] = archive
        permalink = f"/examples/{item['slug']}/"
        for step in steps:
            for symbol in step.api:
                backlinks.setdefault(symbol, []).append({
                    "example": item["slug"], "title": item["title"],
                    "url": f"{permalink}#{step.slug}", "step": step.slug, "step_title": step.title,
                })
    index = {symbol: {"path": api.get(symbol, {}).get("path"), "docs": docs_url(symbol, api), "examples": sorted(rows, key=lambda x: (x["example"], x["step"]))}
             for symbol, rows in sorted(backlinks.items())}
    expected[index_path] = json.dumps(index, indent=2, sort_keys=True) + "\n"
    expected[root / "site/examples/src/components.rs"] = (
        '// Generated by scripts/docs/generate.py; edit examples.toml and the canonical Rust sources.\n'
        'pub fn source(slug: &str) -> Option<&\'static str> {\n    match slug {\n'
        + ''.join(f'        "{slug}" => Some(include_str!("../../static/components/{slug}.rs")),\n' for slug in components)
        + '        _ => None,\n    }\n}\n'
    )
    manifest_path = downloads / ".generated.json"
    expected[manifest_path] = json.dumps({"sources": sorted(item["slug"] for item in examples), "archives": sorted(item["slug"] for item in examples if item.get("downloadable_manifest"))}, indent=2) + "\n"
    old_manifest = []
    if manifest_path.is_file():
        try: old_manifest = json.loads(manifest_path.read_text(encoding="utf-8")).get("archives", [])
        except ValueError: old_manifest = []
    errors = []
    for path, value in expected.items():
        if check:
            current = path.read_bytes() if isinstance(value, bytes) and path.is_file() else (path.read_text(encoding="utf-8") if path.is_file() else None)
            if current != value:
                errors.append(f"stale generated file: {path}")
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            if isinstance(value, bytes): path.write_bytes(value)
            else: path.write_text(value, encoding="utf-8", newline="\n")
    generated = set(expected)
    for directory, suffix in ((content, ".md"), (root / "site/content/sources", ".md"), (downloads, ".rs")):
        if directory.is_dir():
            patterns = [f"*{suffix}"] + (["*.zip"] if suffix == ".rs" else [])
            for pattern in patterns:
                for path in directory.glob(pattern):
                    marked = path.suffix == ".md" and "generated by scripts/docs/generate.py" in path.read_text(encoding="utf-8", errors="ignore")
                    marked = marked or (path.suffix == ".rs" and path.read_text(encoding="utf-8", errors="ignore").startswith("// Generated by scripts/docs/generate.py;"))
                    marked = marked or (path.suffix == ".zip" and (path.name.removesuffix(".zip") in old_manifest or path.name.removesuffix(".zip") in {x["slug"] for x in examples}))
                    if path.name == "_index.md" or path not in generated:
                        if path not in generated and path.name != "_index.md" and marked:
                            if check: errors.append(f"stale generated file: {path}")
                            else: path.unlink()
    if check and not index_path.is_file(): errors.append(f"stale generated file: {index_path}")
    return errors


def main(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args(argv)
    errors = render(ROOT, check=args.check)
    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1
    print("documentation examples are up to date" if args.check else "generated documentation examples")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
