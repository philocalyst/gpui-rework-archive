from pathlib import Path
import hashlib
import json
import shutil
import subprocess
import tarfile

archive = Path('/tmp/gpui-legacy-coverage-qualified.tar.gz')
manifest = Path('/tmp/gpui-legacy-coverage-capture-manifest.json')
evidence = Path('/tmp/gpui-legacy-coverage-evidence')
out = Path('/root/gpui-ce3/reactivity/evidence/uniform-packet/legacy-coverage')

def sha(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()

assert sha(archive) == 'd07e8b2dae5d92715e91acd61d90048c1774a6b11dbd85a79a6a77007a8075f0'
assert sha(manifest) == '85a00afd88025121f5ac4fb862e780c71a06bd863cada5d50901e0bfc4ca19fc'
data = json.loads(manifest.read_text())
assert data['source'] == '299c6aca30c1245c15c2da6a5ccabb41dd435d17'
expected = {entry['member']: entry for entry in data['payload_members']}
assert len(expected) == len(data['payload_members']) == 1503
seen = set()
total = 0
with tarfile.open(archive, 'r|gz') as stream:
    for member in stream:
        assert member.isfile() and member.name not in seen, member.name
        seen.add(member.name)
        file = stream.extractfile(member)
        h = hashlib.sha256()
        size = 0
        while block := file.read(1024 * 1024):
            size += len(block)
            h.update(block)
        if member.name == 'capture-manifest.json':
            assert size == manifest.stat().st_size and h.hexdigest() == sha(manifest)
        else:
            entry = expected[member.name]
            assert size == entry['bytes'] and h.hexdigest() == entry['sha256'], member.name
            total += size
assert seen == set(expected) | {'capture-manifest.json'}
for entry in data['external_elf']:
    path = Path(entry['source_path'])
    assert path.stat().st_size == entry['bytes'] and sha(path) == entry['sha256'], str(path)
git = ['git', '-c', 'safe.directory=/tmp/gpui-legacy-coverage-sol', '-C', '/tmp/gpui-legacy-coverage-sol']
assert subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip() == data['source']
assert not subprocess.check_output(git + ['status', '--porcelain'], text=True).strip()
out.mkdir(parents=True, exist_ok=False)
shutil.copy2(archive, out / 'captures.tar.gz')
assert sha(out / 'captures.tar.gz') == sha(archive)
shutil.copy2(manifest, out / 'capture-manifest.json')
for name in ['README.md', 'cost-ledger.json', 'payload-ledger.json', 'port-audit.md', 'source-audit.json']:
    shutil.copy2(evidence / name, out / name)
report = {'source': data['source'], 'archive_sha256': sha(archive),
          'archive_bytes': archive.stat().st_size, 'payload_members': len(expected),
          'payload_bytes': total, 'external_elf_verified': len(data['external_elf']),
          'every_archive_member_independently_stream_hashed': True,
          'producer_tree_clean': True, 'production_source_adopted': False,
          'scope': 'Correctness/static-cost producer archive. Later fixed timing failed regression gates; see separate campaign.'}
(out / 'root-verification.json').write_text(json.dumps(report, indent=2) + '\n')
(out / 'ROOT-REVIEW.md').write_text('''# Root review of the legacy-packet coverage experiment

Root independently rehashed all 1,503 payloads, the embedded manifest and nine externally retained ELF artifacts. The source tree remains clean at `299c6aca30c1245c15c2da6a5ccabb41dd435d17`. This archive copies no production implementation into main.

The producer README is deliberately preserved as written before timing. It qualifies the ordinary five/six-word packet ABI with constant/opaque-prefix coverage and the borrowed whole-bounds certificate. The later frozen 11-pair comparison has now run: exact images and aggregate speed pass, but independent per-cell regression gates fail. The implementation remains unadopted. This earlier correctness archive does not override that result.

All 52 public SDR/HDR images match shipping; all 578 named inherited captures match the exact legacy control. Both real pixel-fault controls fail and recover after exact restoration. Default/fallback/offline and foreign source-compilation checks are recorded. Strict host IEEE implications and qualified software-driver readbacks do not establish universal WGSL arithmetic, altered host DAZ/FTZ, hardware or foreign runtime behavior.

Against the exact shipping GPU comparison, this branch adds 142 non-test noncomment core lines and 5,376 linked text bytes. Render and binning static frames each grow 32 and 16 bytes respectively. Full ordinary warm uploads remain charged: 1,108,272 bytes for runs32k and 3,076,272 for singleton32k. There are no new proof heap fields; this is not a measured RSS saving. These are historical branch-local costs, not current main's core total.
''')
print(json.dumps(report))
