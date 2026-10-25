# Historical trait-table performance evidence (2026-10-07)

This snapshot predates the native value frontend and canonical schema discovery. Its timings certify that earlier source fingerprint only; current evidence is in [element-query-performance.md](../../docs/element-query-performance.md).

The production design moves discovery to query admission and carries exact native table references
in the resulting view. It does not remove admission cost: preparing a borrowed reflected view for
each four-call batch costs about as much as four repeated lookups in this fixture. Keeping the
prepared view makes the four-call batch about 2.7 times faster. A native capability view, including
its lookup and receiver projection, is about 2.1 times faster than repeated lookup here.

These are local CPU measurements, not a GPU rendering claim or a guarantee for arbitrary traits.
The experiments and rejected alternatives are summarized in
[`tooling/api-experiments/README.md`](README.md). The public API and its
limits are described in [`element-queries.md`](../../docs/element-queries.md).

## Environment and methodology

Measured on 2026-10-07 with `rustc 1.101.0-nightly (5c543b0b8 2026-09-29)`, `aarch64-macos`,
release builds, and the CPU `TestPlatform`; no GPU was involved. The local changes are based on
PR #296 at `8fe466f901a2e536e89549d3e07d9dd575bd67ea`, including PR #295. The checkout was dirty
because the redesign was deliberately kept local. Although the commands use
`--no-default-features`, benchmark dev-dependency feature unification enabled `font-kit`, `wayland`,
`x11`, and `windows-manifest`; the executable reports these observed features.

The tables below report Criterion **means** with 95% bootstrap confidence intervals, using 100
samples, one second of warmup, and three seconds of requested measurement time. The fixture checks
dispatch overrides and stored mutations. Selector workloads assert callback, layout, paint,
cached-render, and scene-quad counts outside measured intervals, including deferred trees.

```sh
cargo bench -p gpui-ce --features bench-support --bench reflection --no-default-features -- \
  reflection/query --sample-size 100 --warm-up-time 1 --measurement-time 3 \
  --save-baseline typed-query-full
cargo bench -p gpui-ce --features bench-support --bench selectors --no-default-features -- \
  'selectors/(matching/(all|missing_class)/256/64|frame/(fresh|cached|deferred)/lending|layout/(fluent|lending)/32/1)' \
  --sample-size 100 --warm-up-time 1 --measurement-time 3 --save-baseline typed-query-full
```

The layout filter also matches `32/16`. Run the full workload suite with `--quick` when checking
fixture assertions; use the longer sampling run to investigate timing differences.

## Dispatch and representation cost

| Workload | Mean | 95% interval | Included work |
| --- | ---: | ---: | --- |
| Resolve four reflected calls | 42.22 ns | 40.35–44.10 ns | Four lookups and concrete receiver dispatches |
| Borrow a reflected view, then four calls | 42.83 ns | 41.49–44.19 ns | Complete admission and table binding on every iteration |
| Native capability, then four calls | 20.40 ns | 19.66–21.14 ns | One lookup, concrete projection, and four native trait-object calls |
| Four calls on an already prepared view | 15.50 ns | 14.91–16.06 ns | Preparation outside the measured iteration; each call still checks its receiver |
| Tuple `Styled + ParentElement` loan | 51.63 ns | 49.56–53.65 ns | Admission, composition, table binding, and one style access |

The table record occupies 16 bytes for `Styled`, 32 bytes for a named `Styled + ParentElement`
group, 48 bytes for its tuple form, and 8 bytes for a capability. Tuples retain child records and
the merged builtin record, so the most convenient composition has a small, explicit storage
tradeoff. Each selector retains at most two schema records; it never retains a reference into a
matched node. Combining records reuses their already-bound builtin slots.

Cold metadata initialization allocates process-owned tables and generic discovery uses a shared
cache. Those costs are not included in the warm dispatch results. Scoped custom-trait `with`
currently rebinds its narrowed group, including inherited tables; it does not have the prepared
capability projection's lookup-free scope entry.

A same-binary admission repeat measured 40.04 ns (38.46–41.54 ns) for the reflected four-call loan
and 50.80 ns (48.94–52.69 ns) for tuple binding. A preceding local build measured tuple binding at
46.08 ns; the final full run flagged that increase statistically. The repeat supports reporting
the final tuple cost near 51 ns, rather than keeping the earlier, lower value. This comparison
does not isolate the source of the build-to-build difference; selector preparation is amortized
per schema, while the tuple microbenchmark deliberately pays it on every iteration.

## Selector workloads

| Workload | Mean | 95% interval |
| --- | ---: | ---: |
| Match all, 256 nodes × 64 rules | 166.53 µs | 160.67–172.30 µs |
| Missing class, 256 nodes × 64 rules | 177.95 µs | 173.54–182.19 µs |
| First layout, owned fluent callback, 32 nodes × 1 rule | 46.55 µs | 44.84–48.22 µs |
| First layout, borrowed callback, 32 nodes × 1 rule | 45.99 µs | 44.16–47.79 µs |
| First layout, owned fluent callback, 32 nodes × 16 rules | 138.98 µs | 133.09–144.80 µs |
| First layout, borrowed callback, 32 nodes × 16 rules | 126.21 µs | 121.01–131.30 µs |
| Fresh borrowed frame, 256 nodes × 4 rules | 1.223 ms | 1.174–1.271 ms |
| Cached borrowed frame, 256 nodes × 4 rules | 1.197 ms | 1.148–1.245 ms |
| Deferred borrowed frame, 256 nodes × 4 rules | 1.305 ms | 1.256–1.353 ms |

The one-rule owned and borrowed layout intervals overlap. The 16-rule fixture favors lending in
this run; both paths produce the expected effects. Styling a cached entity still forces its
subtree to rerender in this fixture, so the cached borrowed frame is not a cache-hit-only cost.

## Allocation checks and outlier tracing

Allocation counting runs separately from Criterion timing and only counts the measured operation
on the calling thread. Fixtures and metadata are warmed first.

```sh
cargo bench -p gpui-ce --features bench-support --bench reflection --no-default-features -- --allocations
cargo bench -p gpui-ce --features bench-support --bench selectors --no-default-features -- --allocations
GPUI_TRACE_ALLOCATION_BYTES=180224 cargo bench -p gpui-ce --features bench-support \
  --bench selectors --no-default-features -- --allocations
```

The measured reflected four-call loan, native capability four-call loan, tuple builtin loan, and
all 24 matching cases allocate **zero objects and zero bytes** after warmup. This covers the tested
groups; larger requirement lists can spill their inline storage, and application callbacks can
allocate independently.

The owned fluent and borrowed first-layout cases have identical allocation counts and bytes:

| Nodes × rules | Allocations | Bytes, for either callback form |
| --- | ---: | ---: |
| 32 × 1 | 82 | 19,548 |
| 32 × 16 | 212 | 46,868 |
| 256 × 1 | 536 | 162,036 |
| 256 × 16 | 1,562 | 375,724 |

In the final run, both callback forms measured 1,334 allocations / 542,756 bytes for fresh frames,
1,352 / 546,764 for cached frames, and 1,370 / 548,796 for deferred frames. The final static-group
admission gate adds 32 bytes across the four stored frame rules; layout and query-loan allocation
counts stay unchanged.

An earlier deferred-frame profile showed one extra 180,224-byte allocation for lending. The
opt-in allocator stack tracer located it at
`hdrhistogram::Histogram<u64>::record_n_inner → WindowProfiler::end_draw`, where the profiler grows
its duration histogram. On the trace rerun the same-sized growth occurred in the owned fluent
deferred case instead, while lending returned to its ordinary count. Another frame grew a different
histogram bucket. Frame allocation counts therefore include variable profiler capacity growth;
they do not establish a per-loan allocation cost. Stack capture disables the counting hook while
it allocates and runs only when explicitly requested.

Selector scope capture stays allocation-free for zero, one, and four rules. Sixteen and 64 rules
spill inline scope storage, allocating twice for 768 and 3,072 bytes respectively.

## Baseline comparison limits

The unchanged PR #296 checkout and this redesign were both run through the full reflection and
selector suites using Criterion's `--quick` mode. Those runs are useful correctness and direction
checks, but they are separate, short runs. An unrelated drawable-only erasure control changed
substantially between them, and an apparent missing-class regression disappeared in the longer
100-sample run. General layout or erasure speedups should not be attributed to this redesign from
those quick results. The dispatch comparisons above compare current implementations in the same
fixture with longer sampling; they support the narrower conclusion about prepared tables and
native capability access.

The captured means, confidence intervals, allocation requests, environment, and a fingerprint of
the modified source files are retained in
[`tooling/api-experiments/measurements.json`](measurements.json).
