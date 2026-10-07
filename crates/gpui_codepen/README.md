# GPUI / The living guide

Edit real Rust on the left and interact with a native GPUI component on the right.
The execution engine is the complete vendored Miri interpreter. There is no WASM
component engine or engine switch.

## Run

With the platform prerequisites in [SETUP.md](../../SETUP.md):

```sh
python3 scripts/codepen/setup.py
cargo run -p gpui_ce_codepen --bin gpui-guide
```

Setup installs `nightly-2026-09-30`, builds the vendored interpreter in release
mode, prepares its sysroot and warms the shared SDK cache. It leaves the default
Rust toolchain unchanged. Subsequent component builds are offline.
See [provenance and local Miri changes](../../vendor/MIRI-PROVENANCE.md).

macOS needs an application bundle for native keyboard and IME integration:

```sh
python3 scripts/codepen/package_macos.py
open 'build/GPUI Guide.app'
```

This development bundle uses this checkout and its toolchain. Fonts are embedded.

## Workbench

Five lessons cover styling, flex layouts, generated elements, stateful events
and composition. Edits run after a 300 ms typing pause. Run or Cmd/Ctrl+Enter
executes immediately; auto-run can be paused. Rapid clicks execute in order.
Errors retain the last successful preview in a fixed diagnostics slot, so neither
pane jumps. Reset state restarts the interpreter, including Rust statics; Restore
lesson restores its source. Drafts save on a separate native writer thread.

The editor supports syntax colors, selection, clipboard, undo/redo, IME and
scrolling. Caret and scroll frames reuse shared text, highlight spans and shaped
text. The editor and preview are separate cached GPUI entities; cursor movement
cannot reconstruct the component tree. User edits exceeding 64 KiB are rejected
without truncating the existing source or its selection.

## Real Rust execution

```rust,ignore
use gpui_codepen_guest::*;

fn render(cx: &mut PreviewContext) -> Node {
    let mut count = cx.state["count"].as_u64().unwrap_or(0);
    if cx.clicked("increment") { count += 1; }
    cx.state = json!({"count": count});
    div().flex().flex_col().p_6().gap_3()
        .child(format!("Count: {count}"))
        .child(div().id("button").on_click("increment")
            .p_4().rounded_lg().bg(rgb(0x315c3b))
            .text_color(rgb(0xffffff)).child("Increment"))
        .into()
}
```

Rust functions, expressions, loops, collections, formatting and state transitions
execute in Miri. Each source owns a resident interpreter. Events go through a
bounded input shim; changing source replaces that process. The Rust SDK encodes
the element tree into a compact binary transport, avoiding interpreted JSON
formatting for every style field. The host constructs real GPUI elements and
handles native text shaping, layout, painting, hover and clicks. User stdout is
separate from nonce-tagged, length-delimited frame messages.

Speed is the priority: Miri validation, borrowing, race, alignment, leak backtrace
and isolation checks are disabled. MIR optimizations remain off because optimized
self-loops can trigger a rustc interpreter bug. Native graphics/window pointers
never cross into the interpreter. This is a local developer workbench.

The supported bridge covers text and divs, flex rows/columns/wrapping, dimensions,
padding, gaps, colors, borders, radii, font size/weight, opacity, shadows, clipping,
hover and click events. It does **not yet expose the entire GPUI API**: arbitrary
GPUI entities, custom GPU painting and async window/application callbacks need
additional native bridge operations. The component dependency graph is fixed to
the SDK and its pinned Rust dependencies.

On the development machine, the resident counter measured roughly 22–25 ms per
click and warmed source changes about 180–300 ms, excluding the typing debounce.
These are local measurements, not a general latency guarantee. The UI displays
actual runtime latency. Setup warms dependencies to avoid a multi-second cold
SDK compile on the first lesson.

Source and serialized state are capped at 64 KiB; frames at 1 MiB, 4096 nodes and
48 levels. Workers cancel superseded source generations, bound output, terminate
compiler descendants, and join pipe readers. Compilation has a 45-second cold
budget and individual renders a 5-second budget. Runaway processes have a 4 GiB
limit/watchdog. These bounds preserve responsiveness and recoverability.

## Embed

```rust,ignore
let pen = cx.new(|cx| gpui_ce_codepen::Codepen::new(source, cx));
pen.update(cx, |pen, cx| pen.run(cx));
// Mount pen as a child of your GPUI view.
```

Bind the editable-text default keybindings and the Codepen Run action as in
`src/main.rs`. `CodeChanged(String)` events support surrounding persistence.

## Optional browser client

The native guide is the primary application. The existing GPUI web platform can
also render the guide shell in a browser; edited Rust still runs exclusively in
the local Miri companion. The browser itself does not contain rustc or Miri.

With Trunk installed:

```sh
rustup target add --toolchain nightly-2026-09-30 wasm32-unknown-unknown
python3 scripts/codepen/web.py
```

Open `http://127.0.0.1:8080`. Each workbench UUID owns an interpreter session;
separate tabs cannot cancel each other's edits or share state. The companion
listens only on loopback, and the launcher chooses an available companion port.

## Verification

```sh
cargo test -p gpui_ce_codepen --lib --test session
cargo test -p gpui_ce_codepen --test engines --test server -- --ignored --nocapture
cargo test -p gpui_ce_parley --lib
cargo clippy -p gpui_ce_codepen --all-targets -- -D warnings
```

The real Miri suite executes every lesson, measures consecutive resident clicks,
changes event logic, recovers after compiler errors/panics, cancels infinite Rust
loops and checks recovery. Protocol tests cover styles, Unicode and truncated
frames. Headless text regressions cover flex min-content wrapping and layout
cache probes. Companion tests exercise cancellation and independent sessions.
