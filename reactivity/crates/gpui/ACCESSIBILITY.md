# Native accessibility

The normal `x11` and `wayland` profiles include AccessKit. On macOS and Windows,
use `desktop`. These profiles compile the actual platform adapter; Linux uses
AT-SPI through AccessKit Unix and its `async-io` executor, not the null adapter.
The default dependency-light headless profile remains unchanged. `native` also
includes accessibility. `x11-minimal` and `wayland-minimal` are explicit
AT-disabled transport diagnostics; `native-core` is their implementation feature.
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
An accessibility-enabled runtime retains one acknowledged nonzero sequence
(an 8-byte option), so a new pending candidate cannot replace or hide P's actual
token. Headless and explicit AT-disabled builds omit this field. The bridge no
longer has to infer the old token from its own previous publication.

An active adapter observes one bounded acknowledged P transition. The existing
presentation walk compares each output entry with old P; a semantic-only field
edit checks its existing fanout destinations, while an inspector edit locates its
one P entry. Logical indices are hints verified against exact P identity; a
clipped/reordered field hint uses full projection. No
observer is installed while inactive, so these comparisons and their vector
allocations are absent. Headless builds omit the observer entirely.

A sparse update is valid only when the adapter's base cursor and current P both
match the transition's exact acknowledged token, epoch and physical size. The
collector requires unchanged identity sequence, parents and synthetic-child
shape. Each changed node is replaced completely, including all its ordered
children and any native-only text child. Missing acknowledged transitions, topology
changes, activation, changed window size, all-metadata publications and more than
4,096 changed entries fall back to the complete tree. Updating a prepared
candidate's metadata invalidates its sparse descriptor; an unsuccessful newer
preparation preserves the older coherent candidate but loses sparse trust.

The observer costs an 8-byte optional box pointer per accessibility-enabled
runtime, in addition to the existing 8-byte acknowledged sequence. Activation
allocates one 96-byte descriptor; its single reusable `Vec<u32>` grows only when
needed, up to 16 KiB. Deactivation releases both. There is no per-node addition,
second P, retained AccessKit node cache, hash or identity map. An unconsumed
transition can be overwritten; the next adapter update detects the missing base
and uses a full projection.

Full projection counts required native records, then constructs one exactly
reserved output vector and a temporary ancestor stack. Sparse projection lowers
selected nodes. Focus uses the existing logical index after checking P identity;
a compacted or older-P mismatch searches P, and absent focus returns the root.
Replacing a container scans its preorder subtree to recover its complete child
list. Dense and scrolling cases can pay comparison work before falling back.
Focus-only changes send an empty node vector. Projection never
calls `view`, layout or paint. See [sparse measurements](SPARSE_ACCESSIBILITY.md)
for the bounded benefit and measured losses.

Static nodes use checked even IDs derived from the window's nonreused retained
identity; their optional native text child uses the adjacent odd ID. Zero names
the window root. Inputs and their hard-line TextRuns use monotonic ranges in the
high half of the namespace. A range retires when its input field or immutable
text allocation changes; no retired-ID history is retained. The bridge rejects
logical identities beyond `u64::MAX/4` with `ResourceLimit`.

Each active provider leases one 40-byte record per input in a sorted vector.
The Bridge's empty cohort header is 40 bytes. Exact sparse updates inspect only
their frontier and preserve unchanged leases/table storage. Retiring an input
range also replaces its immediate parent's child list. Topology, missed stamps,
and source-authority changes require full discovery. Two monotonic bounds in the
96-byte observer preserve equal-byte field rebinding across failed preparation
and older acknowledgements. If old P has no current source authority, its text
and selection remain readable while editing actions are withdrawn. The next
actual stamp transition requalifies authority, even with an empty semantic delta.

Selectable units are ICU graphemes, including unsplit CRLF. Ordinary lengths
retain AccessKit's one-byte representation. A unit longer than 255 bytes uses
a zero escape and a cold u32 length; the complete exceptional payload is one
N+4K-byte allocation. This is a coordinated private AccessKit/Consumer schema,
not upstream-only serialization compatibility. The checked decoder currently
validates the whole run on every decoding request. No per-character map or
second GPUI semantic tree is retained.

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

The frozen GPUI row sidecar stores only identity, key and index (24 bytes on
64-bit targets). Its immediate parent in P already owns the list identity and
frozen count. Deriving those fields saves 8 bytes per reserved row slot and
removes a logical-list lookup during capture; reading a row adds a lookup in the
frozen list column. Nested, partially clipped and reflected lists retain this
parent invariant. No current logical source data supplies an old P row's count.

## Native action admission

Direct native handlers own only transport and wake capabilities. They do not
borrow Win, a Part, the model, or a UI closure. A 64-command FIFO accepts Click,
Focus, Blur, whole-value SetValue, SetTextSelection and range replacement.
Replacement values are limited to 65,536 UTF-8 bytes;
boxed payloads can retain at most 4 MiB across a saturated queue, plus its fixed
record/channel storage. The owner creates that queue only when an active
adapter factory publishes its first real tree; callbacks discard prepublication
requests before decoding payloads. The Linux x86-64 ledger measures one ingress
allocation of 88 bytes before publication, then 3,800 retained bytes across
three allocations after installing the queue; queued records are 40 bytes.
This excludes the preexisting native wake and platform adapter.
AccessKit has already allocated the incoming value before
this boundary; this quota cannot prevent that upstream allocation.

The owner applies at most 16 commands per wake and rearms when the budget is
exhausted. It reconstructs the window-qualified Target and calls `Win::perform`:
P-advertised support and current logical membership are checked again. Stable
position-free static targets remain usable across later P updates. Input actions
also validate current presentation, window, registered field and exact immutable
source lease. Position-bearing actions decode only current, never-recycled run
IDs. A global publication counter is unnecessary for these authority checks.
AT-SPI InsertText/DeleteText carry one atomic range-and-value action; they never
queue selection and replacement separately. Explicit edits reject interior
graphemes rather than silently flooring scalar/UTF-16 offsets. Root/TextRun IDs,
foreign subtree IDs and retired sites cannot acquire a route. No action drains
before the provider's first publication. Deactivation,
close, owner failure and adapter teardown may cancel queued work; an activation
session stamp prevents canceled commands from running after reactivation.

The [owner-lazy transport evidence](../../evidence/owner-lazy-a11y/README.md)
records the matched whole-window allocation controls, unchanged peak and owner
layouts, actual Registry failure/old-P/repair workflow, and the unfavorable
ordinary drain stack cost. These allocator results are not RSS measurements.

Activation is independent of the FIFO and is idempotent. Repeated activation
requests cannot be blocked by a full action queue. Overflow or an oversized
payload sets a sticky fault; the next owner turn closes this window and returns
`NativeError::AccessibilityOverloaded` from the application. Saturation is never
silently ignored by GPUI, but the native method may already have returned success:
AccessKit's action callback returns `()` and cannot propagate admission status.
This is not UIA Busy and provides no arbitrary-rate lossless/exactly-once
guarantee. Native selection and replacement use the ordinary editor writer.
Linux exposes explicit insertion/deletion; the macOS fork adds the standard
selected-text setter. Windows UIA retains selection and whole-value SetValue;
no absent selected-text mutation operation is invented. IME, clipboard, wrapped
text rectangles, magnifier/caret metrics and geometric text hit testing remain.

This bounded FIFO describes GPUI action ingress. AccessKit's own Unix event
transport uses its upstream queues; a bound on all OS/native event traffic under
arbitrary sustained producer load is not claimed.

## Evidence and coverage

Pinned versions: AccessKit 0.25.1, Consumer 0.39.1, Winit adapter 0.34.1, Unix
adapter 0.24.0 and macOS adapter 0.27.1. Matching AccessKit, Consumer, macOS,
Unix and AT-SPI-common patches carry the private schema and exact editing
conversion contract; see [the frozen source and gates](../../evidence/native-text-selection/README.md).
The workspace patches the adapter's Winit dependency to the same
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

The sparse Consumer oracle compares every complete node, full physical bounds,
ordered children, parent and focus against an independently rebuilt full tree.
It includes 100,000 P entries, direct field and inspector edits, containers,
geometry, frozen list reindexing, DPI changes, synthetic shape replacement,
missing acknowledgements, a failed newer preparation and metadata patched after
preparation. The renderer now shapes original-byte CRLF paragraphs, mixed Latin,
Greek, Cyrillic, Devanagari, Hebrew and Arabic with explicit bundled coverage.
The actual AT-SPI Todo proof includes Greek/Hebrew/Arabic SetTextContents and
GetText. Non-BMP TextRun schema fixtures still prove encoding only when no
bundled glyph coverage exists; this adds no native range selection or IME.
The actual AT-SPI Todo proof was rerun with sparse publication enabled. Its later
text-action transcript verifies reverse selection, caret moves, Unicode InsertText
and DeleteText, invalid interior/split-UTF-8/reversed edit ranges and stale IDs.
Apple/MSVC cross checks compile the actual providers; native VoiceOver/UIA
execution and acknowledged text geometry remain separate gates.
