from pathlib import Path
import hashlib
import json
import os
import shutil
import signal
import subprocess

root = Path('/root/gpui-ce3')
out = root / 'reactivity/ports/hummingbird/qualification/main-source-authority-integration/original-clients'
out.mkdir(exist_ok=False)
git = ['git', '-c', f'safe.directory={root}', '-C', str(root)]
paths = subprocess.check_output(git + ['ls-files', '.cargo/config.toml', 'reactivity/Cargo.toml',
    'reactivity/Cargo.lock', 'reactivity/crates', 'reactivity/vendor', 'reactivity/ports/hummingbird'], text=True).splitlines()
paths = [name for name in paths if '/qualification/' not in name and '/evidence/' not in name]
digest = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
guard = lambda: {name: digest(root / name) for name in paths}
before = guard()
(out / 'before.json').write_text(json.dumps(before, indent=2) + '\n')
results = []
env = dict(os.environ, GIT_CONFIG_COUNT='1', GIT_CONFIG_KEY_0='safe.directory', GIT_CONFIG_VALUE_0=str(root))
def run(name, command, timeout):
    assert before == guard(), 'Source changed before ' + name
    with (out / f'{name}.log').open('w') as log:
        process = subprocess.Popen(command, cwd=root, env=env, stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
        try:
            status = process.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGTERM)
            try:
                process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGKILL)
                process.wait()
            status = 124
    row = {'case': name, 'argv': command, 'timeout_seconds': timeout, 'exit': status}
    results.append(row)
    (out / 'results.json').write_text(json.dumps(results, indent=2) + '\n')
    print(json.dumps(row), flush=True)
    assert before == guard(), 'Source changed during ' + name
    assert status == 0, row
run('native-build', ['cargo', 'build', '--manifest-path', 'reactivity/ports/hummingbird/Cargo.toml',
    '--offline', '--locked', '--features', 'native', '--bin', 'hummingbird-gpui-port'], 300)
source = Path(os.environ['CARGO_TARGET_DIR']) / 'debug/hummingbird-gpui-port'
binary = Path('/tmp/gpui-hummingbird-main-source-authority-frozen-20261023/hummingbird-gpui-port')
assert not binary.exists()
shutil.copy2(source, binary)
sealed = digest(binary)
(out / 'binary.json').write_text(json.dumps({'source': str(source), 'frozen_binary': str(binary),
    'bytes': binary.stat().st_size, 'sha256': sealed}, indent=2) + '\n')
run('headless', [str(binary), '--headless'], 60)
displays = []
for renderer in ['cpu', 'gpu', 'auto']:
    display = next(n for n in range(180, 210) if not Path(f'/tmp/.X11-unix/X{n}').exists() and not Path(f'/tmp/.X{n}-lock').exists())
    displays.append(display)
    run('native-' + renderer, ['dbus-run-session', '--', '/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3',
        'reactivity/ports/hummingbird/native-transcript.py', str(binary),
        '--xvfb', '/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb',
        '--xdotool', '/nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool',
        '--atspi-launcher', '/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher',
        '--output', str(out / f'native-{renderer}.json'), '--display', f':{display}', '--renderer', renderer], 90)
    assert digest(binary) == sealed
    assert not Path(f'/tmp/.X11-unix/X{display}').exists()
    assert not Path(f'/tmp/.X{display}-lock').exists()
after = guard()
(out / 'after.json').write_text(json.dumps(after, indent=2) + '\n')
assert before == after and digest(binary) == sealed
(out / 'summary.json').write_text(json.dumps({'passed': True, 'runtime': '9f83f23288bbb364142ff2a82d059b6d99670a7e',
    'source_guards': len(before), 'guards_match': True, 'binary_unchanged': True,
    'owned_displays_stopped': True, 'displays': displays,
    'scope': 'Original ordinary-app headless/Registry/X11 clients under CPU, GPU and Auto; software driver, absent-device failure path, no timing/RSS/hardware claim'}, indent=2) + '\n')
