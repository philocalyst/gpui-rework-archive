# Mutable retained-tree correctness oracle

This independent workspace contains clean-room implementation experiments.
The core and state defaults are dependency-free; native hosting and Cephal layout
are optional. [The plan](../../PLAN.md) and [experiment register](../../EXPERIMENTS.md) record
the architectural choices and their acceptance gates.
It does not add code or dependencies to the legacy GPUI workspace. Run:

```sh
cargo test --manifest-path reactivity/Cargo.toml
cargo clippy --manifest-path reactivity/Cargo.toml --all-targets -- -D warnings
cargo run --manifest-path reactivity/Cargo.toml --example retained_tree
```

The core separates editable topology (`Tree`) from optional spatial data
(`SpatialTree`). Tree nodes use arena-qualified generational identity, and child
order is explicit. This is a kernel primitive; authoring reconciliation by parent,
ordinal and kind, and List-owned identity, are subsequent layers. An explicit
`reparent` preserves identity. `NodeKind::{Native,WebView,NestedGpui}` records
embedding-site intent; it does not instantiate or communicate with a native host.

All code is safe Rust, enforced with `forbid(unsafe_code)`. An atomic, checked,
nonwrapping arena identity prevents ids from another tree or a previously dropped
tree aliasing new nodes. A recycled slot increments its generation; a slot with
exhausted generation is retired. Reparent validates both capabilities and the
ancestor chain before writing links. Subtree iteration, removal, transform refresh
and drop use flat storage and iterative traversal, including deep chains.

Spatial records are allocated only for explicitly declared Geometry. A wrapper
without geometry inherits its parent's coordinate mapping and has no bounds or
clip. Geometry transforms map local to parent, and parents compose outside children.
Bounds are conservative forward AABBs; hit testing inversely maps the point and
checks the local rectangle and each ancestor clip. Floating point corner and inverse
point evaluation and retained ancestor composition use f64 intermediates. A finite inverse need not be representable
as an f32 matrix for point mapping to succeed. Singular mappings have no surface or
hit region. Nonfinite geometry declarations fail without changing retained data.
Composition overflow or unrepresentable forward extents produces `MappedBounds::Unbounded`,
which promotes damage to the full viewport. `CoordinateSpace::bounds` is a convenience
for finite bounds only; damage uses the explicit mapped-bound result.

Mutation adds old subtree bounds, performs the edit, recomputes affected world
mappings, and adds new bounds. Damage is a conservative, lossy 64px tile cover;
it does not retain exact rectangles. Clips can reduce hit regions but are not used
to narrow damage. Repeated updates cannot grow a rectangle queue. Viewports above
1,048,576 tiles return Capacity rather than allocating an unbounded bitmap.
Only touched bitmap words are visited on clear or tile enumeration. No timer,
worker or pending mutation queue exists. Identical geometry/reparent no-ops and
failed validation do no subtree visits, proven by the mutation counter.

On the tested x86_64 Rust 1.97.1 target, `size_of` reports:

| Storage | Bytes | Allocation grain |
|---|---:|---|
| Public NodeId | 16 | Caller-held capability; not stored on every topology link |
| Tree header | 56 | One tree |
| Topology slot | 28 | High-water number of slots |
| Spatial slot directory | 4 | Per topology slot, only for SpatialTree |
| Declared geometry record | 120 | Dense; only nodes with Geometry; wide oracle mapping |
| Traversal scratch entry | 72 | High-water subtree depth on spatial mutations |
| Damage bitmap | 8 | Per 64 viewport tiles |
| Touched-word index | 8 | Per touched bitmap word, reused after clear |
| SpatialTree header | 208 | Includes Tree/Damage headers and vector handles |

These are payload sizes, not allocator/RSS claims. Vector capacity, including spare
capacity, is reported by `allocated_bytes`; allocator headers, stack temporaries
and the struct header itself are excluded. Removed slots enter an intrusive free
list; geometry records swap-remove and update their directory. Vector capacity and
scratch high-water capacity are retained for reuse, not automatically reclaimed.
A topology-only Tree pays neither the directory nor spatial/damage storage.

Insertion and link edits are O(1), cycle checking is O(ancestor depth), and removal
is O(subtree size) with no temporary node queue. Spatial mutation visits affected
nodes and uses O(depth) reusable scratch. Locating an inherited mapping through
geometry-free ancestors is O(depth). Hit testing is a linear preorder scan that
tests each clip once and prunes rejected subtrees; it does not repeat every
ancestor test for every candidate. `query_hit` reports visits. There is no tile
hit index or paint-store cache here.
No final performance claim from the design microbenchmarks is inherited by this spike.

Validation includes 18,000 randomized topology edits against a separate adjacency
oracle, 700 randomized spatial mutations against from-scratch f64 matrix composition,
5,600 independent inverse-hit queries, old/new damage pixel coverage, 100,000-node
deep topology removal/reuse, 30,000-node spatial refresh/removal, rotated ancestor
clips, foreign/stale ids, sparse-record relocation, repeated damage bounds, and
large-forward/tiny-inverse numerical regressions. Additional review tests cover
sub-ULP damage at tile boundaries, 20,000-level hit-query work, and an ancestor
scale chain that underflows in f32 before later scales recover visible geometry.
This correctness oracle pays for wide mappings; sparse coordinate-space
experiments target its retained cost.

The default feature is a mutable retained-tree oracle. Optional `layout` adds
the shared-topology serial Cephal correctness adapter, with interned styles,
lazy caches, unrounded output and panic poisoning. It is not a presentation
sheet. Atomic runtime epochs, authoring/reconciliation, rendering and native
embedding are subsequent layers that must publish coherent immutable outputs.
