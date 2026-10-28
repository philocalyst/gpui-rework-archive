# Todo framework comparison

This checkout contains a native Todo port and a reproducible comparison runner.
It pins [`zeronsh/zgui`](https://github.com/zeronsh/zgui/tree/c077cd3bc2e63311e04ecc0e7b484c7e1192d595)
at commit `c077cd3bc2e63311e04ecc0e7b484c7e1192d595` (2026-10-23, MIT) and
uses its committed `Cargo.lock` unchanged. The coordinating
GPUI checkout supplies the matching application adapter and lockfile.

The application starts empty at 540 by 620 logical pixels. It supports trimmed
draft input, ignoring empty drafts, increasing stable IDs, All/Active/Done
filters, Complete/Reopen, delete with one-step Undo at the original list
position, and remaining-item count. Text input and named controls use the
framework's accessibility semantics. Todo rows are keyed and retained; a
360-pixel list viewport clips and scrolls the eager, nonvirtualized rows. The
matched empty workload uses the same comparison structure in both frameworks,
so it is not the original unmodified GPUI example.
The zgui text field exposes the accessible name “New task”; GPUI also attaches
an explicit description. The comparison does not claim identical descriptions
for assistive technology.

Noto Sans, Noto Sans Arabic and Noto Sans Hebrew are embedded with their SIL
Open Font Licenses in `crates/zgui-desktop/examples/support/todo_fonts/`.
This matches GPUI's bundled font policy and includes these font bytes in the
executable-size measurement. Text behavior beyond the ASCII benchmark corpus
has not been established as identical.

The code-only patch intentionally omits copied font binaries. To provision
them from the GPUI checkout before building, copy the files below into
`crates/zgui-desktop/examples/support/todo_fonts/` (renaming the two license
files as shown); then verify each font's size and SHA-256:

```sh
src=/path/to/gpui/reactivity/crates/canvas/assets
dst=crates/zgui-desktop/examples/support/todo_fonts
mkdir -p "$dst"
cp "$src/NotoSans.ttf" "$dst/NotoSans.ttf"
cp "$src/arabic/NotoSansArabic-Regular.ttf" "$dst/NotoSansArabic-Regular.ttf"
cp "$src/hebrew/NotoSansHebrew-Regular.ttf" "$dst/NotoSansHebrew-Regular.ttf"
cp "$src/OFL.txt" "$dst/OFL.txt"
cp "$src/arabic/OFL.txt" "$dst/OFL-arabic.txt"
cp "$src/hebrew/OFL.txt" "$dst/OFL-hebrew.txt"
sha256sum "$dst"/*.ttf
```

| Destination | GPUI source | Bytes | SHA-256 |
| --- | --- | ---: | --- |
| `NotoSans.ttf` | `reactivity/crates/canvas/assets/NotoSans.ttf` | 2,049,096 | `bfb7bb691513f12e734dc346c03a03f784912432d7e3fa8e56efcf906fe86b3d` |
| `NotoSansArabic-Regular.ttf` | `reactivity/crates/canvas/assets/arabic/NotoSansArabic-Regular.ttf` | 240,456 | `ceea25b464a656dc3b26849bab9356740401af62aedf1bfa8b7f0d9b75925b1b` |
| `NotoSansHebrew-Regular.ttf` | `reactivity/crates/canvas/assets/hebrew/NotoSansHebrew-Regular.ttf` | 26,900 | `a7fa16fffb27bedb060a0866267c29e9859aeb9c21cc33f5b3aaf6eb062eca85` |

The source license files are the matching `OFL.txt` files beside each GPUI
font. The patch includes copies named `OFL.txt`, `OFL-arabic.txt` and
`OFL-hebrew.txt`.

The runner counterbalances app order on three 30-second pairs per workload,
following a five-second settle after first successful presentation. It writes
raw JSON-lines measurements and each app's stdout/stderr under the output
directory. Summary medians use the intersection of valid repeat IDs; a failed
cell is retained and later independent cells continue. CPU and memory samples
from overload or unmatched work remain in the raw file, but do not contribute
to a paired summary.

| Category | Workload and captured field |
| --- | --- |
| CPU idle | Matched empty Todo after settling; process CPU over wall time |
| CPU busy | Fixed 4 events/second; process CPU and requested/dispatched/completed/callback counts |
| CPU heavy | 10,000 seeded, nonvirtualized Todo rows plus the same 30s interaction macro; process CPU and delivery counts |
| CPU animation | 1,000 seeded rows; 60 Hz, ±12-pixel sine translation; CPU and delivered/skipped animation tick counts |
| GPU busy/heavy/animation | Unavailable: host lacks a render node and uses llvmpipe |
| Memory idle/heavy/animation | RSS, PSS and private pages sampled from `/proc` |
| Smoothness busy/heavy/animation | Successful host-submit intervals and frame counts; pacing proxy, not click latency or physical scanout timing |
| Startup work | Warm-page-cache external launch to first successful `Presented`, cumulative CPU ticks and faults |
| App size | As-built and stripped-copy executable bytes, SHA-256, ELF dependencies and embedded font bytes |

The busy sequence repeats every two seconds on absolute 250 ms deadlines:
focus/type `bench-NNN`, Add, Complete/Reopen the first row, Active, Done, All,
Delete the first row, Undo. It requests one text operation and seven button
activations per cycle. A 30-second run requests 120 events. The runner records
dispatched and successful xdotool operations, missed deadlines and injector
failures, then checks callback count, final row count and draft against expected
state. Incomplete work keeps its CPU and memory measurements but is marked
unmatched.

Heavy mode seeds 10,000 rows and runs the same interaction macro as Busy;
animation seeds 1,000 rows. Both retain every row
and use the same 360-pixel clipped viewport. Animation translates list content
inside the stationary clip by a 12-pixel amplitude sine wave at 60 scheduled
samples per second, with phase based on sample index and a one-second period.
After first present, the runner waits five seconds and measures exactly 30
seconds; frame intervals are filtered to that window. Animation ticks must
match the measured first-present-to-close lifetime within 1% (minimum three
ticks of scheduling tolerance), report zero skipped deadlines, and on GPUI the
worker's enqueued count must equal the model's received count. The report keeps
the tick counts next to animation CPU results.

The capture host is an AMD Ryzen 7 3700X with 16 logical CPUs, approximately
64 GiB RAM, an ASPEED display adapter and no render node. Both programs use the
same Mesa software Vulkan path and `LP_NUM_THREADS=4`. Process CPU includes
llvmpipe workers, is normalized so 100 percent means one occupied logical core,
and excludes the Xvfb process. GPU utilization is recorded as unavailable, not
as zero. Successful host presents are renderer submissions/acknowledgements;
they cannot establish physical scanout or perceptual smoothness. Startup is
warm-page-cache; no cache drop is attempted. The runner saves source revisions,
lockfile and before/after source/binary fingerprints, build logs and Cargo
fingerprint JSON, Rust toolchain, build settings, workload counts, renderer
identity and raw samples in `metadata.json` and `results.jsonl`. The first-frame
marker is emitted only after a successful host submission acknowledgement.
External launch-to-marker is paired with process CPU ticks and faults read at the
marker. GPUI's auto-renderer launch is a separate supplemental startup series;
it is not pooled with the forced native-GPU comparison mode.

The size capture preserves each original executable, then applies the same
`strip --strip-all` tool to copies. The zgui binary keeps the upstream default
X11 and Wayland feature set; the GPUI comparison binary is X11-only. ELF
dependencies show this feature-policy difference. zgui uses the real Nix DBus
1.16.2 shared library through an archived `dbus-1.pc` metadata shim because the
runtime store has the library but no pkg-config development file. No vendored or
static DBus library is substituted.

Every cell saves its 100 ms process samples (including raw CPU ticks, page
faults, RSS, PSS and private pages), sample cadence, absolute monotonic start
and end, and duration. Present cells retain the full buffered host-submit
timestamps, the external first-marker receipt and internal-clock alignment,
and the exact filtered measurement window. Startup saves process snapshots at
exec and first marker. Tables show median and min/max spread per run; animation
and smoothness rows also include the corresponding tick/frame counts.

The prepared binary inputs for this capture are GPUI source `63291a4ce494a7b6e129f0208004543b061c83ab` and executable SHA-256 `042c61b327da627fc4b059d95bcc8dabf7e592eb1e8715e269562860e0ec04fa` at `/tmp/gpui-todo-comparison-qualified/gpui-todo-frozen`, plus this checkout's zgui source and executable SHA-256 `e8a5de7f1c984e4dbde84b8532963b6970e1ea2aea9de2722758c499e69b7ad3` at `/tmp/gpui-zgui-todo-target/release/examples/todos`. Build logs and Cargo fingerprints are under those directories and are passed to the runner below. The zgui build used the committed lockfile, Rust 1.97.1, release opt-level 3, thin LTO, one codegen unit, no debug info, unstripped output and flags `-C symbol-mangling-version=v0 --cfg tokio_unstable`; `build-command.txt` records the command and DBus metadata shim. Do not rebuild either binary after freezing the campaign inputs.

Source the native capture environment in the same shell and use the owned
Xvfb display, never the inherited `:93`:

```sh
source /tmp/gpui-native-env.sh
export PATH="/nix/store/sn8r7j6q1js540y5briylnb62203zxq5-pkg-config-wrapper-0.29.2/bin:$PATH"
export PKG_CONFIG_PATH=/tmp/gpui-zgui-todo-pc
DISPLAY=:230 python3 scripts/todo-benchmark.py \
  --gpui-bin /tmp/gpui-todo-comparison-qualified/gpui-todo-frozen \
  --zgui-bin /tmp/gpui-zgui-todo-target/release/examples/todos \
  --gpui-source /tmp/gpui-todo-comparison-root/reactivity \
  --controls comparisons/todo/controls.json \
  --gpui-build-log /tmp/gpui-todo-comparison-qualified/build.log \
  --gpui-fingerprint /tmp/gpui-todo-comparison-qualified/example-fingerprint.json \
  --zgui-build-log /tmp/gpui-zgui-todo-release-build-final.log \
  --zgui-fingerprint /tmp/gpui-zgui-todo-target/release/.fingerprint/zgui-desktop-ffe023f59e83cdc3/example-todos.json \
  --output /tmp/todo-comparison-capture
```

Use the Python executable from the prepared environment if `python3` is not
on `PATH`: `/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3`.

The runner expects `GPUI Todo comparison` for GPUI and `Todos` for zgui, and uses preflighted,
per-framework client points in a 540 by 620 logical-pixel window. Points are in
`controls.json`; revalidate them after any source or geometry change. Final
visual probes confirm square controls, a hidden scrollbar, equal 40-raster-pixel
input/Add fills, and 44-raster-pixel row stride (43.792 logical pixels), matching
GPUI's 41.792-pixel controls and 43.792-pixel row stride at scale 1.

Run all apps under one DBus session on the owned Xvfb display so both inherit
the same session environment. For example, replace `python3` with the absolute
Python path shown above when needed and wrap the runner:

```sh
dbus-run-session -- env DISPLAY=:230 python3 scripts/todo-benchmark.py ...
```

The exact native calls used for the final screenshot and functional probes are
in `/tmp/zgui-todo-native-probe-final6/`; they used display `:248`, never
`:93`, and closed each app through `WM_PROTOCOLS/WM_DELETE_WINDOW`.

## Captured results

The runner reports capture completeness separately from workload-contract
success in `campaign-status.json`. It exits nonzero if a preregistered cell is
missing, duplicated, errors, changes a frozen input, fails its final model or
delivery checks, or fails orderly close. `--preflight-only` checks both an
empty startup and a short seeded 1,000-row animation followed by normal close;
the latter catches shutdown paths that an idle-only launch test misses. The
archived 33-row capture is complete but does not pass every workload contract:
all three GPUI Heavy cells missed interaction work, and all three GPUI Animation
cells failed animation/close validation. The report keeps those cells' CPU,
memory and host-present measurements as descriptive overload evidence. Offline
regression tests can audit that archive with
`TODO_BENCH_RECORDED_RESULTS=/path/to/results.jsonl python3 -m unittest
scripts/test_todo_benchmark.py`.

The final campaign contains 24 measured cells (four workloads, three repeats,
two frameworks) and nine startup launches. [report.md](capture-2026-10-23/report.md)
summarizes all 15 requested categories. `results.jsonl` preserves every raw
per-process sample, frame timestamp, work receipt, and source/binary guard;
`metadata.json`, `provenance.json`, build inputs and application logs document
the capture setup. The first attempt's raw rows, logs and failure note are
archived under [`campaign_failure`](capture-2026-10-23/campaign_failure/) and
excluded from the final results.

Busy and idle workloads yielded three matched pairs. The 10,000-row and
animation workloads show an overload difference: zgui matched all requested
work, while GPUI missed button callbacks and animation deadlines/presents.
The report keeps every CPU and memory sample and shows delivered work beside
those measurements without presenting unequal work as a paired win. GPU
utilization is unavailable on this software-rendered host.
