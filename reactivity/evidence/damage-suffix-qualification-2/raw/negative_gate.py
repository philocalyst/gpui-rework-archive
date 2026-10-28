from pathlib import Path
import os, json, subprocess, hashlib, sys, shutil, time, signal

r = Path(__file__).parent
kind = 'omit'
w = Path(f'/home/user/gpui-damage-suffix-{kind}-lab')
target = Path(f'/home/user/gpui-damage-suffix-{kind}-target')
out = r / sys.argv[1]
out.mkdir(exist_ok=False)
def sha(p):
    return hashlib.file_digest(p.open('rb'), 'sha256').hexdigest()
def inputs():
    return {p: sha(w / p) for p in subprocess.check_output(
        ['git', 'ls-files', '-z', 'reactivity', '.cargo', 'clippy.toml'], cwd=w
    ).decode().split('\0') if p and (w / p).is_file()}
assert not subprocess.check_output(['git', 'status', '--porcelain'], cwd=w).strip()
free = shutil.disk_usage('/home/user').free
(out / 'reserve.json').write_text(json.dumps({'free_bytes': free, 'required_bytes': 8 * 1024**3}))
assert free >= 8 * 1024**3
before = inputs()
(out / 'inputs.json').write_text(json.dumps(before))
(out / 'source.txt').write_bytes(subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=w))
base = ['cargo', '+nightly-2026-10-23', '-Z', 'checksum-freshness', '--config', 'build.fingerprint="content"', 'test', '--locked', '--offline', '--release', '--message-format=json']
env = {**os.environ, 'CARGO_TARGET_DIR': str(target), 'CARGO_BUILD_JOBS': '4',
       'VK_ICD_FILENAMES': '/usr/share/vulkan/icd.d/lvp_icd.json', 'LP_NUM_THREADS': '4',
       'XDG_RUNTIME_DIR': '/home/user/gpui-xdg', 'DISPLAY': ':94',
       'DBUS_SESSION_BUS_ADDRESS': 'unix:path=/nonexistent', 'RUST_BACKTRACE': '1'}
(out / 'environment.json').write_text(json.dumps({k: v for k, v in env.items()
    if k.startswith(('CARGO_', 'RUST', 'VK_', 'LP_')) or k in ['DISPLAY', 'XDG_RUNTIME_DIR', 'DBUS_SESSION_BUS_ADDRESS']}, indent=2))
def run(name, cmd):
    minimum = shutil.disk_usage('/home/user').free
    assert minimum > 8 * 1024**3
    started = time.monotonic()
    stopped = False
    with (out / (name + '.out')).open('w') as a, (out / (name + '.log')).open('w') as b:
        p = subprocess.Popen(cmd, cwd=w / 'reactivity', env=env, stdout=a, stderr=b, start_new_session=True)
        while p.poll() is None:
            minimum = min(minimum, shutil.disk_usage('/home/user').free)
            if minimum < 8 * 1024**3 or (name == 'native' and time.monotonic() - started > 180):
                os.killpg(p.pid, signal.SIGTERM)
                stopped = True
            time.sleep(2)
        code = p.wait()
    (out / (name + '.status.json')).write_text(json.dumps({'command': cmd, 'exit': code,
        'minimum_free_bytes': minimum, 'stopped': stopped, 'seconds': time.monotonic() - started}, indent=2))
    artifacts = []
    for line in (out / (name + '.out')).read_text().splitlines():
        try:
            o = json.loads(line)
        except ValueError:
            continue
        if o.get('reason') == 'compiler-artifact' and o.get('executable'):
            q = Path(o['executable'])
            h = sha(q)
            dest = Path('/home/user/gpui-preserved-test-binaries') / h
            if not dest.exists():
                shutil.copy2(q, dest)
            assert sha(dest) == h
            artifacts.append({'path': str(q), 'sha256': h, 'preserved': str(dest),
                'bytes': q.stat().st_size, 'cargo': o})
    (out / (name + '-artifacts.json')).write_text(json.dumps(artifacts, indent=2))
    print(kind, name, code, 'artifacts', len(artifacts), flush=True)
    assert not stopped
    return code, artifacts
try:
    name = 'unequal_streams_keep_every_changed_pixel_and_exclude_equal_distant_suffix'
    code, artifacts = run('test', base + ['-p', 'gpui_canvas', '--test', 'damage_suffix', name, '--', '--exact', '--nocapture', '--test-threads=1'])
    assert code == 101 and artifacts
    fault = (out / 'test.log').read_text()
    assert 'lost reverse mismatch at' in fault
    assert '0 passed; 1 failed' in (out / 'test.out').read_text()
    (out / 'witness.json').write_text(json.dumps(dict(scope='A changed pixel lies outside reported damage when the first unequal reverse pair is omitted.',panic=next(line for line in fault.splitlines() if 'lost reverse mismatch at' in line)),indent=2))

finally:
    after = inputs()
    changes = sorted(p for p in before.keys() | after.keys() if before.get(p) != after.get(p))
    (out / 'guard-after.json').write_text(json.dumps(changes))
    assert not changes
