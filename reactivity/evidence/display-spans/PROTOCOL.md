# Unified display representation: executable comparison, preregistration

Base df8ca59f69813e7dd05711fead98ed4278f1688d (qualified suffix core).
User clarification supersedes the shader sequence. No production adoption,
performance, shared-memory hardware, or competitor claim follows from this lab.
All changes local. Existing application API stays unchanged.

Compare two complete executable models on identical deterministic traces:
A. Packed preorder records with subtree lengths and identity-to-rank directory.
B. Fixed-slot pages with stable generational handles, threaded paint order and
subtree length. A subtree starts in O(1), but is not a physical contiguous span.
Pages are 32 records. Both use the same lossless column base/bitwidth codec,
with an uncompressed escape when encoding grows. Decode reads bounded words;
all block descriptors, directories, slack, tombstones and frame leases count.
Compressed bytes are consumed by a real Vulkan compute shader. GPU mutation
bytes/calls and completion synchronization are recorded, not inferred from one
queue submission. Portable wgpu staging is not coherent shared host memory.

Cases: repeated versus unique payloads; paint-only leaf, subtree translation/
clip, sibling-layout dependency; insertion at front and page boundary; removal;
subtree relocation; generation reuse; invalidated prepared update before
presentation; failed newer candidate and older eligible completion. Include
sparse and dense changes and sizes 32/256/1024. Fixed seed 20261028.

Use an independent pointer-tree/full traversal and full pixel render oracle.
Compressed roundtrip and retained damage repair must be exact. GPU output must
match independent CPU pixels; both representation decoders must match all
canonical words. Bounded wrong-span, missing old damage, stale-authority and
codec-width mutants must be rejected. Failures and corrected attempts retained.
No time thresholds or best-case filtering: first comparison is structural work,
not a speed verdict. Record nodes visited separately for lookup, dependency
closure, encoding/index upkeep, oracle and adapter; bytes rewritten/moved,
compressed/uploaded, fixed descriptor, GPU metadata and retained versions;
actual decoder/render work and synchronization. Do not call O(k) replacement
O(1), or a full-snapshot adapter an integrated direct update engine.

Trace an ordinary Win::set/Source update using unchanged GPUI public APIs:
identify target, record existing counters and exact prepared/acknowledged
semantics, feed restricted rect-only model through adapter and GPU consumer.
Charge snapshot/materialization costs separately. Unhandled text/effects/affine
and general float semantics remain integration gaps, never silent approximations.
The public API trace is additional to adversarial topology model traces.

Freeze clean source before each execution gate; fresh unique target, locked
nightly checksum builds, before/after all tracked build-input hashes, Cargo JSON
freshness and executed ELF/embedded WGSL hashes. Save all raw logs, seeds,
source/compiler/environment identity and a rederiving verifier in this dossier.
No shipping production files changed in this first representation comparison.

Research anchors: BBTree local1b0201087102f81189da0c4cd5054a91c8d97d62,
design04/05/07/12 (dense hot columns, shared-prefix keys, ordered mutation after
parallel read descent); Ripple fed124465d162ce17ce009936ef50061719d9882
(explicit compiled update groups and stale async versions); Solid
ff4d3c4479163fbdd3327f5b22d0c3ea7bd1a2c5 and fetch-high/block-low article
(work starts early; only consuming dependencies block coherent publication).
These suggest mechanisms; they do not establish wins in display-tree workloads.
