from pathlib import Path
import subprocess, json, hashlib, re

r = Path(__file__).parent
w = Path('/home/user/gpui-scene-support-lab')
source = '92bfac4445c8b518b945c384fe6ff83ed772ae4f'
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=w, text=True).strip() == source
assert not subprocess.check_output(['git', 'status', '--porcelain'], cwd=w).strip()
def sha(p):
    return hashlib.file_digest(p.open('rb'), 'sha256').hexdigest()
receipts = {}
for name, stages in [
    ('gpu-fixture-lint', ['test', 'clippy']),
    ('offline-initial', ['test', 'clippy']),
    ('full-native-initial', ['build', 'test', 'port', 'clippy']),
    ('minimal-library-initial', ['unit-build', 'port', 'clippy']),
    ('default-initial', ['test', 'clippy']),
    ('native-checks-initial', [f'native-{i}' for i in range(6)] + [
        'native-list-default', 'native-overscan', 'native-list-controlled',
        'native_atspi_ime_cjk_preview_old_candidate_ack_and_commit',
        'native_atspi_ime_explicit_line_height_preview_ack_and_commit']),
    ('minimal-native-checks-initial', ['native-todo', 'native-list-default', 'native-overscan', 'native-list-controlled']),
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
    ('omit', 'test', 'complete support case=0, tick=3, format=Rgba8UnormSrgb'),
    ('pending', 'native', 'native patch vs independent full GPU renderer'),
]:
    d = r / ('negative-' + kind)
    assert json.loads((d / 'guard-after.json').read_text()) == []
    status = json.loads((d / (stage + '.status.json')).read_text())
    assert status['exit'] == 101 and not status['stopped']
    assert phrase in (d / (stage + '.log')).read_text()
    if kind == 'pending':
        assert 'scroll_copy_tests::Rows' in (d / (stage + '.log')).read_text()
    assert '0 passed; 1 failed' in (d / (stage + '.out')).read_text()
    mutant = Path(f'/home/user/gpui-scene-support-{kind}-lab')
    assert not subprocess.check_output(['git', 'status', '--porcelain'], cwd=mutant).strip()
    for path, digest in json.loads((d / 'inputs.json').read_text()).items():
        assert sha(mutant / path) == digest
    artifacts = json.loads((d / ('test-artifacts.json' if kind == 'omit' else 'build-artifacts.json')).read_text())
    for a in artifacts:
        assert sha(Path(a['preserved'])) == a['sha256']
    negative[kind] = {'source': (d / 'source.txt').read_text().strip(),
        'status': status, 'pixel_failure': phrase, 'artifacts': artifacts}
receipts['source'] = source
receipts['negative'] = negative
receipts['inherited_controls'] = json.loads(Path('/home/user/gpui-region-batch-evidence/control-inherited-qualification.json').read_text())
receipts['limits'] = 'Exact correctness on software Vulkan/private X11. Full five-way fixed cost gate still required; no hardware, scanout or ZGX victory.'
(r / 'qualification-progress.json').write_text(json.dumps(receipts, indent=2))
print({k: {s: v['passed'] for s, v in d.items()} for k, d in receipts.items()
    if k.endswith('-initial') or k == 'gpu-fixture-lint'})
