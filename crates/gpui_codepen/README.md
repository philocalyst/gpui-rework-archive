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

For the web guide, install Trunk and the pinned WASM target, then run:

```sh
rustup target add --toolchain nightly-2026-09-30 wasm32-unknown-unknown
python3 scripts/codepen/web.py
```

Open http://127.0.0.1:8080. The script starts a local compiler companion on an
available port and proxies it through the web server. Rust compilation and full
Miri execution run in the companion. The browser runs the actual GPUI WASM
application and its existing renderer. It does not contain rustc or Miri.

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
stay alive in the interpreter across input and animation frames. Source edits
compile a new component and restart that component's state. Reset state restarts
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

Edits debounce for 100 ms. A newer edit cancels the previous compiler/interpreter
process group immediately. Stale replies cannot replace newer source. Compilation
errors retain the last good preview. Native workers and browser requests are
asynchronous. Ordered event batches coalesce consecutive pointer moves. Frame
callbacks and async timers determine when another frame is requested; idle
components do not continuously render.

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
frames at 64 MiB. The companion is local and the interpreter has access to the
user's process environment and filesystem.

## Verification

```sh
cargo test -p gpui_ce_codepen --lib --test session
cargo test -p gpui_codepen_guest --features host-services
cargo test -p gpui_ce_codepen --test engines -- --ignored --nocapture --test-threads=1
cargo test -p gpui_ce_codepen --test server -- --ignored --nocapture
```

The full Miri tests execute real GPUI render implementations, entity callbacks,
source edits, scale/resize changes, all lessons, cancellation and recovery, and
report resident-frame timings. The companion tests cover browser sessions and
cancellation. Platform tests compare bidi/caret/selection results with Parley.
