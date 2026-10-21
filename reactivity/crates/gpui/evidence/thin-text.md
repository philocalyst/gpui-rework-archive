# Thin retained UTF-8 leases

This changes only private, immutable retained text to `SharedText(arcstr::ArcStr)`.
Borrowed author operands, public APIs, font faces, glyph masks, backend resources,
source values, and owned `SetError<T>` payloads keep their previous types. The
benefit is storage, with measured preparation/edit regressions reported below;
this is not a general frame-time improvement.

## Baseline and method

The baseline is `0c3dd8b3e1` plus finalized shape-storage commits
`602fbfa262`, `75f76ed34d`, and `cb3ce8db8d`; the local cherry-pick HEAD is
`d88f1a3f82`. It already has the dense text lane and all seven audited inline
annotations. Its retained text is **Triomphe 0.1.16 `Arc<str>`**, with an 8-byte
allocation header, not a standard-library Arc's 16-byte header.

Captured on Linux x86-64, AMD Ryzen 7 3700X, Rust 1.97.1. Release defaults
(`opt-level=3`, no LTO, no custom RUSTFLAGS/profile environment), one process at
a time, pinned to CPU 0. The driver alternates variant ordering. Root and Color
work paused heavy jobs during the later repeat windows. These are process-local
timings, not a controlled CPU-frequency or whole-system benchmark. All durations
include the thread-local allocation counter in both variants. Proof queries and
pixel digests run outside the timed closure. CPU fixtures include actual
`with_pixels` rendering in that closure; recording fixtures do not allocate a
CPU framebuffer. One identical owner is warmed and dropped before measurement.

`immutable_text_measure.rs` is byte-identical between variants (SHA-256
`f522acaacd741cd0f997b6af27dd0d68ff98ffd4938a1d404c6ed27f02c32133`). Source
Strings and their label Vec exist before counters start and are excluded from
retained bytes; the final drop checks their separately known released capacity.
Bytes are allocator **requests**, not allocator usable sizes or RSS. Each phase
also verifies semantic content, epoch/ack behavior, and actual promotion,
comparison and paint counts. CPU output digests match between variants.

Reproduce after copying the same fixture source to a clean baseline checkout:

```sh
source /tmp/gpui-native-env.sh
CARGO_TARGET_DIR=/tmp/gpui-thin-text-target cargo build -p gpui --release --example immutable_text_measure
# Save each variant's binary before switching source checkouts. Clean gpui's
# release artifacts when reusing a target directory across those checkouts.
python3 crates/gpui/examples/support/thin_text_compare.py 5 \
  triomphe=/path/to/baseline thin=/path/to/candidate > paired.csv
THIN_END_FIXTURE=2 python3 crates/gpui/examples/support/thin_text_compare.py 15 \
  triomphe=/path/to/baseline thin=/path/to/candidate > sparse-repeat.csv
CARGO_TARGET_DIR=/tmp/gpui-thin-text-target cargo rustc -p gpui --release \
  --example text_lease_measure -- --emit=asm,link
python3 crates/gpui/examples/support/thin_text_compare.py --clone 9 \
  /path/to/text_lease_measure > clone.csv
```

Raw captures are `thin-text-paired.csv` (1,020 rows, 17 fixtures, five pairs),
`thin-text-sparse-repeat.csv` (360 rows, 15 pairs of the first two fixtures),
`thin-text-clone.csv` (288 rows, nine alternating runs), and
`thin-text-guard.csv` (384 rows, eight four-variant repeats; experiment below).
The driver's fixture table is the authoritative workload definition.

## Storage, including the larger allocation header

Measured compiler sizes on this baseline:

| Private type | Triomphe | SharedText |
| --- | ---: | ---: |
| Text lease / Option of lease | 16 / 16 | 8 / 8 |
| Node | 136 | 136 |
| TextSite / Option<TextSite> | 80 / 80 | 72 / 72 |
| Presented | 88 | 80 |
| Logical semantic declaration | 40 | 24 |
| Frozen semantic text entry | 24 | 16 |
| Metadata / Runtime<()> | 240 / 2328 | 240 / 2328 |
| El / DraftNode / borrowed Text | 184 / 160 / 24 | unchanged |

Triomphe requests `round_up_8(8 + UTF8_bytes)`; ArcStr requests `16 + UTF8_bytes`
for nonempty strings. ArcStr therefore spends **1–8 extra bytes per distinct
nonempty allocation**, with 8 extra for lengths divisible by 8. Empty ArcStr is
immutable static storage and allocates nothing (baseline requests 8 bytes).
Tests measure actual requests: lengths 0, 3, 8, 23, 24, 25, 64, 6 (multibyte),
4096 give Triomphe/ArcStr bytes respectively
`8/0, 16/19, 16/24, 32/39, 32/40, 40/41, 72/80, 16/22, 4104/4112`.
Allocator size classes may change the physical result; no RSS reduction is
inferred from these request counts.

Saved capacities are 8 bytes per text-site slot, 8 per presented row in **each**
retained sheet, 16 per logical semantic declaration, and 8 per frozen name or
description entry. Subtract the distinct-allocation growth above; count a shared
payload once, even when several fields or sheets hold it. The cold metadata
headers and fanout indexes do not change. An absent semantic extension stays
absent, and no pointer is added to ordinary Node or El.

Actual mount-retained requested bytes (full runtime/layout/scene, not just text):

| Fixture | Triomphe | Thin | Saved |
| --- | ---: | ---: | ---: |
| 100,000 nodes, no text | 44,802,700 | 44,002,700 | 800,000 |
| 10,001 nodes, ten direct visual ports | 5,010,988 | 4,930,903 | 80,085 |
| 1,000 distinct 3-byte visual labels | 1,098,399 | 1,085,391 | 13,008 |
| 1,000 distinct 8-byte visual labels | 1,254,659 | 1,246,651 | 8,008 |
| 1,000 distinct 24-byte visual labels | 1,503,075 | 1,495,067 | 8,008 |
| 1,000 distinct 25-byte visual labels | 1,511,075 | 1,496,067 | 15,008 |
| 10,000 direct names sharing one source | 5,706,828 | 5,386,828 | 320,000 |
| 10,000 distinct names and descriptions | 6,200,732 | 5,860,724 | 340,008 |
| 512 nodes, visual/name/description sharing | 776,404 | 751,828 | 24,576 |
| 32-node CPU scene, distinct all-port labels | 71,337 | 70,081 | 1,256 |

For 100,000 no-text nodes, mounting is 35,053 allocations and 94,582,120 peak
new requested bytes in **both** variants. Preparing a replacement sheet keeps
the old P alive: the retained delta is 8,800,000 versus 8,000,000 bytes, with
9,112 allocations and **the same 56,618,596 peak new bytes**. Dominating earlier
scratch makes that peak unchanged. Acknowledgement allocates nothing and
releases the old 8.8/8.0 MB sheet. Smaller retained headers do not establish a
lower peak in every phase.

## Timing results and bounded codegen investigation

Median microseconds, original five-pair capture:

| Fixture / phase | Triomphe | Thin |
| --- | ---: | ---: |
| 100K no-text mount | 143252 | 148190 |
| 100K no-text prepare | 58611 | 64358 |
| Sparse ten-port edit | 3962 | 4220 |
| 1,000 distinct 24-byte label edit | 115945 | 116298 |
| 10K direct-name edit | 1744 | 1616 |
| 10K distinct-name/description edit | 7413 | 7618 |
| 32-node all-port CPU edit | 1626 | 1611 |
| One-label CPU edit | 353 | 346 |

The 15-pair repeat retains the losses: no-text prepare 59.848 -> 66.104 ms
(+10.45%); sparse edit 4.260 -> 4.515 ms (+6.00%); no-text drop
8.236 -> 8.937 ms (+8.52%). Other per-fixture drop results are noisy; for
example the initial distinct 8-byte-label drop is 77.6 -> 147.0 us. The raw data
is retained rather than hiding losing phases. This adoption trades some CPU
costs for storage; it does not claim a throughput win.

Actual application assembly (`cargo rustc --release --example
immutable_text_measure -- --emit=asm,link`) has no missing SharedText inline
helpers. `Runtime<Page>::present` has 3,343 baseline versus 3,337 candidate
instructions, 176 versus 175 calls, and the same 7,320-byte stack frame.
The no-text path skips **all** ArcStr flag tests and refcount instructions.
Instead, LLVM changes row construction: baseline copies the 88-byte Presented
with five 16-byte stores plus one 8-byte store; candidate scalarizes the 80-byte
record into eleven mixed stores, with extra spills across the cold Vec growth
call. This is concrete codegen evidence, not proof that one instruction alone
causes the entire timing difference.

A bounded, separately reviewable experiment states the already-reserved output
capacity before `push`, returning ResourceLimit if the impossible bound fails.
It removes the candidate's `grow_one` call (3,322 instructions / 173 calls),
although mixed stores remain. Eight four-variant pairs give:

| Phase | Original baseline | Original thin | Guarded baseline | Guarded thin |
| --- | ---: | ---: | ---: | ---: |
| No-text prepare (ms) | 58.262 | 64.077 | 62.344 | 61.916 |
| Sparse edit (ms) | 3.997 | 4.240 | 4.214 | 4.173 |

Guarded thin improves 3.37% / 1.58% against original thin, but the guard also
slows baseline. It does **not** erase the loss: guarded thin remains 6.27% /
4.40% slower than original baseline. This small capacity-proof change is kept
separate from the representation patch for independent acceptance.

Raw clone/read/drop loops (two million iterations, includes indexing and
borrowed reads) have medians around 9.2 ns Triomphe versus 8.95 ns ArcStr for
nonempty text; empty is 9.30 versus 1.21 ns. One shared header and 256 distinct
headers are both tested. These are single-thread microbenchmarks, not contention
or frame results. Assembly confirms a dynamic ArcStr clone still uses one
atomic operation: static/count-flag tests then `lock xaddq $2, 8(ptr)`;
Triomphe uses `lock incq (ptr)`. ArcStr release tests flags then
`lock subq $2, 8(ptr)`; Triomphe uses `lock decq (ptr)`. Borrowed reads do not
copy or validate UTF-8. Empty static leases skip the atomic work.

Concrete fixture binary sizes: baseline/candidate `.text`
2,607,911 / 2,607,351 bytes, `.rodata` 2,330,272 / 2,330,320 bytes. No general
binary-size claim follows. SHA-256:

```
baseline a7d358c814d4163ee1c5403883431cae6aed1c7a8553c9b86afb65edeb7a5179
thin     08e19971393849cd08ac6537f24f72dc8db5782f5a4c64cf2fb153ad11e5b63c
baseguard 9c4251d20650f9b11e6acb4bdae961b74a4eb7fdc1320ee9d838129b82b21a8e
thinguard b23035faa76ddc53fc8875d8cd42c75c275c5bd6047cb279a320c21194fb12cb
micro    3dedff8a376e021555b6cda8014c06d2110d8bc6083db6e47651a2ecdf6502cf
```

## Semantics and dependency cost

Tests cover empty, 3/8/23/24/25 bytes, long metadata and raw 4KiB text, multibyte
UTF-8 with embedded NUL, Send/Sync transfers, allocation-free borrowed reads and
clone/drop, one promotion shared across visual/name/description ports, equality
retention, old P alongside a pending candidate, and failed visual preparation
followed by recovery. A 4KiB wrapping visual fixture exceeded the baseline
Canvas resource limit too; it was replaced with a 4KiB metadata fixture rather
than treating that renderer limit as text ownership evidence. The public visual
test uses 256 bytes. Existing source ownership/rejected-value tests remain in
the full suite. No mutable owner or public type is added.

Pinned [arcstr 1.2.0](https://crates.io/crates/arcstr/1.2.0), checksum
`03918c3dbd7701a85c6b9887732e2921175f26c350b4563841d0958c21d57e6d`,
release commit `faa7692b0d6662bb177b3aefa80a6a13f897554d`. Default features off,
only `std`; no mandatory dependencies. Compressed crate archive is 32,237 bytes.
Enabled core Rust source is approximately 1,950 lines including documentation,
tests and macro definitions; disabled substr/serde source adds 857 lines.
Licenses are Apache-2.0 OR MIT OR Zlib. Triomphe remains the canvas resource
dependency and a test-only direct dependency for this comparison.

ArcStr contains internal unsafe code (allocation layout, UTF-8 dereference and
Send/Sync implementation); this is an explicit dependency trust cost. First
party `forbid(unsafe_code)` stays intact. Its
[pinned CI configuration](https://github.com/thomcc/arcstr/blob/v1.2.0/.github/workflows/ci.yml)
defines cross-target, Loom, Miri and sanitizer jobs. That is configuration
evidence, not a claim that we ran Miri locally or verified every upstream job.
No mandatory authoring macro or raw-pointer/static-string API is exposed.
