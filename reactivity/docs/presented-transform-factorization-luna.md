# Presented transform factorization: pinned-source audit

**Integration disposition.** Supplied report SHA-256 `049c01ea143a38c95dbb81ba3f52c875078bd5473c47f5870126450e30848a72`. Root reviewed the full pinned-source audit. The isolated Sol successor is not adopted or measured yet. Beyond this report, root proposed reusing Geometry's existing P/C Vec owners: private 16-byte records hold a finite-basis prefix and a sorted radius suffix with a reserved NaN marker, exact radius bits and full 64-bit identity. One borrowed split selects typed slices; no extra retained field or separate box is needed. This is still a hypothesis requiring source/lifecycle proofs and measured custom-only/dense-owner costs. Keep logical radius state typed and unchanged. The 64-byte row is a target, not a measured result. Historical alternatives below retain their original proposed header costs.

## Finding

At the audited shipping pin, every Presented row receives a local rectangle constructed as Rect::new(0, 0, layout.width, layout.height). Its first two f32 words are always positive zero. The full admitted affine map is stored separately, including its translation. Therefore those two local-origin words can store the exact map translation if the private row field is renamed and every API reconstructs the old zero-origin rectangle.

A candidate row can store the exact four linear coefficients once in a cold basis pool and carry a 32-bit key. Key 0 represents the exact DPI basis [scale, +0, +0, scale]; u32::MAX represents no admitted map; other keys index exact four-f32 bases. A private carrier tx, ty, width, height is 16 B, so replacing Rect (16 B) plus PresentedTransform/Affine (24 B) with that carrier plus a key (4 B) saves 20 raw bytes per row. The pinned 64-bit Presented is 80 B; a 64 B replacement is plausible after alignment, but requires an actual size_of measurement and should not be promised from arithmetic alone.

This is a storage candidate, not an end-to-end performance result. It leaves clipped bounds, links, identity, text lease, action bits, and candidate affine composition unchanged. It reduces storage only when the pool is sparse; a dense pool of distinct bases can consume the row savings. Query paths gain a key branch and basis reconstruction. No build, measurement, or checkout edit was performed.

## Pin and source provenance

The first-party source audited is commit ebfdb2ad459ab8d9801c295718c83f3bab563392, tree 43b97ea15a5baf7a8763e6c1b1bd423a54c7b866, in /root/gpui-acknowledged-text-geometry. The checked-out HEAD was 866e612d912c0e0e1a022552617acd3880ee9eb2, so reads used git show with the full pin, for example:

    git -C /root/gpui-acknowledged-text-geometry show ebfdb2ad459ab8d9801c295718c83f3bab563392:reactivity/crates/gpui/src/runtime.rs

Corresponding pinned reads covered query.rs, scroll.rs, geometry.rs, metadata.rs, accessibility.rs, inspector.rs, editing.rs, list.rs, text_geometry.rs, paint.rs, and style_ledger.rs. These commands read Git objects at the pin; the current worktree was not retagged or modified. git status --short was empty before work.

The pin’s reactivity/STATUS.md:46–52 records Presented as 80 B on 64-bit and cautions that this is a retained-layout measurement, not whole-window memory. Existing production-gaps-luna.md and frontier-research.md were read first. They include broader transform/scene directions; this memo narrows the question to the existing acknowledged per-row representation and does not treat a general transform-propagation proposal as evidence for this change.

Pinned first-party sources:

- [runtime.rs at ebfdb2, transform sentinel and row types](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/gpui/src/runtime.rs#L334-L350) and [Presented row](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/gpui/src/runtime.rs#L701-L715)
- [present_inner composition and origin-only rect](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/gpui/src/runtime.rs#L2674-L2694), [sole Presented construction](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/gpui/src/runtime.rs#L2928-L2945)
- [query geometry API and hit path](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/gpui/src/runtime/query.rs#L326-L343), [P hit testing](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/gpui/src/runtime/query.rs#L632-L670)
- [P acknowledgement and scale swap](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/gpui/src/runtime.rs#L2377-L2408), [KEEP row preservation](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/gpui/src/runtime/paint.rs#L139-L154)
- [cold Geometry P/C owner](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/gpui/src/runtime/geometry.rs#L6-L45), [Metadata owner](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/gpui/src/runtime/metadata.rs#L192-L232)

## Direct invariant audit

There is one construction site for Presented at runtime.rs:2928. Immediately before it, runtime.rs:2694 builds the local rect with literal zero origin and current layout width/height. Runtime.rs:2685–2693 composes the candidate map in f64, narrows six coefficients to f32, and admits the map only if both the wider space and f32 Affine are finite and invertible. The local rect and transform are independent stored values: rect.x/y are zero, while map.tx/ty carry transformed position.

All direct node.rect reads at the pin were enumerated with git grep:

- Size-only: click center reads width/height (runtime.rs:1183–1190); frozen list/scroll viewport info reads width/height (runtime/scroll.rs:150–167). These can read PresentedGeometry.width/height directly.
- Local rectangle: public Part.local_bounds (runtime/query.rs:326–328), unclipped bounds (339–342), accessibility text viewport clipping (223–235), normal/rounded hit tests (632–648), ancestor viewport hit clips (657–668), and scroll-into-view bounds (runtime/scroll.rs:790–802). Each must call local_rect(), returning Rect::new(0,0,width,height). Passing the encoded carrier as a Rect is incorrect.
- Accessibility sparse comparison: rect_bits(previous.rect), rect_bits(next.rect), and exact map_bits comparison (runtime/accessibility.rs:193–194). Compare reconstructed local rectangle bits and decoded affine bits, never raw key IDs. P and C may assign different IDs to identical bases.
- Transform reads: click (runtime.rs:1184), diagnostic snapshot (1307–1310), Part transform/bounds and hit paths (runtime/query.rs:230–235, 332–343, 642–666), accessibility viewport lookup (query.rs:523–540), wheel/scroll-into-view planning (runtime/scroll.rs:521, 568, 794–798), input selection (runtime/editing.rs:359–367), and style-ledger test probe (runtime/style_ledger.rs:95–109). Resolve the correct epoch’s key before using the map.
- Candidate inspector: DisplayCaptions::refresh reads a partially built candidate slice (runtime/inspector.rs:519–546), invoked at runtime.rs:2647–2653. It needs the C scale and C basis pool, not the P resolver. It runs before candidate rows and their basis pool are finalized.
- Native/accessibility projection uses borrowed Part/semantic APIs rather than exposing Presented. TextGeometry calls Part.transform and then applies its content origin (runtime/text_geometry.rs:33–57), so it inherits the resolver. The public/native API can stay unchanged.
- Paint, clipping, bounds generation, and scroll-space composition run before row packing with the transient full candidate Affine. They do not need to decode a stored basis. Clipped bounds cannot replace map translation: viewport/list/scroll clipping changes bounds while the retained transform remains the unclipped node-to-window map.

The invariant holds for admitted and invalid rows because the sole constructor sets both literal zeros. Invalid maps become None through the NaN-Affine sentinel (runtime.rs:334–349); their key can be invalid and tx/ty can be +0 because no public map is returned. Keep local width/height bits unchanged, including empty or unusual dimensions.

Existing map tests require exact coefficient bits, including negative zero and extreme finite translations (runtime.rs:443–465). Basis comparisons must use to_bits for all four coefficients. A map with off-diagonal -0 is not the common DPI basis. Copy translation tx/ty as raw f32 values with no arithmetic or normalization. The invalid sentinel must not overlap a pool index.

## Concrete encoding and ownership trace

Use a private carrier with semantic field names:

- PresentedGeometry: tx, ty, width, height, all f32; local_rect() reconstructs origin +0,+0.
- TransformKey: u32. Reserve 0 for the exact common basis at this sheet’s scale; reserve u32::MAX for unavailable; use 1..N for exact pool entries.
- TransformBases: P Vec<[f32;4]> and optional C Vec<[f32;4]>. Each entry stores [a,b,c,d] exactly; no translation, quantization, f16, matrix multiplication, or recomposition is stored.

The resolver takes the row carrier, key, exact sheet scale, and basis pool. Key 0 returns [scale,+0,+0,scale]; u32::MAX returns None; other keys load exact coefficients. It constructs Affine {a,b,c,d,tx,ty} without arithmetic on tx/ty. The common-key classifier compares the candidate’s four coefficient bit patterns with [scale,+0,+0,scale]. A valid candidate that differs uses the pool or a proven reusable parent key. Existing scale validation requires finite positive scale; use the scale belonging to the represented P or C sheet.

Candidate composition and Canvas use stay unchanged. Immediately before pushing a visible Presented row, pack tx/ty and dimensions and select the key. Default and invalid rows need no pool entry. For a non-default basis, the first no-hash slice can reuse the nearest already-published parent’s key only after resolving that candidate parent key and proving all four basis bits equal. With virtualization, published[parent] can point to a farther visible ancestor because an intervening virtual row was omitted (runtime.rs:2887–2906); never copy the key blindly. Otherwise append the exact current basis. Translation-only scroll changes tx/ty while reusing the unchanged basis key.

Key meanings are local to pool/scale epoch. P Context borrows the P basis pool and Runtime.presentation_scale_factor. The candidate inspector uses C rows, C pool, and requested scale. Successful non-KEEP acknowledgement installs Prepared.nodes, candidate basis pool, and scale as one coherent P epoch. KEEP preserves rows, P pool, and P scale. Failed C cannot mutate P. If C has no custom bases after P had them, commit an explicit empty pool on row ACK to clear P; None means no candidate, not an empty candidate. Keep candidate pool local until the same final preparation boundary as rows, then commit them together.

The pool can live in the existing optional Geometry P/C owner (runtime/geometry.rs:6–45), which already freezes sparse rounded geometry and is removed only by Geometry::unused. Add bases to its unused/acknowledge logic. A cold alternative is Metadata with an optional Box<TransformBases>: this adds one pointer to Metadata owners, while the boxed pool and its two Vec headers exist only when non-default bases occur. These choices trade a common per-owner header against an extra rare box; prevalence is unknown. Extending Geometry is the simplest lifecycle fit and avoids a new owner layer, but adds two nominal 24-byte Vec headers (about 48 B on 64-bit) to every Geometry owner, including rounded-only owners with no custom transforms. A Metadata sidecar adds about 8 B per Metadata owner and another cold allocation when needed. Measure both owner cohorts before choosing. Do not put a basis field or pointer in each Presented row.

Geometry currently separates mutable logical/current and frozen P/C values. The basis pool belongs only to P/C. Do not borrow mutable styles or L state. Queries borrow the P pool under the existing Runtime borrow; candidate values are owned before P publication. Text-geometry maps have their own ownership and are not removed by this proposal.

MAX_NODES is constrained below 1<<17 by PresentedLink (runtime.rs:679–700), leaving ample u32 room after reserving zero and u32::MAX. Still use checked conversions and test the boundary. No per-row hash, Arc, shared ownership counter, or second semantic tree is needed. Grow the vector only for explicit non-default basis records; do not preallocate one entry per logical node, which would spend 16N bytes on the common default case.

## P/C lifecycle and adversarial cases

The design is correct only if it survives these cases:

1. P at scale 1.0, failed C at scale 2.0: P key 0 still decodes with scale 1.0; requested scale and unfinished C pool cannot leak into P Context.
2. Successful C at a different scale then ACK: rows, C pool, and C scale move together; key 0 now resolves with the new scale.
3. Prepared::KEEP after a paint/damage-only transition: paint.rs:139–154 selects acknowledged rows. Keep old P pool and scale; do not commit a stale/empty C pool.
4. Candidate has no custom bases after P used one: candidate must commit an empty pool on row ACK. An absent candidate pool cannot mean both “no transform changed” and “clear pool.”
5. Error/panic during Canvas recording or candidate geometry processing: drop local C pool, retain P rows/pool. Add a late failure injection before row publication to prove there is no half-installed candidate owner.
6. Virtual list rows omitted: a visible child can derive from logical ancestors absent from P. Reuse only an exact basis key from a published row; otherwise append. Child map comes from existing complete spaces, not the visible parent’s matrix.
7. Same basis at different P/C indices: accessibility compares decoded coefficient bits, not keys.
8. Signed zero: -0 in b/c stays distinct from +0 for exact equality and default classification; -0 tx/ty returns unchanged from Part.transform. Preserve the existing signed-zero fixture.
9. Invalid transform sentinel: it is not a pool index; queries return None, local bounds preserve size, and hit/scroll still reject it.
10. Clip/scroll changes: scrolling changes translation while basis may stay fixed. Clip bounds change separately; never infer tx/ty from node.bounds.
11. Singular/overflow composition followed by a child style scale: classify each row from its own candidate admission. An invalid parent key cannot be inherited by a later finite/invertible child.
12. Parent-chain reuse: copy a key only when child basis bits equal that candidate key under the C resolver. For an omitted parent, the nearest visible ancestor is only a comparison candidate.
13. Inspector during presentation: it exposes C transform before C is fully prepared; a P resolver would show stale data after scale/style changes.
14. Native/accessibility conversion: public Part returns reconstructed data for one coherent P borrow; no key or pool pointer escapes the borrow.
15. Repeated failure and KEEP: P stays readable after logical L changes, C errors, native present failure, and damage-only tokens. Pool lifetime follows the same ACK/revocation boundary as rows.

## Size and work model

Let R be retained P plus pending C row capacities, and B be P plus C basis capacities. Current row storage is 80R bytes at the pin. If the replacement row measures S bytes, row saving is (80-S)R; basis storage adds 16B plus owner/header and allocator costs. If S measures 64, the ideal sparse-pool delta is 16R - 16B before other costs. Direct Vec fields on Geometry add about 48 B per live Geometry owner on 64-bit. An optional boxed Metadata sidecar costs about 8 B per Metadata owner plus its TransformBases allocation, both Vec headers, and allocator bookkeeping for owners that use it. These are accounting formulas, not measurements.

If every row has a distinct non-default basis and B approaches R, a 64-byte row plus a 16-byte basis per row is roughly the original 80 bytes before extra headers. During a pending transition, charge both P and C capacities. Parent-key reuse reduces B only for exact repeated subtrees; this is not a general deduplicating dictionary. Repeated non-default sibling transforms can append duplicate bases because no hash or cross-branch interning is proposed. That is a required memory negative control.

Uniform identity/DPI trees use only key 0, so B is zero and the pool need not allocate. Tiny trees may lose to a new cold-owner allocation despite row shrinkage. Report no-Metadata uniform trees, existing Metadata, rounded-only Geometry, and explicit-transform owners. Charge default headers, Vec capacity growth, boxes, and peak P+C state.

The work eliminated is only retained per-row repeated basis storage. Coordinate composition, Canvas transforms, hit/bounds math, and f64-to-f32 narrowing remain. Added work is key selection on row emission, exact parent-key resolve/compare, map reconstruction at consumers, and possible pool pointer chasing. No speedup is predicted. Measure row size/capacity, process allocation peaks, construction, query/hit/scroll/accessibility time, and x86_64/AArch64 optimized assembly. Do not assume the common resolver branch is cheap.

## Primary precedent and limits

Vello’s research scene encoding uses compact path, draw, transform, and resource buffers; its PathTag has a transform marker, while PathMonoid and PathBbox carry transform-stream indices. This is a primary-source example of indexed transform storage, not evidence that the GPUI pool is free or fast: Vello’s compute scene is not a semantic or hit-test tree. See [Vello architecture at pinned commit 65338c258f091883c6ab99b4e9b7d2b47caafb4a](https://github.com/linebender/vello/blob/65338c258f091883c6ab99b4e9b7d2b47caafb4a/ARCHITECTURE.md#L208-L226) and [its transform marker/index fields](https://github.com/linebender/vello/blob/65338c258f091883c6ab99b4e9b7d2b47caafb4a/research/vello_encoding/src/path.rs#L2397-L2400).

Bevy provides a useful contrast: Transform is local to a parent and GlobalTransform is propagated in PostUpdate. That is a different update/query contract, not a representation recommendation for GPUI’s immutable acknowledged P sheet. See [Bevy Transform source at pinned commit 84e2d2cc5adaeff7547e44f434a0d0d7a20345b8](https://github.com/bevyengine/bevy/blob/84e2d2cc5adaeff7547e44f434a0d0d7a20345b8/crates/bevy_transform/src/components/transform.rs#L1655-L1699).

## Bounded next slice

Proceed only as a storage prototype:

1. Introduce PresentedGeometry + TransformKey and an exact pool owned by the existing P/C lifecycle. Keep candidate full Affine composition and Canvas behavior unchanged.
2. Cover default basis, invalid sentinel, and exact pool entry. Differential-test every map coefficient/translation bit against the current PresentedTransform oracle, including signed zero, extreme finite values, singular/overflow, and scale changes.
3. Convert direct P consumers and candidate inspector, preserving local_rect and clipped-bound semantics. Keep Context borrow-only.
4. Test failed C, ACK scale swap, KEEP, stale P queries, omitted virtual parents, and C pool clearing.
5. Measure size_of, retained capacities, P+C peak, and allocations for uniform no-Metadata trees, existing Metadata, rounded-only Geometry, sparse explicit maps, repeated sibling maps, translation-only scroll subtrees, and one unique basis per row. Differential-test public semantics and inspect x86_64/AArch64 assembly for hot default query/hit paths.
6. Compare Geometry extension to optional Metadata sidecar on those cohorts. Stop if pool/header costs dominate or hit/query regression is material.

The row-origin invariant is proven at this pin. The representation is exact if it uses bit-preserving transport and epoch-qualified pools. Net memory and query-cost value remain unmeasured and workload-dependent.

