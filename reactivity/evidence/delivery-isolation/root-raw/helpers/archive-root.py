"""Keep producer qualification, Root composition, and adoption distinct."""
from pathlib import Path
import gzip
import hashlib
import json
import shutil
import subprocess

main = Path('/root/gpui-ce3')
producer = Path('/tmp/gpui-delivery-isolation-sol/reactivity/evidence/delivery-isolation')
root = Path('/tmp/gpui-delivery-adoption-root-evidence')
destination = main / 'reactivity/evidence/delivery-isolation'
selected = '2b52030aed8344ed9c5f6dcf54b2ba19acf8ddf4'
git = ['git', '-c', 'safe.directory=' + str(main), '-C', str(main)]
assert subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip() == selected
assert not subprocess.check_output(git + ['status', '--porcelain'], text=True)
assert not destination.exists()

def sha(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()

payloads = json.loads((producer / 'file-index.json').read_text())
for row in payloads:
    path = Path(row['archive'])
    assert path.parts[0] == 'raw' and '..' not in path.parts
    packed = (producer / path).read_bytes()
    assert hashlib.sha256(packed).hexdigest() == row['archive_sha256']
    raw = gzip.decompress(packed) if path.suffix == '.gz' else packed
    assert len(raw) == row['original_bytes']
    assert hashlib.sha256(raw).hexdigest() == row['original_sha256']
externals = json.loads((producer / 'external-artifacts.json').read_text())
for row in externals:
    path = Path(row['path'])
    if 'symlink_to' in row:
        assert path.is_symlink() and str(path.readlink()) == row['symlink_to']
    assert path.stat().st_size == row['bytes'] and sha(path) == row['sha256']

gates = {}
for folder in sorted(root.iterdir()):
    if not folder.is_dir() or not (folder / 'result.json').exists():
        continue
    result = json.loads((folder / 'result.json').read_text())
    assert result['source'] == selected and result['exit'] == 0 and result['guards_match']
    assert json.loads((folder / 'before.json').read_text()) == json.loads((folder / 'after.json').read_text())
    gates[folder.name] = result
assert {'default-run', 'docs', 'native-gpu-run', 'strict-policy-default', 'strict-policy-native-gpu'} <= gates.keys()
policy_hash = '47a95f0957da515a979049654ec81ff0554f358300c47c0a02573f4041210121'
assert sha(main / 'clippy.toml') == policy_hash
assert sha(Path('/tmp/gpui-delivery-adoption-root/clippy.toml')) == policy_hash

shutil.copytree(producer, destination)
for file in producer.rglob('*'):
    if file.is_file():
        assert sha(file) == sha(destination / file.relative_to(producer))
(destination / 'README.md').rename(destination / 'producer-README.md')
shutil.copy2('/tmp/gpui-delivery-isolation-root-review.json', destination / 'producer-root-review.json')

# Freeze selected actual linked test instances now. These post-run copies do
# not manufacture before/after binary guards around Root's earlier execution.
frozen = Path('/tmp/gpui-delivery-adoption-root-frozen')
frozen.mkdir(exist_ok=False)
binary_records = []
for gate in ['default-build', 'native-gpu-build']:
    for line in (root / gate / 'stdout.log').read_text().splitlines():
        if not line.startswith('{'):
            continue
        item = json.loads(line)
        if (item.get('reason') != 'compiler-artifact' or not item.get('executable')
                or item['target']['kind'] != ['lib']
                or item['target']['name'] not in ['gpui', 'gpui_gpu']):
            continue
        original = Path(item['executable'])
        copy = frozen / (gate + '-' + original.name)
        before = sha(original)
        shutil.copy2(original, copy)
        copy.chmod(0o555)
        assert sha(original) == sha(copy) == before
        binary_records.append({'gate': gate, 'original': str(original), 'path': str(copy),
                               'bytes': copy.stat().st_size, 'sha256': before,
                               'scope': 'Post-qualification preserved ELF; not a before/after execution guard.'})
(destination / 'root-external-artifacts.json').write_text(json.dumps(binary_records, indent=2) + '\n')

index = []
files = [(p, p.relative_to(root)) for p in root.rglob('*') if p.is_file()]
files += [(Path('/tmp/gpui-run-frozen-gate-root.py'), Path('helpers/gpui-run-frozen-gate-root.py')),
          (Path(__file__), Path('helpers/archive-root.py'))]
for path, relative in sorted(files, key=lambda pair: str(pair[1])):
    raw = path.read_bytes()
    stored = gzip.compress(raw, mtime=0) if len(raw) > 24_000 else raw
    relative = Path('root-raw') / relative
    if len(raw) > 24_000:
        relative = relative.with_name(relative.name + '.gz')
    target = destination / relative
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(stored)
    index.append({'source': str(path), 'archive': str(relative), 'original_bytes': len(raw),
                  'original_sha256': hashlib.sha256(raw).hexdigest(),
                  'archive_sha256': hashlib.sha256(stored).hexdigest()})
(destination / 'root-file-index.json').write_text(json.dumps(index, indent=2) + '\n')
report = {
    'adopted_source': selected, 'previous_main': '37d0321fe24ff600fda1ef071361f106ae0ea32b',
    'producer_evidence': 'f812f2c121bf0217492ff475b78dc4d74bebdd7d',
    'producer_selected_source': '22541342e3c10a962bc61f76088c7bfdb1b21bbd',
    'producer_payloads_reopened': len(payloads), 'producer_externals_reopened': len(externals),
    'root_gates': gates, 'root_policy_sha256': policy_hash,
    'policy_scope': 'strict-policy-* explicitly selects the materialized repository clippy.toml. Earlier strict gates used default configuration and retain that narrower scope.',
    'root_functional_scope': 'Source guards and parsed test outcomes; no Root before/after run binary hashes. Producer native and matched-cost binary guards remain separately labelled.',
    'production_adopted': True, 'timing_claim': False, 'rss_claim': False,
    'source_line_bill': {'core_noncomment_nontest': 31232, 'previous_main': 30987, 'delta': 245},
    'adverse_costs': ['ordinary delivery own static frame +64B',
                      'typed fixture vs coarse: linked .text +11328B, delivery own static frame 520 to 1416B',
                      'transport still uses Mutex/Arc; no lock-free claim',
                      'total-undelivered capacity C deliberately tightens former accidental 2C behavior'],
}
(destination / 'root-adoption.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps({'adopted': selected, 'producer_payloads': len(payloads),
                  'root_payloads': len(index), 'frozen_selected_elfs': len(binary_records)}), flush=True)
