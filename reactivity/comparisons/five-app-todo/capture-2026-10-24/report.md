# Five native Todo applications — 2026-10-24

The complete primary capture contains 75 fresh cells (five applications, three repeats, four 30-second resource workloads plus startup). All 15 Busy cells passed. No Heavy resource cell passed the unchanged input/presentation gates, including the three corrected Zeron Heavy reruns. Only Zeron passed all animation delivery and independent host-receipt gates. This capture supports partial comparisons; it does not establish an overall winner.

| App | Idle CPU % | Busy CPU % | Animation CPU % | Idle peak PSS MiB | Animation peak PSS MiB |
| --- | ---: | ---: | ---: | ---: | ---: |
| gpui | 0.03 | 120.36 | unqualified | 127.93 | unqualified |
| zeronsh-zgui | 0.00 | 6.27 | 82.67 | 102.41 | 133.71 |
| zortax-zgui | unqualified | 23.73 | unqualified | unqualified | unqualified |
| nanoui | 0.00 | 61.23 | unqualified | 144.93 | unqualified |
| mygo | 0.00 | 14.67 | unqualified | 162.61 | unqualified |

CPU 100% is one logical core. CPU includes software-renderer worker threads in the app process and excludes Xvfb and the external observer. PSS values are medians of per-trial peaks. Qualified values require three original workload checks; animation additionally requires the independent host-count audit. Failed-cell resource samples remain raw diagnostics.

| App | Warm spawn → host receipt ms | Separate spawn → visible Todo chrome ms | As-built executable MiB |
| --- | ---: | ---: | ---: |
| gpui | 167.70 | 178.65 (3/3) | 23.04 |
| zeronsh-zgui | 61.20 | 67.43 (3/3) | 20.24 |
| zortax-zgui | 228.16 | timeout 8s (0/3) | 43.98 |
| nanoui | 121.46 | 67.47 (3/3) | 6.84 |
| mygo | 169.39 | 76.97 (3/3) | 13.18 |

Host startup is a backend draw/submission boundary. It is not visible readiness. The visible-UI successor waits for independent heading, compose-field, margin and revision-zero pixel anchors without sending focus or pointer events. Polling and X11 window discovery add observation delay; these are bounded client-readback observations, not exact first-photon times. All startup trials use warm page cache; cold startup is unmeasured.

The fifteen-category JSON contains CPU idle/busy/heavy/animation, GPU busy/heavy/animation, memory idle/heavy/animation, smoothness busy/heavy/animation, startup work and app size. All physical GPU utilization and physical smoothness cells are explicitly unsupported: this headless host uses llvmpipe. Host receipt intervals remain named diagnostics, with the actual backend boundary.

App size includes as-built and stripped-copy bytes, external font asset bytes and hashes, exact ELF dependency/loader inventories and missing-loader warnings. It is not a standalone package-size estimate. GPUI uses its bundled font assets; peers require the externally provisioned 2,049,096-byte Noto Sans face. MyGo uses its normal optimized Go build with inspector retained, without the upstream production build tag/strip flags.

The original 75 rows, original acceptance interpretation and reports are preserved. Postcapture exclusions and successors are explicit:

- Original Zeron Heavy All/Done coordinates miss their buttons because the 16px remaining-count label shifts the footer. All five apps passed a slow full eight-event Heavy macro with actual filter paint and canonical full-model checks; Zeron used corrected mode-specific coordinates. The corrected three 30-second reruns still fail the unchanged strict gates. Original Heavy rows are harness failures, not evidence of Zeron capacity. Other Heavy failures retain their exact model, missed-input and drawable-ack evidence.
- Zortax idle remains black in all three final client readbacks and is excluded from qualified idle resource comparison. Its host startup receipts remain raw measurements; the separate visible-UI profile timed out in all three eight-second trials. Pointer-driven Heavy subsequently passes the complete slow macro. The cause of the initial blank readback is unresolved; source inspection shows a normal initial full-damage request, so no upstream defect is inferred solely from these captures.
- A revision-zero parity marker is all black and cannot distinguish absent UI from a valid marker. The exact screenshot audit finds 39 solid-black initial samples and six final samples (all Zortax idle/startup). All screenshot hashes match the original rows. Later interactive images can paint correctly. Independent chrome anchors reject black and uniform-white frames.
- The original animation gate could pass delivered model ticks with too few actual submissions. A separate native Zeron control defers backend render/present while preserving every observer receipt: the positive produces 360 host receipts in six measured seconds; the fault produces 28, with 485 model ticks and 449 actual deferred backend draws. Both pass the original gate, while the independent audit rejects the fault. The postcapture audit requires at least floor(seconds×60)−2 unique monotone in-window receipts plus complete recording integrity. It cannot prove every tick visible because receipts lack source revision IDs.
- The interrupted postcapture-measure-v1 attempt overlapped an evidence copy and is invalidated. The quiet v2 successor replaces it. Future copies and builds take shared locks on the same host lease; measurements take the exclusive lock.

Sources and build boundaries: GPUI 63e0a521f4 (before the later accessibility shutdown change), Zeron 7d82e5b4, Zortax f6badfb1, NanoUI 05f15802, MyGo 818f07e2. Full revisions, exact compiler versions, commands, native dependency metadata, source inventories, fonts and binary hashes are retained. Peer exports verify the entire intended tracked-file set; GPUI verifies its explicitly anchored build scope. This is Linux/X11 coverage, not cross-platform qualification.

Each app uses 540×620, Noto Sans, an eager 10,000-row Heavy list or 1,000-row animation, 360px viewport, and actual draft/Add/Complete/filter/Delete/Undo work. Native editor, focus, decoration and button styles differ. End-to-end IME and assistive-technology parity are unmeasured; normal compiled capabilities were not removed. Rust peers retain their upstream release/dist profiles; NanoUI is ReleaseFast and MyGo uses its normal optimized build. These profile differences are disclosed rather than pooled with normalized supplementary builds.

GPUI’s frozen tick and marker path invalidates the owner and reconstructs all 1,000 row descriptions each tick, despite mutating a direct translation signal. Zeron uses a reactive callback switch and retained animation transform. Results therefore include reactivity/API and instrumentation boundaries as well as renderer work. An optimized GPUI successor requires separate source/binary freezes.

The seven original actual native fault controls pass, and all 20 offline tests pass with the mandatory archived-33-cell regression enabled. The historical six GPUI failures remain failures; none are reused as current performance data.

Raw screenshots, rows, native logs, source/build receipts, full-state evidence, failed attempts and runnable successor/control scripts are retained in the accompanying evidence archive. `postcapture-eligibility.json` and `audited-fifteen-metrics.json` apply the independent rules without rewriting raw observations.

A separate same-binary GPUI Auto-policy supplement selects `ReferenceCpu` on this software-driver host. Its three 30-second idle trials have median CPU 0.00% and peak PSS 15.06 MiB; three fresh warm host-startup trials have median 16.08 ms (range 15.57–22.51 ms). This is ordinary policy behavior, not a faster hardware GPU result, and does not replace the primary forced-GPU profile. The v1 startup wrapper metadata failure and fresh v2 retry remain in evidence.

Evidence: [raw archive](raw-evidence.tar.gz), [archive hashes and verification](archive-receipt.json), [full member inventory](evidence-inventory.json), and [separate frozen source/ELF artifact receipt](source-elf-artifact-receipt.json). The large source/ELF artifact is retained outside Git at the exact path and SHA recorded in its receipt.
