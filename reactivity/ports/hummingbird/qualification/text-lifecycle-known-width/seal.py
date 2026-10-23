import hashlib
import json
import os
import pathlib
import shutil
import subprocess
import tempfile

root = pathlib.Path('/tmp/gpui-hummingbird-browser-allocation-evidence')
out = root / 'known-qualification'
tree = pathlib.Path('/root/gpui-hummingbird-browser-allocation-sol')
pin = '02638ee5fa748fb97b7e39733bde653a33e8e963'
base = 'dfc4f4624fbd7e94aadade21f95674ef851d5dfa'
package = pathlib.Path('/tmp/gpui-hummingbird-known-width-seal-sol')
assert not package.exists()
assert subprocess.check_output(['git', '-C', str(tree), 'rev-parse', 'HEAD'], text=True).strip() == pin
assert not subprocess.check_output(['git', '-C', str(tree), 'status', '--porcelain'])
statuses = json.loads((out / 'all-gate-exits.json').read_text())
required = ['canvas', 'clippy-default', 'clippy-native', 'constructor-release-build', 'constructor-release-runtime', 'core-layout', 'core', 'cross-aarch64-apple-darwin', 'cross-x86_64-pc-windows-msvc', 'gpui-default', 'gpui-native', 'gpui-verify', 'headless', 'native-client-collections', 'native-client-default', 'native-release-build', 'optimized-callers-v2-driver', 'oracle-build', 'oracle-runtime', 'port-clippy-default', 'port-clippy-native', 'port-cpal', 'port-default', 'port-native', 'scoped-fmt', 'static-constructor-baseline-v3', 'static-constructor-candidate-v3', 'static-native-baseline', 'static-native-candidate', 'attribution-compare']
assert all(statuses[name] == 0 for name in required)
assert all(int((out / 'known-attribution' / (name + '.exit')).read_text()) == 0 for name in ['build', 'runtime', 'analysis'])
oracle = json.loads((out / 'oracle-comparison.json').read_text())
assert oracle['stdout_byte_equal'] and not oracle['measure_mismatches']
package.mkdir()
summary = {
    'production_pin': pin, 'browser_base': base,
    'disposition': 'Not recommended for adoption. Functional/resource controls pass, but both const Engine policies cause a material whole-code regression. Preserve as the exact control for one-concrete-Engine successor.',
    'timing': 'No timing campaign or speed claim.',
    'required_stage_exits': {name: statuses[name] for name in required},
    'all_stage_exits_including_preserved_failures': statuses,
    'harness_results': json.loads((out / 'functional-progress.json').read_text()),
    'oracle': oracle,
    'constructor': json.loads((out / 'constructor-release-comparison.json').read_text()),
    'whole_code': json.loads((out / 'whole-code-comparison.json').read_text()),
    'public_controls': json.loads((out / 'optimized-public-controls.json').read_text()),
    'native_public': json.loads((out / 'native-public-summary.json').read_text()),
    'type_headers': json.loads((out / 'type-headers.json').read_text()),
    'core_lines': json.loads((out / 'core-lines.log').read_text()),
    'application_lines': json.loads((tree / 'reactivity/ports/hummingbird/qualification/collection-browser/upstream-browser-inventory.json').read_text())['current_port_shipping_code_lines'],
    'cross_scope': 'Installed-source GPUI --lib native check with build-std, Apple/Windows; no Linux x11 flags, SDK link/run or CPAL hardware claim.',
    'attribution': json.loads((out / 'attribution-comparison.json').read_text()),
}
(package / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
shutil.copy2(out / 'README.md', package / 'README.md')
selected = ['PLAN.md', 'functional-progress.json', 'all-gate-exits.json', 'constructor-ledger.json', 'constructor-deltas.json', 'constructor-release-comparison.json', 'whole-code-comparison.json', 'optimized-public-controls.json', 'native-public-summary.json', 'type-headers.json', 'oracle-comparison.json', 'core-lines.log', 'source-guard.json', 'source-guard-scope.json', 'cargo-config-guard.json', 'native-artifacts.json', 'constructor-artifacts.json', 'attribution-comparison.json', 'attribution-parser-initial-failure.json', 'static-env-failures.json', 'important-frames-baseline.json', 'important-frames-candidate.json', 'all-public-shaper-frames.json', 'next-application-domain.json']
for name in selected:
    shutil.copy2(out / name, package / name)
for source in out.glob('*.py'):
    shutil.copy2(source, package / source.name)
for source in out.glob('*.sh'):
    shutil.copy2(source, package / source.name)
for fixture in ['mixed-caller', 'public-geometry-cost', 'mixed-caller-v2', 'public-geometry-cost-v2']:
    for source in (out / fixture).rglob('*'):
        if source.is_file() and source.suffix in ['.rs', '.json', '.log', '.exit']:
            destination = package / source.relative_to(out)
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source, destination)
for name in ['normal', 'probe', 'text-oracle']:
    for source in (root / name).rglob('*'):
        if source.is_file() and source.suffix in ['.rs', '.toml', '.lock', '.py'] and 'target' not in source.parts:
            destination = package / 'fixtures' / source.relative_to(root)
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source, destination)
for source in out.glob('*.log'):
    if source.stat().st_size > 2_000_000:
        continue
    shutil.copy2(source, package / source.name)
for name in ['default', 'collections']:
    for file in ['result.json', 'events.json', 'native.log']:
        destination = package / ('native-client-' + name) / file
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(out / ('native-client-' + name) / file, destination)
patch = subprocess.check_output(['git', '-C', str(tree), 'diff', '--binary', base, pin])
assert hashlib.sha256(patch).hexdigest() == 'bcf7bab64862d8b1d4770081bf0a85ce6800f450705a833f6b313fab92d99efc'
(package / 'production.patch').write_bytes(patch)
external = {}
for source in sorted(root.rglob('*')):
    if source.is_file() and 'target' not in source.parts:
        external[str(source)] = {'bytes': source.stat().st_size, 'sha256': hashlib.file_digest(source.open('rb'), 'sha256').hexdigest()}
(package / 'EXTERNAL-SHA256.json').write_text(json.dumps({'scope': 'Complete external evidence tree at closure, including original alternatives, old/new outputs, complete assembly/raw allocation traces and frozen binaries. Targets are excluded; copied actual release artifact archives/ELFs are included. These are file bytes, not retained heap or RSS.', 'files': external}, indent=2) + '\n')
files = {str(source.relative_to(package)): {'bytes': source.stat().st_size, 'sha256': hashlib.file_digest(source.open('rb'), 'sha256').hexdigest()} for source in sorted(package.rglob('*')) if source.is_file()}
(package / 'SHA256.json').write_text(json.dumps(files, indent=2) + '\n')
with tempfile.TemporaryDirectory(prefix='known-width-evidence-index-') as temporary:
    env = dict(os.environ, GIT_INDEX_FILE=str(pathlib.Path(temporary) / 'index'))
    git = ['git', '-C', str(tree)]
    subprocess.run(git + ['read-tree', pin], env=env, check=True)
    prefix = 'reactivity/ports/hummingbird/qualification/text-lifecycle-known-width/'
    for source in sorted(package.rglob('*')):
        if not source.is_file():
            continue
        blob = subprocess.check_output(git + ['hash-object', '-w', '--stdin'], input=source.read_bytes()).decode().strip()
        subprocess.run(git + ['update-index', '--add', '--cacheinfo', '100644', blob, prefix + str(source.relative_to(package))], env=env, check=True)
    new_tree = subprocess.check_output(git + ['write-tree'], env=env, text=True).strip()
    commit = subprocess.check_output(git + ['commit-tree', new_tree, '-p', pin, '-m', 'Record known-width text lifecycle controls and unfavorable Engine code growth'], env=env, text=True).strip()
    subprocess.run(git + ['update-ref', 'refs/heads/codex/hummingbird-known-width-qualification-sol', commit], check=True)
closure = {'production_pin': pin, 'qualification_pin': commit, 'package': str(package), 'package_manifest_sha256': hashlib.file_digest((package / 'SHA256.json').open('rb'), 'sha256').hexdigest(), 'production_patch_sha256': hashlib.sha256(patch).hexdigest(), 'external_manifest_sha256': hashlib.file_digest((package / 'EXTERNAL-SHA256.json').open('rb'), 'sha256').hexdigest(), 'source_worktree_remains_clean': not bool(subprocess.check_output(git + ['status', '--porcelain']))}
pathlib.Path('/tmp/gpui-hummingbird-known-width-closure-sol.json').write_text(json.dumps(closure, indent=2) + '\n')
print(json.dumps(closure, indent=2))
