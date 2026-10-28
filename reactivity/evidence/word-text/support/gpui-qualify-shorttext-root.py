from pathlib import Path
import hashlib
import json
import os
import signal
import subprocess

root = Path('/tmp/gpui-short-text-root')
out = Path('/tmp/gpui-short-text-qualification-3d6')
out.mkdir(exist_ok=False)
git = ['git', '-c', f'safe.directory={root}', '-C', str(root)]
pin = subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip()
assert pin == '3d6bbcde4b67b9e99fe35b23db3bf216a79835f8'
assert not subprocess.check_output(git + ['status', '--porcelain'], text=True).strip()
files = [root / file for file in subprocess.check_output(git + ['ls-files'], text=True).splitlines()]
for package in ['arcstr-1.2.0', 'allocation-counter-0.8.1']:
    directory = Path('/root/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f') / package
    files.extend(file for file in directory.rglob('*') if file.is_file())
files.extend(Path('/tmp/gpui-nightly-2026-10-23/bin') / name for name in ['rustc', 'cargo', 'clippy-driver', 'rustdoc'])
files.extend(Path('/tmp/gpui-shorttext-miri-tools/bin') / name for name in ['miri', 'cargo-miri'])
guard = lambda: {str(file): hashlib.sha256(file.read_bytes()).hexdigest() for file in files}
before = guard()
(out / 'before.json').write_text(json.dumps(before, indent=2)+'\n')
assert not os.environ.get('RUSTC_BOOTSTRAP')
commands = [
    ('strict', ['cargo', 'clippy', '--manifest-path', str(root/'Cargo.toml'), '--offline', '--locked', '--all-targets', '--', '-D', 'warnings'], 600, {}),
    ('tests', ['cargo', 'test', '--manifest-path', str(root/'Cargo.toml'), '--offline', '--locked', '--all-targets'], 600, {}),
    ('miri-setup-x86_64', ['cargo', 'miri', 'setup', '--target', 'x86_64-unknown-linux-gnu'], 900,
     {'MIRI_SYSROOT': '/tmp/gpui-short-text-miri-sysroot-x86_64'}),
]
results=[]
for name, argv, timeout, overlay in commands:
    env=os.environ.copy()
    env.update(overlay)
    (out/(name+'-command.json')).write_text(json.dumps({'source':pin, 'argv':argv, 'timeout_seconds':timeout, 'environment':{key:env.get(key) for key in ['RUSTC','RUSTDOC','CARGO_TARGET_DIR','CARGO_BUILD_JOBS','MIRI','MIRI_SYSROOT','RUST_SRC_PATH','RUSTC_BOOTSTRAP']}},indent=2)+'\n')
    with (out/(name+'.log')).open('w') as log:
        child=subprocess.Popen(argv,cwd=root,env=env,stdout=log,stderr=log,start_new_session=True)
        try:
            status=child.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            os.killpg(child.pid,signal.SIGTERM)
            try:
                child.wait(timeout=5)
            except subprocess.TimeoutExpired:
                os.killpg(child.pid,signal.SIGKILL)
                child.wait()
            status=124
    (out/(name+'.exit')).write_text(str(status)+'\n')
    assert guard()==before
    results.append({'gate':name,'exit':status})
    print(json.dumps(results[-1]),flush=True)
(out/'after.json').write_text(json.dumps(guard(),indent=2)+'\n')
(out/'results.json').write_text(json.dumps(results,indent=2)+'\n')
