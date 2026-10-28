from pathlib import Path
import csv
import hashlib
import io
import json
import shutil
import tarfile

archive = Path('/tmp/gpui-legacy-timing-frozen-campaign.tar.gz')
manifest = Path('/tmp/gpui-legacy-timing-capture-manifest.json')
evidence = Path('/tmp/gpui-legacy-timing-evidence')
out = Path('/root/gpui-ce3/reactivity/evidence/uniform-packet/legacy-timing')

def sha(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()

assert sha(archive) == 'd42ba1cc8f1756fb714861dc838bd69d38700590a74616d972e41889553853fd'
assert sha(manifest) == 'ef2e19e669ef1904c0db55f0cf5fc0e89aff86fe72e703e48c2e0a61c0665369'
data = json.loads(manifest.read_text())
assert data['candidate'] == '299c6aca30c1245c15c2da6a5ccabb41dd435d17'
assert data['status'] == 'correctness PASS; speed PASS; independent regression FAIL; unadopted'
expected = {entry['member']: entry for entry in data['payload_members']}
assert len(expected) == len(data['payload_members']) == 5528
seen = set()
total = frames = readbacks = 0
legs = set()
images = {}
with tarfile.open(archive, 'r|gz') as stream:
    for member in stream:
        assert member.isfile() and member.name not in seen, member.name
        seen.add(member.name)
        file = stream.extractfile(member)
        h = hashlib.sha256()
        size = 0
        csv_body = [] if member.name.startswith('evidence/measure/pair-') and member.name.endswith('/frames.csv') else None
        while block := file.read(1024 * 1024):
            size += len(block)
            h.update(block)
            if csv_body is not None:
                csv_body.append(block)
        if member.name == 'capture-manifest.json':
            assert size == manifest.stat().st_size and h.hexdigest() == sha(manifest)
            continue
        entry = expected[member.name]
        assert size == entry['bytes'] and h.hexdigest() == entry['sha256'], member.name
        total += size
        if csv_body is not None:
            legs.add(member.name.split('/')[2])
            rows = list(csv.DictReader(io.StringIO(b''.join(csv_body).decode())))
            assert len(rows) == 312
            frames += len(rows)
        if member.name.startswith('evidence/measure/pair-') and member.name.endswith('.bin'):
            leg, image = member.name.split('/')[2:]
            pair, arm = leg.rsplit('-', 1)
            images.setdefault((pair, image), {})[arm] = (size, h.hexdigest())
            readbacks += 1
assert seen == set(expected) | {'capture-manifest.json'}
assert len(legs) == 22 and frames == 6864 and readbacks == 2288
assert len(images) == 1144 and all(set(arms) == {'A', 'B'} and arms['A'] == arms['B'] for arms in images.values())
for entry in data['external_elf']:
    path = Path(entry['source_path'])
    assert path.stat().st_size == entry['bytes'] and sha(path) == entry['sha256'], str(path)

out.mkdir(parents=True, exist_ok=False)
# Keep each Git blob below 64 MiB; concatenation exactly recovers the sealed gzip.
parts = []
combined = hashlib.sha256()
with archive.open('rb') as source:
    index = 1
    while block := source.read(64 * 1024 * 1024):
        path = out / f'captures.tar.gz.part-{index:02}'
        path.write_bytes(block)
        combined.update(block)
        parts.append({'file': path.name, 'bytes': path.stat().st_size, 'sha256': sha(path)})
        index += 1
assert combined.hexdigest() == sha(archive)
shutil.copy2(manifest, out / 'capture-manifest.json')
for name in ['README.md', 'protocol.md', 'frozen-before-measurement.json', 'qualification-preflight-summary.json']:
    if (evidence / name).is_file():
        shutil.copy2(evidence / name, out / name)
for name in ['analysis.json', 'result-summary.json', 'per-cell-report.md', 'per-cell-gate-ledger.csv', 'worst-frame-rows.json', 'campaign.json']:
    shutil.copy2(evidence / 'measure' / name, out / name)
report = {'source': data['candidate'], 'archive_sha256': sha(archive),
          'archive_bytes': archive.stat().st_size, 'parts': parts,
          'payload_members': len(expected), 'payload_bytes': total,
          'external_elf_verified': len(data['external_elf']),
          'independently_counted_legs': len(legs), 'independently_counted_csv_frames': frames,
          'independently_counted_raw_readbacks': readbacks,
          'independently_matched_image_pairs': len(images),
          'every_archive_member_independently_stream_hashed': True,
          'production_source_adopted': False, 'status': data['status']}
(out / 'root-verification.json').write_text(json.dumps(report, indent=2) + '\n')
(out / 'ROOT-REVIEW.md').write_text('''# Root review of the fixed legacy-packet comparison

The frozen 11-pair comparison completes all 22 fresh processes and 6,864 warmup/measured frames. Root independently reopens and hashes all 5,528 archive payloads and fourteen external ELF artifacts, parses/counts every measured frame CSV, and matches all 1,144 paired raw images byte-for-byte by size/hash. No source implementation is adopted.

Correctness and aggregate speed pass; independent per-cell regression fails. The median paired aggregate host ratio is 0.9366274241, total render/poll wall ratio 0.4417257137 and poll-wall ratio 0.4373844602. Host gates pass only 2/26 cells and total gates 22/26; there are 46 regression-rule failures. The worst host maximum-frame ratio is 1.8032928943 for rounded SDR motion, and worst total maximum-frame ratio is 2.5778517993 for flat SDR motion. The complete failed-cell and frame-row tables are copied beside this review. Aggregate gains do not override those failures.

The run lasts 207.673867 seconds, with unchanged preregistered workload, analyzer, thresholds and watchdogs. No retries or dropped cells occurred. Source/compiler/binary/quiet guards pass; ordinary system services and the existing package-store ticker remain visible in process snapshots. This is llvmpipe software Vulkan, not isolated-machine or hardware GPU evidence. Poll wall time is not a GPU timestamp; no startup or RSS result follows.

Static growth and full legacy uploads remain charged in the preceding legacy-coverage dossier. The earlier uniform-packet failed comparison remains separate and unchanged. This source is a useful work-elimination experiment with failed adoption gates, not a new shipping renderer.

The original gzip is stored in ordered parts smaller than 64 MiB. Reconstruct with `cat captures.tar.gz.part-* > /tmp/gpui-legacy-timing-frozen-campaign.tar.gz`; its SHA256 is recorded in root-verification.json. The producer README and all raw failed evidence remain byte-exact.
''')
print(json.dumps(report))
