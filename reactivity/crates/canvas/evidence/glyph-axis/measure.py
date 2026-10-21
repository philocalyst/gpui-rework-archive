import csv
import hashlib
import io
import json
import os
from pathlib import Path
import statistics
import subprocess
import time

OUT = Path('/tmp/gpui-glyph-axis-controls')
OUT.mkdir(exist_ok=True)
BINARIES = {
    'output_cache': Path('/tmp/gpui-glyph-baseline-target/release/examples/parallel'),
    'glyph_axis': Path('/tmp/gpui-axis-target/release/examples/parallel'),
}
rows = []
binary_hashes = {version: hashlib.sha256(path.read_bytes()).hexdigest()
                 for version, path in BINARIES.items()}
for version, expected_samples in [('output_cache', 1846272), ('glyph_axis', 126744)]:
    environment = os.environ.copy()
    environment.pop('GPUI_RENDER_HDR', None)
    probe = subprocess.run([str(BINARIES[version])], env=environment,
                           text=True, capture_output=True, check=True)
    parsed = list(csv.DictReader(io.StringIO(probe.stdout)))
    labels = [row for row in parsed if row['scene'] == 'labels']
    assert len(labels) == 5 and all(int(row['samples']) == expected_samples
                                    for row in labels), (version, labels)
    (OUT / f'{version}-activation.csv').write_text(probe.stdout)
started = time.time()
for repetition in range(5):
    for profile in ['sdr', 'hdr']:
        order = list(BINARIES)
        if repetition % 2:
            order.reverse()
        for version in order:
            assert hashlib.sha256(BINARIES[version].read_bytes()).hexdigest() == binary_hashes[version]
            environment = os.environ.copy()
            environment.pop('GPUI_RENDER_HDR', None)
            if profile == 'hdr':
                environment['GPUI_RENDER_HDR'] = '1'
            result = subprocess.run([str(BINARIES[version])], env=environment,
                                    text=True, capture_output=True, check=True)
            stem = OUT / f'{profile}-{version}-{repetition}'
            stem.with_suffix('.csv').write_text(result.stdout)
            stem.with_suffix('.stderr').write_text(result.stderr)
            parsed = list(csv.DictReader(io.StringIO(result.stdout)))
            assert len(parsed) == 25, (stem, len(parsed))
            for row in parsed:
                rows.append(dict(profile=profile, version=version,
                                 repetition=repetition, **row))
            print(f'{repetition} {profile} {version} complete', flush=True)

invariants = ['digest', 'parallel', 'commands', 'refs', 'output_bytes',
              'command_bytes', 'bin_bytes', 'mask_payload']
groups = {}
for row in rows:
    key = row['profile'], row['scene'], row['workers']
    groups.setdefault(key, []).append(row)
summary = []
for key, group in sorted(groups.items()):
    for field in invariants:
        assert len({row[field] for row in group}) == 1, (key, field, group)
    timings = {version: statistics.median(float(row['median_frame_us'])
               for row in group if row['version'] == version)
               for version in BINARIES}
    summary.append(dict(profile=key[0], scene=key[1], workers=int(key[2]),
                        **timings,
                        change_percent=100 * (timings['glyph_axis'] /
                                              timings['output_cache'] - 1)))
with (OUT / 'paired.csv').open('w') as output:
    writer = csv.DictWriter(output, fieldnames=list(rows[0]))
    writer.writeheader()
    writer.writerows(rows)
metadata = dict(
    baseline_source='62f68419395bc501ffc8e781f306dd74c7d9cbda',
    candidate_source='0a16952cf3',
    binary_sha256=binary_hashes,
    affinity=sorted(os.sched_getaffinity(0)),
    duration_seconds=time.time() - started,
    rows=len(rows),
    summary=summary,
)
(OUT / 'measurements.json').write_text(json.dumps(metadata, indent=2) + '\n')
print(json.dumps(metadata, indent=2))
