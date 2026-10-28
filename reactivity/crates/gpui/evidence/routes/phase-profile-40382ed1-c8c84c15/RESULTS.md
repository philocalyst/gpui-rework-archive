# Route storage phase profile: diagnostic results

The focused capture completed with 11 fresh-process alternating pairs. It is a diagnostic of coarse phase durations, not a replacement production benchmark. Even rounds ran candidate then baseline; odd rounds ran baseline then candidate. Each binary was called with `--case=4096,1,true`. The fixture retained its route verification, white-pixel preflight, allocation measurement, and lifecycle steps.

Within each process, the first `mount=true` and `sequence=1` pair is the preflight owner. The second such pair is the measured `mount` operation. Values below select the second `mount=true` describe line and second `sequence=1` present line from each full output log. Raw outputs are `round-00` through `round-10` for each source.

| Phase | Baseline median (min–max) | Candidate median (min–max) | Median change |
|---|---:|---:|---:|
| Describe: flatten | 826,279 ns (786,848–929,131) | 856,689 ns (791,428–913,150) | +3.7% |
| Describe: preflight | 80,442 ns (79,852–81,692) | 80,371 ns (79,892–81,702) | −0.1% |
| Describe: reconcile, including handler/route aggregation | 408,820 ns (396,109–467,810) | 443,520 ns (440,590–625,154) | +8.5% |
| Describe: identity-index construction and finalization | 20,301 ns (19,330–86,672) | 21,811 ns (21,280–81,362) | +7.4% |
| Present: canvas/font/layout setup | 746,856 ns (736,387–940,511) | 755,337 ns (749,537–1,138,325) | +1.1% |
| Present: layout compute | 1,164,946 ns (1,153,776–2,101,886) | 1,028,733 ns (1,005,323–1,999,455) | −11.7% |
| Present: paint and commit | 508,421 ns (506,172–710,076) | 540,922 ns (532,561–743,826) | +6.4% |

The coarse internal phases show a 34.7 µs higher median candidate reconciliation phase, with most other medians close and layout compute lower in this capture. This does not explain the earlier roughly 30% outer mount regression. Do not infer the outer regression’s cause from these data.

The fixture's outer mount duration is intentionally excluded: each successful `describe_inner` and `present_inner` emits a diagnostic line from inside the measured closure. This changes closure time and may alter allocator/stdio behavior. The phase intervals themselves exclude their corresponding output write; they include the boundary timer calls. The build is optimized release with one opt-in feature enabling timers; it is not bit-identical to the previous uninstrumented route binaries. The phase values are only coarse localization evidence. Min/max also show long-tail variation in presentation and identity-index intervals, so these 11 observations are not strong latency-distribution estimates.

The patch adds no timestamp calls inside node or handler loops, no Runtime fields, and no allocator-policy changes. Route vector setup/push/shrink remains inside reconciliation; the BTreeMap collection remains separately timed. The profile feature and case filter are absent by default. The exact source commits, fixture/lock hashes, profile-patch hashes, binary hashes and build target directories are in `README.md`.

No `strace` run has been performed yet. If run later, retain syscall counts only as diagnostics; traced durations must not be mixed with these phase values or cited as performance measurements.
