from pathlib import Path
import subprocess, json, hashlib

r = Path(__file__).parent
old = json.loads(Path('/home/user/gpui-region-batch-evidence/matrix-artifacts.json').read_text())
artifacts = {n: old[n] for n in ['control', 'bounds', 'predecessor']}
def sha(p):
    return hashlib.file_digest(p.open('rb'), 'sha256').hexdigest()
for n, path, target, source, gate in [
    ('candidate', '/home/user/gpui-scroll-sparse-lab', '/home/user/gpui-scroll-sparse-target',
     '5a07d7c28ffe500a5d24e25fdf1f31ce4857811f', 'full-native-precise'),
    ('copy_bounds', '/home/user/gpui-scroll-sparse-bounds-lab', '/home/user/gpui-scroll-sparse-bounds-target',
     '599e36c149ea252f96056f3d8e827da137f71197', 'cost-build-copy_bounds-retry'),
]:
    g = r / gate
    assert json.loads((g / 'guard-after.json').read_text()) == []
    for stage in ['build', 'test', 'port', 'clippy'] + (['gpu-test', 'gpu-clippy'] if n == 'copy_bounds' else []):
        assert json.loads((g / (stage + '.status.json')).read_text())['exit'] == 0
    assert (g / 'source.txt').read_text().strip() == source
    a = json.loads((g / 'unit-artifact.json').read_text())
    fp = json.loads((Path(a['path']).parent.parent / 'fingerprint/test-lib-gpui.json').read_text())
    assert 'x11' in json.loads(fp['features'])
    artifacts[n] = {**a, 'variant': n, 'worktree': path, 'target': target, 'source': source,
        'inputs': str(g / 'inputs.json'), 'gate': str(g), 'fingerprint': fp,
        'native_artifact': json.loads((g / 'artifact.json').read_text())}
fixtures = {}
shaders = {}
for n, a in artifacts.items():
    w = Path(a['worktree'])
    assert not subprocess.check_output(['git', 'status', '--porcelain'], cwd=w).strip()
    assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=w, text=True).strip() == a['source']
    assert sha(Path(a['preserved'])) == a['sha256']
    before = json.loads(Path(a['inputs']).read_text())
    after = {p: sha(w / p) for p in subprocess.check_output(
        ['git', 'ls-files', '-z', 'reactivity', '.cargo', 'clippy.toml'], cwd=w
    ).decode().split('\0') if p and (w / p).is_file()}
    assert before == after
    fixtures[n] = {p: after[p] for p in [
        'reactivity/crates/gpui/examples/zgx_native_lab.rs',
        'reactivity/crates/gpui/src/native/scroll_bench.rs',
        'reactivity/crates/gpui/src/native/text_cost.rs',
        'reactivity/Cargo.toml', 'reactivity/Cargo.lock', '.cargo/config.toml']}
    files = list((Path(a['target']) / 'release/build/gpui_gpu').glob('*/out/ui.wgsl'))
    assert files
    values = {sha(p): p.read_bytes() for p in files}
    assert set(values) == {'ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1'}
    h, data = next(iter(values.items()))
    elf = Path(a['preserved']).read_bytes()
    offset = elf.find(data)
    assert offset >= 0
    native = a['native_artifact']
    assert sha(Path(native['preserved'])) == native['sha256']
    native_offset = Path(native['preserved']).read_bytes().find(data)
    assert native_offset >= 0
    shaders[n] = {'canonical_sha256': h, 'bytes': len(data), 'unit_elf_offset': offset,
        'native_elf_offset': native_offset, 'typed_source_sha256': after['reactivity/crates/gpu/src/shader.rs']}
for n, a in artifacts.items():
    assert fixtures[n] == fixtures['candidate']
    assert a['cargo']['profile'] == artifacts['candidate']['cargo']['profile']
    assert a['cargo']['features'] == artifacts['candidate']['cargo']['features']
    assert shaders[n]['typed_source_sha256'] == shaders['candidate']['typed_source_sha256']
research = Path('/home/user/gpui-architecture-local')
for src, dest in [('PROCESS_ORDER.json', 'process-order.json'), ('COST.json', 'cost-definition.json')]:
    assert subprocess.check_output(['git', 'show',
        'a13c3629f0efc6a6a640a02530400d640244faf9:reactivity/evidence/scroll-sparse/' + src], cwd=research) == (r / dest).read_bytes()
for path, value in [('matrix-artifacts.json', artifacts), ('matrix-fixture-equality.json', fixtures), ('matrix-shader-receipt.json', shaders)]:
    assert not (r / path).exists()
    (r / path).write_text(json.dumps(value, indent=2))
print('five source/artifact/profile/fixture/canonical shader sets frozen; final qualification still required')
