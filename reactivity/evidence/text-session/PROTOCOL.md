# Owned text-session cache: preregistration

Baseline `d5848eb970`: the unadopted sparse-publication candidate. This campaign
is separate from its noisy smallest-cell result and never overwrites those runs.
The original complete recorder `75a9e2b06b` remains a second control.

Inspection shows `TextShaper` constructs a new FontContext, font registration,
LayoutContext and paragraph scratch for each present pass. Hypothesis: preserve
that exclusively owned planning state between successful passes, while keeping
borrowed font cmap views scoped. Do not use self references, unsafe lifetime
extension, Rc/Cell/RefCell or new dependencies. A font identity mismatch must
discard cached state. Failed/panicked preparation and removal of text must not
retain poisoned state or historical font owners. Existing scoped `shaper()`
remains the ordinary independent oracle and public application APIs stay intact.

Run the existing complete state-update workload: 0/25/100/1000/10000 static
labels, 200 warmups, 2000 measured operations in 200 batches, five interleaved
process pairs. Preserve every batch, binary/input/compiler receipt, errors,
cold/teardown and RSS. Compare the candidate to sparse publication and the
original full recorder under one session, not to timings from previous sessions.

Advance only if median process CPU improves at least 20% versus sparse publication
in both the zero-static and 1000-static cells, no other cell regresses over 5%,
and independent Unicode/layout/pixel/authority checks pass. Noise is inconclusive.
Report retained cache and allocator costs separately, including font replacement,
long text then short text, mixed scripts, failed shaping and full reclamation.
No cache lifetime or memory claim follows from an elapsed-time win alone.

The negative control must retain planning state across a foreign font identity
and fail an exact oracle. Check scoped versus cached shapes, metrics, original
byte geometry, source/scene leases, and real application behavior. This remains
a CPU qualification; equivalent rendering, native latency and two hardware
classes are still required before declaring a ZGX win.
