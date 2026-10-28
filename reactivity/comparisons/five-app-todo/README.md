# Five-app ordinary Todo campaign

This successor campaign registers the same real Todo workload for GPUI and
four peers: zeronsh/zgui, Zortax/zgui, justrach/nanoui, and egoist/mygo.
The two projects named zgui are distinct applications and remain separate columns.
`protocol.json` freezes revisions, layout, all fifteen requested metric categories,
workloads and acceptance rules. Candidate adapters are not performance results.

The primary application supports real editable draft input, trimmed Add,
Complete/Reopen, All/Active/Done, Delete and one-step Undo. Heavy retains 10,000
rows and constructs them eagerly. Animation translates 1,000 rows in a fixed
viewport with absolute 60 Hz phase. The earlier row-marker fixtures are a separate
rendering microbenchmark and cannot substitute for this application.

`todo_core.py` is the strict successor of the historical ordinary-Todo runner,
copied from `/tmp/zgui-todo-runner-successor/scripts/todo-benchmark.py`. Its original
work/delivery/model acceptance remains in force. Additional lifecycle checks
start each child in its own process group, bound fallback termination to that
group, and reject TERM/KILL escalation as orderly window closure. Source seals
also cover symlink targets and initialized nested gitlinks. `test_todo_core.py` includes the real archived 33-cell
campaign regression: capture is complete and six GPUI cells still fail.

`run.py` adds five-app manifests and counterbalanced serial ordering, refuses
measurements while compiler processes exist, and holds an exclusive `flock`
lease. Every build on that host must hold a shared lock on the **same** file.
Source and binaries are sealed before the first cell and checked before/after
every cell. Failure, source change, unsupported app and normal-close failures
remain in the append-only raw results. A complete capture is distinct from a
passing workload contract.

The independent X11 observer reads actual client-window drawable pixels. It
saves initial/final PPM screenshots, hashes before/after each injected action,
and samples the animated viewport. A successful callback alone cannot establish
visible output. Pixel change alone cannot establish the correct operation;
strict callback counts and the final Todo model remain required. Readback cost
is reported per action; process CPU excludes observer and Xvfb CPU.

Compile all adapters and inspect the `--preflight-only` screenshots and action
receipts before timing. Main capture takes a qualification JSON file with each
available app's `approved: true`, `input_macro_pass: true`, `screenshots` paths,
and `frozen_input` equal to that app's entry in the preflight `freeze.json`.
This review is performed against the concrete source and executable. An absent
binary needs an explicit `unsupported_reason` in the manifest; it is not replaced
with an older executable or fabricated zero resource measurements.

Example orchestration after source/build/environment staging:

```sh
# Builds: shared operation lock; bounded jobs and no concurrent measurements.
flock -s "$TASK_ROOT/host.lock" bash -lc "$EXACT_FROZEN_BUILD_COMMAND"

# Functional/visual probe: still exclusively owns the host; numbers are not
# accepted as primary performance measurements.
python3 run.py --manifest "$TASK_ROOT/manifest.json" \
  --output "$TASK_ROOT/preflight" --lease "$TASK_ROOT/host.lock" \
  --preflight-only --historical-archive "$HISTORICAL_RESULTS"

# Fresh full capture, after source/build freezes and visual/input review.
python3 run.py --manifest "$TASK_ROOT/manifest.json" \
  --output "$TASK_ROOT/capture" --lease "$TASK_ROOT/host.lock" \
  --qualification "$TASK_ROOT/qualification.json" --historical-archive "$HISTORICAL_RESULTS"
```

Capture uses an owned Xvfb and common DBus session. Use a dedicated display,
not any inherited developer display. No cache drop is attempted; startup is
explicitly warm page cache. Cold startup remains unmeasured until an isolated,
reproducible cold-cache procedure can be demonstrated.

Fonts, accessibility implementations and native backend capabilities are
reported individually. GPUI embeds its normal bundled font set. All four peer
adapters resolve an externally provisioned, byte-identical Noto Sans face. External font bytes must accompany size
results. Neither accessibility nor unsupported backend code is removed to win
a comparison. A headless llvmpipe host cannot supply hardware GPU utilization
or physical display smoothness. Host draw/submission cadence is a labeled
diagnostic proxy, retaining each backend's actual observation boundary.

The historical campaign under `../zgui/capture-2026-10-23` remains immutable.
No historical raw value is accepted as a fresh current-source measurement.

`--historical-archive` is mandatory for every capture and preflight. It checks
the exact immutable archive SHA and the six known failed GPUI cells. The default
unit test invocation can skip archive-dependent tests; it is not this mandatory
audit. Run the tests with `TODO_BENCH_RECORDED_RESULTS` set to the archive.

Run `fault_controls.py` with the same manifest, owned display, `--lease`,
`--historical-archive`, and a fresh `--output` before qualification. Its seven
actual native controls require a passing positive macro and rejection of a
suppressed callback with hover, stale marker, duplicate animation delivery,
observer overflow, missing present evidence, and an exit-zero TERM handler
after ignored WM_DELETE. These diagnostic trials are excluded from medians.

The GPUI baseline is pinned at `63e0a521f4`, before the later native
accessibility shutdown patch. Its ordinary model inbox mutates a direct
translation signal and a plain tick counter, and the marker colors are computed
in `View`. Every tick therefore invalidates the owner and constructs all 1,000
row descriptions. This measures the application's reactivity and instrumentation
boundary as well as rendering. Zeron's callback-driven switch and retained
animation transform follow that framework's idiom. Any GPUI direct-recipe
successor must be frozen and reported separately.

Peer source exports cover the complete upstream tracked blob set plus explicit
adapter files. NanoUI's optional `apps/*` gitlinks are recorded without expanded
submodule contents and are outside this Todo build. GPUI's archive deliberately
covers only anchored `.cargo`, `clippy.toml`, `reactivity/Cargo.toml`,
`reactivity/Cargo.lock`, `reactivity/rust-toolchain.toml`, `reactivity/crates`, and
`reactivity/vendor`; exact set equality and per-file Git blobs are verified.
This is build-scope coverage, not a full repository or cross-platform snapshot.

The separately versioned `presentation_audit.py` corrects an acceptance gap in
the frozen runner: correct model tick delivery and three changed drawable
samples could pass with too few native submissions. Its policy was fixed before
reviewing the primary animation cells. It verifies the complete monotone integer
receipt stream, exact recorded measurement subset and count, observer capacity,
first epoch and pipe-clock alignment, and the full requested external duration.
At 60 Hz it requires at least `floor(requested_seconds * 60) - 2` receipts;
the two-frame allowance covers endpoints, rather than a percentage of missed
frames. Extra receipts are reported and do not excuse gaps longer than two
periods. Those gaps and leading/trailing gaps remain explicit diagnostics.

This postcapture audit preserves original results and acceptance flags. Animation
resource medians require both the original workload gate and this audit. The
native receipt boundaries differ by framework; pipe alignment is approximate.
Timestamps carry no presented source revision, so a passing count establishes
host-receipt adequacy and recording integrity. It does not prove every tick
visible or physical display smoothness. The offline suite contains a constructed starvation counterexample. The completed
capture also includes a separate actual native control: backend render/present
is deferred while model updates and the normal receipt observer continue. Its
485 model ticks pass the old gate with only 28 measured host receipts; the new
audit rejects it, while the matching 360-receipt positive control passes.


The [completed capture report](capture-2026-10-24/report.md) records all 75 primary
cells and the versioned followups. The original parity marker accepts an
all-black revision-zero region; it is insufficient evidence of initial UI
painting. Postcapture chrome-anchor readback and the separate visible-startup
profile preserve this limitation explicitly. The original Zeron Heavy injector
coordinates miss two filter controls; its three corrected reruns keep the same
strict deadlines and also fail. Zortax's black final idle readbacks exclude its
idle resource medians. No failed or unsupported cell becomes a performance win.

Rebuild the audited report after extracting `raw-evidence.tar.gz` into an empty
directory with `python3 audited_report.py --evidence EXTRACTED --output REPORT`.
The archive inventory lists every retained member's SHA256 and bytes; executable
copies are omitted with their hashes retained in receipts and the exclusion list.
GPUI's ordinary Auto policy has a separate same-binary ReferenceCpu startup/idle
profile, never pooled into the primary forced-GPU results.
