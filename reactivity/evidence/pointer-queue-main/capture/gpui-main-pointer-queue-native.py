from pathlib import Path
import hashlib, json, os, signal, subprocess, traceback

root = Path('/root/gpui-ce3')
previous = Path('/tmp/gpui-main-pointer-queue-gates')
out = Path('/tmp/gpui-main-pointer-queue-native')
out.mkdir(exist_ok=False)
digest = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
guard = json.loads((previous / 'source-guard.json').read_text())
def check():
    assert {name: digest(root / name) for name in guard} == guard
results = json.loads((previous / 'results.json').read_text())
expected = ['gpui-gpu-full', 'gpui-gpu-strict', 'hummingbird-default', 'hummingbird-native', 'hummingbird-strict-default', 'hummingbird-strict-native', 'format-core', 'format-app', 'hummingbird-native-build']
assert [r['case'] for r in results[:9]] == expected
assert all(r['exit'] == 0 for r in results[:9])
assert results[-1]['case'] == 'native-original' and results[-1]['exit'] != 0
assert 'failed to exec' in (previous / 'native-original.log').read_text()
binary = previous / 'hummingbird-native-frozen'
binary_hash = digest(binary)
metadata = {'source': json.loads((previous / 'metadata.json').read_text())['source'], 'guarded_files': len(guard), 'prior_results_sha256': digest(previous / 'results.json'), 'binary_sha256': binary_hash, 'reason': 'The completed qualification prefix is preserved. The initial native launch failed before the app because python3 was absent from PATH; use the known absolute interpreter.', 'limits': 'Actual private-bus Linux X11/AT-SPI and llvmpipe rendering behavior, not hardware performance, startup, RSS, HDR or foreign-OS runtime.'}
rows = []
try:
    for index, (label, script, renderer) in enumerate([
        ('original-cpu', '/tmp/gpui-rapid-pointer-native-client.py', 'cpu'),
        ('rapid-loop-cpu', '/tmp/gpui-rapid-pointer-native-loop-client.py', 'cpu'),
        ('original-gpu', '/tmp/gpui-rapid-pointer-native-client.py', 'gpu'),
        ('rapid-loop-gpu', '/tmp/gpui-rapid-pointer-native-loop-client.py', 'gpu'),
    ]):
        check()
        assert digest(binary) == binary_hash
        command = ['dbus-run-session', '--', '/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3', script, str(binary), '--xvfb', '/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb', '--xdotool', '/nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool', '--atspi-launcher', '/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher', '--renderer', renderer, '--display', f':{201 + index}', '--output', str(out / f'{label}.json')]
        with (out / f'{label}.log').open('w') as log:
            process = subprocess.Popen(command, cwd=root / 'reactivity', stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
            try:
                code = process.wait(timeout=300)
            except BaseException:
                os.killpg(process.pid, signal.SIGTERM)
                try:
                    process.wait(timeout=10)
                except subprocess.TimeoutExpired:
                    os.killpg(process.pid, signal.SIGKILL)
                    process.wait()
                raise
        row = {'case': label, 'command': command, 'exit': code, 'client_sha256': digest(Path(script)), 'log_sha256': digest(out / f'{label}.log')}
        rows.append(row)
        (out / 'results.json').write_text(json.dumps(rows, indent=2) + '\n')
        print(json.dumps(row), flush=True)
        assert code == 0, row
        check()
    assert digest(binary) == binary_hash
    metadata.update(status='passed', source_unchanged=True)
except BaseException:
    metadata.update(status='failed', failure=traceback.format_exc())
    (out / 'metadata.json').write_text(json.dumps(metadata, indent=2) + '\n')
    raise
(out / 'metadata.json').write_text(json.dumps(metadata, indent=2) + '\n')
