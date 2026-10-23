# Library one-click intent qualification

Qualified application source: `197fb3917df221e84f4d2247a91f1c19aabb9bc8`.
The earlier `a357cc3c2d10813dfa56d71925bb5c06610ac9ea` request-only reply is
**rejected**, despite its passing ordinary suite and smaller allocation bill.
The exact public collision regression prepares id90 when Library requested id44
at that pin (exit101). The same test passes after full Selection is restored.
Both outputs, the exact test and source/binary hashes are preserved. The failing
binary remains `/tmp/gpui-library-oneclick-authority-collision/control-tests`.

The final public worker command API stays available. Replies must match the
Pending id, generation and sequence, the current selection/source, and the audio
Receipt for Play. Private checked issuance survives public selected-data resets
and source replacement. The owner retires permission before queue mutation.
A public PrepareAndPlay command cannot grant playback to pure owner Prepare.

The existing SQLite worker, four-slot command bus, eight-result lane, queue owner and
audio service carry the action. The playback Question/Reader/PlaybackRequest are
deleted; the search Question remains pure. No worker, queue, backend or dependency
is added. Full result delivery failure terminates the worker as before; the
qualified terminal Inbox now delivers buffered data then one None, resolving
accepted Pending rather than silently losing its completion.

## Checks

`commands.json` records normal invocations and environment; raw logs retain all
suite counts. Default: 42 pass. CPAL feature: 88 pass, one scheduled test ignored.
Strict native all-target Clippy passes. The native-feature headless executable
completes the real SQLite/search/import/preparation transcript. This opens no
native window or audio hardware. The bounded output provider is the only
substitution in the six public Library→SQLite→queue→audio-service tests.

Checks cover real WAV/FLAC PCM and tails, paused seek, latest lookahead,
compatible joins, zero/257 output credits, fresh occurrences/old token rejection,
one-click same-ID source revalidation, selection/source/empty Stop/active
Pause/Seek cancellation before buffered result admission, close, absent output,
full result-lane terminal failure, duplicate/late worker work, public source
edits, issuance exhaustion, caller-chosen id/source collisions and pure intent.

Earlier request-only logs and exact source/diff stay under
`request-only-rejected/`. Its first default test failure was an obsolete
prepared-pane retention assertion after source replacement, corrected to assert
retirement. This is separate from the later real identity bug. Initial full
reply and narrowed patches/fixture sources remain in `construction/`.

## Resource and source bills

The identical temporary constructor probe runs four default-feature cohorts on
real Worker/connect/Win. Control is `e62a4ae5ae7792be2e332e0ff0d356cf429705e0`;
its application is the frozen prepared-only implementation. The probe source
changes only the required binding method. `summary.json` preserves every row.
The final candidate retains typed SourceError and full Selection.

| Host layout / requested storage | Control | Final |
|---|---:|---:|
| Library / Questions / Win inline | 416 / 1,016 / 1,080 B | 472 / 600 / 664 B |
| LibraryEvent / Selection / SourceError | 32 / 32 / 64 B | 96 / 32 / 64 B |
| Cold retained UI construction + Win | 107,763 B | 100,512 B |
| Warm retained UI construction + Win | 103,443 B | 96,192 B |
| connect allocations / requested bytes | 3 / 320 | 2 / 184 |

Every cohort saves 7,251 retained bytes, 35,370 total requested bytes and 44
allocation requests. Eight channel plus eight staging slots grow 1,024 B; the
private issuance counter costs 8 B. The rejected request-only reply saved 384 B
more, which did not justify weaker authority. The initial full reply lacked
that private counter; its measurements remain separately labeled.

These are UI-thread Rust allocator requests, not process memory. Worker-thread,
SQLite C, native/device allocations, RSS and timing are excluded. No steady
state allocation, whole application machine-code or performance comparison was
made for this application change. The core transport bill is separate: its
ordinary native endpoint pair grows 8 B and optimized caller text grows 99 B.
Headless transport has unchanged headers/allocations and identical caller object.

`count-app.py` applies the repository Syn/Tokei exclusion to all committed port
src, including binary/all cfg branches, with no unclassified syntax. Shipping
source grows 5,226→5,327 (+101) non-test code lines. Removing one class of Question
work is not a total source reduction. Source/fixture hashes, full final diff,
identity-restoration diff, and exact pre-narrow patches remain reviewable.

## API and parity review

Both pinned upstream Play-now and this row action need one callback/one click.
Upstream's menu calls play_track_now, constructs QueueItemData, reads the global
queue length and sends Queue then Jump through PlaybackInterface. The port row
calls Library::play_now(id, generation); it prepares through SQLite, checks
owner authority, then calls the existing exclusive QueueScreen::play_now.
Public preparation_status/prepared expose progress and a borrowed lease; the
application client needs no playback Reader/retry/continuation wiring.
`api-review.json` records concrete pinned source anchors and line spans; they
are review aids, not an equivalent whole-stack source comparison. The port's
explicit guards and terminal status add code; no fewer-than-upstream claim.

Upstream provenance/license remain LIBRARY-PLAY-UPSTREAM.json/LICENSE.upstream.
This matches named append-and-jump Play now. Album/playlist listing-context
replacement, navigation, scanner/watch/import UI, artwork/settings/platform media,
remaining transport features and arbitrary-rate resampling coverage remain gaps.
CPAL's real provider is attached before native view construction; actual device
negotiation is lazy on media open. Hardware playback is unavailable here.
No new native-window capture, timed campaign, full-port or universal adoption
claim follows from these results.

Core prerequisites are the reviewed 07939f6840 transport plus identical
9af82dda17/bc4c0f5cdd cleanup/test cherry-picks of 0cd64a9aa9/2aec8e8f5b. The
retirement fix e62a4ae5ae is identical to Parent's cc74e92d7f, not new work.
Frozen earlier audio, two-step and core capture pins are unchanged.
