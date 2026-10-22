# Counted style palette phase results

This report compares the exact `f01947e679d9dd2ca7ef149b70dccff92dad67dc`
parent with the counted-palette source patch in `README.md`. Both release test
binaries ran the same ignored probe and the same source-derived Todo/Library
style seeds. This is an owner/lane diagnostic, not a native-window or
application-latency benchmark.

## Measured result

The candidate has a decisive first-sparse-update allocation win, but loses on
repeated broad mutation. At 65,536 style slots, changing one slot retained
66,364 bytes and requested 828 bytes in the candidate, versus materializing a
5,767,168-byte dense lane in the parent. Four full-cohort style changes took a
median 7.467 ms in the candidate and 4.612 ms in the parent (+61.9%). Candidate
cohort mutation made eight bounded palette allocations (9,200 requested
bytes total; 2,116-byte maximum request), while the parent made one dense-lane
allocation. The candidate remains shared after the four changes, retaining
67,008 bytes rather than 5,767,168 bytes. This is the central tradeoff: much
lower storage and allocator volume, with added scan/counter work for every
changed node.

Times below are medians with min–max ranges. Lane phases pool six samples per
cell (three runs for each of the Todo and Library seed sets). The six test
processes alternated P/C, C/P, P/C. All measurements are nanoseconds; memory
and allocation figures are bytes/requests as emitted by the probe.

| Lane size | Phase | Parent ns (min–max) | Counted ns (min–max) | Change | Parent → counted requested bytes / retained bytes |
| ---: | --- | ---: | ---: | ---: | --- |
| 60 | Warm reads, 16 full walks | 925 (900–990) | 960 (920–970) | +3.8% | 0 / 764 → 0 / 796 |
| 139 | Warm reads, 16 full walks | 2,150 (2,130–2,480) | 1,720 (1,670–1,800) | −20.0% | 0 / 843 → 0 / 875 |
| 4,096 | Warm reads, 16 full walks | 51,581 (49,791–53,171) | 40,006 (39,611–45,241) | −22.4% | 0 / 4,800 → 0 / 4,832 |
| 65,536 | Warm reads, 16 full walks | 803,723 (796,378–852,669) | 643,784 (639,315–658,175) | −19.9% | 0 / 66,240 → 0 / 66,272 |
| 60 | First sparse set | 565 (310–870) | 185 (160–210) | −67.3% | 5,280 / 5,280 → 828 / 888 |
| 139 | First sparse set | 1,010 (600–1,930) | 285 (190–350) | −71.8% | 12,232 / 12,232 → 828 / 967 |
| 4,096 | First sparse set | 90,367 (21,700–157,754) | 135 (110–160) | −99.9% | 360,448 / 360,448 → 828 / 4,924 |
| 65,536 | First sparse set | 2,293,181 (2,070,716–2,964,656) | 140 (110–190) | −100.0% | 5,767,168 / 5,767,168 → 828 / 66,364 |
| 60 | Four whole-cohort mutations | 2,400 (2,210–2,670) | 9,110 (8,700–9,380) | +279.6% | 5,280 / 5,280 → 9,200 / 1,532 |
| 139 | Four whole-cohort mutations | 5,455 (5,200–5,880) | 20,931 (19,691–21,700) | +283.7% | 12,232 / 12,232 → 9,200 / 1,611 |
| 4,096 | Four whole-cohort mutations | 220,515 (153,273–296,246) | 469,871 (430,670–493,641) | +113.1% | 360,448 / 360,448 → 9,200 / 5,568 |
| 65,536 | Four whole-cohort mutations | 4,612,023 (4,482,220–4,741,666) | 7,467,356 (6,753,721–7,898,437) | +61.9% | 5,767,168 / 5,767,168 → 9,200 / 67,008 |

Build times are deliberately not measured. Building each lane requested 3
allocations in both variants. Candidate build requests were 160 bytes higher
at every lane size in this probe: 128 extra transient bytes for the 32-entry
builder palette capacity and 32 bytes for the retained eight-entry palette.
The retained lane delta is exactly 4 bytes per live palette entry. At eight
patterns, the added retained size is 32 bytes, including for 65,536 owners.
The implementation bounds the palette at 32 entries (maximum +128 retained
bytes, plus up to 128 bytes in the temporary builder vector). The default
style lane remains allocation-free.

The warm-read result favors the candidate by about 20% for large shared
lanes, despite its 92-byte palette-entry stride versus the parent's 88-byte
stride. This is repeatable across these six short samples but unexplained by
the inspected assembly: both load the same selector and payload words, and
the candidate does not load its user count. Treat this as a probe signal, not
a general performance claim. The candidate's broad-mutation regression is
larger and plainly visible in the measured loop; `Styles::set` linearly
searches the bounded palette and updates a per-pattern count for each changed
owner. The parent pays one dense allocation and then performs direct stores.

## Public and application-shaped controls

| Work | Parent median (min–max) | Counted median (min–max) | Requested bytes / retained bytes |
| --- | ---: | ---: | --- |
| `Win::recording` Todo empty mount, 3 samples | 1.037 ms (0.974–1.061) | 0.991 ms (0.902–1.004) | 284,587 / n/a → 284,715 / n/a |
| `Win::recording` 250K-row Library mount, 3 samples | 4.471 ms (4.292–4.491) | 4.391 ms (4.323–4.409) | 5,150,271 / n/a → 5,150,443 / n/a |
| Library scroll to row 120,000 + acknowledge, 3 samples | 2.284 ms (2.281–2.341) | 2.279 ms (2.266–2.332) | 0 / n/a → 0 / n/a |
| Public inspector, first `Set` + acknowledge on 4,096 default-style owner | 0.367 ms (0.366–0.374) | 0.294 ms (0.290–0.299) | 919,408 / 360,536 → 563,153 / 4,281 |
| Four public inspector updates + acknowledges | 1.148 ms (1.138–1.195) | 1.166 ms (1.149–1.174) | 2,228,768 / 360,536 → 2,228,768 / 4,281 |

The owner setup times do not show a material, attributable latency change at
three samples. They are included to check that ordinary mounted fixtures do
not expose a large regression; they are not proof of unchanged whole-app
latency. The candidate requested 128 more bytes for Todo setup and 172 more
for Library setup. These totals include all work inside `Win::recording` and
do not isolate the style lane. The inspector-first path confirms the intended
memory win in actual owner mutation: retaining a shared palette rather than
densifying saved 356,255 bytes; requested bytes fell by the same amount even
though the candidate made one additional allocation. Four repeated public
updates had essentially equal latency in this small sample and identical total
requested bytes.

## Capture limits and disposition

The capture ran from `2026-10-22T00:14:32Z` through `00:14:38Z` in the root
authorized quiet window. CPU pressure `avg10` was 0.00 before and after;
`avg60` was 0.11→0.10 and `avg300` 0.32→0.31. The process snapshots recorded
no running build or test jobs, but did include two API cargo processes and
one rustc process in stopped (`T`) state, as expected from the coordinated
hold. This is not an isolated machine claim. Six lane-phase observations per
cell and three setup/public observations are too few for broad percentile or
cross-workload claims. Raw per-run rows and the pre/post process/pressure
snapshots are preserved in `raw/`; SHA-256 digests appear in
`raw-sha256.txt`.

The evidence supports a conditional memory optimization for owners with
repeated styles and isolated sparse inspector updates. It does not support
unconditional adoption: full-cohort reactive style replacement is 62% slower
at 65K and about 2.8× slower on the small 60/139-owner lane tests. A follow-up
would need to measure the real frequency and timing of sparse versus
cohort-wide style writes on application workloads, or redesign the counted
update path without hiding full-lane work. No further capture was run.

## Immutable inputs

- Parent tree: `f01947e679d9dd2ca7ef149b70dccff92dad67dc`.
- Candidate `styles.rs` SHA-256: `2e535b39a2a0ec699fcdee3465b84c1e61d378585606f83296592e5362e3b479`.
- Shared probe source SHA-256: `6a09247eb8944d088912b9f1d13a5e22da70ee5f9c08dd0938bc4d828c12e935`.
- Parent and candidate binaries and build/toolchain details: `README.md` and
  `assembly-review.md`.
- Runtime results: `raw/parent-{1,2,3}.log` and
  `raw/candidate-{1,2,3}.log`.
- Process/load snapshots and binary hashes: `raw/capture-envelope.txt`.

The command builds use the nested cleanroom `reactivity/Cargo.toml`, Rust
1.97.1, release profile, and `x11-minimal`. The probe is ignored by default
and is invoked only in the explicit capture mode. It uses single-threaded
test execution because the allocation counter is process-global.
