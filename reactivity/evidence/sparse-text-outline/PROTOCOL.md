# Outline the bounded text-batch preparation path

Base 2d55c3dff194443742736f8171422dc11b59ed48, complete rejected atomic sparse
batch dossier. Its 210-process comparison gained 14.4x/8.1x on two/four-field
1000-label updates but failed the 25-label two-field owner control (1.05617).
Zero-label two-field exact edits also lost (1.07818). Preserve all those results.

Concrete code-generation observation: the new batch helper was inlined into
try_sparse_text, increasing that linked routine 2078→5337 B per specialization
and its stack reservation 344→584 B (six pushes in both). This is not proof of
the narrow control regression's cause. This candidate adds only #[inline(never)]
to try_sparse_text_batch. No cold hint, eligibility threshold, storage change,
borrow/clone refactoring, new API, new unsafe or altered publication contract.
Confirm the actual linked routine and stack sizes before interpreting timings.

Keep the identical source_batch_cost/allocations fixtures and original qualified
source-batch control (measured ed2997bf38ff9187ce4c1012f6da159e52e87795,
complete dossier 1830d9d54fe73903ffd909e3e19aab8c25e9763d). Five alternating
fresh-process pairs in all 21 cells: 0/25/1000 labels, 1/2/4 fields exact/owner,
opaque four-field control. CPU2, 200 warmups, 40×100 complete enqueue/deliver/
record/ACK operations. Exact final pixels/source epochs and expected owner
counts in every process. Primary 1000-label two/four-field ratios <=.8;
all single-field/coarse medians <=1.05. Keep all pair ranges and CPU/wall tails,
cold/RSS, allocation/retention, shipping/linked code and stack costs. Do not
reinterpret failures or discard noisy samples to obtain a passing outcome.

Separately compare against the inline candidate, three alternating pairs at
25-label two-field owner, 1000-label one-field exact and 1000-label two/four-field
exact. Same fixture/endpoint; report separately, never pool with baseline gates.

Freeze clean source and unique target before compilation. Capture the exact
build-only example ELF and its stable build/out path immediately after Cargo
JSON build success; cargo test can overwrite release/examples aliases with a
different feature-unification build. Full input guards include .cargo, manifests,
lock/toolchain and vendors. Preserve failures. No compiler, tests, allocator
probes or source edits during timing. Run complete default GPUI/Canvas suite,
X11 composition, strict Clippy and six actual native scripts. The base's
sequential-partial-commit mutant already falsifies the unchanged transaction
certificate; this code-layout-only trial introduces no new semantic certificate.
Its source/receipt remains in the base dossier, explicitly not a fresh mutant run.

No automatic adoption or competitor/hardware claim. Software Vulkan/private X11
and recorder costs do not establish physical presentation latency. A later GPU
packet-patch or shader experiment must be preregistered independently.
