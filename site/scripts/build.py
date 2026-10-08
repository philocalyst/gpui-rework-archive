#!/usr/bin/env python3
"""Build the walkthrough site, optionally with the API for this checkout."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tomllib

ROOT = Path(__file__).resolve().parents[2]
SITE = ROOT / "site"
PUBLIC = SITE / "public"
sys.path.insert(0, str(ROOT / "scripts" / "docs"))
from postprocess import callouts, process_tree
from check_site import audit
from book import accessible_chrome, prepare_search_assets


def run(*command: str, env=None) -> None:
    subprocess.run(command, cwd=ROOT, env=env, check=True)


def source_digest() -> str:
    digest = hashlib.sha256()
    roots = (ROOT / "book", ROOT / "crates", ROOT / "assets", SITE / "content", SITE / "templates", SITE / "examples", SITE / "editor", ROOT / "scripts/docs", SITE / "scripts", SITE / "static", ROOT / "scripts/codepen", ROOT / "vendor/miri/src", ROOT / "vendor/miri/cargo-miri/src")
    files = {ROOT / "Cargo.toml", ROOT / "Cargo.lock", SITE / "zola.toml", SITE / "examples.toml", SITE / "redirects.json", SITE / "package.json", SITE / "package-lock.json"}
    for directory in roots:
        files.update(path for path in directory.rglob("*") if path.is_file()
                     and "target" not in path.parts and "pkg" not in path.parts and "builds" not in path.parts
                     and "__pycache__" not in path.parts and path.name != "build.json"
                     and not path.is_relative_to(SITE / "static/workbench"))
    for path in sorted(files):
        digest.update(str(path.relative_to(ROOT)).encode() + b"\0")
        digest.update(path.read_bytes())
    return digest.hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--with-api", action="store_true", help="include and link to rustdoc built from this checkout")
    parser.add_argument("--base-url", help="URL where the artifact will be served; supports a path prefix")
    parser.add_argument("--output-dir", type=Path, help="write the processed artifact to this directory")
    parser.add_argument("--text-only", action="store_true", help="omit browser programs for a prose-only review")
    args = parser.parse_args()
    public = (args.output_dir or PUBLIC).resolve()
    config = tomllib.loads((SITE / "zola.toml").read_text())
    base = (args.base_url or config["base_url"]).rstrip("/")
    mdbook = os.environ.get("MDBOOK") or shutil.which("mdbook")
    if not mdbook:
        bundled = ROOT / "target/doc-tools/bin/mdbook"
        mdbook = str(bundled) if bundled.is_file() else None
    if not mdbook:
        parser.error("mdBook 0.5.4 is required; install it or set MDBOOK to its executable")
    run(sys.executable, str(ROOT / "scripts/docs/generate.py"), "--check")
    run(sys.executable, str(ROOT / "scripts/docs/sync_links.py"), "--check")
    if not args.text_only:
        run(sys.executable, str(SITE / "scripts/build_editor.py"))
        run(sys.executable, str(SITE / "scripts/build_preview.py"))
    # The book resolves links against this checkout even when the published
    # artifact links to docs.rs rather than carrying a local API copy.
    env = os.environ.copy()
    env["RUSTDOCFLAGS"] = " ".join(filter(None, [env.get("RUSTDOCFLAGS"), "-D rustdoc::broken_intra_doc_links -D rustdoc::bare_urls -D rustdoc::private_intra_doc_links -D missing_docs"]))
    run("cargo", "doc", "--locked", "--lib", "-p", "gpui-ce", "-p", "gpui_ce_elements",
        "--no-deps", "--features", "gpui-ce/test-support,gpui-ce/bench-support", env=env)
    run(sys.executable, str(ROOT / "scripts/docs/book.py"), "--site-guides")
    run("zola", "--root", str(SITE), "build", "--base-url", base, "--output-dir", str(public), "--force")
    if args.with_api:
        source = Path(os.environ.get("CARGO_TARGET_DIR", ROOT / "target")) / "doc"
        if not source.is_absolute():
            source = ROOT / source
        shutil.copytree(source, public / "api")
        process_tree(public / "api", SITE / "static/api-examples.json", site_base=base)
    book_env = os.environ.copy()
    book_env["GPUI_BOOK_SITE_BASE"] = base
    book_env["GPUI_BOOK_API_BASE"] = base + "/api/gpui/" if args.with_api else config["extra"]["api"]
    from urllib.parse import urlparse
    book_env["MDBOOK_OUTPUT__HTML__SITE_URL"] = urlparse(base).path.rstrip("/") + "/book/"
    run(mdbook, "build", str(ROOT / "book"), "--dest-dir", str(public / "book"), env=book_env)
    prepare_search_assets(public / "book")
    digest = source_digest()
    revision = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip()
    dirty = bool(subprocess.check_output(["git", "status", "--porcelain"], cwd=ROOT, text=True).strip())
    docs_prefix = f'https://docs.rs/gpui-ce/{config["extra"]["version"]}/gpui/'
    for path in public.rglob("*"):
        if not path.is_file() or path.suffix not in {".html", ".json", ".js"}:
            continue
        original = path.read_text(encoding="utf-8")
        text = callouts(original) if path.suffix == ".html" else original
        if path.suffix == ".html" and path.is_relative_to(public / "book"):
            text = accessible_chrome(text, base)
        text = text.replace("__GPUI_SOURCE_DIGEST__", digest[:12])
        text = text.replace("https://gpui-ce.github.io/", base + "/")
        if args.with_api:
            text = text.replace(docs_prefix, base + "/api/gpui/")
            if path.suffix == ".html" and not path.is_relative_to(public / "api"):
                text = text.replace(f'API {config["extra"]["version"]} ↗', "Checkout API ↗")
        if text != original:
            path.write_text(text, encoding="utf-8")
    (public / "documentation-build.json").write_text(json.dumps({
        "format": 1,
        "source_digest": digest,
        "revision": revision,
        "local_changes": dirty,
        "base_url": base,
        "api": "checkout" if args.with_api else "docs.rs",
        "browser_programs": not args.text_only,
        "editor_runtime": "browser-wasm-miri" if not args.text_only else None,
        "runtime_manifest_sha256": hashlib.sha256((public / "preview/miri/assets.json").read_bytes()).hexdigest() if not args.text_only else None,
        "book": "canonical-guides",
    }, indent=2) + "\n")
    failures = audit(public, public / "api" if args.with_api else None, base)
    if failures:
        print("\n".join(failures), file=sys.stderr)
        return 1
    print(f"Documentation built and checked: {public}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
