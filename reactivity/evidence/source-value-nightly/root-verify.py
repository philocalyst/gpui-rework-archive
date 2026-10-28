from pathlib import Path
import hashlib
import json
import re
import shutil
import subprocess

source = Path('/tmp/gpui-source-value-nightly-root')
evidence = Path('/tmp/gpui-source-value-nightly-evidence')
provision = Path('/tmp/gpui-nightly-provision-2026-10-23')
out = Path('/root/gpui-ce3/reactivity/evidence/source-value-nightly')
pin = 'd6883d6d6ad2cee0ba3d3458ac9ef7fac5dea78e'
git = ['git', '-c', f'safe.directory={source}', '-C', str(source)]
assert subprocess.check_output(git + ['rev-parse', 'HEAD'], text=True).strip() == pin
assert not subprocess.check_output(git + ['status', '--porcelain'], text=True).strip()
contracts = json.loads((evidence / 'contracts-v4/results.json').read_text())
assert len(contracts['results']) == 10 and all(row['pass'] for row in contracts['results'])
assert sum(row['expected'] is None for row in contracts['results']) == 1
rows = re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored;', (evidence / 'default.jsonl').read_text())
counts = {'passed': sum(int(a) for a,b,c in rows), 'failed': sum(int(b) for a,b,c in rows),
          'ignored': sum(int(c) for a,b,c in rows), 'harnesses': len(rows)}
assert counts == {'passed': 554, 'failed': 0, 'ignored': 10, 'harnesses': 73}
library = Path(contracts['library'])
assert hashlib.sha256(library.read_bytes()).hexdigest() == contracts['library_sha256']
out.mkdir(parents=True, exist_ok=False)
for name in ['default.jsonl', 'default.log', 'contracts.log', 'contracts-v2.log', 'contracts-v3.log', 'contracts-v4.log',
             'compile-contracts-nightly.py', 'compile-contracts-nightly-v2-failed.py', 'compile-contracts-nightly-v3-failed.py',
             'default-attempt-0-source-freeze-conflict.jsonl', 'default-attempt-0-source-freeze-conflict.log']:
    if (evidence / name).is_file():
        shutil.copy2(evidence / name, out / name)
for name in ['contracts', 'contracts-v3', 'contracts-v4']:
    shutil.copytree(evidence / name, out / name, ignore=shutil.ignore_patterns('*.rmeta'))
(out / 'toolchain').mkdir()
for name in ['selected.json', 'verified-downloads.json', 'nix-loader-adaptation.json', 'rustc-version.txt', 'cargo-version.txt',
             'clippy-driver-version.txt', 'rustfmt-version.txt', 'feature-smoke.rs', 'feature-smoke-build.log', 'atomic-api.rs', 'atomic-api.log']:
    shutil.copy2(provision / name, out / 'toolchain' / name)
shutil.copy2('/tmp/gpui-source-value-adversarial-luna/findings.md', out / 'adversarial-review.md')
report = {'source': pin, 'source_tree_clean': True, 'bootstrap': False,
          'default_all_targets': counts, 'downstream_expected_rejections': 9,
          'downstream_positive_cases': 1, 'all_downstream_contracts_pass': True,
          'library': str(library), 'library_sha256': contracts['library_sha256'],
          'production_source_adopted': False,
          'scope': 'Exact-source genuine-nightly default/type qualification only. Strict/native/foreign/cost integration pending.'}
(out / 'root-verification.json').write_text(json.dumps(report, indent=2) + '\n')
(out / 'README.md').write_text('''# SourceValue prerequisite: genuine nightly qualification, unadopted

Exact isolated source `d6883d6d6ad2cee0ba3d3458ac9ef7fac5dea78e` passes 554 default all-target tests across 73 harnesses (10 ignored) on rustc 1.101.0-nightly 7189d39d9, dated 2026-10-22, official channel 2026-10-23. RUSTC_BOOTSTRAP is unset in both library and downstream compilation. Nine deliberately invalid public constructor/seal/type cases reject with their expected Rust error codes; one generic/trait-object/copy positive case compiles. Raw sources, commands, metadata hash and complete diagnostics are retained.

SourceValue structurally prevents declaring an exact Source whose value contains nested Signals, including heap containers and erased values without the bound. Those representations could mutate inner revisions while preserving the declared outer revision, invalidating exact delivery and Questions. Ordinary coarse owner updates and unregistered nested model state remain supported. The private negative auto trait and public sealed trait alias require nightly; this is not a stable-library compatibility claim. It is not a proof of arbitrary closure purity, hidden external state or user-defined interior-mutability effects.

The toolchain records verify eight official downloaded component archives. Nix required changing native ELF interpreter/RPATH; all seventeen adapted ELF .text sections remain byte-identical to the verified originals. Installer archives and compiler binaries stay external. The actual feature smoke compiles, links and runs without bootstrap.

The first downstream harness attempt selected the new Cargo rlib metadata stub. The next metadata attempt also needed full proc-macro dependency search paths. These failed harness attempts are preserved and do not count as expected SourceValue rejections. The final v4 harness uses the actual full rmeta plus every Cargo-reported library/proc-macro directory and checks the intended diagnostic per negative case. An earlier library build was interrupted after a producer documentation edit violated its source freeze; Root moved qualification into the independent exact-source tree above and completed the full gate there.

This evidence does not adopt SourceValue or change main's compiler. Existing Atomic::fetch_update deprecation warnings on this newer compiler remain visible; strict-warning, native, foreign and matched-cost integration checks are still required. SourceSchema/TAIT and typed inbox successors have separate sources and qualification; their results are not combined here.
''')
print(json.dumps(report))
