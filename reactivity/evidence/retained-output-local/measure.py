#!/usr/bin/env python3
"""Paired renderer ablation. Preserve raw failures; validate equal work and pixels."""
import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
import platform
import statistics
import subprocess
import time

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--binary', type=Path, required=True)
parser.add_argument('--output', type=Path, required=True)
parser.add_argument('--source', type=Path, required=True)
parser.add_argument('--repeats', type=int, default=5)
parser.add_argument('--frames', type=int, default=60)
args = parser.parse_args()
if args.repeats < 3 or args.frames < 10:
    parser.error('require at least three processes and ten paired frames')
args.output.mkdir(parents=True, exist_ok=False)
args.binary = args.binary.resolve()
def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
metadata = {
    'binary': str(args.binary), 'binary_sha256': digest(args.binary),
    'source_commit': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=args.source, text=True).strip(),
    'uname': platform.uname()._asdict(),
    'cpuinfo': Path('/proc/cpuinfo').read_text(),
    'environment': {k: os.environ.get(k) for k in ['LP_NUM_THREADS', 'VK_ICD_FILENAMES', 'XDG_RUNTIME_DIR', 'DISPLAY', 'RUSTFLAGS']},
    'frames': args.frames, 'repeats': args.repeats,
    'started_utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
    'command': [str(args.binary), str(args.frames)],
    'endpoint': 'paired submission and submission plus device poll wall microseconds; no GPU timestamps or scanout',
}
(args.output / 'metadata.json').write_text(json.dumps(metadata, indent=2) + '\n')
cases = ['flat-sparse', 'text-sparse', 'overlap-sparse', 'text-full', 'text-exposure']
by_case = {case: [] for case in cases}
for repeat in range(args.repeats):
    with (args.output / f'{repeat}.csv').open('w') as out, (args.output / f'{repeat}.log').open('w') as err:
        result = subprocess.run(metadata['command'], stdout=out, stderr=err)
    (args.output / f'{repeat}.status.json').write_text(json.dumps({'returncode': result.returncode}) + '\n')
    if result.returncode:
        raise RuntimeError(f'failed repeat {repeat}; raw output preserved')
    rows = list(csv.DictReader((args.output / f'{repeat}.csv').open()))
    assert len(rows) == len(cases) * args.frames
    for case in cases:
        selected = [r for r in rows if r['case'] == case]
        assert [int(r['pair']) for r in selected] == list(range(args.frames))
        for r in selected:
            assert int(r['order']) == int(r['pair']) % 2
            assert int(r['copied_pixels']) == 512 * 256
            assert int(r['image_bytes']) == 512 * 256 * 4
            work = int(r['composited_pixels'])
            if case.endswith('sparse'):
                assert work == 140
            else:
                assert work == (0 if case.endswith('exposure') else 512 * 256)
        record = {'repeat': repeat}
        for metric in ['full_host_us', 'retained_host_us', 'full_complete_us', 'retained_complete_us']:
            values = sorted(float(r[metric]) for r in selected)
            assert all(v > 0 for v in values)
            record[metric] = statistics.median(values)
            record[metric + '_p90'] = values[int(.9 * (len(values) - 1))]
        record['complete_ratio'] = record['retained_complete_us'] / record['full_complete_us']
        by_case[case].append(record)
    assert digest(args.binary) == metadata['binary_sha256'], 'binary changed during run'
summary = {}
for case, rows in by_case.items():
    summary[case] = {
        'processes': rows,
        'median_full_us': statistics.median(r['full_complete_us'] for r in rows),
        'median_retained_us': statistics.median(r['retained_complete_us'] for r in rows),
        'median_ratio': statistics.median(r['complete_ratio'] for r in rows),
        'ratio_range': [min(r['complete_ratio'] for r in rows), max(r['complete_ratio'] for r in rows)],
    }
(args.output / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
for case, row in summary.items():
    print(f"{case}: {row['median_full_us']:.2f} -> {row['median_retained_us']:.2f} us; ratio {row['median_ratio']:.3f}; range {row['ratio_range']}")
