from pathlib import Path
import hashlib
import json
import os
import re
import shutil
import signal
import subprocess

root = Path('/root/gpui-ce3')
out = root / 'reactivity/ports/hummingbird/qualification/main-source-authority-integration'
digest = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
before = json.loads((out / 'source-before.json').read_text())
for name in ['default', 'native', 'clippy-default', 'clippy-native', 'format', 'native-build']:
    assert (out / f'{name}.exit').read_text().strip() == '0', name
after = {name: digest(root / name) for name in before}
(out / 'source-after-tests.json').write_text(json.dumps(after, indent=2) + '\n')
assert before == after, 'Compiler inputs changed during qualification'
counts = {}
for name in ['default', 'native']:
    rows = re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored;', (out / f'{name}.log').read_text())
    assert rows and all(int(failed) == 0 for _, failed, _ in rows)
    counts[name] = {'passed': sum(int(a) for a,b,c in rows), 'failed': sum(int(b) for a,b,c in rows),
                    'ignored': sum(int(c) for a,b,c in rows), 'harnesses': len(rows)}
summary = counts | {'source_guards': len(before), 'guards_match': True}
(out / 'test-summary.json').write_text(json.dumps(summary, indent=2) + '\n')
print(json.dumps(summary), flush=True)

source = Path(os.environ['CARGO_TARGET_DIR']) / 'debug/examples/native_service'
frozen = Path('/tmp/gpui-hummingbird-main-source-authority-frozen-20261023')
frozen.mkdir(exist_ok=False)
binary = frozen / source.name
shutil.copy2(source, binary)
assert digest(source) == digest(binary)
(out / 'native-binary.json').write_text(json.dumps({'source': str(source), 'frozen_binary': str(binary),
    'sha256': digest(binary), 'bytes': binary.stat().st_size, 'runtime': '9f83f23288bbb364142ff2a82d059b6d99670a7e'}, indent=2) + '\n')
command = ['dbus-run-session', '--', '/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3',
    'reactivity/ports/hummingbird/native-service.py', str(binary), str(out / 'native-service')]
(out / 'native-command.json').write_text(json.dumps({'argv': command, 'cwd': str(root), 'outer_timeout_seconds': 180,
    'existing_client_deadline_seconds': 150, 'scope': 'Public Registry/SQL/audio-service behavior; counting output, no hardware or timing claim'}, indent=2) + '\n')
env = dict(os.environ, GIT_CONFIG_COUNT='1', GIT_CONFIG_KEY_0='safe.directory', GIT_CONFIG_VALUE_0=str(root))
with (out / 'native-service.log').open('w') as log:
    process = subprocess.Popen(command, cwd=root, env=env, stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
    try:
        status = process.wait(timeout=180)
    except subprocess.TimeoutExpired:
        os.killpg(process.pid, signal.SIGTERM)
        try:
            process.wait(timeout=5)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGKILL)
            process.wait()
        status = 124
(out / 'native-service.exit').write_text(str(status) + '\n')
final = {name: digest(root / name) for name in before}
(out / 'source-after-native.json').write_text(json.dumps(final, indent=2) + '\n')
assert before == final, 'Compiler inputs changed during native capture'
assert digest(binary) == json.loads((out / 'native-binary.json').read_text())['sha256']
assert status == 0, f'Native client failed: {status}'
assert json.loads((out / 'native-service/result.json').read_text())['passed']
assert json.loads((out / 'native-service/before.json').read_text()) == json.loads((out / 'native-service/after.json').read_text())
print('PASS: actual Registry source-authority integration; immutable binary and all input guards match', flush=True)
