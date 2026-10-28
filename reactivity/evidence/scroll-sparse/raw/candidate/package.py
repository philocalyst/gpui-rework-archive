from pathlib import Path
import json, hashlib, subprocess, shutil

r = Path(__file__).parent
w = Path('/home/user/gpui-scroll-sparse-lab')
d = w / 'reactivity/evidence/scroll-sparse'
assert not (d / 'raw').exists()
assert not subprocess.check_output(['git', 'status', '--porcelain'], cwd=w).strip()
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=w, text=True).strip() == '5a07d7c28ffe500a5d24e25fdf1f31ce4857811f'
s = json.loads((r / 'matrix-analysis/summary.json').read_text())
a = json.loads((r / 'matrix-artifacts.json').read_text())
verdict = json.loads((r / 'matrix-analysis/verdict.json').read_text())
assert not verdict['all_point_gates_pass']
failed = [(case, n, v) for case, row in s.items() for n, v in row['comparisons'].items() if not v['pass']]
assert len(failed) == 2
report = '''# Precise repair outside a copied scroll — complete gate rejected

Local experiment; not adopted, merged or pushed. Existing application APIs and
all workload fixtures remain unchanged. Exact translated overlap and precise
outside damage compose successfully, but the complete fixed cost gate fails two
text controls.110 of112 comparisons pass. No native ZGX comparison follows this
failure, and no hardware/cache-hit/scanout or overall ZGX victory is claimed.

The mixed-update lead is real within this software-Vulkan endpoint: candidate
time is0.066503121 of the corrected original and0.150539480 of the bounding-copy
ablation. The latter isolates the new repair derivation. Scroll/original is
0.083086662; scroll/copy-bounds is1.021030455. Streaming's inherited sparse-repair
gain remains; it is not a new win from the scroll derivation. All tiny-list
comparisons pass in this cohort, without changing the earlier failed trial's verdict.

The failures below are mandatory point gates. Their intervals do not waive them:
'''
for case, n, v in failed:
    report += f"\n- {case}/{n}: {v['median_paired_ratio']:.9f},95% paired interval[{v['paired_bootstrap_95'][0]:.9f},{v['paired_bootstrap_95'][1]:.9f}], limit{v['limit']:.2f}.\n"
report += '''
## Method and execution identities

Implementation protocol372d3960dbebc85d02ed6526d88250b6b0977cab; separate cost/order
freeze a13c3629f0efc6a6a640a02530400d640244faf9. Candidate and copy-bounds differ
only in `outside_damage`; their representation, copy, repair iteration, submission,
ordinary render bodies, shader, application and benchmark fixtures are shared.
The other three current-app immutable controls come from the region-batch dossier,
with source/profile/fixture/ELF guards. Copy-bounds is built in a unique target.

28 cases ×20 paired five-way groups =2800 fresh timing processes. Each runs16
warmups and64 measured updates (179200 measured updates total). Two cycles of
a five-treatment Williams design balance positions and adjacent orders; groups
are shuffled with seed20261104. Before timing,420 correctness and140 allocation
processes pass exact final pixels/source epoch and per-operation copy/image gates.
No successful cell is selected for adoption and no failed comparison is rerun.

Primary estimator: median of20 paired process-p50 ratios, type7 quantiles and10000
paired bootstrap draws with seed20261104. Scroll/mixed must be<=0.8 versus original,
glyph-bounds and static sparse; mixed<=0.8 and scroll<=1.05 versus copy-bounds.
Stream/owner-stream must be<=0.8 versus original/glyph-bounds and<=1.05 versus both
newer controls. Every other comparison must be<=1.05. Exact thresholds and process
order are in COST.json and PROCESS_ORDER.json.

Pinned nightly2026-10-23, locked offline dependencies, repository-default release
profile, private X11:94, llvmpipe LLVM20.1.2/Mesa25.2.8 and LP_NUM_THREADS=4. No build,
other test, allocation probe, source edit, analysis or cleanup overlaps fixed timing.
All2800 processes finish and all before/after source/executable guards pass.

| Variant | Compiled source | Measured unit ELF SHA256 |
|---|---|---|
'''
for n, v in a.items():
    report += f"| {n} | {v['source']} | {v['sha256']} |\n"
report += '\n| Case | /Original | /Glyph bounds | /Static sparse | /Copy bounds | Gate |\n|---|---:|---:|---:|---:|---|\n'
for case, row in s.items():
    values = [row['comparisons'][v] for v in ['control', 'bounds', 'predecessor', 'copy_bounds']]
    report += f'| {case} | ' + ' | '.join(f"{v['median_paired_ratio']:.9f}" for v in values)
    report += f" | {'pass' if all(v['pass'] for v in values) else '**FAIL**'} |\n"
report += '\n| Case | Candidate warm p50 | Copy-bounds warm p50 | Original warm p50 | Candidate first update |\n|---|---:|---:|---:|---:|\n'
for case in ['scroll', 'both', 'stream', 'stream-owner', 'list-tiny']:
    v = s[case]['variants']
    report += f"| {case} | {v['candidate']['p50_ns']/1e6:.6f}ms | {v['copy_bounds']['p50_ns']/1e6:.6f}ms | {v['control']['p50_ns']/1e6:.6f}ms | {v['candidate']['first_update_ns']/1e6:.6f}ms |\n"
report += '''
Absolute medians are descriptive; their ratio is not the paired gate estimator.
Full per-frame, cold, tail and per-process observations remain in raw. The endpoint
is owner operation through native packet preparation, GPU completion and ACK. It
excludes OS/producer dispatch, active-host accessibility projection, WSI/scanout
and initial GPU-context construction from the warm metric. Fresh process/object
observations are not a cold shader-disk-cache measurement. Manual input/render
quality equivalence and two physical hardware classes remain open for the user goal.

## Mechanism, work and storage

The existing complete-scene proof certifies translated ordered contributions.
Outside the copied destination, the candidate compares complete filtered command
streams. Identical geometry/clip/color/material remains unchanged; every mismatched
old AND new contribution retains its conservative support, including both tails.
Glyph equality additionally requires key/dimensions and identical coverage identity
or bytes. Existing bounded DamageRegions collapses overflow to conservative bounds;
subtracting the copied destination yields at most256 scissor rectangles without
another unbounded queue. Exact PresentationToken from/to authority remains mandatory.

This applies BBTree's preservation of unaffected facts and Solid/Ripple's precise
publication boundaries. It does not add an executor or infer arbitrary View purity.
The earlier thread attribution identified raster workers as98–99% of scroll/mixed
CPU; the experiment reduces raster work rather than claiming memory-latency overlap.

Median mixed repair is15770 pixels versus169280 with bounding copy and524400 for
the non-copy alternatives. Both copy variants perform1401440 copied pixels and
retain4185280 image bytes at960x720: full presentation plus both overlap copies,
and backing plus scratch. Ordinary variants copy691200 and retain2764800B.
Scroll repairs12880 pixels in both copy variants. Tiny-list repairs16 versus256,
but still charges1504 copied pixels and5056 retained image bytes. Every operation,
including first use and warmups, meets its registered copy/image accounting.

Warm mixed allocation medians: candidate553.5 requests/358360B, copy-bounds549.5/
351576B; first update459/340212B versus455/333428B. Scroll and tiny-list candidate
allocations equal copy-bounds in the measured allocation run. Full mount, first,
warm, peak and net observations are retained. These count the invoking thread's
allocator calls, not all driver/process or GPU memory.

Runtime1824B, ordinary Output40B, Renderer888B and RetainedRenderer920B stay fixed.
Backing112→120B adds a lazy boxed texture handle. Existing boxed Metadata264→272B
and ephemeral SceneDamage32→40B are charged. ScrollCopy40B and ScrollTransition72B;
multiple repair regions can retain64×8B in their bounded allocation. These header
sizes do not describe the entire driver allocation. Root/window ownership remains
exclusive; there is no new production unsafe, Rc/Cell/RefCell or dependency/vendor change.

Shipping code37977 lines versus37933 for copy-bounds and37372 for static sparse.
Native ELF26388320B versus26385576B and26345432B respectively. Measured unit ELFs
are61312240B,61309528B and61349728B; unit and native reachability differ. Canonical
WGSL remains18995B, SHA256 ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1.
Actual regular/offline GPU and native ELFs contain the checked shader artifacts.
All five unique generated SPIR-V modules validate and occur in the offline render ELF.

Ordinary submit636B/1344B local stack reservation is unchanged; ordinary retained
render2153B/664B versus2117B/664B in static sparse. Its method text is identical,
but transitive backing work can change generated code. Ordinary preparation11664B/
1496B; regional and scroll preparation11701B/1512B each. Scroll submit733B/1512B,
scroll render1851B/264B. Precise outside derivation3478B/1672B versus107B/32B for
bounding derivation. These are local prologue reservations, not total call-chain,
driver or GPU stack bounds. Full selected disassembly and whole-ELF sections remain.

## Correctness, failures and reproduction

Candidate gates:346 combined Canvas/GPU tests (3 ignored),79 offline-shader GPU
tests,1102 composed tests (45 ignored),1009 default tests (13 ignored),328 minimal
library tests (25 ignored),17 workload-port tests in each native configuration,
11 actual native scripts and4 minimal scripts. All applicable strict Clippy gates
pass. The new copy-bounds source additionally has a fresh build/unit/GPU/port/Clippy
gate; identical-source full/native qualification is preserved. Older controls retain
their independently qualified composition and native evidence explicitly.

Shared exact-pixel fixtures cover positive/negative movement, outside edits and
insertions/removals, paint order, glyph identity, images/gradients/clips, changed
clear, failed/resize recovery, pending candidates, stale image authority and region
overflow. All three formats run against the independent ordinary full GPU renderer.
Transparent CPU/HDR and translucent SDR overlaps are covered; opaque-clear SDR
admission and all existing precision/fallback rules remain unchanged.

Omission mutant d6c1efceff015d68c7deff1367c0bcb532c3f268 skips the first repair and
fails actual pixels in case0/tick1/Rgba8UnormSrgb. Authority mutant
0a0a496e4640e80797bfc89f3a82731ffd3d7043 accepts a stale predecessor for the scroll
branch; the same-window Rows fixture differs in2893 of20480 bytes, first byte62
instead of54. The intact candidate passes both witnesses. No tolerance is introduced.

Preserved failed attempts include a Paint-specific test helper used for other
models, transparent content passed to opaque BGRX/SDR APIs, and a fault attempting
to access private token fields. Corrections affect fixtures/faults and preserve
production admission. A preclean helper used Cargo's old directory pattern and
copied zero build-script files; prior executed ELFs remain preserved, with identical
canonical shader bytes verified. The missed original build-script executable is
not claimed recovered. The corrected helper preserves192 package files before
the next clean. A preferred12GiB reserve failure accidentally launched a control
build due to missing fail-fast shell behavior; that owned build was stopped,
recorded and retried successfully. The hard8GiB build monitors remain active.
Receipt selector and verifier-extension helper mistakes stopped before timing and
are retained. They change neither the fixed gates nor this failure verdict.

Executed binaries remain in canonical SHA256 storage. Completed historical target
ELF cache copies were verified in raw/compressed archives before removal; exact
path/hash/mode receipts and a restore helper remain. Only separately recorded
regenerable libraries were removed. No source, evidence or canonical binary was
deleted. All owned processes were reaped. The original checkout is unchanged.

Run `python3 reactivity/evidence/scroll-sparse/verify.py` to independently check the
manifest, complete process order/rows/counters, point estimates/bootstrap intervals,
fault witnesses, shader bytes and preserved executables/cache archives. Keep this
failed result before testing another hypothesis. The extra ordinary publication
header and generated-code changes are candidate follow-up questions, not established
causes of the two small-text failures.
'''
(r / 'dossier-draft.txt').write_text(report)
raw = d / 'raw'
raw.mkdir()
shutil.copytree(r, raw / 'candidate', ignore=shutil.ignore_patterns('__pycache__'))
for n in ['control', 'bounds', 'predecessor']:
    shutil.copytree(Path('/home/user/gpui-region-batch-evidence') / ('cost-build-' + n), raw / 'reused-controls' / n)
for label, source in [('control', '/home/user/gpui-glyph-damage-control-evidence'),
                      ('bounds', '/home/user/gpui-glyph-damage-bounds-evidence'),
                      ('predecessor', '/home/user/gpui-glyph-submit-evidence')]:
    for part in ['full-native', 'native-checks']:
        shutil.copytree(Path(source) / part, raw / 'inherited' / label / part)
for name, before, after in [
    ('production', 'c965a893364b46f965c83d10e2cf94a46dac1304', '5a07d7c28ffe500a5d24e25fdf1f31ce4857811f'),
    ('ablation', '599e36c149ea252f96056f3d8e827da137f71197', '5a07d7c28ffe500a5d24e25fdf1f31ce4857811f'),
    ('omission', '5a07d7c28ffe500a5d24e25fdf1f31ce4857811f', 'd6c1efceff015d68c7deff1367c0bcb532c3f268'),
    ('authority', '5a07d7c28ffe500a5d24e25fdf1f31ce4857811f', '0a0a496e4640e80797bfc89f3a82731ffd3d7043'),
]:
    (raw / (name + '.patch')).write_bytes(subprocess.check_output(['git', 'diff', before, after, '--', 'reactivity/crates'], cwd=w))
research = Path('/home/user/gpui-architecture-local')
for name in ['COST.json', 'PROCESS_ORDER.json']:
    (d / name).write_bytes(subprocess.check_output(['git', 'show',
        'a13c3629f0efc6a6a640a02530400d640244faf9:reactivity/evidence/scroll-sparse/' + name], cwd=research))
shutil.copy2(r / 'verify_dossier.py', d / 'verify.py')
(d / 'README.md').write_text(report)
manifest = {str(p.relative_to(d)): hashlib.file_digest(p.open('rb'), 'sha256').hexdigest()
    for p in d.rglob('*') if p.is_file() and p.name != 'manifest.json'}
(d / 'manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
print('packaged', len(manifest), 'files')
