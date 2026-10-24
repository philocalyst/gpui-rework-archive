from pathlib import Path, PurePosixPath
import hashlib
import json
import subprocess
import sys
import tarfile

source = Path('/tmp/gpui-todo-shader-profiles-sol/reactivity/comparisons/todo-shader-profiles')
capture = source / 'capture-2026-10-24'
out = Path('/tmp/gpui-shader-profiles-root-audit')
out.mkdir(exist_ok=False)
receipts = json.loads((capture / 'archive-receipts.json').read_text())
archives = {
    'raw-evidence': capture / 'raw-evidence.tar.gz',
    'source-and-elfs': Path('/tmp/gpui-todo-shader-profiles-sol-build/final-artifacts/source-and-elfs.tar.gz'),
}
verified = []
for name, path in archives.items():
    receipt = receipts[name]
    with path.open('rb') as stream:
        digest = hashlib.file_digest(stream, 'sha256').hexdigest()
    assert path.stat().st_size == receipt['bytes'] and digest == receipt['sha256']
    with tarfile.open(path, 'r:gz') as archive:
        manifest_bytes = archive.extractfile('MANIFEST.json').read()
        assert hashlib.sha256(manifest_bytes).hexdigest() == receipt['manifest_sha256']
        manifest = json.loads(manifest_bytes)['files']
        members = archive.getmembers()
        assert len(members) == len({m.name for m in members})
        assert {m.name for m in members} == set(manifest) | {'MANIFEST.json'}
        elfs = []
        for member in members:
            relative = PurePosixPath(member.name)
            assert not relative.is_absolute() and '..' not in relative.parts
            if member.name == 'MANIFEST.json':
                continue
            record = manifest[member.name]
            assert member.mode == record['mode'] and member.issym() == record['symlink']
            if member.issym():
                data = member.linkname.encode()
                assert len(data) == record['bytes']
                member_digest = hashlib.sha256(data).hexdigest()
            else:
                assert member.isfile() and member.size == record['bytes']
                with archive.extractfile(member) as stream:
                    prefix = stream.read(4)
                    state = hashlib.sha256(prefix)
                    while chunk := stream.read(1024 * 1024):
                        state.update(chunk)
                member_digest = state.hexdigest()
                if prefix == b'\x7fELF':
                    elfs.append(member.name)
            assert member_digest == record['sha256'], member.name
        assert len(manifest) == receipt['payload_members']
        if name == 'raw-evidence':
            assert not any(member.issym() for member in members)
            extracted = out / 'extracted'
            extracted.mkdir()
            archive.extractall(extracted, filter='data')
    verified.append({'name': name, 'archive': str(path), 'sha256': digest, 'payload_members': len(manifest),
                     'ELFs': elfs, 'all_bytes_types_modes_and_set_verified': True})
reproduced = out / 'reproduced'
subprocess.run([sys.executable, str(source / 'analyze.py'), str(extracted / 'evidence/capture-v1'), str(reproduced)], check=True)
assert (reproduced / 'summary.json').read_bytes() == (capture / 'summary.json').read_bytes()
report = {'report_source': 'ccbfb4c60e34274742df539d93003ab9377f1927', 'archives': verified,
          'summary_byte_identical': True, 'scope': 'Independent complete capsule integrity and deterministic analysis verification; no new runtime trial.'}
(out / 'result.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(report), flush=True)
