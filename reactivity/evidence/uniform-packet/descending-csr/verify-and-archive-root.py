from pathlib import Path
import hashlib
import json
import shutil
import tarfile

root = Path('/root/gpui-ce3/reactivity/evidence/uniform-packet')
specifications = [
    ('descending-csr', Path('/tmp/gpui-descending-csr-qualified.tar.gz'), Path('/tmp/gpui-descending-csr-capture-manifest.json'),
     '7bcbdeae2e16cd06dca737cdb636a461fedb30f23a4098fc3165b8229ac8e29f',
     'ad82f18f7e1a7cc2da4acb1f84d9a8901d8b78222025bb851098ede20365c38c'),
]
for label, archive, manifest_file, archive_hash, manifest_hash in specifications:
    destination = root / label
    assert not destination.exists()
    assert hashlib.sha256(archive.read_bytes()).hexdigest() == archive_hash
    manifest_raw = manifest_file.read_bytes()
    assert hashlib.sha256(manifest_raw).hexdigest() == manifest_hash
    manifest = json.loads(manifest_raw)
    expected = {row['member']: row for row in manifest['payload_members']}
    assert len(expected) == len(manifest['payload_members'])
    verified = set()
    with tarfile.open(archive, 'r|gz') as stream:
        for member in stream:
            assert member.isfile() and member.name not in verified, member.name
            payload = stream.extractfile(member).read()
            if member.name == manifest['manifest_member']:
                assert payload == manifest_raw
            else:
                entry = expected[member.name]
                assert len(payload) == entry['bytes'], member.name
                assert hashlib.sha256(payload).hexdigest() == entry['sha256'], member.name
            verified.add(member.name)
    assert verified == set(expected) | {manifest['manifest_member']}
    for entry in manifest['external_elf']:
        filename = Path(entry['source_path'])
        assert filename.stat().st_size == entry['bytes'], filename
        with filename.open('rb') as stream:
            assert hashlib.file_digest(stream, 'sha256').hexdigest() == entry['sha256'], filename
    destination.mkdir()
    shutil.copy2(archive, destination / 'qualified.tar.gz')
    shutil.copy2(manifest_file, destination / 'capture-manifest.json')
    assert hashlib.sha256((destination / 'qualified.tar.gz').read_bytes()).hexdigest() == archive_hash
    assert hashlib.sha256((destination / 'capture-manifest.json').read_bytes()).hexdigest() == manifest_hash
    report = {'source': manifest['source'], 'baseline': manifest['baseline'], 'archive_sha256': archive_hash,
              'manifest_sha256': manifest_hash, 'payloads_reopened': len(expected),
              'payload_bytes': sum(row['bytes'] for row in expected.values()),
              'external_files_reopened': len(manifest['external_elf']),
              'production_adopted': False, 'timing_qualified': False}
    (destination / 'root-verification.json').write_text(json.dumps(report, indent=2)+'\n')
    shutil.copy2(__file__, destination / 'verify-and-archive-root.py')
    print(json.dumps({'archive':label,**report}), flush=True)
