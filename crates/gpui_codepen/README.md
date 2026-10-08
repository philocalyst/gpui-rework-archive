# GPUI Codepen

A GPUI source editor beside a live GPUI window. Component source uses the real
`gpui` crate: `Render`, `Entity`, `Context`, ordinary elements, custom elements,
closures, event listeners and scene painting. The execution engine is the full
vendored Miri interpreter. The guide and preview both render with GPUI, on the
desktop and in the browser.

```sh
python3 scripts/codepen/setup.py
cargo run -p gpui_ce_codepen --bin gpui-guide
```

The setup script builds the pinned interpreter and cargo wrapper, prepares its
sysroot, and compiles the shared framework dependencies. It does not change the
default toolchain. See [Miri provenance](../../vendor/MIRI-PROVENANCE.md).
Native and browser Miri share the interpreter's immutable call and layout caches.
The native build requires GNU or BSD `patch` and caches its patched interpreter
under `target/codepen-native-interpreter`; setup verifies CTFE, guest execution
and cancellation after building it.

For the web guide, install Trunk and the pinned WASM target, then run:

```sh
rustup target add --toolchain nightly-2026-09-30 wasm32-unknown-unknown
python3 scripts/codepen/browser.py all
python3 scripts/codepen/web.py
```

Open http://127.0.0.1:8080. The browser build includes the pinned Rust compiler
and full Miri in a WebAssembly Worker, using JavaScript Promise Integration to
suspend for input without blocking the editor. The default mode needs no compiler
server. Its initial full compiler build is substantial; generated assets live in
`target/codepen-browser/miri`. Use a browser with `WebAssembly.Suspending` and
`WebAssembly.promising` support.

The bundle contains precompiled MIR for the built-in lessons. Add
`--starter-dir /path/to/components` to `browser.py bundle` to include exact initial
`.rs` sources from a documentation site. Matching source executes its shipped
MIR; edits use the real Rust frontend in an independent compiler Worker. Compiler
assets are compressed and cached. Compatible edits install compiled MIR into
the resident interpreter at an input boundary, retaining actual GPUI entities,
boxed callbacks, vtables, state and the last good frame. The browser compiler
reuses an incremental query cache with ICH verification enabled. Arena-keyed
stable-hash memos are reset at every compiler session boundary.
After the first preview frame, its separate compiler warms the initial source
in the background. This never applies MIR or publishes diagnostics; edits reuse
that compiler and coalesce behind an unfinished warmup. Set the bundle manifest's
`prewarm_compiler` to `false` to compare startup and first-edit latency.

Immutable SDK metadata is loaded in 16 KiB pages. A measured prefetch plan ships
the common working set; content-addressed 256 KiB chunks provide every remaining
byte when arbitrary Rust uses another API. Starter MIR is cached separately from
the SDK. The exact full bundle remains in `target/codepen-browser/miri-full` for
comparison. Set `GPUI_CODEPEN_PAGED_METADATA=0` for the contiguous reference build.
The prefetch plan affects loading only, never which Rust or GPUI APIs are available.
Definition hash tables use their original serialized format with range probes,
so discovering a dependency does not materialize its entire table. Regenerate
the plan from actual worker page reports with
`measure-metadata-working-set.py --write-prefetch path.json profile.txt ...`.
Initialized Rust metadata pages and fetched JS chunks are currently retained
until their Worker is replaced. Bootstrap reads retain the shared Blob without
a second JS page cache; cold-chunk eviction and a measured memory ceiling remain
outstanding.

The fixed SDK uses MIR inline thresholds of 150 (ordinary calls) and 300
(`#[inline]` calls). These are explicit Cargo `RUSTFLAGS`, so changing them
invalidates the dependency cache. Edited component code keeps the pinned
compiler's ordinary thresholds and its reload boundaries; SDK flags are removed
from captured component invocations. The optimization trades larger SDK metadata
for fewer interpreted calls. Compare both redraw CPU and cold startup when
changing these settings.

Changing definitions, Rust type layouts, closure capture order, compile-time
values or coroutine layouts starts a fresh app. Reset also starts a fresh app.
Active calls finish with their original MIR; later calls use the installed body.
Resident compiler arenas currently retain old MIR, so a bounded revision/memory
budget also requires a fresh interpreter. Reclaiming retired bodies remains work.

`python3 scripts/codepen/web.py --native-companion` explicitly selects the local
compiler development mode, with an automatically chosen loopback port and proxy.
The full browser Worker probe verifies state-preserving edits and exact native
frame parity for events, animation, asynchronous tasks, IME and dynamic layouts.
Cold startup and rendering latency still need improvement.

## Component source

```rust
use gpui::{*, prelude::*};

struct Counter { count: usize }

impl Render for Counter {
    fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div().id("counter").p_6().bg(rgb(0x18382b)).text_color(white())
            .child(format!("Count: {}", self.count))
            .on_click(cx.listener(|this, _, _, cx| {
                this.count += 1;
                cx.notify();
            }))
    }
}

fn component(_: &mut Window, cx: &mut App) -> Entity<Counter> {
    cx.new(|_| Counter { count: 0 })
}
```

The harness calls `component` once. Its entity, state, subscriptions and callbacks
stay alive in the interpreter across input and animation frames. Compatible source
edits update their executable bodies without rebuilding the app. Reset state restarts
the same source. Restore lesson restores the original lesson source. Drafts use
versioned local storage, independently for each lesson.

## Rendering and scheduling

The interpreter runs a real headless GPUI app, including layout, element state,
event dispatch and scene construction. Its platform text trait delegates to the
existing compiled Parley backend, including glyph rasterization and bidi/caret
operations. This retains the backend's semantics without interpreting font
shaping and rasterization loops. These platform services run off the UI thread.

Finished scenes and their atlas pixels use a versioned binary transport. The host
imports those pixels into its own GPUI atlas, reusing identical resources, and
composes scene primitives into the containing window. Paths, shadows, sprites,
clipping, opacity and filter groups use the existing GPUI renderers. No extra
preview rasterizer or limited element/style vocabulary is involved.

Edits debounce for 100 ms. Rapid browser edits keep one active compilation and
one latest source slot, skipping intermediate sources while retaining the warm
compiler. An exact-source undo reuses the active result with the newest input.
Obsolete compilation has a fixed escape deadline; the last valid app stays
resident. Native process groups support cancellation;
browser compiler cancellation is independent of the VM. Browser input stays
ordered, with a bounded interruption deadline for obsolete execution. JSPI
basic-block checkpoints acknowledge cancellation; a hard-stop fallback covers
unresponsive Workers. Compiler Workers and their caches survive VM restarts
when their crate identity remains the same.
Native incremental exports can be enabled with `GPUI_CODEPEN_INCREMENTAL=1`;
the wrapper keeps the initial VM and compiler-only metadata output contracts
identical, and compiler options precede the guest argument separator.
Stale replies cannot replace newer source. Compilation
errors retain the last good preview. Native workers and browser requests are
asynchronous. Ordered event batches coalesce consecutive pointer moves. Frame
callbacks and async timers determine when another frame is requested; idle
components do not continuously render. Inputs that do not redraw GPUI reuse the
captured scene and its wire bytes while refreshing cursor, text-input and timer
metadata. The host likewise reuses the imported scene for unchanged pixels.

The input bridge includes mouse, keyboard, scrolling, raw touch, native file
drops, cursor state, and typed text/IME mutations through GPUI's platform input
handler. Native text queries read the last completed guest frame. Arbitrary
character hit-test queries and bounds for uncaptured text ranges are not yet
proxied. Backend-owned native video/surface handles are not portable scene
resources. External app-shell services such as native dialogs are provided by
the headless platform rather than the desktop OS. These limits do not change
the component's GPUI API, but they remain integration work.

Miri validation, borrowing, race, alignment, leak backtraces and isolation are
disabled for this interpreter use case. Source is capped at 64 KiB and binary
frames at 64 MiB. The native companion is local and has access to the user's
process environment and filesystem. The browser interpreter uses its
Worker-owned virtual filesystem.

The native guide uses a dedicated control socket; interpreted stdin/stdout cannot
consume input packets or forge frame messages. Standalone Miri transport fixtures
retain the pipe protocol. The browser uses Worker messages and JSPI host imports.

## Verification

```sh
cargo test -p gpui_ce_codepen --lib --test session
cargo test -p gpui_codepen_guest --features host-services
cargo test -p gpui_ce_codepen --test engines -- --ignored --nocapture --test-threads=1
cargo test -p gpui_ce_codepen --test server -- --ignored --nocapture
python3 scripts/codepen/test-mir-reload.py
GPUI_CODEPEN_TEST_STARTER=1 python3 scripts/codepen/test-mir-reload.py
node scripts/codepen/test-browser-runtime.mjs
node scripts/codepen/test-browser-metadata.mjs
python3 scripts/codepen/test-page-metadata.py
python3 scripts/codepen/test-native-interpreter.py
node scripts/codepen/probe-browser-incremental.mjs
node scripts/codepen/probe-browser-reload.mjs
node scripts/codepen/probe-browser-reload.mjs target/codepen-browser/miri --documentation-starters
node scripts/codepen/probe-browser-reload.mjs target/codepen-browser/miri --guide-lessons
```

The full Miri tests execute real GPUI render implementations, entity callbacks,
source edits, scale/resize changes, all lessons, cancellation and recovery, and
report resident-frame timings. The companion tests cover browser sessions and
cancellation. Platform tests compare bidi/caret/selection results with Parley.
The full browser probe uses production workers and compares entire native frames
for state-preserving edits, animation, async timers and UTF-16 IME composition.
Generate its references with the engine tests and include
`--starter-dir target/codepen-browser-probe` when bundling. Mock transport tests
are separate from the full compiler/interpreter probe.

For interpreter comparisons, run the canonical engine test to generate all 21
counter frames, then compare two bundles with
`benchmark-redraw.py CONTROL CANDIDATE --output target/redraw-comparison`.
It alternates fresh-process arms, performs 20 real clicks per arm, checks every
complete frame against native GPUI, and reports wall time and Worker CPU time.
Run this without competing builds or probes; it disables compiler prewarming
and profiling so the measurement reflects resident redraw execution.
