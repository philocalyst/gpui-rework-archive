# Todo comparison results

Each value is the median of the valid paired runs listed in `results.jsonl`. Busy/heavy results are ranked only when requested events, callbacks, and final model state all match. Raw failed or unmatched trials remain in the JSONL file.
A first launch attempt exposed an incorrect GPUI window-title assumption and a non-executable zgui copy; it is archived separately and contributes no values below. Both binaries passed the subsequent launch/present/geometry/renderer/model/close preflight.

| Category | GPUI | zgui | Valid trials |
| --- | ---: | ---: | ---: |
| CPU idle (one core = 100%) | median 0.00 (range 0.00–0.03)% | median 0.00 (range 0.00–0.00)% | 3 matched pairs |
| CPU busy (one core = 100%) | median 51.77 (range 50.87–51.87)% | median 1.50 (range 1.47–1.53)% | 3 matched pairs |
| CPU heavy (one core = 100%) | unmatched / unavailable | unmatched / unavailable | 0 matched pairs |
| CPU animation (one core = 100%) | unmatched / unavailable | unmatched / unavailable | 0 matched pairs |
| GPU busy | N/A | N/A | Not measurable on this host: no render node; Mesa llvmpipe CPU rendering |
| GPU heavy | N/A | N/A | Not measurable on this host: no render node; Mesa llvmpipe CPU rendering |
| GPU animation | N/A | N/A | Not measurable on this host: no render node; Mesa llvmpipe CPU rendering |
| Memory idle (median peak PSS / RSS / private) | PSS median 110828 (range 110462–111142) / RSS median 111764 (range 111424–111820) / private median 110036 (range 109700–110720) KiB | PSS median 111206 (range 111168–111392) / RSS median 112472 (range 112352–112636) / private median 110296 (range 110276–110488) KiB | 3 matched pairs |
| Memory heavy (median peak PSS / RSS / private) | unavailable | unavailable | 0 matched pairs |
| Memory animation (median peak PSS / RSS / private) | unavailable | unavailable | 0 matched pairs |
| Smoothness busy (not physical scanout) | p95 submit interval median 268599 (range 268581–268820) µs; frames median 153 (range 151–154) | p95 submit interval median 252130 (range 252011–252422) µs; frames median 312 (range 303–315) | 3 matched pairs |
| Smoothness heavy (not physical scanout) | unmatched / unavailable | unmatched / unavailable | 0 matched pairs |
| Smoothness animation (not physical scanout) | unmatched / unavailable | unmatched / unavailable | 0 matched pairs |
| Startup work (warm cache; exec→host submit, CPU ticks, minor faults) | median 148.4 (range 148.1–149.3) ms; CPU ticks median 16 (range 16–16); minor faults median 9171 (range 9143–9941) | median 67.6 (range 67.6–68.9) ms; CPU ticks median 6 (range 6–7); minor faults median 9357 (range 9357–9430) | 3 paired launch sets |
| GPUI auto-renderer startup (supplemental) | median 16.0 (range 15.9–16.0) ms | — | n=3; separate from binary-default series |
| App size (as-built) | 25,839,328 B | 28,004,320 B | SHA-256 in metadata |
| App size (stripped copy) | 20,441,664 B | 21,226,176 B | Copy-only stripping; binaries remain unmodified |

## Heavy-load observations

These descriptive rows include every captured Heavy and Animation trial, including overload runs excluded from matched-work rankings. They show resources and delivered work together; they do not declare a resource winner when delivery differs.

| Workload | Framework | Matched cells | CPU % (one core=100) | Peak PSS / RSS KiB | Callbacks / ticks | Skipped ticks | p95 host-present interval µs | Host presents / rate Hz |
| --- | --- | ---: | --- | --- | --- | --- | --- | --- |
| heavy | gpui | 0/3 | n=3; median 99.93 (range 98.30–100.56)% | PSS n=3; median 242686 (range 242198–242962) / RSS n=3; median 243680 (range 243160–243944) | callbacks n=3; median 21 (range 20–24); ticks n=0 | n=0; not applicable | n=3; median 2025694 (range 2010816–2039681) | frames n=3; median 26 (range 22–26); rate n=3; median 0.87 (range 0.73–0.87) |
| heavy | zgui | 3/3 | n=3; median 68.43 (range 68.30–68.46)% | PSS n=3; median 461220 (range 460236–471292) / RSS n=3; median 462484 (range 461508–472544) | callbacks n=3; median 105 (range 105–105); ticks n=0 | n=0; not applicable | n=3; median 927055 (range 925665–927679) | frames n=3; median 115 (range 115–116); rate n=3; median 3.83 (range 3.83–3.87) |
| animation | gpui | 0/3 | n=3; median 362.31 (range 362.00–362.70)% | PSS n=3; median 122844 (range 122360–123024) / RSS n=3; median 123804 (range 123324–123988) | callbacks n=3; median 0 (range 0–0); ticks n=3; median 1108 (range 1105–1117) | n=1; median 999 (range 999–999) | n=3; median 39403 (range 39011–39728) | frames n=3; median 822 (range 819–828); rate n=3; median 27.40 (range 27.30–27.60) |
| animation | zgui | 3/3 | n=3; median 20.17 (range 20.17–20.37)% | PSS n=3; median 146243 (range 145859–146359) / RSS n=3; median 147512 (range 147076–147596) | callbacks n=3; median 0 (range 0–0); ticks n=3; median 2105 (range 2105–2105) | n=3; median 0 (range 0–0) | n=3; median 17288 (range 17280–17295) | frames n=3; median 1800 (range 1800–1800); rate n=3; median 60.00 (range 60.00–60.00) |

GPUI Heavy callback deficits and GPUI Animation deadline/present deficits are overload observations. Their CPU and memory samples remain visible above even though the corresponding requested work did not match. zgui's cells matched their required callbacks/ticks; compare the delivered-work columns before interpreting resource use. Present intervals are host-submit pacing proxies, not physical scanout or input latency.

GPU utilization is unavailable: the host exposes an ASPEED display adapter without a render node and uses Mesa llvmpipe. Successful-present intervals are host submission/acknowledgement intervals, not scanout or perceived smoothness. CPU includes llvmpipe worker threads and excludes Xvfb. Page cache remained warm. App-size includes zgui's default X11+Wayland dependency feature set while the GPUI comparison build is X11-only; see ELF dependencies and hashes in `metadata.json`.

Busy requests 120 absolute-deadline events over 30 seconds (15 text operations and 105 button activations); heavy uses the same sequence with 10,000 seeded rows. The runner preserves overload and failed-work samples without treating them as matched performance wins.

The three GPUI animation runs also failed to close cleanly: the raw logs show a panic at `crates/gpui/src/runtime/delivery.rs:228` with `mounted owner exists`. The failure followed window retirement while queued `WorkReady` work was being delivered. Those animation resource samples are descriptive overload observations only; this frozen campaign was not rerun with a subsequent fix.
