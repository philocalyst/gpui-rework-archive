from pathlib import Path
import gzip
import hashlib
import json
import shutil

source = Path('/tmp/gpui-delivery-integration-sol/reactivity/evidence/delivery-integration')
destination = Path('/root/gpui-ce3/reactivity/evidence/delivery-integration')
assert not destination.exists()
index = json.loads((source / 'file-index.json').read_text())
seen = set()
for row in index:
    name = row['archive']
    assert name not in seen and Path(name).parts[0] == 'raw' and '..' not in Path(name).parts
    seen.add(name)
    data = (source / name).read_bytes()
    assert hashlib.sha256(data).hexdigest() == row['archive_sha256'], name
    original = gzip.decompress(data) if name.endswith('.gz') else data
    assert len(original) == row['original_bytes']
    assert hashlib.sha256(original).hexdigest() == row['original_sha256'], name
artifacts = json.loads((source / 'external-artifacts.json').read_text())
for row in artifacts:
    path = Path(row['path'])
    if 'symlink_to' in row:
        assert path.is_symlink() and str(path.readlink()) == row['symlink_to']
        native = json.loads((source / 'raw/native-three-results.json').read_text())
        assert native['binary'] == row['symlink_to'] and native['before'] == native['after']
        with path.open('rb') as stream:
            assert hashlib.file_digest(stream, 'sha256').hexdigest() == native['before']
        continue
    assert path.stat().st_size == row['bytes']
    with path.open('rb') as stream:
        assert hashlib.file_digest(stream, 'sha256').hexdigest() == row['sha256'], path
capture = Path('/tmp/gpui-delivery-integration-captures')
guards = 0
guarded_files = 0
for before in sorted(capture.glob('*-before.json')):
    after = before.with_name(before.name.replace('-before.json', '-after.json'))
    if not after.exists():
        continue
    a = json.loads(before.read_text())
    b = json.loads(after.read_text())
    assert a == b, before
    guards += 1
    guarded_files += len(a)
assert len(index) == 324 and len(artifacts) == 11
shutil.copytree(source, destination)
for file in source.rglob('*'):
    if file.is_file():
        assert file.read_bytes() == (destination / file.relative_to(source)).read_bytes()
report = {'source': 'e31ffdbc15c8e786e822715c7c0d00d95629f97c', 'review_commit': '043a0aecedf834efbed594353ef0173934613ec8', 'payloads_reopened': len(index), 'original_payload_bytes': sum(row['original_bytes'] for row in index), 'external_artifacts_reopened': len(artifacts), 'guard_pairs_checked': guards, 'guarded_file_records': guarded_files, 'copied_files_byte_identical': True, 'production_adopted': False, 'known_blocker': 'cb83 public shared-atomic alias failure; ff44 admission fix has separate source and qualification'}
(destination / 'root-verification.json').write_text(json.dumps(report, indent=2) + '\n')
shutil.copy2(__file__, destination / 'verify-root.py')
print(json.dumps(report), flush=True)
