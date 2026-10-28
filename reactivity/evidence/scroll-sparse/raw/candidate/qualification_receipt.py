from pathlib import Path
import subprocess, json, hashlib, re

r = Path(__file__).parent
w = Path('/home/user/gpui-scroll-sparse-lab')
source = '5a07d7c28ffe500a5d24e25fdf1f31ce4857811f'
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=w, text=True).strip() == source
assert not subprocess.check_output(['git', 'status', '--porcelain'], cwd=w).strip()
def sha(p):
    return hashlib.file_digest(p.open('rb'), 'sha256').hexdigest()
receipts = {}
for name, stages in [
    ('gpu-precise-first', ['test', 'clippy']),
    ('offline-precise', ['test', 'clippy']),
    ('full-native-precise', ['build', 'test', 'port', 'clippy']),
    ('minimal-library-precise', ['unit-build', 'port', 'clippy']),
    ('default-precise', ['test', 'clippy']),
    ('native-checks-precise', [f'native-{i}' for i in range(6)] + [
        'native-list-default', 'native-overscan', 'native-list-controlled',
        'native_atspi_ime_cjk_preview_old_candidate_ack_and_commit',
        'native_atspi_ime_explicit_line_height_preview_ack_and_commit']),
    ('minimal-native-checks-precise', ['native-todo', 'native-list-default', 'native-overscan', 'native-list-controlled']),
]:
    d = r / name
    assert json.loads((d / 'guard-after.json').read_text()) == []
    part = {}
    for stage in stages:
        status = json.loads((d / (stage + '.status.json')).read_text())
        assert status['exit'] == 0
        totals = re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored',
            (d / (stage + '.out')).read_text())
        part[stage] = {'status': status, 'passed': sum(int(x[0]) for x in totals),
                      'ignored': sum(int(x[2]) for x in totals)}
    if (d / 'inputs.json').exists():
        assert (d / 'source.txt').read_text().strip() == source
        for path, digest in json.loads((d / 'inputs.json').read_text()).items():
            assert sha(w / path) == digest
    receipts[name] = part
negative = {}
for kind, stage, phrase in [
    ('omit', 'test', 'outside case=0, tick=1, format=Rgba8UnormSrgb'),
    ('authority', 'native', 'native patch vs independent full GPU renderer'),
]:
    d = r / ('negative-authority-retry' if kind == 'authority' else 'negative-omit')
    assert json.loads((d / 'guard-after.json').read_text()) == []
    status = json.loads((d / (stage + '.status.json')).read_text())
    assert status['exit'] == 101 and not status['stopped']
    assert phrase in (d / (stage + '.log')).read_text()
    if kind == 'authority':
        assert 'paint_tests::scroll_copy_tests::Rows' in (d / (stage + '.log')).read_text()
    assert '0 passed; 1 failed' in (d / (stage + '.out')).read_text()
    mutant = Path(f'/home/user/gpui-scroll-sparse-{kind}-lab')
    assert not subprocess.check_output(['git', 'status', '--porcelain'], cwd=mutant).strip()
    for path, digest in json.loads((d / 'inputs.json').read_text()).items():
        assert sha(mutant / path) == digest
    artifacts = json.loads((d / ('test-artifacts.json' if kind == 'omit' else 'build-artifacts.json')).read_text())
    for a in artifacts:
        assert sha(Path(a['preserved'])) == a['sha256']
    negative[kind] = {'source': (d / 'source.txt').read_text().strip(),
        'status': status, 'pixel_failure': phrase, 'artifacts': artifacts}
controls = json.loads((r / 'matrix-artifacts.json').read_text())
new_control = controls['copy_bounds']
assert new_control['source'] == '599e36c149ea252f96056f3d8e827da137f71197'
cw = Path(new_control['worktree'])
for name in ['full-native-bounds-shared', 'native-checks-bounds-shared', 'gpu-bounds-shared-admitted']:
    d = r / name
    assert json.loads((d / 'guard-after.json').read_text()) == []
    if (d / 'inputs.json').exists():
        for path, digest in json.loads((d / 'inputs.json').read_text()).items():
            assert sha(cw / path) == digest
    for p in d.glob('*.status.json'):
        assert json.loads(p.read_text())['exit'] == 0
paths = subprocess.check_output(['git', 'diff', '--name-only', new_control['source'], source], cwd=w, text=True).splitlines()
assert paths == ['reactivity/crates/canvas/src/canvas/scroll.rs']
a = (cw / paths[0]).read_text()
b = (w / paths[0]).read_text()
assert a[:a.index('fn outside_damage(')] == b[:b.index('fn outside_damage(')]
assert a[a.index('\nstruct Contribution'):] == b[b.index('\nstruct Contribution'):]
receipts['source'] = source
receipts['negative'] = negative
receipts['copy_bounds'] = {'source': new_control['source'], 'same_paths_except': 'outside_damage derivation',
    'qualified_composition': ['full-native-bounds-shared', 'native-checks-bounds-shared', 'gpu-bounds-shared-admitted'],
    'fresh_target_build': 'cost-build-copy_bounds-retry'}
receipts['inherited_controls'] = json.loads(Path('/home/user/gpui-region-batch-evidence/control-inherited-qualification.json').read_text())
receipts['limits'] = 'Exact correctness on software Vulkan/private X11. Full five-way fixed cost gate still required; no hardware, scanout or ZGX victory.'
(r / 'qualification-progress.json').write_text(json.dumps(receipts, indent=2))
print({k: {s: v['passed'] for s, v in d.items()} for k, d in receipts.items()
    if k.endswith('-precise') or k == 'gpu-precise-first'})
