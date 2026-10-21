# Route storage with final index construction: still held

Candidate `c8c84c15be` contains production change `d19a008de8`: construct the
identity/route locator map in the final bulk pass, instead of accumulating a
temporary location vector during reconciliation. Its last commit only refines
the callback-destructor test. The parent remains `40382ed1d9`; both sources
already contain the cold viewport slot. This experiment is not main's image,
cached-cmap or compact presented-sheet integration.

The [density manifest](manifest.json) pins 11 alternating fresh-process pairs,
1,320 rows and 12.586 seconds. The [application manifest](apps-manifest.json)
pins five alternating pairs, three warm batches per process, 750 rows and
16.936 seconds. All owned heavy jobs were idle during the captures. CPU2 affinity,
functional/pixel preflights, deterministic allocation cells and balanced owner
drop checks are unchanged. Summary percentages are **ratios of medians**, not
medians of per-pair percentages. Raw outputs retain every observation.

| Operation | Parent median | Candidate median | Change |
| --- | ---: | ---: | ---: |
| 4,097 nodes, captured-route mount | 3.221 ms | 4.190 ms | +30.10% |
| Same captured-route equal description | 2.082 ms | 2.244 ms | +7.75% |
| 4,097 nodes, method-route mount | 3.738 ms | 4.012 ms | +7.35% |
| Same method-route equal description | 2.127 ms | 2.049 ms | -3.70% |
| One captured route, 100 exact activations | 5.560 µs | 5.620 µs | +1.08% |

All nonempty exact activation cells allocate zero; their elapsed changes range
from +0.82% to +2.12%. Method routes deliberately run coarse descriptions and
allocate in both sources. Empty dispatch cells do no work and their percentages
have no performance meaning. The full [60 density cells](summary.csv) and
[25 application cells](apps-summary.csv) remain available.

Moving the index build fixes the earlier broad style-mount losses in this
capture: the four existing 4,097-node style controls now range from -0.37% to
+0.15%. Their equal descriptions range from -5.66% to +0.72%. Counter exact is
-0.10%, Todo equal -0.47%, Workspace rotate -0.41%, Library equal +1.69%, and
Library scroll -0.34%. These small changes are not universal speed claims.

The retained-byte ledger matches the first prototype: no-route 4,097-node
owners save 65,528 requested bytes, 256 method routes save 61,432, and fully
actionable owners add 8 bytes plus one allocation. Captured callbacks retain
their original 4,096 payload allocations. Node24 does not remove those boxes.

**Hold adoption.** The dense captured mount loss persists, and its cause is
unresolved. A later opt-in phase profile is separate diagnostic evidence;
instrumented closure timings must not replace these uninstrumented results.
Neither campaign measures native startup, event delivery, upload or scanout.

Both candidate executables were frozen at SHA256-named paths before further
compilation; manifests keep the original mutable build-output path too. CSV
summaries/combined rows are normalized to LF. `paired_sha256` records the original
capture bytes; `paired_lf_sha256` records the normalized file. Process raw files
are untouched. `capture-routes.py` and `capture-apps.py` preserve the historical
capture scripts, including their machine-specific paths. To reproduce, copy a
script, change its output to a fresh directory, and use the immutable binaries
from its manifest; do not overwrite this evidence. Rebuilding requires the
pinned source, identical fixture/toolchain and independent target directories.

The final locator construction passes the public route/list cases and strict
native Clippy recorded on this branch. The callback-destructor regression is
also integrated independently into main; compact route storage is not.
