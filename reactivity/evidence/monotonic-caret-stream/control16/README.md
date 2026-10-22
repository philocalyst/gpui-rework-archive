# Monotonic caret stream: frozen 16-byte loss control

Production source `62ef2508c2346fcd71d4616a85000da530313e1e`, baseline
`1d5bc3061cce3beb3c4857102ed651da501b5cfd`. The implementation passed its
correctness controls, reduced temporary heap, and **lost** the measured speed
comparison. It is not an adopted optimization. Later 8-byte slots, inline
storage, cached boundary neighbours and borrowed iteration are separate controls.

The source-ordered visitor keeps random `CursorGeometry` APIs unchanged. It
validates the complete layout before callbacks, scatters visual item positions
by source-run identity, sums exact LTR prefixes and reuses one RTL visual-offset
buffer. Its decreasing-request path uses ordinary cursor geometry. Oversized
source domains and unexpected run/range ordering use the unchanged indexed
implementation before callbacks. Empty ranges do not claim source bytes; neither
gaps nor private structural corruption gain a new general rejection contract.

## Qualified behavior

* Default Canvas unit suite: 65 passed, two ignored. Full parallel Canvas:
  193 passed, four ignored, 28 harnesses. Fallback Canvas without defaults:
  183 passed, three ignored, 28 harnesses. First-party all-target parallel
  Clippy passed with warnings denied.
* Independent ordinary cursors, random indexed pairs, streamed pairs and packed
  Canvas stops agree bit-for-bit: 94,176 accepted requests, 41,760 snapped
  requests, 11,096 distinct affinity pairs. Repeated/decreasing requests,
  extreme widths, zero/small line height, spacing, styles, bidi, wraps,
  ligatures, combining/ZWJ content and hard separators are exercised.
* Seven private producer/admission tests pass, including all 396 real-layout
  span fixtures: 2,468 lines, 344 reordered lines, 629 split-run recurrences,
  144 empty edge runs and 396 boxes. Empty runs among other runs were **not**
  observed. Out-of-order disjoint and duplicate/empty fragments retain old
  admission through fallback. Range/overlap rejection precedes callbacks even
  when earlier geometry is nonfinite. The tested bad private run ID retains
  its old panic before callbacks.
* The ordinary 83-case presentation transcript is exactly equal in both
  independently linked native-feature consumers: 2,678,729 bytes, SHA-256
  `1d529192f8bce827403feb865c800d20054ef98b96fa8043e29edce018f69a4f`.
  This is a recording-owner behavior gate, not a foreign native runtime test.
* The ordinary owner fixture preserves old P through new C and failed new L,
  then publishes the earlier C on ACK. The same source/geometry checksums and
  retained-byte rows hold in baseline and candidate.

Standalone Parley Clippy is separately recorded: both exact baseline and
candidate fail the same three existing diagnostics (two nested cursor `if`
warnings and one existing documentation-backtick warning). The new stream
adds none. These failures are not relabeled as a strict vendor pass.

## Heap and linked costs

Already-shaped producer measurements include both allocations and peak live
scratch, with zero retained bytes after the call:

| Fixture | Old index bytes | Stream bytes | Old/stream allocations |
|---|---:|---:|---:|
| Empty | 16 | 64 | 1 / 1 |
| 18-byte label | 360 | 64 | 2 / 1 |
| 32 KiB ASCII | 655,360 | 64 | 2 / 1 |
| Latin, 30,800 bytes | 616,000 | 64 | 2 / 1 |
| RTL, 27,000 bytes | 367,200 | 316 | 2 / 2 |
| Mixed, 25,200 bytes | 417,600 | 252 | 2 / 2 |
| Disjoint ordering fallback | 300 | 364 | 2 / 3 |

The fallback includes live run slots plus the old index. The RTL scratch is not
allocated before preflight completes. Rust's minimum Vec capacity makes the
single 16-byte slot request 64 bytes. Empty/tiny/one-grapheme API measurements
do not imply Canvas savings: Canvas keeps its existing direct path through
eight boundaries. The short-paragraph cohort also stays on that direct path.
All complete shaping allocator rows remain in the archive; allocations are
intentionally not asserted equal across variants.

For the 32 KiB ordinary owner, first C changes from 383 allocations,
21,246,272 requested bytes and 12,817,120 peak extra bytes to 382 allocations,
20,590,976 requested and 12,170,700 peak extra bytes. Retention remains
1,091,736 bytes. New C and failed new L each request 655,296 fewer bytes;
old-C ACK allocates zero in both versions. These are allocation-counter values,
not RSS, and unchanged shaper/owner transient work is still charged.

The matched scoped release executable grows 15,400 bytes; `.text` grows
10,784 bytes. Planner's local stack reservation changes 4,568 → 4,584 bytes.
The stream helper is 6,903 code bytes with a 1,960-byte local reservation.
Assembly retains 272-byte iterator staging copies and other cursor/iterator
copies. These individual local reservations are not a peak-stack measurement.
The frozen source throws away cached prefixes at exceptional boundaries and
reenters direct geometry; subsequent controls must qualify eliminating that work.

## Paired timing loss

Seven alternating pairs per cohort, CPU 0, isolated source/binary guards before
and after every paired block. Quiet interval: 2026-10-22 22:13:03–22:13:31 UTC;
driver duration 27.703 seconds. All cooperating agents held builds and heavy
work; the driver rejected live Cargo/rustc/Clippy processes. Unrelated host
activity was uncontrolled. Fonts were primed per process; cold means a fresh
scoped planner, warm means a reused planner. Timing includes previous output
drop and excludes process/font setup.

| Cohort | Cold change | Warm change |
|---|---:|---:|
| Tiny | −1.47% | +0.62% |
| Label | +4.96% | +15.79% |
| Latin | +13.30% | +10.37% |
| RTL | +30.48% | +29.43% |
| Mixed | +28.32% | +27.67% |
| Short paragraphs | −0.61% | −0.85% |
| One grapheme | −0.07% | −1.32% |

Positive means slower. These medians are not confidence intervals or complete
frame, native-input, GPU, startup or competitor measurements. No rerun was
silently substituted. Raw samples and per-variant allocator rows are preserved.

## Source and reproduction

`qualification.json`, both release metadata files, Cargo artifact records,
raw logs, disassembly, and paired samples pin flags, source, executable hashes
and source guards. Targets and frozen executables are distinct. Binary files
remain outside Git at the recorded paths. The historical public fixture omitted
the current `wgpu-core` path patch; that unexecuted build is preserved under
`rejected-public-patch`, and both qualified public builds use every root patch.
All registry package versions in that corrected public lock match the root lock.

Core non-test code is 30,420 → 30,432, including 18 build-script lines. The
authored Parley delta is separately **+227 code lines**, so shipping code grows
239 lines. New non-shipping, non-test source is also charged: `prepare.py`
84 lines, `run_pair.py` 72, ordinary owner driver 94: **250 more code lines**.
Private test files total 413 code lines; the Canvas oracle additionally adds
52 physical lines. Core exclusions do not make these tool/vendor costs vanish.

To reproduce private admission, run `../../monotonic-caret-span/prepare.py`
with source `62ef…`, `--stream`, then install that directory's `fixture.lock`
and test `stream_tests` with `--offline --locked --no-default-features
--features std --lib -- --nocapture`. Add `--cost`, install `cost.lock` and
select `indexed_and_streamed_scoped_allocation_rows` for scratch costs. The
public manifests select the recorded source trees; their `owner` binary uses
the ordinary driver in the same support directory. Rebuild/freeze scoped
examples at both pins, refresh metadata from Cargo's exact artifact records,
then run `run_pair.py` only in a newly coordinated quiet window. Gzip files
are lossless; `SHA256.json` records the archived bytes.
