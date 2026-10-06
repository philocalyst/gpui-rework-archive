# Clip reduction experiment

This standalone, `std`-only prototype compares three ways to query nested affine rectangle clips: walk the original local-space chain with cached inverses, compile the intersection to one convex polygon, or remove clips proven redundant by a later clip. The source and raw outputs are [element-clip-reduction.rs](experiments/element-clip-reduction.rs), [run 5](experiments/element-clip-reduction-run-5.txt), [run 6](experiments/element-clip-reduction-run-6.txt) and [run 7](experiments/element-clip-reduction-run-7.txt); the command below writes a fresh output file under `/tmp`.

```sh
rustc --edition 2024 -C opt-level=3 docs/experiments/element-clip-reduction.rs -o /tmp/element-clip-reduction
/tmp/element-clip-reduction > /tmp/element-clip-reduction.txt
```

The test host was an Apple M3 Pro running macOS 15.7.4, `rustc 1.101.0-nightly (5c543b0b8 2026-09-29)`. The harness checks correctness before timing. It uses deterministic mixed hit/miss traces, 30 timing samples per query case and 500 per construction case, plus 400 randomized affine/fade chains × 1,280 points for the dominance check. Transforms include rotations, shears, reflections and scale; cases include identical clips, gradual containment, adversarial overlap, safe nested fades and active fades. The host was heavily loaded during the recorded runs, so the timings are directional microbenchmarks, not stable application-level speedups.

The useful simple rule is local and conservative: for a newly appended clip, map all four of its rectangle corners into the most recent retained ancestor’s local coordinates. Remove that ancestor only if every corner lies inside the ancestor rectangle inset by all four fade distances. An affine rectangle is convex, and the inset is convex, so corner containment proves the child’s entire support is in the ancestor’s alpha-one region. Keep checking backward while this holds; stop at the first ancestor that fails. This prefix-only operation preserves the original clip/fade records and needs no polygon representation or shader change.

| Synthetic chain | Original → prefix retained | Original → full-filter retained | Query median, original → prefix | Build median, prefix / full filter |
| --- | ---: | ---: | ---: | ---: |
| identical, depth 64 | 64 → 1 | 64 → 1 | 31.73 → 1.60 ns | 0.79 / 0.83 µs |
| safe nested fade, depth 16 | 16 → 1 | 16 → 1 | 7.13 → 1.60 ns | 0.21 / 0.25 µs |
| adversarial overlap, depth 64 | 64 → 63 | 64 → 11 | 15.41 → 13.92 ns | 0.79 / 3.88 µs |
| gradual containment, depth 64 | 64 → 62 | 64 → 62 | 38.45 → 33.73 ns | 0.79 / 8.08 µs |
| active fade, depth 64 | 64 → 64 | 64 → 64 | 29.48 → 29.37 ns | 0.79 / 8.54 µs |

Prefix pruning catches the common nested case while avoiding the full-chain rebuild cost. Full filtering can remove more old clips in the adversarial sequence, but it costs more to build and scales quadratically in this prototype. It is a poor default when the retained list is long and little is redundant. A depth-64 shear/reflection sequence retained all 64 clips under both rules; this confirms pruning is an optimization opportunity, not a replacement for exact traversal.

The convex-polygon experiment supports keeping the more complex representation out of the first implementation. In the gradual-containment depth-16 case the exact chain query was 14.20 ns and polygon query 14.80 ns; polygon compilation cost 12.46 µs. At depth 64 the polygon query was 19.02 ns versus 38.45 ns for the chain, but compilation cost 100.25 µs and the boundary grew to 49 vertices. These hard-edge query timings exclude fade multiplication. The shader’s current fades are independent local-space ramps multiplied together: replacing them with the final hard boundary changed alpha at 22,256 of 100,000 sampled points at depth 1, 17,554 at depth 4 and 12,936 at depth 16. Keeping all original fade terms gave zero measured alpha error.

The dominance proof was checked against both the original and prefix-pruned chains at 512,000 randomized points; hard membership and alpha agreed. A singular/non-finite mapping stays collapsed. Zero-area rectangles deliberately take the original-chain fallback in the polygon prototype because a closed line/point clip is not represented by the polygon fast path. For the production `f32` path, treat numerical uncertainty as a reason to retain an ancestor: require an inward margin when comparing transformed corners to the fade inset, rather than expanding the inset by a tolerance. The exact margin should be tied to the composed matrix and coordinate magnitudes, with edge-adjacent differential tests before adoption.

The production implementation adopts the prefix rule in `CoordinateSpace::clipped`.
Its inward margin uses both affine evaluations' absolute operation magnitudes,
with a factor of `32 * f32::EPSILON`; it retains ancestors when the mapping's
infinity-norm condition estimate exceeds 4,096. Empty child rectangles also retain
the original chain. Production tests compare the reduced chain against independently
recorded originals and cover active fades, shears, reflections and uncertain edges.
The timings above describe the standalone prototype, not this guarded builder.

Run 5’s timing spread is visible in its raw output: for identical depth 64, the original chain measured 31.73 ns (p10 30.99, p90 95.94), while prefix pruning measured 1.60 ns (p10 1.59, p90 6.75). Several p90 values show host contention, so the medians should not be treated as precise speedup promises.

The same source has an operation-only text-density check mirroring `TransformationMatrix::max_scale` and the current eighth-step bucket for one shared camera. It validates each recomputed bucket against the cached value, then times recomputation and cached reads. Run 7 showed about 2.23–2.28 ns per recomputation versus 0.65–0.75 ns per cached read across 512–10,000 glyph operations; the 100,000-operation read had a wider tail. This isolates math versus a cached scalar read; it says nothing about shaping, cache lookup, rasterization, or whole-frame text performance.
