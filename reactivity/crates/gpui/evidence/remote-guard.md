# Static inbox cleanup guard comparison

The private exclusive `RuntimeMut` guard is adopted for storage/allocation and
lifecycle simplification. These samples support **no frame-time improvement**.

The baseline source is `fdfc505817` (query prerequisite `799c471ced`). The guard
source is the focused followup commit containing this artifact. It removes the
runtime revocation pointer, atomic owner lease, binding allocation and per-send
liveness read, and closes receivers before a faulting public call returns. The
empty chain's compile-time constant disables cleanup for ordinary windows.

## Exact workload and machine

The complete executable source is
[remote_delivery_measure.rs](../examples/remote_delivery_measure.rs). The same
file was copied into the baseline worktree. Both optimized executables were built
with `cargo build --release -p gpui --example remote_delivery_measure`, Rust
1.97.1, x86_64-unknown-linux-gnu, default release profile (opt-level 3; no workspace
release overrides), no native feature. GPUI release artifacts were removed before
each build so Cargo could not reuse the other worktree's package in the shared
target directory. Other unchanged dependencies were reused.

Host: AMD Ryzen 7 3700X, Linux, frequency boost enabled. The parent process set
`os.sched_setaffinity(0, {0})` before launching each child, so children inherited
CPU 0. This is a shared environment; CPU pinning does not isolate all contention.

Executables, SHA-256:

- Before: `41014f375bbe75af3eb03a0e9e6359199e4b3be0467c7741ba6c6d408ba01ca6`
- Guard: `2747ec975f2fb07242f641c1d38aa5b4517e483c6f4878020906f23b023d9fe7`

Processes ran in ABBA order, each with seven rounds. Round zero of each process
was warmup and excluded from medians: 12 measured rounds per variant. Raw data,
including warmups, is [remote-guard.csv](remote-guard.csv).

Each round measures:

1. 500,000 `try_send` calls against a capacity-zero bound channel; every value
   returns `Full`.
2. 10,000 batches of eight successful sends into preallocated storage. The timer
   covers enqueue only; the same production owner drains each batch outside that
   timer. The reported value divides elapsed nanoseconds by 80,000 messages.
3. 2,000 complete send → source/description/presentation barrier → CPU pixel
   materialization operations, alternating black/white on a 32×32 rectangle.
   This uses the actual headless `Win` and CPU renderer, with no font service.

The program checks the final source count. Existing native tests separately
compare production output and input/lifecycle behavior under CPU/GPU/Auto.

## Results

| Median | Before | Guard |
| --- | ---: | ---: |
| Full send | 9.556 ns | 9.766 ns |
| Successful enqueue | 10.582 ns | 10.465 ns |
| Complete send/source/render | 67.959 µs | 68.456 µs |

Timing is neutral for this decision. The render result does not show a win, and
this microbenchmark is not an application input-to-present latency measurement.

Allocation/size ledger, eight `u64` slots, measured separately:

| Storage | Before | Guard |
| --- | ---: | ---: |
| Empty Win | 8 B | 8 B |
| Retained runtime revocation slot | 8 B | 0 B |
| Headless Remote / Inbox | 24 / 64 B | 16 / 56 B |
| Headless channel/staging cold allocation | 4 allocations, 864 B | 3 allocations, 832 B |
| Native-enabled channel/staging cold allocation | 4 allocations, 904 B | 4 allocations, 888 B |
| Binding first inbox | 1 allocation, 24 B | 0 allocations |

The ledger unit prints these values with and without `--features x11`. Zero
allocation tests cover standard-channel/staging operations and idle turns with
no native wake attached. They do not measure attached Winit proxy/OS wake-posting
allocation. The real native tests prove bounded wake delivery and liveness, not
zero allocation inside native notifications.

Close releases queued payloads; channel backing and wake proxies can remain
leased by retained sender handles until all senders drop. Standard-library queue
capacity may include allocator/header rounding beyond the declared occurrence
bound. Application payloads, callbacks, retained descriptions, pixels and font
services retain their own separate costs.
