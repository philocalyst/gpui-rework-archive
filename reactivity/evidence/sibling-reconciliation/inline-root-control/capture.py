from pathlib import Path
import gzip, hashlib, json, shutil, statistics, subprocess

root = Path('/root/gpui-ce3')
out = root / 'reactivity/evidence/sibling-reconciliation/inline-root-control'
out.mkdir(exist_ok=False)
git = ['git', '-c', f'safe.directory={root}', '-C', str(root)]
digest = lambda value: hashlib.sha256(value).hexdigest()
def put(relative, data):
    path = out / relative
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)
def copy(path, relative=None, compress=False):
    data = path.read_bytes()
    name = relative or path.name
    put(name + ('.gz' if compress else ''), gzip.compress(data, mtime=0) if compress else data)

copy(Path(__file__), 'capture.py')
for path in Path('/tmp').glob('gpui-sibling-inline-*'):
    if path.is_file() and path != Path(__file__):
        copy(path, 'controls/' + path.name, compress=path.suffix in ('.log', '.json'))
for path in Path('/tmp/gpui-sibling-inline-pair').iterdir():
    assert path.is_file()
    copy(path, 'paired-run/' + path.name, compress=path.suffix in ('.log', '.json'))
for path in Path('/tmp/gpui-sibling-controls').glob('inline-root*.asm'):
    copy(path, 'assembly/' + path.name, compress=True)
for name in ['candidate.elf.json', 'inline-root.elf.json']:
    copy(Path('/tmp/gpui-sibling-controls') / name, 'assembly/' + name)
fixture = 'reactivity/crates/gpui/tests/sibling_reconciliation_cost.rs'
data = subprocess.check_output(git + ['show', f'89aeabd539:{fixture}'])
assert digest(data) == '8ac3ff609e6e7af336f2676cda8de0a6ce7c3dd26427baaf509c88a8ae60dfa1'
put('public-fixture.rs', data)
rows = json.loads(Path('/tmp/gpui-sibling-inline-pair/runs.json').read_text())
summary = {}
for cohort in dict.fromkeys(row['cohort'] for row in rows):
    changes = []
    for pair in range(7):
        values = {row['variant']: row['elapsed_ns'] for row in rows if row['cohort'] == cohort and row['pair'] == pair}
        changes.append(100 * (values['candidate'] / values['baseline'] - 1))
    baseline = [row['elapsed_ns'] for row in rows if row['cohort'] == cohort and row['variant'] == 'baseline']
    candidate = [row['elapsed_ns'] for row in rows if row['cohort'] == cohort and row['variant'] == 'candidate']
    summary[cohort] = {'paired_percent_changes': changes, 'median_paired_percent_change': statistics.median(changes), 'ratio_of_medians_percent_change': 100 * (statistics.median(candidate) / statistics.median(baseline) - 1), 'slower_pairs': sum(value > 0 for value in changes)}
put('paired-summary.json', (json.dumps(summary, indent=2) + '\n').encode())
put('README.md', b'''# Unadopted empty/root sibling control

Shipping control `926105a025dcae6b543bef9d56ee958f8504e244` is based on
`89aeabd53942c3a4643bcb6fd978e6a24703f6d2`. It uses an Empty/Root/Indexed enum
to avoid scratch allocation for the empty helper and the one-node public owner.
The helper remains 24 bytes. The exact standalone source patch and public fixture
are included; no dependency or retained field changes.

The actual tiny owner with three updates falls from 30 allocation requests / 2820
requested bytes to 27 / 2772; peak remains 832 bytes and retained bytes are
unchanged. Every larger owner row is identical. Private map/allocator tests,
the public owner check, default all-target strict checks and formatting pass.
These scoped checks are not a broad native/foreign qualification.

Seven alternating process pairs per cohort, pinned to CPU0 with the other
workers held, retain all 56 samples. Median paired time changes are -3.41% tiny,
+0.34% flat1K, +0.83% nested1K and +0.31% flat16K. The runner prints a different
statistic, the ratio of cohort medians: -2.81%, -0.01%, +0.83% and +0.82%.
Both statistics and every paired delta are retained. Source and executable guards,
semantic assertions and process audits pass. Unrelated host activity remains
uncontrolled. No frame, startup, RSS or universal speed improvement is claimed.
The existing CSR producer is the baseline, not the older ordered-map baseline.

The source adds 11 core code lines, excluding tests/comments/blanks. Whole linked
.text grows 176 bytes, .rodata 16, .data.rel.ro 24 and .eh_frame 36. Selected
actual disassembly and section ledgers are preserved; no dynamic stack-peak
claim follows. The tiny allocation win does not justify silently adopting the
measured larger-owner losses. Main keeps the existing CSR implementation.
''')
manifest = {str(path.relative_to(out)): digest(path.read_bytes()) for path in sorted(out.rglob('*')) if path.is_file()}
put('files.sha256.json', (json.dumps(manifest, indent=2) + '\n').encode())
for name, expected in manifest.items():
    assert digest((out / name).read_bytes()) == expected, name
print(json.dumps({'files': len(manifest), 'paired_summary': summary}, indent=2))
