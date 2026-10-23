from pathlib import Path
import gzip
import hashlib
import json
import re
import shutil
import subprocess

source = Path('/tmp/gpui-one-buffer-inbox-sol')
packet = source / 'reactivity/evidence/inbox-buffer'
destination = Path('/root/gpui-ce3/reactivity/evidence/inbox-buffer')
git = ['git', '-c', f'safe.directory={source}', '-C', str(source)]
assert subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip() == '581640fee40ee6b16cc296548f666de8a9750443'
assert not subprocess.check_output(git + ['status', '--porcelain'], text=True).strip()
assert not destination.exists()
manifest = json.loads((packet / 'SHA256SUMS.json').read_text())
actual = {str(path.relative_to(packet)) for path in packet.rglob('*') if path.is_file()}
assert actual == set(manifest) | {'SHA256SUMS.json'}
for name, expected in manifest.items():
    assert hashlib.sha256((packet / name).read_bytes()).hexdigest() == expected, name
    if name.endswith('.gz'):
        gzip.decompress((packet / name).read_bytes())

external = json.loads((packet / 'external-files.json').read_text())
for entry in external:
    path = Path(entry['path'])
    if 'bytes' in entry:
        assert path.stat().st_size == entry['bytes'], path
    with path.open('rb') as stream:
        digest = hashlib.file_digest(stream, 'sha256').hexdigest()
    assert digest == entry['sha256'], path

qualification = json.loads((packet / 'qualification.json').read_text())
for name, expected in qualification['totals'].items():
    text = gzip.decompress((packet / 'raw' / (name + '.gz')).read_bytes()).decode()
    rows = re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored;', text)
    counts = dict(zip(['passed', 'failed', 'ignored'], [sum(int(row[i]) for row in rows) for i in range(3)]))
    counts['harnesses'] = len(rows)
    assert counts == expected, (name, counts)
for name in qualification['equal_guard_pairs']:
    before = gzip.decompress((packet / 'raw' / (name + '.gz')).read_bytes())
    after_name = name.replace('-before.json', '-after.json')
    after = gzip.decompress((packet / 'raw' / (after_name + '.gz')).read_bytes())
    assert json.loads(before) == json.loads(after), name
for label in ['strict-final', 'default-strict', 'apple', 'msvc']:
    lines = gzip.decompress((packet / 'raw' / (label + '.jsonl.gz')).read_bytes()).decode().splitlines()
    builds = []
    for line in lines:
        try:
            row = json.loads(line)
        except ValueError:
            continue
        if row.get('reason') == 'build-finished':
            builds.append(row)
    assert builds == [{'reason': 'build-finished', 'success': True}], label

for name, base, head, paths in [
    ('production.patch', qualification['base'], qualification['production'],
     ['reactivity/crates/gpui/src/remote.rs', 'reactivity/crates/gpui/src/reader/question.rs', 'reactivity/crates/gpui/src/runtime/turn.rs']),
    ('tests.patch', qualification['base'], qualification['tests'],
     ['reactivity/crates/gpui/tests/inbox_storage.rs', 'reactivity/crates/gpui/tests/source_inbox.rs']),
]:
    generated = subprocess.check_output(git + ['diff', '--binary', base, head, '--', *paths])
    assert generated == (packet / 'patches' / name).read_bytes(), name

shutil.copytree(packet, destination)
for name, expected in manifest.items():
    assert hashlib.sha256((destination / name).read_bytes()).hexdigest() == expected, name
report = {'producer': str(source), 'review': '581640fee40ee6b16cc296548f666de8a9750443',
          'production': qualification['production'], 'base': qualification['base'],
          'payloads_reopened': len(manifest), 'external_files_reopened': len(external),
          'guard_pairs_verified': len(qualification['equal_guard_pairs']), 'source_and_test_patches_match_git': True,
          'all_payloads_match_after_copy': True, 'production_adopted': False,
          'scope': 'Historical Rust1.97 one-buffer slice relative to typed f9. Composed genuine-nightly costs remain separate.'}
(destination / 'root-verification.json').write_text(json.dumps(report, indent=2)+'\n')
shutil.copy2(__file__, destination / 'verify-and-archive-root.py')
print(json.dumps(report, indent=2), flush=True)
