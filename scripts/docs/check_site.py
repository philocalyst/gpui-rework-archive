#!/usr/bin/env python3
"""Check the generated site's links, anchors, downloads, and preview artifacts."""
from __future__ import annotations

import argparse
from html.parser import HTMLParser
import json
from pathlib import Path
import re
import sys
from urllib.parse import unquote, urlparse


class Document(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.links = []
        self.ids = []
        self.tags = {}
        self.redirect = None
        self.errors = []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        self.tags[tag] = self.tags.get(tag, 0) + 1
        if attrs.get('id'):
            self.ids.append(attrs['id'])
        for attr in ('href', 'src'):
            if attrs.get(attr):
                self.links.append(attrs[attr])
        if tag == 'iframe' and not attrs.get('title'):
            self.errors.append('iframe needs a title')
        if tag == 'meta' and attrs.get('http-equiv', '').lower() == 'refresh':
            match = re.search(r'url=(.*)', attrs.get('content', ''), re.I)
            if match:
                self.redirect = match[1].strip().strip('\"\'')
                self.links.append(self.redirect)


def audit(public: Path, rustdoc: Path | None = None, base_url='https://gpui-ce.github.io') -> list[str]:
    public = public.resolve()
    rustdoc = rustdoc.resolve() if rustdoc else None
    base = urlparse(base_url)
    prefix = base.path.rstrip('/')
    cache = {}
    errors = []

    def document(path):
        path = path.resolve()
        if path not in cache:
            doc = Document()
            doc.feed(path.read_text(encoding='utf-8'))
            cache[path] = doc
        return cache[path]

    def resolve(path, href):
        url = urlparse(href)
        if url.scheme in {'mailto', 'tel', 'data'}:
            return None, None
        if url.scheme == 'javascript':
            errors.append(f'{path}: javascript link {href}')
            return None, None
        if url.netloc and url.netloc != base.netloc:
            if url.hostname == 'docs.rs' and url.path.startswith('/gpui-ce/') and rustdoc:
                segments = url.path.strip('/').split('/')
                target = (rustdoc / '/'.join(segments[2:])).resolve()
                if target.is_dir() or url.path.endswith('/'):
                    target /= 'index.html'
                return target, unquote(url.fragment)
            return None, None
        route = unquote(url.path)
        if route.startswith('/'):
            if prefix and route != prefix and not route.startswith(prefix + '/'):
                errors.append(f'{path}: link escapes base URL prefix: {href}')
                return None, None
            route = route[len(prefix):] if prefix else route
            target = public / route.lstrip('/')
        elif route:
            target = path.parent / route
        else:
            target = path
        target = target.resolve()
        if not target.is_relative_to(public):
            errors.append(f'{path}: link escapes artifact: {href}')
            return None, None
        if target.is_dir() or route.endswith('/'):
            target /= 'index.html'
        # Zola get_url can omit a trailing slash. The server adds it for directories.
        return target, unquote(url.fragment)

    def check_link(path, href):
        target, fragment = resolve(path, href)
        if target is None:
            return
        if not target.is_file():
            errors.append(f'{path}: missing {href}')
        elif fragment and target.suffix == '.html':
            # Preview fragments select a program rather than an HTML anchor.
            if target in {public / 'preview/index.html', public / 'workbench/index.html'}:
                return
            if fragment not in document(target).ids:
                errors.append(f'{path}: missing anchor {href}')

    guides = [p for p in public.rglob('*.html') if not p.is_relative_to(public / 'api') and not p.is_relative_to(public / 'preview')]
    for path in guides:
        doc = document(path)
        errors.extend(f'{path}: {error}' for error in doc.errors)
        if len(doc.ids) != len(set(doc.ids)):
            errors.append(f'{path}: duplicate ids')
        book_auxiliary = path in {public / 'book/toc.html', public / 'book/print.html'}
        if not doc.redirect and not book_auxiliary:
            if doc.tags.get('main') != 1:
                errors.append(f'{path}: expected one main')
            if doc.tags.get('h1') != 1:
                errors.append(f'{path}: expected one h1')
        for href in doc.links:
            check_link(path, href)

    index = public / 'api-examples.json'
    if not index.is_file():
        errors.append(f'{index}: missing API/example index')
    else:
        try:
            data = json.loads(index.read_text())
            for symbol, item in data.items():
                check_link(index, item['docs'])
                for row in item['examples']:
                    # Manifest routes are independent of the publication prefix.
                    check_link(index, base_url.rstrip('/') + row['url'])
        except (OSError, ValueError, KeyError) as error:
            errors.append(f'{index}: invalid API/example index: {error}')

    metadata = public / 'documentation-build.json'
    if not metadata.is_file():
        errors.append(f'{metadata}: missing build identity')
    else:
        try:
            build = json.loads(metadata.read_text())
            if build['browser_programs']:
                preview = public / 'preview'
                bundle = json.loads((preview / 'build.json').read_text())
                for field in ('entry', 'wasm'):
                    file = (preview / 'pkg' / bundle[field]).resolve()
                    if not file.is_relative_to(preview / 'pkg') or not file.is_file():
                        errors.append(f'{preview}: missing preview {field}')
                wasm = preview / 'pkg' / bundle['wasm']
                if wasm.is_file() and wasm.read_bytes()[:4] != b'\0asm':
                    errors.append(f'{wasm}: invalid WebAssembly artifact')
                for name in ('index.html', 'editor.js', 'workbench.css', 'editor-build.json', 'licenses.txt'):
                    if not (public / 'workbench' / name).is_file():
                        errors.append(f'{public / "workbench"}: missing editor artifact {name}')
        except (OSError, ValueError, KeyError) as error:
            errors.append(f'{metadata}: invalid build artifacts: {error}')
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('public', type=Path)
    parser.add_argument('--rustdoc', type=Path)
    parser.add_argument('--base-url', default='https://gpui-ce.github.io')
    args = parser.parse_args()
    failures = audit(args.public, args.rustdoc, args.base_url)
    if failures:
        print('\n'.join(failures), file=sys.stderr)
        return 1
    print('Site links and artifacts passed.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
