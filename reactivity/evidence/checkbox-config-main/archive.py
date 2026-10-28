from pathlib import Path
import gzip
import hashlib
import json
import re
import shutil

root = Path('/root/gpui-ce3')
source = Path('/tmp/gpui-checkbox-config-main-gates')
destination = root / 'reactivity/evidence/checkbox-config-main'
destination.mkdir(exist_ok=True)
digest = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
metadata = json.loads((source / 'metadata.json').read_text())
guard = json.loads((source / 'source-guard.json').read_text())
results = json.loads((source / 'results.json').read_text())
assert metadata['source'] == 'f490974fdc1ff440762a01fedc4d2b4a6c40417c'
assert metadata['source_unchanged'] and metadata['owned_display_stopped']
assert len(results) == 15 and all(row['exit'] == 0 for row in results)
assert all(digest(root / name) == value for name, value in guard.items())
assert all(digest(Path(name)) == value for name, value in metadata['executables'].items())
assert all(digest(source / (row['case'] + '.log')) == row['log_sha256'] for row in results)
counts = re.findall(r'test result: ok\. (\d+) passed; \d+ failed; (\d+) ignored',
                    (source / 'gpui-full.log').read_text())
assert (len(counts), sum(int(a) for a, _ in counts), sum(int(b) for _, b in counts)) == (49, 542, 28)
for name, expected in [('hummingbird-tests', 9), ('catalog-client', 5)]:
    counts_in_log = re.findall(r'test result: ok\. (\d+) passed;', (source / (name + '.log')).read_text())
    assert sum(map(int, counts_in_log)) == expected
for name in ('checkbox-native', 'late-service', 'future-wake', 'blank-handoff'):
    assert '1 passed; 0 failed' in (source / (name + '.log')).read_text()
transcript = json.loads((source / 'hummingbird-gpu.json').read_text())
assert len(transcript['presented_frames']) == 8
assert {frame[0] for frame in transcript['presented_frames']} == {'Gpu'}
for path in sorted(source.iterdir()):
    if path.name.endswith('-frozen'):
        continue
    if path.suffix == '.log':
        (destination / (path.name + '.gz')).write_bytes(gzip.compress(path.read_bytes(), mtime=0))
    else:
        shutil.copyfile(path, destination / path.name)
shutil.copyfile('/tmp/gpui-checkbox-config-main-gates.py', destination / 'guard-driver.py')
shutil.copyfile(__file__, destination / 'archive.py')
qualification = {
    'source': metadata['source'], 'gates': len(results), 'gpui_passed': 542,
    'gpui_ignored': 28, 'gpui_harnesses': 49, 'hummingbird_passed': 9,
    'catalog_client_passed': 5, 'hummingbird_native_renderer': 'Gpu',
    'hummingbird_native_frames': 8, 'guarded_files': len(guard),
    'source_and_binaries_unchanged': True, 'owned_displays_stopped': True,
    'limits': 'Behavior and compilation only. No new timing/RSS/native-heap attribution, native HDR, hardware conformance or foreign-OS runtime. Earlier Canvas/GPU and CPU/Auto evidence retains its separate ebfdb2 pin.'
}
(destination / 'qualification.json').write_text(json.dumps(qualification, indent=2) + '\n')
print(json.dumps(qualification, indent=2))
