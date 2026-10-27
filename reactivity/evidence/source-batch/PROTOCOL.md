# Typed source batches: preserve destinations through one publication barrier

Base 6d5e409d6b. The prior delivery-sweep experiment failed: the compiler already
uses jump-table index routing. Do not inherit that candidate. The current target
is actual work elimination: Lane::apply forgets typed edit identities when a
batch touches different fields, causing one conservative owner re-description.

BBTree insert_many gathers destinations then applies in input order, invalidating
routes affected by earlier structural writes. GPUI's typed direct bindings already
supply destinations, but layout/paint/IME/input/a11y must publish coherently. First
trial keeps at most four distinct typed source identities in transient batch
storage. No application API changes, background runtime, unsafe, retained index,
or reordered user callback is permitted. Opaque callbacks, status terminals,
overflow, invalid bindings and failed callbacks retain conservative behavior.

Initial certificate is intentionally narrow: no Question lanes, virtual lists,
inspector, owner-invalidating source, or nonvisual-text destination. Each admitted
visual text node has one primary source, so distinct fields have disjoint sinks.
Patch the existing text destinations from final model values, then do one ordinary
layout/paint/publication. Do not publish a partial color bank, skip text measurement,
or weaken old-ACK eligibility. Mixed metadata/style/color batches and Question DAGs
stay on their existing coarse path. Those are separate future experiments, not
implied by this certificate. Solid-style coherent dependency-closure transitions
remain a distinct semantic gap; this does not claim to implement them.

Before timing freeze production and identical public fixture commits with complete
source guards and independent targets. Compare real recording-window enqueue,
delivery and ACK for 1/2/4 distinct fields, 0/25/1000 static labels, and exact/fallback
cases (opaque mixed callback, owner-dependent field, names/style, dynamic list,
Question plan, failed newer preparation and old eligible ACK). Existing callback
FIFO, source epochs, lifetime and no-replay contracts remain exact. Compare complete
fresh-window pixels and public text/selection/commit semantics. Expected counters
change only where work is deliberately eliminated; preserve semantic assertions in
older tests while updating performance counters only for admitted cases.

Primary >=20% CPU improvement for 2/4 fields with 1000 static labels; <=5% regression
in one-field and fallback guards. Five rotated process pairs pinned CPU2, 200 warmups,
40 batches of 100 complete operations, CPU/wall p50/p95/p99, no dropped pairs or noise
claims. Include cold allocation, peak/retained bytes, new transient field bookkeeping,
shipping lines, ELF and linked code. Do not run timings with compiler/test/allocator
probes. A mutant admitting an owner-dependent field must fail an independent public
pixel/text oracle. Full GPUI/default and composed native/Canvas qualification required.
Passing this experiment admits equivalent application/hardware trials only.
