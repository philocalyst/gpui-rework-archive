# Cold scratch trim: bounded memory, median CPU gates pass provisionally

Production c8560a8e41; qualified fixture/source
606dd0f67d7a35b03338a3bd764564abeb420959. This outlines the >1024-byte
paragraph scratch reset into a cold, non-inlined helper. Eligibility, ownership,
fonts, numerical output and application APIs are unchanged. The original
bounded-cache campaign remains separate and unadopted.

The same long/short/mixed/font-switch ledger retains at most 45,046 requested
bytes and reaches zero at clear. Its fresh no-reset mutant retains 3,290,692
bytes, violating the original 256 KiB cap. Long-input transient allocations
remain: trimming lowers retention, not the peak needed to shape the paragraph.
The first short use still reconstructs discarded paragraph scratch.

| Static labels | Cold / unbounded cache | Cold / sparse-only | Cold / old bounded |
| --- | ---: | ---: | ---: |
| 0 | 0.9948 | 0.2778 | 0.9961 |
| 25 | 0.9864 | 0.2676 | 0.9954 |
| 100 | 1.0004 | 0.2695 | 1.0044 |
| 1000 | 0.9796 | 0.2571 | 0.9840 |
| 10000 | 0.9943 | 0.2691 | 0.9553 |

Five interleaved/rotated processes × four alternatives × five cells: 100
processes, 20,000 batches, 200,000 complete source-write/record/ACK operations.
All fixtures run their independent fresh-window exact pixel oracle. CPU/wall
quantiles, process order, raw counters, cold/drop costs, RSS, source/toolchain
and artifact hashes remain in raw. Controls use the exact ELFs from the previous
campaign, checked against its hashes and unchanged production/fixture source.
Sparse-only has a later separate allocation-example change; it is not linked
into state_update_cost and is explicitly recorded rather than silently ignored.

**Provisional, unadopted:** every median clears <=5% versus unbounded cache
and >=20% versus sparse-only at 0/1000 static labels. However, 0/10000-label
pairs span up to +9.1%/+32.2%; the preregistration says noise is inconclusive.
This is not a demonstrated no-regression result. The old bounded comparator
also stays close in this campaign, so the data do not isolate cold outlining
as the cause of an improvement over its earlier failure. Do not average the
campaigns together or infer a cache-miss reduction.

Twenty exact shaping/cache/Unicode tests pass; corrected-fixture strict Clippy
passes. The first Clippy failure was an existing complex example return tuple;
a type alias corrected only that fixture, with both attempts retained. The
full composed GPUI/Canvas X11+parallel release suite passes 1,045 tests, and
strict GPUI X11 lib/tests Clippy passes. The actual private-X11 Todo test also
passes its five renderer policies, pointer/edit/resize/inspection and reference
checks on llvmpipe. This establishes local exercised correctness, not hardware
performance, physical presentation latency, or ZGX superiority.

Linked assembly confirms the trim helper is outlined; an earlier extraction
that missed the demangled symbol is preserved, alongside its corrected output.
core-lines.json records shipping code separately. No new dependency or unsafe.
All source guards pass through their respective gates/capture. Run verify.py.
