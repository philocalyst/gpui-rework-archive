from pathlib import Path
import hashlib
import json
import os
import re
import signal
import subprocess

root = Path('/tmp/gpui-source-value-nightly-root')
out = Path('/tmp/gpui-source-value-nightly-native-x11-postbuild-evidence')
out.mkdir(exist_ok=False)
git = ['git', '-c', f'safe.directory={root}', '-C', str(root)]
pin = 'd6883d6d6ad2cee0ba3d3458ac9ef7fac5dea78e'
assert subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip() == pin
assert not subprocess.check_output(git + ['status', '--porcelain'], text=True).strip()
assert not os.environ.get('RUSTC_BOOTSTRAP')
paths = subprocess.check_output(git + ['ls-files', '.cargo/config.toml', 'reactivity/Cargo.toml',
    'reactivity/Cargo.lock', 'reactivity/crates', 'reactivity/vendor'], text=True).splitlines()
guard = lambda: {name: hashlib.sha256((root / name).read_bytes()).hexdigest() for name in paths}
before = guard()
(out / 'before.json').write_text(json.dumps(before, indent=2) + '\n')
command = ['cargo', 'test', '--manifest-path', 'reactivity/Cargo.toml', '--locked', '--offline',
    '-p', 'gpui', '--all-targets', '--features', 'x11', '--message-format=json']
(out / 'command.json').write_text(json.dumps({'argv': command, 'cwd': str(root), 'source': pin,
    'target': os.environ.get('CARGO_TARGET_DIR'), 'jobs': os.environ.get('CARGO_BUILD_JOBS'),
    'RUSTC': os.environ.get('RUSTC'), 'RUSTC_BOOTSTRAP': os.environ.get('RUSTC_BOOTSTRAP'),
    'timeout_seconds': 600, 'scope': 'Genuine-nightly native X11 tests after the recorded8m32s build; previous combined600s gate timed out with610 completed passing tests and incomplete heavy Todo; same600s deadline, unchanged source/toolchain/features; both previous failures preserved; no display execution, strict lint, cost or timing claim'}, indent=2) + '\n')
(out / 'rustc.txt').write_text(subprocess.check_output(['rustc', '-Vv'], text=True))
with (out / 'native.jsonl').open('w') as stdout, (out / 'native.log').open('w') as stderr:
    process = subprocess.Popen(command, cwd=root, stdout=stdout, stderr=stderr, start_new_session=True)
    try:
        status = process.wait(timeout=600)
    except subprocess.TimeoutExpired:
        os.killpg(process.pid, signal.SIGTERM)
        try:
            process.wait(timeout=5)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGKILL)
            process.wait()
        status = 124
(out / 'native.exit').write_text(str(status) + '\n')
after = guard()
(out / 'after.json').write_text(json.dumps(after, indent=2) + '\n')
assert before == after, 'Compiler inputs changed'
assert subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip() == pin
assert not subprocess.check_output(git + ['status', '--porcelain'], text=True).strip()
rows = re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored;', (out / 'native.jsonl').read_text())
summary = {'source': pin, 'exit': status, 'source_guards': len(before), 'guards_match': True,
    'passed': sum(int(a) for a,b,c in rows), 'failed': sum(int(b) for a,b,c in rows),
    'ignored': sum(int(c) for a,b,c in rows), 'harnesses': len(rows), 'bootstrap': False}
(out / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
print(json.dumps(summary), flush=True)
assert status == 0 and rows and summary['failed'] == 0
