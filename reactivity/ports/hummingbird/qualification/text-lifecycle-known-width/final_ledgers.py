import hashlib
import json
import pathlib
import re

out = pathlib.Path(__file__).parent
root = out.parent

def parse(path):
    rows = []
    for line in path.read_text().splitlines():
        if not line.startswith('COHORT '):
            continue
        header, phase = line.split(' spawn=', 1)
        row = {'cohort': int(header.split()[1]), 'headers': {key: int(value) for key, value in re.findall(r'(\w+)=(\d+)', header)}}
        for label, body in re.findall(r'(spawn|connected|mounted)=AllocationInfo \{([^}]+)\}', 'spawn=' + phase):
            row[label] = {key: int(value) for key, value in re.findall(r'(\w+): (-?\d+)', body)}
        assert len(row) == 5
        rows.append(row)
    assert len(rows) == 4
    return rows

baseline = root / 'same-path-control/constructor-baseline-output.txt'
candidate = out / 'constructor-release-runtime.log'
old = parse(baseline)
new = parse(candidate)
debug = json.loads((out / 'constructor-ledger.json').read_text())['variants']
assert old == debug['dfc4']['rows']
assert new == debug['known-width']['rows']
rows = []
for before, after in zip(old, new):
    assert before['cohort'] == after['cohort']
    delta = {phase: {key: after[phase][key] - before[phase][key] for key in before[phase]} for phase in ['spawn', 'connected', 'mounted']}
    delta['headers'] = {key: after['headers'][key] - before['headers'][key] for key in before['headers']}
    delta['cohort'] = before['cohort']
    rows.append(delta)
report = {
    'scope': 'Same physical source/build path, normal release Cargo constructor artifacts; calling-thread Rust counters only. Worker/C/OS/device/RSS excluded. Header fields overlap; phase peaks must not be summed.',
    'baseline': str(baseline), 'candidate': str(candidate), 'baseline_rows': old, 'candidate_rows': new,
    'release_equals_corresponding_original_debug_rows': True, 'deltas': rows,
    'candidate_artifacts': json.loads((out / 'constructor-artifacts.json').read_text()),
    'baseline_artifacts': json.loads((root / 'same-path-control/baseline-constructor-whole-artifacts.json').read_text()),
}
(out / 'constructor-release-comparison.json').write_text(json.dumps(report, indent=2) + '\n')
statuses = {}
for status in sorted(out.glob('*.exit')):
    statuses[status.stem] = int(status.read_text())
(out / 'all-gate-exits.json').write_text(json.dumps(statuses, indent=2) + '\n')
headers = {}
for filename in ['canvas-ledger.log', 'text-headers.log', 'gpui-ledger.log']:
    for line in (out / filename).read_text().splitlines():
        if line.startswith(('GEOMETRY_HEADERS', 'TEXT_HEADERS', 'TEXT_OWNER_HEADERS')):
            headers[line.split()[0]] = {key: int(value) for key, value in re.findall(r'(\w+)=(\d+)', line)}
(out / 'type-headers.json').write_text(json.dumps(headers, indent=2) + '\n')
print('Saved guarded release constructor comparison, all gate exits and type headers.')
