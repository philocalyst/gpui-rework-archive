# Color-only pointer campaign results

Completed 2026-10-22 on persistent Xvfb `:109` using the frozen paint-only 5f4 GPUI fixtures and pinned MyGo/NanoUI binaries. The fixed protocol completed all 16 cells: 100 fresh starts and 1,000 clicks per cell, plus five 750 ms idle-memory samples. All raw files, run manifest, order, and hashes are preserved beside this report. No cells were cut or rerun.

Each click measures synchronized pointer motion/button input through exact marker-pixel change acknowledged by XDamage/readback on the X11 drawable. This is not compositor, vblank, hardware scanout, or photon latency. Startup is process-launch to first exact server pixel. Click and startup figures are milliseconds, p50/p95/p99. RSS/PSS are KiB from five short idle samples; thread counts are observed values.

The GPUI within-framework control/direct pair is the causal comparison. Direct uses registered `.bg(&Signal)` and `Source::update`; control reconstructs the full description. Peer values are contextual framework-native full-frame paths, not a ranking: GPUI uses Auto and selected ReferenceCpu; NanoUI uses GTK/Cairo CPU; MyGo uses its native Linux path. GPUI builds include the AccessKit backend, but no active assistive-technology client was established. GPUI uses bundled Noto Sans; peers use DejaVu Sans. Realized virtual rows differ: GPUI 23, MyGo 25, NanoUI 28. All use the same checked 800×600 task, row IDs/content, marker transition, and X11-pixel endpoint; renderer, font, overscan, and widget styling remain different.

| Variant | Workload | Startup p50/p95/p99 ms | Click p50/p95/p99 ms | Idle RSS min–max KiB | Idle PSS min–max KiB | Threads |
|---|---|---:|---:|---:|---:|---:|
| gpui-control | eager-0 | 15.926/16.391/16.536 | 0.151/0.189/0.207 | 17156–17424 | 14982–15252 | 4 |
| gpui-control | eager-1000 | 31.465/32.403/34.441 | 1.994/2.620/2.757 | 20464–20880 | 18290–18706 | 4 |
| gpui-control | eager-10000 | 182.939/185.844/190.023 | 24.167/28.964/29.874 | 52656–53208 | 50482–51034 | 4 |
| gpui-control | virtual-250000 | 17.180/17.584/17.952 | 0.214/0.267/0.298 | 17192–17444 | 14753–15264 | 4 |
| gpui-direct | eager-0 | 16.008/16.735/17.618 | 0.130/0.164/0.200 | 17172–17404 | 14992–15224 | 4 |
| gpui-direct | eager-1000 | 31.439/32.317/32.721 | 0.143/0.238/0.287 | 20744–20932 | 18570–18758 | 4 |
| gpui-direct | eager-10000 | 181.919/186.399/187.816 | 0.274/0.683/0.785 | 52972–53144 | 50826–50992 | 4 |
| gpui-direct | virtual-250000 | 17.105/17.532/17.698 | 0.135/0.162/0.181 | 17300–17392 | 15120–15212 | 4 |
| mygo | eager-0 | 51.113/53.029/53.924 | 16.363/16.444/16.576 | 44856–45256 | 40499–40913 | 15 |
| mygo | eager-1000 | 78.568/80.913/82.345 | 16.921/18.795/19.167 | 56872–57260 | 52530–52934 | 24/25 |
| mygo | eager-10000 | 325.026/359.275/366.230 | 38.170/65.736/67.639 | 156428–159640 | 152147–155274 | 27/28 |
| mygo | virtual-250000 | 52.146/53.108/53.671 | 16.469/16.559/16.737 | 45256–45612 | 40955–41318 | 15 |
| nanoui | eager-0 | 47.230/49.050/50.735 | 16.512/17.581/17.875 | 33192–33588 | 29263–29516 | 5 |
| nanoui | eager-1000 | 49.403/50.942/51.146 | 16.458/33.050/33.883 | 34448–34792 | 30467–30755 | 5 |
| nanoui | eager-10000 | 67.544/69.611/71.065 | 35.826/41.980/49.842 | 48764–49076 | 44753–45049 | 5 |
| nanoui | virtual-250000 | 47.628/48.407/49.362 | 16.648/17.144/18.066 | 33188–33532 | 29257–29492 | 5 |

The direct GPUI path reduces the median server-pixel click latency relative to its matched full-description control in all four workloads: eager-0 0.130 vs 0.151 ms; eager-1,000 0.143 vs 1.994 ms; eager-10,000 0.274 vs 24.167 ms; virtual-250,000 0.135 vs 0.214 ms. Startup distributions are close between the paired binaries; this campaign does not show a startup improvement. At 10,000 eager rows the control p95 is 28.964 ms while direct is 0.683 ms. These are this fixture, host, frozen build and Xvfb observation results; they do not imply every reactive style update takes the same path. The virtual-list cell specifically shows that this direct paint path did not pay the full realization cost in this fixture.

The five-sample idle RSS/PSS ranges are diagnostic only, not population estimates. Memory and thread counts varied substantially by framework and realization. The source/binary identities and process-level raw rows should be retained when citing any cell. See `run-manifest.txt` for exact commits, fixture/binary hashes, backend and accessibility disclosure, and `sha256.txt` for artifact integrity.
