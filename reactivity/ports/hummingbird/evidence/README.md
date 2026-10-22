# Hummingbird port qualification

Final source is `1183954cdab2a15060bc8a1046cb9c5fb815e495`, based on
`6e9839856d`, with Hummingbird source pinned to
`e15e8ba0ef6ff5445294030d373e3c8ccc7d780c`. Source and evidence commits are
separate. Tracked source was clean during the final captures; this evidence
directory was the only untracked addition. `provenance.json` records commands,
compiler versions, source/lock hashes and immutable binary hashes.

This is a SQLite-backed Library port through the ordinary public GPUI owner.
It does not implement audio output, scanner/watcher, full player navigation,
queue, artwork or platform media integration. These are Linux x86_64 debug
correctness gates, with the native CPU reference renderer. Elapsed build/test
lines in raw logs are not performance measurements.

## Final gates

- `tests-1183954cda.log.gz`: eight query, matching and public-owner tests pass.
- `clippy-1183954cda.log`: strict all-target Clippy with the native feature passes.
- `headless-1183954cda.log`: actual SQL order, Unicode matching, ID44 play,
  resort/import identity, stale completion rejection and real missing-table
  failure/recovery pass through one ordinary `Win` and the shared `Library` View.
- `native-1183954cda.json`: an external client launches the ordinary `Window`
  under its own Xvfb/private D-Bus/AT-SPI session. It observes nine initial
  results, actual Play ID1/path `/music/1.flac`, the same accessible row action
  after SQL resort, real X11 keyboard input `cafe` with three acknowledged
  results, then AT-SPI Unicode input `μαρ` and Play ID44/path `/music/44.flac`.
  All eight captured frames have equal source and presented epochs.

Native matching checks the acknowledged count; the individual cafe IDs
`[13,11,21]` are asserted by the separate real-SQL/headless tests. Native does
not exercise fixture import or source replacement; the public headless owner
does. This is not a GPU, macOS, Windows, audio or full-player qualification.

The worker owns SQLite and matcher scratch. Search, play and source commands
share one bounded channel. Imports commit and advance its authoritative revision
before publishing Inbox updates. The explicit revision-coherence test leaves the
Inbox unbound, commits ID5000, proves an old-revision search faults instead of
becoming Ready, then delivers the Inbox and recovers to the correct revision.
Cancellation is only an early-exit hint; full frozen-version validation and core
completion admission control publication. See the parent README for ownership
and the limitation on changes made by external database writers.

All 39 migrations, the uncompiled original TrackQuery reference and Apache
license were checked against their pinned SHA-256 values. Compiled queries are
an adaptation with documented transport/domain changes. Title-desc ordering and
the matcher prefix quirk remain explicit compatibility fixtures.

The six registry families added relative to the inherited root lock are
Rusqlite0.40.2, libsqlite3-sys0.38.2, Nucleo matcher0.3.1,
fallible-iterator0.3.0, fallible-streaming-iterator0.1.9 and vcpkg0.2.15.
Their resolved checksums/versions match primary registry latest-stable metadata.
Bundled SQLite reports3.53.2. The vcpkg build dependency is recorded even though
the bundled Linux build does not use a Windows package installation. This
statement concerns these additions; inherited GPUI dependency constraints retain
their separately documented compatibility decisions.

The unfiltered offline metadata command encountered an uncached Emscripten
package. That failure is preserved; the Linux-filtered metadata command passed.
No unsupported cross-target build claim is inferred from the standalone lock.

## Historical controls

`controls/` preserves preliminary failures and a preliminary success. They ran
on integration base `d05b826b62` with an uncommitted app, before the final source
freeze and before the Parley0.12 integration. Their app source was not archived
byte-for-byte; they must not be relabelled as a final source commit. The success
JSON contains that executable's digest. No independent executable digest was
captured for the failed runs.

- `preliminary-offscreen-driver-failure.log` and its native log retain the
  requested losing control: the driver sought ID13 (`CAFE Étude`) after
  longest-first ordering moved that row outside the anchored viewport. Its
  timeout did not establish an identity failure. The final capture follows ID1,
  which remains visible through the same real SQL resort.
- `preliminary-scalar-driver-failure.log` retains an external driver's wrong
  assumption that `busctl get-property` JSON data was a tuple. Correcting scalar
  handling allowed actual accessibility discovery.
- `preliminary-native-success.json` is historical only. Its `matched_ids` field
  copied the companion headless fixture expectation; native accessibility
  observed the count, not those individual IDs. The final record explicitly
  uses `visible_result_count`.
- `preliminary-prefix-expectation-failure.log` retains the initial incorrect
  expectation for `^Other`. The final tests preserve actual Nucleo0.3.1 prefix
  behavior rather than silently changing the dependency.

The native driver owns display127, private runtime/settings and spawned
processes, and cleans them up. Raw accessibility/XKB daemon messages are retained
without claiming that warnings or incidental timestamps measure application
performance.
