from pathlib import Path
import json, hashlib, subprocess, shutil, os

r = Path(__file__).parent
a = json.loads((r / 'matrix-artifacts.json').read_text())
qualification = json.loads((r / 'qualification-progress.json').read_text())
assert qualification['source'] == a['candidate']['source']
receipt = {'artifacts': {k: {'source': v['source'], 'sha256': v['sha256']} for k, v in a.items()},
    'qualification': qualification, 'shader_receipt': 'generated-shaders/receipt.json'}
def sha(p):
    return hashlib.file_digest(p.open('rb'), 'sha256').hexdigest()
environments = {}
for n, v in a.items():
    w = Path(v['worktree'])
    assert not subprocess.check_output(['git', 'status', '--porcelain'], cwd=w).strip()
    assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=w, text=True).strip() == v['source']
    assert sha(Path(v['preserved'])) == v['sha256']
    before = json.loads(Path(v['inputs']).read_text())
    after = {p: sha(w / p) for p in subprocess.check_output(
        ['git', 'ls-files', '-z', 'reactivity', '.cargo', 'clippy.toml'], cwd=w
    ).decode().split('\0') if p and (w / p).is_file()}
    assert before == after
    env = json.loads((Path(v['gate']) / 'environment.json').read_text())
    environments[n] = {k: value for k, value in env.items()
        if k.startswith(('RUST', 'CARGO_PROFILE_', 'CARGO_ENCODED_RUSTFLAGS'))}
    for stage in ['build', 'test']:
        command = json.loads((Path(v['gate']) / (stage + '.status.json')).read_text())['command']
        assert '+nightly-2026-10-23' in command and '--release' in command
        assert '--locked' in command and '--offline' in command
assert all(v == environments['candidate'] for v in environments.values())
receipt['compiler_environment'] = environments
for phase, count in [('qualification', 420), ('allocations', 140)]:
    d = r / ('matrix-' + phase)
    assert json.loads((d / 'guard-after.json').read_text()) == []
    assert not (d / 'failure.txt').exists()
    assert json.loads((d / 'artifacts.json').read_text()) == a
    assert len(json.loads((d / 'results.json').read_text())) == count
    receipt[phase + '_processes'] = count
allocation = json.loads((r / 'allocation-verdict.json').read_text())
assert allocation['all_pass']
assert allocation['source_sha256'] == sha(r / 'matrix-allocations/results.json')
receipt['allocation_gate'] = allocation
headers = json.loads((r / 'headers/summary.json').read_text())['candidate']
spec = json.loads((r / 'cost-definition.json').read_text())
for name, expected in spec['header_gates'].items():
    if name == 'TextPatch_without_native': continue
    assert headers['TextPatch' if name == 'TextPatch_native' else name] == expected
receipt['headers'] = headers
runner = json.loads((r / 'runner-receipt.json').read_text())
for path, key in [('matrix_runs.py', 'timing_sha256'), ('analyze_matrix.py', 'analysis_sha256'),
    ('verify_dossier.py', 'verifier_sha256'), ('process-order.json', 'process_manifest_sha256')]:
    assert sha(r / path) == runner[key]
receipt['runner'] = runner
receipt['free_bytes'] = shutil.disk_usage('/home/user').free
assert receipt['free_bytes'] > 8 * 1024**3
receipt['processes'] = subprocess.check_output(['ps', '-eo', 'pid,etime,pcpu,comm'], text=True)
for row in receipt['processes'].splitlines()[1:]:
    assert row.split()[-1] not in ['cargo', 'rustc', 'rust-lld', 'ld.lld', 'gcc', 'clang', 'cc1', 'clippy-driver']
receipt['driver'] = json.loads((r / 'driver.json').read_text())
receipt['cache_environment'] = {k: os.environ.get(k) for k in ['MESA_SHADER_CACHE_DISABLE', 'MESA_SHADER_CACHE_DIR', 'XDG_CACHE_HOME']}
receipt['limits'] = ('Owner operation through native bridge, GPU completion and ACK. '
    'Fresh process/object cold observations are not a cold shader-disk-cache measurement. '
    'Copy variants charge both overlap copies and retained scratch in addition to full presentation. '
    'No builds, other tests, allocations, analysis, source edits or cleanup during timing. '
    'Software Vulkan/private X11; no physical GPU, scanout, quality parity or ZGX victory.')
assert not (r / 'matrix-preflight.json').exists()
(r / 'matrix-preflight.json').write_text(json.dumps(receipt, indent=2))
print('all fixed gates and five execution identities ready for timing')
