#!/usr/bin/env python3
"""Execute every canonical component through the local real-GPUI Miri service."""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import struct
import sys
import time
import urllib.request
import uuid

ROOT = Path(__file__).resolve().parents[2]
CONTENT_TYPE = 'application/vnd.gpui.codepen-frame;version=3'


def evaluate(base, session, generation, source, *, restart=False):
    request = {
        'session_id': session, 'generation': generation, 'source': source,
        'backend': 'miri', 'restart': restart,
        'input': {'viewport': {'width': 600., 'height': 500.}, 'scale_factor': 1., 'events': [], 'elapsed_ms': 0},
    }
    response = urllib.request.urlopen(urllib.request.Request(
        base + '/api/render', json.dumps(request).encode(),
        {'Content-Type': 'application/json', 'Accept': CONTENT_TYPE}), timeout=600)
    with response:
        assert response.headers['Content-Type'] == CONTENT_TYPE
        data = response.read()
    assert data[:8] == b'GPUIREP3', 'unexpected workbench envelope'
    received, elapsed, diagnostics_len, frame_len = struct.unpack('<QQII', data[8:32])
    assert received == generation, 'stale workbench response'
    assert len(data) == 32 + diagnostics_len + frame_len, 'truncated workbench response'
    diagnostics = data[32:32 + diagnostics_len].decode()
    frame = data[32 + diagnostics_len:]
    if frame:
        assert struct.unpack('<I', frame[:4])[0] == 8, 'unexpected GPUI frame format'
    return diagnostics, frame, elapsed


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--base-url', default='http://127.0.0.1:1111')
    parser.add_argument('--example', action='append', help='check only these walkthrough slugs')
    args = parser.parse_args()
    paths = sorted((ROOT / 'site/static/components').glob('*.rs'))
    if args.example:
        paths = [path for path in paths if path.stem in args.example]
        if set(args.example) != {path.stem for path in paths}:
            parser.error('unknown walkthrough slug')
    if not paths:
        parser.error('no canonical components found; generate the walkthrough sources first')
    # Reuse one session: avoid leaving one resident interpreter per test case.
    session = str(uuid.uuid4())
    generation = 0
    failures = []
    successful_source = None
    try:
        for path in paths:
            generation += 1
            source = path.read_text()
            started = time.monotonic()
            try:
                diagnostics, frame, elapsed = evaluate(args.base_url, session, generation, source, restart=True)
                if diagnostics or not frame:
                    raise RuntimeError(diagnostics or 'no scene returned')
                successful_source = source
                print(f'{path.stem}: GPUI frame {len(frame)} bytes, {elapsed} ms ({time.monotonic() - started:.1f} s wall)', flush=True)
            except (AssertionError, RuntimeError, OSError) as error:
                failures.append(f'{path.stem}: {error}')
                print(failures[-1], file=sys.stderr, flush=True)
        # The browser separately verifies that diagnostics retain the displayed
        # frame. This check covers the interpreter's same-session recovery.
        if successful_source:
            try:
                generation += 1
                diagnostics, frame, _ = evaluate(args.base_url, session, generation, successful_source + '\ninvalid rust syntax!')
                assert diagnostics and not frame, 'invalid Rust must return diagnostics without a replacement frame'
                generation += 1
                diagnostics, frame, _ = evaluate(args.base_url, session, generation, successful_source)
                assert not diagnostics and frame, f'recovery failed: {diagnostics}'
                print('Invalid-source diagnostics and same-session recovery passed.', flush=True)
            except (AssertionError, RuntimeError, OSError) as error:
                failures.append(f'Recovery: {error}')
                print(failures[-1], file=sys.stderr, flush=True)
    finally:
        try:
            request = urllib.request.Request(args.base_url + '/api/cancel',
                json.dumps({'session_id': session, 'generation': generation}).encode(), {'Content-Type': 'application/json'})
            with urllib.request.urlopen(request, timeout=10) as response:
                assert response.status == 204
            print('Explicit cancellation passed.', flush=True)
        except (AssertionError, OSError) as error:
            failures.append(f'Cancellation: {error}')
            print(failures[-1], file=sys.stderr, flush=True)
    print(f'{len(paths)} components checked; {len(failures)} failures.', flush=True)
    return bool(failures)


if __name__ == '__main__':
    raise SystemExit(main())
