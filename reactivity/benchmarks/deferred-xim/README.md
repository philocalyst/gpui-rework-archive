# Deferred X11 XIM qualification — adoption held

Production is frozen at `f51089671a` (deferred admission, request ordering,
spots/focus and focused reconnect) plus `a44ff50c6b` (event-time XIM key modifiers
kept separate from live XKB state). Baseline is committed
`c9344bdd592c2c7474ba9412bc17e00a4c1c453a`, Winit 0.30.13. No production changes
were adopted into the main workspace. Work stopped at the owner's explicit
priority change, with lifecycle repair still required.

**Adoption blocker:** `Ime::new` may register an instantiate callback referencing
its boxed `ImeInner`, then free that box on either constructor error. Final
`Ime::drop` also leaves a fallback instantiate watcher registered. A subsequent
callback can use freed client data. This is inherited source behavior, not a
qualified failure path. Do not adopt the seam until ownership is repaired and
failure/drop controls pass. No environment or libc locale mutation is accepted
as a cleanup technique.

## Verified native behavior

The six frozen successful runs use an isolated Xvfb `:110`, the unchanged protocol
implementation from [fcitx/xcb-imdkit](https://github.com/fcitx/xcb-imdkit/tree/621048bd50e8f3cbf52335f824f7b4d708a21b14),
and a 117-line adaptation of its primary `test/test_server.c`. The server commits
exactly `Ω` for the first unmodified `q`, only after the context receives actual
XIM focus. `p` starts/updates preedit, Escape cancels, q commits; the server logs
window-tagged protocol operations and cursor spots.

- `runs/press-{active,late}.log`: configured server present and late availability,
  using the upstream KeyPress-only filter mask.
- `runs/both-{active,late}.log`: the same matrix filtering both press/release;
  composition-key releases are consumed and shortcut/modifier releases forwarded.
- `runs/both-focus.log`: first global admission and first q queued inside the
  `Focused(true)` callback, during the same pump.
- `runs/both-core.log`: core-only first key excludes XI raw events that could
  accidentally let stock admit the pending request before the key.

Each checks ordinary q, dead-acute+e→é, Compose+o+e→œ before enabling; false requests
without admission; first q→exactly one correctly routed Ω; independent W1/W2;
first-key spots 31,47 and 73,89; burst Ctrl+q including its release and cleared
live Ctrl; burst Shift+1→logical/text ! and cleared live Shift; preedit update,
cancel, commit and focus transfer; real server kill/reinstantiate with a first key
in the still-focused W2 and both old windows recovered; retained spots after
restart; late W3; queued enable after close; rapid toggles; cross-thread Allow
waking ControlFlow::Wait without a RedrawRequested; and ordinary dead/Compose
input after disable while the other window still commits through XIM.

The server trace proves no configured-server OPEN before admission. Source
qualification additionally pins the only initial `Ime::new` call behind a live
Allow(true), with callbacks unreachable before that owner exists. Locale setup,
xkbcommon compose and both existing channels remain eager. This is correctness
evidence, not a startup benchmark or a claim that locale pages disappear.

`runs/{winit,probe}-clippy.log` pass `-D warnings`. Other platform adapters and
real ibus/fcitx desktop services have not been qualified in this worktree.
GPUI `crates/gpui/src/native.rs` currently neither calls `set_ime_allowed` nor
handles `WindowEvent::Ime`; these changes qualify Winit independently and do not
complete GPUI native editing integration.

## Controls and actual pins

`runs/pins.json` records compiler, source commits, actual selected Winit rlibs,
consumer/provider binaries, file sizes and SHA-256 hashes. Binaries are retained
outside Git under `/tmp/gpui-deferred-xim-frozen/`. The committed losing control
sources are the exact earlier fixture versions used by those binaries; they
precede later positive-fixture spot/focus/release refinements.

| Frozen control | Result |
| --- | --- |
| eager first key | Plain q precedes Enabled; exactly-one-Ω assertion fails (101). |
| eager burst Ctrl+q | After explicit settle/refocus to bypass stock enable defects, final Ctrl-clear assertion fails (101). |
| deferral-only f510 burst | The same final Ctrl-clear assertion fails (101). |
| initial candidate without reconnect focus | Still-focused first key after restart becomes plain q (101). |

The replay fix adds no retained field/history/queue. Allowed-XIC key core masks
never overwrite live XKB state; mismatching event-time masks/groups use the
existing transient synthetic XKB helper for both key translation and modifiers,
then restore current modifiers. That helper can allocate/query at input time;
first-editable-input latency remains unmeasured.

An experimental provider that forwarded composition releases hit intermittent
libX11 fabricated-event diagnostics; preserve
`runs/experimental-forwarded-release-failure.log`. The final both-filter provider
instead consumes releases of the composition keys it handles, and explicitly
forwards/qualifies shortcut releases. This is not certification of every server
forwarding strategy. An initial concurrent control/provider attempt was rejected
for cross-process protocol interference; runners now serialize on a per-display
flock and server names are per process. A newer stock control stopped at its
known lost cursor spot before reaching replay; its trace is retained separately.
The final control-runner adjustment bypasses only that stock setup defect for
its explicit replay control; this adjustment was not rerun after the owner asked
to freeze work. The independently pinned earlier negative controls remain valid.

## Actual inline ledger

Rustc `-Zprint-type-sizes`, x86_64-unknown-linux-gnu, Rust 1.97.1:

| Owner | Eager | Candidate | Delta |
| --- | ---: | ---: | ---: |
| SharedState | 640 B | 648 B | +8 B/window (4 B spot plus padding) |
| UnownedWindow | 784 B | 792 B | +8 B/window, includes SharedState |
| ActiveEventLoop | 200 B | 216 B | +16 B pending event sender |
| EventProcessor | 664 B | 696 B | +32 B total, includes ActiveEventLoop and peekable request |
| ImeInner, after admission | 344 B | 360 B | +16 B focused XID |

Do not add nested-owner deltas twice. Channels and their allocation behavior are
unchanged; no waker clone or channel is added. Each IME request pings the existing
waker, including spot updates; no redraw packet is emitted. No RSS/PSS, timing,
allocation-call or input-latency win was measured. Source-qualified matched
startup controls require the root's quiet measurement window first.

## Callback retirement source proof and alternatives (unimplemented)

Primary [libX11 1.8.13 source archive](https://www.x.org/releases/individual/lib/libX11-1.8.13.tar.xz)
was inspected; its exact archive hash is pinned. `src/xlibi18n/IMWrap.c` delegates
unregister using the current locale. `modules/im/ximcp/imInsClbk.c`,
`_XimUnRegisterIMInstantiateCallback`, matches locale name, exact mapped modifiers,
database/resource strings, callback and client_data. Absent registrations return
False safely, but fallback changes the modifier context, so a bare unconditional
unregister can miss a live watcher. `src/xlibi18n/lcWrap.c` also concatenates the
program modifier string with current XMODIFIERS; feeding a saved full mapped
string back can duplicate the environment suffix.

Existing `PotentialInputMethods` owns original program strings. Reselecting them
can work under unchanged environment/locale, but cannot prove retirement after
legitimate context changes. Mutating environment/locale to force matching was
rejected. The proposed alternative was a display-owned tombstone token carrying
a nullable raw ImeInner pointer, cleared after final native cleanup on every
Err/Drop; no strong Arc cycle or retained ImeInner/resources. Estimated charge:
+16 B empty Mutex/optional linked head in XConnection, +8 B token handle in
admitted ImeInner, and about 16 B per allocated watcher token, retained through
display lifetime. These are estimates, not implemented layouts. X11_BACKEND owns
a process-static Arc to the display, so display lifetime can exceed loop lifetime.

That alternative also needs more proof: libX11's `callback_list` is process-global,
and the inspected instantiate-callback file has no obvious display-close purge.
Freeing tokens immediately after XCloseDisplay must not leave global native
registrations able to call them. Repeated registration/history and native
registration retention must be bounded or explicitly owned; permanent leaks,
strong cycles and an unreviewable Xlib-internals dependency are unacceptable.
A private low-level opener-failure injection fixture was authorized for the next
repair, but was not implemented before this work was frozen.

## Reproduce later

Source `/tmp/gpui-native-env.sh` for this machine's compiler/library paths, then
explicitly override its stale DISPLAY=:93 with an isolated display. Build the
pinned upstream provider using `build-server.sh`, supplying XIM_SOURCE,
XIM_BUILD, XCB_INCLUDE, XCB_LIB and CC. The script uses a screen-iterator shim in
place of xcb-util and compiles upstream protocol sources without modification.
`server.c` is LGPL-2.1-only derived test code; license is included.

With DISPLAY, XIM_SERVER and a dedicated CARGO_TARGET_DIR, `run-native.sh` runs the
six positive gates. `run-controls.sh` creates separate archived source trees,
Cargo package IDs and targets for eager and deferral-only controls; supply a new
XIM_CONTROL_ROOT. Both cap jobs at two and take the same per-display lock. Never
run correctness providers concurrently on the same display. The final control
runner needs its noted post-freeze verification before being counted as a gate.
