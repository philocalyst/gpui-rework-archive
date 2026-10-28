from pathlib import Path
import hashlib
import json
import subprocess

root = Path('/root/gpui-ce3')
producer = Path('/root/gpui-hummingbird-source-authority-sol')
git = lambda path: ['git', '-c', f'safe.directory={path}', '-C', str(path)]
runtime = '9f83f23288bbb364142ff2a82d059b6d99670a7e'
pin = 'b31b34475ebdfd196b93babe21b44bce2e79e78e'
patch = Path('/tmp/gpui-hummingbird-source-authority-evidence/qualification-only.patch')
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
assert sha(patch) == 'a39e0978ffd76455f2aad8b80743931727ff36be3b97ba269fcea5d5e90914c9'
assert subprocess.check_output(git(producer) + ['rev-parse', 'HEAD'], text=True).strip() == pin
assert not subprocess.check_output(git(producer) + ['status', '--porcelain'], text=True).strip()
paths = subprocess.check_output(git(producer) + ['diff', '--name-only', runtime, pin], text=True).splitlines()
assert paths and all(name.startswith('reactivity/ports/hummingbird/qualification/source-authority/') for name in paths)
subprocess.run(git(root) + ['apply', '--check', '--index', str(patch)], check=True)
subprocess.run(git(root) + ['apply', '--index', '--whitespace=nowarn', str(patch)], check=True)
for name in paths:
    actual = subprocess.check_output(git(root) + ['hash-object', str(root / name)], text=True).strip()
    expected = subprocess.check_output(git(producer) + ['rev-parse', pin + ':' + name], text=True).strip()
    assert actual == expected, name
out = root / 'reactivity/ports/hummingbird/qualification/source-authority'
manifest = json.loads((out / 'runtime-manifest.json').read_text())
for name, expected in manifest['files'].items():
    assert sha(root / name) == expected, name
negative = json.loads((out / 'negative-binaries-manifest.json').read_text())
for label, row in negative.items():
    assert sha(Path(row['path'])) == row['sha256'], label
for name in ['baseline-named', 'baseline-both', 'baseline-uncommitted']:
    assert (out / (name + '.exit')).read_text().strip() == '101'
for name in ['default-qualified', 'cpal-qualified', 'native-qualified', 'clippy-cpal-qualified', 'clippy-native-qualified', 'fixed-both', 'fixed-uncommitted']:
    assert (out / (name + '.exit')).read_text().strip() == '0'
probe = out / 'constructor-probe'
probe_manifest = json.loads((probe / 'manifest.json').read_text())
assert sha(probe / 'current/src/main.rs') == probe_manifest['probe_sha256']
assert sha(Path(probe_manifest['frozen'])) == probe_manifest['sha256']
deltas = json.loads((probe / 'deltas.json').read_text())
assert len(deltas['control']) == len(deltas['candidate']) == 4
for old, new in zip(deltas['control'], deltas['candidate']):
    assert new['spawn']['count_current'] - old['spawn']['count_current'] == 1
    assert new['spawn']['bytes_current'] - old['spawn']['bytes_current'] == 64
    assert new['mounted']['bytes_current'] - old['mounted']['bytes_current'] == -8
    assert new['win'] - old['win'] == -8
    assert new['ui_current_plus_inline'] - old['ui_current_plus_inline'] == 48
report = {'runtime': runtime, 'qualified_commit': pin, 'qualification_patch_sha256': sha(patch),
    'qualification_paths': len(paths), 'all_qualification_blobs_match': True,
    'runtime_files_match': len(manifest['files']), 'negative_external_binaries_verified': len(negative),
    'constructor_frozen_binary_verified': True, 'matched_constructor_cohorts': 4,
    'retained_heap_plus_owner_delta_bytes': 48, 'extra_live_allocations': 1,
    'core_changed': False, 'browser_imported': False}
destination = root / 'reactivity/ports/hummingbird/qualification/main-source-authority-integration'
(destination / 'root-producer-verification.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(report), flush=True)
