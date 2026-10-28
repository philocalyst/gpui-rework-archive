from pathlib import Path
import json, hashlib, subprocess

r = Path(__file__).parent
t = Path('/home/user/gpui-scroll-sparse-target/release/build/gpui_gpu')
out = r / 'generated-shaders'
out.mkdir(exist_ok=False)
rows = []
for p in sorted(t.glob('*/out/*')):
    if not p.is_file() or p.suffix not in ['.wgsl', '.spv', '.json', '.rs']:
        continue
    data = p.read_bytes()
    h = hashlib.sha256(data).hexdigest()
    q = out / (h + '-' + p.name)
    if not q.exists():
        q.write_bytes(data)
    assert q.read_bytes() == data
    rows.append({'path': str(p), 'saved': str(q), 'bytes': len(data), 'sha256': h})
ui = {q['sha256'] for q in rows if q['path'].endswith('/ui.wgsl')}
assert ui == {'ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1'}
assert not any(Path(q['path']).name.startswith('region') for q in rows)
spirv = {q['sha256'] for q in rows if q['path'].endswith('.spv')}
assert spirv
validator = Path('/home/user/gpui-region-validator/extracted/usr/bin/spirv-val')
validator_hash = hashlib.file_digest(validator.open('rb'), 'sha256').hexdigest()
assert validator_hash == '20c5998a46f02310f56bf11be238c34d374bb50104b7ccf85bb909f9da883ff9'
validation = []
for h in sorted(spirv):
    q = next(q for q in rows if q['sha256'] == h)
    command = [str(validator), '--target-env', 'vulkan1.0', q['saved']]
    p = subprocess.run(command, capture_output=True, text=True)
    assert p.returncode == 0, p.stderr
    validation.append({'sha256': h, 'command': command, 'exit': p.returncode,
        'stdout': p.stdout, 'stderr': p.stderr})
binaries = []
for gate in ['gpu-precise-first', 'offline-precise', 'full-native-precise']:
    file = 'build-artifacts.json' if gate == 'full-native-precise' else 'test-artifacts.json'
    artifacts = json.loads((r / gate / file).read_text())
    artifacts = [a for a in artifacts if gate == 'full-native-precise' or (
        a['cargo']['target']['name'] == 'render' and a['cargo']['manifest_path'].endswith('/crates/gpu/Cargo.toml'))]
    assert len(artifacts) == 1
    a = artifacts[0]
    data = Path(a['preserved']).read_bytes()
    assert hashlib.sha256(data).hexdigest() == a['sha256']
    embedded = []
    for q in rows:
        if q['sha256'] in {x['sha256'] for x in embedded}:
            continue
        raw = Path(q['saved']).read_bytes()
        offset = data.find(raw)
        if offset >= 0:
            embedded.append({'name': Path(q['path']).name, 'sha256': q['sha256'],
                'offset': offset, 'bytes': len(raw)})
    found = {x['sha256'] for x in embedded}
    assert ui <= found
    if gate == 'offline-precise':
        assert spirv <= found
    binaries.append({'gate': gate, 'artifact': a, 'embedded': embedded})
(out / 'receipt.json').write_text(json.dumps({'generated_files': rows, 'binaries': binaries,
    'validator': {'path': str(validator), 'sha256': validator_hash, 'results': validation},
    'note': 'Canonical typed/generated equality tests passed. Canonical WGSL occurs in executed regular/offline GPU render tests and native example. Every generated SPIR-V variant validates and occurs in the offline render ELF. No new shader or region-instanced pipeline.'}, indent=2))
print('shader files', len(rows), 'executed binaries', len(binaries), 'unique SPIR-V modules', len(spirv))
