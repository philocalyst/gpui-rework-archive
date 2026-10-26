# Reactivity contract, revision 2

This is the explicit 2026-10-20 amendment to the supplied `final/` model and
statutes. It preserves their application vocabulary and progressive storage
ladder, while replacing the contradictory construction/publication promises
listed below. [DESIGN.md](DESIGN.md) defines representation;
[CONCURRENCY.md](CONCURRENCY.md) defines ownership across threads;
[GRAPHICS.md](GRAPHICS.md) defines pixel and resource obligations. Earlier passes
and unchanged statute sections remain useful requirements. An implementation
cannot claim both sides of an amended rule.

## Changes to the original laws

| Original home | Revision 2 rule | Reason |
| --- | --- | --- |
| 00 L1; 02 §1, borrowed generative public El | `View::view(&self) -> El<'_>` returns an owned description with borrowed operands. Only internal lowering cursors are frame-branded. | A method without a carrier cannot allocate into an independent current arena in ordinary safe Rust. |
| 00 L2; 01/03 mutation guard | `DerefMut` marks a checked revision before returning `&mut T`; enclosing owner publication discovers it. | The trait cannot return a custom drop guard. |
| 01 publication/delta complexity | Arbitrary owner callbacks scan that owner's wired descriptors; typed operations know exact sources. Exact old/new delta requires capture or instrumentation. | Inline movable values have no hidden runtime carrier or free previous value. |
| 00 L13, gate-3 | Optional macros preserve state, pixels, input/effect/drop order and the selected observation precision. They may reduce pure invocations and discovery work only. | Removing instrumentation cannot create old values or exact fine-grained edges from arbitrary Rust. |
| 08 logical draft failure; 01/04/05 observers | Successful source operations commit before pure derivation. Derivation produces Ready/Pending/Fault at that source version; it does not roll back committed arbitrary mutation. | Unrestricted `&mut Self`, interior effects, clone-free state and generic rollback cannot coexist. |
| 08 layout inverse journal | Cephal is private memo state. Publish immutable outputs; invalidate touched cache closure or poison/recreate workspace on failure. | No external reader depends on the workspace being an old-frame replica. |
| 00 model resolution 4, List slice | Slice dereference requires genuinely contiguous storage. Start with Vec; order/geometry indexes can be chunked independently. | Disjoint chunks/gaps cannot form one Rust slice. |
| 01 occurrence durability | Handoff is reliable in-process with explicit backpressure. Crash durability requires an attached durable journal and declared transaction/ack policy. | An in-memory FIFO is not a write-ahead log. |

The zero-tax law means a mechanism is paid where declared and its complete cost
is reported. It does not promise zero bytes or no fallback scan for every feature.
Public capabilities are scope-owned, not weak/strong reference lifetimes.
Shared immutable backing may use reference counting internally without changing
that rule.

## Public description and mutation

Keep `View::view(&self) -> El<'_>`, concrete branch-unifying `El`, ordinary Rust
control flow, constructor children, methods as routes and no public context
argument. An El owns headers/child storage and borrows operands for an ordinary
Rust lifetime. It is consumed/lowered while those borrows remain valid. It may
outlive a single call if its operands do; this is safe and **not** a generative
frame guarantee. Static and borrowed branches can shorten to a common lifetime.
Independent descriptions can be combined because no hidden arena identity exists.

An internal `describe/lower` scope owns scratch and creates generative cursors.
Those cursors cannot escape or mix with another scope. The retained output owns
changed operands or leases their stable immutable backing; it never retains a
borrow into an application `&self` or scratch. Returning an El does not retain
a raw pointer to a movable Signal. Direct wire installation uses a typed
owner-relative projection or an explicit stable source capability.

The [API experiment](crates/api-lab/README.md) is the compilability oracle for this
cut, including branching, constructor children and escape/mutation failures.
Its allocation strategy is a baseline to replace, not a proof of a zero-allocation
builder. Optimization candidates are small inline descriptions, owned chunks,
const templates and unchanged-owner avoidance. Measure construction, nesting,
spill and drop; do not trade these for quadratic flattening. A public arena fast
path would be a separately specified API, not undocumented TLS.

`Signal<T>` has ordinary shared reads and a mutation hint. Obtaining `&mut T`
counts as a possible change even if no write follows; destination equality cuts
off redundant work. Revision exhaustion is checked before exposing the borrow.
The initial primitive fails explicitly; a production rebase must suspend that
owner's publication, refresh all wired baselines and advance its incarnation
before restarting at zero. Silent wrapping is forbidden. Handler panic follows
the policy below; no destructor-based commit is assumed.

## Version domains and the turn

```text
typed input / arbitrary owner invocation / admitted worker result
                       │ successful operation commits
                       ▼
source sequence S ── pure settle ── logical outcomes L(S)
                                      │ candidate style/layout/scene
                                      ▼
                                 presentation P(L)
                                      │ submitted device generation D
                                      ▼
                              CPU / GPU / OS release
```

S orders committed source operations. L records coherent outcomes derived from
specific S versions, including Pending/Fault. P names a coherent immutable sheet
and the logical version it represents; P can lag L. Owner incarnation, request
ticket, template revision, schema version, and device/resource generation are
different typed domains. Equal integers in different domains imply nothing.
Checked exhaustion retires/rebases a namespace through a stated protocol.

A host event starts a **turn**. Invoke its admitted owner operation exclusively,
commit on normal return, discover touched source revisions and settle pure
dependencies to outcomes. Enqueue `changed` with the composed boundary publication
log at most once per owner in that wave. Release description/read borrows before
invoking it. `changed` may enqueue effects or another owner operation; it cannot
re-enter an active owner/settle/layout borrow. Those operations form subsequent
numbered waves within the turn, each with its own source sequence and outcomes.
Reach quiescence or a causal wave budget before admitting the next event in that
reliable source's order. Budget exhaustion suspends the remainder; it does not
erase committed writes or reorder later input ahead of them.

Coalesce scalar writes within an operation when the specified resting-state
semantics permit it. Preserve ordered occurrences, List/text edits and effect
order. `changed` observes boundary deltas, not an unrestricted effectful
dependency graph. A plain owner mutation conservatively marks that owner; exact
library operations provide exact deltas. No macro may skip an observable effect
because it guessed that an opaque callback had no dependency.

Presentation may be attempted after each needed barrier or at the host's redraw
opportunity; coalescing does not change logical event order. It publishes all of
layout, spaces, paint, hit geometry and accessibility bounds as one sheet.
User code cannot observe an intermediate candidate as committed.

## Commit points and failure

| Operation | Commit/acknowledgement | Failure/retry rule |
| --- | --- | --- |
| Arbitrary owner invocation | Normal return; source state becomes the next S | Panic poisons that owner and revokes future dispatch. No generic rollback or retry. Dispose on its legal owner after leases/borrows end. |
| Validated scalar/List/text/field operation | Validation and staged source edit succeed | Rejected operation returns its owned payload/error; no partial edit. Multi-owner atomicity requires an explicit staged batch of supported operations. |
| Pure derive/equality/cycle/measure demand | Outcome at admitted input versions | Publish Fault/Pending with provenance; do not relabel stale Ready as current. Explicit boundary policy may preserve a prior displayed cohort. |
| Worker completion | Validate once, then transfer payload into source/result inbox | Ticket consumption and retained result are one admission operation. Presentation failure cannot consume-and-drop the result; retry uses the inbox. |
| Handoff give | Successful insertion into its bounded queue | Full returns payload. If its owner subsequently panics, outstanding values follow declared owner-fault recovery/return policy, not silent successful delivery. |
| Handoff take | Explicit removal transfers ownership to receiver | In-process acknowledgement only. Durable take needs the journal policy below. |
| Entity/List lifetime transfer | Validated linear adoption commits | Failed transfer returns value and identity to original owner. Revocation invalidates queued capabilities. |
| Effect/action | Dequeue/admission under its declared reliability policy | Arbitrary external I/O is not automatically idempotent or rolled back. Retry only with declared idempotency authority. |
| Candidate sheet | Entire candidate validated and pointer/version published | Discard candidate outputs, retain prior P, invalidate/poison private caches; keep committed source/results. |

Owner panic cannot erase an externally committed I/O effect. A poisoned owner
may be quarantined behind an error surface; source snapshots are diagnostic and
not proof that arbitrary interior state can resume. If a Handoff must outlive a
potentially failing producer, its queue belongs to a longer-lived parent/service
scope. Its fault policy returns/drains/persists each untaken value exactly once.
A queue owned by the failed owner is explicitly reported as abandoned on disposal.

For crash durability, a journal records give and take/ack in the same declared
source transaction as relevant durable state, flushes according to policy, and
replays unacknowledged records on recovery. At-least-once redelivery is explicit;
exactly-once external effects require an idempotent receiver or transactional
external system. A serde snapshot can preserve an in-flight FIFO, but a snapshot
between give and a crash is not guaranteed unless actually committed. Plain
Handoff imposes no filesystem or journal dependency.

## Input while the presentation lags

Always validate target/owner generation at dispatch. A capability's continued
identity does not prove its old geometry is current.

| Modality | Authority while P lags L | Recovery behavior |
| --- | --- | --- |
| Key/text command with logical focus | Current logical focus; removed focus revokes immediately | Deliver in order to valid focused owner, or normal no-focus handling |
| IME edit/commit | Current valid composition owner; never resurrect removed field | Cancel native composition on revocation; defer geometry-dependent caret/candidate-rect update until coherent P |
| Pointer down/up, hit-targeted wheel, hover | Require a current presentation hit result | Hold a bounded ordered geometry-dependent suffix; do not hit-test old pixels as new layout |
| Existing pointer capture/drag | Stable capture may receive position-free cancel/release; mapping-dependent motion waits | Revoked capture gets cancellation; no synthetic click after target disappearance |
| Absolute/captured motion | Preserve latest absolute position where semantics permit; retain button transitions | Re-map at recovery under current space; cap queue and cancel gesture on overflow |
| Relative/raw motion | Ordered accumulated vectors only where declared additive; otherwise bounded FIFO | Map vectors without translation, under admitted space version |
| Accessibility semantic action | Validate current logical target and allowed action | Execute position-free action; bounds-dependent action waits; removed nodes revoke |
| Accessibility tree/bounds publication | Last coherent P tree and bounds, with revocation filtering | Publish one coherent replacement; suppress focus announcement for revoked target immediately |
| Test/inspector query | Must select logical-source or presented-sheet query explicitly | `settle` reports Pending/Fault and never silently calls stale P current |
| Window close/suspend/device loss | Native lifecycle authority, independent of candidate success | Cancel/release legally; cannot wait indefinitely for layout recovery |

The bounded input suffix cannot wait forever. On time/byte budget exhaustion,
cancel pending coordinate gestures/IME geometry, preserve reliable key/action
semantics, expose a framework-owned failure surface using a known-good fallback
renderer, and stop dispatching ambiguous spatial events to the broken content.
If even the fallback/device is unavailable, retain native close/recovery controls
and report the failure; do not silently discard input and claim success.
Recovery drops invalid queued targets, recomputes hover/hit state, and publishes
one coherent sheet before spatial dispatch resumes. Test removal of a composing,
captured text field during repeated layout failure.

Hover is derived from an admitted pointer sample and authoritative presented hit
snapshot. Paint/composite-only hover fast paths require a hit-invariance proof.
Geometry-affecting state overlays take the normal candidate path, with bounded
post-publication re-hit. Detect a repeated target/geometry configuration within
that causal input turn. On a pure-style hover cycle, diagnose the responsible
contribution and suppress its geometry-changing part for that pointer turn,
recomputing from the noncyclic base while retaining valid paint state. No idle
rehit loop is scheduled. A new physical input or independent geometry change
starts a fresh admitted evaluation. Arbitrary application hover handlers are
committed source operations; a cycle there follows the causal budget/fault policy
and cannot be silently rolled back as a style. Test stationary-pointer move,
resize, transform, removal and animated-boundary cases, including hover moving
its own box out from under the pointer.

## Typed schemas, override order and admission

A stable schema key is `{namespace, component, schema_version, field_id}`.
The namespace/component are declared stable names/IDs with collision checks;
field IDs are explicit, never automatically tied to Rust member position or a
function address. Process-local typed descriptor identity accelerates in-process
use. Stable keys select a registered codec/migration at a tool/process boundary;
the codec validates type/range/version before constructing a typed operation.
Neither `TypeId` nor a content hash is a durable ABI.

Public retained targets name sparse addressed sites, not raw template preorder
numbers. A template change remaps a surviving parent/child-ordinal/kind site;
replacement/unkeyed structural invalidation revokes it. Ephemeral NodeAddress
values include the sheet/template revision and cannot be replayed as stable
Targets. This distinguishes schema identity, semantic identity and snapshot
location without adding an identity record to every static primitive.

One library-owned declaration owns default, equality, allowed edits/reset,
validation, phase impact, codec and optional editor metadata. Typed setters,
fluent methods and inspector adapters lower to that declaration. Custom model
projectors remain safe but cannot certify an arbitrary impact or that separate
get/set functions point to the same field. They take conservative owner impact
unless a trusted schema contract is explicitly installed.

Resolve replace-valued style fields in this order: library default → enclosing
theme → named part style → instance setting → active state overlay. An explicit
reset removes that layer's contribution and reveals the preceding value. Each
property separately declares replace versus additive/composed behavior; transforms
compose in declared local order, not HashMap iteration order. A locked structural
invariant or accessibility/user policy is a validated constraint after resolution,
not a hidden extra style layer. Invalid values fail atomically with provenance.
Inspection reports the winning value and each origin; a paint-only change cannot
accidentally invalidate layout.

Each style layer stores contribution presence: `Inherit | Set(T)`. `Set(default)`
is not Reset, and `Set(currently_resolved)` must survive later lower-layer changes.
For library padding 4, theme 8 and instance Set(4), the result is 4; resetting
the instance reveals 8. An explicit Set(8) remains 8 if the theme later becomes
10. Equality may skip a destination patch while preserving the contribution
and its provenance. The template scalar lab's equality-to-default compaction is
valid for its fixed-default unlayered field only, not for layered style presence.

Behavior extension has explicit policies: replace a declared handler, or wrap
its typed invocation with `before/after` ordering and a single-use default-call
capability. The wrapper cannot invoke default twice through that capability.
It may enqueue declared typed operations subject to normal target authorization
and causal budgets. Private component state/commands remain inaccessible.
An arbitrary user callback is still arbitrary Rust with conservative effects;
the framework does not claim a Rust type system proof of purity or security
inside application code.

The common operation envelope carries origin/provenance, target generation,
schema and field key, expected revision where needed, typed payload and sequence.
Worker ingress additionally requires its exact request stamp; remote ingress
requires negotiated authority/idempotency; history requires a declared inverse;
accessibility and tests resolve the same production targets. Expected-revision
conflicts return a typed conflict with the payload intact. Each origin retains
its own trust, ordering, retry and byte limits. A shared dispatcher is not shared
unconditional authorization.

Unknown durable/plugin fields round-trip as bounded opaque bytes under their
original schema version. Migrations explicitly map field IDs and source values;
they cannot manufacture live capabilities. Restore remints owner/target/request
namespaces, preserves entity aliasing through a graph table, and re-arms producers
from source data through normal admission. Derived layout, raw pointers, closures,
device handles and private runtime indexes are rebuilt.
