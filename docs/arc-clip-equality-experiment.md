# Retained clip equality cost

`CoordinateSpace` derives `PartialEq` and contains `Option<Arc<ClipRegion>>`. `ClipRegion` also derives `PartialEq`, but does not implement `Eq`; it contains floating-point geometry. In the current Rust standard library, `Arc<T>::eq` short-circuits pointer-identical allocations only when `T: Eq`. For `PartialEq`-only values its fallback is structural equality. A `ClipRegion`’s `parent: Option<Arc<ClipRegion>>` repeats that comparison recursively.

That makes exact retained-view comparisons a real depth-dependent path: `ViewElementCacheKey` derives `PartialEq` over `CoordinateSpace`, and `view.rs` compares the previous and current keys during prepaint reuse. If the two keys contain clones of the same `Arc<ClipRegion>` chain, the derived comparison still reaches every equal clip node. `Window::with_coordinate_space` already uses the separate `CoordinateSpace::same_scope` pointer check, so this finding concerns the view cache key rather than that scope-entry path.

The std-only proxy in [arc-partialeq-chain.rs](experiments/arc-partialeq-chain.rs) mirrors the relevant layout: an outer mapping and a recursively parented clip record with float fields. It compares derived equality against a cache-style equality that first tests `Arc::ptr_eq`, then falls back to structural equality. A counted `PartialEq` implementation confirms same-allocation comparisons visit exactly 1, 16, 64 and 256 nodes at those depths. The paired timings are in [the raw run](experiments/arc-partialeq-chain-run.txt).

| Clip depth | Same-Arc derived median | Same-Arc pointer-fast median | Distinct equal-Arc derived median | Distinct equal-Arc pointer-fallback median |
| ---: | ---: | ---: | ---: | ---: |
| 1 | 13.80 ns | 6.34 ns | 13.68 ns | 7.06 ns |
| 16 | 71.28 ns | 2.35 ns | 163.76 ns | 234.73 ns |
| 64 | 633.57 ns | 2.35 ns | 409.79 ns | 349.98 ns |
| 256 | 4,222.56 ns | 2.34 ns | 3,258.98 ns | 5,272.10 ns |

The host load was unusually high and timing tails are wide, so use the visit counter for the exact complexity result and the timings only to show scale. Distinct-but-structurally-equal chains still require the full comparison and show no consistent pointer-fast-path benefit.

The adopted optimization reuses the existing `CoordinateSpace::same_scope` check in `ViewElementCacheKey::PartialEq`, before falling back to public structural equality. A scope's matrix and immutable clip allocation identify the retained geometry; inverse and raster density are derived from that matrix. The other cache-key fields still compare normally. This keeps structural fallback when a view rebuilds an equivalent chain, preserves public `CoordinateSpace::PartialEq` semantics, and adds no new equality abstraction or `Eq` implementation for float geometry. Cache comparison treats the same immutable clip allocation as unchanged, including invalid floating-point values within that allocation; a changed mapping or a different clip allocation still receives the normal comparisons.

The benchmark is a Rust standard-library and type-shape proxy, not a whole-view-frame measurement. It validates the derived equality behavior without compiling GPUI. The production optimization is separately covered by the retained-view camera invalidation tests.
