# Presented transform factorization

Base: `619788822bf4f55818007ac596af0d607b4ebb3b`.
Qualified shipping source: `9c1dbdf1e0a8ca15be8624cb68d295db9fcb36b3`.
`raw/source.patch` is the final crate-only diff against that base. No manifests,
lockfiles, dependencies, vendor bytes, public signatures or unsafe code change.
This archive is a separate evidence commit. Main was never edited here.

The retained Presented row shrinks from 80 to 64 bytes, alignment 8. Its former
zero-origin local Rect becomes explicit exact translation plus width/height;
local queries reconstruct +0,+0. Clipped bounds remain independent. The 8-byte
MapBasis stores exact finite diagonal coefficients inline when both off-diagonal
words are +0, otherwise an owner-local direct index or invalid tag. Off-diagonal
-0 remains pooled. This preserves the admitted f32 words without recomposition,
reassociation or stricter affine admission. A 64-byte stride does not assert
64-byte allocation alignment or one-cache-line residency.

General bases share Geometry's existing P/C Vec slots with radii. Private typed
accessors distinguish finite basis records from NaN-tagged radius records; radius
identity retains all 64 bits. A borrowed GeometryView splits the stream once,
then direct basis lookup and radius binary search use their own slices. No
sibling hash/interner, per-node scratch, separate pool header or new runtime
owner field is added. Repeated exact parent coefficients reuse its key. Dense
siblings deliberately append independently.

Candidate records stay local through fallible lowering and partial-C inspector
caption generation. Only successful commit stages them with C rows. An explicit
empty C clears old P storage on ACK; failed lowering and paint KEEP preserve P.
P/C native comparisons carry each row together with its own Bases and compare
decoded coefficient bits. Identical indices in different pools cannot hide a
semantic change. Virtual ancestors still contribute through the unchanged
CoordinateSpace accumulation before publication filtering.

Measured Linux64 carriers (sizeof, not total compiler stack frames):

| Carrier | Base | Final |
| --- | ---: | ---: |
| Presented / Option<Presented> | 80 / 80 | 64 / 64 |
| Prepared / Option<Prepared> | 40 / 40 | 40 / 40 |
| Runtime<()> no-default / native | 1824 / 1840 | 1824 / 1840 |
| Metadata / Geometry | 264 / 96 | 264 / 96 |
| Query Context, no-default | 96 | 112 |
| Query Context, native | not separately probed | 128 |
| Part | 16 | 16 |

Final Placement16, MapBasis8, Record16, Bases16 and GeometryView24. Native
RowView and Option<RowView> are each24; ComparedRows is48. The query carrier
adds16 borrowed bytes versus the actual base probe. The row has63 field bytes
and1 padding byte. The earlier4-byte control also had64-byte rows but retained
scale resolution and created a pool for custom diagonal transforms. Its exact
source and allocation evidence remain in `../four-byte-baseline/`.

Allocation-counter cohorts use ordinary acknowledged recording windows, warmed
TLS scratch and the same fixture on the base,4-byte control and final source.
`allocations.json` contains all32 matched cohorts and exact source pins. These
are requested Rust bytes, not usable size, native allocations, RSS or timings.

| Cohort | Final retained delta | Requested delta | Allocation requests delta |
| --- | ---: | ---: | ---: |
| 1025 plain, named, rounded or diagonal rows | -16,400 | -16,400 | 0 |
| 1025 inherited/sparse general rows | -15,976 | -15,976 | +3 |
| One general-transform-only row | +408 | +408 | +3 |
| 1024 general siblings / unique bases, 1025 rows | +344 | +16,664 | +11 |

The tiny general case creates Metadata264 + Geometry96 + initial64-byte record
capacity, less16 row bytes. A modeled optional sidecar would save40 header bytes
for this cold case but adds8 to every Metadata and48 to rounded Geometry; it was
not selected. A one-row diagonal instead saves16 with no new owner. The4-byte
control regresses408 for that same diagonal. Dense general records consume row
savings and Vec growth adds work; no universal memory or speed win is claimed.
The clipped/virtual fixture has9 logical rows,5 published rows,2 bases,2 published
radii and capacity6 (96 bytes). Freeze still reserves for all4 logical radii
before filtering: omitted-radius capacity is explicitly retained and charged.

Qualification, all on frozen9c source:

- Default/full gpui: 500 passed,8 ignored across49 groups.
- Desktop x11+wayland+parallel native library: 201 passed,25 ignored.
- Exact no-default basis/layout/allocation rerun:13 passed.
- Native all-target Clippy with `-D warnings`: passed.
- Apple aarch64 and Windows x86_64 MSVC desktop+parallel all-target checks:
  passed, using build-std; compilation only, no foreign runtime claim.
- Actual private Xvfb/dbus Linux AT-SPI: late service/owner replacement/destroy
  and checkbox action/state/event tests each passed. They include text extent,
  hit, UTF-8 selection/editing and stale-owner behavior through ordinary APIs.

Public API lifecycle tests cover old P queries while C exists, P/C scale
changes, stale ACK rejection, failed L preserving C, empty-C clearing, typed
paint KEEP and a finite child beneath an unavailable parent map. Exact codec
checks cover signed zeros, subnormals, full identities and epoch-local keys.
The native oracle compares sparse updates with a fresh full Consumer tree for
same-index/different-basis maps with equal bounds. Existing transform, scroll,
text, inspector, late-AT and100k-row tests are included in the full gates.

All Cargo gates source `/tmp/gpui-native-env.sh`, use offline+locked, two jobs,
and `/tmp/gpui-presented-basis-target`. `commands.sh` records exact commands;
raw logs and machine totals are adjacent. Linux native runtime uses the existing
ReferenceCpu path/llvmpipe and private Xvfb, not a hardware GPU claim. No timing
or startup result is inferred. The frozen native debug test executable is
716,049,416 bytes, SHA-256
`5a574b88676f3da694db360ecea6ad5ecb6485d9b2d0cf1c0092abbaafe0241b`;
this identifies a test artifact, not shipping executable size. Native test hash
and path are in `raw/native-executable.json`.

The six-library shipping count is30,007→30,216 (+209), build-script count stays18.
All changed crate Rust adds1,196 code lines:209 shipping and987 tests/fixtures/
ledgers. No vendor or dependency increment. `source-bill.json` and the three
build-script-aware source inventories identify the counting tools and exact
pins. The final total includes strict-lint and typed comparison-boundary fixes;
the initial8-byte codec alone reduced16 shipping lines from the4-byte control.
Evidence and tools are separately excluded from shipping, not free work.

`codegen/` is a separately charged23-code-line wrapper plus an exact contiguous
excerpt of frozen geometry.rs. Optimized x86 and Apple aarch64 assembly show the
inline reader's tag branches, pooled bounds check and bit loads/stores; no pool
allocation is introduced by decoding. This selected reader is not an app speed
or whole-stack proof. The commands compile unchanged core source to optimized
rlib, then emit wrapper assembly; the A64 std metadata came from the qualified
cross build. Input hashes and output assembly are archived. The unused excerpt
items produce expected dead-code warnings in this small fixture.

Earlier strict failures and an Xvfb launch failure remain in `diagnostics/` with
their earlier source pins. They are not final-source failures: iterator lint
and comparison arguments were fixed before9c; the background X server had exited
with its shell and final tests use a held foreground server. No failed gate is
silently attributed to a successful source pin. No further source edit followed
final qualification. `SHA256SUMS` covers all evidence files except itself.
