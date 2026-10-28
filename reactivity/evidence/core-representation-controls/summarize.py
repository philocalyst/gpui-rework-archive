#!/usr/bin/env python3
"""Verify archived bytes and report every captured phase, including losses."""
import gzip
import hashlib
import json
from pathlib import Path
import statistics

ROOT = Path(__file__).resolve().parent


def read(path):
    if path.exists():
        return path.read_text()
    return gzip.decompress(path.with_suffix(path.suffix + '.gz').read_bytes()).decode()


def summarize(campaign, group):
    root = ROOT / campaign / group
    runs = json.loads(read(root / 'runs.json'))
    rows = []
    for run in runs:
        for line in read(root / run['log']).splitlines():
            markers = ['phase,'] if group == 'raster' else ['query,', 'mount,']
            for marker in markers:
                if marker not in line:
                    continue
                parts = line[line.index(marker):].split(',')
                values = dict(s.split('=', 1) for s in parts[2 if group == 'raster' else 1:])
                keys = ['scene', 'count'] + (['kind'] if parts[0] == 'query' else [])
                phase = parts[1] if group == 'raster' else ','.join([parts[0]] + [values[k] for k in keys])
                numeric = {k: int(v) for k, v in values.items() if k not in ['scene', 'count', 'kind']}
                rows.append(dict(label=run['label'], repeat=run['repeat'], phase=phase, **numeric))
    result = {}
    for row in rows:
        key = row['phase']
        result.setdefault(key, {}).setdefault(row['label'], []).append(row)
    for phase, labels in result.items():
        for label, samples in labels.items():
            assert len(samples) == 3, (phase, label)
            times = [s['total_ns'] / s['iterations'] for s in samples]
            allocations = [{k: s[k] for k in s if k not in
                            ['phase', 'label', 'repeat', 'total_ns', 'iterations', 'ns_each']} for s in samples]
            assert all(a == allocations[0] for a in allocations)
            labels[label] = dict(median_ns=statistics.median(times), samples_ns=times,
                                 allocations=allocations[0])
        if group == 'hit':
            assert len({json.dumps(s['allocations'], sort_keys=True) for s in labels.values()}) == 1
    return dict(rows=len(rows), phases=result)


if __name__ == '__main__':
    for path, checksum in json.loads((ROOT / 'RAW_SHA256.json').read_text()).items():
        assert hashlib.sha256(gzip.decompress((ROOT / path).read_bytes())).hexdigest() == checksum, path
    result = {campaign: {group: summarize(campaign, group) for group in ['raster', 'hit']}
              for campaign in ['second', 'third']}
    assert [result[c][g]['rows'] for c in result for g in result[c]] == [105, 216, 84, 216]
    print(json.dumps(result, indent=2))
