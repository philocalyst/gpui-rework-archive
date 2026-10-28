from pathlib import Path
import hashlib, json, math, statistics

base = Path(__file__).parent
regpath = base / 'timing-final-registration.json'
reg = json.loads(regpath.read_text())
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
assert sha(Path(__file__)) == reg['analysis_runner_sha256']
out = base / 'timing-final-capture'
capture = json.loads((out / 'metadata.json').read_text())
assert capture['registration_sha256'] == sha(regpath)
complete = capture['status'].startswith('complete;')
records = {}
for item in capture['observations']:
    if item.get('observable_guard') == 'PASS':
        assert sha(Path(item['log'])) == item['log_sha256']
        key = item['pair'], item['cell_id'], item['label']
        assert key not in records
        records[key] = item['raw_output']

cells = []
def metrics(value, cell):
    if cell['kind'] == 'ordinary':
        return {'elapsed_ns/count': value['elapsed_ns'] / cell['count']}
    result = {}
    for field, name in [('elapsed_ns', 'cycle'), ('host_ack_elapsed_ns', 'host_ack')]:
        values = sorted(value[field])
        assert len(values) == 128
        result['median_' + name + '_ns'] = statistics.median(values)
        result['p95_' + name + '_ns'] = values[math.ceil(.95 * len(values)) - 1]
        result['p99_' + name + '_ns'] = values[math.ceil(.99 * len(values)) - 1]
        result['max_' + name + '_ns'] = values[-1]
    for field in ['provider_60hz_budget_exceeded', 'host_ack_60hz_budget_exceeded']:
        result[field] = value[field]
    return result

for cell in reg['cells']:
    paired = []
    for pair in range(reg['pairs']):
        before = records.get((pair, cell['id'], 'baseline'))
        after = records.get((pair, cell['id'], 'candidate'))
        if before is not None and after is not None:
            paired.append((pair, metrics(before, cell), metrics(after, cell)))
    result = {'cell': cell, 'completed_pairs': len(paired), 'metrics': {}}
    for metric in (reg['ordinary_metrics'] if cell['kind'] == 'ordinary' else reg['native_metrics'] + reg['native_budget_gate']['metrics']):
        budget = metric in reg['native_budget_gate']['metrics']
        deltas = [new[metric] - old[metric] if budget else new[metric] / old[metric] for _, old, new in paired]
        positive = sum(value > (0 if budget else 1) for value in deltas)
        ninth = sorted(deltas)[8] if len(deltas) == 11 else None
        regression = positive >= 9
        equivalent = ninth is not None and ninth <= (0 if budget else 1.01)
        status = 'FAIL reproducible regression' if regression else ('PASS' if equivalent else 'INCOMPLETE/equivalence unproven')
        result['metrics'][metric] = {'pairs': [{'pair': pair, 'baseline': old[metric], 'candidate': new[metric],
                                               'difference' if budget else 'ratio': value}
                                              for (pair, old, new), value in zip(paired, deltas)],
                                    'positive_pairs': positive, 'ninth_order_statistic': ninth,
                                    'median_difference' if budget else 'median_ratio': statistics.median(deltas) if deltas else None,
                                    'gate': status}
    result['gate'] = 'PASS' if all(m['gate'] == 'PASS' for m in result['metrics'].values()) else 'FAIL/unproven'
    cells.append(result)
all_pass = complete and len(records) == reg['observations'] and all(cell['gate'] == 'PASS' for cell in cells)
speed = []
if all_pass:
    for result in cells:
        cell = result['cell']
        representative = cell['case'] not in ['empty', 'tiny'] and (cell['kind'] == 'native' or cell['operation'] in ['owner-hit', 'arrow', 'drag', 'prepare', 'reshape'])
        if representative:
            for name, value in result['metrics'].items():
                if 'median_ratio' in value and value['median_ratio'] <= .95 and value['ninth_order_statistic'] < 1:
                    speed.append({'cell_id': cell['id'], 'metric': name})
analysis = {'registration_sha256': sha(regpath), 'capture_status': capture['status'], 'complete_capture': complete,
            'valid_observations': len(records), 'required_observations': reg['observations'],
            'all_independent_gates_pass': all_pass, 'speed_claim_gate': bool(all_pass and speed),
            'speed_cohorts': speed, 'cells': cells,
            'policy': 'No aggregate offset; every cell/metric required. Partial capture remains invalid. No retry/resample.'}
(out / 'analysis.json').write_text(json.dumps(analysis, indent=2) + '\n')
for cell in cells:
    print(cell['cell']['id'], cell['cell']['case'], cell['cell']['operation'], cell['completed_pairs'], cell['gate'])
print('complete', complete, 'observations', len(records), 'all gates', all_pass, 'speed claim', bool(all_pass and speed))
