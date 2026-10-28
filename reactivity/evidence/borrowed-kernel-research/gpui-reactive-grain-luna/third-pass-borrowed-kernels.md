# Third pass: frame-borrowed typed kernels instead of owned region snapshots

This corrects the overly restrictive owned-snapshot recommendation in the first pass. The freeze-to-owned boundary is appropriate for asynchronous work that must outlive a frame (questions/readers, inbox messages, request completions). It is usually the wrong abstraction for a synchronous frame-scoped CPU kernel. The stronger formulation here keeps the model `!Sync`, shares only selected `&T: Send` fields whose `T: Sync`, mutates only disjoint `&mut O: Send` scratch/output lanes, and synchronously joins before the owner borrow ends.

No GPUI source was edited. The standalone probe is at `/tmp/gpui-reactive-grain-luna/borrowed-jobs-probe.rs`; it compiled and ran with `rustc 1.97.1 (8bab26f4f 2026-07-14)` after sourcing `/tmp/gpui-native-env.sh`. Three compile-fail controls also failed for the intended trait/borrow reasons. The first sketch incorrectly tied the worker's short mutable output-slot borrow to the longer frame-data lifetime; the corrected design uses separate job-borrow and frame-data lifetimes. Details and diagnostics are below.

## Correct the async versus frame-lifetime boundary

There are two separate work classes:

| Work class | Input/output ownership | Scheduler contract |
|---|---|---|
| External async operation (Question/Reader, inbox worker, image decode, I/O) | Own/freeze a `'static` request pack; completion owns result and request/owner epoch | Can outlive this frame; must not borrow the model. Existing reader/question version admission and `Remote<T: Send + 'static>` are appropriate. |
| Pure frame preparation kernel | Borrow selected `&'frame T` and disjoint `&'frame mut O`; output may itself borrow from `T` for `'frame` | Must finish before frame borrow ends and before the next owner mutation. Use `Sync` only on each shared leaf input type, `Send` on output, and a reusable in-process worker pool or join scheduler. Do not enqueue as a background `'static` task. |

Requiring every frame region input to be owned `'static` forces clone/copy/Arc ownership conversion for borrowed views. If the output is just a transformed view of existing `&str`, image, layout data, or a retained lease, such a conversion can add allocation/refcount work and parallel-only output layers. It defeats the borrowing model and can cost more than the computation. A frame kernel instead carries a generative borrow lifetime and returns a temporary `FrameProduct<'frame>` consumed before that scope ends.

The owner remains exclusively borrowed during the dispatch scope: there is no mutation while worker reads are live. The model may contain `Cell`, `RefCell`, `Rc`, or GPU/thread-affine fields elsewhere; only selected input fields need `Sync`. Crucially, callers first bind references to those fields:

```rust
let text: &str = model.text.as_str();      // capture only this shared field
let transform: &Affine = &model.transform; // this type also must be Sync
let (text_out, transform_out) = outputs.split_at_mut(1);
```

Do not hand `&M` or `&mut M` to a worker closure. Closure capture precision is easier to audit when references are named before dispatch; a generic `&M` closure would require `M: Sync` (for shared access) or `M: Send` (for moving ownership), which this design intentionally avoids.

## Typed heterogeneous borrowed job tree

Use a zero-allocation, statically typed kernel tree. Each leaf owns only two references and a function pointer; a balanced `Fork<L,R>` recursively combines different input/output types. Construction borrows disjoint output fields safely. Function pointers receive the frame lifetime explicitly, so a kernel may put borrowed input data in its output without promoting it to `String`, `Arc`, or `Box`.

```rust
// Borrowed-kernel shape validated by the standalone probe.
// 'job is the short scheduler borrow; I/O may themselves contain 'frame refs.
struct Job<'job, I: ?Sized, O: ?Sized> {
    input: &'job I,
    output: &'job mut O,
    run: fn(&'job I, &'job mut O),
}
struct Leaf<J>(J);
struct Fork<L, R>(L, R);

trait KernelTree { fn run(self); }
impl<'job, I: Sync + ?Sized, O: Send + ?Sized> KernelTree for Leaf<Job<'job, I, O>> {
    fn run(self) { (self.0.run)(self.0.input, self.0.output) }
}
impl<L, R> KernelTree for Fork<L, R>
where L: KernelTree + Send, R: KernelTree + Send {
    fn run(self) {
        rayon::join(|| self.0.run(), || self.1.run());
    }
}
```

`Job<'job,I,O>` is `Send` if `I: Sync`, `O: Send`, and its function pointer is ordinary `Send`. Importantly, `'job` is the borrow of the slot during the synchronous worker call, while `I` and `O` may contain references with a longer frame lifetime. This lets `Option<&'frame str>` be written into an output slot borrowed only for `'job`; after join the slot can be read while its referent remains borrowed from the model. The initial single-lifetime sketch failed with E0502/E0503 and was corrected this way. It stores no shared context and no erased `dyn Fn`, `Box`, `Arc`, `Mutex`, `RefCell`, thread-local dependency collector, or `M`. For a retained pool, call `pool.install(|| tree.run())` on a pool created once at application/runtime setup, not inside each frame. Rayon 1.12.0 docs state that `join` can use stack work while general `scope` must heap-allocate spawned tasks; use balanced `join` trees or homogeneous `par_iter` batches rather than one scoped heap task per node. The pool is persistent; dispatch is synchronous and all branches finish before `install` returns. See [Rayon `scope` docs (1.12.0)](https://docs.rs/rayon/1.12.0/rayon/fn.scope.html) (explicit task allocation caution) and [Rayon `ThreadPool` docs (1.12.0)](https://docs.rs/rayon/1.12.0/rayon/struct.ThreadPool.html).

For uniform batches, prefer existing flat lanes and a Rayon `par_iter_mut`/parallel iterator kernel over building one `Job` per element. For heterogeneous recipes, generate a balanced static `Fork` tree at compile time from an HList or tuple; avoid a runtime `Vec<Box<dyn Kernel>>`. A handwritten 2–4 job tree is enough to prototype bounds before adding a macro. If fork grain is too fine, collapse leaves into serial blocks at the type-construction boundary or use Rayon `join` only above a work threshold. Do not create threads per frame: `std::thread::scope` is useful for proof probes, not a frame scheduler.

### Frame-borrowed outputs

`O` itself may contain `'f` references. For example, `Job<'job, &'frame String, Option<&'frame str>>` can call `fn copy_ref<'job, 'frame>(src: &'job &'frame String, out: &'job mut Option<&'frame str>) { *out = Some(src.as_str()); }`. After join, the owner consumes the borrowed output before mutating/dropping the model. This yields no payload copy or refcount promotion. For multiple borrowed operands, make the input a typed tuple `I = (&'f A, &'f B)` (both A/B need `Sync`) or use a dedicated input struct; the shared borrow of that tuple is Send if it is Sync.

Do not use a raw `*mut` destination array, `UnsafeCell`, integer pointer cast, or “each worker uses its index” alias claim. Construct disjoint output borrows via field destructuring or `split_at_mut`; let the compiler enforce exclusive slots. A dynamically indexed output set can be partitioned into disjoint slices before dispatch, or each job can own a `&mut Slot` minted through safe splitting. Any scratch/output type with non-thread-safe interior mutability fails `Send` naturally and stays on the serial path.

## What this does and does not prove

**Compiler-proved if the sketch's bounds compile:**

- Every worker closure owns a shared reference to each input type with `Sync` and an exclusive reference to each output type with `Send`.
- Distinct workers cannot receive aliased `&mut O` unless unsafe code or an unsound `Send` impl manufactures that alias; there is no unsafe code in the proposed API.
- The caller cannot use an output slot while its mutable borrow is held by a worker.
- `M: Sync` is unnecessary because the closure receives only field references. A containing model can therefore include a `Cell` field and still expose a separate `u32`, `String`, `Affine`, or immutable lease input where the field type itself is `Sync`.
- Frame references cannot outlive the `Job<'f,...>`/dispatch scope, and join completion precedes later owner mutation.

**Not compiler-proved:**

- That a function pointer reads only its explicit parameters; it can still inspect mutable global state. Do not call this pure by type alone. Purity remains an API contract; recipe bodies should be small, audit-friendly functions with no global/device/runtime access.
- That the selected `FieldId`/version set covers all data affecting the recipe; typed source provenance and view dependency completeness are separate from borrowing safety.
- That output ordering, cache reuse, row identity, scene ownership, or presentation freshness is correct. These require explicit structural IDs/epochs and owner-side commit checks.
- That a worker actually runs on another OS thread; Rayon may execute work on the caller or serialize under a one-thread pool. Correctness must be order-independent.

## Source-level construction facts in this checkout

### `with_inbox_for` is an external async delivery API, not the frame kernel

In `/tmp/gpui-field-delivery-root/reactivity/crates/gpui/src/runtime/delivery.rs`, `Win::with_inbox_for<T: Send + 'static, U: 'static, S: SourcePath<M,U>, F: FnMut(&mut U,T)>` constructs a typed `FieldAction` for an admitted source path. Its docs say the callback borrows only that value and a batch of direct-source edits can patch its ports without describing the owner; mixed or owner-dependent edits stay coarse. In `remote.rs`, `Remote<T>` sends owned messages through a bounded `SyncSender`; `deliver_ready` stages a batch before owner callbacks. This is good for a worker producing an owned `T` asynchronously, then applying that `T` to a field on the owner thread. The closure gets `&mut U` only during delivery. It neither passes a borrowed model field to a worker nor enables worker execution of view or paint logic.

The source path must be revalidated before each mutable callback, since a declaration ID alone does not authorize a different projector. This is an appropriate authority rule. Do not confuse “the message is owned/static” with “the rendering kernel must own/clone the source field.”

### `El` itself is not a worker product

Current `El<'a>` owns a `Vec<El<'a>>`, optional `Handler(Box<dyn Route>)`, component metadata, and optional boxed extras. A handler is a `Box<dyn Route>` without `Send`; the public builder returns borrowed `El<'a>`. Worker code cannot safely return or retain arbitrary `El`, and adding `Send` to all handlers would narrow user captures and break borrowed flexibility. Keep route installation, `Component` admission, source projection validation, inspector hooks, and logical owner changes on the `Win` owner thread.

A frame-scoped worker should operate on a smaller restricted product: numeric paint/geometry records, borrowed text/image/resource views where their concrete type is `Sync`, and output references/slots. The owner then lowers those results into existing `CanvasScene` / `PreparedScene` paths. GPUI Canvas's `PreparedScene<'a>` already exposes borrowed command, mask, and image views. Passing the borrow through the frame is a supported model; copying every source into an owned region arena is not required for temporary computation.

### Existing code imposes real serial stages

The current `Runtime::prepare` in `crates/gpui/src/runtime.rs` obtains a font face from `TextSystem`, creates one mutable shaper, then calls mutable `LayoutTree::compute_with` with a measurement closure. That closure captures `&nodes`, `&styles`, image resources, `&mut texts`, `&mut shaper`, and failure state; text `shape_for` mutates caches. The current Cephal tree is mutably traversed and measurement is callback-driven. This is not a worker-safe region surface. Do not send `TextSystem`, shaper/Fontique/Parley state, `LayoutTree`, `&mut texts`, or images/atlas if their API does not prove `Sync`.

Similarly, current Paint pass iterates nodes in declaration order, carries parent transform/clip/layout state, refreshes inspector state and writes into one staged canvas. Arbitrary `El` tree construction includes handlers and borrowed dynamic values. A parallel region abstraction that rebuilds this whole output into an extra heap graph would duplicate current descriptions and publication surfaces.

Better boundary: complete owner-only edits, route validation, source admission, layout/style mutation, text shaping, and any mutable resource admission first. Then identify a narrow pure per-lane kernel over already-existing compact `&[T]` / `&mut [O]` data—e.g. a bounded numeric transform/coverage/geometry lane after layout—where input/output columns are independently partitioned and current `layout_dirty`, `damage`, paint-slot, or scene tokens already define work. Consume its borrowed output in existing slots/scene path before releasing `&mut Win`. Do not add a general RegionStore/cache graph unless evidence shows a gap not already covered by exact source impact, dirty lanes, damage, and Canvas's retained columns.

If the chosen workload is text, first do immutable serial extraction of shaping outputs and explicit face/atlas lease reads; then only parallelize post-shaping numeric layout/geometry over immutable glyph/line facts. It must not share mutable Parley/Fontique caches. If the chosen workload depends on Cephal parent layout dependencies, keep Cephal serial until its data-parallel layout API can hand disjoint immutable inputs and outputs through safe borrows; no `&mut LayoutTree` split via raw pointers.

## SIMD before task parallelism; reuse existing lanes

First ask whether the work already has contiguous same-kind columns. GPUI Canvas uses typed display-list lanes (`Columns`, common groups, inline draws) and has its own parallel output-band rasterization. Its reports distinguish `parallel`, output bands, tile references and bytes; that is a more concrete CPU-kernel grain than a semantic region graph. A new layer over the same list risks duplicate commands/refs, task records, branch predictor pressure and code size. Use the existing Canvas SIMD kernel where applicable; do not add a second raster pipeline.

For GPUI runtime geometry/paint, SIMD candidate should be a fixed-arity safe kernel over contiguous numeric lane arrays. It can map already computed layout extents/transforms/clips into geometry with no tree reads and no text/system objects. The current Node tree is AOS; creating SoA scratch purely for one invocation may cost more than it saves. Prefer existing columns/slot arrays and existing `layout_dirty`/damage ranges. If vectors are needed, reuse capacity in current scratch or write into an existing destination lane; account every added byte/line and cold allocation. No SIMD performance claim is made.

Only after same-recipe batch SIMD is the task large enough to split should a persistent pool run the batch. `rayon::join` balanced over static disjoint jobs pays no per-task heap `Box` according to Rayon docs; a new `Vec<RegionJob>` plus `rayon::scope` may allocate each job. `par_iter` is convenient for homogeneous lanes but still needs `T: Sync`/output `Send` and a meaningful grain threshold. Running a background future on every frame is different from synchronous join and risks stale snapshots, backpressure and lifetime promotion.

## Standalone compiler probe

The probe at `/tmp/gpui-reactive-grain-luna/borrowed-jobs-probe.rs` uses an HList with heterogeneous `String`/`Vec<u8>` inputs, borrowed outputs `Option<&'frame str>`/`Option<&'frame [u8]>`, an owner model containing `Cell`, and compile-fail controls for passing whole `&M`, a `Cell` field, or aliased `&mut` output slots. Commands and results (all using the stated environment setup):

- `source /tmp/gpui-native-env.sh && rustc --version` → `rustc 1.97.1 (8bab26f4f 2026-07-14)`.
- `source /tmp/gpui-native-env.sh && rustc --edition=2024 --crate-type=bin /tmp/gpui-reactive-grain-luna/borrowed-jobs-probe.rs -o /tmp/gpui-reactive-grain-luna/borrowed-jobs-probe && /tmp/gpui-reactive-grain-luna/borrowed-jobs-probe` → compile and execution succeeded, no output. The HList carried borrowed slices/str outputs from selected fields of a model containing `Cell`; mutation of the `Cell` after the synchronous scope compiled.
- The same compile with `--cfg negative_whole_model` failed as expected: `Model: Sync` is unsatisfied because `Cell<u32>` is not `Sync`, so `&Model` cannot meet the job input bound.
- With `--cfg negative_cell_field`, compilation failed as expected because `Cell<u32>: Sync` is unsatisfied.
- With `--cfg negative_aliased_output`, compilation failed with E0499 because `out` is mutably borrowed more than once.

The harness uses `std::thread::scope` only to validate borrow/trait constructibility; it is not a frame scheduler and says nothing about frame latency, worker reuse, or speed. Runtime proposal remains a persistent pool with `rayon::join`, not per-frame OS thread creation. A compile-fail after the source owner is dropped and a captured Win/Runtime negative control were listed as follow-up acceptance tests but were not run; no claim is made for those controls.

## Additional probe acceptance tests

1. Positive: model `{ title: String, bytes: Vec<u8>, local: Cell<u32> }` remains `!Sync`; create jobs only from `&model.title` and `&model.bytes`; run in a scoped worker abstraction; output slots hold borrowed `&str` and `&[u8]`; no `Clone`/`to_owned`/`Arc`/`Box` appears. Compare contents after join.
2. Negative: job with input `&model` fails the `I: Sync` bound because the model contains `Cell`; job with `&model.local` fails because `Cell` is not `Sync`.
3. Negative: two jobs attempted with `&mut output.value` fail because mutable borrows overlap; constructing them via two distinct struct fields succeeds. `split_at_mut` yields disjoint dynamic output ranges.
4. Negative: returning `FrameProduct<'a>` from a function after the source owner is dropped fails; drop frame product, then mutation of model field compiles.
5. Negative: task closure captures `Win<M>` or `Runtime<M>` fails Send/Sync as expected; no unsafe escape hatch is accepted.
6. Parent dependency test remains separate: a valid borrow/scheduling proof does not justify skipping `View::view` when a hidden field or branch may affect output.

## Primary references and precise scope

- Rust 1.98.1 (official docs version as crawled 2026-09-01): [`std::thread::scope`](https://doc.rust-lang.org/stable/std/thread/fn.scope.html) says scoped threads can borrow non-`'static` data and are joined before return. It proves a lifetime pattern, not a persistent frame scheduler.
- Rust standard library 1.99.1 (2026-10-13): [`Sync`](https://doc.rust-lang.org/std/marker/trait.Sync.html) gives `&T: Send iff T: Sync`; [Rustonomicon Send/Sync](https://doc.rust-lang.org/nomicon/send-and-sync.html) explains `Cell`/`RefCell`/`Rc` are not thread-safe. These are the exact bounds the API uses.
- Rayon 1.12.0: [`scope`](https://docs.rs/rayon/1.12.0/rayon/fn.scope.html) explicitly warns scoped spawn tasks allocate on heap and prefer `join`/parallel iterators; [`ThreadPool`](https://docs.rs/rayon/1.12.0/rayon/struct.ThreadPool.html) describes a reusable pool and `install`; [`Scope::spawn`](https://docs.rs/rayon/1.12.0/rayon/struct.Scope.html) requires the task closure to be `Send + 'scope`. These support the mechanism only; no speedup claim transfers.
- Stylo 0.22.0 current docs: [style crate](https://docs.rs/stylo/latest/style/) states style traversal starts sequentially and optionally parallelizes as work is discovered. Servo's [layout 2020 report](https://github.com/servo/servo/wiki/Servo-Layout-Engines-Report) describes opportunistic tree parallelism constrained by floats/flow dependencies. This supports extracting coarse safe phases and serial fallback, not copying browser APIs or claiming GPUI benefits.
- GPUI local source: `/tmp/gpui-field-delivery-root/reactivity/crates/gpui/src/runtime/delivery.rs` and `remote.rs` for `with_inbox_for`; current checkout `crates/gpui/src/element.rs` for `El<'a>`/non-Send handler; `crates/gpui/src/runtime.rs` around `Runtime::prepare` for mutable TextSystem/shaper/Cephal measurement; `crates/canvas/src/canvas.rs` for borrowed `PreparedScene<'a>`, staged Canvas and typed display-list columns.

## Decision

Do not add a retained region graph merely to get parallelism. First identify a pure current dirty lane and establish the field-level `Sync`/output-field `Send` types; run the borrowed kernel inside a synchronous reusable-pool scope while owner mutation is excluded; consume its borrowed product in the existing scene/dirty/damage path. Keep text shaping, Cephal traversal, renderer/atlas mutation, source action routing, handlers, accessibility/inspector reconciliation, and publication on the owner thread. A user with no independent data lane gets no parallel path; the API must preserve that zero-work case.
