from pathlib import Path
import hashlib, json, os, shutil, subprocess

root = Path('/root/gpui-ce3')
out = Path('/tmp/gpui-native-text-hummingbird-gates')
out.mkdir(exist_ok=True)
digest = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
artifacts = [json.loads(line) for line in Path('/tmp/gpui-native-text-hummingbird-build.jsonl').read_text().splitlines()]
artifact = next(row for row in artifacts if row.get('reason') == 'compiler-artifact'
                and row.get('executable') and row['target']['kind'] == ['bin'])
binary = out / 'hummingbird-frozen'
shutil.copyfile(artifact['executable'], binary)
binary.chmod(0o755)
binary_hash = digest(binary)
prefixes = [f'reactivity/crates/{name}' for name in ('canvas', 'core', 'gpu', 'gpui', 'host', 'state')]
files = subprocess.check_output(['git', '-c', f'safe.directory={root}', '-C', str(root), 'ls-files',
                                *prefixes, 'reactivity/Cargo.toml', 'reactivity/Cargo.lock',
                                'reactivity/.cargo', 'reactivity/vendor', 'reactivity/ports/hummingbird'], text=True).splitlines()
def guard():
    return {name: digest(root / name) for name in files}
before = guard()
(out / 'before-source.json').write_text(json.dumps(before, indent=2) + '\n')
results = []
def run(name, command, timeout):
    assert guard() == before and digest(binary) == binary_hash
    with (out / f'{name}.log').open('w') as log:
        result = subprocess.run(command, cwd=root / 'reactivity', stdout=log, stderr=subprocess.STDOUT, timeout=timeout)
    row = {'case': name, 'command': command, 'exit': result.returncode,
           'log_sha256': digest(out / f'{name}.log')}
    results.append(row)
    (out / 'results.json').write_text(json.dumps(results, indent=2) + '\n')
    print(json.dumps(row), flush=True)
    assert result.returncode == 0
    assert guard() == before and digest(binary) == binary_hash
run('headless', [str(binary), '--headless'], 60)
display = next(n for n in range(152, 180) if not Path(f'/tmp/.X11-unix/X{n}').exists()
               and not Path(f'/tmp/.X{n}-lock').exists())
python = '/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3'
driver = root / 'reactivity/ports/hummingbird/native-transcript.py'
run('native', ['dbus-run-session', '--', python, str(driver), str(binary),
    '--xvfb', '/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb',
    '--xdotool', '/nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool',
    '--atspi-launcher', '/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher',
    '--output', str(out / 'native-transcript.json'), '--display', f':{display}'], 75)
assert not Path(f'/tmp/.X11-unix/X{display}').exists()
(out / 'metadata.json').write_text(json.dumps({
    'source_head': subprocess.check_output(['git', '-c', f'safe.directory={root}', '-C', str(root), 'rev-parse', 'HEAD'], text=True).strip(),
    'artifact': artifact, 'binary_sha256': binary_hash, 'driver_sha256': digest(driver),
    'guard_driver_sha256': digest(Path(__file__)), 'source_unchanged': True,
    'owned_display_stopped': True, 'display': f':{display}',
    'limits': 'Actual private X11/AT-SPI protocol and SQLite/Nucleo public-owner transcript, not timing, hardware performance, complete Hummingbird or native foreign-OS coverage.'
}, indent=2) + '\n')
