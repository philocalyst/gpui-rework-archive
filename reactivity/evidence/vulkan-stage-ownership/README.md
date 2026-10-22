# Scoped Vulkan stage ownership

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
