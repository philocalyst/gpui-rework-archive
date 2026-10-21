# One runtime, ordinary users, independent oracles

Tests configure the production host rather than instantiate a second application
engine. The same owner dispatcher, source barriers, schema setters, sheet
publication, input routing and visitors serve native apps, `Application::demo`,
`Win::demo`, the inspector and tests. The synchronous production surface exists
in `gpui`; native accessibility uses that same sheet and action dispatcher.
Virtual time and the full asynchronous graph remain separate implementation gates.
The supplied `final/10-quality.md` supplies the broader feature corpus, subject
to [CONTRACT.md](CONTRACT.md)'s explicit semantic amendments.

## The public testing cut

The implemented synchronous cut uses ordinary exclusively owned windows:

```rust,ignore
let app = Application::demo();
let mut search = app.open(SearchPage::default())?;
search.type_text(search.role(Role::TextInput).one()?, "ban")?;
search.click(search.role(Role::Button).text("Find").one()?)?;
assert!(search.contains_text("banana")?);
assert_eq!(search.root()?.hits.len(), 3);
```

Each `Win<V, L>` owns its actual production runtime and static inbox chain
(`L = ()` by default). Demo application configuration
opens windows of different model types without an index, shared owner, shadow
dispatcher or registry. The returned windows own their lifetimes; closing a
window drops its model and resources. Queries borrow `&Win`; edits, input and
presentation acknowledgement require `&mut Win`. Rust rejects mutation during a
source/scene read. There is no production `Rc`, `RefCell` or `Cell` in this window
engine. Immutable text uses one-word ArcStr leases between source and presented epochs;
fonts/masks/backend resources have their separate immutable resource leases.
The [ownership evidence](crates/gpui/evidence/thin-text.md) charges larger distinct
nonempty string headers, dependency unsafe internals and measured CPU losses.

`visit` also exposes each part's target, parent, focus, supported semantic actions,
name/description/value, frozen list metadata and canonical local geometry.
`perform(target, Action::...)` uses the
ordinary activation/focus/text-edit barrier. Supported actions are frozen with
the acknowledged sheet; execution revalidates current logical authority. A
screen-reader request cannot keep a removed site alive or route to a replacement.
Semantic activation of the real Todo port matches ordinary input source JSON and
rendered output. A 1,000-pass visitor test allocates nothing and performs no
source/layout/paint work. Input values are not misreported as accessible names.
Explicit names/descriptions and typed semantic Set/Inherit overrides use sparse
publication columns; queries combine those predicates with visual text filters.
Richer text protocols and semantic relationships remain gates.
Focus is current interaction state over the acknowledged parts: it can change
without a source edit or frame, and logical removal revokes it immediately even
when an older sheet remains displayed. Position-free actions deliberately invoke
the current logical operation at the surviving site; old advertised support is
not permission to bypass current handler/type/lifetime validation.

`bounds()` is viewport-clipped query geometry. `local_bounds()` plus `transform()`
is the retained canonical geometry basis; the latter is already absolute to the
window in physical pixels, including ancestor transforms and DPI. Native bridges
derive full bounds when needed rather than retaining another rectangle per node.
`unclipped_bounds()` is a conservative on-demand convenience, with no screen-origin
offset or exact hit-membership promise. UIA's full bounds and offscreen state must
remain distinct. An AccessKit hierarchy must not compose these already-absolute
transforms again at every ancestor.

`role`, `contains_text`, `bounds`, `filter_count`, `root` and borrowed `visit`
avoid diagnostic snapshots. Unique queries reject ambiguity rather than select
an arbitrary component instance. Counts/visitors observe the acknowledged sheet
while a source edit awaits repair; resolving a new query target requires a current
presentation. Target stamps combine the window namespace and checked monotonic
retained ID, so querying allocates no capability table. Checked description
recovery remounts invalid identities; presentation-only failure preserves targets
for position-free editing repair. Query tests assert zero allocations across
5,000 operations and compiler tests reject escaped visitor data/reentrant mutation.

Source persistence uses `source_json`/`from_json`; restoration remints targets.
Snapshots/inspection and explicit pixel diagnostics remain available when those
artifacts are needed. Focus and normalized keyboard input now share the production
operations; [the keyboard contract](crates/gpui/FOCUS.md) records their exact scope.
The 1,000-cycle navigation test allocates nothing and performs no source, layout
or paint work. Virtual time, completion control and replay remain implementation
gates through production facilities. There are no dummy test-only timers or a
second event loop.

Typed `Remote<T>`/`Inbox<T>` queues and `deliver_ready(budget)` now provide the
production delivery primitive for native and deterministic headless callers.
Tests send ordinary owned values, choose the batch budget and inspect the same
source/commit results as applications. They cover FIFO, bounded staging, sparse
lane fairness, arrivals during callbacks, callback faults, failed presentation
repair and receiver-before-model teardown. A real X11 script verifies wake-driven
delivery without polling. Typed one-source questions now add registered source,
revision, coarse replacement, retry and consume-once ticket admission. Their
ordinary `Completion`, `deliver_ready`, status/ready-borrow and retry APIs serve
tests and applications. The real Library search tests hold normal completion
caps to choose result timing and check previous controls, failed C repair,
same-batch supersession, faults, physical credit and restored domain state.
The model's ephemeral Reader is rebound through a fresh Questions plan after
domain DTO restoration; it is not serialized as authority. A separate actual
X11 script requires result/credit progress through WorkReady, and three Loom
cases check the credit/wake seam. These are not the complete multi-input
dependency/cohort graph; see [the Reader contract](docs/reader-question.md). See
[the delivery contract](crates/gpui/REMOTE.md) for the exact capacity and lifetime
limits.

Keyed lists also use the ordinary public testing interface. The 250K Library
model is shared by native and headless tests. Native execution verifies actual
acknowledgements, line/pixel wheel routing, target survival/revocation, pointer
activation, resize, suspend/resume and full server-pixel equality. The separate
[list benchmark](crates/gpui/VIRTUAL_LIST.md) first compares every pixel with
independently materialized eager rows; timing never substitutes for that oracle.

Native accessibility tests use the pinned AccessKit Consumer to check tree
replacement/removal, names distinct from edited values, full physical geometry,
live focus, frozen list positions, session cancellation and bounded action
admission. Text-unit tests include multibyte scalars and CRLF; no selection or
glyph-position capability is invented. The actual Linux AT-SPI client activates
after initial P, reads renamed text and its actual content, edits input, invokes
an action and reactivates without forcing a frame. The absent-session-bus case
still presents real CPU content. These prove separate boundaries from UIA and
VoiceOver runtime behavior; see [the native contract](crates/gpui/ACCESSIBILITY.md).
Sparse publication additionally compares its complete Consumer result against
fresh full projection, including 100K entries, clipped logical/P index mismatch,
ordered container children, pending metadata, missed acknowledgements, failed
preparations and synthetic text children. The verifier includes both schema and
transition modules; a schema-only filter cannot substitute for these oracles.

From the repository root, the complete local verifier is:

```sh
python3 reactivity/tools/verify.py --native-x11 --vulkan --native-atspi \
  --atspi-launcher /usr/libexec/at-spi-bus-launcher
```

It requires the actual display, driver and launcher. Every execution gate rejects
a successful filter that ran zero tests. The private AT-SPI helper probes service
readiness; it never changes desktop settings. CI's ordinary native profiles also
compile and test the accessibility schema on Linux, Windows and macOS; scheduled
CI configuration is not evidence that those remote runners have executed.

Choose time, worker delivery and native/resource adapters at application creation.
The native adapter supplies real events/time/completion; demo adapters supply
deterministic equivalents. A virtual-clock advance and admitted user input run
the normal turn barrier and return its Ready/Pending/Fault status. No arbitrary
sleep or hidden force-flush is needed to make synchronous user input observable.
Async tests choose the declared worker/result delivery, rather than replace
handlers with callbacks that bypass admission.

Queries select either source/logical state or the presented semantic sheet.
They resolve typed target/part capabilities and committed role/text/focus/bounds;
a presented query never silently reads private ahead-of-frame layout caches.
Tests can use the same stable part/schema identifiers that a component library
publishes to users. Strings used by a tool protocol resolve to validated typed
descriptors at that boundary, not dynamic mutation in the kernel. Private state
stays private; testing it does not confer a special public inspector capability.

Input simulation goes through production normalization and dispatch. Typed
semantic activation uses the same allowed operation as accessibility; coordinate
input uses the actual presented hit path. Test both where they prove different
things. A test that directly invokes `increment()` proves model behavior, not
click hit testing. No macro is needed for either ordinary model testing or the
production component path.

The compiled [API oracle](crates/api-lab/README.md) demonstrates the current
View/El borrowing and retention surface. State/tree/layout/ownership labs test
their actual public interfaces. They intentionally do not invent a fake
Application facade to make unconnected experiments appear integrated.

## Failure artifacts use existing visitors

On request/failure, stream source data and bounded semantic/scene diagnostics
through production visitors. Include source/logical/presentation versions,
virtual time, admitted input, worker delivery order, origin/gesture tags,
schema/dependency IDs, backend numeric/quality profile and resource readiness.
Trace/provenance storage is optional, cold and byte-bounded. Normal clean frames
do not traverse a snapshot mirror or serialize state.

Persist source state through explicit serde-compatible schemas and an alias graph
for shared entities. Restore remints live capabilities and reconstructs producers
through the same mount/admission path as a cold launch. Serialize a replay trace
of typed accepted operations and environmental inputs; unknown schema/plugin
bytes round-trip under quotas. Non-UTF8 paths, NaNs, opaque bytes, redaction,
font/content versions and migration have declared codecs. JSON is an inspector
format, not proof of universal lossless state serialization.

Source snapshots, deterministic replay, undo and durable occurrence delivery are
different services. Replay requires recorded nondeterminism; undo requires an
inverse/declared domain operation; crash delivery requires journal/ack semantics.
An arbitrary callback that performs I/O cannot acquire these guarantees from a
serialized function address. Save minimized failing traces and their seeds.

## Adversarial correctness gates

| Boundary | Required comparison/adversary |
| --- | --- |
| Source/graph | Full pure recompute; dynamic branch reads, cycle recovery, spurious revisions, exact versus coarse discovery, A→B→A and equality faults |
| Identity | Foreign namespaces, slot/generation exhaustion, remove/reuse, template insertion inside A shifting held sibling B, queued operations and failed remap |
| Sequence/style | List moves across owners/windows with focus; failed adoption; explicit Set(default) versus Reset; later theme changes; override capability/validation |
| Publication | Fault after every source/result/candidate boundary; completion accepted once but preserved for retry; owner panic and Handoff fault/durable policy |
| Input/epochs | Persistent layout fault while field is removed, key/IME continues, capture cancels, pointer/wheel wait, a11y bounds remain coherent; hover geometry feedback |
| Layout | Retained versus cold Cephal, upstream fixtures and old behavior cases; measure dependency changes, child solution revisions, cache eviction, unrounded placement/snapping |
| Coordinates | Independent wide/high-precision reference; deep cancellation, singular/near-singular, tiny support, giant viewport origins, local replacement and tagged region edits |
| Graphics | Full scene/reference repaint; opaque↔translucent/invisible↔visible, clip/filter/backdrop dependencies, area AA, LCD filter noncommutation, CPU/GPU precision envelopes |
| Presentation | Target ages/generations, accumulated damage after skipped packets, exposure/resize/device loss, capacity overflow and full fallback |
| Parallel | Serial equivalence, disjoint output coverage, reordered completions, exact reductions, cancellation and UI latency under saturation |
| Ownership | Full/closed returns same payload, exact-once drops, stalled CPU/GPU/OS releases, no reuse before actual fence, shutdown at each transition |
| Embedding | Negotiated transforms/z-order, guest/webview focus and IME, pointer capture, popup/a11y merge, slow guest, import copy/fence and remount |

Reference paths stay independent and simple: adjacency topology, parent-order
coordinates, cold layout, full graph recomputation, scalar interpolation,
high-precision geometric/coverage integration and full repaint. Randomized traces
exercise real APIs; oracle code does not become an unreported normal-path scan.
Sampled geometry tests supplement interval/math proofs and do not prove a
continuous domain by themselves.

## Compiler and memory-model gates

Compile passing examples and intended-diagnostic failures: borrowed operand
escape, owner mutation while a description is used, internal cursor escape and
both nested frame directions, wrong field/target/value, reader mutation,
cross-thread non-Send state, and page completion while a shared read is live.
Public El has ordinary lifetimes; do not test a nonexistent public frame brand.
Optional derives/macros must preserve visible state, pixels, input/effect/drop
order and declared delta precision with instrumentation disabled.

Loom explores the small new queue/ready/wake composition with weak-memory
payload/cursor ordering. Keep positive models and counterexamples for clear-after,
release-only acknowledgement, acquire-only failed coalescing and hint-after-wake.
Extend to producer hint registration/recycling, terminal close and shutdown before
claiming those properties. The existing finite models do not prove native event
fairness, all queue internals or device synchronization.

Every new production unsafe block needs its local invariant, provenance/alias/
initialization/drop proof, an optimized safe comparison, and Miri/sanitizer/fuzz
fixtures appropriate to the operation. The current first-party library experiments
forbid unsafe; the allocation-counter example has isolated System-forwarding
instrumentation and is not an accepted production allocator. Unavailable unsafe
validation is a failed adoption gate, not an implied waiver.

## Performance and deletion gates

Benchmark complete operations: construction, warm/cold query, marking plus visit,
plan build plus render, command/upload plus GPU/OS completion, and reclaim. Report
payload/capacity/allocator, process RSS/PSS, CPU images and GPU/compositor/guest
bytes separately. Include startup/thread/service allocation, stacks, idle work,
compile time/code size and p50/p95/p99 input-to-present. A steady zero-allocation
queue benchmark does not include the windowing system's memory floor.

Use optimized simple baselines. The coverage spike replaced unnecessary distance
square roots in its point baseline with implicit containment before publishing
results. Record losing regimes: tiny scoped jobs, dense path queries, customized
small templates and boundary-dense certificates. Never select a threshold from
the old M3 lab's embedded verdict text; the committed x86 rerun shows different
crossovers when marking cost is included.

Before claiming an order-of-magnitude simplification, port equivalent features
and count first-party production, dependencies/vendor, tests/examples, generated
code and compatibility islands separately. Before claiming a competitor win,
port equal workloads/features and verify output/quality on at least two hardware
classes. Native GUI, driver and compositor tests require actual target hardware.
Headless compile success does not satisfy those gates.

Delete each old system only after its replacement passes the corresponding
public behavior/platform gates and has no required first-party legacy caller.
Then remove the compatibility island, obsolete types and dependency edges in the
same reviewed slice. These are the tests that make deletion safe; retaining the
entire old implementation as the hidden normal path would defeat the design.
