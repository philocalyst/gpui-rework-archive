#!/usr/bin/env python3
"""Independently audit the local dossier; no adoption verdict is inferred."""
import argparse
import csv
import hashlib
import json
import math
from pathlib import Path
import re
import statistics

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--external-artifacts', action='store_true')
args = parser.parse_args()
root = Path(__file__).resolve().parent
read = lambda name: json.loads((root / name).read_text())
digest = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
manifest = read('manifest.json')
for name, expected in manifest.items():
    path = root / name
    assert path.is_file(), name
    assert path.stat().st_size == expected['bytes'], name
    assert digest(path) == expected['sha256'], name
summary = read('raw/paired/summary.json')
metadata = read('raw/paired/metadata.json')
assert metadata['repeats'] == 5 and metadata['frames'] == 60
quantiles = read('raw/paired/quantiles.json')['cells']
metrics = ['full_host_us', 'retained_host_us', 'full_complete_us', 'retained_complete_us']
pairs = 0
for repeat in range(metadata['repeats']):
    assert read(f'raw/paired/{repeat}.status.json')['returncode'] == 0
    rows = list(csv.DictReader((root / f'raw/paired/{repeat}.csv').open()))
    assert len(rows) == 300
    assert set(r['case'] for r in rows) == set(summary)
    for case, result in summary.items():
        cell = [r for r in rows if r['case'] == case]
        assert [int(r['pair']) for r in cell] == list(range(60))
        expected = result['processes'][repeat]
        tail = next(q for q in quantiles if q['case'] == case and q['repeat'] == repeat)
        pairs += len(cell)
        for r in cell:
            assert int(r['order']) == int(r['pair']) % 2
            assert int(r['composited_pixels']) == (140 if case.endswith('sparse') else 0 if case.endswith('exposure') else 131072)
            assert int(r['copied_pixels']) == 131072 and int(r['image_bytes']) == 524288
        for key in metrics:
            values = sorted(float(r[key]) for r in cell)
            assert all(v > 0 and math.isfinite(v) for v in values)
            assert statistics.median(values) == expected[key] == tail[key]['p50']
            assert tail[key]['p95'] == values[math.ceil(.95 * len(values)) - 1]
            assert tail[key]['p99'] == values[math.ceil(.99 * len(values)) - 1]
        assert expected['complete_ratio'] == expected['retained_complete_us'] / expected['full_complete_us']
for case, result in summary.items():
    ratios = [r['complete_ratio'] for r in result['processes']]
    assert statistics.median(ratios) == result['median_ratio']
    assert [min(ratios), max(ratios)] == result['ratio_range']
assert pairs == 1500
checks = read('qualification.json')
for check in checks['checks']:
    log = (root / check['log']).read_text()
    rows = re.findall(r'test result: (?:ok|FAILED)\. (\d+) passed; (\d+) failed; (\d+) ignored', log)
    if 'passed' in check:
        assert sum(int(r[0]) for r in rows) == check['passed']
        assert sum(int(r[1]) for r in rows) == check['failed']
        assert sum(int(r[2]) for r in rows) == check['ignored']
        assert check['passed'] > 0 or check['name'] == 'negative-control'
    else:
        assert 'Finished `dev` profile' in log and 'error:' not in log
    if check['name'] == 'negative-control':
        assert check['failed'] == 1 and check['exit_code'] != 0
        assert 'assertion `left == right` failed' in log
    else:
        assert check['exit_code'] == 0 and check.get('failed', 0) == 0
assert read('static/candidate-lines.json')['core_non_test_code_lines'] - read('static/baseline-lines.json')['core_non_test_code_lines'] == 328
identity = read('qualification/rebuild-identity.json')
assert identity['identical'] and identity['restored_sha256'] == identity['rebuilt_sha256'] == metadata['binary_sha256']
assert read('qualification/inputs-verified.json')['changed'] == []
if args.external_artifacts:
    for row in read('external-artifacts.json'):
        p = Path(row['path'])
        assert p.stat().st_size == row['bytes'] and digest(p) == row['sha256'], str(p)
print(f'PASS: {len(manifest)} payload hashes, {pairs} measured pairs, all recorded checks, deliberate pixel failure and source costs. Experiment remains unadopted.')
