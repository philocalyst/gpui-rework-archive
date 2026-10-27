# Admitted parent walk: deep gains, no-regression gates not met

Production 93117a2cdd; lifecycle-qualified source 6801b594c1bc9990f4c83ea77ecb130f563b7ff0.
One full arena/generation admission precedes a private immutable parent walk.
The public parent operation remains the independent oracle. Compact parents
are the sole authority, not a mirror. No application API change or new unsafe.
The single-root proof and selective 32-lane level loop are inherited from the
previous candidate. This experiment isolates private admission versus forced
public-parent inlining and the previously outlined scalar fallback.

Disposition: **unadopted**. Initial four-way medians met numerical gates, but
timer-floor and single-full uncertainty required the separately preregistered
longer pinned qualification. It misses the original <=5% regression gate.
Neither campaign is discarded, pooled, or described as a ZGX comparison.

| Cell | Initial candidate/original | Longer pinned candidate/control | Paired range (longer) |
| --- | ---: | ---: | --- |
| tiny | 1.0008 | 0.9074 | 0.6989–1.7207 |
| contiguous | 0.5693 | 0.7350 | 0.3905–1.0262 |
| shuffled | 0.2430 | 0.2694 | 0.2458–0.3024 |
| medium-depth | 0.3166 | 0.3022 | 0.2770–0.3302 |
| shallow | 1.0000 | 1.0986 | 0.7290–1.8000 |
| single-full | 0.9959 | 1.0505 | 1.0340–1.0827 |
| mixed-depth | 0.4464 | 0.3828 | 0.3487–0.4019 |

The shuffled depth128 improvement persists (3.71x); single-full is 5.05%
slower and shallow 9.86% slower by paired medians. Tiny/shallow variability
is large; no confidence or hardware cache-hit claim is made. A split parent
column can help routing while harming complete layout locality. The data do
not isolate that mechanism from code generation or VM frequency effects.

First campaign: four variants × seven cells × five processes, 5,600 batches
and 28,000 complete compute calls. Qualification: two variants × seven cells
× five processes, 2,800 batches; 1,000 calls/batch for shallow and 20 for
others, 448,000 complete calls. Each campaign independently compares exact
final layout bits and LayoutStats; counts differ between campaigns. CPU/wall
p50/p95/p99, cold calls, retained storage and /usr/bin/time RSS remain raw.
The pinned fixtures only add an optional operation-count argument, with
unchanged production code. Frozen revisions and ELF hashes are preserved.

All four variants pass 46 core cases; candidate strict core Clippy passes.
Miri passes the arbitrary-forest/lifecycle test, including reparent, removed
generation, slot reuse and foreign arena. The negative control skips initial
capability admission and fails that exact test (exit 101). The composed
GPUI/Canvas release suite with X11 and parallel Canvas passes 1,044 cases
(42 ignored), and strict GPUI X11 lib/tests Clippy passes. The ignored actual
native Todo script was then run explicitly on owned Xvfb :94 and llvmpipe:
one test passes across its five renderer policies, pointer/edit/resize and
inspection operations. This is software Vulkan, not physical GPU evidence.

Entry24 + parent4 remains 28 bytes/slot; Tree header56→80 and one additional
allocation are charged. core-lines.json inventories the seven shipping crates.
All tracked inputs remain unchanged through the gates and measurements.
Linked private-root assembly and full ELF sizes are preserved. No prefetch
instructions occur in the selected candidate. Full application frame latency
and the required equivalent competitor/hardware gates remain unproven.

An important scope limitation: the current public runtime builds one layout
root. The strongest multi-root deep-filter cell therefore does not represent
its ordinary frame path. Its single-root complete workload is the relevant
regression guard. The next architecture stage must measure real publication
and task dependency work rather than infer a frame win from deep filtering.
