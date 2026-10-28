from pathlib import Path
import subprocess, json, hashlib, re

r = Path(__file__).parent
w = Path('/home/user/gpui-patch-workspace-lab')
source = '41a67473a0177fbb17df1f7b8e2f2f36dd6940f6'
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=w, text=True).strip() == source
assert not subprocess.check_output(['git', 'status', '--porcelain'], cwd=w).strip()
def sha(p):
    return hashlib.file_digest(p.open('rb'), 'sha256').hexdigest()
receipts = {}
for name, stages in [
    ('gpu-support-fixture', ['test', 'clippy']),
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
d = r / 'negative-retire-reserved'
assert json.loads((d / 'guard-after.json').read_text()) == []
status = json.loads((d / 'test.status.json').read_text())
assert status['exit'] == 101 and not status['stopped']
fault = (d / 'test.log').read_text()
assert 'full supersession replayed a retired sparse payload' in fault
assert '0 passed; 1 failed' in (d / 'test.out').read_text()
mutant = Path('/home/user/gpui-patch-workspace-retire-lab')
assert not subprocess.check_output(['git', 'status', '--porcelain'], cwd=mutant).strip()
for path, digest in json.loads((d / 'inputs.json').read_text()).items(): assert sha(mutant / path) == digest
artifacts = json.loads((d / 'test-artifacts.json').read_text())
for a in artifacts: assert sha(Path(a['preserved'])) == a['sha256']
witness = json.loads((d / 'witness.json').read_text())
assert witness['actual'][0] == ['1111', 4] and witness['expected'][0] == ['2222', 4]
negative = {'retirement': {'source': (d / 'source.txt').read_text().strip(), 'status': status, 'witness': witness, 'artifacts': artifacts}}
receipts['source'] = source
receipts['negative'] = negative
receipts['inherited_controls'] = json.loads(Path('/home/user/gpui-region-batch-evidence/control-inherited-qualification.json').read_text())
receipts['limits'] = 'Exact correctness on software Vulkan/private X11. Full five-way fixed cost gate still required; no hardware, scanout or ZGX victory.'
(r / 'qualification-progress.json').write_text(json.dumps(receipts, indent=2))
print({k: {s: v['passed'] for s, v in d.items()} for k, d in receipts.items()
    if k.endswith('-initial') or k == 'gpu-support-fixture'})
