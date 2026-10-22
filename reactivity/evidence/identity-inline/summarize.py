#!/usr/bin/env python3
"""Retain all four normalized owner samples and every allocation field."""
import csv
import json
from pathlib import Path
import statistics

HERE = Path(__file__).resolve().parent
samples = {}
oracle = None
for path in sorted((HERE / 'capture').glob('owner-*.txt')):
    fields = list(csv.reader(path.read_text().splitlines()))
    current = sorted(','.join(row) for row in fields if row and row[0] == 'guard')
    if oracle is None:
        oracle = current
    assert current == oracle, path
    tag = path.stem.split('-')[-1]
    for row in fields:
        if row and row[0] == 'cost':
            key = row[1], int(row[2]), tag
            samples.setdefault(key, []).append([int(value) for value in row[3:]])
for (phase, count, tag), rows in samples.items():
    if tag == 'inline':
        assert [r[2:] for r in rows] == [r[2:] for r in samples[phase, count, 'runs']]
result = []
for (phase, count, tag), rows in sorted(samples.items()):
    assert len(rows) == 4
    times = [r[1] / r[0] for r in rows]
    median = statistics.median(times)
    record = {'phase': phase, 'count': count, 'variant': tag,
              'median_ns': median, 'min_ns': min(times), 'max_ns': max(times),
              'ns_per_operation': times, 'samples': rows}
    for reference in ['baseline', 'packed', 'runs']:
        old = statistics.median(r[1] / r[0] for r in samples[phase, count, reference])
        record[f'versus_{reference}_percent'] = 100 * (median / old - 1)
    result.append(record)
assert sum(len(r['samples']) for r in result) == 576
(HERE / 'summary.json').write_text(json.dumps(result, indent=2) + '\n')
keys = ['phase', 'count', 'variant', 'median_ns', 'min_ns', 'max_ns',
        'versus_baseline_percent', 'versus_packed_percent', 'versus_runs_percent']
with (HERE / 'summary.csv').open('w') as stream:
    writer = csv.DictWriter(stream, fieldnames=keys, lineterminator='\n')
    writer.writeheader()
    for row in result:
        writer.writerow({k: row[k] for k in keys})
print('ALL576ROWS_RETAINED; normalized complete cross-round oracles agree')
