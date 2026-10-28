from pathlib import Path
import hashlib
import json
import subprocess

old = Path('/tmp/gpui-structural-main-gates')
digest = lambda data: hashlib.sha256(data).hexdigest()
root = Path('/root/gpui-ce3')
guard = json.loads((old / 'source-guard.json').read_text())
assert all(digest((root / name).read_bytes()) == expected for name, expected in guard.items())
failure = {
    'outcome': 'Compile/link timeout before test execution; no test failure or success inferred.',
    'timeout_seconds': 1200,
    'source_unchanged_after_timeout': True,
    'guarded_files': len(guard),
    'driver_sha256': digest(Path('/tmp/gpui-structural-main-gates-driver.log').read_bytes()),
    'cargo_log_sha256': digest((old / 'gpui-full.log').read_bytes()),
}
(old / 'failure.json').write_text(json.dumps(failure, indent=2) + '\n')
source = Path('/tmp/gpui-structural-main-gates.py').read_text()
source = source.replace('/tmp/gpui-structural-main-gates', '/tmp/gpui-structural-main-gates-v2')
assert 'source_unchanged=True' in source
Path('/tmp/gpui-structural-main-gates-v2.py').write_text(source)
print(json.dumps(failure))
