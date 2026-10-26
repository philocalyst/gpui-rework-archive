# Source delivery and the smallest necessary graph

This specifies the scheduler beneath the public storage ladder, ports, Readers,
actions and streams. [CONTRACT.md](CONTRACT.md) fixes observable publication and
fault semantics. The graph is an implementation of those semantics, not another
component API or a graph node hidden in every scalar.

## Separate storage, observation and delivery

A plain field belongs to its owner and is observed at owner grain. Signal adds
a checked mutation hint, not a heap source object. List owns slot/order delta;
Entity owns independent lifetime and scheduling. Reader owns a read capability
over a producer outcome, not application state. Handoff owns reliable occurrences.
Changing a storage rung must not change the meaning of the view or input order.

An installed source key contains owner namespace/incarnation and a typed field
or boundary site. The signal's local revision is meaningful only with that key.
A direct wire additionally names a destination site/property declaration. Store
these records only when something subscribes. Unwired fields have no fanout,
ready flag, virtual call, shared counter or source allocation.

Arbitrary owner mutation records the owner once, then scans its registered wired
projectors at the barrier. The exact typed operation path enqueues a known source
directly. Library controls use that path for high-rate edits. A registration can
resolve a borrowed `&Signal` against known typed projectors while the owner is
immovably borrowed, then retain its owner-relative key; it cannot retain that
borrow's address. Missing/ambiguous projection falls back to owner grain or a
located installation error, never an unchecked guessed field path. Conditional
or relocated fields require a declared incarnation/remount rule.

An optional derive generates those same projectors. It may avoid scans by
instrumenting explicit mutation, subject to gate-3 symmetry. Opaque aliases,
interior mutation and arbitrary Deref reads retain conservative behavior.
There is no TLS dependency collector that silently makes unrelated shared reads
part of the current graph.

## Lower relation classes to different mechanisms

| Relation | Retained mechanism | Work on change |
| --- | --- | --- |
| Constant | Template/default operand | None |
| Source → property | Destination edge and last accepted operand/version | Compare and patch exact typed lane |
| Fixed pure circuit | Shared ordered operator plan; instance varying slots | Run affected plan ranges; compare outputs |
| Dynamic projection | Cached outcome and replaceable read set | Discover attempted reads; validate/update edges; compare |
| List/filter/sort/group | Stable slot/order arrangement and typed operator state | Apply declared splice/edit/move delta |
| Worker question | Frozen input/version pack, request authority, outcome | Admit latest applicable completion |
| Effect/action/stream | Declared ordered boundary protocol | Queue after source/logical admission |

Static plans have known topological order and can use compact per-kind operand
lanes. A circuit function and its captures are part of the plan key; pointer/code
address is not equality. Type-specific output pages retain values once. Small
Copy values can live inline; large owned results move into a page/immutable lease.
Do not erase every value into `Box<dyn Any>` and then recover its type at each
patch. Type erasure is at a validated heterogeneous kernel/codec seam, with the
actual typed operation and drop behavior retained. Monomorphization/code-size
growth is measured and cold code may share a narrow dispatch stub.

## Sparse publication and equality

Deduplicate changed source/destination IDs by checked owner/turn stamps, using a
compact queue and touched ranges. Do not scan the whole scene to discover empty
work. Source revisions are hints: a destination compares the actual admitted
operand under its declared value/identity policy. Equality success cuts off the
downstream impact closure; it does not erase source contribution presence,
occurrences or provenance that is semantically distinct.

Value equality, identity equality and approximate numeric equality are separate
policies. Approximate equality is allowed only for a declared visual tolerance;
it must not suppress a document edit, request A→B→A, Handoff occurrence or schema
change. Hashes accelerate rejection/candidate lookup and require confirmation.
Comparing large values costs bytes; versioned immutable identity can avoid a scan
only if identity guarantees the same immutable content and policy.

Property schemas declare a fixed conservative Impact ceiling. Concrete changes
can cut off sub-impacts after comparison: unchanged alpha may skip occlusion-plan
rebuild, RGB-only paint can reuse geometry, translation can skip layout. Propagate
only the justified closure. A user cannot label an unrestricted setter paint-only
to bypass validation. Exact counters distinguish source discovery, operator run,
compare, destination patch, layout, coverage, occlusion and submit.

## Dynamic reads, cycles and coherent outcomes

Evaluate a pure projection against immutable admitted source versions through an
explicit read facade. The facade returns scoped reads/owned snapshots and records
source keys. It cannot mutate owners, invoke effects or retain a reference into
a replaceable output after the evaluation ends. Compute an owned candidate while
input borrows live, release them, then install the candidate into its typed lane.
This makes read-versus-write aliasing an actual Rust boundary.

Use the static plan order where known. For genuinely dynamic work, keep states
Unscheduled/Queued/Computing/Settled for the current source cohort and an explicit
evaluation stack/worklist. A demanded dirty prerequisite must settle before a
consumer is called Ready. Encountering Computing diagnoses a dependency cycle
with its read path. Avoid recursive Rust evaluation/destruction for deep graphs.
Priority/height indexes are disposable accelerators; they cannot authorize a
mixed-version result. Compare queue/height overhead against direct demand
evaluation and dense plan sweeps at actual dirty rates.

Collect attempted reads even when evaluation faults; never edit live reverse
edges during evaluation. On success, atomically replace the previous successful
set and discard abandoned recovery watches. On fault, stage the prior successful
set union newly attempted noncyclic recovery reads, validate the whole staged
edge change, then install it atomically under the graph owner. Retain explicit
cycle/structure provenance. Rejected cyclic edges do not become Ready dependencies;
their relevant boundary topology/producer revision is a retry watch. Deduplicate
retry within an unchanged source/input cohort so publishing the same Fault cannot
itself create an endless retry loop. Conditional mode-source changes and explicit
structural/producer changes retry the boundary. This keeps recovery observable
without retaining a stale value as Ready or losing newly discovered wake sources.
Obsolete edges and queued work carry generation checks and are reclaimed at a
safe phase boundary.

The edge-swap oracle must cover A reading B while B reads A only under a mode
source: the cycle faults, changing mode removes it, and both recover. Also cover
a failed branch that reads a new source then panics, removal of old dependencies
after success, equality panic and producer retirement/replacement.

An outcome is Ready(value/version), Pending(request/version), or
Fault(provenance/version). Retaining an old ready value for display is a boundary
policy; the current logical outcome remains Pending/Fault. Do not combine a new
source with an old prerequisite and call the result coherent. A cohort admits
compatible complete input versions, including unchanged dependencies whose
validity spans multiple source sequences. Equivalent final pixels are insufficient
if focus, effects, drops or reliable occurrences reorder.

## Readers cross ownership and latency explicitly

A question declaration captures typed stable inputs plus a producer site. Its
mounted owner resolves those sources and creates the producer. Constructing a
query then moving it and its Reader into a model cannot leave a retained pointer
to the old local variable. Use deferred typed declarations or an owned stable
source capability. Scope revocation yields Fault(Revoked), never pending forever.

Freeze the exact owned worker input and its observed revisions. Issue the request
only after source admission. The stamp includes owner lifetime, site/producer
incarnation and unique request ticket; input/policy changes issue a new ticket
even if the parameter later returns to an equal value. Cancellation reduces
waste; admission checks establish correctness. A completion validated once moves
into the committed inbox before its ticket is consumed. Layout/paint failure
cannot lose that payload or require a now-consumed stamp to be accepted again.

Reader accesses must reflect readiness. `inspect_ready`/a scoped settled value
can borrow a present T; a snapshot owns/leases T when it must outlive the read.
No fallible Deref, panic-as-suspension or permanent reference from a bare runtime
key is assumed. The final ergonomic Settled spelling must compile with replacement,
revocation and simultaneous readers before stabilization. A fallback value does
not make a dangling ready reference safe.

Queue bounds cover frozen inputs, running jobs, completion slots and pending
full results together. Stamp rejection drops semantic use, but backing storage
remains leased until CPU/GPU/OS completion. See CONCURRENCY for exact transfer,
wake and shutdown ordering. Opaque worker closures cannot inspect the live graph.

## Actions and streams retain their own algebra

A finite action declares its concurrency/reliability policy: single-flight,
queued, restartable or idempotent as appropriate to the operation. These are
sealed local adapters behind `.action(...)`, not a framework-wide Task enum.
Admission and acknowledgement differ. Restarting a read question is safe;
restarting a payment/send/save is not implied by cancellation support. Effects
run after logical admission, outside pure compute/layout, with provenance and
the source operation's declared ordering.

A stream is an owned protocol whose messages are domain data. It has reliable
ordered lanes, explicitly coalescible state lanes, sequence/generation, byte
quotas, backpressure and reconnect/resume policy. Remote deserialization is an
admission boundary; unknown or unauthorized messages do not become local typed
operations merely because their bytes parse. Preserve unsupported durable records
for migration/recovery under bounded codecs.

There is no physically possible guarantee of unbounded reliable ingress, bounded
memory and unconditional nonblocking acceptance at once. Native callbacks are
processed directly at legal owner barriers where feasible. External producers
receive admission/backpressure or a declared disconnect/error policy. Key/IME/
close transitions are never silently treated as latest paint state. Tests flood
each actual boundary and verify the promised rejection/ack behavior.

## Motion is another typed source of property changes

An animation track owns start/time/target/velocity and the property declaration.
Static/nonanimated fields have no clock subscription. Group tracks by kind for
contiguous time sampling; update through the same compare/impact path as an input
or inspector edit. Interruption samples the current value and velocity under the
track's interpolation rule. Reduced motion, hidden windows, long clock jumps and
zero duration have explicit state transitions. Springs terminate by a declared
error/energy threshold and snap policy, not endless epsilon redraw.

Transform/opacity tracks preserve layout; size/font tracks admit layout work.
Opacity changes still invalidate opacity-dependent occlusion summaries. An exit
track leases only the necessary immutable visual fragment/resources after logical
removal, with a byte/time cap and no live application borrow. Input capabilities
are revoked at logical removal even if its ghost pixels remain during the exit.

## Parking and reclamation

Parked/offscreen content keeps source/domain/slot identity and required protocol
state. Unneeded derived layout/paint outputs and their subscriptions can retire.
Focus/IME/capture, accessibility virtual nodes, pending actions and exit visuals
are explicit retention reasons. On activation, validate versions and rebuild
discarded answers lazily; old read sets cannot silently serve a new incarnation.

Use intrusive/recyclable edge records for mutable low fanout, with a compact CSR
or sorted fanout cache only where measured high fanout amortizes rebuilding.
Dead owners revoke requests and edge/site capabilities before slots recycle.
Checked generation exhaustion retires the slot. Clear touched bookkeeping and
release over-budget scratch after all phase readers end. No epoch pin can keep
unbounded history alive.

## Required graph evidence

Compare every incremental trace with a full pure recomputation oracle. Cover
branch read-set replacement, cycles and recovery, equality panic, revisions and
incarnations, same-value publication, A→B→A requests, dynamic source removal,
source/Reader moves, queued effects, saturated Handoffs and candidate failure after
completion admission. Check exact input/effect/drop order under macro on/off and
storage promotions. Record all registered fields scanned, edges/operators visited,
bytes compared, allocations and retained capacity. The no-macro fallback's price
is part of the result; it is not hidden behind a sparse graph claim.
