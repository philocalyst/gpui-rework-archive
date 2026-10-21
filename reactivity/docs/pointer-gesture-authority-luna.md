# Pointer gesture authority and reusable hit work

Read-only audit of cleanroom source `3c87346ac4aecb37b402a91137a78a97689e0a16` in
`/root/gpui-ce3/reactivity`. This note proposes no production change and makes no timing claim.

## Current contract and the repeated work

`NativeHost` stores one window-level `pointer: Option<Point>` and `pressed: Option<Target>`
([`native.rs:322-333`](../crates/gpui/src/native.rs#L322)). A left-button down and up both call
`Win::hit_target` at the latest pointer coordinate; down stores the hit, and up activates only
when the freshly hit target equals that stored target
([`native.rs:957-994`](../crates/gpui/src/native.rs#L957)). `hit_target` first requires
`current_presentation()`, then scans the acknowledged sheet in reverse paint order and tests the
exact node/ancestor clip and transform predicates (`runtime.rs:1031-1040, 2408+`). This is correct
for the current “release on the same target” click rule, but an unchanged down/up point visits the
same immutable geometry twice. The scan is over the eager presented vector, so the repeated work
scales with all presented nodes, including noninteractive nodes and offscreen eager content.

The pointer event currently contains enough information to make one narrow, conservative reuse
possible without per-node state, a map, or an allocation: save the down hit and its point at the
window protocol level; on release, reuse it only if the release point compares equal and the exact
source/presentation authority is unchanged. For every other release, keep the existing fresh hit
test. The normal `activate(Target)` validation still runs, so this optimization never caches a
handler or grants action authority. A handler replacement, removal, or any uncertain transition
must take the ordinary path or cancel according to the gesture policy.

## The authority stamp must include both axes

The current presentation gate is stricter than a visual token check: `current_presentation()`
requires a logically valid owner, no pending presentation, valid presentation authority, equal
source/presentation epochs, and matching requested/acknowledged size and scale
([`runtime.rs:1374-1387`](../crates/gpui/src/runtime.rs#L1374)). The presentation token is a private
window namespace plus sequence. A newly acknowledged presentation consumes the prepared sheet and
sets `presented_sequence` to that token sequence (`runtime.rs:1969-2000`).

The native reuse key should therefore be the pair **(source epoch, acknowledged presentation
sequence)**, captured and compared only while `current_presentation()` succeeds. Each half closes a
different gap:

* A semantic-only publication can change current source authority while reusing the same visual
  sheet/token. `publish_metadata` advances `complete_epoch`, and when no candidate is pending also
  advances `presentation_epoch`, without creating a new presentation sequence
  ([`runtime/metadata.rs:297-320, 450-479`](../crates/gpui/src/runtime/metadata.rs#L297)). A
  token-only cache would incorrectly reuse a hit/press result across that publication.
* A new acknowledged sheet can change geometry without a semantic edit (for example a viewport or
  scroll presentation). The sequence changes even when the source epoch does not. An epoch-only
  cache could reuse the old hit.

There is no current zero-allocation API that exposes this pair atomically: `Commit` exposes the
epochs but not the token sequence, while `with_scene` exposes the latest token but not the current
source epoch. If a future press-session cache needs this proof, add a small owner query that runs
`current_presentation()` and returns a copy of the pair under the existing exclusive borrow. Do not
use `snapshot()` to obtain it: snapshots are diagnostic, owned data, not an input-lane API. The
query needs no stored per-node or per-window cache field; sequence is already minted by the
presentation protocol.

This is an optimization-validity key, not a universal gesture-cancellation key. If the pair
changes during a press, discard the cached hit. Whether the gesture itself continues depends on
the declared gesture recognizer/capture policy; the fresh current hit and existing logical target
validation decide whether a click remains valid. `Target` IDs are not reused, and `activate` must
remain the final logical admission barrier.

## Input origin, capture, and cancellation

Vendored Winit is `0.30.13` (`vendor/winit/Cargo.toml`). `CursorMoved` and `MouseInput` are separate
events and both carry a `DeviceId` (`vendor/winit/src/event.rs:242-250, 277-278`). Winit documents
that a device id may denote a virtual cursor and that virtual devices typically aggregate physical
devices (`event.rs:440-457`). The current match uses `_` for `device_id` in both events and keeps a
single pointer and pressed target. That is a valid single-cursor simplification for this adapter,
but a new multi-device gesture protocol cannot safely assume every physical pointer maps to a
distinct stable ID. It should pair the event origin when the backend provides a coherent identity;
otherwise use a documented conservative policy (serialize to the window's virtual cursor, or
cancel/fall back when the origin is ambiguous). Touch needs the touch sequence ID, not just a
window-wide “pressed” bit.

The current code is not a captured drag model: it stores a target on down, does not route movement
to it, and activates only if a later in-window up hit-tests to the same target. `CursorLeft`
clears the pointer but not the pressed target; focus loss, resize, scroll, presentation-stale input,
and suspend clear it (`native.rs:499-502, 923-950, 971-975, 926-932, 1113-1125`). Surface recovery
also clears press indirectly: both surface creation paths call `resize`, which clears `pressed`
before its same-size early return (`native.rs:440-497, 499-502, 653-662`). Preserve that invariant
with a named session-cancel helper/test if the paths are reorganized. `Occluded(true)` invalidates
the destination and records occlusion but does not clear `pressed` (`native.rs:910-915`); whether
that should cancel is a policy choice, not a conclusion from Winit's event type.

Platform sources show why “button up” and “gesture end/cancel” need a real protocol boundary:

* Win32 normally routes a mouse message to the window under the pointer. `SetCapture` changes that
  routing for a held button, and `WM_CAPTURECHANGED` reports capture loss. A release outside the
  window is otherwise not delivered to that window. Microsoft documents this in
  [Mouse Input Overview](https://learn.microsoft.com/en-us/windows/win32/inputdev/about-mouse-input),
  [SetCapture](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setcapture),
  and [WM_CAPTURECHANGED](https://learn.microsoft.com/en-us/windows/win32/inputdev/wm-capturechanged).
* GTK gestures track state per input sequence. Claiming a sequence denies competing recognizers
  and sends cancellation down the propagation chain; GestureClick also has an explicit
  `unpaired-release` signal when a grab is taken elsewhere mid-press. See GTK's
  [Gesture](https://docs.gtk.org/gtk4/class.Gesture.html),
  [input handling](https://docs.gtk.org/gtk4/input-handling.html), and
  [unpaired-release](https://docs.gtk.org/gtk4/signal.GestureClick.unpaired-release.html) docs.
* AppKit models a drag as `mouseDown`, zero or more `mouseDragged`, then `mouseUp`, and notes that
  mouse-moved events need not be delivered between down and up. See Apple's archived
  [Handling Mouse Events](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/EventOverview/HandlingMouseEvents/HandlingMouseEvents.html).

These are platform contracts, not proof that the current Winit adapter captures on every backend.
The portable protocol should distinguish `Up`, `Cancel`, `CaptureLost`, `WindowFocusLost`,
`SurfaceLost`, and teardown. It should never synthesize an `Up` to repair a missing release.

## Small implementation/test seam

Use one by-value normalized event reducer owned by each window session; native translation,
deterministic public/test input, and tests feed the same reducer. Keep it stack/value based so
steady-state events allocate nothing. The normalized event should use a GPUI-owned pointer/session
identity and phase, not `winit::DeviceId`; the native adapter maps the host's origin into that
identity, and test callers can provide deterministic identities without constructing OS events.
Do not put caller-supplied authority stamps in events. The reducer captures/queries the exact
source-plus-presentation authority from its owner at the operation boundary. The first useful
slice is only the existing mouse-click rule plus conservative hit reuse:

1. On down: require a current presentation, run the existing hit kernel, retain the target, point,
   and exact authority pair in the window session; preserve focus behavior.
2. On move/up: update the window pointer. On up, use the retained hit only on exact point+authority
   match; otherwise run `hit_target` as today. In both cases run ordinary `activate` validation.
3. On cancel, focus loss, resize/scale change, scroll, surface loss, or teardown, clear the session.
   Do not retain it across an authority mismatch. Define occlusion explicitly.
4. Keep gesture recognizer arbitration, drag capture, pointer-id routing, and touch sequences as
   later protocol work; a click fast path does not implement those semantics.

Test with no heap-backed event queue and assert zero allocations after warmup. Required traces:
same-point down/up; pointer moved out and back; release on another target; stale presentation before
release; source-only semantic publication with unchanged token; same-source new acknowledged P;
surface loss/recovery at the same token; capture-loss/cancel; focus loss; resize/scale; scroll;
remove/reinsert; two interleaved device origins; and touch sequences. Compare final action/focus logs
and current target admission against the uncached reducer. Add a large eager sheet with a button
near the end to ensure the hit-count oracle demonstrates only the intended repeated traversal was
removed. Do not count the `activate` logical lookup as removed work.

## Design alignment and limits

The intended architecture already puts interaction state in window protocols: `07-platform.md` §8
defines a protocol-owned session index, and says unused protocol state costs zero; its gesture
ordering begins with static compositor claims and escalates recognizers conservatively. `08-runtime.md`
§6 describes an immutable presentation resolver and the no-owner/no-logical-epoch hover/wheel fast
lane. `10-quality.md` FP1/FP5 require escalation proofs and zero steady-state allocation. Current
code implements neither a general resolver nor a gesture DAG; the proposal here only reuses one
validated hit in the one exact unchanged-point click case. Full resolver work should wait until
the public input/gesture contracts are implemented and measured.

The stale `rg` process PID 3051321 was already absent when checked (`ps -p 3051321` returned no
row); no recursive `/tmp` scan was run.
