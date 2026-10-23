# Partial caret construction candidate

Shipping source **8d81d28bc4a058786fa2fc7336d2e88e6b686f26**, isolated worktree
`/root/gpui-caret-transaction-sol`, based on the unadopted borrowed control
**81bd9e53b7a18161903dad3816d494ed1afdfce3**. This is an experimental source and
correctness result. Release assembly, complete allocation/owner captures, broad
qualification and coordinated timing are still pending. No adoption or speed
claim is made. Older losing captures remain unchanged in their original archives.

## API and ownership

`CursorGeometry::try_for_each_pair` retains its complete admission preflight,
maximum RTL scratch census, generic `ControlFlow` early exit, and decreasing
request fallback. Its checked admission rejection still invokes zero callbacks.
The immutable layout is reborrowed by the existing shared emission loop.

The distinct, hidden `try_for_each_pair_partial` explicitly permits observable
callbacks before a later `CursorGeometryRestart`. It has no generic accumulator
certificate. Its callback returns `()`: complete admission must drain before the
caller accepts geometry. A decreasing request also restarts. A restart does not
assert InvalidFont; the existing random index remains final admission authority.

Canvas alone provides rollback. `shape_inner` owns local `glyphs` and `details`;
`details.carets` is the local Stop Vec. `append_carets` records its current length
for this paragraph, appends partial results, and remembers nonfinite geometry.
A structural restart truncates to that checkpoint, creates the old index, then
recreates ICU segmentation and emits the indexed result. The deferred geometry
flag is discarded on restart: index rejection remains InvalidFont, ahead of
InvalidGeometry. On a successful stream drain, the remembered geometry error is
returned. On any shape error all unpublished local output drops, and `shape`
resets its reusable Parley layout.

The only TextLayout is assembled after successful local construction. The GPUI
preparation path therefore still sees a complete map only after Ok(TextLayout),
then stages complete candidate C, then installs acknowledged P on exact ACK.
This patch changes no preparation/publication/ACK code or retained layout fields;
old acknowledged P and eligible C are untouched by a failed newer L. A new
whole-owner transcript is pending; this paragraph is a source ownership proof,
not a claim that that capture has already been rerun.

## Shared walk and iterator comparison

The existing borrowed walk is specialized by `const ADMIT`. The atomic caller
uses false after its preflight. Canvas uses true: range bounds/count/order checks
execute in the already-required logical emission walk. This removes the complete
preflight cluster pass, the second per-line source-run mapping, and eager maximum
RTL census from Canvas's admitted stream. The same RTL visual-prefix pass and
source-order emission pass remain. Prefixes still start at the exact line/run
origin and add every f32 advance in visual order. No reverse subtraction,
reassociation, sorting, replacement segmentation or output permutation was added.

The callback consumes borrowed Run/Atom/Grapheme state synchronously inside the
existing cluster cursor. Measured existing types are Run48B, owned Cluster144B,
and cluster iterator272B on x86_64. The cursor272B still exists in this approach.
A straightforward fallible pair iterator built on the public Cluster iterator
would materialize Cluster144B and persist its traversal phase/current owner,
request and line/run state across next calls. A carefully redesigned iterator
could instead own the272B cursor and expose Entry values without Cluster copies;
that is possible, not disproved here. It would require a second resumable
traversal API/state machine. The synchronous form shares the present walk and
endpoint/affinity lowering with the atomic API. This is a source/ownership choice;
current optimized assembly and a runtime comparison are still pending.

No whole output/range/visited Vec was introduced. Ambiguous source ordering,
duplicate/fragmented run identity and oversized source domains request restart.
The index decides whether unusual disjoint/decreasing/empty layouts admit or
reject. The unchanged trusted internal atom/grapheme invariants are a limit:
arbitrary private corruption may still panic, as documented by the earlier
control; checked source admission is not a promise to atomically handle every
possible corrupt private representation.

## Focused evidence

* Fresh isolated Canvas check passed (`check.log`).
* `canvas-oracle.log`: the actual Canvas adapter passes the direct full-bit and
  packed Stop oracle: 94,176 accepted, 41,760 snapped, 11,096 distinct pairs,
  with wrapping, bidi, styled boundaries, spacing, affinities and nonfinite
  geometry. One focused test passed; 66 unrelated tests were filtered.
* `private-focused.log`: 18 custom tests passed, 17 stock tests filtered. Existing
  nine atomic-stream tests remain included. New tests cover396 real producer
  layouts, repeated/decreasing requests, late disjoint-line reordering, late
  empty/disjoint duplicate fragments, empty metrics, source >u32 guard, and
  nonfinite geometry before late OOB/overlap rejection with checkpoint rollback
  and indexed final authority. The malformed rollback sink is in the private
  Parley test, not an invocation of the private Canvas adapter; the complete
  adapter is covered separately by the packed-bit oracle.
* `private-initial-unfiltered.log` is preserved: 30 passed and four unrelated
  stock Cluster tests failed their test_count>5 assertion under the overlay's
  no-system-font configuration. It is not labelled a successful complete vendor
  test run. All seven transaction tests and the existing nine stream tests
  passed in that initial run. The later focused run names its exclusions.
* `prepare.py` reproduces production modules from the immutable source pin using
  the existing fixture, adds separate test modules and only a cfg(test) geometry
  child. `overlay-provenance.json` records prefix/test hashes.
  `tested-overlay-equivalence.json` proves37 Rust files byte-equal between the
  tested overlay and the clean reproduced overlay. No production prefix was
  changed for private tests.

These focused tests do not synthesize reversed Engine character offsets or
allocate >u32 character/line counts. The corresponding guards are preserved
statically; no impossible-memory boundary test is claimed. Private Engine
character arrays cannot be mutated through Parley's safe interface.

## Concrete space and source bills

`state-sizes.log` measures Vec24B, RunSlot8B, Entry16B, Option<Entry>20B,
Option<usize>16B and Restart0B. The two reused Vec headers total48B and inline
single-run slot8B. New Canvas transaction state is one usize checkpoint and one
bool; partial admission uses two usize scalars. These are type/header sizes,
not a summed live stack-frame measurement.

Measured final scratch capacities using the production shared helper:

| Case | RunSlot capacity | RTL f32 capacity | capacity payload bytes |
| --- | ---: | ---: | ---: |
| Empty | 0 | 0 | 0 |
| Tiny sparse requests | 0 | 0 | 0 |
| Unwrapped32KiB LTR sparse requests | 0 | 0 | 0 |
| Unwrapped4500-character RTL sparse requests | 0 | 8192 | 32768 |
| Wrapped many-run mixed sparse requests | 26 | 4 | 224 |

Dynamic RTL growth can increase allocation calls and capacity slack versus the
old exact maximum reservation. Capacity payload is not cumulative requested
allocation bytes, allocator peak, RSS or retained TextLayout space. Those costs
remain to be captured before timing or adoption.

`core-lines.json` and `ast-source-ledger.json` use the existing Syn test-span
helper and Tokei15, retaining macro/conditional ambiguities as charged code.
The six shipping first-party libraries total30,448 non-test code lines,
including18 build-script lines (30432 at81bd). Planner534 vs518, vendor
geometry542 vs476, vendor run362 unchanged and editing mod8 unchanged.
The transaction adds **82 shipping code lines** to81bd:16 first-party and66
vendor. Total authored shipping delta from indexed1d5 is448 lines:28 first-party
and420 vendor. Evidence support is separately charged:76 Python and203 Rust
test code lines. Physical/nonblank counts in `source-ledger.json` include
comments and must not be confused with this AST/Tokei bill.

Release assembly/code size, any const-false result-wrapper impact, scoped/owner
allocations and broad gates remain pending under the root build coordination
hold. No timings have been taken for this candidate.

## Metadata-only RTL reservation review

Source inspection during the build hold found no constant-time exact grapheme
count. `Run::len` calls `count_graphemes`, scanning Character.grapheme_start;
`ShapedCluster::graphemes_overlapped` also scans those flags. In contrast,
`ShapedSlice::characters().len()` is constant time: char_range reads the first
and last shaped-cluster character endpoints. That scalar count safely bounds
prefix entries. `shaped_clusters_range().len()` is constant time too, but is
neither an exact grapheme count nor a safe grapheme upper bound: a ligature can
span multiple graphemes, and Graphemes also supports crossing shaped-cluster
boundaries within one grapheme.

Reserving exactly the scalar count before each RTL run would fit4500 simple
characters into18000B rather than the measured8192 slots/32768B. It would remove
the initial geometric growth allocations on that case. It may overreserve badly
for a large combining sequence embedded in a paragraph with >8 ICU requests;
Canvas's direct tiny-request bypass does not exclude that case. This is a
metadata proof and arithmetic projection, not an executed allocation capture.

A tighter alternative is reserving exactly the shaped-cluster count as an
initial estimate, then allowing Vec growth when ligatures yield more graphemes.
It adds no scan, map, retained field or prefix arithmetic. For simple Hebrew it
could reserve exactly4500 prefixes; for ligatures it can still grow and for
one grapheme spanning many shaped clusters it can overreserve. Thus neither
extent is an exact universal solution. The candidate remains unchanged pending
coordinated evaluation; this note does not present the alternative as measured.

A third alternative counts only RTL Character.grapheme_start flags with the
existing Run::len. This adds a linear Character-array pass on RTL and none on
LTR. It does not rebuild atoms/graphemes, project source ranges, redo checked
range admission or perform the original all-run maximum census. An exact count
avoids the scalar-bound pathology for combining sequences. No separately
emitted count_graphemes/Run::len symbol was found in the old frozen stream-final
binary; scalar versus vectorized generated code remains unproven until a
coordinated release build is allowed.

The count and reservation policy are separate choices. reserve_exact(run.len())
fits the first4500 prefixes into18000B, but may reallocate for every later run
that establishes a new maximum length. reserve(run.len()) also fits an initial
4500-prefix run exactly, prevents allocation growth while emitting that run,
and keeps ordinary geometric reuse across increasing later runs. That can retain
slack after a staircase of increasing run lengths, while avoiding an allocation
for every new maximum. No-reserve, shaped-cluster seed, and RTL-only exact count
remain explicitly distinct alternatives;8d81 stays unchanged as the no-reserve
control. A single successor is pending generated-code/whole-pipeline evaluation.
