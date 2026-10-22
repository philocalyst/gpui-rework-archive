# Hidden-only cache allocation elimination

Source63d2327b68 is based on main eb610aaea2. This is a core LayoutTree
Display::None fixture, not a claim about an ordinary public GPUI feature:
GPUI's current public element API does not expose Display::None. No native,
GPU, OS-memory, RSS, startup or CPU-speed result is claimed here.

Cephal's NodeCache already has an8-byte lazy owner handle, but mark_hidden
allocates its360-byte Inner solely to store a bool when a previously cold
nonempty subtree is zeroed. Add two default CacheAccess hooks that delegate
to the existing NodeCache methods. GPUI overrides the hooks using bit0x10 in
its existing flags byte lane. Traversal order, nonempty-container policy and
non-speculative marking remain unchanged. The vendor default-host regression
confirms its cache marker allocation/invalidation and leaf/speculative behavior.

The scheduler reserves low bits0x01/02/04/08 and preserves META_MASK0xF0 for
tree-owned facts. The adapter's query_meta reads StyleTable, not those bits;
verify-cache and diagnostics introduce no competing core flag interpretation.
The spare bit is checked against META_MASK at compile time. This proof is
revoked before every mutable cache exposure and the audited direct bypasses:
cheap-node cache reset, viewport-root clear, OOF ancestor clear, fresh/removed/
reused slots and generation rollover. Existing style/topology edit queues and
scheduler cache invalidation remain authoritative before changed subtrees are
asked again. The audit is included. No new owner/node header, allocation,
unsafe code, retained tree, application knob or dependency was introduced.

Existing warm caches are cleared while retaining their allocations exactly as
before. This slice does not reclaim their payload when a node becomes hidden.
The extra flag write/check on mutable cache paths is real; allocation neutrality
does not establish CPU neutrality. Timing qualification is left to a separately
coordinated control if this source is adopted.

## Frozen actual control and independent oracle

The baseline was built before production edits. Shipping core/layout.rs,
vendor trait/compute/cache sources, provenance and workspace lock were checked
against exact eb610 Git blobs. The new uncommitted test-only fixture and external
driver were pinned separately; this is not presented as a completely clean full
Git checkout. Actual Cargo build JSON, feature sets, executable and core/Cephal
rlibs were frozen. Candidate source equals committed63d2327b68; the same driver,
manifest, lock and fixture bytes are used. Its actual normal-policy build omits
verify-cache. Both frozen executables and rlibs remain at the manifest paths.

The core fixture creates a normal block root with1000 parents, each containing
a leaf. Hidden mode starts the parents at Display::None. Empty, ordinary visible
and initially visible warm-hide modes are independent controls. After every
measured phase, a fresh vendor-owned Tree receives the same declared topology
and styles, computes cold, and must match every Layout. The1000-parent unit
also explicitly checks hidden leaf sizes, visible reveal, moving into another
hidden subtree, removal/reuse and hide/reveal. Existing hidden-sibling authority
regression remains. Private unit tests cover leaf markers, speculation, mutable
revocation and generation rollover clearing a different forest's proof.

Three fresh processes per mode/variant produce24 processes,114 allocation/work
rows. Every pre/post source and executable/rlib guard, cold oracle and work-counter
equality check passes. These are actual ordinary public core APIs, not a private
parallel renderer or hidden test dispatcher. Allocation-counter measures requested
payload and phase net retained/peak-new bytes; allocator headers/RSS and prior
fixture allocations are not included in each phase's peak-new counter.

## Cold hidden compute

Construction allocation rows match exactly. The first hidden compute changes:

| metric | frozen baseline | flag marker | delta |
|---|---:|---:|---:|
| phase retained bytes |647256|287256|-360000|
| total requested bytes |746936|386936|-360000|
| peak new bytes |655576|302720|-352856|
| allocation calls |1036|36|-1000|
| allocated NodeCache inners |1001|1|-1000|
| actual cache heap payload |360360|360|-360000|

The root's real query cache remains; the1000 hidden-marker-only inners disappear.
No nominal handle-size estimate is used as heap accounting. Repeated dirty
recompute has matching allocation/work counters, while cache payload stays lower. Empty and ordinary controls match
every allocation/work row. LayoutTree stays664 bytes in both executables, and
existing lane capacities do not change. No broad app memory result follows from
this deliberately hidden-heavy fixture.

The first capture incorrectly asserted that peak-new must fall by the entire
360000-byte retained/requested reduction. That assertion failed: the actual peak
reduction is352856. Its original script, complete raw rows and traceback are
preserved under peak-assumption-failure. No production change followed; the
complete source-guarded capture was rerun with the measured peak recorded rather
than inferred. Other initial failures are preserved too: an explicit test-module
path was needed, and standalone Cephal features require its own manifest rather
than a workspace -p invocation.

## Deferred first visibility and warm retention

The first reveal now requests360 extra bytes and1 call because a real query
cache is first needed then:2360 bytes/7calls versus2000/6. Hiding that warmed
parent again keeps its allocation; hide-one allocation/work counters match. After move/remove/reuse,
reveal-all requests359280 extra bytes/998 calls (443200/1185 versus83920/187).
The baseline paid those cache allocations earlier while hidden. Its reveal peak
is58752 versus the candidate's368160. This deferred cost is part of the ledger,
not erased by reporting only initial hidden compute. Remaining hidden nodes
continue to avoid their marker-only caches.

The separate initially-visible1000-parent warm-hide fixture has identical
construction, compute, dirty, hide-all and reveal-all rows, including retained,
requested, peak and allocation calls. It retains1001 cache inners/360360 bytes
through hiding, as before. Thus this formulation avoids repeated reveal churn
for already-warm caches; it removes only the hidden-only allocation class.

## Gates and emitted code

The exact frozen source passes43 core release tests under normal policy and43
under cephal/verify-cache (6unit,21layout,13tree,3lifecycle; none ignored).
Strict core release all-target Clippy and package-scoped fmt checks pass.
The full standalone vendor verify-cache suite passes60 tests,15 ignored across
17 groups, including the new default-host test and existing upstream hidden
subtree edit regression. Full logs and ignored names are retained.

The same external driver's linked file grows872 bytes and .text368 bytes.
Section sizes and hashes are included. No inference about speed follows from
this small code-size cost. Vendor provenance records the trait seam, traversal
call-site change and default-host regression; cache equations, allocation size
and upstream Owned policy remain unchanged.

baseline/pins.json and candidate/results.json connect exact sources, actual
features, build artifacts and raw rows. Frozen binaries/rlibs remain under
/tmp/gpui-cephal-hidden-control and /tmp/gpui-cephal-hidden-captures; the failed
peak assumption's raw controls remain separate. SHA256.json covers this evidence
package. Parent main and shared build targets were not edited or used.
