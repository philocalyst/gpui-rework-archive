from pathlib import Path
import hashlib
import json
import os
import signal
import subprocess

root = Path('/tmp/gpui-source-value-nightly-root')
out = Path('/tmp/gpui-source-value-nightly-strict-evidence')
out.mkdir(exist_ok=False)
before = json.loads(Path('/tmp/gpui-source-value-nightly-native-x11-postbuild-evidence/before.json').read_text())
guard = lambda: {name: hashlib.sha256((root / name).read_bytes()).hexdigest() for name in before}
assert guard() == before and not os.environ.get('RUSTC_BOOTSTRAP')
(out / 'before.json').write_text(json.dumps(before, indent=2) + '\n')
commands = {}
for name, features in [('default', []), ('native', ['--features', 'x11'])]:
    command = ['cargo', 'clippy', '--manifest-path', 'reactivity/Cargo.toml', '--offline', '--locked',
        '-p', 'gpui', '--all-targets', *features, '--message-format=json', '--', '-D', 'warnings']
    commands[name] = {'argv': command, 'timeout_seconds': 300, 'cwd': str(root), 'source': 'd6883d6d6ad2cee0ba3d3458ac9ef7fac5dea78e',
        'bootstrap': False, 'target': os.environ.get('CARGO_TARGET_DIR')}
    (out / 'commands.json').write_text(json.dumps(commands, indent=2) + '\n')
    with (out / f'{name}.jsonl').open('w') as stdout, (out / f'{name}.log').open('w') as stderr:
        process = subprocess.Popen(command, cwd=root, stdout=stdout, stderr=stderr, start_new_session=True)
        try:
            status = process.wait(timeout=300)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGTERM)
            try:
                process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGKILL)
                process.wait()
            status = 124
    (out / f'{name}.exit').write_text(str(status) + '\n')
    print(json.dumps({'gate': name, 'exit': status}), flush=True)
    assert before == guard(), 'Inputs changed during strict ' + name
(out / 'after.json').write_text(json.dumps(guard(), indent=2) + '\n')
