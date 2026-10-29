# Semantic emission mapping: captured, exact variety gate FAILED

**No adoption.** Actual producer events now associate existing semantic identities
with Canvas command ranges and old/new support. All30 inherited structural
frames still match CPU, independent fresh-window CPU and full GPU exactly. The
new three-frame text/image fixture fails exact CPU/GPU parity:48 RGB bytes differ
by one level in each frame. Retained and full GPU outputs agree exactly; current
and fresh-window CPU outputs agree exactly. No tolerance, input simplification
or shader change turns this into a pass. The overall gate remains FAILED.

This supplies a concrete mapping and counterexample set, not output reuse,
resource lifetime safety, a GPU publication journal or a performance result.
Ordered cold extents remain unadopted; paint remains NOT ADMITTED
(single1024=1.103170), with A/B verdicts unchanged. No codec tuning, new paint
optimization, shipping adoption or ZGX inference occurs.

## Actual existing emission path

Runtime::present_walk walks logical preorder after layout. It composes the
parent coordinate space, layout translation and style transform, inherits clip
state and may create a scene-local clip. Then one node can emit background or
gradient, selection/composition rectangles, a glyph run, caret and/or image.
Some nodes admit no draw. Canvas numerical/clipping admission may also remove a
requested draw. Omitted presented rows are handled after this emission logic.

The mapping observes DisplayList.order length immediately before the node and
its actual admitted slice afterward. Support is the union of that new slice's
stored bounds; it never scans the preceding command prefix. An ancestor stack
closes logical and command subtree endpoints. Range records are produced here,
not inferred from later snapshots, pixel colors or matching cold records.

Within this synchronous full-paint producer, each node's own command range and
its descendants' union are contiguous in painter order, including empty ranges.
The checker independently enumerates logical ancestry and verifies all spans
against the actual prepared command stream. This is not a claim about arbitrary
future/out-of-order producers or a contiguous self-contained GPU allocation.

GPU preparation iterates groups: an inline draw occupies six16B words; a compact
group uses five common words plus two words per placement. A paint bank precedes
these records; clip/resource metadata follows them. Placements may reference a
common record, paint slot, clip prefix, image or glyph atlas outside their own
range. Thus semantic command addressing does not directly supply a physical
packet byte interval or its dependency/resource closure.

## Identity, version and invalidation

Each24B range record stores existing identity, own start/end, subtree command
end and logical subtree end. Current identity lookup uses the existing
IdentityIndex and then one rank-indexed range record, with identity checks; no
parallel identity registry is introduced. Existing arithmetic/run/sorted-index
lookup complexity remains. Its all-row lookup verification is a post-update
diagnostic walk, not claimed O(1) producer work.

A mapping carries the exact planned PresentationToken and source epoch. It is
built locally and installed only after successful complete scene commit. Failed
newer descriptions retain the old mapping. Lookup into the live logical tree
requires token, complete/source epoch and logical validity to match. Paint/text
paths that change the scene without generating this map decline that check;
this lane does not certify or optimize those paths. Same-token metadata changes
that advance source epoch also decline conservatively.

Current and previous mapping metadata are retained. Old ranges/support describe
old output; their positional indices and ClipIds must never be dereferenced
against a new scene. These values own no Canvas, image, glyph, clip arena or GPU
lease. Diagnostic old/new identity comparison builds temporary analysis tables
outside the producer, explicitly not a reconciliation or journal adapter. The
existing cold correspondence/identity rules and full renderer remain authorities.

## Concrete ranges and escaped dependencies

The mixed fixture has7 logical nodes and9 actual draws initially: two nodes emit
zero draws, three emit multiple draws. Inserting a4px sibling yields8 nodes and10
draws; removal returns7/9. The intentionally wrong one-node/one-command mapping
misaddresses6/7/6 rows. This is a mapping counterexample, not a new GPU mutant.

Initial painter ranges are: root[0,1), empty leaf[1,1), text with background[1,4),
text[4,6), image-row container[6,6), image with background[6,8), second image[8,9).
The image-row subtree is[6,9) despite its empty own range. Four glyph draws share
one mask resource; two image draws share one image. One clip resource is also
present, making three resource entries and96B resource handle capacity. A
single subtree's contiguous command span is not ownership of these shared entries.
Insertion/removal in this unkeyed fixture remints children under existing rules;
the map does not invent stronger semantic survival.

The live keyed256 insertion has269 nodes but only71 admitted draws:198 nodes
emit no draw because of containers or clipping. Its edited logical group is
[2,11), mapping to commands[1,5). The surviving following sibling (identity10)
moves from logical rank9 to11 and from command[4,5) to[5,6). Its support moves
from[7,19,33,29] to[7,27,33,37], outside the edited group. The inherited actual
GPU mutant that repairs only the group still produces326 wrong pixel bytes in
all six insertion cases. Old and new support are both necessary.

Unkeyed reordering preserves every complete cold record, all own command ranges
and the relevant geometry/support, yet changes colors and704 pixel bytes at all
three sizes. Three surviving node outputs change while their ranges stay[1,2),
[2,3),[3,4). Even cold equality plus range/geometry equality is not paint authority.

## Charged construction and storage

The range is24B per node; separately retained diagnostic dependency records are
136B per node. They contain parent rank, full parent coordinate space, resolved
transform, inherited/used Clip capabilities and own support. These are explicit
observability costs, not a selected compact production dependency format. The
Store header is272B and contains current/previous Mapping headers/counters.

Keyed269-node insertion performs269 range/dependency appends and269 stack
pushes/pops,538 cursor reads and71 support-draw visits. It writes8,608B of range
fields (24B initialization plus8B endpoint updates per node) and36,584B of
dependency records. Stack capacity is64B. Current mapping heap is43,040B;
current+previous heap85,760B plus272B Store header. Minimal range columns alone
are12,864B across these two versions; the remaining72,896B is dependency trace.
The current/new mapping plus any two old metadata versions coexist during
installation; for the following removal, their known heap plus stack is128,544B.
These are object/capacity counts, not complete machine-code stack or RSS.

The already-counted raw Node mirror, identity index, correspondence journal,
three fixed-block and three ordered-extent controls still remain. Adding the
mapping makes that counted cold/control/diagnostic subset124,529B for insertion,
versus6,552B original raw Node Vec+lookup. This is actual extra experimental
storage, not a hypothetical replacement or an application memory win.

The complete ordinary Source update allocates581,024B in272 allocations for this
insertion, retaining69,999B more and measuring183,344B peak delta relative to its
starting allocation balance. Existing old state is outside that delta: it is
not a whole-Window or process peak. The scope includes all producer controls and
checks, but excludes post-update JSON, snapshot/scene diagnostics, GPU work and
pixel oracles. Description/reconciliation/index/layout/paint still visit269
nodes. The original GPU still uploads7,992B, validates71 draws and visits486 bins.
No mapping or cold extent is consumed as a GPU update capability.

## Rendering counterexample and failed attempts

The first mixed fixture used a rectangular inherited clip. Canvas validly lowered
it to draw rectangles, so an assertion requiring an explicit ClipChain failed
before pixel comparison. A rounded clip was then used to exercise an explicit
chain; its first compile failed because radius requires an f32 property (4.0).
Both failures are retained. Several attempts stopped at the8GiB disk preflight
before builds; completed local caches and verified duplicate captures were
reclaimed with receipts. Canonical test executables and sealed evidence remain.

The corrected fixture then exposed the48-byte CPU/GPU discrepancy at glyph
positions. The final capture saves all four images before comparison and runs
all three declared frames before the final exact assertion. The assertion still
fails; the driver records FAILED while allowing independent structural and
strict-Clippy checks to finish. This changes failure capture, not the equality
gate. Both GPU routes agree and both CPU routes agree in every mixed frame; the
observed maximum byte delta is1, not an allowed tolerance. No uninstrumented
causal comparison or shader diagnosis has been performed, and the mismatch is
not attributed to retained traversal or to this read-only mapping.

The mapping/range/resource observations remain inspectable despite that failed
rendering qualification. Full preparation remains the oracle; text/image
end-to-end parity and submitted resource lifetime remain open requirements.

## Requirement matrix and next choice

| Requirement | Status | Limit |
|---|---|---|
| Existing semantic identity and contiguous CPU nodes | Existing | Reconciliation/remint and reconstruction limits unchanged |
| Semantic identity to own/subtree command ranges | Implemented producer observation | Exact full-scene/source version only; O(N+D) construction |
| Zero/multiple emissions and painter order | Captured and checked | Command stream, not one physical GPU byte interval |
| Inherited transform/clip and shared-resource references | Captured diagnostics | Not a dependency-closure algorithm or resource ownership certificate |
| Old/new support outside edited subtree | Concrete trace and GPU mutant | Full producer/damage still required |
| Current/previous metadata lifetime | Explicitly retained | No Canvas/GPU/resource leases supplied |
| Local structural/dependency publication journal | Missing | Full description/layout/paint/packet preparation unchanged |
| Compressed tree consumed by GPU / coherent shared memory | Missing | Staged raw renderer remains authoritative |
| Exact text/image four-oracle pixels | FAILED in this fixture |48 differing CPU/GPU bytes per frame; no tolerance |
| Performance / ZGX advantage | Unmeasured here | No timing or adoption claim |

The next representation choice should use this producer seam, not infer output
reuse from cold storage. Renderer packet addresses currently depend on global
paint-bank length, preceding group sizes and clip/resource suffix bases. For
example clips::reference(word_count + bank_words, chain.index()) embeds a suffix
address into each clipped draw; adding an unrelated command can relocate that
reference even when its semantic node/geometry is unchanged. A compact placement
also references the preceding common-record address. Before selecting persistent
GPU extents, distinguish canonical output changes from these address relocations
on the actual live packet, and retain exact predecessor/namespace/resource
interpretation. Alternatively, surviving layout identities and changed-parent
lists could expose the layout dependency closure now paid for by full rebuilds.
Those are executable next hypotheses; neither is implemented or admitted here.
No further paint special case or codec tuning follows this trace.

## Provenance

Protocol6ccdaaec9894559c4604d561244b67229d5ea3a0. Final source3316c2f487ec50dc1cb1945f009c2291c991019c.
Final build, inherited structural fixture, strict Clippy and source/ELF/shader
guards pass; mixed fixture exact gate fails as documented. Source inventory
38,079 versus38,059 parent includes the gated Canvas observer
and conservatively charged conditional test initialization. All Runtime mapping
code is cfg(test). Canvas adds two doc-hidden observer methods behind the
emission-trace development feature; ordinary application APIs and rendering
behavior are unchanged. No default-feature adoption is made.

The preserved final executable is
24a3ca4e872b8e4e6d84d341d4b7c70246cb9ac47198f9749d182f07f4d58b90.
Earlier canonical binaries, Cargo diagnostics, all rejected attempts, cleanup
receipts, frozen sources and complete images are retained. External analysis
checks ranges/support and reports the pixel failure rather than treating it as
success. Run python3 verify.py here to check the sealed evidence. All local.
