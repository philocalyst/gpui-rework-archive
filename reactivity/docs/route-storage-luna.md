# Sparse retained action routes

Read-only source audit of `/root/gpui-bench-luna/reactivity` at `c23b376d2b` (2026-10-21). No production changes or timing claims. The candidate below is a storage-layout proposal; its byte ledger follows the actual x86-64 Rust layouts and needs a paired release measurement before adoption.

## Current lifetime and authority

`runtime.rs` defines `Node { identity, parent, ordinal, content, component_scope, style, handler }` at lines 489–497. `Handler` is `Box<dyn Route>` (`element.rs:50–71`); `Option<Handler>` occupies 16 bytes on the current 64-bit target. The `Node` size test asserts 128 bytes (`runtime.rs:2789–2820`). `Content(u32)` holds the kind in three low bits and an encoded text-lane index above it (`runtime.rs:447–483`); six kind values are assigned, leaving 6 and 7 unused for the reserved Image/Scroll kinds.

The route is not an identity and must not be recovered from a function pointer. `describe_inner` validates the candidate handler against the current model and sources before reconciliation (`runtime.rs:1380–1408`), then replaces each node's handler with the handler produced by the new description (`runtime.rs:1601–1611`). The same identity may therefore receive a new callback on every description. Component wrappers and their owner-scope validation live inside the handler route (`element.rs:96–140`); `component_scope` prevents a site from surviving a change of owning component (`runtime.rs:1543–1560`).

Dispatch is current-logical-state-authoritative. `activate` resolves the target through the live identity map and then validates and invokes the current route (`runtime/turn.rs:194–222`). Hit testing, focusability, snapshots, and prepared action flags separately query route presence (`runtime.rs:1076–1082`, `2120–2128`, `2181–2188`, `2286–2295`; `runtime/input.rs:68–76`). Presented nodes store identity and frozen action flags, not a handler or route index. A position-free action from an older presented sheet is intentionally allowed to invoke the current callback at a surviving identity; tests exercise that rule and stale-target revocation (`native/accessibility/tests.rs:300–358`). Any route slot must consequently be rebuilt from current logical nodes and looked up through the current identity map. Storing a route slot in `Presented` would let an old sheet call a different current route after reorder or replacement.

## Candidate: dense handler column plus a packed live locator

Keep route payloads in one `Vec<Handler>` containing only nodes that currently have a route. Add one route-presence bit to `Content`; its kind plus current text slot uses at most 20 bits at the present 100,000-node bound. A high bit such as bit 31 can mark route presence while the text-slot decoder masks that bit. This keeps the existing 6/7 kind reservations and does not require an artificial 17-bit node cap. The constructor should validate the admitted slot count as it does now, and tests should decode every kind/text index with both route-bit values.

Change the existing `by_identity` value from `usize` to a private `NodeLocator { node: u32, route: u32 }`, where `u32::MAX` means no route. On x86-64 this remains exactly 8 bytes, matching the existing `usize` value. Build `Vec<Handler>` in node preorder as drafts are lowered. In the existing final `by_identity` rebuild, scan `nodes` once: map each identity to its node index and, when the `Content` route bit is set, the next route-vector index. Assert the route count matches the vector length. `MAX_NODES` is already capped at 100,000 and fits both `u32` indices.

The existing identity B-tree lookup then supplies both the logical node index and the direct route slot. Activation performs no second route search or map operation. The stored slot is only in the freshly rebuilt current logical map; `Presented` and native IDs remain identity-only. On 32-bit targets `NodeLocator` is 8 bytes while `usize` is 4, so this form adds 4 bytes per map value there; confirm 32-bit support policy or use the portable sorted-route fallback below for those targets.

Count click handlers during the existing draft-validation traversal, before reconciliation starts. After all recoverable validation has succeeded, clear the old route vector (dropping the old captures), call `reserve_exact(handler_count)` if its retained capacity is too small, and fill it while lowering. This reuses the allocation on ordinary updates and avoids a second old+candidate handler buffer. Each handler is moved once from its draft into the vector. `Handler` is not cloned, and method-item routes remain ZST boxes as documented in `element.rs:44–48`.

The current `describe_inner` has a useful transaction boundary: all recoverable `Result` failures from description, component/handler/source validation, and input registration occur before it takes `self.nodes` (`runtime.rs:1328–1450`). After that point it builds the candidate nodes and reaches the state swap without another `?` (`runtime.rs:1450–1744`); an unwind poisons the runtime in `describe_with` (`runtime/turn.rs:64–91`). This allows the route vector to be cleared and reused only after validation succeeds, then filled alongside the new nodes and published at the same commit point as `nodes` and `by_identity`. Keep a test or an explicit invariant around this no-recoverable-error boundary: adding a fallible return after clearing the route column would otherwise leave a valid old logical tree with its routes gone. A stricter rollback design can build a separate candidate vector and swap only on success, at the cost of temporarily retaining both old and new route capacities.

## Byte ledger and losing cases

On x86-64 the current per-node handler storage is `16N` bytes. The proposed node drops from 128 to an expected 112 bytes. The `by_identity` B-tree value remains 8 bytes; the new `Vec<Handler>` adds a 24-byte runtime header and `16C` bytes for route capacity `C` (usually the exact route count after the counted reservation). Estimated retained delta is therefore:

`new − old = 24 + 16C − 16N`

This excludes allocator metadata and unchanged B-tree keys/nodes. It predicts a gain of about 1.60 MB for 100,000 nodes with no click handlers, and about 0.80 MB at 50,000 handlers if capacity is exact. With every node interactive, it is about 24 bytes larger from the vector header. Tiny windows can also lose: a one-node handler-free window saves 16 bytes in nodes but adds the 24-byte vector header. Report live vector capacity, not just route count, in the actual allocator capture.

`Vec::with_capacity(handler_count)` avoids growth during this description, but reusing its capacity after `clear()` retains the high-water route allocation if a formerly dense view becomes sparse. `shrink_to_fit()` on every description would reintroduce copy/allocation churn. If this matters in a real workload, measure an infrequent shrink policy after large route-count falls; do not silently count retained vector capacity as freed. Captured callback payloads are still dropped immediately when the vector is cleared, so this is backing-capacity retention rather than a live-route/history leak.

Alternatives:

| Layout | x86-64 retained route storage | Lookup/lifecycle cost | Assessment |
|---|---:|---|---|
| Current `Option<Handler>` in every Node | 16N | Direct field access | Fastest direct access; pays for blank nodes. |
| Sparse `Vec<(u32, Handler)>` sorted by node index | about 24K plus 24-byte Vec header | Existing identity lookup, then binary search on activation | Portable/simple baseline; 24-byte entries include 4-byte index plus alignment. No per-node route index. |
| Sparse identity/handler pairs | about 24K plus header | Binary search by identity after current map lookup, or bypass that lookup with an independent search | Duplicates identity keys and keeps two lookup paths; no advantage over packed locator. |
| Dense `Vec<Option<Handler>>` | 16N plus header | Direct by node index | Same payload tax as the current field, so no per-node memory win. |
| `by_identity: BTreeMap<u64, NodeLocator>` + dense `Vec<Handler>` | 16K plus 24-byte header; existing map value stays 8 bytes on x64 | One existing B-tree lookup, then direct vector access | Best fit if the transaction/lifecycle invariant is kept. |

The packed locator is not a stale-target table: every description reconstructs `by_identity` from current nodes, while IDs are never reused. For list reorder, a stable row identity gets a newly assigned current node/route slot; an old P node still names that identity and therefore reaches the current route. For removal, the identity disappears from the map. For an owner-scope change, reconciliation mints a new identity before the new route slot is assigned. These three cases need explicit tests.

## Borrowing and dispatch

The owner already has exclusive `&mut Win`; native callbacks transfer owned actions and never borrow `Runtime`. Route invocation can borrow `handlers[route_slot]` immutably and `model` mutably as disjoint runtime fields, just as current activation borrows the handler and then mutates the model. Preserve the existing order: resolve target/current list membership, reject no-route, validate route against current model/sources, compute source epoch, invoke inside the current panic barrier, and poison on unwind. No `Rc`, `Cell`, per-route mutex, pointer-keyed global registry, or removal/reinsertion from a second map is needed.

The `Content` route bit is needed for the existing scan paths that ask whether a live node is actionable without invoking a callback. It also keeps hit-region creation, focusability, snapshot targets, and frozen `Presented::actions` in agreement with the same current-draft presence bit. The bit is a presence flag only; the `NodeLocator` route slot is the sole route address, and it is never copied into P.

## Primary implementation precedent and limits

Bevy ECS explicitly distinguishes table storage (cache-friendly dense iteration) from sparse-set component storage (fast insert/remove, slower iteration); it allows choosing per component rather than paying the component payload in every entity ([Bevy ECS 0.19.1 `StorageType`](https://docs.rs/bevy_ecs/0.19.1/bevy_ecs/component/enum.StorageType.html), [sparse-set storage API](https://docs.rs/bevy_ecs/0.19.1/bevy_ecs/storage/struct.ComponentSparseSet.html)). `hecs` describes dense contiguous component columns and recommends a specialized index beside the world when lookup criteria differ from entity iteration ([hecs 0.11.2 source/docs](https://docs.rs/crate/hecs/0.11.2/source/src/world.rs), [hecs README](https://github.com/Ralith/hecs/tree/0.11.2)). These are precedents for separating rare payloads from dense nodes and preserving the existing identity index. They do not establish this runtime's break-even point or prove the locator layout faster; that comes from the ledger and a benchmark.

## Release gates before adoption

1. Assert `size_of::<Node>() == 112`, `size_of::<NodeLocator>() == size_of::<usize>()` on 64-bit, and verify `Content` size remains 4. Keep a portable 32-bit compilation or deliberately document that target's extra locator bytes.
2. Exhaustively round-trip all `0..MAX_NODES` text slots with each current kind, route bit on/off, no text, and route-bit masking. Assert future kind codes 6 and 7 cannot overlap the route flag.
3. Exercise no handlers, one handler among many, all handlers, adding/removing handlers while identity survives, reorder of keyed rows, removal/reinsertion, and component-owner replacement. Assert route counts and every `NodeLocator` resolve to the handler installed by the current description.
4. Preserve the existing old-P/current-S action test. Add an old P action after a surviving site's handler is replaced and verify it invokes the replacement; then remove the handler and verify dispatch returns `NotInteractive`; remove the site and verify `StaleTarget`.
5. Test rejected description before reconciliation leaves old routes callable, and a caught panic in the destructive phase poisons the owner so no partially rebuilt route vector can be used.
6. Compare identical release binaries with: 100k blank nodes, 100k nodes/1 route, 50k routes, and 100k routes; plus repeated route-count grow/shrink. Capture `Node` bytes, `by_identity` allocation, handler-vector `len/capacity`, requested allocation/live bytes, description cost, hit/focus scan, and activate latency. Do not claim a win from `size_of::<Node>()` alone.
