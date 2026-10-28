"""Preserve all count formulations, including rejected frames and failed builds."""
from pathlib import Path
import gzip
import hashlib
import json
import subprocess

main = Path('/root/gpui-ce3')
root = Path('/tmp/gpui-coverage-integration-evidence')
fault = Path('/tmp/gpui-count-preflight-fault-control-root')
dest = main / 'reactivity/evidence/raw-glyph-count'
selected = 'ff8fa35f19af553764f82a4af943c94b1235f5a4'
adopted = '2fefe2d26692e7839231318a71dc4055a694f456'
git = ['git', '-c', 'safe.directory=' + str(main), '-C', str(main)]


def sha(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


assert subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip() == adopted
assert not subprocess.check_output(git + ['status', '--porcelain'], text=True)
assert not dest.exists()
equivalence = json.loads((root / 'raw-main-source-equivalence.json').read_text())
for relative, expected in equivalence['changed_files'].items():
    assert sha(main / relative) == expected, relative
gates = {}
for label in ['raw-unit-tests', 'raw-fallback-unit-tests', 'raw-strict',
              'raw-check-apple', 'raw-check-msvc']:
    folder = root / label
    result = json.loads((folder / 'result.json').read_text())
    assert result['source'] == selected and result['exit'] == 0 and result['guards_match']
    assert (folder / 'before.json').read_bytes() == (folder / 'after.json').read_bytes()
    gates[label] = result
assert json.loads((root / 'raw-strict/before.json').read_text())['clippy.toml'] == '47a95f0957da515a979049654ec81ff0554f358300c47c0a02573f4041210121'
oracle = json.loads((root / 'raw-comparison.json').read_text())
assert oracle['stdout_byte_equal'] and oracle['cases'] == 1120
assert sha(root / 'raw-run/stdout.log') == oracle['actual_sha256']
control = json.loads((fault / 'result.json').read_text())
assert control['selected'] == selected and control['source_restored_clean']
assert control['positive_run']['passed'] == 1 and control['negative_run']['failed'] == 1
for key in ['good_binary', 'wrong_count_binary']:
    assert sha(Path(control[key]['path'])) == control[key]['sha256']
counter = json.loads((root / 'raw-core-lines.json').read_text())
assert counter['core_non_test_code_lines'] == 31318
analysis_path = root / 'machine-analysis-certificate-count-cluster-fixed-raw.json'
analysis = json.loads(analysis_path.read_text())
old, new = [analysis['variants'][label] for label in ['certificate', 'raw']]
assert new['sections']['.text']['bytes'] - old['sections']['.text']['bytes'] == -1392
assert new['allocated_sections'] - old['allocated_sections'] == -4

dest.mkdir(parents=True)
index, external = [], []


def preserve(path, relative):
    assert path.is_file() and not path.is_symlink(), path
    before = sha(path)
    with path.open('rb') as stream:
        elf = stream.read(4) == b'\x7fELF'
    if elf or path.name == 'disassembly.txt' or (path.name == 'stdout.log' and path.parent.name.endswith('-run') and path.stat().st_size > 1_000_000):
        external.append({'path': str(path), 'bytes': path.stat().st_size, 'sha256': before})
    else:
        raw = path.read_bytes()
        stored = gzip.compress(raw, mtime=0) if len(raw) > 24_000 else raw
        relative = Path('raw') / relative
        if len(raw) > 24_000:
            relative = relative.with_name(relative.name + '.gz')
        target = dest / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        assert not target.exists()
        target.write_bytes(stored)
        restored = gzip.decompress(stored) if relative.suffix == '.gz' else stored
        assert hashlib.sha256(restored).hexdigest() == before
        index.append({'source': str(path), 'archive': str(relative),
                      'original_bytes': len(raw), 'original_sha256': before,
                      'archive_sha256': hashlib.sha256(stored).hexdigest()})
    assert sha(path) == before


for path in sorted(root.rglob('*')):
    if not path.is_file():
        continue
    relative = path.relative_to(root)
    if relative.parts[0].startswith(('count-', 'cluster-', 'raw-', 'machine-analysis-certificate-count')):
        preserve(path, Path('qualification') / relative)
for path in sorted(fault.rglob('*')):
    if path.is_file():
        preserve(path, Path('fault-control') / path.relative_to(fault))
for name in ['/tmp/gpui-raw-count-selected.patch', '/tmp/gpui-count-preflight-fault-root.py', __file__]:
    path = Path(name)
    preserve(path, Path('helpers') / path.name)

report = {
    'selected_source': selected, 'adopted_commit': adopted,
    'production_adopted': True, 'gates': gates, 'oracle': oracle,
    'whole_text_delta_bytes': -1392, 'whole_rodata_delta_bytes': -8,
    'all_allocated_sections_delta_bytes': -4,
    'count_helper': {'code_bytes': [1118, 444], 'max_observed_rsp_cfa_bytes': [352, 48]},
    'shape': {'code_bytes': [13544, 13312], 'max_observed_rsp_cfa_bytes': [3056, 3040]},
    'core_noncomment_nontest_lines': [31321, 31318],
    'loop': 'Four-way unrolled scalar loads/additions; no SIMD claim.',
    'headers_or_allocations_added': False,
    'rejected_cached_count': 'One usize per positioned run; its iterator code +155B and own static frame +32B.',
    'failed_headerless_source': '1c6bee compiled neither unit nor public fixture: patch removed the debug assertion argument rather than initializer field. Corrected bfba before the selected raw-run formulation.',
    'fault_control': {'source': control['fault_source'], 'positive_passed': 1,
                      'negative_failed': 1, 'source_restored_clean': True},
    'guard_scope': 'Strict/default/oracle/fault have 2215 materialized inputs. After restoring the fault source, sparse checkout removed clippy.toml only: fallback and foreign source checks have 2214, otherwise identical source hashes. These latter gates are not lint claims. Main retains the tracked policy.',
    'oracle_payload': '../bundled-coverage/raw/integration/certificate-run/stdout.log.gz',
    'oracle_payload_scope': 'Selected original output is byte-identical by SHA to the previously archived full output; the new original output remains externally indexed.',
    'timing_claim': False, 'rss_claim': False, 'dynamic_stack_claim': False,
}
(dest / 'review.json').write_text(json.dumps(report, indent=2) + '\n')
(dest / 'file-index.json').write_text(json.dumps(index, indent=2) + '\n')
(dest / 'external-artifacts.json').write_text(json.dumps(external, indent=2) + '\n')
print(json.dumps({'payloads': len(index), 'externals': len(external)}), flush=True)
