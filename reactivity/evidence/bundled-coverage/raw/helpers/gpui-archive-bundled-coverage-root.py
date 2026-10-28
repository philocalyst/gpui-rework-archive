"""Seal the selected text validation formulation and its rejected predecessors."""
from pathlib import Path
import gzip
import hashlib
import json
import subprocess

main = Path('/root/gpui-ce3')
root = Path('/tmp/gpui-coverage-integration-evidence')
dest = main / 'reactivity/evidence/bundled-coverage'
selected = '023e584a0504c05e7db33c887de980671f096257'
adopted = 'f0859ea215e637befd76a56471d99658ac495b45'
git = ['git', '-c', 'safe.directory=' + str(main), '-C', str(main)]


def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


assert subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip() == adopted
assert not subprocess.check_output(git + ['status', '--porcelain'], text=True)
assert not dest.exists()
equivalence = json.loads((root / 'main-source-equivalence.json').read_text())
assert equivalence['selected_source'] == selected
for relative, expected in equivalence['matched_changed_files'].items():
    assert digest(main / relative) == expected, relative

gates = {}
for label in ['certificate-default-tests', 'certificate-fallback-tests',
              'certificate-strict-default', 'certificate-strict-fallback',
              'certificate-check-apple', 'certificate-check-msvc']:
    directory = root / label
    result = json.loads((directory / 'result.json').read_text())
    assert result['source'] == selected and result['exit'] == 0 and result['guards_match']
    assert (directory / 'before.json').read_bytes() == (directory / 'after.json').read_bytes()
    gates[label] = result
oracle_hash = '5f17488c73478c4d7271d39f783a8e15cb72c60a8e32ee18a72bf444923f7c39'
variants = ['baseline', 'candidate', 'successor', 'iterator', 'certificate']
for label in variants:
    comparison = json.loads((root / (label + '-comparison.json')).read_text())
    assert comparison['stdout_byte_equal'] and comparison['actual_sha256'] == oracle_hash
    assert digest(root / (label + '-run/stdout.log')) == oracle_hash
    identity = json.loads((root / (label + '-binary.json')).read_text())
    assert digest(Path(identity['frozen_path'])) == identity['sha256']
    for stage in ['build', 'run']:
        guards = root / (label + '-' + stage + '-dependencies')
        assert json.loads((guards / 'result.json').read_text())['guards_match']
        assert (guards / 'before.json').read_bytes() == (guards / 'after.json').read_bytes()

fault_root = Path('/tmp/gpui-bundled-coverage-evidence/fault-control')
fault = json.loads((fault_root / 'result.json').read_text())
assert fault['production_source'] == selected
assert fault['variants']['baseline']['run']['passed'] == 2
assert fault['variants']['wrong-primary-bit']['run']['exit'] == 101
assert fault['variants']['wrong-primary-bit']['run']['failed'] == 1
for item in fault['variants'].values():
    assert digest(Path(item['binary'])) == item['sha256']
simd_fault = json.loads(Path('/tmp/gpui-coverage-events-evidence/broken-continuation/result.json').read_text())
assert simd_fault['exit'] == 101 and simd_fault['failed'] == 1

dest.mkdir(parents=True)
index = []
externals = []
seen = set()


def preserve(path, relative, external=False):
    assert path.is_file() and not path.is_symlink(), path
    before = digest(path)
    size = path.stat().st_size
    if external:
        externals.append({'path': str(path), 'bytes': size, 'sha256': before,
                          'scope': 'Preserved original artifact, not stored inside Git.'})
    else:
        raw = path.read_bytes()
        stored = gzip.compress(raw, mtime=0) if len(raw) > 24_000 else raw
        relative = Path('raw') / relative
        if len(raw) > 24_000:
            relative = relative.with_name(relative.name + '.gz')
        target = dest / relative
        assert not target.exists(), relative
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(stored)
        assert hashlib.sha256(gzip.decompress(stored) if len(raw) > 24_000 else stored).hexdigest() == before
        index.append({'source': str(path), 'archive': str(relative),
                      'original_bytes': size, 'original_sha256': before,
                      'archive_sha256': hashlib.sha256(stored).hexdigest()})
    assert digest(path) == before and path.stat().st_size == size, path


for base, prefix in [(root, Path('integration')),
                     (Path('/tmp/gpui-bundled-coverage-evidence'), Path('certificate')),
                     (Path('/tmp/gpui-coverage-events-evidence'), Path('simd-spike'))]:
    for path in sorted(base.rglob('*')):
        if not path.is_file():
            continue
        relative = path.relative_to(base)
        with path.open('rb') as stream:
            elf = stream.read(4) == b'\x7fELF'
        external = elf or path.name == 'disassembly.txt'
        # These five full outputs have the same checked SHA. Store the selected
        # one in Git; retain the other original outputs by indexed identity.
        if base == root and relative.name == 'stdout.log' and relative.parent.name.endswith('-run'):
            external |= relative.parent.name != 'certificate-run'
        preserve(path, prefix / relative, external)
        seen.add(path)

helpers = ['/tmp/gpui-run-frozen-gate-root.py', '/tmp/gpui-freeze-dependencies-root.py',
           '/tmp/gpui-analyze-coverage-machine-root.py', '/tmp/gpui-run-coverage-oracle-root.py',
           '/tmp/gpui-bundled-coverage-fault-root.py', __file__]
for name in helpers:
    path = Path(name)
    preserve(path, Path('helpers') / path.name)
for name in ['gpui-luna-text-pipeline-research-20261023.json',
             'gpui-bundled-coverage-audit-20261023.json',
             'gpui-cold-glyph-raster-audit-20261023.json']:
    path = Path('/tmp') / name
    preserve(path, Path('research') / name)
for directory in ['/tmp/gpui-coverage-events-root', '/tmp/gpui-coverage-events-broken-root',
                  '/tmp/gpui-coverage-text-oracle-root', '/tmp/gpui-coverage-certificate-fault-root']:
    tree = Path(directory)
    paths = subprocess.check_output(['git', '-C', str(tree), 'ls-files', '-z']).split(b'\0')
    for relative in paths:
        if relative:
            path = tree / relative.decode()
            preserve(path, Path('fixtures') / tree.name / relative.decode())

analysis = json.loads((root / 'machine-analysis-baseline-iterator-certificate.json').read_text())
old = analysis['variants']['baseline']
new = analysis['variants']['certificate']
sections = {name: new['sections'].get(name, {'bytes': 0})['bytes'] -
            old['sections'].get(name, {'bytes': 0})['bytes']
            for name in sorted(old['sections'].keys() | new['sections'].keys())}
assert sections['.text'] == -1632 and sections['.rodata'] == 832
assert new['allocated_sections'] - old['allocated_sections'] == 4
counter = json.loads((root / 'certificate-core-lines.json').read_text())
assert counter['source_commit'] == selected and counter['core_non_test_code_lines'] == 31321
report = {
    'selected_source': selected, 'adopted_commit': adopted,
    'previous_production_base': '2b52030aed8344ed9c5f6dcf54b2ba19acf8ddf4',
    'production_adopted': True, 'gates': gates,
    'oracle': json.loads((root / 'certificate-comparison.json').read_text()),
    'section_deltas_bytes': sections,
    'all_allocated_sections_delta_bytes': 4,
    'shape_code_bytes': {'old': 15119, 'new': 13544},
    'shape_max_observed_rsp_cfa_bytes': {'old': 4656, 'new': 3056},
    'added_events_next': {'code_bytes': 508, 'max_observed_rsp_cfa_bytes': 80},
    'core_noncomment_nontest': {'old': 31232, 'new': 31321, 'delta': 89},
    'data': {'maximal_intervals': 195, 'bytes': 585, 'bits': '21-bit inclusive end, 3-bit font presence'},
    'scope': 'Matched public fixture at the same path/compiler/flags; selected scalar/layout/error/selection oracle. Cross compilation is not native execution. Static frames are not dynamic stack peaks.',
    'rejected_boundaries': {
        'callback_f7a1192': 'Larger shape frame and outlined callback despite smaller whole text.',
        'iterator_b92220b': 'Shape max observed rsp CFA +192 before composing the font certificate.'},
    'failures_retained': ['Initial strict checks found two real test lints; repaired in successor.',
                          'Direct thin-RLIB metadata/link invocations failed before passing explicit rmeta+rlib.',
                          'One-bit font certificate and wrong UTF-8 continuation predicate fail their controls.'],
    'claims_not_made': ['speed', 'RSS', 'new allocation measurement', 'GPU performance',
                        'bounded binary-search comparison count', 'entire Cmap header removed'],
}
(dest / 'review.json').write_text(json.dumps(report, indent=2) + '\n')
(dest / 'file-index.json').write_text(json.dumps(index, indent=2) + '\n')
(dest / 'external-artifacts.json').write_text(json.dumps(externals, indent=2) + '\n')
print(json.dumps({'payloads': len(index), 'externals': len(externals),
                  'stored_bytes': sum((dest / row['archive']).stat().st_size for row in index)}), flush=True)
