# Typed retained regions and parallel preparation for GPUI

Research status: read-only source inspection plus primary/official literature and API review, 2026-10-23. This note is independent of the GPU coverage proof. No builds, tests, timings, or source edits were made. Claims are tagged **source observed**, **derived**, or **proposal**. The plan is a research direction, not a correctness or performance result.

## Strongest conclusion

The strongest usable architecture is an opt-in *typed region program* with two phases and a deliberate escape hatch:

1. On the owning thread, a normal borrowed GPUI `View::view(&self) -> El<'_>` describes structure and can expose typed region boundaries. Only reads made through the region read context are dependencies. Existing arbitrary view code stays on the ordinary conservative path.
2. At a region boundary, GPUI freezes a small immutable input value from selected fields. A pure retained recipe consumes that owned `Send + Sync + 'static` snapshot and produces an immutable, owned prepared fragment. The recipe can be reused by exact input revisions; dirty sibling regions can be prepared in parallel. `M` itself never crosses threads and need not be `Sync`.
3. A region that cannot freeze its dependencies, whose child rows lack stable identity, or whose output borrows transient parent data remains synchronous and is rebuilt as today. It must not claim cacheability or parallel safety.

This is stronger than inferring purity from `Component`, `Source`, or a borrowed child view. In the current code, a component boundary only qualifies routes and source IDs; its `View::view` can still inspect any child field and return borrowed `El`, and the parent can make arbitrary branch/row/ordering decisions before entering the child. The compiler cannot infer those semantic dependencies from the component boundary. Existing `Source.direct` can identify a route's source, but it does not prove that the rendered region depends only on that source.

The useful invariant is:

> A retained/parallel region has no route back to `&M`; every dynamic input is passed as an explicit frozen value, every cache key includes every declared input version and structural key, and the worker closure sees only immutable `Send + Sync` values.

The ordinary borrowed GPUI language remains the default. The stronger guarantee is deliberately available only in the opt-in region API.

## What I observed in the checkout

**Source observed.** `View` currently has exactly the conventional method `fn view(&self) -> El<'_>` and an optional `sources() -> Sources<Self>` schema in `crates/gpui/src/lib.rs`. Its source comments explicitly say plain views need no schema. `Component::view(parent)` invokes the projected child's ordinary `view`, maps handlers, and attaches the component route. Its comments describe it as parent-owned ordinary state, not an independently scheduled entity, and state that arbitrary child methods use the parent's scheduling grain (`crates/gpui/src/component.rs`).

**Source observed.** `Source<M,T>` stores safe read/write projection function pointers. `Sources<M>` can describe direct fields and contained components. `FieldId` is a 64-bit pair of local declaration ID and 32-bit schema scope; it is a window/schema-relative route, not a globally unique durable capability (`crates/gpui/src/source.rs`). The declarations are validated at mount/edit, and comments explicitly say purity of custom projections is a semantic contract rather than a Rust type-system proof. These facilities are a suitable vocabulary for a read context, but currently they are used for binding/edit routing and invalidation, not for recording arbitrary `view()` reads.

**Source observed.** `ItemSource` is a borrowed viewport snapshot API. It requires `len`, `key`, `index_of`, and `row(index) -> El<'_>`, and the runtime checks key/index agreement for realized keys. `ItemKey(u64)` and `ListId(u64)` are full-width public identities; lists impose uniqueness within a window and state that reusing keys for unrelated items requires a fresh `ListId`. `RowDraft` carries full `ItemKey`. This is an important warning against reducing 64-bit row identity to a 32-bit scope ordinal.

**Source observed.** `Runtime<M>` is exclusively owned and generic over `M`, with model, `Sources<M>`, retained nodes/styles/text/images, list rows, canvas, and prepared/presentation state. `Win` owns `Box<Runtime<M>>`; mutation requires `&mut Win` and queries borrow `&Win`. The runtime does not require `M: Sync`. Adding an incremental database with ambient synchronization would change that ownership model. A runtime-owned region arena/cache is more consistent than per-component `Rc<RefCell<_>>`, but even one new large field should be measured before adoption.

**Source observed.** GPUI's `El<'a>` and `ItemSource::row` are intentionally borrowed. A worker cannot safely retain these values beyond the owner's borrow; more importantly, moving `&M` across threads requires `M: Sync`. A new opt-in owned prepared-fragment type is needed for concurrency. The ordinary `El` route should retain its borrow flexibility and existing inference.

**Spike observed.** `/tmp/gpui-schema-owner-sourcepath.patch` contains an unadopted `SourcePath`/`ProjectedSource` design. It composes nested declarations without storing owner addresses, supports `Win::read`/`set`, and changes `FieldAction` to validate and route through the full projected path; a nested `Counter`/`Pane`/`Page` example avoids duplicate root `Signal`s and source IDs. That is useful ergonomic precedent for declaring input provenance, and its comments correctly distinguish the current registered path from a historical component instance/presentation. However, it only projects to a `Signal<T>` and is for route/read/write/question inputs. `Component::view` still calls ordinary child `View::view`, so it does not capture render-time reads or prove a subtree's dependency closure. I did not find a `with_inbox_for` symbol in the checked-in tree or that patch. Treat any separate inbox API as per task description, not as inspected source.

## Proposed API shape: read contexts, frozen values, immutable recipes

The API below is illustrative Rust, not a claim that the exact signatures compile unchanged. It separates ordinary view construction from the cache/worker proof.

```rust
trait View {
    fn view(&self) -> El<'_>; // unchanged, conservative path

    fn regions(&self, _cx: &mut RegionBuildCx<'_, Self>) -> RegionTree<'_>
    where Self: Sized
    {
        RegionTree::opaque(self.view())
    }
}

// A zero-sized declaration; adding one does not grow the tiny model/view.
struct HeaderRegion;
impl HeaderRegion {
    const INPUTS: ReadSpec<App, HeaderInput> = ReadSpec::new(freeze_header);
    const RECIPE: RegionRecipe<HeaderInput, HeaderOutput> = RegionRecipe::new(render_header);
}

fn freeze_header(app: &App) -> HeaderInput {
    HeaderInput { title: app.title.clone(), selected: app.selected }
}

fn render_header(input: &HeaderInput) -> HeaderOutput {
    // Pure owned recipe: no capture of `app`, Runtime, window, mutable global,
    // platform renderer, atlas, or thread-affine model/resource.
    HeaderOutput::text_and_style(&input.title, input.selected)
}

impl View for App {
    fn view(&self) -> El<'_> { /* existing borrowed body */ }

    fn regions(&self, cx: &mut RegionBuildCx<'_, Self>) -> RegionTree<'_> {
        let header = cx.region(HeaderRegion, Self::INPUTS, Self::RECIPE);
        let body = cx.opaque(self.body.view());
        cx.column([header, body])
    }
}
```

The key boundary is `RegionRecipe`: use a non-capturing function pointer or associated function, not an arbitrary closure with unconstrained capture. If ergonomic closure syntax is important, accept a closure only if its complete environment is `'static + Send + Sync` and make it consume the frozen input (never `&M`). That type bound proves the capture cannot contain a borrowed model or a `!Sync` model/resource, but does **not** prove purity: Rust cannot prevent a `'static` closure from reading mutable global state. The supported recipe contract must forbid undeclared ambient reads, and debug builds can optionally hash/check declared inputs and run the recipe twice to detect obvious impurity; neither is a proof. A `fn` pointer reduces accidental capture but also cannot make hidden global reads impossible.

`ReadSpec<M, Frozen>` should be a static projector from `&M` to `Frozen`. It executes on the owner thread. `Frozen: Send + Sync + 'static` (or `Send + 'static` if the worker gets sole ownership and no sharing is needed) is the compiler gate. No `M: Sync` bound appears. This is how Rust's trait rules show the necessary property without requiring the model itself to be shareable: the only thing moved to the worker is `Frozen`. Rust defines `Sync` exactly as `&T: Send`; `&T` is `Send` iff `T: Sync`, while `Rc`, `Cell` and `RefCell` are non-`Sync`. For `Arc<T>`, the compiler requires thread-safe inner types before allowing shared cross-thread use. [Rust 1.99.1 `Sync` docs, 2026-10-13](https://doc.rust-lang.org/std/marker/trait.Sync.html).

The closure inference tradeoff is manageable: `cx.region(HeaderRegion, ...)` infers `M` from `RegionBuildCx<M>` and `Frozen` from `ReadSpec<M,Frozen>`, while user-facing builders keep ordinary `column([...])`/`text(...)` inference. Avoid APIs like `.read(|m| ...)` with a generic closure body as the only dependency declaration: it encourages borrowing arbitrary `M` and is not a useful proof boundary. Let users define ordinary named freeze functions or infer a `freeze` closure that returns a specifically bounded owned type.

Two read-context modes may be useful:

```rust
// Synchronous, scoped reads retain current borrowed ergonomics. No cache or
// worker guarantee follows merely from this read.
cx.read(Self::TITLE, |title: &String| text(title));

// A typed region read freezes selected values and opts into retain/parallel.
cx.region(TitleRegion, title_spec, title_recipe);
```

Do not automatically treat any scoped read callback as parallel. It may return an `El<'a>` borrowing from `&M`, in which case the ordinary owner-thread rules remain. Only an owned `Frozen` plus owned prepared output grants reuse/worker eligibility.

### Tree structure, branch decisions, and nested GPUI-in-GPUI composition

The region tree must distinguish a static recipe from a structural branch. A static region identity is a zero-sized type such as `HeaderRegion`; its input version decides whether its content recipe is reusable. A dynamic `if` or list branch changes topology and belongs to a parent structure region whose declared inputs include the condition and child-order identity. The parent can then reuse child regions when their identities and inputs remain stable.

Nested regions compose by returning `RegionNode` values, not by treating every `Component` as a dependency boundary. A parent can call a child’s explicit `regions(cx)` while holding an ordinary borrowed child reference; the child projects its own declared inputs through the same scoped context and returns nested nodes. If the parent does not use the child region method, the child remains an opaque borrowed description. This permits gradual adoption and keeps the standard `View::view` implementation and closure inference intact.

An example structural list interface:

```rust
cx.rows(ListRegion, list_source, |rows| {
    rows.for_each_visible(|row: RowCx<'_, RowInput>| {
        row.region(RowVisual, row.freeze(RowInput::from(row.item())), row_recipe)
    })
});
```

The source must supply a full-width stable key and an identity generation/domain. A row not yet realized has no instance identity; never hash `ItemKey(u64)` or a composite path into `FieldId`'s `u32` scope. Keep a full `u64`/128-bit key in an owner-local slot map or intern each realized identity into a checked generational handle `(arena, slot:u32, generation:u32)`. The map compares the entire full-width key; slot lookup is collision-free and checks generation. Rows outside the realized range need no row cache entry. On removal, bump generation or retire the slot; a reinserted equal key after the list domain changes must not resurrect stale output. If the application promises stable `ItemKey` across updates under one `ListId`, preserve the old row slot; if it changes list domain, remount all rows.

### Cache keys, ownership, and memory model

The minimal safe key is a runtime-interned region instance `(owner-generation, region-type-id, row-slot-generation, structural-branch-id)` plus the full ordered tuple of read versions. The region type may be a `TypeId` only as an internal process-local key; durable or serialized identity needs an explicit schema ID. A 32-bit scope is suitable for compact schema route ordinal, not as a lossy hash of region or row identity. If a dense `u32` slot is used, every lookup resolves through a table that compares the complete source identity and generation before reusing a value.

Keep region metadata in a runtime-owned arena/table, not in a `View` or each tiny base model. Existing `Runtime` already owns owner-lifetime vectors/maps and `Win` is an exclusive single-threaded state machine. One added `RegionStore` field at runtime scale is likely cheaper and more coherent than adding `Rc<RefCell<Cache>>` to every component. The exact additional bytes/allocations are unknown until an implementation measures them; this note makes no size or speed claim. For zero allocations on a base with no regions, use an enum/empty sentinel or optional lazily allocated arena, but do not add a per-view heap allocation. A bounded arena needs explicit reclamation for removed rows/owners and a resource budget; cache eviction must only discard outputs, never invalidate the logical current tree.

Workers must never mutate the store. Owner thread stages a vector of dirty work items containing immutable frozen inputs and indices, dispatches a batch, then commits all completed outputs only if the owning generation and snapshot epoch still match. Each worker returns owned output and no GPUI owner pointers. The owner validates that all expected work completed, and atomically publishes the new region tree/outputs. A panic, cancellation, error, or schema mismatch leaves the last complete tree intact (or falls back to fresh serial render); no partial sibling publication. This transactional boundary also handles authority: only the owning `Win` can publish against its own generation. A foreign `PreparedScene` or caller-supplied generic scene lacks region provenance and must not be accepted as a cache hit merely because geometry/header compare equal.

External renderer resources remain on owner/render threads unless their APIs explicitly declare immutable `Send + Sync` snapshots. A recipe may produce renderer-neutral data (`PaintOp`, style/geometry columns), while atlas allocation, image residency, device handles, font system state, and final `PreparedScene` packet assembly happen in the renderer-authorized context. A change in viewport size/scale, color configuration/HDR mapping, theme/environment inputs, or resource residency/atlas generation must be a declared dependency or invalidate the affected downstream stage. Generation keys protect replacement/ABA; addresses alone do not prove identity.

## Stronger formulations and tradeoffs

### A. Explicit typed region recipes (recommended first prototype)

Typed region node + freeze function + immutable recipe + exact read versions. Highest safety-to-complexity ratio. Works with GPUI borrowing as a separate fallback; produces good boundaries for both skipped description work and worker work. Requires user annotations and explicit owned snapshots, and has no automatic capture analysis. Reuse is at the recipe/region level. Parent layout may still need its own pass if a child's measured output affects parent geometry.

### B. Static recipes plus dynamic typed input vector

Use a `RegionRecipeId` associated constant and a compact `FrozenInputs` struct. Runtime stores recipe outputs and a type-erased but schema-checked input version vector. This scales better than a heap graph of reactive signal nodes, gives static dispatch, and avoids per-dependency `Rc`/`Arc`. Generic type erasure should occur at cache-table boundary, not in every model. A generated/derive macro could produce freeze/read declarations and avoid user-written `TypeId` or hashes.

### C. Pull-based demand with short-lived `ReadCtx`

Each recipe runs only when demanded and a `ReadCtx` records field reads. This resembles Salsa's tracked functions and simdjson's demand-based cursor. It can remove boilerplate, but obtaining dependencies from arbitrary Rust access requires routing reads through the context; ordinary `&self` reads still bypass tracking. If the API uses a `ReadCtx` that hands out read-only projected values, all code that affects output must stay inside it. The `ReadCtx` borrow should be lexically short, and its `ReadValue<'a,T>` must not escape into a retained output. Dynamic dependencies can allocate per query or need inline small vectors, so this is a later option rather than the base path.

### D. Compiler-generated dependency graph / macro expansion

A derive could generate field-read wrappers and a typed `region!` macro can reject direct `self.field` capture inside recipe bodies. It cannot currently inspect arbitrary method bodies, reflection of private arbitrary Rust reads, or prove no ambient state. It provides better UX, not a semantic proof for arbitrary Rust. Treat omitted inputs as a contract error and preserve opaque fallback.

### E. Whole-view automatic incremental graph (reject for now)

Auto-tracking every read in arbitrary `View::view` would need proxying all field access and container iteration through observable APIs, while current views borrow normal model fields. Making `M: Sync` or wrapping it in `RwLock`/`RefCell` conflicts with current ownership and would add synchronization/indirection throughout the tree. Component boundaries alone are not enough. Avoid a full reactive graph with per-field nodes and pointer identity until real workloads show that explicit typed regions are too cumbersome.

## Parallelism: SIMD inside a batch first, threads for coarse independent regions second

**Proposal.** The first parallel-friendly kernel should operate on a contiguous batch of frozen numeric lane records (`RegionInput`/transforms/visibility/material flags), using safe portable SIMD or compiler-vectorizable slices. This avoids starting with a scalar task per region; scalar duplicate work or per-row task creation is not a substitute for SIMD. Keep a scalar reference path for semantics. Where branches differ, split work by recipe kind or process masks in chunks instead of a large branchy global loop. Rust's safe `std::simd` stabilization status is time-sensitive, so implementation must verify the actual compiler/library version before choosing `std::simd`, `wide`, or scalar auto-vectorization; I make no claim about current std stability here.

Then dispatch only independent dirty region batches with enough work. Workers read frozen immutable inputs and write distinct output slots or return vectors. The owner merges in deterministic order. Never borrow disjoint `&mut M` by unsafely splitting it; instead freeze while holding `&mut Win` and hand only immutable snapshots to workers. There is no `Root: Sync` or `Runtime<M>: Sync` requirement. If using rayon-style parallel iterators, the item/output types still enforce `Send`; no worker closure gets a renderer resource or runtime.

GPUI's structural branch / row identity must remain deterministic regardless of worker completion order. A worker output is indexed by checked `RegionInstance`, then merged in tree order. Cancellation cannot erase the last accepted output. Batch thresholds are empirical and should be measured; no timings are claimed here.

## Literature and what transfers

| System/source (version/date) | Evidence and useful transfer | Important limit for GPUI |
|---|---|---|
| Salsa Rust crate 0.28.4 docs, current docs site | Tracked functions dynamically record which input fields/query results they read; the red-green algorithm validates dependencies across revisions; field-level dependencies and owned/borrowed return modes are explicit. This is the strongest reference for *incremental cache semantics*. [Crate docs](https://docs.rs/salsa/latest/salsa/) and [red-green algorithm](https://salsa-rs.github.io/salsa/reference/algorithm.html). | Salsa separates a deterministic query database from mutation and its db-lifetime prevents borrowed tracked references from crossing revisions. GPUI's arbitrary borrowed `View::view` is not a tracked query, and a Salsa-style database can impose more storage/memo overhead than a region recipe. Salsa describes incremental reuse, not automatically parallel rendering.
| SolidJS current releases on research date; 1.9.17 stable release commit (2026-10-07) and 2.0.0-rc.15 pre-release (2026-10-13) | Fine-grained signals/resources and explicit async boundaries provide compositional reactivity. The current RC.15 includes ownership/retry fixes around async computations and streamed regions; this is evidence that owner identity, retry, and streaming coherence are first-order concerns even in a reactive framework. [Official releases](https://github.com/solidjs/solid/releases), [Solid 2.0 RC announcement](https://www.solidjs.com/blog/solid-2-0-rc-the-big-reveal), [async server rendering API](https://docs.solidjs.com/reference/rendering/render-to-string-async). | The earlier Feb 2025 roadmap is now stale as current status: Solid 2.0 remains pre-release on the research date. JS runtime-owned reactive graph and DOM updates do not model GPUI's Rust borrowed elements, `!Sync` model, or Rust ownership proof.
| Bevy ECS 0.19.1 docs (docs.rs `latest` on research date) | Query access types are declared (`Query<&T>`, `Query<&mut T>`); schedule detects conflicting accesses and runs non-conflicting systems in parallel. Change detection is available and can be filtered; mutably dereferencing can mark changed even when value is equal, with `set_if_neq` opt-in. [Bevy ECS overview](https://docs.rs/bevy/latest/bevy/ecs/), [Query](https://docs.rs/bevy/latest/bevy/ecs/system/struct.Query.html), [DetectChanges](https://docs.rs/bevy/latest/bevy/ecs/prelude/trait.DetectChanges.html). | Bevy proves/schedules data access conflicts, not that a component owns a complete render dependency set; change detection itself is coarse unless deliberately designed. Its ECS world and query storage are a much larger ownership model than GPUI's small borrowed views.
| Riffle UIST 2023 (Litt et al., Oct. 29, 2023) | A reactive relational state model uses query graphs and incremental view maintenance for derived UI state; illustrates the powerful end of dataflow formulations when large collections/joins dominate. [MIT publication page and DOI](https://dspace.mit.edu/entities/publication/4444260b-22b4-4d79-8477-a4d2cdd6d813). | Query DB, persistence, and general IVM are too heavy to transplant for basic view construction; consider only for data-heavy retained tables. The assignment's phrase “Ripplet” did not identify a reactive UI research system; search results surfaced unrelated current products. Riffle is the closest relevant primary work I found.
| Stylo style0.22.0 API and Servo browser scheduling sources; parallel browser study at HiPC 2016 | Stylo's current crate docs describe a traversal that starts sequentially and optionally parallelizes as it discovers work. Servo's layout design uses recursive traversal, parallelizes opportunistically, and preserves sequential dependencies such as floats. The 2016 Servo workload study finds pages where parallelization helped and pages where overhead outweighed benefit; it models whether to parallelize. This directly supports task grain/thresholding and serial fallback, not blanket task-per-node. [Stylo 0.22.0 docs](https://docs.rs/stylo/latest/style/), [Servo layout report](https://github.com/servo/servo/wiki/Servo-Layout-Engines-Report), [Zambre et al., HiPC 2016 paper](https://hpcforge.eng.uci.edu/publication/hipc16-browser/hipc16-browser.pdf). | Browser DOM/layout has different mutation/access model and much larger subtrees. These sources do not prove GPUI's candidate parallel region grain is worthwhile. The Servo wiki is architecture documentation, while the cited paper's measurements are from its browser workloads/hardware.
| simdjson On-Demand API design and 0.8.0 docs | A cursor over immutable source text parses only demanded fields and keeps references valid only while parser/input/document remain alive; forward-only restrictions bound state. Good inspiration for a scoped `ReadCtx` that avoids constructing all intermediate values. [On-Demand design](https://github.com/simdjson/simdjson/blob/master/doc/ondemand_design.md), [0.8.0 API docs](https://simdjson.org/api/0.8.0/md_doc_ondemand.html). | simdjson is a sequential parser cursor, not an incremental dependency graph or UI scheduler; its state is intentionally not thread-safe. Borrowed demand avoids copies but cannot be retained as a worker snapshot without freezing owned values.
| Elm asynchronous FRP (Czaplicki & Chong, PLDI 2013) | Async FRP makes ordering relaxation explicit to allow long-running computations concurrently while preserving responsive UI behavior. [Harvard institutional record](https://dash.harvard.edu/entities/publication/73120378-ccb2-6bd4-e053-0100007fdf3b). | Elm's pure functional language/design gives stronger semantics than ordinary Rust closures; an async boundary must be explicit and snapshot consistency designed.
| Rust 1.99.1 standard library docs (`Sync`, 2026-10-13) | `&T: Send` iff `T: Sync`; the compiler-derived `Sync` bound for the frozen snapshot is a direct, reviewable gate. [Official `Sync` docs](https://doc.rust-lang.org/std/marker/trait.Sync.html). | `Send + Sync` is a memory-safety guarantee, not a guarantee that a recipe is pure, complete, current, or cheap.

## Proof obligations and fallbacks

1. **Dependency completeness.** Every branch, output property, child ordering choice, and row set read by a cached region comes from its declared versioned inputs. An ordinary `self.foo` read outside the context makes that region opaque. A structural branch must be a parent region input. Existing source projector validation verifies projection identity, but does not automatically attest that all rendering reads used the source.
2. **No stale borrowed values.** Frozen inputs and outputs cannot reference the owner, `El<'_>`, mutable runtime, or stack borrow. Store must not extend a borrow by raw pointers. Worker closure signature excludes `M` entirely.
3. **Coherent snapshot.** Owner constructs all snapshots from one `&mut Win` critical section/epoch; no owner mutation interleaves. If snapshots derive from multiple revisions or foreign `PreparedScene`, key includes owner and public scene header, otherwise fallback to full prepare.
4. **ABA and authority.** Use generational owner and row IDs, checked nonwrapping generation/revision. Do not trust addresses alone. A pointer may be reused after drop, and equal scene headers do not establish same owner/command/resource authority. Failure or panic before commit leaves prior complete state and marks dirty.
5. **Resource/view configuration.** Viewport, scale, color/HDR config, font/raster/atlas/device residency and environment are inputs of the appropriate stage. If a runtime resource is unshareable or a resource generation changed, rerun owner-thread prepare. No hidden mutable singleton access in recipes.
6. **Ordering.** Each immutable `RegionOutput` maps to a tree slot; only owner commits in stable structural order. Out-of-order task completion must not reorder paint/hit/accessibility semantics.
7. **Granularity.** Do not dispatch one tiny scalar callback per element. Batch same-recipe lanes for SIMD, then divide independent region batches only when measured task work exceeds scheduler overhead. Preserve a serial path for small regions and !Send inputs.

The fallback is an opaque borrowed subtree built synchronously each owner turn. This is a first-class result, not an error. If a cache key is unknown, any typed projection changes, the row key collides or goes stale, an input cannot be frozen, a result has a non-static borrow, color/resource configuration changes, or task commit epoch no longer matches, invalidate/rebuild the affected parent or entire legacy tree according to the existing runtime contract.

## Failure-focused tests for a later implementation

These tests would verify the contract, not mirror implementation:

- Compile-fail: a `RegionRecipe` closure cannot capture `&M`, `Runtime`, `Window`, `TextSystem`, or `Rc<Cell<_>>`; a `Frozen` containing a `!Sync` resource cannot satisfy worker bound. Ordinary `View::view` using those borrows must continue to compile.
- A child view that reads an undeclared sibling/self field renders through opaque path; modifying that field cannot yield a stale cached result. A normal `Component` does not automatically mark the region pure.
- Mutating a declared selected field changes only regions whose frozen input version changes; changing an unrelated field keeps a region eligible, but rerunning its parent structural branch when the parent declared that input.
- Branch switch with identical child values changes structure identity/order and does not reuse old output in the wrong slot.
- Dynamic row: remove/reinsert the same full-width `ItemKey` under a new list domain; prior row state/output is rejected. Use keys differing only in high bits to prove no 32-bit hash truncation alias; test generation wrap policy as explicit exhaustion, never silent alias.
- Duplicate keys and `index_of(key)` disagreement must fail before publishing a new tree, preserving the last complete frame.
- Inject a recipe panic/cancellation while siblings are dirty; no partial output becomes presented, and next frame retries/falls back safely.
- Foreign `PreparedScene` with equal dimensions/clear/color but a different owner or command/resource generation cannot become a cache hit. Change HDR/color config, viewport scale, atlas residency generation or image lease; correct downstream invalidation must happen.
- Spawn/complete workers in reverse order; final paint/hit/accessibility tree remains identical to serial stable order.
- Serial and worker recipes compare equal outputs for the same frozen input; cache invalidates on exact input revision changes. Ambient mutation is explicitly documented unsupported; in debug mode tests can detect a deliberately impure static recipe but must not claim compiler proof.
- Zero-region tiny base should allocate no region table/recipe objects. Measure runtime field/region metadata size and allocations later; no size assumptions in this research note.

## Final applicability judgement

Typed source paths are useful for explicit updates and for producing versioned leaves. They are not by themselves a rendering dependency graph. `Component` is an ergonomic composition/projection facility, not an independent scheduling proof. The strongest practical increment is to let a region opt into a restricted `Frozen -> OwnedOutput` recipe, retain the normal borrowed `View` contract for everything else, and add coarser batch scheduling only where these boundaries expose independent work. That buys a real compiler-visible worker boundary without `Root: Sync`, ambient locks, per-view owner fields, or an attempt to infer purity from arbitrary Rust.
