#!/usr/bin/env python3
"""Bundle the Rust editor and its dependencies as local static assets."""
import hashlib
import json
from pathlib import Path
import subprocess

SITE = Path(__file__).resolve().parents[1]


def main():
    inputs = sorted(path for path in (SITE / 'editor').rglob('*') if path.is_file()) + [SITE / 'package.json', SITE / 'package-lock.json']
    digest = hashlib.sha256()
    for path in inputs:
        digest.update(path.name.encode() + b'\0' + path.read_bytes())
    fingerprint = digest.hexdigest()
    metadata = SITE / 'static/workbench/editor-build.json'
    outputs = ('editor.js', 'index.html', 'workbench.css', 'licenses.txt')
    if metadata.exists() and all((metadata.parent / name).is_file() for name in outputs):
        try:
            if json.loads(metadata.read_text()).get('digest') == fingerprint:
                return 0
        except (OSError, ValueError):
            pass
    lock_digest = hashlib.sha256((SITE / 'package-lock.json').read_bytes()).hexdigest()
    installed = SITE / 'node_modules/.documentation-lock'
    if not (SITE / 'node_modules/esbuild').exists() or not installed.exists() or installed.read_text() != lock_digest:
        subprocess.run(['npm', 'ci', '--ignore-scripts', '--no-fund', '--no-audit'], cwd=SITE, check=True)
        installed.write_text(lock_digest)
    subprocess.run(['npm', 'run', 'build:editor'], cwd=SITE, check=True)
    metadata.write_text(json.dumps({'digest': fingerprint}) + '\n')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
