# GPUI reactivity through shared structure and typed changes

The proposed clean-room core retains shared structure and the smallest independent
differences. A component instance owns application state, a shared description,
and sparse deviations. Layout solutions, paint recipes and local spatial indexes
can also be shared when their complete inputs agree. Transforms operate on sparse
coordinate spaces. Typed changes drive one production pipeline that inspection,
testing, accessibility and history can all observe.

The important reduction is in what exists: most static primitive instances need
no mutable tree record, no world matrix, no subscription object, no copied style,
and no inspector mirror. Adding a feature should usually add a typed operation or
a projection of existing data. It should not add another tree and scheduler.

This is the architectural proposal. [CONTRACT.md](CONTRACT.md) is the versioned
amendment to the supplied statutes, including construction, commit points,
override precedence and input during presentation failure. [PLAN.md](PLAN.md) contains the source audit,
contract corrections and delivery gates; [EXPERIMENTS.md](EXPERIMENTS.md) contains
the competing formulations. [STATUS.md](STATUS.md) distinguishes executable
experiments from proposed integration. The supplied `final/` documents remain
the public vocabulary authority except for those explicit amendments.
None of the experiments establishes a complete GUI or a competitor
performance win.

[REACTIVITY.md](REACTIVITY.md) specifies source delivery and graph outcomes;
[MEMORY.md](MEMORY.md) accounts the full native/OS/GPU floor;
[TESTING.md](TESTING.md) defines production-path verification and replay.

## The representation

A rendered subtree is a tuple:

```text
shared template
  + instance identity and application owner
  + sparse typed property deviations
  + explicit dynamic-region child runs
  + selected shared layout solution and instance placement
  + sparse coordinate-space and resource leases
```

The same tuple supplies description, layout input, semantic traversal, painting
and inspection. The implementation can use different indexes over it, but those
indexes carry revision keys and are disposable. They do not become independent
authoritative UI models.

Use three stores with different lifetimes:

| Store | Contents | Ownership and reclamation |
| --- | --- | --- |
| Shared immutable definitions | Template topology, property schemas, constant recipes, layout solutions, text/shape geometry, optional static circuit plans | Intern once, borrow locally; bounded shared leases for published sheets and workers; evict only when unleased |
| Source owners and dynamic regions | User structs, independently scheduled entities, List identity/order, occurrence queues, typed commands, worker request authorities | Scope-owned, exclusive mutation; generation-checked capabilities; linear transfer between owners |
| Published presentation | Instance placements, selected solution references, space graph, changed properties, scene spans, hit/a11y resolvers and resource leases | Immutable at publication; one coherent epoch, bounded in-flight versions; reclaim after CPU/OS/GPU readers release |

Per-turn borrowed descriptions and private layout/render scratch are a fourth,
temporary lifetime rather than a retained store. Their bytes cannot appear in a
published packet by accident. The borrow ends before owner mutation, effects,
arena reset or a worker handoff.

## Templates make immutable topology cheap

A template contains fixed structure in preorder, property declarations, constant
operands, route/part descriptions and dynamic-region holes. Its identity includes
a schema version. Property values that depend on an instance live in typed lanes;
they do not make structurally equal templates distinct. Literal payloads can be
interned separately from shape when that saves total bytes.

The topology is immutable, making succinct representation practical where the
original design rejected dynamic succinct trees. Balanced parentheses need two
bits per node before navigation support. The executable template experiment adds
word-level rank/excess summaries and sampled select indexes; it measures roughly
0.625 bytes per node of topology payload, with headers and slack counted
separately. A template is shared across instances, so this navigation cost is
paid once. Parent/child/order traversal for a repeated widget need not be stored
again for every row.

Only dynamic-region boundaries carry editable child runs. A List insertion adds
an item instance to a region sequence; moving a row edits the sequence and its
placement, preserving the row's identity and retained state. The immutable
template is unchanged. A branch that changes fixed shape chooses a new template
revision, reconciled by the specified parent/ordinal/kind law. List remains the
mechanism that preserves identity across reordering.

For highly irregular content, a unique template plus sparse overlays can lose to
a direct compact page. Therefore each region has a representation price:

1. Shared immutable template and defaults for repeated structure.
2. Sparse deviations for fields with few changed instances/nodes.
3. Dense typed field pages when deviations become common.
4. Editable instance/order pages for genuinely dynamic structure.

The transition changes storage only. Target identity, typed properties, event
routes and visible results remain invariant. Use density hysteresis and a byte
budget so mutation near a threshold cannot repeatedly allocate both forms.
Clearing an override returns to the shared default; it is a semantic reset,
not a special style path.

For layered style, retain `Inherit` versus explicit `Set(value)` independently
of value equality. Setting the library default still overrides a different theme.
Only Reset removes that layer's contribution. The unlayered scalar experiment's
equal-default elision cannot implement this style rule by itself.

Template equality is structural after hash filtering. A content hash alone
cannot authorize sharing. Do not serialize Rust function pointers or TypeIds as
template ABI. Persist source state and stable schema identifiers; rebuild runtime
recipes normally. The first implementation interns at mount; compile-time
templates are an optional producer of the same format.

Public El values own description headers and borrow operands; internal lowering
alone uses a generative scratch frame. This preserves the context-free method
signature without assuming a hidden arena. Construction/spill allocation is
priced explicitly in the API experiment and revised contract.

## Identity exists at crossings

An internal NodeAddress is instance identity plus template-local ordinal and
template revision, valid only for that sheet/revision. A retained public Target
instead names a sparse addressed-site slot with generation inside that instance.
The site directory maps it to the current NodeAddress. Only nodes whose identity
crosses a lifetime boundary need a site; ordinary links and on-demand inspector
traversal use validated ephemeral addresses. Instance slots are namespaced and generational; exhausted
generations retire. A removed instance invalidates every target, request, focus
claim and resource residency reference to it. The template can remain shared
after that instance disappears.

Template replacement reconciles parent × child ordinal × kind and remaps surviving
addressed sites before admitting queued operations. A changed preorder number
alone does not revoke a surviving sibling; reusing the same number does not keep
a replaced node alive. Unkeyed structural edits revoke the affected run/suffix
under the child-sequence contract; without an exact edit delta, conservatively
remount that changed run. List slots preserve identities across reorder. A held
focus/capture/worker target either remaps to that same site or gets revocation,
never an unrelated node at the old ordinal. Test insertion inside sibling A that
shifts sibling B's preorder index while B's parent/ordinal/kind still survives.

Do not mint a heap object per Target. Site tables are compact sparse instance
storage with retirement on generation exhaustion. Dynamic List slots use a scope identity
directory and a linear transfer token, permitting a same-turn cross-container
move without allowing two containers to adopt the same item. A failed move
restores ownership. Domain persistence IDs are a separate type and are remapped
on restore; process-local instance numbers never become application database IDs.

The template experiment uses append-only instance numbering to isolate its
representation question. Production recycling, template-schema remapping and
cross-window transfer are explicit subsequent gates, not assumed properties of
that experiment.

## One typed property declaration

A library-owned property declaration supplies its value type, default, allowed
operations, validation, equality/identity policy, merge/reset behavior, phase
impact, and optional serialization/editor metadata. Generate fluent methods,
typed descriptors and inspector protocol information from this single schema.
The renderer consumes packed property lanes; it does not walk reflection objects.

Component libraries publish typed parts and behavior policies through ordinary
Rust module/trait boundaries. A button can expose its label, icon, padding,
activation and interaction policy without exposing private state. A theme can
replace those declared values; a behavior override can wrap the default typed
operation. Reset, composition order and precedence are specified once. Opaque
private internals remain private by Rust's normal visibility rules.

User structs retain plain fields and the storage ladder. They require no UI macro
to render, mutate, test, persist ordinary serializable source data or compose
children. Fine-grained field wiring needs an actual typed field projection.
The compiled `TypedField` experiment demonstrates safe shared/exclusive projectors,
but its arbitrary metadata is not an enforcement proof: two functions can point
to different fields, and a caller can mislabel an impact. Trusted built-in
descriptors come from the single schema. Untrusted custom mutation uses the
conservative owner invalidation path unless its declared contract is accepted.

A manual typed descriptor is the no-macro fine-grained path. An optional data
derive generates the same descriptors and recursive deltas. The design does not
claim automatic Rust field reflection or that a proc macro can resolve arbitrary
type aliases. Actual compilable signatures, diagnostics and branch/lifetime tests
must precede stabilization of the convenience spelling.

## State delivery has explicit prices

An inline `Signal<T>` stores T and a checked four-byte mutation revision. Shared
reads borrow T. `DerefMut` marks before returning `&mut T`; it cannot return a drop
guard. Revisions are local mutation hints, with owner/field incarnation carried
at the binding edge. `Signal<bool>` and `Signal<u32>` occupy eight bytes in the
current experiment. Alignment and wire-table costs are reported separately.

There are three delivery forms:

| Form | Publication discovery | Cost and use |
| --- | --- | --- |
| Arbitrary `fn(&mut Self)` handler | The changed owner is known; compare its wired field revisions through typed descriptors at the turn barrier | O(wired fields in changed owners), no clean-tree scan; preserves GPUI's flexible arbitrary Rust mutation |
| Direct control sink or typed field command | The destination source key is part of the input operation | Enqueue the exact source directly; equality cuts off unchanged destinations; suitable for text edits, slider values and hot scalar commands |
| Explicit source circuit / instrumented projection | Its typed inputs are known, or a read scope records dynamic dependencies | Static circuit update is proportional to affected operators; dynamic form pays read-set replacement and cycle checks |

This removes the missing-carrier assumption. Four bytes inside a movable signal
cannot also refer to an arbitrary runtime queue without a carrier, instrumentation
or scanning. A borrowed `&Signal` cannot become a permanent source path merely by
being mentioned in a view. The ergonomic installation spelling must lower to a
typed owner-relative projector or an explicit stable source capability. No
unchecked retained pointer to a movable/optional/Vec-contained field is accepted.

Similarly, constructing `query.map_async(...)` and then moving both query and
Reader into a struct requires a deferred declaration keyed to a typed source,
or a real stable source allocation. It cannot retain the address of that local
query. A `Settled` reader's ready value also needs a genuine scoped borrow/owned
snapshot; fallback readiness alone does not justify `Deref` across replacement.

Expose the simple owner-grained path first, then typed field operations where
tracking earns its price. Optional compiler assistance expands to those ordinary
operations; it does not unlock an otherwise inaccessible performance tier.

## Reduce the graph by classifying relations

Do not instantiate the same generic reactive node for every relationship.

- A constant has no graph node.
- A direct source-to-property wire is an edge plus a destination compare.
- A fixed-input pure circuit is a compact opcode/typed function in a shared plan,
  with instance-local output slots only where needed.
- A dynamic projection owns a replaceable read set and cached output.
- A sequence operator owns its actual arrangement/index state.
- A worker boundary owns a frozen input pack, request stamp and bounded result.
- An external effect is queued after logical publication, outside the pure graph.

These are the existing port families, lowered to their minimal mechanism. Shared
plans contain static dependency order; only genuinely dynamic edges need runtime
height/cycle maintenance. Common pure subexpressions can share immutable results
when their inputs, environment and equality policy agree. Never deduplicate
closures by code address or forget captures, side effects, owner revocation or
the difference between identity and value equality.

The graph is demand-aware. An offscreen parked region retains source identity
and required semantic state, but can stop maintaining expendable paint/layout
outputs. Reactivation validates input stamps and lazily rebuilds those outputs.
Focus, IME, capture, pending reliable actions, accessibility obligations and exit
transitions are explicit retention reasons. Parking does not silently revoke an
application document or drop an in-flight Handoff.

Use differential operators for List/filter/sort/group/virtualization where deltas
are well-defined. An arbitrary Rust predicate has wildcard dependencies unless
it uses typed field sources; the cost cannot be inferred from its syntax. Full
Differential Dataflow or DBSP is excessive as the default UI kernel, but their
incremental operator algebra is useful for substantial query subsystems.

## Commit source operations and publish outcomes

The following is a deliberate amendment to the original rollback promise. It
removes an unimplementable combination of unrestricted `&mut Self`, inline state,
clone-free mutation and automatic rollback.

One owner invocation runs exclusively. On normal return, its source mutation
commits. An arbitrary handler panic poisons/removes that owner under the specified
fault policy; the framework does not promise to reconstruct its prior T. A
multi-owner atomic edit must be a batch of staged typed operations whose validation
and inverses are defined. Arbitrary callbacks do not become atomic because they
were placed in a transaction object.

Pure downstream computation publishes an outcome at that source epoch:
`Ready(value)`, `Pending(request)` or `Fault(provenance)`. Synchronous derivation,
cycle, equality and budget faults use the same outcome model as asynchronous
Readers. They do not demand rolling back an already-successful arbitrary handler.
A ready consumer is evaluated only from the appropriate admitted input versions;
it cannot mix a new source with a stale ready prerequisite and call the result
current. Boundary policy decides which ready cohort can be presented.

This keeps two externally relevant epochs: a coherent logical outcome epoch and
the most recent coherent presentation. A failed presentation retains the old
sheet while input/source progress continues. Key/focus routing follows current
logical state; coordinate-dependent input waits for presentation recovery.
Unbounded failure cannot retain unbounded old owners or packets. Exhausting a
window's recovery budget enters an explicit diagnosed failure surface.

`changed` runs after logical outcome publication, with a typed precision tier:
exact library delta where an operation knows it; changed-marker/new-value where
only a revision is available; old/new values only where capture or persistence
provides them. Plain fields have no per-field publication identity. Exact
recursive old/new deltas for arbitrary plain fields require snapshots, generated
instrumentation or explicit descriptors, and must not be advertised as free.

Effects queue another owner turn. They never recurse through active state
borrows, compute, layout or presentation. Event bursts observe committed writes
between their specified barriers. Budgeted waves retain causal provenance so a
loop names the participating owners, fields and operations.

## Presentation sheets remove layout rollback

A published sheet owns or leases layout solution references, placements, local
space definitions, selected paint spans, hit/a11y resolvers and resource versions.
All of these describe one presentation epoch. The renderer and input path read
this sheet; they never read a partially-mutated Cephal workspace.

Cephal is a private computation/memo workspace. Compute a candidate sheet from
the latest logical outcomes, then publish the candidate all at once. If layout
fails, retain the old sheet, discard candidate outputs, and invalidate or discard
the touched private caches before retry. The private workspace may be ahead of
the displayed frame; that is safe because it is not the displayed frame's geometry.
This eliminates an inverse-operation journal for a foreign mutable tree.

The cache validity proof is still required: include source/style/children/measure/
environment revisions in the workspace's validity policy, or clear the affected
cache closure. A caught panic poisons an adapter that cannot establish which
answers remain trustworthy. Never keep a partially-written public layout lane and
label it the old committed presentation. The executable Cephal wrapper is the
unrounded serial oracle and currently uses a poison policy.

Workers receive frozen owned input packs, leased immutable pages, or scoped
borrows whose threads join before the borrow ends. Use no Arc when an owned move
or scoped borrow suffices. Cross-turn/cross-thread shared leases can use measured
triomphe variants; they carry request and resource generations. Completion
admission and payload retention must survive candidate retry. Consuming a request
ticket and dropping its result after a failed candidate is a lost update.

## Share layout answers as well as structure

A repeated template under identical constraints and geometry inputs can share an
immutable layout solution. Each instance then stores its placement and selected
solution reference. Hundreds of identical rows can avoid hundreds of copies of
per-primitive computed geometry and Cephal query caches.

The key includes template/schema revision, resolved layout styles, actual measured
content signature, available space and definite-size flags, font/fallback/variation
and shaping revisions, writing direction/mode, device scale/rounding policy,
scrollbar environment, and any inherited parameter the solver can observe.
Omitting text content merely because two strings have equal length is invalid.
Paint-only color/theme changes do not enter the layout key unless they alter a
metric or layout-affecting style. Baseline, min/max-content, inline-object and
measurement dependencies are part of the answer.

Measurement uses typed declared dependencies or an instrumented explicit read
scope. An opaque custom measurement callback is not eligible for cross-instance
shared cache hits without a complete dependency declaration. Child solution IDs,
locale, image/inline-object intrinsic revisions, safe-area/viewport and external
model reads join the key when observed. Equal metrics alone do not authorize
sharing line breaks, hit/cluster maps or semantic content. Semantic text/source
identity remains instance-local even when geometry can share.

Solutions are admitted after full equality/version validation, with small caches
for common width classes and byte-bounded eviction. A unique-content case must
degrade to a direct solution without a large interning tax. Style defaults,
template topology and shaping data remain independently shareable even when the
final layout differs. Layout field changes use Cephal's incremental machinery;
uniform translation/opacity never enters it.

Shared solutions are **unrounded local answers**. Final snapping occurs after
instance placement and device mapping, so absolute fractional device origin is
part of that per-instance output. If snapped answers are shared, their key must
also include that phase. Paint, hit and accessibility consume the same final
geometry policy. A 0.6-wide box at x=0 versus x=0.6 can have different snapped
widths despite identical local layout. Scale/policy alone is not a complete key.

The pinned Cephal types currently cost 288 bytes per distinct Style, 92 per
Layout, and 464 per populated NodeCache before spills. The correctness adapter
uses lazy caches for containers/measured leaves and releases style references.
The destination representation replaces repeated solutions and pools query state;
it must prove retained-versus-cold equality before replacing the oracle.

## Spatial work belongs to local coordinate spaces

Most primitives need a reference to a coordinate space, not a cached world
matrix. Create a space only where a transform, scrolling, clipping/isolation or
surface boundary earns one. Static nodes use template-local geometry. A local
hit index is shared with its geometry solution and remains valid while an ancestor
camera moves. The outer index updates the transformed group support, then maps
the input point into the local shard. It need not rewrite every descendant hitbox.

Paint, input, caret/IME, accessibility, culling and inspection consume the same
space revision. Point inversion and displacement-vector mapping are distinct
operations. Singular spaces have an explicit noninteractive outcome. Overflow or
uncertain numeric support causes conservative damage, never silent disappearance.

The default space forest is small and evaluated in parent order for streamed
painting. Demand queries cache by parent/local revision and published epoch.
Very deep sparse queries may use a dynamic path-product index, evaluated over
spaces rather than all primitives. Dense full-scene traversal uses a stream.
Algorithm selection changes only the work schedule and must preserve its numeric
contract.

The affine link-cut experiment establishes a large sparse-path speed opportunity,
and a numerical rejection case: f64 multiplication/addition is not an associative
monoid. Query-only splay rotations can change a coordinate from zero to one for a
finite cancellation chain. Therefore unrestricted f64 link-cut aggregation is
not admitted to the pixel/input contract. The exact translation specialization
uses fixed subpixels, i64 inputs and i128 aggregates; its bounded node count gives
a proof of exact regrouping. Subtract the viewport origin before float narrowing,
preserving tiny movements at giant virtual scroll offsets. General affine paths
retain a reproducible composition order until a certified error policy is proven.

## Transform queries instead of repeatedly transforming summaries

Keep group/page support in a canonical local frame. For a set K and affine map
`D(x) = A x + t`, its support function obeys:

```text
h(D K, u) = h(K, transpose(A) u) + dot(u, t)
```

This identity uses no inverse and also holds for singular A. It changes the bound
query direction, leaving the source summary intact. Repeated rotations therefore
do not repeatedly inflate an already-inflated AABB.

Use exact four-direction summaries for translations and axis-preserving maps.
For arbitrary affine maps, query a local convex hull or a conservative bounded
support polygon. Hull reduction, quantization, floating-point uncertainty and
filter inflation have explicit outward error budgets. A fixed angular table
does not give exact arbitrary-direction support. Rebuild from source geometry
when the loose-area/error budget is exceeded; conservative group/full damage is
the final fallback. Include support metadata and fallback frequency in memory
and performance reports.

Dynamic region order uses pages in a count/summary tree. Subtree/group ranges can
carry a lazy transform action with ordered tag composition. Before splitting,
inserting, joining or cutting a tagged interval, push or transfer its tag according
to the exact structural semantics. New children inherit the new parent space,
not a historical tag applied to unrelated prior occupants. Preserve-world
reparenting may fail for singular parents; preserve-local reparenting remains
well-defined. A full local-matrix replacement is not always expressible as one
left world delta, so it uses the space forest rather than forcing an inverse.

These mechanisms only remove end-to-end work if packets/backends retain group
transforms, stable local primitives or cached surfaces. A backend that flattens
every primitive's matrix every frame still pays for those primitives. Capabilities
and counters expose that cost instead of hiding it behind an O(log N) tree claim.

## One change pipeline serves ordinary use and tools

A typed operation identifies owner/part/field, input/source epoch, operation
payload, provenance and impact. Direct input, inspector edits, accessibility
actions, test input, accepted worker results and remote commands enter this same
dispatcher after their own capability/serialization checks. They do not get
independent mutation mechanisms.

The operation's precision follows its type: scalar replacement, List splice/move,
text edit, focus claim, surface lease, or arbitrary owner invocation. Coalesce
only operations whose algebra permits it. Replacing a pending scalar value can
be latest-wins; text edits and click/key transitions cannot be silently dropped.
A Handoff transfers owned occurrences through a bounded FIFO and returns the
payload on backpressure. History observes invertible operations and gesture/origin
tags, in a separate library; arbitrary callback closures never enter the journal.

Inspection is a committed visitor over templates, instance overlays, solutions,
spaces, source/route descriptors, requests and leases. The same visitor exposes
semantic tests and accessibility. Debug provenance, trace history and timing live
in cold optional storage with byte budgets. No inspector shadow tree is updated
on every frame. Snapshot serialization streams only when requested.

Persist source data with serde and a graph table that preserves entity aliases.
Serialize typed operation traces for replay, with virtual time, worker delivery
order and schema versions. Remint runtime capabilities on restore. Unknown
plugin records remain byte-preserved behind a recovery surface. Secret/redacted
fields, non-UTF8 data and non-JSON scalar domains need explicit lossless codecs;
JSON is a useful inspection format, not a universal Rust snapshot proof.

## Embedded surfaces share services and negotiate composition

A same-runtime component instance shares templates, text, device, style and
layout services normally. An independent GPUI guest is a versioned surface
endpoint with viewport/scale, ordered input, scene/texture output, damage,
focus/IME, accessibility and resource-release messages. It owns no second host
event loop. Its request/lease generations make unmount and device loss safe.

Native webviews can use native composition or negotiated texture import. Native
child windows often impose stacking/transform constraints; arbitrary transformed
interleaving requires a supported composition path. A surface reports those
capabilities, imported format/color space, synchronization and fallback-copy cost.
GPU sharing is per-device/protocol, not a generic promise. Share host services
where possible and account guest/web process and compositor memory explicitly.

## Graphics and presentation are part of the design

The renderer consumes local recipes, instance patches and space references.
It chooses coverage/evaluation by actual visual class, with bounded caches and
an exact/reference path. Analytic shape coverage, compute vector tiles, glyph
fields and native retained composition are competing implementations of that
contract. Their complete treatment belongs in [GRAPHICS.md](GRAPHICS.md), including
SDF/MSDF limitations, clipping/effects, color, driver transfers and presentation
buffer ownership. A lower scene-update cost is not enough if GPU uploads,
offscreen targets or compositor copies dominate.

Native hosting uses pinned Winit behind an internal callback boundary. Idle waits;
resume/suspend/redraw and IME-sensitive native callbacks obey OS timing. The
windowless floor creates no native event loop, GPU device, font database or pool.
Start workers/services when demanded and share one compatible service/device
across windows. Release backing memory only after its exact CPU/OS/GPU lease ends.

## Parallelism follows immutable boundaries

[CONCURRENCY.md](CONCURRENCY.md) specifies the full phase, page-ownership,
SPSC/ready/wake, weak-memory, fence, cache and scheduling protocols. The
lock-free queue boundary is not a per-node synchronization mechanism.

The event/source owner stays serial and borrows application state exclusively.
Independent pure work uses scoped jobs or owned immutable input packs. Layout
solutions, shape/decoder outputs, tile/effect work and selected space/property
lanes can execute in parallel and merge in deterministic order. A demand-started
pool and a packet submission owner are options above measured grain thresholds,
not unavoidable baseline threads.

Dense per-kind columns make SIMD a consequence of layout: contiguous opcodes,
coverage/span data, animation lanes, dirty masks and fixed-point translations.
Choose task and lane formats before intrinsics. Separate latency and throughput
benchmarks; inspect critical dependency chains, instruction count, memory traffic
and generated assembly. CPU feature dispatch and scalar tails are explicit.
Unsafe is admitted only when its local invariant and product-level gain survive
comparison with optimized safe code, Miri/sanitizers and adversarial traces.

## How formulations are selected

[FORMULATIONS.md](FORMULATIONS.md) derives further complete-work reductions:
implicit virtual positions, alpha-preserving filter pushdown, analytic rectangular
shadows, compatible blur fusion, clip elimination and conditional band damage.
Their admission conditions and reference fallbacks are part of each derivation.

The method follows the useful lesson from [Ben Joffe's modulus study](https://www.benjoffe.com/fast-day-of-week):
derive the actual input domain and algebra, look at generated instructions,
distinguish latency from throughput, and test the complete valid range. A special
range can enable a stronger identity, while widening can remove a correction.
Here the analogous changes are exact translation sums, immutable topology,
local-frame support queries and typed operation classes. Each removes a category
of work under a stated invariant; arbitrary input retains a correct general path.

Every selected mechanism needs both a win and its losing regime recorded.
Template overlays can lose for tiny fully-customized widgets. Link-cut aggregation
loses for dense reads and unrestricted floating-point coherence. Shared layout
solutions can lose for unique metric inputs. GPU fields can lose for tiny hinted
text. A native layer can lose through memory and compositor overhead. The design
uses these distinctions to keep the common representation small and the complete
feature set expressible, with cost visible at the boundary that earns it.

## Acceptance and remaining implementation

The primary integration gates are representation equivalence, coherent epochs,
exact source/target lifetime, retained-versus-cold layout, paint/hit/a11y geometry
agreement, complete damage repair, bounded leases/queues, idle zero work and
production-path semantic tests. Every storage promotion must preserve behavior.
Numerical, borrowing and serialization limits are executable tests, not prose
assumptions. The original feature gates remain required where the explicitly
amended publication semantics do not replace them.

The implementation sequence now follows the representation: shared templates and
typed operations; coherent immutable sheets; shared Cephal solutions and local
indexes; space/group presentation and damage; production input/inspection/test
adapters; text/media/history/guest features; backend selection and measured
parallel/SIMD specializations. The existing mutable tree and Cephal wrapper remain
independent oracles during this build. They are not accumulated into a second
permanent architecture.
