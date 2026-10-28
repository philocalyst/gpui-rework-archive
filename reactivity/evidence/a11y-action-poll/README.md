# Consume native action results at the owner borrow boundary

Production source `5b4a2d7fc792a4e9929589eaf4c0ac94f144de39`; final test
source `e96c1b748e49ae3988fffcab154a36090ff5ac68`. Source and test patches
are against integrated queue source `a6ac3ea81f`. This follows the
[owner-lazy transport](../owner-lazy-a11y/README.md), whose queue, payload,
session, source and geometry admission remain intact.

The old bridge applied up to sixteen actions and returned all their results
in a stack array. Native dispatch handled those outcomes only afterward.
Now one poll returns Empty, Discarded, or an applied result. Its short bridge
and owner borrows end before the host handles that result and polls again.
The host owns the sixteen-command budget, including discarded sessions, and
rearms once after a full turn. Empty/unpublished polls stop immediately.
The older projection fixtures collect results only under `cfg(test)`.

This deliberately strengthens two failure boundaries: fatal action outcomes
stop before consuming another command, and overflow is checked before each
poll rather than only at batch entry. Recoverable presentation failures still
retain source changes, notify the public observer, and allow a later queued
repair. No owner fields, heap allocation, public API, dependencies or unsafe
code are added. Syn/Tokei charges **30,696** nontest, noncomment core lines,
**+10** against the preceding queue integration and +4 against 30,692 before
that integration. This source-size cost is separate from generated code size.

The ordinary public empty Window is built twice at the same physical source
path, with the same dependencies, lockfile, release profile, features and root
flags, adding stack metadata once. Both actual library and linked consumer
are rebuilt (`fresh:false`), guarded, frozen and inspected. Whole linked
`.text` changes **11,636,039 → 11,632,343 bytes (−3,696)**; read-only data is
unchanged and relocation data increases 40 bytes. The callback changes
7,500 → 7,331 code bytes and **3,000 → 2,120 static frame bytes**. Bridge
drain/poll changes 3,088 → 1,611 code bytes and **1,432 → 296 frame bytes**.
The new rearm helper is 24 code bytes with a zero metadata frame. The other
listed NativeHost and Bridge methods, including input_result, new and sync,
retain their code/frame sizes. Complete aliases, symbols and assembly remain
in the archive. These are static compiler frames, not dynamic stack peaks,
RSS reductions, summed call chains or measured latency.

The restored production source passes **216 native library cases**, with
27 native cases ignored. This run precedes adding the already-qualified
provider failure fixture; final test additions pass strict all-target X11
Clippy and scoped formatting. Actual Apple ARM64 and Windows MSVC installed
source native library checks pass; they do not establish foreign runtime
behavior. Production bytes are unchanged by those final test additions.

An actual native Driver/X11 proof uses a deterministic direct-ingress schedule
and real WorkReady/presentation callbacks. Its three scenarios verify:

- owner panic leaves the following command unconsumed;
- a missing-glyph presentation failure is reported and a queued repair succeeds;
- sixteen old-session commands consume the budget, then a rearmed turn applies
  the current-session command.

The direct-ingress proof is distinct from the final actual AT-SPI Registry
client: an unsupported-glyph edit preserves old-P text/extents, another old
provider edit cannot overwrite failed logical state, the original public
Repair button restores acknowledged source, and caret/value edits succeed.
That unchanged client passes against the final poll source.

The negative control deliberately reinstates delayed sixteen-result handling.
The actual native test fails because the command after the fatal action has
already been consumed. Exact source restoration, rebuilding and rerunning
make the proof pass. This detects that specific regression; it is not an
exhaustive correctness claim. Two earlier fixture mistakes are preserved:
an assertion wrongly expected no error on Exiting after successful fatal
validation, and a view panic was wrongly used as a recoverable failure even
though it intentionally poisons the owner. The final recoverable fixture uses
an ordinary missing-glyph error. A first missing-import compile error is also
retained, without counting it as qualification.

The archive contains 100 reopened/hash-verified members, including source
overlays, failed/restored logs, compiler fingerprints, all linked symbol/frame
ledgers, assembly and exact runners. Seven large ELF files remain external
with size/SHA-256 records. No timing, hardware, RSS or universal platform
performance claim is made.
