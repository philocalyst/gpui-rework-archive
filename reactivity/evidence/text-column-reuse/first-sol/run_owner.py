from pathlib import Path
import hashlib, json, os, subprocess, sys
label, root_name, binary_name = sys.argv[1:]
root = Path(root_name)
binary = Path(binary_name)
out = Path(__file__).parent

def git(*args):
    return subprocess.check_output(['git', '-c', f'safe.directory={root}', '-C', str(root), *args], text=True)
def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()
def sources():
    names = git('ls-files', '-z', '--', '.cargo', 'reactivity/Cargo.toml', 'reactivity/Cargo.lock', 'reactivity/crates', 'reactivity/vendor').split('\0')
    return {name: digest(root/name) for name in names if name and (root/name).is_file()}
assert not git('status', '--porcelain', '--', '.cargo', 'reactivity/Cargo.toml', 'reactivity/Cargo.lock', 'reactivity/crates', 'reactivity/vendor')
env = dict(os.environ)
env.pop('RUSTFLAGS', None)
env.pop('CARGO_ENCODED_RUSTFLAGS', None)
env['CARGO_BUILD_JOBS'] = '1'
meta = {'source': git('rev-parse', 'HEAD').strip(), 'binary': {'path': str(binary), 'sha256': digest(binary), 'bytes': binary.stat().st_size}, 'fixture_sha256': digest(root/'reactivity/crates/gpui/src/runtime/text_geometry/owner_tests.rs'), 'files_before': sources(), 'generic_rustflags': 'unset', 'jobs': 1, 'profile': 'gpui lib test, no default features', 'commands': []}
metadata = out/f'{label}-metadata.json'
metadata.write_text(json.dumps(meta, indent=2)+'\n')

def run(name, args, extra=None):
    row = {'name': name, 'argv': args, 'env': extra or {}}
    meta['commands'].append(row)
    with (out/f'{label}-{name}.log').open('w') as log:
        row['exit'] = subprocess.call(args, cwd=root, env={**env, **(extra or {})}, stdout=log, stderr=subprocess.STDOUT)
    metadata.write_text(json.dumps(meta, indent=2)+'\n')
    print(label, name, row['exit'], flush=True)
    assert row['exit'] == 0

if label == 'candidate':
    run('text-tests', [str(binary), 'runtime::text_geometry::column_tests', '--nocapture', '--test-threads=1'])
for count in [1, 32, 32768]:
    run(str(count), [str(binary), '--exact', 'runtime::text_geometry::owner_tests::whole_window_text_column_owner_ledger', '--ignored', '--nocapture', '--test-threads=1'], {'GPUI_TEXT_COLUMN_COUNT': str(count)})
run('headers', [str(binary), '--exact', 'runtime::text_geometry::tests::acknowledged_geometry_owner_epoch_and_allocation_ledger', '--nocapture', '--test-threads=1'])
after = sources()
assert after == meta['files_before']
assert digest(binary) == meta['binary']['sha256']
meta['sources_unchanged'] = True
meta['binary_unchanged'] = True
metadata.write_text(json.dumps(meta, indent=2)+'\n')
