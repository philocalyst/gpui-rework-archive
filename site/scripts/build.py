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


def run(*command: str, env=None) -> None:
    subprocess.run(command, cwd=ROOT, env=env, check=True)


def source_digest() -> str:
    digest = hashlib.sha256()
    for directory in (ROOT / "crates", SITE / "content", SITE / "templates", SITE / "examples" / "src"):
        for path in sorted(directory.rglob("*")):
            if path.is_file() and path.suffix in {".rs", ".md", ".html", ".toml"}:
                digest.update(str(path.relative_to(ROOT)).encode())
                digest.update(path.read_bytes())
    return digest.hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--with-api", action="store_true", help="include and link to rustdoc built from this checkout")
    parser.add_argument("--base-url", help="URL where the artifact will be served; supports a path prefix")
    parser.add_argument("--text-only", action="store_true", help="omit browser programs for a prose-only review")
    args = parser.parse_args()
    config = tomllib.loads((SITE / "zola.toml").read_text())
    base = (args.base_url or config["base_url"]).rstrip("/")
    run(sys.executable, str(ROOT / "scripts/docs/generate.py"), "--check")
    run(sys.executable, str(ROOT / "scripts/docs/sync_links.py"), "--check")
    if not args.text_only:
        run(sys.executable, str(SITE / "scripts/build_preview.py"))
    if args.with_api:
        env = os.environ.copy()
        env["RUSTDOCFLAGS"] = " ".join(filter(None, [env.get("RUSTDOCFLAGS"), "-D rustdoc::broken_intra_doc_links -D rustdoc::bare_urls -D rustdoc::private_intra_doc_links -D missing_docs"]))
        run("cargo", "doc", "--locked", "--lib", "-p", "gpui-ce", "--no-deps", "--features", "test-support", env=env)
    run("zola", "--root", str(SITE), "build", "--base-url", base)
    if args.with_api:
        source = Path(os.environ.get("CARGO_TARGET_DIR", ROOT / "target")) / "doc"
        if not source.is_absolute():
            source = ROOT / source
        shutil.copytree(source, PUBLIC / "api")
        process_tree(PUBLIC / "api", SITE / "static/api-examples.json", site_base=base)
    docs_prefix = f'https://docs.rs/gpui-ce/{config["extra"]["version"]}/gpui/'
    for path in PUBLIC.rglob("*"):
        if not path.is_file() or path.suffix not in {".html", ".json", ".js"}:
            continue
        original = path.read_text(encoding="utf-8")
        text = callouts(original) if path.suffix == ".html" else original
        if args.with_api:
            text = text.replace(docs_prefix, base + "/api/gpui/")
            text = text.replace("https://gpui-ce.github.io/examples/", base + "/examples/")
            if path.suffix == ".html" and not path.is_relative_to(PUBLIC / "api"):
                text = text.replace(f'API {config["extra"]["version"]} ↗', "Checkout API ↗")
        if text != original:
            path.write_text(text, encoding="utf-8")
    (PUBLIC / "documentation-build.json").write_text(json.dumps({
        "format": 1,
        "source_digest": source_digest(),
        "base_url": base,
        "api": "checkout" if args.with_api else "docs.rs",
        "browser_programs": not args.text_only,
    }, indent=2) + "\n")
    failures = audit(PUBLIC, PUBLIC / "api" if args.with_api else None, base)
    if failures:
        print("\n".join(failures), file=sys.stderr)
        return 1
    print(f"Documentation built and checked: {PUBLIC}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
