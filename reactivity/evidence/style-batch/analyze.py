#!/usr/bin/env python3
"""Summarize every captured cell without selecting or rerunning samples."""
import csv
from collections import defaultdict
import json
from pathlib import Path
from statistics import median

ROOT = Path(__file__).resolve().parent


def write(name, fields, rows):
    with (ROOT / name).open('w') as stream:
        writer = csv.DictWriter(stream, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)


def costs(kind):
    rows = []
    for path in sorted((ROOT / 'captures' / f'{kind}-first').glob('round-*.txt')):
        _, repetition, variant = path.stem.split('-')
        for line in path.read_text().splitlines():
            values = next(csv.reader([line]))
            if not values or values[0] not in ['cost', 'phase']:
                continue
            if kind == 'literal':
                _, phase, case, rounds, ns, requests, cumulative, net, peak = values
                count = ''
            else:
                _, phase, case, count, rounds, ns, requests, cumulative, net, peak = values
            rows.append(dict(variant=variant, repetition=int(repetition), phase=phase,
                             case=case, count=count, rounds=int(rounds), total_ns=int(ns),
                             ns_per_operation=int(ns)/int(rounds), requests=int(requests),
                             cumulative_bytes=int(cumulative), net_bytes=int(net),
                             peak_net_bytes=int(peak)))
    return rows


def summarize(rows):
    groups = defaultdict(list)
    for row in rows:
        groups[(row['phase'], row['case'], row['count'], row['variant'])].append(row)
    result = []
    metrics = ['ns_per_operation', 'requests', 'cumulative_bytes', 'net_bytes', 'peak_net_bytes']
    for (phase, case, count, variant), samples in sorted(groups.items()):
        assert len(samples) == 3
        row = dict(phase=phase, case=case, count=count, variant=variant, samples=len(samples))
        for metric in metrics:
            row[metric + '_median'] = median(sample[metric] for sample in samples)
            row[metric + '_min'] = min(sample[metric] for sample in samples)
            row[metric + '_max'] = max(sample[metric] for sample in samples)
        result.append(row)
    return result


def comparisons(summary, target, bases):
    cells = {(row['phase'], row['case'], row['count'], row['variant']): row for row in summary}
    result = []
    for row in summary:
        if row['variant'] != target:
            continue
        for base in bases:
            before = cells[(row['phase'], row['case'], row['count'], base)]
            a, b = before['ns_per_operation_median'], row['ns_per_operation_median']
            result.append(dict(phase=row['phase'], case=row['case'], count=row['count'],
                               baseline=base, candidate=target, baseline_ns=a,
                               candidate_ns=b, percent=(b/a-1)*100))
    return result


def main():
    for kind, target, bases in [('literal', 'compact', ['f019']),
                                 ('phase', 'batch', ['compact', 'counted'])]:
        raw = costs(kind)
        write(kind + '-costs.csv', list(raw[0]), raw)
        summary = summarize(raw)
        write(kind + '-summary.csv', list(summary[0]), summary)
        comparison = comparisons(summary, target, bases)
        write(kind + '-comparisons.csv', list(comparison[0]), comparison)
        losses = sorted((row for row in comparison if row['percent'] > 0),
                        key=lambda row: -row['percent'])
        write(kind + '-latency-losses.csv', list(comparison[0]), losses)
        cells = {(row['phase'], row['case'], row['count'], row['variant']): row for row in summary}
        allocation_losses = []
        for row in summary:
            if row['variant'] != target:
                continue
            for base in bases:
                before = cells[(row['phase'], row['case'], row['count'], base)]
                for metric in ['requests', 'cumulative_bytes', 'net_bytes', 'peak_net_bytes']:
                    a, b = before[metric + '_median'], row[metric + '_median']
                    if b > a:
                        allocation_losses.append(dict(phase=row['phase'], case=row['case'],
                                                      count=row['count'], baseline=base,
                                                      candidate=target, metric=metric,
                                                      baseline_value=a, candidate_value=b,
                                                      absolute_increase=b-a))
        fields = ['phase', 'case', 'count', 'baseline', 'candidate', 'metric',
                  'baseline_value', 'candidate_value', 'absolute_increase']
        write(kind + '-allocation-losses.csv', fields, allocation_losses)

    retained = []
    for path in sorted((ROOT / 'captures' / 'phase-first').glob('round-*.txt')):
        _, repetition, variant = path.stem.split('-')
        for line in path.read_text().splitlines():
            values = next(csv.reader([line]))
            if values and values[0] == 'after':
                _, phase, case, count, mode, size, slots, entry, digest, patches, sinks, runtime, lane = values
                retained.append(dict(variant=variant, repetition=int(repetition), phase=phase,
                                     case=case, count=int(count), mode=mode, retained_style_bytes=int(size),
                                     resident_slots=int(slots), entry_bytes=int(entry), digest=digest,
                                     patches=int(patches), sinks=int(sinks), runtime_bytes=int(runtime),
                                     style_lane_header_bytes=int(lane)))
    write('phase-retained.csv', list(retained[0]), retained)

    pressure = []
    for kind in ['literal', 'phase']:
        for point in ['before', 'after']:
            path = ROOT / 'captures' / (kind + '-first') / ('environment-' + point + '.json')
            data = json.loads(path.read_text())
            for category in ['cpu_pressure', 'io_pressure', 'memory_pressure']:
                for line in data[category].splitlines():
                    mode, *fields = line.split()
                    pressure.append(dict(campaign=kind, point=point, time_utc=data['time_utc'],
                                         category=category, mode=mode,
                                         **dict(field.split('=') for field in fields)))
    write('pressure.csv', list(pressure[0]), pressure)


if __name__ == '__main__':
    main()
