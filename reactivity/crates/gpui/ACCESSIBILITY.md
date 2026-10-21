# Native accessibility

The normal `x11` and `wayland` profiles include AccessKit. On macOS and Windows,
use `desktop`. These profiles compile the actual platform adapter; Linux uses
AT-SPI through AccessKit Unix and its `async-io` executor, not the null adapter.
The default dependency-light headless profile remains unchanged. `native`,
`x11-minimal`, and `wayland-minimal` are explicit AT-disabled transport diagnostics.
Cargo features are additive: combining a minimal profile with `x11`, `wayland`,
`desktop`, or `accessibility` enables accessibility.

From `reactivity/`, ordinary accessible application ports run without source edits:

```sh
cargo run -p gpui --features x11 --example workbench -- --cpu
cargo run -p gpui --features x11 --example library -- --cpu
# Use wayland on Linux/Wayland, or desktop on macOS/Windows.
```

For an explicit transport measurement without AT:

```sh
cargo run -p gpui --features x11-minimal --example workbench -- --cpu
```

Earlier native solid-fill, startup and client-memory evidence predates this
integration and had AT disabled. It is not an accessibility-enabled startup or
whole-process memory measurement.

## Ownership and publication

The adapter is installed while the window is hidden. Each native window event
reaches it before application input. Activation returns `None` and signals an
independent atomic control flag plus the native wake; AccessKit supplies its own
temporary placeholder. The next owner turn sends the complete acknowledged P
tree, even when no paint is scheduled. A pending or failed candidate cannot leak
new text, names, list positions or geometry into that projection.

An inactive `update_if_active` never enters the projector. The native proof runs
1,000 inactive synchronization calls with zero owner-thread allocations and zero
node conversion. This is separate from constructing the platform adapter itself.

AccessKit owns the required native tree. GPUI retains no AccessKit-node mirror,
ID map, hash lane, or second semantic cache. A compact per-window cursor tracks
the scene token, acknowledged P epoch, physical size and live focus. Both token
and epoch matter: list scrolling can change the token without S, while a
semantic-only name edit can advance P with the same scene token and no paint.

This baseline replaces the full native tree on a changed P. Full projection
counts required native records, then constructs one exactly reserved output
vector and a temporary ancestor stack. It is O(number of exposed parts), with an
extra read pass to avoid geometric vector overreserve. Focus-only changes send
an empty node vector; resolving focus membership still scans P. Neither operation
calls `view`, layout or paint. Sparse native updates are a future optimization,
not a claimed property of this implementation.

Real nodes use checked even IDs derived from the window's nonreused retained
identity. Zero names the synthetic window root. An input uses its adjacent odd
ID for a native-only `TextRun`; exact UTF-8 byte lengths describe the existing
editor's scalar units, with CRLF counted as one unit as AccessKit requires.
The bridge rejects identities beyond `u64::MAX/2`
with `ResourceLimit`. No public Target changes, historical ID map, or model
address is involved.

Ordinary static text is a single `Label` with its actual content in AccessKit
`value`. Native Label implementations derive their name from that content. An
explicit different name or explicit absent name therefore uses a `Group` with
that name plus one odd-ID `Label` child containing the actual text. This
exceptional extra native node preserves both dimensions, including inheritance
and removal of the extra child; it does not add another GPUI node. Editable input
name, description and value remain separate.

Bounds are full, transformed window-physical rectangles derived from P. Absolute
transforms are not attached again to AccessKit ancestors. The native adapter
handles window-to-screen conversion. List and row-slot clipping are represented
separately from full bounds. GPUI's clipped query bounds are not substituted for
UIA full element bounds. Provider-specific offscreen/complex-clip behavior still
needs native Windows/macOS verification.

List containers receive the full frozen count. Realized items receive frozen
zero-based `position_in_set`, as required by AccessKit 0.25.1; its adapters translate
to one-based native conventions. Offscreen rows have no native nodes. This does
not implement UIA ItemContainer/VirtualizedItem, remote row realization, or native
AT scrolling; users can scroll the real Library window and the bounded native
tree then follows acknowledged rows.

## Native action admission

Direct native handlers own only transport and wake capabilities. They do not
borrow Win, a Part, the model, or a UI closure. A 64-command FIFO accepts Click,
Focus, Blur and whole-value SetValue. SetValue is limited to 65,536 UTF-8 bytes;
boxed payloads can retain at most 4 MiB across a saturated queue, plus its fixed
record/channel storage. The Linux x86-64 ledger measured three allocations and
3,792 requested retained bytes for the ingress/channel before payloads; queued
records are 40 bytes. This excludes the preexisting native wake and platform
adapter. AccessKit has already allocated the incoming value before
this boundary; this quota cannot prevent that upstream allocation.

The owner applies at most 16 commands per wake and rearms when the budget is
exhausted. It reconstructs the window-qualified Target and calls `Win::perform`:
P-advertised support and current logical membership are checked again. Stable
position-free targets remain usable across later P updates. Root/odd IDs,
foreign subtree IDs and retired sites cannot acquire a route. Deactivation,
close, owner failure and adapter teardown may cancel queued work; an activation
session stamp prevents canceled commands from running after reactivation.

Activation is independent of the FIFO and is idempotent. Repeated activation
requests cannot be blocked by a full action queue. Overflow or an oversized
payload sets a sticky fault; the next owner turn closes this window and returns
`NativeError::AccessibilityOverloaded` from the application. Saturation is never
silently ignored by GPUI, but the native method may already have returned success:
AccessKit's action callback returns `()` and cannot propagate admission status.
This is not UIA Busy and provides no arbitrary-rate lossless/exactly-once
guarantee. Supported native text actions are whole-value replacement and focus;
selection, caret editing, IME and character-position metrics are not fabricated.

This bounded FIFO describes GPUI action ingress. AccessKit's own Unix event
transport uses its upstream queues; a bound on all OS/native event traffic under
arbitrary sustained producer load is not claimed.

## Evidence and coverage

Pinned versions: AccessKit 0.25.1, Consumer 0.39.1, Winit adapter 0.34.1, Unix
adapter 0.24.0. The workspace patches the adapter's Winit dependency to the same
vendored Winit used by GPUI's host, preventing incompatible duplicate Window types.

Portable tests use the actual Consumer to validate tree replacement/removal,
names/values/descriptions, text runs, focus, frozen list positions, stale targets,
same-token semantic edits, same-epoch list scroll, inherited names, queue limits,
session cancellation and synthetic-ID rejection.

The ignored Linux proof was actually run on Xvfb 21.1.24, AT-SPI2 2.60.6 and a
private D-Bus session, with `ReferenceCpu` and an invalid Vulkan ICD. A D-Bus client
enables AT after initial P, discovers the window, reads a renamed Group and its
original text child, calls Component.GrabFocus, EditableText.SetTextContents and
Action.DoAction on the shared Todo model, and disables/re-enables accessibility.
It checks real acknowledged source/UI changes. Initial activation, a same-token
name edit and reactivation cause no new paint/native frame. A separate ignored
native test checks that an absent session bus does not prevent CPU presentation.

Run the real proof with an installed AT-SPI launcher and X11 display:

```sh
export GPUI_AT_SPI_LAUNCHER=/usr/libexec/at-spi-bus-launcher
bash tools/test_atspi.sh "$GPUI_AT_SPI_LAUNCHER"
DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/gpui-no-session-bus \
  cargo test -p gpui --features x11 --lib \
    native::accessibility::linux_tests::native_accessible_profile_without_session_bus_still_presents \
    -- --ignored --exact --nocapture
```

The helper waits for the private launcher's D-Bus service rather than depending
on compilation time or a fixed startup delay. It uses an in-memory settings
backend so it does not depend on a desktop dconf service or change the user's
accessibility setting. Normal
applications use the real desktop bus and dynamically detect AT enable/disable.

On the measured inactive native host, thread count rose from 2 before native
resume to 5 after adapter/surface creation, before spawning the test D-Bus client.
This is a whole-host observation, not an isolated allocator attribution to each
thread. The stock Unix adapter starts a worker before activation; async I/O and
blocking runtime setup also have process-wide costs. Inactive semantic conversion
is lazy; adapter construction is not zero-thread or zero-memory.

[Projection measurements](evidence/accessibility-projection.csv) report requested
allocation bytes for the TreeUpdate and temporary work only, excluding the GPUI
owner, the adapter's retained Consumer tree, OS providers and D-Bus traffic.
The 10K-button fixture has about 3.13 MB of owned native update payload; the
two-pass vector removes approximately 0.87 MB retained and 1.62 MB peak requested
bytes versus geometric growth in that capture. The extra read pass is included
in timings. These are 31 samples in one shared Linux container, not end-to-end
screen-reader latency or a hard performance guarantee.

Cross-compilation checks the actual adapter and native integration for
`aarch64-apple-darwin` and `x86_64-pc-windows-msvc` (including their platform
dependencies, using Rust's `build-std` cross-check).
Native VoiceOver/UIA tests and Orca spoken output have not been run here; Consumer
tests, an AT-SPI client and cross-checks do not replace those OS provider/threading/
screen-reader proofs.
