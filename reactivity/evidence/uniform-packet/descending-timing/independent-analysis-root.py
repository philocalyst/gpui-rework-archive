from pathlib import Path
import csv
import json
import math
import re
import statistics

root = Path('/tmp/gpui-descending-timing-evidence/measure')
destination = Path('/root/gpui-ce3/reactivity/evidence/uniform-packet/descending-timing')
metrics = ('host_submit_ns', 'total_ns')
samples = {}
capacity = re.compile(r'cpu_index_capacity_bytes: (\d+)')
paired_work = 0
for pair in range(11):
    lanes = {}
    for lane in ('A', 'B'):
        path = root / f'pair-{pair:02d}-{lane}' / 'frames.csv'
        rows = list(csv.DictReader(path.open()))
        assert len(rows) == 26 * 12
        groups = {}
        for row in rows:
            key = '/'.join(row[k] for k in ('case', 'hdr', 'motion'))
            groups.setdefault(key, []).append(row)
        assert len(groups) == 26
        for key, group in groups.items():
            assert [int(r['frame']) for r in group] == list(range(12))
            assert [r['sampled'] for r in group] == ['false'] * 3 + ['true'] * 9
            samples[pair, lane, key] = group[3:]
        lanes[lane] = rows
    for a, b in zip(lanes['A'], lanes['B'], strict=True):
        for field in ('case', 'hdr', 'motion', 'frame', 'sampled', 'image_stats'):
            assert a[field] == b[field]
        assert capacity.sub('cpu_index_capacity_bytes: INTENDED', a['stats']) == capacity.sub('cpu_index_capacity_bytes: INTENDED', b['stats'])
        assert int(capacity.search(a['stats'])[1]) - int(capacity.search(b['stats'])[1]) == 2048
        paired_work += 1
keys = sorted({key for _, _, key in samples})
ledger = {}
rule_counts = {'nine_slower_pairs': 0, 'ninth_ratio_above_1.01': 0, 'frame_tail_above_1.10': 0}
for key in keys:
    for metric in metrics:
        ratios, tails = [], []
        for pair in range(11):
            a = [int(r[metric]) for r in samples[pair, 'A', key]]
            b = [int(r[metric]) for r in samples[pair, 'B', key]]
            ratios.append(statistics.median(b) / statistics.median(a))
            tails.append(max(b) / max(a))
        failures = []
        for name, failed in [('nine_slower_pairs', sum(r > 1 for r in ratios) >= 9), ('ninth_ratio_above_1.01', sorted(ratios)[8] > 1.01), ('frame_tail_above_1.10', max(tails) > 1.10)]:
            if failed:
                failures.append(name)
                rule_counts[name] += 1
        ledger[key, metric] = {'cell': key, 'metric': metric, 'median_ratio': statistics.median(ratios), 'slower_pairs': sum(r > 1 for r in ratios), 'ninth_sorted_ratio': sorted(ratios)[8], 'worst_maximum_frame_ratio': max(tails), 'pass': not failures, 'failed_rules': failures}
agent_rows = list(csv.DictReader((root / 'per-cell-gate-ledger.csv').open()))
assert len(agent_rows) == len(ledger) == 52
for row in agent_rows:
    independent = ledger[row['cell'], row['metric']]
    assert independent['pass'] == (row['regression_pass'] == 'True')
    for field in ('median_ratio', 'ninth_sorted_ratio', 'worst_maximum_frame_ratio'):
        assert math.isclose(independent[field], float(row[field]), rel_tol=1e-12)
    assert independent['slower_pairs'] == int(row['slower_pairs'])
aggregates = {}
for metric in metrics:
    values = []
    for pair in range(11):
        ratios = [statistics.median(int(r[metric]) for r in samples[pair, 'B', key]) / statistics.median(int(r[metric]) for r in samples[pair, 'A', key]) for key in keys]
        values.append(math.exp(math.fsum(math.log(r) for r in ratios) / len(ratios)))
    aggregates[metric] = {'median_ratio': statistics.median(values), 'faster_pairs': sum(value < 1 for value in values)}
assert paired_work == 3432 and sum(rule_counts.values()) == 93
report = {'source': '1c97566cf0a7140d4f258deab136342a609d5755', 'raw_processes': 22, 'raw_frames': 6864, 'paired_work_rows': paired_work, 'cells': 26, 'independent_metric_cell_checks': 52, 'regression_rule_counts': rule_counts, 'aggregates': aggregates, 'regression_pass': False, 'adopted': False, 'independent_source': 'Reparsed raw CSVs without importing agent analyzers; medians/maximums/per-cell thresholds and work equality independently recomputed.', 'ledger': list(ledger.values())}
(destination / 'root-independent-analysis.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps({key: value for key,value in report.items() if key != 'ledger'}), flush=True)
