# Element transform benchmarks

The benchmark target separates small geometry-path experiments from scene construction and GPU submission. Run the CPU suite in the bench profile with default GPUI features disabled:

```sh
cargo bench -p gpui-ce --bench element_transforms --features bench-support --no-default-features
```

Append `-- --scenes-only` to run only the stable `Scene` insert/replay workloads. Those use 100 quads, 100 frames for the small replay case, and 10,000 quads, 10 frames for the larger replay case. The full suite also compares inverse-per-candidate against a precomputed inverse, exercises exact transformed clip chains at depths 0, 1, 4 and 16, validates answers and visit counts before timing, checks the axis-aligned shortcut against the exact reference for positive axis-aligned transforms, and measures the existing eighth-step raster-scale policy on deterministic zoom traces.

For comparisons against a revision without affine coordinate-space APIs, the same source has a scene-only build mode that compiles out the newer APIs. Build it through a small Cargo package pointing `gpui` at the desired checkout, with the benchmark file as its binary path, then run:

```sh
CARGO_TARGET_DIR=/path/to/shared/target cargo rustc \
  --manifest-path /path/to/scene-benchmark/Cargo.toml \
  --profile bench --bin element_transforms -- \
  -C opt-level=3 --cfg gpui_scene_only
/path/to/shared/target/release/element_transforms --scenes-only
```

## Recorded CPU run

Recorded on an Apple M3 Pro (`aarch64-apple-darwin`) with `rustc 1.101.0-nightly (5c543b0b8 2026-09-29)`, the bench profile, default features disabled, 30 timed samples after warmup, fixed seed `0x2732026`. The measured CPU scene implementation corresponds to the geometry committed in `cd388bf8b1dd15e63772a2e3b7dc2cdb0fa5cdd0`; the baseline source snapshot was `b5aceefaf96af3946ff26a603e5f4110d4bdf4ca`. These scene workloads do not compile or time the complete final shader implementation. Values below are median and p10–p90 nanoseconds per reported operation.

| CPU workload | Current median (p10–p90) | Baseline median (p10–p90) |
| --- | ---: | ---: |
| Insert and finish, 100 quads | 201 (198–718) | 205 (195–574) |
| Replay and finish, 100 quads × 100 frames | 212 (198–331) | 207 (190–248) |
| Insert and finish, 10,000 quads | 732 (648–826) | 717 (649–890) |
| Replay and finish, 10,000 quads × 10 frames | 743 (685–816) | 716 (668–901) |

The post-culling scene-only measurements are close to the baseline medians, with substantial tail variation in the small-scene runs. They do not isolate coordinate-space interning because these workloads use identity-space quads. Run-to-run variation is material, so these values are diagnostic rather than a stable regression claim.

The matrix microbench isolates affine point mapping, not the whole pointer-dispatch path. For a 10,000-node scan across 64 deterministic events, computing each candidate inverse inside the scan measured 8.54 ns/candidate (8.11–8.96); reusing the precomputed inverse measured 1.97 ns/candidate (1.86–2.52). A 100-node/256-event case measured 7.35 (7.32–13.44) and 1.66 (1.62–2.61), respectively. Exact 16-clip containment on rotated chains measured 60.77 ns/event (60.02–96.56) when inverting each clip for each point and 20.38 (20.33–36.96) with cached inverses; a mixed inside/early-miss/late-miss trace measured 46.12 (46.05–73.54) and 15.66 (15.61–28.77). The AABB timing is only a geometric baseline; it does not preserve rotated clip semantics.

The current `element_transforms` target also pairs the actual `CoordinateSpace::raster_scale()` getter against recomputing the camera’s maximum stretch and eighth-step bucket per operation. Each iteration black-boxes the matrix or the `CoordinateSpace` reference before the operation, preventing constant folding or a hoisted getter load. At production HEAD `34bc8a29e8e52ec28f1f26ae3665aae3239702b8` with the benchmark changes uncommitted, variant A (recompute) versus B (cached getter) measured:

| Shared camera operations | Recompute median (p10–p90) | Cached getter median (p10–p90) |
| --- | ---: | ---: |
| 512 | 2.28 ns (2.20–2.36) | 0.73 ns (0.65–0.73) |
| 10,000 | 2.23 ns (2.22–2.25) | 0.72 ns (0.70–0.74) |
| 100,000 | 2.23 ns (2.21–2.82) | 0.73 ns (0.70–0.74) |

This scalar-operation benchmark validates that the cached getter returns the same bucket, but does not measure glyph shaping or rendering. The corrected run had a host load of 22.72 / 20.09 / 23.41. Raw methodology and values are in [raster-density-production-run-2.txt](experiments/raster-density-production-run-2.txt). Run 1 is preserved as a superseded experiment: its cached scalar lacked an opaque input reference and could be hoisted, so it is not a valid getter comparison. The deep convex-clip and prefix-pruning experiments are standalone geometry microbenchmarks documented in [element-clip-reduction-experiment.md](element-clip-reduction-experiment.md), not calls into the private production clip builder.

For four deterministic 100,000-frame zoom traces and device scales 1, 1.5 and 2, the current `ceil(max(zoom, 1) * 8) / 8` scale policy produced 25 distinct effective scale values. The maximum upward raster oversampling was 12.5% (p95 5.7–6.2%). These are scale-error and bucket-transition measurements, not rendered image-quality results.

## Mapping-only parent traversal

The production scene stores the complete composed matrix on each active space.
Parent links skip mapping-only records, so coverage traversal depends on clip
depth rather than transform depth. Run the isolated CPU proxy with:

```sh
cargo bench -p gpui-ce --bench element_transforms --features bench-support --no-default-features -- --parent-walk-only
```

The [source](experiments/element-mapping-chain.rs) builds real production `Scene`
records and reconstructs the former parent links on a copy of those records. It
checks visit counts, retained clip IDs/order and clip metadata before timing 30
alternating paired samples of 10,000 probes. It does not execute GPU shaders,
evaluate clip alpha or build an older commit. The table retains the same number
of records; only the parent walk changes.

| Transform depth / clips | Records visited, former → current | CPU proxy median, former → current |
| --- | ---: | ---: |
| 8 / 0 | 8 → 1 | 5.85 → 1.12 ns |
| 64 / 0 | 64 → 1 | 158.41 → 1.19 ns |
| 256 / 0 | 256 → 1 | 249.31 → 1.14 ns |
| 64 / 8 | 72 → 9 | 176.41 → 8.81 ns |
| 256 / 32 | 288 → 33 | 209.30 → 53.40 ns |

[The raw run](experiments/element-mapping-chain-run.txt) records wide timing tails
under host contention. These timings describe a CPU traversal proxy; the exact
visit-count reduction is the relevant structural result for the shader.
[A repeat through the durable harness](experiments/element-mapping-chain-run-2.txt)
passed the strengthened clip-order assertions and reproduced those visit counts;
its timing spread is recorded separately.

## GPU submission target

`gpui_wgpu`'s `renderer` benchmark includes `coordinate_spaces_render_wait`: 512 identity quads, a shared pan/zoom transform on 512 quads, and nested rotated clip chains at depths 1, 4 and 16. Each timed iteration uses `render_scene_and_wait`, which waits for GPU completion without a readback. Criterion reports each case separately; the harness does not interleave variants in one paired timer.

Run the renderer benchmark with `cargo bench -p gpui_ce_wgpu --bench renderer --features test-support -- coordinate_spaces_render_wait --noplot`.

Recorded on macOS 15.7.4 with the Apple M3 Pro 14-core GPU (system-reported Metal 3), using the same Rust toolchain above and 30 Criterion samples per case:

| GPU submission and wait workload | Criterion estimate |
| --- | ---: |
| Identity, 512 quads | 1.703 ms (1.558–1.908) |
| Shared pan/zoom, 512 quads | 1.775 ms (1.634–1.965) |
| Rotated nested clips, depth 1, 512 quads | 2.039 ms (1.750–2.324) |
| Rotated nested clips, depth 4, 512 quads | 2.693 ms (2.260–3.188) |
| Rotated nested clips, depth 16, 512 quads | 1.915 ms (1.837–2.008) |

These intervals overlap and the point estimates are non-monotonic with clip depth. That result does not establish a clip-depth cost curve: this end-to-end test includes fixed command submission and GPU completion wait, and Criterion reported 3–5 outliers for four of the cases. The adapter driver string was not emitted by this benchmark. The measured binary used geometry equivalent to `cd388bf8b1dd15e63772a2e3b7dc2cdb0fa5cdd0`, built before the later atlas guards, clip-distance reconstruction and antialiasing refinements; it is not an exact build or performance claim for the final source.

The source retains the workload and methodology. Raw CPU and GPU output logs are also available in the benchmark host's `/tmp/gpui-transform-bench/` directory, but the tables above are the durable results record.
