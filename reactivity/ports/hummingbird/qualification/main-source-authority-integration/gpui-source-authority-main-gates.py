from pathlib import Path
import json
import os
import subprocess
import sys

root = Path('/root/gpui-ce3')
out = root / 'reactivity/ports/hummingbird/qualification/main-source-authority-integration'
manifest = 'reactivity/ports/hummingbird/Cargo.toml'
base = ['--manifest-path', manifest, '--locked', '--offline']
gates = [
    ('default', ['cargo', 'test', *base, '--all-targets']),
    ('native', ['cargo', 'test', *base, '--all-targets', '--features', 'native']),
    ('clippy-default', ['cargo', 'clippy', *base, '--all-targets', '--', '-D', 'warnings']),
    ('clippy-native', ['cargo', 'clippy', *base, '--all-targets', '--features', 'native', '--', '-D', 'warnings']),
    ('format', ['cargo', 'fmt', '--manifest-path', manifest, '--check']),
    ('native-build', ['cargo', 'build', *base, '--features', 'native', '--example', 'native_service']),
]
(out / 'commands.json').write_text(json.dumps({'cwd': str(root), 'commands': dict(gates),
    'jobs': os.environ.get('CARGO_BUILD_JOBS'), 'target': os.environ.get('CARGO_TARGET_DIR'),
    'bootstrap': os.environ.get('RUSTC_BOOTSTRAP'), 'scope': 'Exact integrated 9f83 port; unchanged core; no timing or hardware qualification'}, indent=2) + '\n')
for name, command in gates:
    with (out / f'{name}.log').open('w') as log:
        try:
            result = subprocess.run(command, cwd=root, stdout=log, stderr=subprocess.STDOUT, timeout=600)
            status = result.returncode
        except subprocess.TimeoutExpired:
            status = 124
    (out / f'{name}.exit').write_text(str(status) + '\n')
    print(json.dumps({'gate': name, 'status': status}), flush=True)
    if status != 0:
        sys.exit(status)
