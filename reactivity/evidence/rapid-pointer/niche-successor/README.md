# Rapid pointer release: niche-preserving successor

Shipping source is `6021d0009db4069e5c7f96400890baa75630f047`, based on
`c00c030a98e6218d306073d3e2a98ae8ee554cc1` through the reviewed 4d implementation.
Only `crates/gpui/src/runtime/input.rs` changes production code. Public tests
are in `crates/gpui/tests/pointer_focus.rs`. `source.patch` is the complete
base-to-final shipping/test patch; `successor.patch` isolates the representation
correction after the sealed `baseline-4d/` archive. No manifest, dependency,
unsafe code, retained runtime field or callback ABI is added.

## Admission and explicit limit

Press records its target and the exact sequence of its own successful
focus-only candidate. Release first uses the ordinary strict current-sheet
path. Its private fallback requires live logical authority, clean/valid P,
unchanged requested viewport, exactly S=P+1 without overflow, complete C=S,
a still-pending candidate and the same latest presentation sequence. A fresh
hit still uses acknowledged P and must resolve to the same window-qualified
live target. The proof is consumed before callbacks. Model/no-op/semantic
changes, new or failed preparation, viewport/DPI ABA, loss, cancellation and
foreign/retired targets cannot reuse it. Nothing loosens current_presentation
for other operations; semantics and geometry remain acknowledged P until ACK.

The built-in inspector deliberately retains strict ACK admission: its epoch
captions can change text geometry during focus publication. This is an explicit
temporary inspector limitation, not full rapid-gesture parity for that surface.
Ordinary contained components, including the public queue consumer, use the
bounded focus path. Input selection presses retain their existing strict path.

## Safe coordinate encoding and costs

The private 8-byte Position stores x in NonZeroU32 and y as f32. Finite x bits
plus one are never zero, MAX or overflowing; MAX is the absent-position marker.
Subtracting one reconstructs signed zeros and subnormals exactly. Both axes are
validated before encoding. Nonfinite movement clears the position and consumes
the gesture. Public position() still returns Option<Point>, and Debug keeps
its previous public position/pressed-target shape. No lifetime or pointer cast
is involved.

Actual x86-64 measurements: Position and Option<Position> are 8 bytes;
Pressed/Option<Pressed> are 24; PointerSession and Option<PointerSession> are
32, alignment 8. The rejected 4d control had direct session 32 but optional
session 40, preserved in baseline-4d/ and the optimized control. These are
specific measured carriers, not a promise about arbitrary nested enum layouts.
The private test's model Runtime is 1,864 bytes default and 1,880 native; Win
is 8, unchanged. Public Point and PointerEvent stay unchanged.

The six-library source ledger is 30,554 shipping code lines: +17 over rejected
4d, +86 over c00. input.rs contains 350 shipping and 116 test code lines;
pointer_focus.rs contains 359 test code lines. Tests/comments/vendor bytes
are separately charged. The existing repeated-input test still checks zero
allocations across 1,000 pointer activations after warm selection.

The matched opt-level 3, codegen-units 1, no-LTO control (GPUI default features
disabled) freezes both binaries
and identical public consumer source. Both activate the same caret-to-checkbox
rapid release and round-trip its point. Getter linked bytes fall 38→28;
dispatch bytes 3,857→3,835. Compiler frame metadata reports dispatch 280→264
and main 3,304 unchanged. Whole linked .text is 3,434,583→3,434,519 bytes,
.rodata 6,510,264→6,510,288, .data.rel.ro 128,472→128,496. The getter replaces
a finite classifier with sentinel compare/decrement. Finite Move adds an
increment plus an unreachable zero-check/panic branch retained by the compiler;
that safe checked-constructor cost is not hidden. Source/assembly/ELF metadata
are in controls/. These are code/frame measurements, not runtime timings,
summed stack depth, RSS or native renderer performance claims.

## Qualification boundaries

The complete 546-case default and 603-case native suites plus desktop
all-target Apple/MSVC compilation belong to exact 4d, preserved separately;
they are not retagged to this successor. This small representation successor
passes the approved targeted campaign: 2 private + 18 public pointer tests in
each default/native configuration, default/native all-target strict Clippy,
Apple aarch64 and MSVC x86-64 desktop library checks, and both actual public
native clients. All 1,991 before/after input guards match; commands and exit
statuses are in metadata.json. Formatting also passes.

The external app is the frozen Hummingbird queue source 365efc09f1207718aac7c7cfa3d9f7bfa3a5d5b9.
Its standalone manifest only redirects first-party/vendor paths to this core;
its lock and all app source stay guarded. The unchanged original client uses
complete rapid xdotool clicks without a held-button ACK workaround. The loop
client also checks two more complete clicks, Space and actual AT actions with
stable provider identity. Each runs its own Xvfb and actual AT-SPI Registry;
there is no private host/model seeding or app instrumentation. The older
native failure remains sealed in baseline-4d/. CPU rendering and no attached
audio are explicit; SQLite foreign C SDK failures remain the app's separate
archive, not a claimed cross-app success.

Checked-in root config is present and guarded. Generic RUSTFLAGS and
CARGO_ENCODED_RUSTFLAGS are unset, so Windows target flags remain effective.
Cargo uses two jobs and an isolated target directory. Source, external app,
client and control inputs are hashed before/after; actual profile fingerprints
and executable hashes are archived. The setup metadata-key typo was corrected
before any gates and its failed setup log is retained.
