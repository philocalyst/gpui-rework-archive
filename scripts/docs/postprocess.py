#!/usr/bin/env python3
"""Decorate rendered Markdown callouts and local rustdoc pages with backlinks."""

from __future__ import annotations

import argparse
import hashlib
import html
import json
from pathlib import Path
import re
import shutil


_CALLOUT = re.compile(
    r"<blockquote>\s*<p>\s*\[!(NOTE|TIP|WARNING)\]\s*(?:<br\s*/?>)?(.*?)</p>(.*?)</blockquote>",
    re.I | re.S,
)
_BACKLINK_ID = "gpui-examples-backlinks"
_RUSTDOC_STYLE_ID = "gpui-documentation-notes"
_RUSTDOC_STYLES = """
.rustdoc .callout,.rustdoc .doc-examples {
    margin:1.2em 0;padding:1em 1.2em;
    border:1px solid var(--border-color);
    border-left:4px solid var(--border-color);border-radius:4px;
    background:var(--code-block-background-color);color:var(--main-color);
}
.rustdoc .callout-warning {border-left-color:var(--warning-border-color)}
.rustdoc .callout-label,.rustdoc .doc-examples>p {margin-bottom:.5em}
.rustdoc .callout>:last-child,.rustdoc .doc-examples>:last-child {margin-bottom:0}
""".strip()


def callouts(text: str) -> str:
    counter = 0
    def replace(match):
        nonlocal counter
        counter += 1
        kind = match.group(1).lower()
        first, rest = match.group(2).strip(), match.group(3)
        label = f'<p class="callout-label"><strong>{kind.title()}</strong></p>'
        body = (f'<p>{first}</p>' if first else '') + rest
        return f'<aside id="callout-{kind}-{counter}" class="callout callout-{kind}" role="note">{label}{body}</aside>'
    return _CALLOUT.sub(replace, text)


def rustdoc_notes(text: str) -> str:
    """Keep generated notes readable in rustdoc's light and dark themes."""
    text = callouts(text)
    if f'id="{_RUSTDOC_STYLE_ID}"' in text:
        return text
    if 'class="callout ' not in text and 'class="doc-examples"' not in text:
        return text
    style = f'<style id="{_RUSTDOC_STYLE_ID}">{_RUSTDOC_STYLES}</style>'
    return text.replace("</head>", style + "</head>", 1)


def rustdoc_backlinks(text: str, symbol: str, links: list[dict], anchor: str | None = None) -> str:
    if not links:
        return text
    generated = re.compile(rf'<!-- gpui-walkthroughs:begin {re.escape(symbol)} -->.*?<!-- gpui-walkthroughs:end {re.escape(symbol)} -->', re.S)
    text = generated.sub('', text)
    body = "".join(f'<li><a href="{html.escape(link["url"], quote=True)}">{html.escape(link["title"])}: {html.escape(link.get("step_title", link["step"]))}</a></li>' for link in links)
    aside = f'<aside id="{_BACKLINK_ID}" class="doc-examples" aria-label="Examples"><p><strong>Walkthroughs</strong></p><ul>{body}</ul></aside>'
    # Rustdoc uses an h1 for the item declaration. Insert after the heading so
    # the backlink follows the symbol definition section in every theme.
    aside_id = _BACKLINK_ID + "-" + hashlib.sha1(symbol.encode()).hexdigest()[:10]
    aside = aside.replace(f'id="{_BACKLINK_ID}"', f'id="{aside_id}"')
    existing = re.compile(rf'<aside id="{re.escape(aside_id)}"(?:\s|>).*?</aside>', re.I | re.S)
    if existing.search(text): return existing.sub(aside, text, count=1)
    if anchor:
        section = re.search(rf'<section\b[^>]*id="{re.escape(anchor)}"[^>]*>', text, re.I)
        if not section: raise ValueError(f"{symbol}: rustdoc anchor #{anchor} has no section")
        summary_end = re.search(r"</summary>", text[section.end():], re.I)
        position = section.end() + summary_end.end() if summary_end else section.end()
        return text[:position] + aside + text[position:]
    heading = re.search(r"<h1\b[^>]*>.*?</h1>", text, re.I | re.S)
    if heading:
        return text[:heading.end()] + aside + text[heading.end():]
    return text.replace("</main>", aside + "</main>", 1)


def process_tree(rustdoc: Path, index: Path, output: Path | None = None, site_base: str = "https://gpui-ce.github.io") -> int:
    data = json.loads(index.read_text(encoding="utf-8"))
    destination = output or rustdoc
    source_real, dest_real = rustdoc.resolve(), destination.resolve()
    repo = Path.cwd().resolve()
    if output and (dest_real == source_real or source_real in dest_real.parents or dest_real in source_real.parents or dest_real == repo or repo in dest_real.parents):
        raise ValueError("rustdoc output must be a disjoint directory")
    if output:
        if destination.exists(): raise ValueError("rustdoc output already exists; choose a new directory")
        shutil.copytree(rustdoc, destination)
    changed = set()
    for symbol, item in data.items():
        raw_docs = item.get("docs", "").split("docs.rs", 1)[-1].lstrip("/")
        docs_path, _, anchor = raw_docs.partition("#")
        candidates = [destination / docs_path, destination / "/".join(docs_path.split("/")[2:])]
        candidates = [p for p in candidates if p.is_file()]
        if len(candidates) != 1:
            raise ValueError(f"{symbol}: expected one local rustdoc target for {docs_path}, found {len(candidates)}")
        links = [{**row, "url": site_base.rstrip("/") + row["url"]} for row in item.get("examples", [])]
        for file in candidates:
            text = file.read_text(encoding="utf-8")
            if anchor and not re.search(rf'id="{re.escape(anchor)}"', text):
                raise ValueError(f"{symbol}: missing rustdoc anchor #{anchor}")
            rendered = rustdoc_backlinks(text, symbol, links, anchor or None)
            if rendered != text:
                file.write_text(rendered, encoding="utf-8", newline="\n"); changed.add(file)
                break
    # Notes also occur on pages without walkthrough backlinks. Preserve their
    # formatting throughout the API, rather than only touching indexed items.
    for file in destination.rglob("*.html"):
        text = file.read_text(encoding="utf-8")
        rendered = rustdoc_notes(text)
        if rendered != text:
            file.write_text(rendered, encoding="utf-8", newline="\n")
            changed.add(file)
    return len(changed)


def main(argv=None):
    ap = argparse.ArgumentParser()
    ap.add_argument("rustdoc", type=Path)
    ap.add_argument("--index", type=Path, default=Path("site/static/api-examples.json"))
    ap.add_argument("--output", type=Path)
    ap.add_argument("--site-base", default="https://gpui-ce.github.io")
    ap.add_argument("--site-html", type=Path, help="rewrite generated Zola HTML callouts in place")
    args = ap.parse_args(argv)
    if args.site_html:
        for file in args.site_html.rglob("*.html"):
            text = file.read_text(encoding="utf-8")
            file.write_text(callouts(text), encoding="utf-8", newline="\n")
    print(f"decorated {process_tree(args.rustdoc, args.index, args.output, args.site_base)} rustdoc pages")
    return 0


if __name__ == "__main__": raise SystemExit(main())
