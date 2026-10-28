from pathlib import Path
import gzip
import hashlib
import io
import json
import shutil
import subprocess
import tarfile

source = Path('/tmp/gpui-compact-slice-root')
captures = Path('/tmp/gpui-compact-slice-evidence')
destination = Path('/root/gpui-ce3/reactivity/evidence/retained-slice')
assert not destination.exists()
git = ['git', '-c', f'safe.directory={source}', '-C', str(source)]
payload = {}
results = []
pins = set()
for result_file in sorted(captures.rglob('result.json')):
    directory = result_file.parent
    result = json.loads(result_file.read_text())
    before = json.loads((directory / 'before.json').read_text())
    assert before == json.loads((directory / 'after.json').read_text())
    command = json.loads((directory / 'command.json').read_text())
    pin = result['source']
    pins.add(pin)
    assert command['environment']['RUSTC_BOOTSTRAP'] is None
    for name, digest in before.items():
        data = subprocess.check_output(git + ['show', pin + ':' + name])
        assert hashlib.sha256(data).hexdigest() == digest
    results.append({'gate': str(directory.relative_to(captures)), **result})
assert len(results) == 26
for gate in ('capacity-negative', 'clone-negative'):
    row = next(row for row in results if row['gate'] == gate)
    assert row['exit'] == 1
    diagnostic = (captures / gate / 'stderr.log').read_text()
    expected = 'incorrect layout on deallocation' if gate == 'capacity-negative' else 'use-after-free'
    assert 'error: Undefined Behavior' in diagnostic and expected in diagnostic
final = '0fc39c500c44f3059095975d0de4749815a3ef18'
assert next(row for row in results if row['gate'] == 'stable-final')['passed'] == 9
assert next(row for row in results if row['gate'] == 'strict-final')['exit'] == 0
assert sum(row['passed'] for row in results if row['gate'].startswith('miri-final/')) == 42
for path in sorted(captures.rglob('*')):
    if path.is_file():
        payload['captures/' + str(path.relative_to(captures))] = path.read_bytes()
for pin in sorted(pins):
    for name in ('Cargo.toml', 'Cargo.lock', 'src/lib.rs'):
        payload['sources/' + pin + '/' + name] = subprocess.check_output(git + ['show', pin + ':' + name])
    payload['sources/' + pin + '/commit.txt'] = subprocess.check_output(git + ['show', '-s', '--format=fuller', pin])
for script in ('/tmp/gpui-compact-slice-miri-root.py', '/tmp/gpui-compact-slice-miri-v2-root.py', '/tmp/gpui-compact-slice-miri-final-root.py', '/tmp/gpui-run-frozen-gate-root.py', __file__):
    path = Path(script)
    payload['helpers/' + path.name] = path.read_bytes()
executable = None
for line in (captures / 'stable-final/stdout.log').read_text().splitlines():
    try: row = json.loads(line)
    except ValueError: continue
    if row.get('reason') == 'compiler-artifact' and row.get('executable') and row['profile']['test']:
        assert executable is None
        executable = Path(row['executable'])
assert executable is not None
frozen = Path('/tmp/gpui-retained-slice-final-0fc39-frozen')
frozen.mkdir(exist_ok=False)
shutil.copy2(executable, frozen / 'tests')
binary_hash = hashlib.sha256(executable.read_bytes()).hexdigest()
assert hashlib.sha256((frozen / 'tests').read_bytes()).hexdigest() == binary_hash
manifest = {'source': final, 'production_adopted': False, 'gates': results, 'external_test_binary': {'original': str(executable), 'frozen': str(frozen / 'tests'), 'bytes': executable.stat().st_size, 'sha256': binary_hash}, 'payloads': {name: {'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest()} for name,data in sorted(payload.items())}}
manifest_bytes = (json.dumps(manifest, indent=2) + '\n').encode()
destination.mkdir()
archive = destination / 'qualified.tar.gz'
with archive.open('wb') as stream, gzip.GzipFile(filename='', mode='wb', fileobj=stream, mtime=0) as compressed, tarfile.open(fileobj=compressed, mode='w|') as output:
    for name, data in sorted({**payload, 'manifest.json': manifest_bytes}.items()):
        member = tarfile.TarInfo(name)
        member.size = len(data)
        member.mode = 0o644
        output.addfile(member, io.BytesIO(data))
seen = set()
with tarfile.open(archive, 'r|gz') as stream:
    for member in stream:
        assert member.isfile() and member.name not in seen
        data = stream.extractfile(member).read()
        assert data == (manifest_bytes if member.name == 'manifest.json' else payload[member.name])
        seen.add(member.name)
assert seen == set(payload) | {'manifest.json'}
(destination / 'manifest.json').write_bytes(manifest_bytes)
shutil.copy2(__file__, destination / 'archive-root.py')
report = {'source': final, 'payloads_reopened': len(payload), 'payload_bytes': sum(len(data) for data in payload.values()), 'guarded_gate_records': len(results), 'stable_passed': 9, 'strict_passed': True, 'final_miri_target_models': 6, 'final_miri_passed': 42, 'actual_ub_controls': 2, 'archive_bytes': archive.stat().st_size, 'archive_sha256': hashlib.sha256(archive.read_bytes()).hexdigest(), 'production_adopted': False, 'scope': 'Standalone allocation ownership, not application performance, full GPUI behavior or production integration.'}
(destination / 'root-verification.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(report), flush=True)
