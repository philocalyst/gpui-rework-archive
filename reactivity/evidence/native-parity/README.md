# Native source ingress qualification; parity still incomplete

Local source 1a914c0fdd604f91ba6f4457ab8e89ee86d180ed, based on diagnostic
port 6d5e409d6b3e8994b69c8dbf7a153e8358be5e99. Only the application example
changes. No shipping library/API/dependency/shader change and no performance
verdict. Original archive remains unchanged; nothing pushed.

Workload now belongs to an exclusively owned UI callback. Stream-only mode
uses the existing with_inbox_for registered source. Text generation and the
8192-byte buffer remain on the UI thread. Scroll/both use the owner route.
The producer still sends only tick notifications with one pending tick; it
starts after the first native ACK and is stopped/joined at teardown. The model
retains rendered text, row range/offset and controls. An optional owner ingress
is the equivalent-work control. The unchanged shared Workload is the oracle.

Eight release tests pass (two new port tests and six shared-workload tests).
They exercise buffer trimming, stream/scroll/both/idle, row boundaries, UI-thread
execution, exact source counters, final text, fresh-window and owner-route exact
images, completion and empty/closed delivery. Strict Clippy passes after fixing
an existing snapshot chunks_exact lint; the first failed gate and clean guards
are retained. This slice did not change the library, so no new core suite or
optimization mutant is claimed. Executable SHA/feature/profile receipts are raw.

Five actual private-X11/llvmpipe runs exercise precise stream, owner stream,
scroll, both and idle. All finish and log model/worker/window teardown. Logs and
960x720 screenshots are retained. `native-summary.json` distinguishes delivered
ticks, total ACKs and distinct presentation epochs. Delivery may coalesce;
re-exposure may ACK the same token again. Nominal mounted_rows is the requested
row-range length, not a verified keyed retained-row count. This is qualification,
not a throughput experiment: short runs have no performance acceptance gate.

Harness failures remain: direct-window key release raced WM close, then stale
modifier state closed a retry; the corrected harness uses WM_DELETE_WINDOW.
Two overly strict harness assumptions were rejected against the documented
runtime behavior: one ACK per tick, and strictly increasing epochs despite
re-exposure. Existing completed logs were revalidated with nondecreasing epochs;
only missing idle was run afterward. No timing run was selected as a winner.

Still missing for a fair ZGX comparison: explicit20px/28px line pitch and text
quality qualification, wheel/controlled scroll, keyed two-row overscan, deferred
plus/equals controls, equal build profiles and two physical hardware classes.
The next isolated slice adds explicit line height while preserving the existing
GPUI default. No software Vulkan result proves physical GPU or scanout latency.

Run `python3 verify.py` to check manifest, gate failures, exact test outcomes,
executable identity, all accepted native logs/screenshots and source guards.
