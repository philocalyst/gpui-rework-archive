from pathlib import Path
import gzip,hashlib,json,shutil
root=Path('/root/gpui-ce3/reactivity')
out=root/'evidence/vulkan-stage-ownership'
out.mkdir(exist_ok=False)
checks=Path('/tmp/gpui-vulkan-stage-527-gates')
result=json.loads((checks/'results.json').read_text())
assert len(result['checks'])==7 and all(row['exit']==0 for row in result['checks'])
assert (checks/'source-unchanged.txt').exists()
assert 'warning:' not in (checks/'clippy.log').read_text()
def pack(source,target):
 p=out/(target+'.gz');p.parent.mkdir(parents=True,exist_ok=True)
 p.write_bytes(gzip.compress(Path(source).read_bytes(),mtime=0))
for p in checks.iterdir():
 if p.is_file() and p.name not in ['gpui_gpu','presentation','render']:
  pack(p,'checks/'+p.name)
for name in ['render','unit']:
 for suffix in ['build.jsonl','build.log']:
  pack(f'/tmp/gpui-vulkan-stage-527-{name}-{suffix}',f'build/{name}-{suffix}')
for suffix in ['json','log']:
 pack(f'/tmp/gpui-vulkan-stage-527-unit.{suffix}','unit/result.'+suffix)
pack('/tmp/gpui-vulkan-stage-test-graph.lock','unit/standalone-test.lock')
pack('/tmp/gpui-vulkan-stage-upstream.lock','unit/upstream-provenance.lock')
pack('/tmp/gpui-vulkan-stage-527-code-lines.json','code-lines.json')
for file in ['gpui-vulkan-stage-527-gates.py','gpui-vulkan-stage-freeze-unit.py']:
 p=out/'drivers'/file;p.parent.mkdir(exist_ok=True)
 shutil.copyfile('/tmp/'+file,p)
controls=Path('/tmp/gpui-vulkan-stage-gates')
for p in controls.iterdir():
 if p.is_file() and p.name not in ['gpui_gpu','presentation','render']:
  pack(p,'prior-1ec/'+p.name)
for name in ['initial','final']:
 for suffix in ['unit.log','unit.json']:
  pack(f'/tmp/gpui-vulkan-stage-{name}-{suffix}',f'prior-{name}/'+suffix)
(out/'README.md').write_text('''# Scoped Vulkan stage ownership

Frozen candidate `52701c8cc7` changes only the vendor HAL source and provenance;
six first-party libraries, public APIs and their 28,405 shipping code lines are
unchanged. Render, compute and ray-tracing pipeline construction previously
cleaned up stage-local shader modules only after successful driver creation.
Later-stage, render-pass or driver errors skipped those cleanup blocks.

`CompiledStage` now owns cleanup through one optional borrowed Device. Its
existing creation descriptor already stores the native module handle. Raw
modules keep their separate reusable owner. Entry-point CString validation
precedes native module creation. Vertex processing stores exactly one required
vertex-or-mesh stage plus an optional task, replacing three independent Options.
No persistent field, heap allocation, Arc, cache or platform binding is added.
The scoped lifetime follows the [Vulkan shader-module rule](https://docs.vulkan.org/refpages/latest/refpages/source/vkDestroyShaderModule.html).

Actual local Rust stage layout is 80→72 bytes; this is a type layout, not measured
stack reserve, native window RSS or frame-time improvement. Syn strips test
syntax and Tokei counts actual code: the modified vendor file is 2,627→2,591
non-test/comment/blank code lines, a 36-line reduction. The ledger is archived.

One fake Vulkan dispatch-boundary test passes success, early return after one
and two stages, unwind, and nonownership of Raw modules. It uses an actual
standalone Cargo unittest artifact copied from compiler JSON, with source and
executable hashes checked. Its standalone test graph was resolved separately
because the vendor's published lock is provenance, not the workspace graph.
Both effective test and untouched upstream locks are archived; no vendor lock
or shipping dependency changes are integrated. This is a scoped resource test,
not an induced physical driver failure or whole-HAL unit campaign.

The exact workspace graph separately passes 8 GPU units, 4 presentation tests,
44 actual Vulkan rendering cases, strict all-target GPU Clippy, formatting,
and Apple AArch64/Windows MSVC all-target GPU compilation with build-std. The
three executable paths come from actual Cargo compiler artifacts and copied
binaries are hashed around execution. All tracked crate/vendor/manifest bytes
are guarded around final checks. Apple/Windows checks do not execute their
native graphics; Vulkan execution uses Mesa llvmpipe. No timing or hardware GPU
memory claims follow. Existing pixel tolerances remain unchanged.

Prior controls are preserved separately. `fbc2` held a separate optional guard;
`1ec1` removed the duplicated handle and passed the resource and 44-pixel gates,
but its old three-Option initialization emitted unused-assignment warnings.
The final tuple fixes those warnings. The prior Apple command returned zero
while source was refined; the after-source guard rejected that campaign, so its
Apple log is unqualified and no old cross result is retagged as final. Only the
complete `checks/` campaign qualifies `52701c8cc7`.

The bounded repair covers stage module ownership. It does not establish full
GPU device-loss recovery, artifact parity, foreign-platform runtime conformance
or complete upstream resource-failure auditing. Offline artifacts remain a
separate opt-in implementation and retain their own module lifetime tradeoff.
''')
manifest={str(p.relative_to(out)):hashlib.sha256(p.read_bytes()).hexdigest() for p in out.rglob('*') if p.is_file()}
(out/'SHA256.json').write_text(json.dumps(manifest,indent=2,sort_keys=True)+'\n')
print(f'Archived {len(manifest)} files at {out}')
