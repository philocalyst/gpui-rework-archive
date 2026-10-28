# Semantic review: commit source intent, fault derived work, publish immutable sheets

Research date: 2026-10-20. This review tests a semantic simplification against the final model and primary implementation/documentation sources. It is not an endorsement without the adversarial gates in §7. “Fact” means a cited source or the current design text says this; “proposal” is the suggested contract; “open” means the team must choose and test it.

## The simplification worth testing

Separate three facts that the current runtime text partially merges:

1. **Source intent:** a handler completed and mutated app-owned state. Commit that fact as a monotonically increasing source epoch and append typed source changes.
2. **Derived evaluation:** pure computations, description, style and layout attempt to derive results from a specific source epoch. A failure becomes a typed `Fault` result for the affected node/region at that same input epoch; it does not pretend the source edit never happened.
3. **Presented interaction:** hit geometry, paint, accessibility, focus/placement mappings and target resolution publish together as an immutable `PresentationSheet`. Until a valid replacement sheet exists, keep the prior sheet and its referenced owners alive; coordinate-dependent input waits or is explicitly rebased.

This is consistent with the current `Reader<T>` vocabulary, where `Ready`, `Pending`, and `Fault` are all graph outcomes and a `Fault` retains prior `Ready` content when policy allows. It may delete the layout engine’s inverse-operation journal and some global candidate rollback machinery. It **does not** make an arbitrary `&mut self` handler rollback-capable: inline `Signal<T>` already changes its value as the handler executes, and arbitrary plain fields have no general inverse. The current runtime itself admits handler panic has no general rollback and poisons/drops the owner, but then describes downstream settlement faults as leaving source revisions unchanged ([08-runtime.md §§1–2](/root/designs/reactivity/final/08-runtime.md:44)). Those claims need a crisp boundary.

The proposed contract is: a normally returning handler commits its writes even if it returns `Err`; `Result<T,E>` is route/domain data in the current handler table, not implicit transaction abort. An unwind poisons/revokes that owner, because its fields may be partially mutated; do not claim the prior state was restored. A caller that needs all-or-nothing writes uses an explicit typed transaction/delta builder with a staged value and commit. After source commit, a pure derived or presentation failure never rolls back the source epoch. That is the actual reduction in machinery.

## Exact contract delta from the current documents

The existing model has several stronger or ambiguous statements that this proposal changes:

| Current statement | Proposed clarification | Impact |
|---|---|---|
| `LogicalDraft` atomically swaps source revisions, derived outputs, structure, ports and lifecycle; a computation/equality/reconcile/budget fault drops it and leaves source revisions unchanged ([08 §2](/root/designs/reactivity/final/08-runtime.md:58)). | A successful mutable handler is the source commit point. Derived failure is a `Fault` for `(source_epoch, node)` and cannot erase the event or source mutation. | A component cannot rely on a view failure to undo a handler. Better matches arbitrary mutable methods; changes logical atomicity. |
| “Atomicity is per publication cut; coherence is per region; reveal is per boundary” for synchronous/async cohorts ([05 §9.0](/root/designs/reactivity/final/05-async.md:299)). | Keep region coherence and boundary reveal. Synchronous derived faults join the same typed verdict space as async `Fault`, with a distinct `FaultKind::Derive` and no worker request stamp. | Cohort boundaries still matter; an entire screen need not be rolled back. |
| Layout is the one mutable engine in a `PresentationDraft`; a fault replays inverse operations and dirties touched nodes ([08 §2](/root/designs/reactivity/final/08-runtime.md:70)). | Layout mutates only a private/versioned memo workspace; successful output is a newly published immutable sheet. Discard a candidate sheet and invalidate its touched scratch keys; never inverse-replay the committed engine. | Removes foreign-engine inverse journal if all externally visible results are sheet-owned and workspace can be safely invalidated. |
| Dispatch and hit-testing see one committed presentation epoch, while key routing/focus are logical-epoch state and pointer input waits on presentation recovery ([08 §1–2](/root/designs/reactivity/final/08-runtime.md:34)). | Keep this split, but say which resolver each event class reads. Pointer coordinates are tagged with the sheet epoch and held/rejected/re-hit-tested after publication; key/command events resolve against current logical focus/owner generation. | Prevents dispatch through a stale hit target into a newly reused node or mixing new model with old geometry. |
| `changed` is post-publish, at most once per turn and FIFO; its writes schedule the next round ([04 §2](/root/designs/reactivity/final/04-reactions.md:143)). | Preserve one invocation per owner per drained causal turn. Give it a composed `ChangeBatch` containing committed source records and derived boundary verdicts, with explicit per-record source epoch; its own writes form the next source epoch/round. | Existing effect ordering survives; no effect runs speculatively or against an uncommitted source mutation. |
| Current failure table has async `Fault` at a node, retains prior Ready operands, and applies boundary failed/stale policy ([05 §9.1–9.3](/root/designs/reactivity/final/05-async.md:306)). | Reuse the outcome type, but distinguish source/domain error, async worker fault, pure derive fault, layout/presentation fault, stale/revoked delivery. Do not conflate “new pure output fault” with “old output remains correct.” | Fault visibility improves; explicit stale policy remains essential. |

Current text also says a phase fault discards candidate geometry, never the document ([02 §1.2](/root/designs/reactivity/final/02-elements.md:86)); that statement directly supports source-commit/presentation-hold semantics. The model’s work should change primarily in `08-runtime.md`, `05-async.md` and their tests, not by creating a second unrelated fault system.

## A concrete turn and event-ordering contract

Use one serial dispatcher with two kinds of commit:

```text
external Intent (OS | test | accessibility | remote)
  -> validate target/sheet epoch/generation
  -> invoke one owner method(&mut Owner) to completion
  -> on normal return: commit its source writes as SourceEpoch e+1
     on unwind: poison/revoke owner; retain no claim of rollback
  -> drain queued typed commands FIFO; each successful owner invocation commits in order
  -> settle pure derived nodes against the final source epoch(s)
       Ready(value) | Fault(Derive { node, input_epoch, cause })
  -> build candidate BoundarySheets; each boundary applies show-fault | keep-stale | fallback
  -> build immutable PresentationSheet { layout, placement, hit, a11y, paint, resolver }
  -> publish one sheet epoch only when its coherent regions are complete
  -> invoke changed once per affected owner with the accumulated committed ChangeBatch
  -> settle writes caused by changed before the next external Intent
```

This makes one event’s causal command queue serial and non-reentrant, like the current pipeline. It does **not** promise atomicity across multiple arbitrary owner methods: if owner A’s method returns normally and a later queued method on B panics, A’s source epoch is committed and B is poisoned. If an operation must atomically alter several owners (remote presence batch, coordinated editor transaction, inspector multi-field edit), it must submit one sealed `BatchDelta` whose validation/application can be staged and committed as one source cut. Do not imply a generic callback taking `&mut` owners can be rolled back without copying, inverse logs or changing the API.

Use a small shared outcome algebra:

```rust,ignore
enum Outcome<T> {
    Ready { value: T, input: Revision, evaluation: EvalId },
    Pending { prior: Option<T>, request: RequestStamp },
    Fault { prior: Option<T>, kind: FaultKind, input: Revision, evaluation: EvalId },
}

enum FaultKind {
    Domain(ErasedError), AsyncWorker, Derived, Cycle(CyclePath),
    EqualityPanic, Layout(LayoutError), Budget(BudgetKind), Revoked,
}
```

The `prior` is not silently read as current. A boundary chooses `KeepPrior`, `Fallback`, or `ShowFault`; the inspector always reports the fault even when stale content remains. `latest(...)` remains a per-sink opt-in to current input intent, not a way to read a failed derived value. A stale content policy should record both `input_revision` and `value_revision`, making “showing old output for new input” explicit.

### Effect ordering and `changed`

- Source writes from an ordinary method are visible immediately to that same method through Rust, but no graph computation or `changed` callback re-enters during it.
- When the method returns, its writes become a committed source epoch. If its declared result is `Result<T,E>`, the result follows today’s route table; `Err` is not rollback unless the route explicitly uses a staged transaction API.
- Queued entity sends/actions run FIFO after the parent handler and each is its own owner invocation/commit. The dispatcher may coalesce presentation work, but cannot claim one atomic source state across already-run arbitrary methods.
- `changed` receives only committed records. It executes once after the causal queue is drained, as today; writes from `changed` schedule another round before the next external event. It cannot observe a pure output that has faulted as if it were a successful value; its boundary delta carries `Outcome::Fault` or only the diagnostic surface, to be decided.
- Focus claims/effects remain after the logical/source publication and before the next input. If the new presentation is unavailable, focus may already have logically moved; coordinate-based pointer input stays against the old sheet or waits. It must never combine the old hit tree with new, unpinned callbacks.
- A presentation fault may keep old paint/hit/a11y together. Do not keep paint old but publish new accessibility positions, or vice versa. Accessibility actions routed while old sheet is current carry that sheet epoch and generation.

### Cycles and multiple commands

A detected reactive cycle faults the active strongly connected evaluation region and records the cycle path; input sources remain committed. Suppress automatic retry until a dependency revision changes or a user-directed retry occurs, or it will spin each frame. Independent derived regions can still settle, subject to their own coherent boundary. For overlapping async cohorts, retain the current per-input request-ticket/policy-generation admission rules; a same-value `A→B→A` still needs tickets. The committed source epoch is not a substitute for request identity.

## Failure cases the simplification does not make disappear

### Arbitrary handlers and rollback

The current public surface permits ordinary `fn(&mut Self, ...) -> R`; the `Signal<T>` value is inline and `DerefMut` publishes on drop ([01 §3](/root/designs/reactivity/final/01-state.md:62)). If the method panics after incrementing a field but before updating an invariant, there is no general way to restore the previous owner. The existing answer—poison/drop the owner—is honest. Commit-on-normal-return records successful intent; it cannot heal an unwind. If a method returns an error after partial mutation, ordinary Rust `Result` cannot imply rollback either. An atomic editing API must stage a clone or typed invertible delta; expensive values may use a domain-specific snapshot/copy-on-write representation. Offer it only where needed.

### Equality/comparator panics

The runtime supports user-supplied `Eq(fn(&T,&T)->bool)` among node equality policies ([08 §3](/root/designs/reactivity/final/08-runtime.md:86)). If this function panics, do not turn the source write into “did not happen.” Mark that derived edge/output as `Fault(EqualityPanic)`, count it, and either conservatively propagate the value as changed only when a valid new owned output exists, or hold prior with an explicit stale marker. Equality must be pure, deterministic and total as a contract; a failed comparator cannot be used to claim equality. A destination that cannot compare should use `Always` (already supported) rather than running arbitrary app equality in commit.

### Panicking `Drop`

An arbitrary destructor can panic while a sheet, old value, or failed workspace is reclaimed. No transaction design can promise recovery from `panic=abort`, and a second panic while unwinding can abort. In unwind builds, defer reclamation outside publication and isolate/quarantine retired values if the runtime elects to catch panics; never publish partially dropped allocations. The baseline must state a destructor policy (typically destructors are required to be non-panicking for recoverable behavior) and test panic paths. Do not count “discard output sheet” as infallible if it can invoke user `Drop` synchronously.

### Stale completions and derived caches

Async results still require owner generation, producer generation, request ticket, exact frozen input revisions and policy generation as current §05 specifies. A faulted sync evaluator must not be retried from a stale completion or cache hit. Memo cache keys include all captured input revisions; a source epoch alone is too coarse for independently admitted input sets and too weak for ABA if epochs can be restored/rebased. On restore, namespace revisions with a session/owner generation.

### Presentation lag and input

While source epoch is e+1 and the visible `PresentationSheet` is for e, keyboard commands can target logical focus in e+1; pointer coordinates only have meaning in a specific presented geometry. Queue pointer events with their source sheet epoch and either (a) run against the still-pinned e sheet plus e handler capabilities, (b) re-hit-test at the latest sheet after publish while preserving timestamp/pointer sequence, or (c) reject with a typed stale-input result. The safest default for ordinary pointer input is wait then re-hit-test, with explicit policy for drag/capture/IME so an active gesture is not silently retargeted. Never dereference a node slot without its generation and epoch check.

### Atomic external batches

Remote/accessibility/test/inspector ingress should not each invent a transaction path. Each submits a typed `IntentBatch` with an origin, observed epoch, target/source identities and a list of sealed operations. Validation is all-before-apply; operations are staged in a `DeltaDraft`; commit advances one source epoch. This is available only for operations with known delta semantics. A batch that invokes arbitrary app closures is not atomic. Remote protocol operations also require durable semantic keys and idempotence; process-local `NodeId`/`Signal` slots never cross the wire.

## Private memo workspace and immutable `LayoutSheet`

### What existing systems actually establish

- **Chromium LayoutNG:** its design note states the cache stores input constraint space and a layout fragment; it reuses only if the constraint space is equal, there is no break token, and the node is not marked `NeedsLayout`. It clones the fragment without its offset so a parent can place it. This is a concrete precedent for immutable-ish local layout results plus separate placement, and a warning that exact constraints and invalidation are part of the key ([Chromium LayoutNG, retrieved 2026-10-20, moving `main` source doc](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/third_party/blink/renderer/core/layout/layout_ng.md#52)).
- **Chromium paint artifacts:** pinned paint README says a `PaintController` keeps previous display items; identical items or a valid subsequence can be reused, but reuse is guarded by painter-specific conditions and paint invalidation ([Chromium source revision `93af02c7e794220d52376ab1b461b4d9089ef479`](https://chromium.googlesource.com/chromium/src/+/93af02c7e794220d52376ab1b461b4d9089ef479/third_party/blink/renderer/core/paint/README.md#149)). It supports immutable fragment/artifact reuse with explicit validity, not “same widget template means same pixels.”
- **Flutter:** public `RenderBox` docs describe layout constraints and separate intrinsic/baseline protocols ([RenderBox docs](https://api.flutter.dev/flutter/rendering/RenderBox-class.html)); the implementation reference is tagged [Flutter 3.47.5 `box.dart`](https://github.com/flutter/flutter/blob/3.47.5/packages/flutter/lib/src/rendering/box.dart). A framework issue opened 2026-09-20 reports `_LayoutCacheStorage` keyed by exact dry-layout/intrinsic inputs growing with continuously changing constraints on Flutter 3.44.9/3.47.5 and 3.48 pre-release, with a proposed three-entry cap. Treat this as an author-reported adversarial case, not a framework guarantee or independently reproduced result ([Flutter issue #193075](https://github.com/flutter/flutter/issues/193075)). It demonstrates the risk of an exact signature cache without cardinality/budget/eviction policy.
- **Jetpack Compose:** official layout guidance uses a single child measurement per normal measure pass and separates measure from placement; intrinsic measurement is an explicit extra query path ([Compose layout basics](https://developer.android.com/develop/ui/compose/layouts/basics), [intrinsics](https://developer.android.com/develop/ui/compose/layouts/intrinsic-measurements)). This is evidence for eliminating redundant passes and making placement-only changes cheap, not for cross-instance sharing of measured sheets.
- **Slint:** the renderer’s `cache-rendering-hint` asks for an intermediate cached layer for complex rarely changing subtrees, can cost memory, and is unsupported on some backends ([Slint common properties, current docs retrieved 2026-10-20](https://docs.slint.dev/latest/docs/slint/reference/common/#cache-rendering-hint)). This is raster/composite caching, not layout memoization, and strongly supports capability-gated caches with a miss path.
- **Adapton / DBSP:** demand-driven incremental computations use identity, read dependencies and change algebra, but their cache correctness depends on tracked inputs and a valid incremental operator ([Adapton PLDI 2014, DOI](https://doi.org/10.1145/2594291.2594324); [DBSP PVLDB 2023](https://www.vldb.org/pvldb/vol16/p1601-budiu.pdf)). A GPUI custom measure closure that reads untracked external state cannot safely share cached output merely because its node template matches.

### Proposed split

```text
LayoutWorkspace (private, mutable, discardable)
  keyed memo entries, dirty/recompute queue, bounded scratch, diagnostics
          │ pure successful result
          ▼
LayoutSheet (immutable, epoch-stamped, atomically published)
  local sizes/positions, baselines, clips, hit geometry, semantic bounds,
  paint fragment references, child-order mapping, coordinate-space revisions
          │ per instance
          ▼
PlacementSheet (small overlay)
  instance origin/scroll/transform, focus/pointer mapping, semantic IDs
```

The candidate layout workspace may mutate its private caches while computing. Its only committed product is an immutable `LayoutSheet`. On failure, drop the candidate output roots; mark every workspace entry touched by the failed input signature non-reusable (or tag it with a candidate generation that is never committed), then retry from the old committed sheet. There is no inverse replay of Cephal/other mutable layout-engine operations because that engine state is not the published truth. This works only if the workspace can rebuild all affected results from source descriptors and its keys; if an engine’s hidden mutable state affects future output, it must be reset/recreated on failure or its inverse mechanism remains necessary.

Sharing identical rows is a **second, narrower cache**: share local `LayoutSheet` geometry only when the entire measured subtree is equivalent; store per-instance placement/identity separately. Do not put per-window origin, focus, hover, pointer capture, a11y IDs, callbacks, parent-dependent placement, or window-scale transforms into a shared local sheet. A placement-only change composes outside the sheet and does not relayout. A child size/content/measure/style change invalidates the shared result and its ancestors according to dependency signatures.

### Required cache signature (proposal)

A cache key must include equality-checked identity for:

```text
template_revision + node_kind + child_shape_revision
resolved_style_revision + layout_algorithm/version
canonical exact constraint space (min/max, fixedness, writing mode, fragmentation/break token)
measurement input revision/signature (text content + shaping/font revision + all declared reads)
environment revision (scale, locale/direction, accessibility/text scale, platform metrics, safe area,
                      window constraints and any other input the measure contract reads)
```

The output-sheet cache key excludes only fields proven to affect placement or paint after measurement; that exclusion is type/port metadata, not a guess. Compare the full key after hash lookup. Reject NaN/infinite invalid layout inputs before keying; canonicalize `-0` if the math semantics treat it equal to `+0`, otherwise preserve exact bits. Custom measure code with undeclared reads is non-cacheable or reruns at owner grain. A hash-only cache key is a correctness bug. A generation/hash is never reused as identity across session restore without namespace.

For N identical rows, each has independent placement `O(N)` (at least an offset/identity), but shared measured subtree geometry can be `O(S + N·p)` where S is row sheet size and p is small per-instance placement bytes, instead of `O(N·S)`—only when signatures and output invariants truly match. This is a derived upper-bound sketch, not a memory measurement. Memory is bounded by both bytes and distinct signatures per template (e.g. top K constraint signatures with LRU/clock eviction); evictions are safe recompute misses. Track hit rate, bytes, distinct-key cardinality, invalidation churn, recompute time and p99. A resize that creates many almost-distinct widths must stay bounded, as should font/locale/content churn.

## One typed change envelope, with honest precision tiers

The design promises O(publications) `Changed` assembly and says a plain-field commit compare exists, while ordinary `Signal<T>` is an inline value mutated through `DerefMut`, plain `T` reruns its owner, and `#[derive(Delta)]` generates a data-shaped observer view ([01 §§2–3, 8](/root/designs/reactivity/final/01-state.md:197), [10 gate R4](/root/designs/reactivity/final/10-quality.md:80)). A source ID cannot be discovered from an arbitrary field write unless an API, wrapper or compiler instrumentation reports it. This is a real precision/cost boundary, not a missing clever hash.

### Recommended canonical carrier

Use one `EpochBatch` format, and one ordered ingress queue, for input, publications, derived outcomes, presentation summaries, history and tools:

```rust,ignore
struct EpochBatch {
    cause: Cause,                 // User, A11y, Inspector, Test, Remote, Undo, System
    from: SourceEpoch,
    to: SourceEpoch,
    gesture: GestureId,
    records: SmallVec<[RecordHeader; 8]>,
}

struct RecordHeader {
    owner: OwnerId,               // namespace + generation checked
    field: FieldId,               // stable schema id, not field-name string
    before: Revision,
    after: Revision,
    kind: RecordKind,
    impact: Impact,
    payload: PayloadRange,        // typed descriptor decodes; owned if it crosses the frame
}
```

`RecordKind` is a closed kernel enum for `Replace`, `ListSplice/Edit/Move`, `TextSplice`, `Handoff`, `Lifecycle`, `OwnerInvalidated`, `DerivedOutcome`, and external command admission. Typed `FieldDescriptor<Owner, Value, Delta>` supplies decode/apply/compose/invert/serialize policy where supported. Runtime stays monomorphic at ordinary ports; erasure happens only in the tool/history/remote adapter. `Impact` remains the compile-time port metadata already defined in [03 §3](/root/designs/reactivity/final/03-ports.md:118).

Input is also an `Intent` in this envelope: target capability + expected sheet/owner generation + typed event/operation + origin. Mouse, keyboard, accessibility actions, inspector edits, tests and remote messages enter the same validator/dispatcher. Their provenance and operation permissions differ. Outgoing scene/a11y diffs are `PresentationBatch` records referencing source and sheet epochs; history consumes only operations with declared inverse/transform policy; remote serialization emits only stable domain operations, never raw local IDs. It is one envelope/ordering/attribution system, not one universal semantic payload type.

### How precision is produced without a magical source path

1. **Direct `Signal`/direct sink path:** a mounted `Signal` already has a dense slot. Its mutable guard publishes `(source_slot, revision)` in O(1), and a property sink patches directly. This is the zero-ceremony, precise path; a write may report `Replace` or `AlwaysChanged` if no old/new delta is retained. A full old/new `Change<T>` has a real ownership cost: copy/clone the old/new scalar, retain a prior owned snapshot, or ask the field for an explicit delta/revision. O(publication) log records do not imply O(1) capture of an arbitrary large payload.
2. **Sealed collections/text path:** `List` and text use their existing typed ops (`splice`, `move`, text edit), which produce known compact deltas and can serve layout, input, history and remote adapter from the same record.
3. **Arbitrary `&mut self` method:** normal owner invalidation is O(1); the owner reruns and tape-diffs. Plain fields get a coarse `OwnerInvalidated` unless explicitly described by source wrappers or a staged delta. Do not promise arbitrary field-level old/new values for free.
4. **Optional derive/manual descriptor:** `#[derive(Sources)]` can generate stable per-field descriptors only for fields explicitly marked `#[source]` and carrying a supported `Source`/delta type. Manual `FieldDescriptor` implements exactly the same schema. A derive cannot instrument arbitrary writes to a plain `String` or private external state; it can generate IDs/accessors and metadata, not observe invisible mutations.

Possible surface, while preserving ordinary Rust handlers:

```rust,ignore
#[derive(Sources)]
struct Search {
    #[source(delta = Replace)] query: Signal<String>,
    #[source(delta = TextSplice)] document: TextDocument,
    rows: Vec<Row>, // coarse owner-grained; no field-level tracking promise
}

fn on_key(&mut self, key: Key) {
    self.query.update(|q| q.push(key.as_char())); // known source slot publishes
    self.rows.sort_by_key(Row::rank);            // plain owner edit: rerun/diff Search
}
```

No `cx`, ambient tracking or guessed source path is introduced. For atomic multi-field tool/remote/history edits use `DeltaDraft::push(FieldDescriptor::..., operation).commit()`; for ordinary handlers, existing `&mut Self` remains. The one `EpochBatch` coordinator can log causes and changes, but this does not abolish the boundary between source deltas and derived presentation records.

### A contradiction to resolve before promising O(publications)

Gate R4 currently includes “plain-field commit compare” while requiring one signal publication in a large struct to cause zero comparisons beyond the destination’s own. A plain field mutation through `&mut Owner` is not individually published by the field, so the runtime cannot construct its old/new `Change<T>` without either (a) scanning/comparing fields, (b) snapshotting/journaling before mutation, (c) wrapping/instrumenting each field, or (d) representing it as one coarse owner invalidation and comparing only when a consumer asks. Pick and document the cost tier. Recommended correction: exact deltas are O(publications) for source/operation descriptors; arbitrary plain fields yield one owner invalidation and their view/tape diff pays its own declared cost; history only captures typed invertible operations or an explicit snapshot. The floor remains simple and correct, but no false field-level precision claim.

## Adversarial proof obligations

| Scenario | Required result |
|---|---|
| Handler mutates two plain fields then panics | Owner is poisoned/revoked; no claim of source rollback; old presentation remains pinned if safe. No `changed` observer is told a successful complete delta. |
| Handler mutates source then returns `Err` | Source operation commits unless explicitly inside staged `DeltaDraft`; `Err` follows declared route. |
| Synchronous memo A succeeds, B panics, C is independent | A’s output may be retained only if keyed to the input epoch; B becomes typed Fault; C can settle; affected boundary follows policy; source epoch remains committed. |
| Equality callback panics | No source rollback; comparator failure is attributed; result cannot be falsely declared equal; destination falls back conservatively or holds prior with visible Fault. |
| One child of a boundary faults while sibling is ready | Region/boundary policy provides coherent all-or-fallback content; do not publish a torn combination unless the boundary explicitly allows independent reveal. |
| Input A→B→A; completion for first A arrives last | Ticket and frozen input revisions reject old result even when values compare equal. |
| Pointer event from sheet e is waiting while source epoch e+1 unmounts its target | Either dispatch against pinned e owner/sheet, re-hit-test against the new sheet, or return stale-input; never call freed/reused owner by slot alone. |
| Layout candidate mutates measurement cache then faults | Candidate immutable sheet is dropped; all touched cache entries are discarded/invalidated by candidate generation; retry from sources matches full-layout oracle. |
| Layout output succeeds but paint/a11y fails | Do not publish mixed layout/hit/paint/a11y epochs. Keep prior full `PresentationSheet` or publish a deliberately defined diagnostic sheet. |
| Same template/style but row text/font/constraint differs | Cache miss unless every measurement input revision/signature matches. |
| Window resized through 10,000 unique widths | Cache bytes/cardinality remain within configured budget; eviction increases recompute only, never changes correctness. |
| Panicking `Drop` while dropping failed candidate, `panic=unwind` and `panic=abort` | No assertion of recoverability under abort. Unwind behavior is isolated or owner/window is poisoned; old published sheet remains valid until safe reclamation. |
| Remote batch partially invalid | Validate all operations before staging/commit; reject whole declared atomic batch. Arbitrary handler callback is excluded from atomic batch API. |
| Same `FieldId` in two owners / stale owner generation / restore session | IDs remain owner+generation scoped; schema revision and session namespace prevent alias; stale records are counted and rejected. |

Property tests compare derived nodes and every published `LayoutSheet` against a from-scratch oracle at the same source epoch. Fault injection at every node and every layout/paint/a11y stage checks atomic sheet publication. Model tests assert source epochs are monotonic even when derive/layout faults, and that no presentation record references unpinned owners.

## Judgment and recommended experiment order

**Adopt for prototype:** source commit on successful owner-method return; typed derived faults instead of source rollback; immutable `PresentationSheet`; private disposable/versioned layout workspace; bounded signature cache; one `EpochBatch` ingress/log envelope with explicit precision tiers.

**Do not promise yet:** restoration after arbitrary handler unwind, rollback after ordinary `Result::Err`, universal capture of plain field changes, global all-screen atomicity, shared layout solely from template/style equality, unlimited exact-constraint memoization, or recovery from arbitrary destructors under `panic=abort`.

Prototype in this order: (1) change only the internal fault semantics for pure sync derived nodes and prove unchanged source commit; (2) make layout output immutable while keeping current dirty engine as a workspace; fault-inject candidate invalidation and compare full relayout; (3) add a bounded per-node exact signature cache; (4) share one immutable local row sheet across repeated rows using per-instance placement; (5) unify event/history/inspector/test/a11y adapters on the `EpochBatch` header and measure hot-path bytes. Maintain the existing inverse/staged path for operations whose API actually promises atomic multi-source edits until each explicit `DeltaDraft` replaces it.

Go/no-go: the simplification wins only if it deletes inverse replay and candidate rollback code without increasing ordinary handler overhead, preserves old-sheet correctness under every fault injection, has a demonstrated cache hit rate on repeated components, and bounds memory under constraint churn. If a workspace’s hidden mutable state cannot be versioned/reset, retain its journal or replace that engine before removing rollback.

## Source index

- Local final model, runtime, and roadmap: [00-model.md](/root/designs/reactivity/final/00-model.md), [01-state.md](/root/designs/reactivity/final/01-state.md), [02-elements.md](/root/designs/reactivity/final/02-elements.md), [03-ports.md](/root/designs/reactivity/final/03-ports.md), [04-reactions.md](/root/designs/reactivity/final/04-reactions.md), [05-async.md](/root/designs/reactivity/final/05-async.md), [08-runtime.md](/root/designs/reactivity/final/08-runtime.md), [10-quality.md](/root/designs/reactivity/final/10-quality.md), [11-roadmap.md](/root/designs/reactivity/final/11-roadmap.md).
- Chromium LayoutNG, retrieved 2026-10-20, moving main doc: https://chromium.googlesource.com/chromium/src/+/refs/heads/main/third_party/blink/renderer/core/layout/layout_ng.md
- Chromium paint cache README, revision `93af02c7e794220d52376ab1b461b4d9089ef479`: https://chromium.googlesource.com/chromium/src/+/93af02c7e794220d52376ab1b461b4d9089ef479/third_party/blink/renderer/core/paint/README.md
- Flutter 3.47.5 RenderBox implementation: https://github.com/flutter/flutter/blob/3.47.5/packages/flutter/lib/src/rendering/box.dart ; API docs: https://api.flutter.dev/flutter/rendering/RenderBox-class.html
- Flutter issue #193075, opened 2026-09-20 (reported observation; not independent validation): https://github.com/flutter/flutter/issues/193075
- Jetpack Compose layout and intrinsic measurement docs: https://developer.android.com/develop/ui/compose/layouts/basics ; https://developer.android.com/develop/ui/compose/layouts/intrinsic-measurements
- Slint `cache-rendering-hint`: https://docs.slint.dev/latest/docs/slint/reference/common/#cache-rendering-hint
- Adapton PLDI 2014, DOI `10.1145/2594291.2594324`: https://doi.org/10.1145/2594291.2594324
- DBSP PVLDB 16(7), 2023: https://www.vldb.org/pvldb/vol16/p1601-budiu.pdf
- Rust destructors and unwinding: https://doc.rust-lang.org/reference/destructors.html ; https://doc.rust-lang.org/std/panic/fn.catch_unwind.html
