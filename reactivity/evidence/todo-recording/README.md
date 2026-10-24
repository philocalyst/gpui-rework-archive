# Complete Todo model through ordinary recording operations

Source `5222d7cfb790ecee1a74e8fef297ed6afb9f04d2` adds only
`crates/gpui/examples/todo_recording_cost.rs`. The fixture uses the same
`support/todo_five.rs` model and View as the native five-framework benchmark.
It invokes public window typing, borrowed queries, clicks, scene access and
presentation acknowledgement. It allocates no diagnostic framebuffer.

Run from the Reactivity workspace:

```sh
cargo run --release --locked --offline -p gpui --example todo_recording_cost -- 10000
```

Seed, mount, every edit, acknowledgement and close have separate allocation
and wall-time records. Scene digests and production counters accompany each
stage. Type/Add/Complete/Active/Done/All/Delete/Undo execute in the established
order. After measurement, an independent expected model checks every row's
id, title and done flag, plus filter, draft, next id and deleted state. This
oracle covers empty, 1,000-row and 10,000-row initial models; it does not charge
its own JSON/expected-row allocations to the edits.

The original reviewed fixture, its complete-model successor and the exact Main
composition each passed all three sizes using fresh, frozen release ELFs.
Main strict release Clippy passed with 2,074 unchanged tracked build inputs.
The first incorrect close return type and an unused imported animation method
produced real compiler failures; both are preserved, along with the corrected
attempts. The animation implementation remains exercised by the native fixture.

The e509 complete-model ELF also ran on mothership, pinned to CPU 0 under the
exclusive shared host lock. All model results, scene digests and production
counters matched the local execution exactly at all three sizes. The unchanged
ELF used an explicitly recorded compatible glibc 2.44 loader and library path;
the loader listing and SHA256 are archived. Every owned process was reaped,
the lock released and the 8 GiB free-space floor preserved.

One 10,000-row mothership baseline mount requested **639,146 allocations /
129,538,561 bytes**, retaining **56,679,491 bytes** on the measured thread.
Mount took 962 ms, Add 948 ms and All 932 ms in that single recording run.
These figures diagnose work to remove. They are not repeated native benchmark
samples or performance wins. Main's IME composition adds eight retained bytes
at this fixture's mount with the same allocation count; that cost is preserved
in Main's separate raw run.

Recording excludes OS window creation, framebuffer rasterization, GPU work and
scanout. Allocation counters measure requested calling-thread bytes; they are
not allocator usable sizes or process RSS. Native latency and workload gates,
including the historical failed Heavy and five-framework cases, are unchanged.
No GPU utilization, smoothness or peer result is inferred from this fixture.

`result.json` catalogs source/build identity, actual executable hashes and
limits. `logs.tar.gz` preserves Main gates and runs, original failed attempts,
the exact example, runner helpers, mothership raw output and loader listing.
The three actual local ELFs remain at their recorded frozen paths. Mothership's
19 MB source/executable bundle remains at
`/home/miles/gpui-ce3-compute-20261024/evidence/heavy-recording-root-e509`.
This fixture adds zero shipping library lines and changes no dependency.
