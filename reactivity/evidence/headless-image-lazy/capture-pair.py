from pathlib import Path
import hashlib, json, re, shutil, subprocess

root = Path('/root/gpui-ce3')
out = Path('/tmp/gpui-headless-image-pair')
out.mkdir(exist_ok=True)
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
old_meta = json.loads((root / 'reactivity/evidence/native-text-integration/native/metadata.json').read_text())
old = Path(old_meta['artifact']['executable'])
assert sha(old) == old_meta['binary_sha256']
test_log = Path('/tmp/gpui-headless-lazy-integrated.log')
match = re.search(r'Running unittests src/lib.rs \((target/debug/deps/gpui-[0-9a-f]+)\)', test_log.read_text())
assert match
new = out / 'candidate-frozen'
shutil.copyfile(root / 'reactivity' / match[1], new)
new.chmod(0o755)
files = subprocess.check_output(['git', '-c', f'safe.directory={root}', '-C', str(root), 'ls-files',
    *[f'reactivity/crates/{name}' for name in ('canvas','core','gpu','gpui','host','state')],
    'reactivity/Cargo.toml', 'reactivity/Cargo.lock', 'reactivity/.cargo', 'reactivity/vendor'], text=True).splitlines()
guard = lambda: {name: sha(root / name) for name in files}
before = guard()
(out / 'candidate-source.json').write_text(json.dumps(before, indent=2) + '\n')
rows = []
hashes = {str(path): sha(path) for path in (old,new)}
for name, binary in [('baseline',old),('candidate',new)]:
    assert guard() == before and sha(binary) == hashes[str(binary)]
    command = [str(binary), 'runtime::inspector::tests::plain_window_has_no_tool_allocation_and_inspector_uses_only_cold_storage',
               '--exact', '--nocapture', '--test-threads=1']
    result = subprocess.run(command, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=60)
    (out / f'{name}.log').write_text(result.stdout)
    assert result.returncode == 0 and '1 passed; 0 failed' in result.stdout
    values = re.search(r'plain_bytes=(\d+),plain_allocs=(\d+),tool_bytes=(\d+),tool_allocs=(\d+),delta_bytes=(\d+)', result.stdout)
    assert values
    rows.append({'variant':name,'command':command,'binary_sha256':hashes[str(binary)],
                 'source':old_meta['source_head'] if name == 'baseline' else subprocess.check_output(
                     ['git','-c',f'safe.directory={root}','-C',str(root),'rev-parse','HEAD'],text=True).strip(),
                 **dict(zip(['plain_retained_bytes','plain_retained_allocations','inspector_retained_bytes',
                             'inspector_retained_allocations','inspector_extra_bytes'], map(int, values.groups()))),
                 'log_sha256':sha(out / f'{name}.log')})
    assert guard() == before and sha(binary) == hashes[str(binary)]
assert rows[0]['plain_retained_bytes'] - rows[1]['plain_retained_bytes'] == 800*560*4
assert rows[0]['inspector_retained_bytes'] - rows[1]['inspector_retained_bytes'] == 800*560*4
assert rows[0]['plain_retained_allocations'] - rows[1]['plain_retained_allocations'] == 1
assert rows[0]['inspector_retained_allocations'] - rows[1]['inspector_retained_allocations'] == 1
(out / 'results.json').write_text(json.dumps({
    'features':'desktop,x11,wayland,gpui_canvas/parallel,cephal/verify-cache',
    'method':'Fresh-process identical existing unit fixture on frozen actual Cargo binaries; current-thread retained Rust allocations only. No timings, RSS or native blank-window claim.',
    'baseline_provenance':'reactivity/evidence/native-text-integration/native/metadata.json and guarded source manifest',
    'candidate_test_log_sha256':sha(test_log),'source_and_executables_unchanged':True,
    'rows':rows},indent=2)+'\n')
print(json.dumps(rows,indent=2))
