# Second pass: API audit, memory/grain accounting, and negative-space review

This is a separate follow-up to [`retained-grain-and-parallelism.md`](retained-grain-and-parallelism.md), not a replacement. It sharpens the API boundary and documents failure cases after checking the current `SourcePath` patch, GPUI's runtime ownership, current Solid 2.0 status, Stylo's current traversal API, and official Rust auto-trait rules. No builds, tests, timings, or source edits were performed.

## Correction and exact SourcePath-spike scope

The unadopted `/tmp/gpui-schema-owner-sourcepath.patch` is more than a conceptual path: it adds `Path<M,T>` (sealed behind public `SourcePath`), `ProjectedSource`, `Component::source`, and generic `Win::read`/`Win::set`, and allows `FieldAction` routing through a nested projected path. The static nested component example shows reuse of a child's own source declaration without duplicate source IDs or duplicate Signals. The patch keeps only declaration/path data: comments say it retains no model address, resolved scope, allocation, or window authority. This is good exact-input provenance and ergonomic precedent.

The patch does **not** solve render dependency discovery. `SourcePath::resolve` obtains one `Signal<T>` and its registered scoped `FieldId`; its role is value access and update/input routing. `Component::view` remains ordinary borrowed `child.view()`, and parent `view()` remains arbitrary Rust. Therefore `SourcePath` is a leaf primitive for an explicit read context, not the region/memo itself. The search found no `with_inbox_for` implementation in the current source or this patch; conclusions about that name are limited to the prompt's characterization.

## Better initial prototype shape

The smaller design is a trait method with a default, not a replacement View or all-view signal graph:

```rust
pub trait View {
    fn view(&self) -> El<'_>;
    fn retained_view(&self, cx: &mut RegionBuildCx<'_, Self>) -> RegionTree<'_>
    where Self: Sized {
        RegionTree::opaque(self.view())
    }
}
```

Compatibility properties:

- Existing implementors change zero lines; old views hit the opaque path.
- Opt-in implementors add one method, and static `RegionSpec` declarations (ZST/function pointers) can live as associated constants. No model/base struct field is added.
- `RegionBuildCx` is a temporary borrow only. It provides explicit `read(path, ...)`, `region(spec, recipe)`, `opaque(el)`, `rows(...)`, and stable-order composition.
- `Win` remains non-`Sync`; no shared mutable model, `Rc<RefCell>`, global collector, or renderer resource leaves the owner.
- One lazily created owner-level `RegionStore` is the unavoidable retention state. If unused, it costs zero heap allocations; if used, keep cache records and variable-length dependency packs in dense owner arenas rather than a cache object per `El`/view.

The new method adds one trait dispatch slot in the library API (exact object/layout effects depend on trait-object use; GPUI currently knows concrete `M` in `Runtime<M>`), but does not add an owner field to each `View` or model. An alternative separate `RetainedView` trait avoids changing the `View` vtable, but the runtime cannot discover the optional implementation for arbitrary `M` without another adapter/registration mechanism or type erasure. The default method is the smaller adoption story, subject to ABI compatibility policy.

For line counts: the crate-side first prototype likely needs one trait default method, one `RegionBuildCx`, one owned `RegionRecipe<I,O>`, one dense owner store and one commit hook. User-side opt-in adds a freeze function + recipe function + one `retained_view` body, and zero model fields. That is qualitative source-surface accounting, not an exact diff estimate.

## Typed dependency key versus cache identity

Keep three identities separate:

1. **Schema source id**: `FieldId` (existing 64-bit `local:u32 + scope:u32`) routes a declared projection in a schema. It is not a unique runtime instance or a row key.
2. **Region recipe id**: static type/function declaration identity. `TypeId` is acceptable only for in-process ephemeral cache lookup; codegen/schema persistence should use a checked explicit ID.
3. **Region instance id**: owner generation + region slot + generation + full structural path or full-width row key/list domain. It is the cache's collision-free live identity.

The row case is decisive: a stable `ItemKey(u64)` may have high bits that distinguish values with the same low 32 bits. A hash into `FieldId.scope:u32` cannot be an identity proof. Instead store the complete key in a collision-checked owner table. The table returns a dense slot (and generation) that the runtime can use in compact hot records. `FieldId` remains a source schema path and does not change to encode rows.

For dependencies, an explicit `RegionSpec<M,Frozen>` may expose a fixed typed version tuple (`Copy + Eq`) and a projection `fn(&M) -> Frozen`. That is lower allocation and more compiler-visible than a dynamic graph. If a region reads dynamic fields, use a small inline list of full `FieldId + Revision` entries and spill only past inline capacity. The version tuple is *not* a content hash; revisions can wrap only if the state API has an explicit invalidation policy on exhaustion. Existing monotonic revision types and scoped field IDs are useful but the cache's owner epoch must still guard replacement/ABA.

## Memory and allocation choices (not measured)

- Static function pointers and ZST spec values have no per-frame heap allocation.
- `Frozen: Copy` scalar packs need no allocation; owned strings can either clone (costly, but explicit) or clone an immutable already-thread-safe `Arc<str>`/text handle. For data that cannot be made safely owned, the region remains serial/opaque.
- Store region slots, typed version packs, and outputs in dense vectors owned by runtime; cache handles are index+generation. A cold region table allocation occurs only after a view opts in. Avoid one `HashMap`/`Arc`/`Mutex` per node.
- Variable row counts may allocate a vector on structural changes; reuse capacity and keep only realized rows. Do not preallocate one slot for each possible billion-item list; GPUI already caps realized rows.
- A computed `RegionOutput` can append to the existing retained command/style/text arenas. If persistent output is represented by `Arc<[T]>`, that introduces atomic refcounts and shared ownership. Prefer a runtime-owned immutable arena if worker outputs can return `Vec<T>` and the owner moves them into arena after join.
- Parallel completion storage can be a temporary `Vec<Option<Output>>` indexed by distinct slots; that is a frame allocation unless workspace capacity is reused. Workers never mutate shared arena locations. After all results are successful and epochs validate, owner performs one merge/publish.
- No memory/timing wins are asserted; the memory layout itself must be measured against the zero-region baseline and with dynamic rows.

## Strong dependency model compared to alternatives

**Explicit source region (recommended):** cache correctness is local and reviewable; selected dependencies are visible at the call site; parallel worker boundary is owned data. User must write the freeze/recipe and topology keys.

**Dynamic read tracking (Salsa/Solid/Riffle-style):** less annotation and can track dependencies based on actual reads. It needs all reads to flow through a mediated API. Ordinary `&self`/`&M` field access in existing GPUI views bypasses interception; adding proxies would destroy the simple borrowed access model. Dynamic tracking also needs invalidation/validation records and sometimes a graph allocator. Use only inside an explicit region context or a future separate declarative view language.

**Declared source path only:** easy, zero new state, exact and useful for `Win::read`, update routes, and inbox question inputs. It still cannot infer which visual output depends on a source or ensure there are no other reads.

**Component as render boundary:** nice organization and projected ownership; not a dependency boundary because it is a conventional method call and can inspect all child fields. Treat as a structural container, not a memo.

**Whole frame invalidation + cached scene identity:** can avoid repeated packet validation for an unchanged owner scene only when a real owner/revision/residency witness is available; this is the separate GPU preparation concern. It does not solve fine-grain recomposition and must not let a generic caller turn scene equality into ownership authority.

## Correctness hazards an implementation must encode

- **Hidden parent read:** closure defined inside `retained_view` can implicitly capture `&self`. Worker region API must take a non-capturing `fn` or a closure moved with frozen fields and `Send+Sync+'static`; do not hand a general `&self` to the recipe. If users choose the ordinary `read` callback returning `El<'a>`, it remains serial and non-retained.
- **Purity limit:** even a `'static + Send + Sync` function can read a mutable static. Rust's auto-traits prove memory safety, not deterministic purity. Keep the API's declared-input purity contract explicit; optionally offer debug determinism diagnostics, but never tell users the compiler proved purity.
- **Parent structure:** parent may read an undeclared field to choose child order/branch. A retained child is safe only if the parent's structural region includes that input and its topology version changes. Keeping stale child output at a new position is semantically wrong even if the child input tuple is unchanged.
- **Stale async result:** owner can mutate between job enqueue and completion. Each work item carries an owner generation, frame/input epoch, region generation, and all input versions. On return, mismatch discards the result; never writes into a reused slot.
- **Foreign prepared input:** generic external prepared scenes are untrusted for a region cache, even if header/commands appear equal. Use cache only on the owning runtime's typed recipe route. Generic renderer API falls back to its normal preparation path.
- **Layout feedback:** if child's output changes its intrinsic measure, parent constraints/size become a dependency and layout may need reevaluation. A region may cache paint preparation but cannot skip parent layout unless the measured result is included in the child's output version and parent propagation is correct.
- **Failure P / publication:** all dirty sibling outputs are staged as a complete new set; only one owner turn publishes. Panic, cancellation, compile failure, invalid row identity, or resource mismatch preserves prior frame or falls back to existing full preparation. Never expose some new outputs with old parent topology.
- **Concurrent model writes:** `Win`'s exclusive mutable borrow serializes mutations. Freeze all snapshots in this borrow before task dispatch; dispatch immutable frozen values only after the owner has finished reading the scene. Worker never accesses live source versions, `Signal`, or runtime.
- **Thread-affine resources:** canvas, text system, renderer/device, atlas, and any `!Send/!Sync` resource stay in the context that owns them. Only renderer-neutral immutable output crosses thread boundaries. Increment resource/residency generation when content relocates.
- **Dynamic rows:** rows outside the realized range don't have a runtime `RegionInstance`. `row(index)` must expose its full key before allocating the instance slot. Duplicate key, key/index disagreement, changing list domain, or stale generation invalidates that structural region.

## Literature reread: corrected transfer lessons

- Salsa 0.28.4 is a genuinely demand-recording incremental computation engine, not merely an API with typed input declarations. Its query body runs under dependency recording and input mutations are serialized as revisions; its per-field dependencies and db-borrow lifetime are useful semantic models. However, its version docs describe the cache design, not a free Rust guarantee that any `&Db` function is pure. GPUI should copy the explicit boundary/lifetime ideas, not transplant a full query DB without evidence.
- Solid current status on 2026-10-23 is stable 1.9.17 and 2.0.0-rc.15, not simply the Feb 2025 design-roadmap proposals. The RC release history records bug fixes for async owner context, hydration IDs, stale region versions and dynamic rows. The transferable lesson is that region and row identity must be versioned across retries/remounts; the product implementation is still JS/DOM and does not prove GPUI's Rust architecture.
- Bevy's declarative access sets are a good way to schedule independent code but only represent memory read/write conflicts. They do not determine whether the output may be reused. Use `Send/Sync` snapshot types for task safety plus separate explicit version dependencies for cache safety.
- Stylo 0.22's driver starts sequentially and can parallelize while discovering work. Servo docs say some traversals opportunistically parallelize while ordered CSS layout dependencies constrain branches. The published 2016 browser study warns that work stealing/parallel scheduling may help one web page and lose on another. Accordingly, GPUI should batch contiguous SIMD-friendly same-recipe lanes first, then dispatch sufficiently large independent region groups, with serial fallback. This is design guidance, not a prediction of speed.
- simdjson On-Demand improves laziness by reading the original buffer through a forward-only document iterator and validating only demanded structure. It strengthens the idea of a scoped `ReadCtx` and explicit demand, but does not imply that retained references become thread-safe snapshots. Its own docs describe the on-demand document as single-threaded.

## Proposed serial contract before any worker dispatch

For each owner turn:

1. `Win` takes exclusive access and observes one current model/source epoch.
2. `retained_view` constructs a temporary ordered structural description. Every region boundary records its declared version tuple; every opaque child remains an ordinary borrow.
3. Owner compares versions to the prior complete tree and freezes inputs for changed static recipes. It verifies full row keys/domain/generations and viewport/config inputs.
4. It batches adjacent compatible jobs; a batch can first use a safe SIMD loop over same-layout scalar fields. The scheduler may still choose serial execution for small batches.
5. Worker closures receive owned `Frozen: Send + Sync + 'static` inputs and static recipes; they return renderer-neutral owned fragments. No `Root`, `Runtime`, `&M`, `El<'_>`, thread-affine GPU/text resource, or shared mutable cache exists in the worker closure.
6. Owner checks all generation/version stamps and validates complete output count. If any stale/failure condition appears, drop all staged sibling outputs and either retain prior complete output or run current serial fallback. Otherwise merge by original region order and commit one coherent tree.

This protocol avoids requiring `Root: Sync` while deriving concurrency from isolated frozen data. It also makes cache reuse and task scheduling separately testable.

## Open choices for an implementation spike

1. Does a new default `View::retained_view` trait method fit GPUI's semver/trait-object policy, or should a separate statically supplied adapter be used?
2. What is the first owned fragment boundary: renderer-neutral paint ops, a `PreparedScene` subset, style/layout inputs, or a child `El` recipe? The latter cannot preserve arbitrary current borrows.
3. Which source revision is authoritative: existing `Signal` revision, a schema-wide source epoch, or both? A whole owner epoch is safe but erases fine grain; only field revisions without topology/config revisions are incomplete.
4. Which resource generations are available for text/raster/image residency? They must be explicit before caching output across residency changes.
5. Is one dense `RegionStore` allocation lazy enough, or can region records share existing stable `Sites`/node arenas without mixing semantics? Avoid an auxiliary store if existing tables can be extended without adding per-node allocations.

Resolve those questions in a tiny compile-and-correctness prototype first; no evidence from this research says the region model improves frame time. The important result at this stage is a complete API boundary and a list of properties the compiler can and cannot prove.
