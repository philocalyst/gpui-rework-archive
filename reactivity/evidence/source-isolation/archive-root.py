from pathlib import Path
import gzip
import hashlib
import io
import json
import re
import shutil
import subprocess
import tarfile

root = Path('/root/gpui-ce3')
destination = root / 'reactivity/evidence/source-isolation'
assert not destination.exists()
payload = {}
def add(name, data):
    assert name not in payload
    payload[name] = data if isinstance(data, bytes) else data.encode()
def tree(directory, prefix):
    for path in sorted(directory.rglob('*')):
        if path.is_file():
            add(prefix + '/' + str(path.relative_to(directory)), path.read_bytes())
def git(*arguments):
    return subprocess.check_output(['git', '-c', f'safe.directory={root}', '-C', str(root), *arguments])

negative_pin = 'cb83d485451e2cbd69da95b68f58409a4dee5abf'
positive_pin = 'ff44c087e36eba331e0bc408a98bcab8e3837467'
base = 'e31ffdbc15c8e786e822715c7c0d00d95629f97c'
negative = Path('/tmp/gpui-source-alias-root-evidence/initial')
positive = Path('/tmp/gpui-source-value-isolation-evidence')
for directory, pin, expected in [(negative, negative_pin, (1, 1, 0, 1)), (positive / 'initial', positive_pin, (156, 0, 5, 2))]:
    before = json.loads((directory / 'before.json').read_text())
    after = json.loads((directory / 'after.json').read_text())
    assert before == after and len(before) == 1994
    command = json.loads((directory / 'command.json').read_text())
    assert command['source'] == pin and command['environment']['RUSTC_BOOTSTRAP'] is None
    source = Path(command['cwd'])
    for name, digest in before.items():
        assert hashlib.sha256((source / name).read_bytes()).hexdigest() == digest, name
    rows = re.findall(r'test result: (?:ok|FAILED)\. (\d+) passed; (\d+) failed; (\d+) ignored;', (directory / 'stdout.log').read_text())
    total = tuple(sum(int(row[i]) for row in rows) for i in range(3)) + (len(rows),)
    assert total == expected, total
    tree(directory, 'negative' if pin == negative_pin else 'positive/initial')
for label in ('contracts', 'contracts-public-bound'):
    tree(positive / label, 'positive/' + label)
contracts = json.loads((positive / 'contracts-public-bound/results.json').read_text())
assert len(contracts['results']) == 25 and all(row['pass'] for row in contracts['results'])
guards = json.loads((positive / 'contracts-public-bound/artifact-guards.json').read_text())
assert guards['before'] == guards['after']
for path, record in guards['before'].items():
    candidate = Path(path)
    assert candidate.stat().st_size == record['bytes']
    assert hashlib.sha256(candidate.read_bytes()).hexdigest() == record['sha256']
for pin, label in [(negative_pin, 'negative'), (positive_pin, 'positive')]:
    add(label + '/source.patch', git('diff', base, pin, '--', 'reactivity/crates/gpui'))
    names = git('diff', '--name-only', base, pin, '--', 'reactivity/crates/gpui').decode().splitlines()
    for name in names:
        add(label + '/source/' + name, git('show', pin + ':' + name))
add('helpers/compile-contracts-root.py', Path('/tmp/gpui-isolation-contracts-root.py').read_bytes())
add('helpers/functional-gate-root.py', Path('/tmp/gpui-run-frozen-gate-root.py').read_bytes())
add('helpers/archive-root.py', Path(__file__).read_bytes())
executable = Path('/tmp/gpui-source-alias-negative-frozen-cb83/source_alias_contract-9e72926c0f640666')
expected_hash = 'cc62097038e781d43c1b82a1c434bd51bef8e5bce3db7f6d5f82819b88f19faa'
assert executable.stat().st_size == 160342240
assert hashlib.sha256(executable.read_bytes()).hexdigest() == expected_hash
manifest = {
    'base': base, 'negative_source': negative_pin, 'candidate_source': positive_pin,
    'production_adopted': False, 'bootstrap': False,
    'functional_guards_per_lane': 1994, 'downstream_artifacts_guarded': len(guards['before']),
    'negative_totals': {'passed': 1, 'failed': 1, 'ignored': 0, 'harnesses': 1},
    'positive_initial_totals': {'passed': 156, 'failed': 0, 'ignored': 5, 'harnesses': 2},
    'compile_contracts': {'total': 25, 'passed': 25},
    'external_negative_executable': {'path': str(executable), 'bytes': executable.stat().st_size, 'sha256': expected_hash},
    'payloads': {name: {'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest()} for name, data in sorted(payload.items())},
}
manifest_bytes = (json.dumps(manifest, indent=2) + '\n').encode()
destination.mkdir()
archive = destination / 'qualified.tar.gz'
with archive.open('wb') as stream, gzip.GzipFile(filename='', fileobj=stream, mode='wb', mtime=0) as compressed, tarfile.open(fileobj=compressed, mode='w|') as output:
    for name, data in sorted({**payload, 'manifest.json': manifest_bytes}.items()):
        entry = tarfile.TarInfo(name)
        entry.size = len(data)
        entry.mode = 0o644
        output.addfile(entry, io.BytesIO(data))
seen = set()
with tarfile.open(archive, 'r|gz') as stream:
    for member in stream:
        assert member.isfile() and member.name not in seen
        content = stream.extractfile(member).read()
        assert content == (manifest_bytes if member.name == 'manifest.json' else payload[member.name])
        seen.add(member.name)
assert seen == set(payload) | {'manifest.json'}
(destination / 'manifest.json').write_bytes(manifest_bytes)
shutil.copy2(__file__, destination / 'archive-root.py')
report = {'archive_bytes': archive.stat().st_size, 'archive_sha256': hashlib.sha256(archive.read_bytes()).hexdigest(), 'payloads_reopened': len(payload), 'payload_bytes': sum(len(data) for data in payload.values()), 'source_guards_reopened': 3988, 'downstream_artifacts_reopened': len(guards['before']), 'frozen_negative_executable_reopened': True, 'production_adopted': False, 'timing_claim': False}
(destination / 'root-verification.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(report), flush=True)
