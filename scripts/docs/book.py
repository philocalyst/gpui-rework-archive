#!/usr/bin/env python3
"""Mirror canonical conceptual documentation into mdBook, resolving API links."""

from __future__ import annotations

import json
from html import escape
import hashlib
import os
from pathlib import Path
import re
import sys
import tomllib

ROOT = Path(__file__).resolve().parents[2]
SOURCES = {
    "ownership": "crates/gpui/src/_ownership_and_data_flow.rs",
    "accessibility": "crates/gpui/docs/accessibility.md",
    **{name: f"crates/gpui/docs/{name}.md"
       for name in ("rendering", "layout", "lists", "animation", "text", "drawing", "assets", "input", "scheduling", "testing", "platforms")},
}
CHAPTERS = {
    "_ownership_and_data_flow": "ownership.md",
    "_accessibility": "accessibility.md",
    **{f"_documentation::{name}": f"{name}.md"
       for name in ("rendering", "layout", "lists", "animation", "text", "drawing", "assets", "input", "scheduling", "testing", "platforms")},
}
KINDS = ("struct", "enum", "trait", "type", "fn", "macro", "attr", "constant", "static")


def accessible_chrome(html: str, site_base: str | None = None) -> str:
    """Name navigation, expose its toggle to keyboards, and keep one chapter h1."""
    html = re.sub(r'<h1 class="menu-title">(.*?)</h1>',
                  r'<p class="menu-title">\1</p>', html)
    html = re.sub(r'<label id="mdbook-sidebar-toggle"(.*?)</label>',
                  r'<button type="button" id="mdbook-sidebar-toggle"\1</button>',
                  html, flags=re.DOTALL)
    html = html.replace(' for="mdbook-sidebar-toggle-anchor"', '')
    if site_base:
        home = escape(site_base.rstrip("/") + "/", quote=True)
        html = html.replace('<p class="menu-title">',
                            f'<p class="menu-title"><a href="{home}">GPUI</a> / ')
    return html.replace('<iframe class="sidebar-iframe-outer" src="toc.html">',
                        '<iframe class="sidebar-iframe-outer" src="toc.html" title="Table of contents">')


def prepare_search_assets(directory: Path) -> None:
    """Update results on input, including paste, rather than only on key release."""
    scripts = list(directory.glob("searcher-*.js"))
    if len(scripts) != 1:
        raise ValueError("expected one mdBook search script")
    original = scripts[0]
    source = original.read_text()
    needle = "searchbar.addEventListener('keyup', () => {"
    if source.count(needle) != 1:
        raise ValueError("mdBook search input hook changed; review the pinned renderer")
    source = source.replace(needle, "searchbar.addEventListener('input', () => {")
    revised = directory / ("searcher-gpui-" + hashlib.sha256(source.encode()).hexdigest()[:8] + ".js")
    revised.write_text(source)
    for path in directory.rglob("*.html"):
        html = path.read_text()
        path.write_text(html.replace(original.name, revised.name))
    original.unlink()


def canonical_source(name: str, root: Path = ROOT) -> str:
    path = root / SOURCES[name]
    text = path.read_text(encoding="utf-8")
    if path.suffix == ".rs":
        lines = []
        for line in text.splitlines():
            if not line.startswith("//!"):
                break
            lines.append(line[4:] if line.startswith("//! ") else line[3:])
        text = "\n".join(lines) + "\n"
    return text


class ApiLinks:
    def __init__(self, docs: Path, base: str, concept_base: str | None = None):
        self.docs = docs
        self.base = base.rstrip("/") + "/"
        self.concept_base = concept_base
        self.anchors: dict[Path, set[str]] = {}
        self.names: dict[Path, set[str]] = {}
        self.items: dict[str, list[Path]] = {}
        for path in docs.rglob("*.html"):
            if path.name.split(".", 1)[0] in KINDS:
                self.items.setdefault(path.name, []).append(path)

    def resolve(self, raw: str) -> str:
        target, separator, fragment = raw.partition("#")
        if separator:
            resolved = self.resolve(target)
            if "#" in resolved:
                raise ValueError(f"API member and explicit fragment conflict: {raw}")
            return resolved + "#" + fragment
        symbol = raw.strip("`").removeprefix("crate::").removeprefix("gpui::")
        symbol = re.sub(r"<.*>", "", symbol)
        symbol = symbol.removesuffix("()")
        symbol = symbol.removesuffix("!")
        if symbol in CHAPTERS:
            chapter = CHAPTERS[symbol]
            return self.concept_base.rstrip("/") + "/" + chapter.removesuffix(".md") + ".html" if self.concept_base else chapter
        if symbol.startswith("accesskit::"):
            external = {"NodeId": "struct.NodeId.html", "Action": "enum.Action.html"}
            return "https://docs.rs/accesskit/0.24.1/accesskit/" + external[symbol.split("::")[-1]]
        parts = symbol.split("::")
        for count in range(len(parts), 0, -1):
            modules, name = parts[:count - 1], parts[count - 1]
            directory = self.docs.joinpath(*modules)
            if directory not in self.names:
                self.names[directory] = {p.name for p in directory.iterdir()} if directory.is_dir() else set()
            names = self.names[directory]
            candidates = [directory / f"{kind}.{name}.html" for kind in KINDS]
            candidates = [path for path in candidates if path.name in names]
            module = directory / name / "index.html"
            if not candidates and name in names and module.is_file():
                candidates = [module]
            if not candidates and not modules:
                candidates = [p for kind in KINDS for p in self.items.get(f"{kind}.{name}.html", [])]
            if not candidates:
                continue
            if len(candidates) != 1:
                raise ValueError(f"ambiguous API link: {raw}")
            path = candidates[0]
            member = parts[count:]
            fragment = ""
            if member:
                if len(member) != 1:
                    raise ValueError(f"unsupported API member link: {raw}")
                if path not in self.anchors:
                    self.anchors[path] = set(re.findall(r'\bid="([^"]+)"', path.read_text()))
                anchors = self.anchors[path]
                choices = [f"{kind}.{member[0]}" for kind in
                           ("tymethod", "method", "associatedconstant", "associatedtype", "variant", "structfield")]
                matches = [anchor for anchor in choices if anchor in anchors]
                if not matches:
                    raise ValueError(f"missing or ambiguous API member: {raw}")
                fragment = "#" + matches[0]
            return self.base + path.relative_to(self.docs).as_posix() + fragment
        raise ValueError(f"unresolved API link: {raw}; build cargo doc with test-support first")


def render_markdown(text: str, links: ApiLinks, site_base: str) -> str:
    # Adapt links only; prose and code remain the canonical source's words.
    # Fenced examples can contain Rust syntax resembling Markdown links.
    fenced = False
    delimiter = ""
    rendered = []
    for line in text.splitlines(keepends=True):
        fence = re.match(r"\s*(`{3,}|~{3,})", line)
        if fence:
            if not fenced:
                fenced, delimiter = True, fence[1][0]
            elif fence[1][0] == delimiter:
                fenced = False
            rendered.append(line)
            continue
        if not fenced:
            line = re.sub(r"\[([^\]\n]+)\]\((crate::[^)]+)\)",
                          lambda m: f"[{m[1]}]({links.resolve(m[2])})", line)
            line = re.sub(r"\[([^\]\n]+)\]\[((?:crate::|accesskit::)?\w+::[^\]\n]+)\]",
                          lambda m: f"[{m[1]}]({links.resolve(m[2])})", line)
            line = re.sub(r"\[`([^`\n]+)`\](?![\[(])",
                          lambda m: f"[`{m[1]}`]({links.resolve(m[1])})", line)
            line = line.replace("https://gpui-ce.github.io/", site_base.rstrip("/") + "/")
        rendered.append(line)
    return "".join(rendered)


def preprocess(book: dict, links: ApiLinks, site_base: str, root: Path = ROOT) -> dict:
    def visit(items):
        for item in items:
            chapter = item.get("Chapter")
            if chapter is None:
                continue
            content = chapter["content"]
            match = re.fullmatch(r"\s*\{\{#gpui (\w+)\}\}\s*", content)
            if match:
                content = canonical_source(match[1], root)
                content = render_markdown(content, links, site_base)
            content = content.replace("{{#gpui-site}}", site_base.rstrip("/"))
            content = content.replace("{{#gpui-api}}", links.base)
            chapter["content"] = content
            visit(chapter.get("sub_items", []))
    visit(book["items"])
    return book


def main() -> int:
    if len(sys.argv) > 1 and sys.argv[1] == "supports":
        return 0 if sys.argv[2] == "html" else 1
    config = tomllib.loads((ROOT / "site/zola.toml").read_text())
    docs = Path(os.environ.get("CARGO_TARGET_DIR", ROOT / "target")) / "doc/gpui"
    if not docs.is_absolute():
        docs = ROOT / docs
    if len(sys.argv) > 1 and sys.argv[1] == "--site-guides":
        links = ApiLinks(docs, config["extra"]["api"], config["base_url"].rstrip("/") + "/book")
        for name in ("testing", "accessibility", "drawing", "assets", "text", "lists"):
            destination = ROOT / f"site/content/guides/{name}.md"
            frontmatter, _old = destination.read_text().split("\n+++\n", 1)
            source = canonical_source(name)
            _heading, body = source.split("\n", 1)
            mirrored = render_markdown(body.lstrip(), links, config["base_url"])
            output = frontmatter + "\n+++\n\n<!-- Mirrored from crates/gpui/docs/" + name + ".md; edit that source. -->\n\n" + mirrored
            if destination.read_text() != output:
                destination.write_text(output)
        return 0
    _context, book = json.load(sys.stdin)
    links = ApiLinks(docs, os.environ.get("GPUI_BOOK_API_BASE", config["extra"]["api"]))
    book = preprocess(book, links, os.environ.get("GPUI_BOOK_SITE_BASE", config["base_url"]))
    json.dump(book, sys.stdout)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
