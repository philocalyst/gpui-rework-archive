# One-click Library intent

Library rows now offer explicit Prepare and Play now actions. Prepare resolves
one real SQLite recording and stores its immutable lease. Play now prepares
and starts that recording with one click, appending and jumping to a fresh
queue occurrence. The existing worker, command bus, result lane, queue owner
and audio service carry the operation.

The playback Question, PlaybackRequest placeholder and playback Reader are
removed. Search remains a pure Question. The explicit owner action reserves a
checked request number and stores full Selection plus the current audio Receipt
revision. The worker validates source generation before the same SQL projection
and returns full Selection with Result<TrackRef, SourceError>. The owner
requires the matching Pending, selected value, source generation and transport
revision, then retires authority before calling queue.play_now. Duplicate and
late results cannot consume it again.

A private u64 issuance counter survives source replacement; public selected data
and its typed Source remain editable. Resetting that data cannot reuse a prior
request. Exhaustion fails the new action and revokes prior Pending without
wrapping. This costs 8 B in Library. Typed errors remain intact. Public worker
commands can carry caller-chosen sequence values; full id/generation/sequence
must therefore match Pending, not just the request number. Preparation already
queued on the worker can still perform its one-row query after revocation; cancellation here governs owner
admission, not preemption of SQLite.

Selection/source replacement, Stop (including an empty queue), Pause and Seek
revoke an unconsumed Play continuation. Queue/audio updates after successful
consumption leave prepared data inert. An explicit Prepare, search retry or
unrelated import does not start playback. Command Busy/Closed fails visibly.
If the existing bounded result lane is full, the worker's existing terminal
failure policy closes its producer. The status-aware Inbox delivers buffered
data followed by one None; the owner resolves any remaining Pending as failure.
No blocking delivery, retained retry state, additional queue or worker was added.

## Public application surface

| Purpose | API |
|---|---|
| Editable data | Library QUERY/SORT/VERSION/SELECTED Sources and existing QUEUE component |
| Explicit action | Library::prepare(id, generation); audio Library::play_now(id, generation) |
| Preparation status | preparation_status(); prepared() borrowing Selection/TrackRef |
| Worker | WorkerHandle::prepare / prepare_and_play; shared existing SQL helper |
| Owned delivery | Library::receive(Option<LibraryEvent>), with_inbox_status |
| Queue and service | Existing QueueScreen::play_now and AudioHandle controls/Receipt/Event |

The row action uses the ordinary public GPUI button/Win machinery. It needs no
client-built Question, Reader retry or manual completion continuation. Native
constructs the real CPAL provider and attaches its handle before mounting the
view. CPAL device/config/stream negotiation occurs on first actual media open;
attachment alone does not establish successful device playback. An audio-feature
headless owner without output gets a clear Play-now rejection and retains pure
Prepare. Hardware CPAL execution remains unavailable in this environment.

## Bills and qualification

The initial full-Selection and rejected request-only patches and constructor
controls are retained with qualification. A request-only reply was rejected:
a prequeued public worker command for id90/sequence1 could satisfy the first
Library intent for id44/sequence1. The exact public regression fails at a357cc3c2d
and passes after restoring full Selection. Private issuance remains necessary
to prevent public selected data from reusing prior issued identities. A public
PrepareAndPlay command cannot grant playback to an owner's pure Prepare.

LibraryEvent is 96 B versus the prepared-only control's 32 B. The existing
channel and staging capacities remain eight each, so their requested buffer
bytes grow 1,024 B. Model grows 416 to 472 B; removing the playback Question
shrinks Questions 1,016 to 600 B and the bound Win's inline size 1,080 to 664 B.

Four default-feature construction cohorts measure UI-thread Rust allocations
across worker creation, connect and mount, plus Win inline storage. Retained
totals fall 7,251 B in every cohort: cold 107,763 to 100,512 B; warm 103,443 to
96,192 B. Requested bytes fall 35,370 and allocation requests fall 44. The
rejected request-only version saved another 384 B, which did not justify its
authority bug. These numbers exclude worker-thread allocations, SQLite C
allocation, native/device memory, RSS and performance. They establish no whole
process or universal resource claim.

Public tests drive real SQLite files/fixtures, Library/Sources/Questions,
Remote/Inbox, queue and audio service. The bounded OutputProvider alone is
substituted. They cover canonical WAV/FLAC PCM, paused seek, partial/final tail,
latest lookahead and compatible stream retention; zero/257 frame credits;
fresh occurrences and retired token rejection; duplicate/late preparation;
source-revalidated same-ID playback; cancellation by empty Stop and active
Pause/Seek before buffered result consumption; close with Pending; unattached
output; full result-lane terminal failure; public selection reset/source
replacement; checked exhaustion through the actual method; caller-chosen request
collisions across recording/source identities; and public worker Play commands
against a pure owner Prepare. Scheduled audio performance remains ignored; no new timing campaign was run. The final full
default suite passes 42 tests; the full CPAL-feature suite passes 88 with one
scheduled test ignored. Strict native-feature all-target Clippy passes. Raw
commands, logs and constructor controls are in `qualification/library-intent/`.

Upstream provenance remains LIBRARY-PLAY-UPSTREAM.json at Hummingbird
e15e8ba0ef6ff5445294030d373e3c8ccc7d780c. Its named Play-now context menu appends
and jumps, which this action follows. Other upstream listing actions replace an
album/playlist context; that workflow remains absent. The earlier prepared-only
report's 54-line comparison is historical. This successor adds explicit
cancellation, terminal failure and application state; it claims deletion of one
class of Question work, not fewer total application source lines.

Full navigation, scanner/watch/import UI, artwork/settings/platform media,
remaining transport features and arbitrary-rate resampling coverage remain gaps.
Earlier audio and prepared-only pins/captures remain frozen. There is no new
native-window, hardware playback or full-player performance qualification.
