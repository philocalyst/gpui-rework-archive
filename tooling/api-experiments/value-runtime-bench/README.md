# Value runtime microbench

This standalone crate imports `crates/gpui/src/reflection/value.rs` by path, so it benchmarks and tests the checkout's production implementation without building GPUI. It uses `inventory` for the runtime's linked type registrations. Cargo output goes to `/tmp/value-runtime-bench-target`. The latest exact-source results are in [Fresh audit run on 2026-10-08](#fresh-audit-run-on-2026-10-08); preceding tables retain their historical fingerprints.

Run it with:

```sh
CARGO_TARGET_DIR=/tmp/value-runtime-bench-target cargo test --release --manifest-path tooling/api-experiments/value-runtime-bench/Cargo.toml
CARGO_TARGET_DIR=/tmp/value-runtime-bench-target cargo run --release --manifest-path tooling/api-experiments/value-runtime-bench/Cargo.toml --bin bench
```

The tests include the production module's tests and cover duplicate enum field names, recursive `Vec` and `Option` traversal, a registered role with an associated type constraint, and replacing an opaque schema after its described form becomes available.

## Measurements

Captured on 2026-10-07 with Rust 1.98.1 (`48a229cea`, LLVM 22.1.8), Apple M3 Pro / arm64. Production source SHA-256: `09eafcd891aa4f68f61d0503a32b6548c70b7871571d564759d9e31169ca51ab`.

Four fresh-process release runs, each with 11 samples of 5,000,000 repeated mutations per operation. The table reports the median of those four per-process medians and their min–max range. Checksums matched in each field or role comparison. Every warm path asserted zero allocations per 100 mutations.

| Operation | Median ns/op (run range) | Allocations per 100 warm ops |
| --- | ---: | ---: |
| Native field borrow | 2.40 (2.14–2.94) | 0 |
| `Field::get_mut` typed handle | 2.56 (2.11–3.11) | 0 |
| `ValueMut::at` typed path | 3.30 (2.57–4.13) | 0 |
| `ValueMut::at` composed `then` path | 3.44 (3.01–3.72) | 0 |
| Two dynamic `field` lookups plus downcast | 45.51 (40.34–53.78) | 0 |
| Native trait-object role call (one registered role) | 2.35 (2.26–3.41) | 0 |
| `ValueMut::cast_mut` role call (one registered role) | 7.61 (7.13–9.33) | 0 |

Role lookup by schema size. The benchmark sorts each target's `TypeId` in process and selects the greatest ID, so `cast_mut` exercises the final entry in the runtime's sorted table. The selected marker tag is printed for reproducibility with the active toolchain.

| Registered targets | Native trait call, ns/op (run range) | `cast_mut`, ns/op (run range) | Allocations per 100 warm ops |
| ---: | ---: | ---: | ---: |
| 3 | 2.33 (2.25–2.97) | 8.95 (8.79–9.30) | 0 |
| 8 | 2.40 (2.29–2.41) | 11.81 (11.16–12.50) | 0 |
| 9 | 2.40 (2.36–2.57) | 21.15 (17.81–23.78) | 0 |
| 32 | 2.46 (2.26–2.57) | 24.45 (21.01–26.77) | 0 |
| 64 | 2.54 (2.23–2.87) | 27.11 (25.32–31.85) | 0 |

The cold `ColdNode` root schema build had a 3,042 ns median across the four processes (range 1,625–5,250 ns) and made 5 allocations each time; lazy child schemas were not resolved. Warm operation counts exclude schema setup and benchmark storage. The executable uses a custom allocator that counts allocations and reallocations.

## Repeated role calls

`ValueMut::cast_mut` returns a safe borrow tied to the exclusive borrow of the value. Resolve the role once, retain that `&mut dyn Trait`, and make repeated calls through it when the same role is used repeatedly. This skips repeated schema lookup, target `TypeId` checks, role-slot downcasts, and concrete-root downcasts without exposing raw pointers or vtables. Repeated `cast_mut` calls remain useful when each call needs a fresh role borrow, for example when interleaving accesses to other reflected children.

One additional release run on the same machine (Rust 1.98.1, Apple M3 Pro) measured the single-role case at 6.30 ns/op for `cast_mut` on every iteration and 2.54 ns/op after resolving the role once; the native trait call was 2.48 ns/op. In the multiple-role worst-target cases, repeated lookup ranged from 11.57 ns/op at 8 roles to 40.23 ns/op at 64, while resolving once ranged from 2.40 to 2.71 ns/op and native calls ranged from 2.31 to 2.71 ns/op. All checksums matched and every warm path asserted zero allocations per 100 operations. These are single-process medians of 11 samples, so treat the values as directional rather than a stable cross-run estimate.

## Stabilized API rerun

After moving child-shape functions from `Field::new` / `VariantField::new` to `into_schema`, the experiment was adapted and rerun on 2026-10-08 with Rust 1.98.1 on Apple arm64. Aggregate SHA-256 of sorted `crates/gpui/src/reflection/value.rs` and `crates/gpui/src/reflection/value/*.rs` contents: `dc37fec53a1563240e2788618407adb839274f258806395d27fd2cc3c8869327`. The earlier reports above retain their original single-file source fingerprint and remain historical measurements.

The stabilized-API run's worst-target role results (one process, 11 samples) were:

| Registered targets | Native trait call, ns/op | `cast_mut` each call, ns/op | Resolve once, ns/op |
| ---: | ---: | ---: | ---: |
| 3 | 3.87 | 20.05 | 3.61 |
| 8 | 3.18 | 16.08 | 2.98 |
| 9 | 3.46 | 35.54 | 3.37 |
| 32 | 3.56 | 50.44 | 2.99 |
| 64 | 3.00 | 60.14 | 3.76 |

Checksums matched and all warm paths reported zero allocations per 100 operations. Background system load varied during this run, so use the lookup-vs-cached gap as the useful signal and avoid comparing these absolute values directly with the earlier four-process report.

## Pre-discovery canonical-slot schema API rerun

The experiment was then adapted to the canonical `Schema<Root>` builder and rerun on 2026-10-08 with Rust 1.98.1 on Apple arm64. Aggregate SHA-256 of sorted `crates/gpui/src/reflection/value.rs` and `crates/gpui/src/reflection/value/*.rs` contents: `fe476f5f97fd3a2d98e3c92294e4f3080b29c0f9ade1a6b1a57957f7d26d9b40`. This fingerprint includes the production runtime tests. Earlier results and their source fingerprints above remain historical.

The new prepared-projection measurement calls `Type::role` once for the operation and then invokes `RoleProjection::get_mut` for each receiver. It avoids repeated role-table lookup while keeping the receiver check and projection on each call. One release process with 11 samples reported:

| Registered targets | Native trait call, ns/op | `cast_mut` each call, ns/op | Cached borrow, ns/op | Prepared projection `get_mut`, ns/op |
| ---: | ---: | ---: | ---: | ---: |
| 3 | 2.30 | 8.07 | 2.25 | 4.26 |
| 8 | 2.45 | 11.30 | 2.24 | 4.34 |
| 9 | 2.26 | 13.60 | 2.28 | 4.22 |
| 32 | 2.26 | 17.49 | 2.26 | 4.03 |
| 64 | 2.31 | 23.33 | 2.36 | 3.90 |

For the single-role workload, native / repeated `cast_mut` / cached borrow / prepared projection measured 2.58 / 7.71 / 2.38 / 4.59 ns/op. Each warm path asserted zero allocations per 100 operations and checksums matched. The cold `ColdNode` schema build took 38,625 ns and made 5 allocations. The cached borrow is fastest when many calls can share one exclusive borrow; the prepared projection is useful across successive receivers and cuts role-table lookup cost, while each call still checks the receiver and performs the safe projection. These absolute timings are one-process measurements and should be treated as local microbenchmarks.

The current hybrid remains close to linear lookup through 8 targets (11.81 ns at 8) and moves to binary search above that (21.15 ns at 9, 24.45 ns at 32, 27.11 ns at 64). The 8-to-9 jump is repeatable in this four-run set, though those values come from different schemas and do not isolate search alone. Prior unsorted-vector measurements on this host were 145 ns at 32 and 307 ns at 64; the previous one-role `HashMap` run measured 98.54 ns. Those are historical, noisy comparisons rather than controlled A/B results. The benchmark excludes construction and memory footprint and does not determine a production threshold. Dynamic field resolution remains much slower than typed paths because it searches names and checks erased types. Treat the figures as local microbenchmarks, not a GPUI workload forecast.

## Final discovery runtime rerun

The experiment was updated for automatic `inventory` type discovery, partial/full described containers, and the final schema API, then rerun on 2026-10-08. Aggregate SHA-256 of sorted `crates/gpui/src/reflection/value.rs` and every `crates/gpui/src/reflection/value/*.rs` file: `b091275a39dcf3c07d5f538b56c033b8128e2fe7a582ecf7fcd18413310e7840`. The hash includes `discovery.rs`, `sequence.rs`, and the production runtime tests. Earlier fingerprints and measurements remain historical, including the pre-discovery `fe476f5f...` slot-era report.

The prepared-projection case resolves `Type::role` once per operation, then calls `RoleProjection::get_mut` for each receiver. It avoids repeated role-table lookup while still checking and projecting every receiver. The release run reported these one-process, 11-sample medians:

| Registered targets | Native trait call, ns/op | `cast_mut` each call, ns/op | Cached borrow, ns/op | Prepared projection `get_mut`, ns/op |
| ---: | ---: | ---: | ---: | ---: |
| 3 | 2.64 | 19.58 | 6.33 | 7.20 |
| 8 | 3.77 | 17.41 | 3.04 | 5.13 |
| 9 | 3.43 | 53.68 | 4.03 | 10.47 |
| 32 | 3.88 | 31.92 | 3.25 | 31.80 |
| 64 | 6.10 | 47.45 | 3.32 | 7.16 |

The single-role workload measured 17.96 / 26.26 / 3.59 / 8.51 ns/op for native / repeated `cast_mut` / cached borrow / prepared projection. The cold `ColdNode` schema build took 48,667 ns and made 5 allocations. Checksums matched and all warm operations asserted zero allocations per 100 calls. The machine was under substantial unrelated compile and test load during this run, so these absolute timings are noisy and should not be compared with prior runs. They still show the structural costs of repeated table lookup and per-receiver checked projection, but a quiet-host run would be needed for tighter timing estimates.

## Fresh audit run on 2026-10-08

The current checkout's production-imported runtime was tested and benchmarked with Rust 1.98.1 (`48a229cea`, LLVM 22.1.8) on Apple M3 Pro / arm64. The release test command passed 19 unit tests and one compile-fail doctest. Build output used `/tmp/value-runtime-bench-target`, separate from the GPUI workspace target. The aggregate runtime fingerprint is `a0501ba8b47ab2c4277bf1d925ce766b254f497074c11c733ba58a5a80178f7b`; it is SHA-256 over `value.rs` and each `value/*.rs` file sorted by path, hashing each basename, a NUL byte, and its contents.

Three fresh release benchmark processes each ran 11 samples of 5,000,000 mutations per operation. Values below are the min–max of the three process medians (ns/op). Every warm operation asserted zero allocations per 100 operations. All field-path checksums matched (`1512505582500000`), and all role-path checksums matched (`330001111`). The role table was sorted by `TypeId` in each process and the greatest entry was selected; its printed marker tags were 2, 3, 3, 25, and 25 for 3, 8, 9, 32, and 64 registrations respectively.

| Registered targets | Native call | `cast_mut` each call | Retained role borrow | Prepared projection `get_mut` |
| ---: | ---: | ---: | ---: | ---: |
| 3 | 2.59–4.08 | 12.67–14.44 | 2.68–2.91 | 5.95–7.91 |
| 8 | 2.70–4.03 | 14.70–18.85 | 2.73–3.09 | 5.46–7.25 |
| 9 | 2.58–4.76 | 26.89–35.85 | 3.04–5.99 | 6.77–7.09 |
| 32 | 3.14–3.47 | 32.88–39.57 | 2.89–3.48 | 6.31–6.96 |
| 64 | 2.91–3.33 | 36.84–62.94 | 2.65–3.99 | 5.47–7.51 |

The field-path medians also had matching checksums and zero warm allocations in every process: native borrow 3.25–5.59 ns/op, typed handle 3.24–4.32, `ValueMut::at` 4.83–5.94, composed typed path 4.62–5.17, and two dynamic field lookups 77.79–97.20. Cold `ColdNode` schema setup made 5 allocations and ranged from 7,625 to 47,750 ns across processes.

Treat the timing ranges as a noise bound for this unpinned local machine, not as a controlled comparison or a production forecast. Even process medians moved substantially: 64-target repeated `cast_mut` ranged from 36.84 to 62.94 ns/op, and cold schema setup varied by over 6×. No cross-run speedup claim is supported. The stable correctness evidence is matching checksums and zero warm allocations; repeated role lookup does grow with the table sizes tested, while retaining a borrow or using a prepared projection avoids that repeated lookup.
