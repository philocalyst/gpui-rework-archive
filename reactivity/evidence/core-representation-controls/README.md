# Core representation controls and rejected follow-ups

These are software CPU/public-owner microbenchmarks, not native click, scanout,
startup or RSS/PSS measurements. Every capture is retained, including slower
candidates. Raw stdout/assembly is losslessly gzip-compressed; `RAW_SHA256.json`
checks its original bytes. `summarize.py` independently recomputes all second/third
phase distributions and verifies exact matching query **and mount** allocation
fields. No sample exclusion, retry or best-round selection.

## Frozen sources

| Label | Exact source | Change from preceding stage |
|---|---|---|
| parent | `de18f040c98dbfc32d33bd1e51515bbf11bce53b` | integrated bounds-only containing CSR |
| cuts | `d50ba094b59af1c536b0b2f3cc3cab526e92b45c` | reuse construction cursors for opaque cuts |
| narrow | `25d851b380f7ed4765416a5afaa8cbbc924a81a3` | admitted 32-bit offsets/cursors |
| cursor | `96f4dff27c98d9b8b6906baeb4e29afa962a446d` | no cursor vector; cuts in first member word; monotone scheduling exit |
| lazy | `349d229d4ef0f7103110c17b7b66df2c394523ed` | two audited MaybeUninit sample reads; **rejected** |
| borrowed | `aed7aa11604effc452df6dd167409d1ad795cb51` | direct serial row loop; **rejected** |
| runs | `966a13ff7d9dc3e04e41aabf9223dd71826951fd` | seven-bit impossible-hit runs |
| links | `50a082654d4ff97a5588676b6aff4f4cddfaf4f8` | 17-bit presented parent / 15-bit hit run |
| iterator | `33a282000f18cfa344f7d6b9515f04fee2e3f941` | existing eligibility byte includes empty bounds; reverse slice traversal |

The final iterator includes intermediate `ea3cc4009c`. The final cursor includes
`7006be8487`. The sample-init and direct-serial variants are not adoption choices.
Their unsafe and serial-specific edits must not enter through this evidence.

`fixtures/` holds the two exact consumers; the hit probe uses ordinary public
`Win::hit_target`, and all producers use the same fixture bytes. They are not
installed as ignored duplicates in the library test catalog. Frozen manifests
pin source, actual executables and fixtures. For newly built second/third
consumers, they also pin actual root rlib/rmeta and JSON build records, requiring
fresh root and consumer compilation. Older controls are explicitly reused by
hash. Before archiving, root independently rechecked every available frozen
executable, root-library and build-record hash. Binaries remain external artifacts;
the manifests retain their exact identity, not a claim of portable binary replay.

The scripts retain their original absolute worktree/artifact paths. Reproduction
on another machine requires rebuilding the pinned consumer/source combinations,
then a new frozen manifest. It must not silently reuse the archived timings.

## Capture scope

`first/` retains the earlier three-raster-stage and two-hit-stage captures. Its
raster stage predates process/pressure snapshots; there is no retroactive quiet
machine claim. `second/` contains 15 raster processes/105 rows/90 exact matching
pixel digests and nine hit processes/216 rows/48 paired public preflight cases.
`third/` contains 12 raster processes/84 rows/72 matching pixel digests and nine
hit processes/216 rows/48 preflights. All guards pass, all attempts retained.

Both later campaigns use three alternating-order rounds on one recorded CPU.
Owned compiler/test/native work was held across capture. Before/between/after
process lists and CPU/I/O/memory PSI are preserved. A foreign `find` process was
present, and storage pressure persisted: this is **not machine or I/O isolation**.
The third campaign follows the first two and does not replace their distributions.
The short, sometimes bimodal recording-only and blank phases are descriptive
controls, not significance tests or reliable estimates of tiny percentage gains.

## Final matched raster controls

Third-campaign median microseconds per operation; three complete samples for
every cell are recoverable with `python3 summarize.py`:

| Phase | parent | cursor | rejected lazy | rejected borrowed |
|---|---:|---:|---:|---:|
| first blank CPU | 3.611 | 3.620 | 1.940 | 1.997 |
| first 4096 panels | 2797.060 | 2668.024 | 2714.398 | 2836.325 |
| same-tile color repair | 2.967 | 2.897 | 1.845 | 1.923 |
| distant color repair | 2.742 | 2.748 | 1.636 | 1.686 |
| full-color raster | 1895.970 | 1683.495 | 1662.692 | 1766.431 |
| geometry replacement | 12170.709 | 12534.239 | 13108.537 | 13685.889 |

The safe cursor representation removes its construction cursor and keeps narrow
offsets: recording Canvas stays488B; lazy scratch80→56B. In this 64×48 blank
fixture, first raster makes two requests/108B instead of three/280B. The separate
32×32 unit oracle reports two/76B; those are different dimensions. Final retained
CSR capacity is209944→160788B in the panel fixture, about23.4% less. There is no
new per-tile allocation, worker job vector, refcount or lock. Exclusive mutable
membership spans and output bands are split together; immutable offsets overlap.

Tradeoffs remain: geometry replacement loses2.99% versus parent in this capture
(2.33% in the second), despite warm full-color improvement11.21% (11.14% second).
Blank and tiny repairs vary across rounds. The rejected lazy sample initialization
removes an unconditional64KiB memset and improves these blank/repair tests, but
geometry replacement loses7.71% versus parent. The direct serial row follow-up
loses another4.4% there and6.2% in full-color raster versus lazy. Neither follows
from memory/code elegance alone. Valgrind and initialization tests support only
the rejected unsafe prototype's tested behavior, not exhaustive soundness or Miri.

## Final matched hit controls

Third-campaign median nanoseconds per **public hit query**, not native latency:

| Scene / query | parent | links | iterator |
|---|---:|---:|---:|
| no clipped descendants / hit |39.35|38.29|38.55|
| 1000 clipped / hit |4721.43|54.91|54.27|
| 40000 clipped / hit |186604.12|58.84|59.28|
| 40000 clipped / miss |186702.61|35.41|36.79|
| 1000 visible / hit |5216.47|5432.91|5331.76|
| 1000 visible / miss |5173.56|5427.15|5221.66|
| 40000 visible / hit |207319.82|217021.52|212298.00|
| 40000 visible / miss |207153.42|217014.23|207741.21|

Packed runs charge no new node, P or owner bytes: Presented remains80B. Their
15-bit saturation conservatively resumes scanning rather than skipping an
eligible row. Parent indices retain their complete admitted17-bit domain and
sentinel. Only already-published P owns the proof; pending/failed descriptions and
same-alpha KeepP transitions cannot rewrite it. Exhaustive routing, scroll/list
parent remapping, saturation and near100K-node tests compare the old scan.

All queries allocate zero; **every matching mount allocation/requested-byte/peak
field also agrees exactly** across variants and rounds. Visible40K hit still
loses2.40% and miss0.28% with iterator; full visible mount is61.178ms versus
60.930ms parent (+0.41%). Earlier links loses roughly4–5% on visible scans.
Bounded linked code is1137B parent,1177B links and1289B iterator. It does not
shrink. The iterator prototype's historical commit-message suggestion about
preserved bounds checks was unsupported: none of these linked hit bodies calls
`panic_bounds_check`. Do not repeat that as the cause of an observed improvement.

## Integration boundary

This archive qualifies the frozen isolated sources above. Combining the selected
safe cursor/hit representations with literal dispatch, range/run identities,
single-search target admission or paint banks requires its own actual-source
workspace, parallel, GPU, native and cross-target checks. These timings must not
be relabeled as measurements of that integrated tree.
