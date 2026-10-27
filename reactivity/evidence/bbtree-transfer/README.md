# BBTree architecture transfer research

Reference: XiangpengHao/bbtree, pinned locally at
`1b0201087102f81189da0c4cd5054a91c8d97d62` in
`/home/user/bbtree-reference-local`. Read-only study; no benchmark claims were
independently reproduced. The project's advertised 5x/12x/30% results concern
its workloads and hardware, not GPUI. No BBTree dependency has been added.

## Findings from primary implementation and experiment records

- [Cost model and rejected trials](https://github.com/XiangpengHao/bbtree/blob/1b0201087102f81189da0c4cd5054a91c8d97d62/design/06-cost-model.md):
  count dependent loads, hot cache lines, shifts, retained bytes and generated
  instructions. Doubling internal node size removed a level but slowed integer
  lookups; fewer misses alone did not consistently improve latency. Changes in
  inlining and aggregate return code generation reversed some results.
- [Inline keys](https://github.com/XiangpengHao/bbtree/blob/1b0201087102f81189da0c4cd5054a91c8d97d62/design/04-inline-key.md):
  dense routing summaries separate search from payload; equality ties must
  consult full keys. Width follows the cost of ties and actual key distribution.
  This is useful hot/cold separation, not permission for approximate identity.
- [Batch design and measured limits](https://github.com/XiangpengHao/bbtree/blob/1b0201087102f81189da0c4cd5054a91c8d97d62/design/12-batch-api.md):
  private lanes interleave independent memory stalls while preserving a
  synchronous external API. The simpler level-by-level scheduler was faster
  than the adopted generic async lanes. Batching is size-gated; its state and
  scheduling cost are not free. Single-key software prefetch was rejected.
- [Implementation](https://github.com/XiangpengHao/bbtree/blob/1b0201087102f81189da0c4cd5054a91c8d97d62/bbtree/src/tree/batch.rs):
  per-caller marker types isolate code generation, lanes write results into
  caller slots, and a live-bit mask avoids duplicate state tags. This is
  internal memory-latency scheduling, not an argument for an async UI API or
  shared mutable window ownership.

## Fit to the current GPUI core

GPUI already factors common font identity from glyph keys (Canvas MaskIndex),
keeps affine identity runs before its 12-byte sorted fallback (IdentityIndex),
and stores sparse metadata outside ordinary nodes. Replacing these with a
million-entry B-tree would discard existing structure. Virtualized lists only
materialize visible rows; a 100K-row source does not imply a 100K-entry hot map.
Fanout uses BTreeMap<FieldId, Fanout>, but its live source count and lookup share
must be measured before changing the map. Numeric IDs do not have BBTree's
heap-string comparison chain. No blanket map replacement is justified yet.

Candidate experiments, in priority order:

1. **Cold-path isolation of bounded text scratch.** The preceding bounded cache
   passes memory gates but misses CPU gates. Move rare paragraph destruction and
   reconstruction into a cold non-inlined helper. Inspect linked machine code;
   retain exact threshold/ownership/output and all failed prior cells. Separate
   preregistration at `/home/user/gpui-cold-trim-lab/reactivity/evidence/text-cache-cold-trim/PROTOCOL.md`,
   branch `local/text-cache-cold-trim`. This directly tests BBTree's code-generation
   lesson without importing its unsafe internals or changing public APIs.
2. **Separate routing keys from fallback payloads.** If actual identity/metadata
   lookup traces expose long dependent searches, compare current packed entries,
   dense key/value columns and bounded multiway routing. Charge extra allocations,
   construction, maintenance and small-node overhead. Keep consecutive-ID and
   run fast paths. Exact full-width identity checks remain authoritative.
3. **Batch independent lookups at existing pass boundaries.** First measure
   resource-key resolution or sparse publication groups. Compare ordinary loop,
   level-wise batches and serial reuse; require complete-pass improvement.
   Do not introduce a coroutine executor before showing cache misses dominate.

The existing pixel-uniform GPU experiment predates this reference. It follows
an analogous principle of proving redundant work removable, but must not be
attributed to BBTree or conflated with its CPU measurements. No competitor
performance victory is established by this research or any isolated result.


## Current campaign result

The historical proposals above have been exercised; see the campaign index and
[SCHEDULING.md](SCHEDULING.md) for their preserved failures and qualifications.
The latest certified scroll-copy dossier8041b7a7fe shows a strong whole-owner/GPU
completion signal but fails its tiny-flat control. The next hypothesis concerns
aggregate layout and dispatch code generation, consistent with BBTree's measured
lessons; it does not import its runtime or claim measured cache-hit improvement.
