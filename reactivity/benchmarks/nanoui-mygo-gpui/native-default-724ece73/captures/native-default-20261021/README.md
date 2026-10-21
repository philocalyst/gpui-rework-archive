# Native-default Xvfb capture (2026-10-21)

This capture attempted the approved nine cells: eager 0, eager 1,000, and
virtual 250,000 rows for GPUI, MyGo, and NanoUI. A post-capture executable-path
audit found `run-one.sh` launched a different NanoUI binary than the one that
passed preflight. Thus the six GPUI/MyGo cells are valid for their pinned
binaries; the three NanoUI cells are retained raw diagnostics and invalid for
comparison. A corrected NanoUI run followed after the runner was fixed. The intended binary
was `/tmp/gpui-luna-nanoui-output/bin/luna-bench` (SHA-256
`4cb7822c45a757f4d93ada2c0ab45fb2521cbdcb8397e8824e4cc0ef4d9d60a0`), while
`run-one.sh` actually launched `/root/gpui-bench-luna/comparators/nanoui/zig-out/bin/luna-bench`
(SHA-256 `b2d9c6f4ce2745a1e8d9b68c07f831ab2f7756eb349ed14a2c50891403f513a8`).
All nine apps passed the separate pixel/geometry/one-click preflight. The
corrected NanoUI recapture used the manifest binary. Its wrapper enables
`LUNA_REQUIRE_BINARY_IDENTITY=1`, and `run-one.sh` checks the resolved app
path SHA before each observer process launch. The wrapper also dry-runs all
three resolved app paths before starting the recapture. This guard is opt-in in
`run-one.sh` (default `0`); ordinary default paths remain available. Each cell records
100 fresh process startups, 10 marker-toggle clicks per process (1,000 click
samples), and five 750 ms idle RSS/PSS/thread samples. `summarize.py` verifies
sample counts and computes `summary.csv` from raw nanosecond logs. `order.csv`
records the framework order and wall-clock duration per cell.

| App | Workload | Startup p50 / p95 / p99 (ms) | Click-to-exact-pixel p50 / p95 / p99 (ms) | Idle RSS / PSS p50 (KiB) | Threads p50 |
| --- | --- | ---: | ---: | ---: | ---: |
| GPUI | eager 0 | 16.07 / 16.66 / 16.88 | 0.197 / 0.232 / 0.270 | 16,444 / 14,000 | 4 |
| GPUI | eager 1,000 | 31.61 / 32.37 / 32.65 | 1.944 / 2.589 / 2.735 | 20,048 / 17,624 | 4 |
| GPUI | virtual 250,000 | 17.41 / 17.85 / 18.24 | 0.265 / 0.321 / 0.354 | 16,560 / 14,116 | 4 |
| MyGo | eager 0 | 50.96 / 52.18 / 53.99 | 16.36 / 16.47 / 16.66 | 45,112 / 40,787 | 15 |
| MyGo | eager 1,000 | 78.44 / 80.25 / 81.35 | 16.85 / 18.83 / 19.04 | 57,184 / 52,871 | 25 |
| MyGo | virtual 250,000 | 52.08 / 53.43 / 55.28 | 16.47 / 16.57 / 16.78 | 45,488 / 41,107 | 15 |
| NanoUI | eager 0 | 45.51 / 46.72 / 48.99 | 16.80 / 17.14 / 33.20 | 33,484 / 29,427 | 5 |
| NanoUI | eager 1,000 | 47.45 / 48.64 / 49.24 | 16.73 / 21.76 / 33.54 | 34,608 / 30,645 | 5 |
| NanoUI | virtual 250,000 | 45.85 / 47.55 / 48.57 | 16.91 / 17.43 / 33.03 | 33,308 / 29,337 | 5 |

NanoUI rows in the table use the corrected recapture in
`../native-default-nanoui-recapture-20261021/`. The three earlier NanoUI raw
files in this directory are invalid diagnostics and are excluded from
`final-summary.csv`. The final nine-cell summary combines the six valid GPUI/MyGo
cells with the three corrected NanoUI cells. These are measurements of this
exact fixture and host, not universal framework rankings. Startup percentiles
use n=100 launches per cell; click percentiles use n=1,000 clicks per cell.
Idle RSS/PSS/thread medians use n=5 samples per cell. The click endpoint is the X server drawable's
exact marker-pixel transition after XTEST press/release. It includes application
input/event/render response and X server observation, but excludes vblank,
compositor presentation, scanout, and photons. The observer waits on X socket
readiness and XDamage, uses exact pixel equality, and keeps its X connection
open while each cell's 100 fresh processes run. Five idle samples per cell are
read from `/proc/<pid>/status` and `smaps_rollup` after 750 ms.

The runtime is Xvfb `:97`, 1280x800x24, on Linux 6.18.54 x86_64 / AMD Ryzen 7
3700X. This is a software/headless desktop endpoint. GPUI was built with `x11`
and renderer policy `Auto`, but its observed first-frame backend was
`ReferenceCpu`; MyGo used its GTK in-memory software path; NanoUI used Linux
CPU/Cairo. Those renderer paths are not equivalent. GPUI used bundled Noto
Sans; MyGo and NanoUI used staged DejaVu Sans. GPUI's AccessKit support and
MyGo's ATK support were present in their builds; NanoUI at its pin had no
accessibility implementation. The user session's AT-SPI bus was not activatable
(`busctl` reported that `org.a11y.Bus` was not activatable), so no active AT
client/registry was observed. Do not read this as a test with live screen-reader
traffic or as proof that the bridges allocate nothing while inactive.

The three fixtures target the same requested 800x600 client surface, 16 px
text, 24 px row wrappers, 784x530 body viewport, content, and shared marker
coordinate. They preserve each framework's normal widget defaults and
virtual-list overscan; visible rows are the same, while realized row counts
are framework-specific (GPUI 23, MyGo 25, NanoUI 28). Font files and rendering
are not pixel-identical. Earlier mismatched fixture captures are retained in
other result directories and are superseded; they are not part of this table.

The exact source pins, fixture hashes, and intended binary hashes are in
`../../build-manifest.txt` and `../../preflights/private97-20261021-click/`.
`capture-manifest.txt` records the initial NanoUI path/hash mismatch and the
corrective runner identity guard.
The six valid GPUI/MyGo raw logs, original cell order, final summary, and hash
list are in this directory. The three mismatched NanoUI raw logs and corrected
recapture are preserved separately. No launch failures or timeouts occurred;
one executable-identity mismatch was found and corrected before reporting NanoUI.
