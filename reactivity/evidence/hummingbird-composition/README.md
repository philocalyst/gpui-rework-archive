# Browser, Files and fresh-schema composition

Main adopts the application/vendor paths of Root's
`a414a390b00b0431567f3777903e657027e8d3bb`, over Main
`47c46ddcf0f6749eb317d0058bdbb3170ff9cff3`. The
[source ledger](source-equivalence.json) records every adopted path and 148
identical library source/build files, including their test modules. This is an
application integration; the core remains 31,616 non-test, non-comment lines.

The ordinary Hummingbird View now navigates albums, artists, playlists and Files,
with persistent library roots and cancellable WAV/FLAC/MP3 metadata acquisition.
The existing worker owns SQLite and interleaves indexing with its other commands.
TEMP staging and final atomic publication prevent obsolete partial scans from
becoming a library source. Files stores one canonical directory prefix and exact
`OsString` child names; row actions lease that immutable listing by ordinal.
Explicit playback checks route, query, source version and audio Receipt together.
The [port documentation](../../ports/hummingbird/FILES.md) records behavior,
adverse resource cases and remaining gaps.

The complete licensed Symphonia RIFF 0.6.1 vendor has a two-line metadata-owner
correction, not a second application parser. Its upstream license stays
byte-exact, including its existing trailing whitespace. The lock retains Main's
earlier removal of production Swash, Skrifa 0.44 and Yazi. No core or font vendor
source changes are included.

## Fresh creation deletes migration replay

An offline generator derives the final schema from 39 unchanged, pinned upstream
migrations. Production creates it in one IMMEDIATE transaction covering ownership
admission, DDL, original seed expressions and marker. Existing marked version 1
libraries reopen without DDL or reseeding. Unmarked databases containing any user
object and unknown/future markers are rejected. Upstream libraries retain the
separate read-only API. The original migrations remain an independent bundled
SQLite test oracle. The worker's three acquisition tables share one transaction
at their existing admission boundary.

The oracle compares schema SQL, trigger order, columns/defaults/generated fields,
indexes, foreign keys, seed semantics, actual data and SQLite-owned autoincrement
behavior. Tests cover late creation failure/rollback/retry, no-write reopen,
concurrent creators and previously exploitable view/marker/internal-name cases.
Normal durability remains foreign_keys=1, synchronous=2, journal=delete.

Untimed full-process syscall controls record constructor fsync 392→4 and
pwrite64 1010→44, with the same 172,032-byte closed database. A separate
constructor→worker control isolates acquisition setup: fsync 16→8 and pwrite64
90→70, with the same 204,800-byte database. Test-only feature differences and
the absence of matched production codegen/latency measurements are explicit in
the [producer ledger](fresh-schema-ledger.json). These are counts of deleted
work, not startup-time or RSS results.

## Root qualification and retained failures

Full combined application qualification pins `5edeb285ed9e1de602cdfe1890f336874dbf88a3`:

- Default: 70 passed, 2 explicitly ignored syscall controls, 18 harnesses.
- Native feature: 143 passed, 3 ignored, 20 harnesses.
- The unchanged seven-case indexing module passes both original 120-second gates.
- Ordinary native-service binary: default, collections and Files clients pass
  through actual X11/AT-SPI Registry services; owned children are reaped.
- Strict default passes. Library doctests (31) passed on the identical core.

The final successor changes only two PCM fixture helpers and three docs/offline
tool paths. All production app Rust, schema, dependencies and library sources
are byte-identical to the full qualification. Strict native all-target checking,
the affected 25-case library-audio target, formatting and offline regeneration
pass on `a414a390b0`. The direct audio helper's test target passed separately on
`603605d68b`; its source is unchanged in the final successor. Feature test totals
overlap; they are not counts of unique cases.

Original Files composition `64162234a0` has default/native indexing timeouts
(exit 124) and deprecated-atomic strict failures. Kernel snapshots show actual
filesystem journal waits; a later diagnostic completion does not relabel these
failures. The fresh-schema source removes the repeated durable transactions.
Strict failures on `5edeb285ed` and `603605d68b` identify the two fixture helpers
separately; all original logs remain. No watchdog or correctness tolerance changed.

[The archive](qualification.tar.gz) contains raw commands, guards, logs,
failures, native output, producer ledgers and syscall traces. Its
[member ledger](archive-members.json) lists hashes and external binary/media/DB
payloads; [archive.json](archive.json) records the reopened archive verification.
Frozen executable identities remain in the included original binary/seal JSON.

## Source and scope

The fresh-schema formulation reduces production application Rust from 8,085 to
7,936 non-test, non-comment lines. The [source bill](app-source-bill.json) charges
the shipped SQL separately (213 code lines, 8,749 bytes), offline generator
(78 code lines) and provenance. Complete vendored RIFF source is separate from
both the application and core count. Migrations excluded from production remain
in the repository under a test-only import; they have not disappeared.

Artwork, settings/output selection, media services, watchers, rename matching,
playlist editing and complete codec/provider coverage remain. The documented
audio rate/filter, pause/fade and natural-EOF limits remain. This qualification
adds no physical-device, native foreign-platform, performance, whole-player
parity or Zed-port claim.
