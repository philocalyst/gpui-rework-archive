# Second pass: rounded coverage enclosure and exact scene reuse witness

Read-only follow-on to [`coverage-algebra.md`](coverage-algebra.md), candidate `a81bc7536b002b1f81e1b36137c1c4de543e2204`, checked 2026-10-23. No source edits, builds, or tests.

## Correction: prove the old floating predicate, not only the ideal geometry

The first note described the real-valued half-plane implication correctly but left the rounded implication underspecified. The implementable proof below makes the target explicit:

> If `certify_visited_bounds` returns true, then for every tile emitted by the existing `visit`, the existing `full_tile(draw, error, tile, ...)` returns true under the same process/compiler arithmetic model.

This proves an implication to the old implementation, including its rounded comparisons. It does not assert that either implementation is a perfect oracle for GPU execution.

### Operation model and conservative fallback

Use only ordinary Rust float operators; do not mark this kernel with `algebraic_*`, fast-math, reassociation, or approximate-math attributes. Rust documents `f64` as IEEE binary64, and documents `next_up` / `next_down` as IEEE nextUp/nextDown (stable since 1.86). `mul_add` has a separate explicit fused contract, so the interval derivation below also bounds a fused multiply-add as one of the allowed evaluation paths. [Rust `f64` reference](https://doc.rust-lang.org/std/primitive.f64.html)

Use directed endpoints implemented as `rounded.next_down()` / `rounded.next_up()` after each finite operation. If the workspace MSRV predates 1.86, the equivalent bit-step helper is straightforward, but must handle signed zero, both infinities, and NaN exactly as documented there. For a computation that could overflow, become NaN, or enter an uncertain subnormal intermediate, return `false` and fall back to `full_tile` per tile. Never clamp or saturate an interval endpoint.

For a finite rounded operation `z = fl(x op y)`, one adjacent representable value below/above `z` encloses the exact operation result under round-to-nearest binary64. That gives outward interval primitives:

```
add([a,b], [c,d]) = [down(a+c), up(b+d)]
sub([a,b], [c,d]) = [down(a-d), up(b-c)]
mul(I,J) = [down(min(ac,ad,bc,bd)), up(max(ac,ad,bc,bd))]
```

The `mul` endpoints are computed for all four products and each product is itself expanded outward before min/max. Every intermediate and endpoint must be finite. Exact-zero cases can return `[0,0]` when the operation is provably exact (e.g. zero times a finite value or adding zero); otherwise apply the outward step. A produced zero from nonzero operands is ambiguous under underflow and rejects.

**Subnormals:** ordinary IEEE gradual underflow still rounds subnormal results to nearest; expanding by one representable neighbor encloses it. However, some execution modes flush subnormal operands/results to zero. The safe simple policy for this filter is to reject any calculation whose input or intermediate interval intersects `(-f64::MIN_POSITIVE, f64::MIN_POSITIVE)`, except the exact singleton `[0,0]`. Also reject nonzero subnormal f64 inverse coefficients before using them. Check all intermediate boxes in the dot and margin expression, including the first two-product sum where cancellation can occur. This may decline transforms whose later final edge is far from zero; false negatives are harmless. It avoids silently assuming that an FTZ mode behaves like gradual underflow. Rust's type docs describe f64 as binary64; IEEE interval standards require outward enclosure and define exception conditions [IEEE 1788-2015](https://standards.ieee.org/ieee/1788/4431/). The `gamma_n` model and error bound are the standard forward-error analysis for a sequence of rounded operations; Higham develops this notation and inner-product bounds from the operation-by-operation model in *Accuracy and Stability of Numerical Algorithms*, chs. 2–3 [SIAM chapter 1](https://epubs.siam.org/doi/10.1137/1.9780898718027.ch1), [SIAM chapter 3](https://epubs.siam.org/doi/abs/10.1137/1.9780898718027.ch3).

The shader can independently flush f32 subnormals. That does not weaken this implication: the old `full_tile` already tries to keep the packed-high shader path outside its error/correction envelope. The certificate below only proves that the CPU `full_tile` inequalities pass for all its sample corners, so it preserves exactly the authority the existing renderer already uses.

### Global box and intervals

Derive `[L,T,R,B]` from the same integer casts and inclusive tile loops in `visit`, as in the first note. Set exact dyadic endpoints

```
X = [L + 1/8, R - 1/8]
Y = [T + 1/8, B - 1/8].
```

These are exactly representable binary64 values. Every sample corner passed to old `full_tile` lies in `X × Y`.

For one local axis, let `(a,b,c)` be `(inverse[i], inverse[i+2], inverse[i+4])`, `o=origin`, `e=extent`. Packed uses the same tuple after `high[k] = f64::from(inverse[k] as f32)`. Construct an outward enclosure of the exact affine range:

```
P_exact = a*X + b*Y + c - o
```

by directed interval operations. Bound evaluation error separately. With `u=2^-53` and `gamma_5 = (5u)/(1-5u)`, the source expression has at most five binary64 roundings (two products plus three additions/subtractions); any contracted FMA uses fewer. While all intermediates are normal or exact zero, standard floating-point error analysis bounds the absolute difference from the exact affine result by `gamma_5*S`, where

```
S = |a|*maxabs(X) + |b|*maxabs(Y) + |c| + |o|.
```

Compute an outward upper endpoint `S_hi` from those nonnegative terms and set `E = up(gamma_5*S_hi)`. Then the value that the old Rust expression computes at any `(x,y)` in the box is enclosed by

```
P_old = [down(P_exact.lo - E), up(P_exact.hi + E)].
```

This bound covers every interior `(x,y)`, including the points between tile sample corners. It therefore covers each old `full_tile` rounded `packed` or `canonical` value, even if cancellation changes the low bits. The `gamma_5` bound, rather than an assumption that the rounded affine function is exactly linear, is the key excess term.

To handle compiler contraction, derive this bound for the ordinary left-associated expression and include the only source-local contraction site (`a*x + b*y`) as an FMA case. The same `gamma_5*S` bound is valid because an FMA removes an intermediate rounding. Fast-math reassociation is outside the certificate contract; compile this function under the same strict mode as the old predicate. If build configuration cannot rule that out, enumerate every reassociated tree the build can emit or return false for the global path.

The old `full_tile` margin is also rounded. For either packed or canonical arithmetic, define the exact nonnegative magnitude expression

```
Q = |a|*x + |b|*y + |c| + |o| + |e| + 1.
```

Its maximum on `X × Y` is at `(x_hi,y_hi)`. Compute `Q_hi` with outward operations. For the old computed margin, use `K=16*f32::EPSILON` for packed and `K=32*f64::EPSILON` for canonical; both K values are exact powers of two in f64. The source then rounds the positive multiply/add sequence and, for packed, adds `error[i]`. A conservative upper endpoint is

```
M_hi = up((K*Q_hi + error_hi) * (1 + gamma_9))
G_hi = up((K*Q_hi) * (1 + gamma_9))
```

where `error_hi=f64::from(error[i])` (admission guarantees it is finite and nonnegative). There are at most nine rounded operations in the positive expression for `M`; `gamma_9=9u/(1-9u)` bounds all of them. Use a few additional outward endpoint steps after each displayed multiply/add. Reject if any interval used for `Q`, `M`, or `G` enters the subnormal band, except exact zero; `Q` includes +1, so its final value is normal, while tiny early products can still be rejected.

For each axis, require all four strict checks:

```
Ppacked.lo > M_hi
Epacked - Ppacked.hi > M_hi
Pcanonical.lo > G_hi
Ecanonical - Pcanonical.hi > G_hi
```

The second inequality is the correct form for `extent - value > margin`: use the *upper* bound on `value` to obtain a lower bound on `extent-value`. More explicitly compute `down(extent - P.hi)`; do not use an upper bound on `extent-P`.

Why this proves the implication: every old packed/canonical value at every tile corner lies inside `P_old`; every old locally computed packed margin is at most `M_hi`, and every old canonical guard at most `G_hi`. Thus `P.lo > M_hi` makes every old first-edge test pass. `down(extent-P.hi) > M_hi/G_hi` makes every old second-edge test pass. This is a strict implication to each rounded predicate result. Every false/ambiguous result falls back to per-tile checks.

**Clip:** calculate the same four f64 expressions that `full_tile` uses, once (`f64(clip.x) + f64(clip.width)`, etc.), with the same binary64 operators. The old clip test is constant across tiles except for its tile edge. Require `clip.x <= L`, `clip.y <= T`, and those computed max endpoints `>= R/B`. Because the global right/bottom are the largest tile edges, this implies each old tile's clip comparisons pass. Preserve equality as the old code does. There is no need to invent clip endpoint rounding rules beyond evaluating the exact same expression once.

This version is deliberately conservative. Near cancellation, a box interval may be wide and reject even when all 512 existing tile proofs would accept. The proof work is constant in tile area, and false negatives only return to the existing proof loop.

## 32K host regressions and a safe witness boundary

### What the source says

The fixed-campaign report remains authoritative: host regressions in `runs32k` and `singletons32k` were not localized by tile proof counts; a full-canvas opaque tail means both implementations still walk/validate each preceding draw, then visit tiles forward and reverse. The candidate's fused reverse CSR/resource patch walk already removed the separate shipping resource-placement pass. The candidate still compares the common metadata word and each placement's local word during forward packing; this is O(draws), but the report correctly says its causal share is unmeasured.

The GPU benchmark creates one `Canvas` once, then for each warm frame calls `renderer.render(canvas.prepared_scene(), &view)` again. The scene does not change between those calls (`reactivity/crates/gpu/examples/groups.rs`). Candidate `RendererState::render` intentionally takes/drops its prior `Packet` and runs all header checks, `scene.groups()/draws()`, per-placement `validate_draw`, word packing, forward binning, reverse CSR fill, resource preparation, buffer update, and bind-group creation again. `PreparedScene` is `Copy`; its command reference is private, but `width`, `height`, `color_config`, and `clear` are public mutable snapshot fields. `Canvas::prepared_scene()` is the constructor. `CanvasScene::commit` replaces the command list; `Canvas::prepare_paint` and `prepare_slots` have explicit validated commit points; `paint_slot` can also mutate the bank. These are reliable mutation choke points. Images and glyph rasters in the prepared view are immutable leased resources (`Image(Arc<ImageData>)`; prepared masks borrow immutable `Raster`), while `TextSystem` is used during shaping/raster admission and is not part of `PreparedScene`.

At the GPUI/native boundary, `GpuSurface::render_paint` already compares the exact `PresentationToken`; an equal token calls explicit `Renderer::redraw`, while a color-only `SlotTransition` uses `prepare_slots`. That is stronger presentation authority than a raw scene address and already handles GPUI's unchanged presentation path. Do not weaken or replace it. The likely 32K gap is the public generic renderer path used by the direct Canvas benchmark, where no GPUI presentation token is supplied.

### Minimal safe exact-scene key

Put an unforgeable scene owner token and nonwrapping revision in `Canvas`, not in arbitrary caller memory:

- `owner: Arc<SceneOwner>` allocated once when a canonical Canvas is created; `SceneOwner` has private fields and no mutation API. Keep the target Canvas's owner across `CanvasScene::commit`; staging must not replace it. A new Canvas after resize receives a distinct owner. The GPU packet retains one `Arc`, so allocator address reuse cannot create ABA while the packet exists. Compare `Arc::as_ptr` to the borrowed owner only while the packet's Arc keeps that allocation alive; do not use an unretained raw `Canvas` or `DisplayList` address.
- `revision: Option<u64>` starts at a fixed value and advances under `&mut Canvas` at every successful canonical mutation. On checked-add overflow, set it to `None` permanently and disable the fast path. This needs no `Cell`, `RefCell`, lock, or atomic because every mutation already has exclusive `&mut Canvas`; readers hold an immutable borrow. The GPU stores the `Arc` and revision in the same `Packet` as the successful bindings.
- `PreparedScene` exposes an opaque crate-boundary witness borrowed from its originating Canvas (`&SceneOwner`, `Option<u64>`). A caller cannot construct a `PreparedScene` with arbitrary commands because its command and extent fields are private. The witness is evidence of exact lane immutability, not a lifetime lease beyond the scene borrow and not permission to present/acknowledge.
- Include the current public header snapshot in the key: width, height, every `ColorConfig` field by exact value/bits, and `clear.map(f32::to_bits)`. The renderer must still do its O(1) context, target width/height/format, color-config validity, clear validity, HDR-format consistency, and renderer-mode checks before reusing. This catches a caller modifying a copied `PreparedScene` header while private command lanes remain unchanged.

Revision bump choke points found in source:

- direct Canvas successful append/admission with nonempty pending draws; `Canvas::clear` (including clear-color changes); successful `CanvasScene::commit`/`commit_with_damage` on the target;
- `PaintCommit::commit` for every nonempty validated edit set: its docs state equal-value writes can establish literal ownership or detach shared/palette rows, so the lane representation can change even when `changed_groups()==0`. `SlotCommit::commit` only when `changed_slots()>0`; `Canvas::paint_slot` may conservatively bump on every call because it can add a bank row;
- any future mutation that changes order, geometry, clip, inverse transform, material, source tag, image/mask lease/index table, or paint bank.

For `CanvasScene`, it is enough to bump the target revision once on commit, regardless of the number of edits in the pending scene. Dropping a candidate leaves target revision and commands untouched. `CanvasScene` staging may share the target owner token, but target revision advances only after successful commit. `Canvas::clear` called on staging mutates only staging's revision. Prefer a central `Canvas::bump_scene_revision()` and place calls in the existing post-admission/commit paths, not in failed validation paths.

On success, bind the witness to `Packet` when the existing code installs the new bindings at the very end. At the start of a new render attempt with a different key, clear old redraw eligibility exactly as current `render` does. At an equal key, take the same checks as `redraw` and call the existing redraw submit path without touching records, ranges, references, cursors, atlas, image relocation, or correction tables. This is an O(1) branch plus the normal clear/draw submission; it does not skip presenting to a new target view. The cached witness becomes eligible only with the `Packet` after every validation/resource/upload stage succeeds.

Failure/lifecycle rules:

- A wrong context is still rejected before packet mutation, exactly as now.
- For a nonmatching-key attempt, revoke the previous witness before any state can be overwritten. A failed geometry/resource/atlas/device preparation never leaves the old key attached to new or partial buffers. Preserve the existing failed-render behavior (the old packet is not redraw-eligible after an attempted changed scene).
- A successful image/atlas relocation belongs to the newly installed packet/key; if it fails, no new witness installs. An unchanged key cannot require relocation because the renderer's corresponding resident packet and resource state were installed together on its last success.
- `set_tile_proofs` / `set_grouped_records` already clear `packet`; any future renderer setting that changes output or record schema must do the same. Context equality remains checked. Device-loss policy already says to retire a context and all its states.
- Header values are compared exactly, including clear signed-zero bits. A foreign Canvas with identical scene contents misses because it owns a different Arc token; this is conservative and avoids content hashing.
- `PaintRenderer` has an additional positional `sites` map. Do not use the plain scene fast path there unless its requested mapping set is also known identical and its packet bindings remain the owner of that map. The safe initial version can leave `PaintRenderer.render` on its current full validation route; GPUI native already uses token-qualified redraw/slot patch.

This key removes repeated bitwise comparisons instead of adding them: the whole immutable lane set is authorized by the mutation epoch. It only hits when the same Canvas-owned command lanes survive. `CanvasScene::stage` rebuilds a pending list and `commit_with_damage` currently scans old and new commands with `BorrowedCommand::unchanged`; a new full-scene commit must therefore bump and miss this key even if the pixels happen to match. A revision cannot certify equality across two separately constructed pending lists. If that rebuild scan becomes a measured 32K cost, GPUI must carry typed dirty/revision evidence from the owner that knows which geometry/common/material/resource lanes were edited; a hash or raw node identity is still an O(N) comparison or an insufficient proof. In the current GPUI native path, equal `PresentationToken` already avoids that rebuild-to-GPU path by calling redraw.

Existing code already includes `NEXT_FONT.fetch_update(...checked_add...)` for process-unique `FontFace` identity and fails closed on exhaustion; a Canvas-local checked revision uses the same no-wrap principle. An Arc identity does add one small allocation per Canvas and one strong reference in a live GPU packet, not one allocation or clone per frame. If that field cost is unacceptable, an atomic globally unique integer is a valid alternative only on targets with the required atomic width and with overflow disabling cache; don't silently wrap it.

A finer key (topology/common/material/resource revisions) is a later step, not required for exact warm-frame reuse. Topology changes always force full admission/rebuild. Transform or clip changes invalidate tile proof and CSR even if their AABB is unchanged, because the coverage and opaque-prefix result can change. Source/resource changes can relocate atlas/image state. Material changes can change signed-zero or opacity classification. For a material-only path, use an explicit dirty edit set or the existing `PaintIndex`/`SlotEdit` APIs; don't rescan all lanes and compare bits just to rediscover edits. Candidate `GpuPaintCommit` already does direct positional writes after validated admission and submits using the retained packet. If a new general material epoch is added, it needs a complete changed-index feed; an epoch alone says stale, not which bytes to patch.

### 32K performance attribution stays bounded

A successful exact-key reuse skips all four O(draws/refs) CPU passes and the repeated placement comparisons for frames after initial admission. It does not explain the fixed campaign's first render, does not improve a scene whose owner mutates each frame, and does not establish that each 32K host regression came from any one specific loop. The benchmark source proves unchanged-scene reuse is available; only a later unchanged-vs-mutated paired measure can show its effect. Keep every existing outlier and the failed gate.

## Threading and SIMD boundary

The zero-work key path should be the first implementation target; it needs no parallelism and avoids crossing model/resource thread boundaries. If changed 32K scenes still need acceleration:

1. The GPUI model, `TextSystem`, layout caches, and live renderer owner stay on their current owning thread unless their types explicitly satisfy the relevant Rust `Send`/`Sync` bounds. `TextSystem` is used before `PreparedScene` exists. Do not capture `Runtime`, a mutable `Canvas`, `RendererState`, or `PaintRenderer` into workers.
2. The immutable `PreparedScene` numeric input may be shared only if the compiler proves its borrowed payload is `Sync`. Rust defines `T: Sync` iff `&T: Send`; `Cell`, `RefCell`, and `Rc` are not `Sync`. `Arc` only makes reference counting thread safe and does not make its payload safe to share. Use those compiler trait bounds as the gate rather than an unsafe impl or assumption. [Rust `Sync`](https://doc.rust-lang.org/core/marker/trait.Sync.html), [Rust `Arc` thread-safety note](https://doc.rust-lang.org/std/sync/struct.Arc.html)
3. The candidate's current `DisplayList` uses immutable `Vec` lane storage, `Arc<Raster>`, and `Image(Arc<ImageData>)` in the read-only scene; this is promising for a numeric read-only phase, but do not claim `PreparedScene: Sync` until the compiler checks the complete type graph and all target configurations. Keep each async worker limited to borrowed numeric lanes and return owned results. The renderer's reusable output vectors and WGPU queue calls remain single-owner; if workers ever write outputs, hand each worker a distinct `&mut [T]` slice before spawning and merge only ordered metadata after join.
4. If cold-path SIMD is pursued, make the validation/packing math one batched kernel first. Add an immutable, order-preserving `PreparedLaneChunk` view that resolves common-state references into vector-friendly numeric lanes (local rect, inverse/common key, bounds, clip, error, material/source class) without cloning resources. Process full SIMD-width chunks in that kernel, with scalar handling only for the final short tail/unsupported targets. Do not add a parallel scalar copy of the full validation algorithm and then route to it when SIMD fails. Keep resource admission/atlas handling outside the SIMD kernel. The kernel must keep f64 envelope/error semantics and compare exact input bit patterns for signed-zero-sensitive words; it cannot replace HDR/color admission.

This SIMD idea still needs a representation decision: current `InlineDraw` and `Placement` are array-of-structs reached through an order-address vector, and compact groups have shared common state. A vector kernel may need gathers or a one-pass stack batch. Do not create another heap plane merely to stage 32K lanes, and do not count a scalar gather plus SIMD recomputation as eliminated work. Benchmark the same shared kernel with and without SIMD after correctness. The existing `Changes::replace` slice comparisons already generate SIMD16B in the historical linked code; handwritten SIMD for record-word equality would duplicate an operation already vectorized.

If parallelizing that numeric kernel later, first show the data is worthwhile after SIMD and ensure tasks read only immutable borrowed lane slices and write disjoint reserved output slices. Rust's `Send`/`Sync` model bars transferring/sharing non-`Send`/non-`Sync` resources; `Arc` alone does not fix payload constraints. Qt's retained scene graph illustrates the general ownership pattern: an independent renderer-side scene can be synchronized from changed frontend nodes, and dirty flags distinguish matrix, geometry, material and tree changes. It does not justify moving this GPUI runtime/model across threads; it supports putting immutable render data behind an explicit synchronization boundary. [Qt Quick Scene Graph 6.11.2](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html), [Qt QSGNode dirty state](https://doc.qt.io/qt-6.11/qsgnode.html)

## Retained-scene primary references and what they establish

- Qt Quick Scene Graph 6.11.2 describes retaining the scene, rendering a renderer-owned scene independent of item state, and an optional render thread. Its `QSGNode` API makes callers mark the exact dirty-state categories (matrix, geometry, material, node-added/removed). This backs explicit revision/dirty categories and the requirement that owners update them correctly; it does not prove this code's particular identity key.
- Skia `SkPictureRecorder::finishRecordingAsPicture` documents that the finished picture is immutable and that the recording canvas becomes invalid. This supports a frozen snapshot as a reuse boundary; GPUI's `PreparedScene` is borrowed mutable-owner state instead, so it needs a version token rather than assumed immutability beyond the borrow. [Skia API](https://api.skia.org/classSkPictureRecorder.html)
- Flutter's `Layer.engineLayer` docs say the prior engine layer can be passed to `SceneBuilder.addRetained` to tell the engine no layer/descendant changed and allow resource reuse. This is the closest analogy to the proposed exact owner+revision witness. [Flutter API](https://api.flutter.dev/flutter/rendering/Layer/engineLayer.html)
- Rust `Arc` docs explicitly warn that atomic shared ownership does not make `T` thread-safe; `Arc<T>` is `Send`/`Sync` only when its payload meets those bounds. This supports the identity-token lifetime mechanism and the separate threading restrictions, not any performance forecast. [Rust `Arc`](https://doc.rust-lang.org/std/sync/struct.Arc.html)

These sources were checked on 2026-10-23; Qt citation is Qt 6.11.2 docs, Flutter API docs as served that date, Skia API docs generated from Skia's reference, and Rust stable `f64` docs list nextUp/nextDown stabilized at 1.86. Their claims are cited narrowly above. No source says this candidate will achieve a given speedup.
