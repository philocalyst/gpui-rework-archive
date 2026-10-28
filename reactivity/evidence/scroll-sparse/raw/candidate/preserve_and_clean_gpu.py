from pathlib import Path
import hashlib, json, shutil, subprocess, sys, os

root = Path(__file__).parent
wt = Path('/home/user/gpui-scroll-sparse-lab')
target = Path('/home/user/gpui-scroll-sparse-target')
out = root / sys.argv[1]
out.mkdir(exist_ok=False)
assert not subprocess.check_output(['git', 'status', '--porcelain'], cwd=wt).strip()
assert (target / 'CACHEDIR.TAG').is_file()
commands = subprocess.check_output(['ps', '-eo', 'comm='], text=True).splitlines()
assert not any(c.strip() in ['cargo', 'rustc', 'clippy-driver', 'rust-lld', 'ld.lld'] for c in commands)
rows = []
for p in sorted((target / 'release/build/gpui_gpu').rglob('*')):
    if not p.is_file():
        continue
    q = out / p.relative_to(target)
    q.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(p, q)
    h = hashlib.file_digest(p.open('rb'), 'sha256').hexdigest()
    assert hashlib.file_digest(q.open('rb'), 'sha256').hexdigest() == h
    with p.open('rb') as f:
        elf = f.read(4) == b'\x7fELF'
    rows.append({'path': str(p), 'preserved': str(q), 'sha256': h,
                 'bytes': p.stat().st_size, 'elf': elf})
assert any(Path(r['path']).name == 'ui.wgsl' for r in rows)
assert any(r['elf'] and 'build_script' in Path(r['path']).name for r in rows)
(out / 'manifest.json').write_text(json.dumps(rows, indent=2))
(out / 'source.txt').write_bytes(subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=wt))
cmd = ['cargo', '+nightly-2026-10-23', 'clean', '--release', '-p', 'gpui_gpu']
with (out / 'clean.out').open('w') as a, (out / 'clean.log').open('w') as b:
    p = subprocess.run(cmd, cwd=wt / 'reactivity', env={**os.environ, 'CARGO_TARGET_DIR': str(target)}, stdout=a, stderr=b)
(out / 'status.json').write_text(json.dumps({'command': cmd, 'exit': p.returncode}, indent=2))
assert p.returncode == 0
print('preserved', len(rows), 'GPU package files before cleaning', flush=True)
