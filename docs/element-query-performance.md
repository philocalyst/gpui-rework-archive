# Native query performance evidence

The current frontend borrows ordinary Rust values. Typed fields and method descriptors compile to
native access; structural `ValueMut` construction resolves a cached schema handle, and named
lookup checks child descriptors and types. Native roles can be resolved once: a retained role
lends one receiver, while a prepared projection checks successive receivers. The measurements below keep those costs separate.

These are local CPU fixtures, with no GPU work and no general rendering speedup claim. The source
fingerprint is `1732c87d0004e321aa08e4862273d86b8dda3d39b6d5e8961090123dacf2edf9`; the exact commands, per-file hashes, confidence intervals,
allocation requests, and environment are in [native-measurements.json](../tooling/api-experiments/native-measurements.json).
The [consumer guide](element-queries.md) explains the API; the
[experiment record](../tooling/api-experiments/README.md) records the alternatives.

## Methodology

Measured on October 8 with `rustc 1.101.0-nightly (5c543b0b8 2026-09-29)`, Apple M3 Pro,
`aarch64-macos`, release builds, and CPU `TestPlatform` for selector workloads. The checkout is
based on PR #296 at `8fe466f901a2e536e89549d3e07d9dd575bd67ea`, including PR #295, and deliberately remains uncommitted.
Commands use `--locked --no-default-features --features bench-support,test-support`; benchmark
dev-dependency feature unification also enables `font-kit`, `wayland`, `x11`, and
`windows-manifest`, as reported by the executables.

The tables report Criterion means followed by 95% bootstrap confidence intervals, using 100
samples, one second of warmup, and three seconds of requested measurement per case. Other
worktrees were compiling during this session, so absolute timings are subject to host contention.
No comparisons to the earlier build are used to claim improvements.

```sh
cargo bench --locked -p gpui-ce --no-default-features --features bench-support,test-support \
  --bench reflection -- reflection/value --sample-size 100 --warm-up-time 1 \
  --measurement-time 3 --save-baseline native-frontier-oct8
cargo bench --locked -p gpui-ce --no-default-features --features bench-support,test-support \
  --bench selectors -- \
  'selectors/(layout/(native|native_style|native_path|native_role|native_view|lending)/32/(1|16)|frame/(fresh|cached|deferred)/(native_role|native_view|native_path|lending))$' \
  --sample-size 100 --warm-up-time 1 --measurement-time 3 --save-baseline native-frontier-oct8
```

## Native fields, methods, and trait views

| Operation | Mean (95% interval) | Included work |
| --- | ---: | --- |
| Native method | 2.51 ns (2.46–2.56) | One direct method call |
| Native typed field | 2.61 ns (2.55–2.67) | Typed field getter and mutation; no runtime schema |
| Typed path through `ValueMut` | 5.15 ns (4.97–5.34) | Construct borrowed runtime value, downcast root, access field |
| Composed path through `ValueMut` | 6.06 ns (5.53–6.68) | Construct value, downcast root, compose two field borrows |
| Named field through `ValueMut` | 21.31 ns (20.47–22.24) | Construct value, resolve name and child schema, checked downcast |
| Resolve native role and call | 13.91 ns (13.46–14.36) | Construct value, look up role adapter, project receiver, call |
| Typed method descriptor | 2.74 ns (2.62–2.92) | Copy descriptor and make a native call |
| Retained native role borrow | 2.63 ns (2.57–2.70) | Borrow and lookup outside timing; one trait-object call |
| Prepared native role projection | 5.53 ns (5.38–5.69) | Lookup outside timing; check each receiver and call |

The fixture verifies the stored mutation for each operation. Typed native paths do not need
runtime discovery. `ValueMut::new` calls `Describe::type_shape`; generated monomorphic types
cache that handle in a static `LazyLock`. These fixtures measure that cached path. Generic
implementations and direct `Type::of` calls use the canonical `TypeId` registry; a retained
borrowed value or `ValueMut::from_parts` with an already resolved `Type` avoids repeated registry
lookup for those cases. Prepared role projections retain immutable adapters,
never receiver addresses. Their checked borrow still rejects a different concrete root.

A separate [production-runtime audit](../tooling/api-experiments/value-runtime-bench/README.md#fresh-audit-run-on-2026-10-08)
runs role tables with 3, 8, 9, 32, and 64 entries in three fresh processes. It verifies mutation
checksums, zero warm allocations, and the linear-to-binary lookup boundary. Its smoke timings
use a different harness and must not be compared numerically to these Criterion means.

## Selector layout and frame workloads

Each path below performs equivalent text-style edits. First-layout fixtures have 32 nodes and
one or sixteen rules. They assert callback and layout counts outside the measured interval.

| Callback | 1 rule: mean (95% interval) | 16 rules: mean (95% interval) |
| --- | ---: | ---: |
| Concrete callback | 63.11 µs (60.58–65.58) | 184.43 µs (167.09–206.24) |
| Native text-style borrow | 62.94 µs (58.99–67.21) | 176.85 µs (169.66–183.87) |
| Typed field path | 80.45 µs (69.32–95.37) | 173.41 µs (164.86–181.74) |
| Discovered native role | 63.68 µs (59.24–69.67) | 181.99 µs (170.33–195.49) |
| Explicit native view | 66.03 µs (60.81–72.63) | 170.45 µs (164.18–176.55) |
| Legacy reflected loan | 66.95 µs (62.34–72.49) | 156.50 µs (146.17–167.35) |

A focused same-binary repeat of the sixteen-rule pair measured concrete callbacks at
157.25 µs (149.24–165.57) and legacy loans at
173.86 µs (168.13–179.87). That reverses the full run's ordering.
These busy-host runs therefore do not establish a stable relative layout ranking. Both sets
of means and intervals are retained in the JSON.

Frame fixtures have 256 nodes and four rules. They assert render, cached-render, callback,
layout, paint, and scene-quad counts, including deferred trees. The cached mutation workload
rerenders the affected subtree; its cost is not a cache-hit-only draw.

| Callback | Fresh: mean (95% interval) | Cached: mean (95% interval) | Deferred: mean (95% interval) |
| --- | ---: | ---: | ---: |
| Discovered native role | 1.75 ms (1.69–1.82) | 1.86 ms (1.80–1.92) | 1.83 ms (1.74–1.91) |
| Explicit native view | 1.80 ms (1.72–1.88) | 1.83 ms (1.75–1.93) | 1.71 ms (1.56–1.88) |
| Typed field path | 1.83 ms (1.77–1.90) | 1.80 ms (1.74–1.86) | 1.78 ms (1.70–1.86) |
| Legacy reflected loan | 1.74 ms (1.66–1.81) | 1.98 ms (1.84–2.16) | 1.92 ms (1.85–1.99) |

## Allocation profiles

Allocation counting runs separately from timings and records system allocation/reallocation
requests and requested bytes on the calling thread, after metadata and fixture warmup.
The selector command uses Criterion test mode: every fixture assertion runs once, without the
profiling mode's one-second calibration per case. Sampled timing commands are unchanged.

```sh
cargo bench --locked -p gpui-ce --no-default-features --features bench-support,test-support \
  --bench reflection -- --allocations
cargo bench --locked -p gpui-ce --no-default-features --features bench-support,test-support \
  --bench selectors -- --allocations
```

All eight profiled native value operations allocate **zero objects and zero bytes** after
warmup: direct methods, typed fields, erased typed paths, nested paths, named fields, native
role resolution, method descriptors, and prepared role projections. The retained role timing
case has no separate production allocation profile. The isolated runtime audit covers retained
role borrows independently. Zero warm allocations is not a cold initialization claim.

The faster command covers the same 105 selector allocation cases as the earlier profiling-mode
run, with identical non-frame totals. Only whole-frame totals differed between modes.
First-layout allocations include normal layout bookkeeping and stored rules:

| Callback | 32 nodes × 1 rule: requests / bytes | 32 nodes × 16 rules: requests / bytes |
| --- | ---: | ---: |
| Concrete callback | 82 / 19,548 | 212 / 46,868 |
| Native text-style borrow | 82 / 19,548 | 212 / 46,868 |
| Typed field path | 82 / 19,548 | 212 / 46,868 |
| Discovered native role | 82 / 19,548 | 212 / 46,868 |
| Explicit native view | 82 / 19,548 | 212 / 46,868 |
| Legacy reflected loan | 82 / 19,548 | 212 / 46,868 |

The JSON retains every matching, layout, frame, and scope-capture allocation case, including
unselected timing controls. Whole-frame counts include tree construction, profiler capacity
growth, and rendering state. Earlier stack tracing identified a 180,224-byte outlier in
`hdrhistogram::Histogram::record_n_inner → WindowProfiler::end_draw`; it moved between callback
forms on rerun. Frame allocation totals therefore do not establish a per-loan allocation cost.
Large rule lists can spill inline storage, and user callbacks can allocate independently.
The reflection executable's cold `linked`/`generic`/`empty` samples measure the legacy table
runtime, so they are not reported as structural type-slot initialization costs.

## Validation and historical evidence

The production pass includes 452 library tests, 32 public consumer tests across eight fixtures,
28 macro unit tests, all 32 rejection probes, both tutorial examples, scoped formatting, and
Clippy checks. Benchmark Clippy allows only the nightly's deprecation of existing profiler
`fetch_update` calls; dependency lints are excluded. See [testing](element-api-testing.md)
for exact commands and the read-only review of the sibling testing infrastructure.

The earlier capability/table measurements remain in
[legacy-performance-oct7.md](../tooling/api-experiments/legacy-performance-oct7.md) and
[measurements.json](../tooling/api-experiments/measurements.json). They describe a prior design
and fingerprint; their ratios and quick baseline runs are not evidence for this native frontend.
