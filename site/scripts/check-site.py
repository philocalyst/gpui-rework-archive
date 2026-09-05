#!/usr/bin/env python3
"""Audit the actual Zola output without third-party dependencies."""
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urlparse, unquote
import collections
import hashlib
import json
import re
import sys

site = Path(__file__).resolve().parents[1]
public = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else site / 'public'
errors = []

class Document(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.ids = []
        self.links = []
        self.tags = collections.Counter()
        self.lang = None
        self.stack = []
        self.in_code = 0
        self.code_blocks = []
        self.code_text = ""
    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        self.tags[tag] += 1
        if tag == 'pre':
            self.in_code += 1
            self.code_text = ''
        if tag == 'html': self.lang = attrs.get('lang')
        if attrs.get('id'): self.ids.append(attrs['id'])
        for attr in ['href', 'src']:
            if attrs.get(attr): self.links.append((tag, attrs[attr]))
        if tag == 'iframe' and not attrs.get('title'):
            errors.append(f'{path}: iframe needs an accessible title')
        if tag == 'img' and 'alt' not in attrs:
            errors.append(f'{path}: image needs alternative text')

    def handle_data(self, data):
        if self.in_code: self.code_text += data
    def handle_endtag(self, tag):
        if tag == 'pre':
            self.in_code = max(0, self.in_code - 1)
            self.code_blocks.append(hashlib.sha256(self.code_text.strip().encode()).hexdigest())

pages = {}
for path in sorted(public.rglob('*.html')):
    doc = Document()
    doc.feed(path.read_text())
    pages[path] = doc
    if len(doc.ids) != len(set(doc.ids)): errors.append(f'{path}: duplicate IDs')
    # GPUI's isolated canvas document and legacy redirects do not use the publication shell.
    if 'components' in path.parts or 'http-equiv="refresh"' in path.read_text().lower(): continue
    if doc.lang != 'en': errors.append(f'{path}: missing language')
    if doc.tags['main'] != 1: errors.append(f'{path}: expected exactly one main')
    if doc.tags['h1'] != 1: errors.append(f'{path}: expected exactly one h1')
    if doc.tags['div']: errors.append(f'{path}: unexpected generic div wrapper')
    if path.name != '404.html' and '<title>' not in path.read_text(): errors.append(f'{path}: missing title')

for path, doc in pages.items():
    for tag, href in doc.links:
        url = urlparse(href)
        if url.scheme in {'mailto', 'data', 'javascript', 'tel'}: continue
        if url.netloc and url.hostname not in {'gpui-ce.github.io', 'localhost', '127.0.0.1'}: continue
        local = unquote(url.path)
        target = public / local.lstrip('/') if local.startswith('/') else path.parent / local
        if not local: target = path
        if target.is_dir(): target /= 'index.html'
        target = target.resolve()
        if not target.exists():
            errors.append(f'{path.relative_to(public)}: missing {tag} target {href}')
        elif url.fragment and target in pages and unquote(url.fragment) not in pages[target].ids:
            errors.append(f'{path.relative_to(public)}: missing anchor {href}')

manifest = json.loads((site/'migration-manifest.json').read_text())
for entry in manifest:
    dest = site.parent / entry['markdown']
    if not dest.is_file(): errors.append(f'Missing migrated chapter: {dest}')
    relative = dest.relative_to(site/'content').with_suffix('')
    rendered = pages.get((public/relative/'index.html').resolve())
    if rendered:
        expected = collections.Counter(entry.get('code_sha256', []))
        missing = expected - collections.Counter(rendered.code_blocks)
        if missing: errors.append(f'{relative}: {sum(missing.values())} original source blocks changed or missing')
    else: errors.append(f'Missing published chapter: {relative}')
for css in (site/'static').rglob('*.css'):
    if '@media' in css.read_text(): errors.append(f'{css}: unexpected CSS media query')
    if re.search(r'#[0-9a-fA-F]{3,8}\b|\brgba?\(|\bhsla?\(', css.read_text()):
        errors.append(f'{css}: authored CSS must use OKLCH colors')
fingerprints = site/'wasm-build-manifest.json'
if fingerprints.exists():
    for relative, expected in json.loads(fingerprints.read_text()).items():
        artifact = site/relative
        if not artifact.exists() or hashlib.sha256(artifact.read_bytes()).hexdigest() != expected:
            errors.append(f'{relative}: stale WASM source/distribution; run scripts/build-wasm.sh')
else:
    errors.append('Missing WASM source/distribution fingerprints')
if errors:
    print('\n'.join(errors))
    raise SystemExit(1)
print(f'Checked {len(pages)} HTML documents, local links and anchors, {len(manifest)} recovered pages, semantic structure, and authored CSS.')
