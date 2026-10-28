# Exclusive Hummingbird queue

Shipping source is `365efc09f1207718aac7c7cfa3d9f7bfa3a5d5b9`, based on
`c88a545d3749638e9b7321b02be31d9465548233`. Only the standalone Hummingbird
application changes; core and vendors are unchanged. The source patch and
immutable source/test ledger are archived separately from this evidence commit.

## Ownership and behavior

One application model owns the mutable queue, order, inverse history and current
entry. Duplicate recordings have distinct monotonically checked entry keys.
Immutable track metadata uses `triomphe::Arc`; visible rows borrow metadata and
capture only entry keys. The Add button clones one prepared track lease and
still allocates its ordinary captured route. Building a View is not allocation
free. A single worker SQL projection supplies the real title, IDs and path; the
existing `for_playback` projection remains unchanged. The worker observes path
availability. UI routes read that snapshot and never perform filesystem I/O.
An actual decoder must recheck availability when opening a path.

The controller is non-Clone. One checked Relaxed atomic session ID per controller
and a checked serial qualify opaque EOS callbacks; the channel/wake separately
publishes plans. Accepted plan-affecting edits revoke old EOS, including edits
that preserve the current path. Explicit Play/restart of the same entry is a new
occurrence. A future decoder must reconcile current/lookahead changes without
reopening the same path on every edit. Stop can revoke at serial exhaustion.
Queued paths survive database replacement; only Add admission checks the
captured database generation. Read-question completion prepares metadata; it
does not deliver audio effects.

The ordinary public `Library` component displays the queue through keyed virtual
rows and real-title controls. Checkbox activation toggles; explicit Only and
Range buttons expose selection without inventing modifier metadata. Space,
Enter and Tab use existing GPUI behavior. Editing clears selection, as in the
original queue notification path. Reconstructing a screen requires a fresh
window-unique `ListId`; a fresh controller also has a fresh EOS session.

## Pinned reference and deliberate differences

`oracle/PROVENANCE.json` names the exact Hummingbird commit and every audited
source hash. `oracle/upstream/queue_manager.rs` is byte-identical. Its original
34 tests pass. The oracle supplies shims only for unrelated entity/metadata and
settings fields, so it is not an original audio/UI allocation or timing control.
The seven navigation fixtures exercise real temporary-file availability. Three
additional desired-behavior tests deliberately fail against the pinned manager:
removing row zero without a current entry must not start playback; unshuffle
must not create a current entry; duplicate metadata must retain the selected
occurrence. The new implementation fixes all three; their failing logs remain.

The 30-entry inverse history and strictly-greater-than-4096 large-change rule
remain. Key-based move clamps its destination and suppresses an unchanged block;
this is an explicit replacement for the original differing single/multi-index
edge cases. Undo restores a pre-edit current key rather than an ambiguous
metadata-equality match. While stopped, undo may restore a queue current key but
does not start a decoder plan, matching the old PlaybackThread stopped guard.

Audio decoding/output, pause/seek, the five-second Previous policy, consume and
stop-after policies, session-storage transport, full keyboard navigation,
modified clicks, drag/drop and double-click behavior are not implemented here.
The app explicitly says audio is not attached. No universal click count or
synthetic timer is introduced. This is a queue/controller and public consumer
slice, not a complete player port.

## Costs

The Syn/Tokei ledger counts compiled app `src/` separately from tests and
uncompiled upstream reference source: 1,668 → 2,927 shipping code lines (+1,259),
293 → 1,362 test code lines (+1,069). No unresolved test-span ambiguity exists.
The helper, external client, oracle shim and exact copied upstream source have
separate support bills. Manifests and locks are not source-line counts.
`triomphe` is a new direct runtime edge (previously GPUI dev/test only),
`fastrand` a new direct edge to an existing transitive package, and
`allocation-counter` a new app dev dependency. All versions are locked.

Preserved baseline `1ca457059b6747000b27c00f8f6bbb9c81f3577e` retains one key per
inserted undo entry. The final private contiguous-key range adds 21 shipping
code lines and removes exactly 800,000 retained bytes and one allocation at
100,000 entries. Shared-track construction requests/retains
3,200,352/2,400,352 bytes; unique-track construction requests/retains
17,600,352/16,800,352 bytes. These are allocation-counter requested-byte values,
not allocator usable sizes, RSS or timings. Arbitrary selections normalize once;
restoring removed/moved entries merges in place rather than repeatedly inserting
into a vector. Metadata lookup is binary; an individual order index lookup is
linear. There is no claim that every queue operation is constant time.

The 100,000-entry public view realizes four rows and fewer than 100 nodes; its
reported incremental mount begins with an already prepared queue and includes
font/UI setup. This is not a cold-model total. Retiring large history/current
state still destroys metadata on the UI thread: the raw controls show roughly
2.4 MB shared or 16.8 MB unique released by one operation. No instant large-queue
claim follows from the compressed history.

Measured x86-64 carriers at the shipping pin: key/optional key 8 B, entry 16 B,
queue 128 B, stamp/EOS 24 B, plan/optional plan 56 B, controller 200 B,
queue screen 264 B and public Win 8 B. These are layouts, not a summed stack
peak. The session atomic is one app-global 8 B identity counter, not per row.

## Qualification profiles

Early baseline/range allocation controls omitted the sparse root `.cargo`
directory and used the standalone profile; those logs remain identified as
such. Canonical qualification checks out the exact root `.cargo/config.toml`
and unsets both `RUSTFLAGS` and `CARGO_ENCODED_RUSTFLAGS`. Linux therefore uses
the checked-in v0 symbol mangling and `tokio_unstable` flags. Cross-target
qualification must use the checked-in target flags too: a global override would
silently suppress Windows `windows_slim_errors` and `crt-static`. Source guards
and actual Cargo fingerprint flags accompany the final results. No timings are
claimed, and concurrent builds are not timing controls.

Exact canonical-source default and native all-target tests pass (33 each), as
do both all-target Clippy runs with warnings denied. The guard verifies 2,100
tracked configuration, library, vendor and app files unchanged. The frozen
debug native executable is `/tmp/hummingbird-queue-365-native-frozen`,
420,811,168 bytes, SHA-256
`a07cf39a122f75a4d42bc225671eb25dd979b620c537f69c1012a55a219a79d1`;
`.text` is 35,757,895 bytes and `.rodata` 7,667,608 bytes. These are absolute
debug-artifact costs, not a matched old-player linked-size comparison. Library
is 424 B, immutable Track 88 B and PlaybackRequest 40 B at this pin.

The real public Registry replay passes with a held pointer press: mousedown,
acknowledged accessibility focus, then mouseup. It also exercises real Space,
AT-SPI selection/range, keyed reorder, removal/undo retirement and policy
controls. It uses ordinary `Window::document`, the existing public View and
existing presentation callback; no private NativeHost/model seeding occurs.
The tested paths are unavailable, so no decoder/audio is claimed. The two
rapid-click attempts fail and remain under `failures/`. A separate public
manual-ACK reproducer establishes the existing core bug: an input's collapsed
caret focus transition prepares C; immediate Release rejects PresentationStale
and consumes the gesture before ACK. The held replay does not establish rapid
click parity. A focus-only probe without an active caret does not reproduce;
that negative is preserved too. The core fix is a separate source slice.

Apple and MSVC **do not qualify** the complete app. Actual unwrapped target
compilers reach bundled SQLite and fail for absent target C SDK headers:
Apple `stdio.h`, Windows `stdlib.h`. Initial Nix-wrapper/clang-cl PATH failures
are preserved alongside these corrected-compiler attempts. No bundled feature,
dependency or profile is disabled to force success. Actual fingerprint flags
prove target configuration admission for compiled Rust dependencies; they are
not presented as full foreign app completion. The old GPUI cross checks are
not a substitute for this app's missing SDK proof.
