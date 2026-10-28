from pathlib import Path
import hashlib, json, os, shutil, signal, subprocess, traceback

root = Path('/root/gpui-ce3')
cwd = root / 'reactivity'
out = Path('/tmp/gpui-main-pointer-queue-gates')
out.mkdir(exist_ok=False)
git = ['git', '-c', f'safe.directory={root}', '-C', str(root)]
digest = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
source = subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip()
files = subprocess.check_output(git + ['ls-files', '.cargo/config.toml', 'reactivity/Cargo.toml', 'reactivity/Cargo.lock', 'reactivity/.cargo', 'reactivity/vendor', 'reactivity/crates', 'reactivity/ports/hummingbird'], text=True).splitlines()
def guard():
    return {name: digest(root / name) for name in files}
before = guard()
(out / 'source-guard.json').write_text(json.dumps(before, indent=2) + '\n')
results = []
executables = {}
metadata = {'source': source, 'guarded_files': len(before), 'root_cargo_config_sha256': digest(root / '.cargo/config.toml'), 'rustc': subprocess.check_output(['rustc', '-vV'], text=True), 'cargo': subprocess.check_output(['cargo', '-V'], text=True), 'limits': 'Behavior, static layout and Vulkan software rendering; no timing, RSS, native HDR, hardware performance or foreign-OS runtime claim.'}
def check():
    assert guard() == before, 'source changed during campaign'
    assert all(digest(Path(path)) == value for path, value in executables.items())
def run(name, command, timeout=900, workdir=cwd):
    check()
    with (out / f'{name}.log').open('w') as log:
        process = subprocess.Popen(command, cwd=workdir, stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
        try:
            code = process.wait(timeout=timeout)
        except BaseException:
            os.killpg(process.pid, signal.SIGTERM)
            try:
                process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGKILL)
                process.wait()
            raise
    row = {'case': name, 'command': command, 'exit': code, 'log_sha256': digest(out / f'{name}.log')}
    results.append(row)
    (out / 'results.json').write_text(json.dumps(results, indent=2) + '\n')
    print(json.dumps(row), flush=True)
    assert code == 0, row
    check()

try:
    feature = 'desktop,x11,wayland,gpui_canvas/parallel,cephal/verify-cache,gpui_gpu/offline-shader,gpui_gpu/vulkan-tests'
    metadata['gpui_features'] = feature
    (out / 'metadata.json').write_text(json.dumps(metadata, indent=2) + '\n')
    run('gpui-gpu-full', ['cargo', 'test', '--offline', '--locked', '-p', 'gpui', '-p', 'gpui_gpu', '--features', feature, '--message-format=json'], timeout=1200)
    run('gpui-gpu-strict', ['cargo', 'clippy', '--offline', '--locked', '-p', 'gpui', '-p', 'gpui_gpu', '--features', feature, '--all-targets', '--', '-D', 'warnings'])
    app = ['--manifest-path', 'ports/hummingbird/Cargo.toml']
    run('hummingbird-default', ['cargo', 'test', '--offline', '--locked', *app, '--all-targets', '--', '--nocapture'])
    run('hummingbird-native', ['cargo', 'test', '--offline', '--locked', *app, '--all-targets', '--features', 'native', '--', '--nocapture'])
    run('hummingbird-strict-default', ['cargo', 'clippy', '--offline', '--locked', *app, '--all-targets', '--', '-D', 'warnings'])
    run('hummingbird-strict-native', ['cargo', 'clippy', '--offline', '--locked', *app, '--all-targets', '--features', 'native', '--', '-D', 'warnings'])
    run('format-core', ['cargo', 'fmt', '--package', 'gpui', '--package', 'gpui_canvas', '--package', 'gpui_gpu', '--package', 'gpui_reactivity_core', '--', '--check'])
    run('format-app', ['cargo', 'fmt', *app, '--', '--check'])
    run('hummingbird-native-build', ['cargo', 'build', '--offline', '--locked', *app, '--features', 'native', '--message-format=json'])
    artifacts = []
    for line in (out / 'hummingbird-native-build.log').read_text().splitlines():
        try:
            row = json.loads(line)
        except ValueError:
            continue
        if row.get('reason') == 'compiler-artifact' and row.get('executable') and row['target']['kind'] == ['bin']:
            artifacts.append(row)
    assert len(artifacts) == 1, artifacts
    artifact = artifacts[0]
    binary = out / 'hummingbird-native-frozen'
    shutil.copyfile(artifact['executable'], binary)
    binary.chmod(0o555)
    executables[str(binary)] = digest(binary)
    (out / 'native-artifact.json').write_text(json.dumps(artifact, indent=2) + '\n')
    common = [str(binary), '--xvfb', '/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb', '--xdotool', '/nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool', '--atspi-launcher', '/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher', '--renderer', 'cpu']
    for label, script, display in [('original', '/tmp/gpui-rapid-pointer-native-client.py', ':197'), ('rapid-loop', '/tmp/gpui-rapid-pointer-native-loop-client.py', ':198')]:
        run(f'native-{label}', ['dbus-run-session', '--', 'python3', script, *common, '--display', display, '--output', str(out / f'native-{label}.json')], timeout=300)
    metadata.update(source_unchanged=True, executables=executables, status='passed')
except BaseException:
    metadata.update(status='failed', failure=traceback.format_exc(), source_unchanged=guard() == before)
    (out / 'metadata.json').write_text(json.dumps(metadata, indent=2) + '\n')
    raise
(out / 'metadata.json').write_text(json.dumps(metadata, indent=2) + '\n')
