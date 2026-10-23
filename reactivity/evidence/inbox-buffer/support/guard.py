import hashlib, json, pathlib, subprocess, sys
root = pathlib.Path(sys.argv[1])
paths = subprocess.check_output(['git', '-C', str(root), 'ls-files', '-z', '.cargo', 'reactivity/Cargo.toml', 'reactivity/Cargo.lock', 'reactivity/crates', 'reactivity/vendor']).decode().split('\0')
files = {}
for name in filter(None, paths):
    path = root / name
    if path.is_file() and (path.suffix in ('.rs', '.wgsl', '.toml') or path.name == 'Cargo.lock'):
        files[name] = hashlib.sha256(path.read_bytes()).hexdigest()
result = {
    'head': subprocess.check_output(['git', '-C', str(root), 'rev-parse', 'HEAD']).decode().strip(),
    'status': subprocess.check_output(['git', '-C', str(root), 'status', '--short']).decode(),
    'files': files,
}
print(json.dumps(result, sort_keys=True, indent=2))
