#!/usr/bin/env python3
"""Extend the frozen public SourceValue contracts without weakening their errors."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

artifacts, destination = map(Path, sys.argv[1:])
original = Path('/tmp/gpui-delivery-isolation-sol/reactivity/evidence/source-value-nightly/compile-contracts-nightly.py')
program = original.read_text()
start = program.index('cases = {')
end = program.index('\nresults = []', start)
namespace = {}
exec(program[start:end], namespace)
cases = namespace['cases']
for name, value in {
    'cell': 'std::cell::Cell<u64>',
    'refcell': 'std::cell::RefCell<Vec<u64>>',
    'atomic': 'std::sync::atomic::AtomicU64',
    'atomic_alias': 'std::sync::Arc<std::sync::atomic::AtomicU64>',
    'mutex_alias': 'std::sync::Arc<std::sync::Mutex<Vec<u64>>>',
    'rwlock_alias': 'std::sync::Arc<std::sync::RwLock<Vec<u64>>>',
    'triomphe_atomic_alias': 'triomphe::Arc<std::sync::atomic::AtomicU64>',
    'borrowed_unsafe_cell': "&'static std::cell::UnsafeCell<u64>",
    'nested_alias': 'Vec<Option<Box<std::sync::Arc<std::sync::atomic::AtomicU64>>>>',
    'borrowed_signal': "&'static Signal<u64>",
}.items():
    cases[name] = ('E0277', f'struct Model(Signal<{value}>);\nconst VALUE: Source<Model,{value}> = Source::new(FieldId::new(1), "value", |m| &m.0, |m| &mut m.0);')
for name, value in {
    'immutable_std_arc': 'std::sync::Arc<Vec<String>>',
    'arcstr': 'arcstr::ArcStr',
    'image': 'gpui::Image',
    'std_text_geometry': 'std::sync::Arc<gpui_canvas::TextGeometry>',
    'triomphe_text_geometry': 'triomphe::Arc<gpui_canvas::TextGeometry>',
    'immutable_triomphe_arc': 'triomphe::Arc<str>',
    'immutable_arc_trait_object': 'std::sync::Arc<dyn std::any::Any + Send + Sync + gpui::SourceValue>',
    'borrowed_immutable': "&'static [u64]",
}.items():
    cases[name] = (None, f'struct Model(Signal<{value}>);\nconst VALUE: Source<Model,{value}> = Source::new(FieldId::new(1), "value", |m| &m.0, |m| &mut m.0);')
alias_source = Path('/tmp/gpui-delivery-integration-sol/reactivity/evidence/delivery-integration/raw/blocking-alias-negative/source_alias_contract.rs')
cases['original_public_alias_repro'] = ('E0277', alias_source.read_text())

for name, value in {
    'rc_cell_resource': 'std::rc::Rc<std::cell::Cell<usize>>',
    'rc_refcell_resource': 'std::rc::Rc<std::cell::RefCell<Vec<u8>>>',
}.items():
    cases[name] = ('E0277', f'struct Resource {{ bytes: Vec<u8>, drops: {value} }}\nstruct Model(Signal<Resource>);\nconst VALUE: Source<Model,Resource> = Source::new(FieldId::new(1), "value", |m| &m.0, |m| &mut m.0);')

destination.mkdir(parents=True, exist_ok=False)
libraries = {}
dependencies = set()
for line in artifacts.read_text().splitlines():
    try:
        message = json.loads(line)
    except json.JSONDecodeError:
        continue
    if message.get('reason') != 'compiler-artifact':
        continue
    for filename in message['filenames']:
        if filename.endswith(('.rlib', '.rmeta', '.so', '.dylib', '.dll')):
            dependencies.add(Path(filename))
    if message['target']['name'] in ('gpui', 'triomphe', 'arcstr', 'gpui_canvas') and 'lib' in message['target']['kind'] and not message['profile']['test']:
        metadata = [Path(f) for f in message['filenames'] if f.endswith('.rmeta')]
        assert len(metadata) == 1, message
        libraries[message['target']['name']] = metadata[0]
assert set(libraries) == {'gpui', 'triomphe', 'arcstr', 'gpui_canvas'}, libraries
def guards():
    return {str(p): {'bytes': p.stat().st_size, 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()} for p in sorted(dependencies)}
before = guards()
environment = os.environ.copy()
environment.pop('RUSTC_BOOTSTRAP', None)
results = []
for name, (expected, body) in cases.items():
    source = destination / (name + '.rs')
    prefix = '#![forbid(unsafe_code)]\n#![allow(dead_code, unused_imports)]\n'
    if name != 'original_public_alias_repro':
        prefix += 'use gpui::{FieldId, Signal, Source, Sources};\n'
    source.write_text(prefix + body + '\n')
    command = [environment['RUSTC'], '--edition=2024', '--test', '--emit=metadata', '--error-format=json', '--out-dir', str(destination)]
    for library, metadata in sorted(libraries.items()):
        command += ['--extern', f'{library}={metadata}']
    for directory in sorted({p.parent for p in dependencies}):
        command += ['-L', f'dependency={directory}']
    command.append(str(source))
    result = subprocess.run(command, env=environment, capture_output=True, text=True, timeout=30)
    (destination / (name + '.stdout')).write_text(result.stdout)
    (destination / (name + '.stderr')).write_text(result.stderr)
    diagnostics = [json.loads(line) for line in result.stderr.splitlines() if line.startswith('{')]
    codes = {d['code']['code'] for d in diagnostics if d.get('level') == 'error' and d.get('code')}
    passed = result.returncode == 0 if expected is None else result.returncode != 0 and codes == {expected}
    if name in ('cell', 'refcell', 'atomic', 'atomic_alias', 'mutex_alias', 'rwlock_alias', 'triomphe_atomic_alias', 'borrowed_unsafe_cell', 'nested_alias', 'original_public_alias_repro', 'rc_cell_resource', 'rc_refcell_resource'):
        # Diagnostics stop at the public alias and may hide the private
        # UnsafeCell reason. Require the exact public constructor bound instead.
        passed = passed and 'SourceValue' in result.stderr and 'gpui::Source::<M, T>::new' in result.stderr
    results.append({'case': name, 'expected': expected, 'codes': sorted(codes), 'exit': result.returncode, 'pass': passed, 'command': command})
after = guards()
assert before == after
(destination / 'artifact-guards.json').write_text(json.dumps({'before': before, 'after': after}, indent=2) + '\n')
report = {'source_pin': '22541342e3c10a962bc61f76088c7bfdb1b21bbd', 'bootstrap': False, 'artifact_guards': len(before), 'libraries': {k: str(v) for k,v in libraries.items()}, 'original_contract_helper_sha256': hashlib.sha256(original.read_bytes()).hexdigest(), 'alias_repro_sha256': hashlib.sha256(alias_source.read_bytes()).hexdigest(), 'results': results}
(destination / 'results.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps({'cases': len(results), 'passed': sum(r['pass'] for r in results), 'failures': [r['case'] for r in results if not r['pass']], 'guards_match': before == after}), flush=True)
assert all(r['pass'] for r in results)
