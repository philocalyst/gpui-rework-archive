from pathlib import Path
import hashlib
import json

root = Path(__file__).parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
manifest = json.loads((root / 'MANIFEST.json').read_text())
assert set(manifest) == {p.relative_to(root).as_posix() for p in root.rglob('*') if p.is_file() and p.name != 'MANIFEST.json'}
for name, digest in manifest.items():
    assert sha(root / name) == digest, name
raw = root / 'raw'
for name in ['first', 'second', 'third', 'fourth', 'final', 'legacy', 'legacy-final']:
    assert json.loads((raw / name / 'guard.json').read_text()) == [], name
assert json.loads((raw / 'first/build.status.json').read_text())['exit'] != 0
assert json.loads((raw / 'second/tests.status.json').read_text())['exit'] == 0
assert json.loads((raw / 'second/clippy.status.json').read_text())['exit'] != 0
for name in ['third', 'fourth', 'final']:
    for gate in ['build', 'tests', 'feature_off', 'clippy']:
        assert json.loads((raw / name / (gate + '.status.json')).read_text())['exit'] == 0
for gate in ['build', 'tests']:
    assert json.loads((raw / 'legacy-final' / (gate + '.status.json')).read_text())['exit'] == 0
source = (root / 'source.txt').read_text().strip()
assert source == 'a0bc93cd11148b1ac439deaf4a60608be3af25e8'
for name in ['final', 'legacy-final']:
    assert (raw / name / 'source.txt').read_text().strip() == source
    a = json.loads((raw / name / 'artifact.json').read_text())
    p = Path(a['preserved'])
    if p.exists():
        assert sha(p) == a['sha256'] and p.stat().st_size == a['bytes']
    else:
        print(f"external executable not bundled: {a['sha256']}")
    rows = json.loads((raw / name / 'compiled-profiles.json').read_text())
    gpui = next(x for x in rows if x['target']['name'] == 'gpui')
    assert not gpui['profile']['test'] and gpui['features'] == ['component-replay-lab']
rows = json.loads((raw / 'final/trace/trace.json').read_text())
assert len(rows) == 39
admitted = [x for x in rows if x.get('replay', {}).get('admitted')]
assert len(admitted) == 24
for x in admitted:
    assert x['calls_replay'] == [0, 1] and x['calls_full'] == [1, 1]
    origin = x['replay']['origin']
    assert origin['caller_replayed'] and origin['correspondence'][0][2] == origin['root_identity']
large = next(x for x in rows if x['case'] == 'absent-128-0')
assert large['replay']['node_records_written'] == 261
assert large['replay']['parent_rank_checks'] == 257 and large['replay']['parent_rank_rewrites'] == 128
assert large['replay']['style_new_capacity_bytes'] == 25056
assert large['full']['full_work']['new_style_payload_bytes'] == 741
assert large['allocation_replay']['bytes_total'] == 268628 and large['allocation_full']['bytes_total'] == 574465
tiny = next(x for x in rows if x['case'] == 'absent-0-3')
assert tiny['allocation_replay']['bytes_total'] == 10380 and tiny['allocation_full']['bytes_total'] == 5720
a = (raw / 'final/trace/full.rgba').read_bytes()
b = (raw / 'final/trace/mutant.rgba').read_bytes()
assert len(a) == len(b) == 16384 and sum(x != y for x, y in zip(a, b)) == 1152
assert any(x['case'] == 'depth-failure-exact-remint-recovery' for x in rows)
inventory = json.loads((raw / 'inventory-final.json').read_text())
assert inventory['source_commit'] == source and inventory['core_non_test_code_lines'] == 39065
print(f'verified {len(manifest)} files; bounded CPU qualification and losses preserved; no adoption/timing/GPU claim')
