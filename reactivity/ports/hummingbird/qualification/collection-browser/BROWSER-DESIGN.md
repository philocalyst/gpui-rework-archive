# Routed collection browser and explicit context playback

The frozen candidate ae18a3740471a0c7b1f8261713c7bcd8d94d6019 extends the qualified
9f83 source-authority port. Nineteen application/example/client/test paths change;
no core, dependency, lockfile, DSP, output provider or worker-count change.
Application source6571 versus5633 (+938); core30987 unchanged. The unchanged core
and vendor tree is checked against730 (1984 file hashes), and730 has the same
shipping core as914/9f. No whole-player speed or resource non-regression is claimed.

## Usable application surface

The same public application::window(Database, OutputProvider) exposes Tracks,
Albums, Artists, Playlists, album and artist detail, playlist occurrence order,
Back/Forward/Refresh and shared search. The navigation history is capped at100;
branching drops forward entries. One private checked domain counter gives each
visit/refresh two fresh nonzero list domains; queue retains zero. Artists include
album-linked and standalone track credits without duplicated track rows; playlist
position ties use item ID, preserving occurrence rather than only recording ID.
Album artist display overrides are respected. Empty and missing collections have
real SQL outcomes. Collection indexes show their fixed ordering rather than sort
buttons that do nothing; album/playlist default ordering is named explicitly.

Library::BROWSER is an existing typed Component; Browser owns its Navigation,
Query and Sort Sources. Public Win.set composes BROWSER.source(QUERY/SORT), while
buttons use NAV.update; tests can navigate through ordinary Win.update. Four
inputs form nested pairs for one existing Question. There is no mutable model,
Question, Reader, subscription or worker for each route. One typed Page owns the
result; its input() borrows the track rows' existing shared Input. Track/card
ItemSource adapters share immutable Input, not copies of query strings per row.
Only realized context buttons retain Input Arc clones; headless no-audio rows
perform no unused context clone/drop. The old worker Search command and misleading
generation-derived recordings() helper are removed; recording_list() returns the
actual active domain. The direct Searcher SQL utility remains for its public
query controls.

The worker reuses its existing four-command channel, one thread and eight-event
result lane. One borrowed read_tracks projection supplies both displayed tracks
and explicit context preparation; preparation skips page title/card SQL. Pure
page/search/retry/import/refresh work neither prepares a queue nor opens output.
Play all and Play from here explicitly prepare ordered metadata and an occurrence
position. The prepared Vec moves into the existing queue; the entire listing is
retained, including preceding entries. Existing shuffle/repeat/undo and occurrence
stamps remain authoritative. Unavailable selected paths and every returned queue
error precede mutation. No new queue/backend or audio device implementation.

## Authority and concurrency

A checked private monotonic request sequence never resets on source/selection
changes. A context reply must echo the complete PlayRequest: shared frozen Input
(route, private list domain, query, sort, full source Version), selected RowKey
(including playlist item ID) and sequence. Pending also holds the private browser
Signal revision cohort and audio Receipt revision. Changing query/sort away and
back still revokes the continuation; route/refresh, public selection edits and
new clone Stop/Pause/Seek revoke it. The same-Selection pure Prepare reply cannot
consume context intent, and mismatched context replies cannot consume named intent.
Pending is retired before queue mutation, so duplicate replies are inert.

The existing WorkerHandle.with_current_version validates actual published source
Version and holds Source authority through the existing Audio desired transaction
and queue edit. Lock order is Source then Audio; callbacks must not reenter either
handle or wait on worker commands. Queue scans/allocation scale with listing and
queue size, so this is not a hard latency-bounded callback or panic rollback.
Named Prepare/Play/Add retains9f generation-only lease semantics across imports;
context listings require exact Version because membership/order can change.
The worker commits/adopts SQL before Version publication, and acknowledgement
follows publication. External SQLite writers/watchers are outside this contract.
Worker final close/failure retires published source before native disconnect wake;
old buffered context cannot play after finish and terminal failure is visible.

Page cancellation uses existing Completion cancellation between fetched rows.
SQLite internal sort/step is not preempted. A late explicit preparation can finish
SQL work before the owner rejects its revoked result; no hard preemption claim.

## Fixtures, proof and limits

collection_fixture extends the real migrated SQLite fixture with album/artist
relations, an orphan artist, an empty album/playlist, a Unicode playlist and tied
playlist positions. Three actual WAV/FLAC/MP3 paths back the context playback
fixture. Headless tests drive only public Sources/Win/worker/service APIs. They
cover relation ordering/deduplication,100-entry history, unavailable paths,
prequeued wrong input/occurrence/sequence/pure replies, duplicate replies,
route/query/sort/refresh/import/replacement, clone controls, worker finish,
zero-credit backpressure and64 accepted real PCM frames. Queue controls prove
same-track occurrences remain distinct under shuffle and errors leave the old
plan unchanged. All prior audio/queue/SQL regressions remain in the full suites.

The actual native client uses original public buttons and actual Registry. Its
optional --collections scenario traverses collection details and Unicode search,
prequeues a pure-Prepare collision, starts listing context, observes the real
service/64-frame bounded output, Stop revocation, disconnect failure and normal
WM_DELETE_WINDOW. The original provider and150s client/180s outer/5s kill grace
remain. No hardware or latency claim. Final results and source/binary guards are
reported separately from this design description.

Reference inventory pins13 upstream UI/query files at e15e8ba0 (5167 code lines
excluding tests). Those files include substantial unported features; comparing
that selected total to this port establishes no equivalent-feature code reduction.
The existing complete Apache-2.0 LICENSE.upstream remains; SQL projections and
bounded navigation are adapted with the specific architecture changes above.

Missing: Files, scanning/tagging/watch reconciliation, artwork, settings/output
selection, OS media/scrobbling/presence, playlist editing/import/export, complete
upstream sorts, two-column views, per-route scroll restoration and full codec/
provider coverage. Current default remains Tracks. Historical four unresolved
processing comparisons, constructor cohort24 ratio1.429 [1.427,1.432], untimed v2
geometry/changed filters and bounded rational-rate admission remain adverse.
CPAL pause-before-fade, EOF live stream/2ms polling, drain/token retirement and
startup rendezvous remain unchanged. This is collection-browser/context-playback
progress, not full Hummingbird parity or universal performance qualification.
