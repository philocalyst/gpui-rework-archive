from pathlib import Path
import hashlib
import json
import mmap
import shutil

build = Path('/tmp/gpui-certified-main-native-build')
assert json.loads((build / 'result.json').read_text())['exit'] == 0
rows = [json.loads(line) for line in (build / 'stdout.log').read_text().splitlines()]
generated = [row for row in rows if row.get('reason') == 'build-script-executed' and '#gpui_gpu@' in row.get('package_id', '')]
assert len(generated) == 1, generated
path = Path(generated[0]['out_dir']) / 'ui.wgsl'
data = path.read_bytes()
digest = hashlib.sha256(data).hexdigest()
assert digest == 'bfc3c458b4632b081f03ceeb2b33cd5d4cef757dbb6063ae55838c01ffa1f185', digest
artifacts = [row for row in rows if row.get('reason') == 'compiler-artifact' and row.get('executable') and row['profile']['test'] and row['target']['name'] == 'gpui']
assert len(artifacts) == 1
binary = Path(artifacts[0]['executable'])
with binary.open('rb') as stream:
    with mmap.mmap(stream.fileno(), 0, access=mmap.ACCESS_READ) as mapping:
        assert mapping.find(data) >= 0, 'actual WGSL missing from linked native ELF'
with binary.open('rb') as stream:
    binary_digest = hashlib.file_digest(stream, 'sha256').hexdigest()
out = Path('/tmp/gpui-certified-main-native')
shutil.copyfile(path, out / 'ui.wgsl')
report = {'source': json.loads((build / 'result.json').read_text())['source'], 'generated': str(path),
          'wgsl_sha256': digest, 'wgsl_bytes': len(data), 'linked_native_ELF': str(binary),
          'ELF_sha256': binary_digest, 'complete_generated_WGSL_in_linked_ELF': True,
          'expected_shader_source': '7ccc65d2673a64499d805f41aaa0e423f15de2ce',
          'scope': 'Actual fresh generated shader and linked binary identity; no runtime inference.'}
(out / 'generated-shader-proof.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(report), flush=True)
