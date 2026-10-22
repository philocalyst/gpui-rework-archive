#!/usr/bin/env python3
"""Recompute all operation distributions and allocation totals from raw stdout."""
import csv
import json
from pathlib import Path
import statistics

HERE = Path(__file__).resolve().parent
rows = {}
for path in sorted((HERE / 'capture').glob('round-*.txt')):
    tag = path.stem.split('-', 2)[2]
    for fields in csv.reader(path.read_text().splitlines()):
        if fields and fields[0] == 'cost':
            rows.setdefault((fields[1], fields[2], tag), []).append([int(value) for value in fields[3:]])
result = []
for kind, name in sorted({(kind, name) for kind, name, _ in rows}):
    values = {}
    for tag in ['f019', 'baseline', 'candidate']:
        samples = rows[kind, name, tag]
        assert len(samples) == 3
        times = [sample[1] / sample[0] for sample in samples]
        values[tag] = {'median_ns': statistics.median(times), 'min_ns': min(times), 'max_ns': max(times),
                       'samples': samples, 'ns_per_operation': times}
    baseline = values['baseline']['median_ns']
    candidate = values['candidate']['median_ns']
    result.append({'kind': kind, 'case': name, 'values': values,
                   'candidate_vs_baseline_percent': 100 * (candidate / baseline - 1),
                   'candidate_vs_f019_percent': 100 * (candidate / values['f019']['median_ns'] - 1)})
(HERE / 'summary.json').write_text(json.dumps(result, indent=2) + '\n')
with (HERE / 'summary.csv').open('w') as stream:
    writer = csv.writer(stream, lineterminator="\n")
    writer.writerow(['kind', 'case', 'variant', 'samples', 'median_ns', 'min_ns', 'max_ns', 'candidate_vs_baseline_percent', 'candidate_vs_f019_percent'])
    for row in result:
        for tag, values in row['values'].items():
            writer.writerow([row['kind'], row['case'], tag, 3, values['median_ns'], values['min_ns'], values['max_ns'], row['candidate_vs_baseline_percent'], row['candidate_vs_f019_percent']])
print('12 cases, 108 cost rows; all samples retained')
