from pathlib import Path
import hashlib, json, subprocess

root = Path('/root/gpui-ce3')
out = Path('/tmp/gpui-combined-native-gates')
binary = Path('/tmp/gpui-combined-native-test-bin')
digest = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
binary_hash = digest(binary)
before = json.loads((out / 'before-source.json').read_text())
def guard():
    assert {p: digest(root / p) for p in before} == before
    assert digest(binary) == binary_hash
wrong = out / 'headers.log'
if wrong.exists():
    wrong.rename(out / 'control-wrong-header-test-filter.log')
cases = [
    ('owner-ledger', 'runtime::inspector::tests::plain_window_has_no_tool_allocation_and_inspector_uses_only_cold_storage'),
    ('headers', 'runtime::style_port_tests::ordinary_headers_and_literal_owner_allocation_floor_remain_unchanged'),
]
rows = []
for name, case in cases:
    guard()
    command = [str(binary), case, '--exact', '--nocapture', '--test-threads=1']
    log = out / f'{name}.log'
    if name != 'owner-ledger':
        with log.open('w') as stream:
            result = subprocess.run(command, cwd=root / 'reactivity', stdout=stream, stderr=subprocess.STDOUT, timeout=60)
        assert result.returncode == 0
    assert '1 passed; 0 failed' in log.read_text()
    guard()
    print(log.read_text())
    rows.append({'case': name, 'command': command, 'exit': 0, 'log_sha256': digest(log)})
(out / 'owner-ledger.json').write_text(json.dumps({
    'library_source': '6d77c71c1227bd2609518cc5f3a49e37fc176f82',
    'binary_sha256': binary_hash, 'source_unchanged': True,
    'profile': 'desktop,x11,wayland,gpui_canvas/parallel,cephal/verify-cache',
    'qualification': 'Current-thread Rust requested retained bytes, not RSS or native window memory. The wrong exact header filter ran zero tests and is preserved separately; the corrected filter requires one passed case.',
    'checks': rows,
}, indent=2) + '\n')
