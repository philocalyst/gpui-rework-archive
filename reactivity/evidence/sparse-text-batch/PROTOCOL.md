# Transactional sparse text batches

Base 1830d9d54fe73903ffd909e3e19aab8c25e9763d, qualified source-batch
publication. Separate from the Question source-set experiment. Candidate keeps
ordinary layout, requires zero changed layout writes, then prepares all disjoint
text-run replacements before changing canonical commands or candidate rows.
This transfers BBTree's read/plan batch followed by ordered writes and route
revalidation; it does not assert memory-yield Futures will be faster.

Current multi-source admission removes owner description but falls back to
complete paint because sparse C/P publication represents one changed text row.
Extend only that proven certificate to bounded batches. Unknown/owner-dependent,
metadata, topology, viewport, geometry, new raster resources, run-length changes
and unproven layout retain complete preparation. No application API changes.
No borrowed model closure or Window reference crosses an await. No new unsafe.

Canvas replacement must be atomic across the entire batch. Validate every slot
and exact common state against the same preceding scene, reject duplicate slots,
and aggregate resource-use and tile-reference changes before applying any write.
Per-run checks alone are insufficient: two edits can collectively remove a
resource's final uses. Preparation errors/rejection leave the preceding scene
and its pixels intact. Apply admitted command and resource-count replacements
in input order, invalidate bins once, publish one damage union and one ACK token.
Text values and interaction geometry become P only on the matching ACK. Failed
newer candidates must not prevent an older eligible candidate's ACK.

Preserve the old single-run path and independently compare its machine code and
complete-operation cost. Report every new persistent field, transient allocation,
retained resource and shipping line. An owned TextLayout clone is acceptable in
an initial safe candidate only if its allocations/leases are included. A generic
scheduler, scene clone, or per-run full scene scan is not the intended solution.

Public gates: two/four independent edits against a fresh full window's exact
pixels/model/text geometry; mismatched run length/new glyph/full-layout fallback;
last resource used by two changed runs; duplicate slot rejection; transformed
or clipped text; failed newer glyph preparation then older ACK; accessibility
and native composition. Mutants must falsify aggregate resource or atomic
publication authority through independent output/lifetime observations.

Measure identical source_batch_cost and separate allocations examples against
this base: 0/25/1000 static labels, 1/2/4 fields, exact and owner-dependent edits,
opaque four-field control; five alternating process pairs pinned CPU2, 200 warm,
40 batches of 100 complete enqueue/deliver/record/ACK operations. Pixel oracle
outside timing. Primary two/four-field 1000-label CPU ratios <=0.8; all single-
field/fallback medians <=1.05. Include paired uncertainty, p50/95/99, cold/RSS,
allocation/retention, code and linked assembly. Unique targets, frozen commits,
full input guards, full default/composed tests, strict Clippy and actual native
scripts. Keep failures. No hardware or competitor victory from recorder results.
