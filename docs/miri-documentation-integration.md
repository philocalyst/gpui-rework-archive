# Real GPUI Miri workbench integration

Implementation worktree: `/Users/mileswirht/.codex/worktrees/12a1/gpui-ce3`, branch
`codex/miri-codepen-integration`. This worktree currently includes the internal
testing merge; documentation must receive isolated framework prerequisites and
Codepen commits rather than merging this entire branch.

## Source contract

Source imports the real `gpui` crate, without a replacement SDK. Define
`fn component(window: &mut gpui::Window, cx: &mut gpui::App) -> gpui::Entity<V>`
where `V: gpui::Render + 'static`. `component` does not have to be public. The
runtime appends `fn main() { gpui_codepen_guest::run(component); }`.

The builder runs once per source revision. Ordinary GPUI entities, listeners,
closures, custom elements, tasks, and state persist across event frames. A source
change or `restart: true` starts a new interpreted app. It does not compile edited
components into browser WASM. Native text shaping and rasterization delegate
through GPUI's platform traits to the host's configured backend. Fonts registered
in a native host app are shared with its interpreter service; standalone services
create a native backend through `gpui_platform::text_system`.

## Local HTTP contract

`POST /api/render`, JSON Content-Type, binary Accept
`application/vnd.gpui.codepen-frame;version=3`:

```json
{
  "session_id": "a-valid-random-uuid",
  "generation": 1,
  "source": "use gpui::{*, prelude::*}; /* component definition */",
  "backend": "miri",
  "restart": false,
  "input": {
    "viewport": {"width": 600.0, "height": 500.0},
    "scale_factor": 1.0,
    "events": [],
    "elapsed_ms": 0
  }
}
```

Each view uses its own UUID and increasing generation. A newer generation cancels
the previous compiler/interpreter process group. Apply replies only when their
generation is still current. The same source uses the resident interpreter;
input must remain ordered. Consecutive mouse moves can be coalesced, clicks and
text mutations cannot. Rust `InputMessage` is the authoritative event JSON
schema (`guest/src/input.rs`): `Event(PlatformInput)` and `Text(TextEdit)`.

`POST /api/cancel` with `{"session_id":"...","generation":1}` cancels that
generation if it remains current, returning 204. AbortController alone does not
cancel server execution. Compilation/runtime errors arrive as diagnostics in a
successful reply envelope; retain the last good frame. Superseded queued requests
receive 409. The companion listens on loopback; currently allowed browser origins
are localhost/127.0.0.1 port 8080. A documentation deployment using another port
sets `GPUI_CODEPEN_ALLOWED_ORIGINS` to a comma-separated list of local HTTP
origins, for example `http://127.0.0.1:1111,http://localhost:1111`.
`GPUI_CODEPEN_ORIGINS` remains a compatible alias.

## Binary and renderer contract

Use `gpui_ce_codepen::transport::decode` rather than duplicating the wire codec.
The envelope is `GPUIREP3`, u64 generation, u64 elapsed_ms, u32 diagnostics length,
u32 frame length, UTF-8 diagnostics, then the frame (all numbers little endian).
Frame version is 8; SceneCapture version is 2. The frame includes the actual GPUI
scene, viewport, DPR, cursor, text input context, and next requested frame delay.

The frame uses fixed-width little-endian bincode, including existing GPUI shader
record layouts, dynamic paths/filter commands, and atlas bitmaps. Decode and
validate before importing. `Window::import_scene_capture` uses `SceneResources`
to upload resources into the host's existing atlas. `Window::paint_scene` composes
the imported scene into the host window's normal scene and renderer. The browser
adapter should reuse the Rust `Codepen` component inside a GPUI WASM application;
there is no JS element schema or new canvas rasterizer. See `renderer.rs` for
normal input routing and clipping, and `text_input.rs` for platform text input.

`gpui_ce_codepen::Codepen::new(source, cx)` is the reusable editor/preview entity.
The existing guide application (`src/main.rs`, wasm start entry at its bottom)
shows its root creation and standard editable-text key bindings. A Zola embed
needs a Rust WASM entry that mounts this entity and chooses its initial source;
the guide's lesson sidebar is optional. Host CSS/canvas sizing does not replace
the actual GPUI renderer. Frame callbacks/timers are requested only when pending;
use the emitted `next_frame_ms` and real elapsed time between requests.

## Startup and current status

```sh
GPUI_CODEPEN_MIR_OPT_LEVEL=2 python3 scripts/codepen/setup.py
GPUI_CODEPEN_MIR_OPT_LEVEL=2 python3 scripts/codepen/web.py
```

The second command builds the native companion, chooses a free companion port,
and starts Trunk on 8080 with `/api/` proxied. For a separately managed proxy:

```sh
GPUI_CODEPEN_MIR_OPT_LEVEL=2 GPUI_CODEPEN_PORT=8092 cargo run -p gpui_ce_codepen --bin gpui-codepen-server
```

Contracts ready to build against: real `component` harness, request/cancel schema,
binary envelope, actual GPUI atlas import/scene composition, asynchronous worker
and browser transport. Still changing: frame capture/packing performance,
headless frame driver, platform service lifecycle, text query completeness, and
first viewport scheduling. All five lessons have executed under full Miri, but
text frame latency remains seconds and is being optimized; this is not a finished
performance claim. Backend-owned native surface handles and uncaptured arbitrary
IME bounds/hit-test queries still need integration.

The isolated prerequisite snapshot is commit
`58c30b2452963fcec0c32296af37c793cb847806` on
`codex/miri-documentation-prerequisites`, based on `codex/example-cleanup`.
It excludes the internal testing merge, CPU renderer, and testing examples.
Follow-up patches use that snapshot as their base. Do not merge the internal
testing branch or the earlier fake-SDK checkpoint.
