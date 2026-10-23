# Prepared Library playback integration

The prepared-recording pane now has an explicit Play now action when audio is
attached. It appends that immutable TrackRef and jumps to its fresh occurrence,
preserving existing entries. One checked controller serial is reserved before
mutation, then one final Plan is published to the existing audio service. An
unavailable snapshot is disabled; selection/source guards reject a retained
action after another selection or database replacement.

This is still a two-step workflow: the Library row's existing Play action
prepares through its read-only Question, then Play now authorizes the effect.
Preparation, completion admission and retry never start audio. Single-click
listing playback with an owned cancellable continuation remains a concrete
upstream UX/API gap; this integration does not claim complete Play-now parity.

The existing public interfaces carry the whole operation:

| Layer | Current public API |
|---|---|
| Source inputs | Library QUERY/SORT/VERSION/SELECTED descriptors; existing Sources and QUEUE component schema |
| SQL validation | WorkerHandle::play(Selection, Completion); pure PlaybackRequest Reader |
| User action | Win semantic `Play <title> now`; existing accessible button/action machinery |
| Queue owner | QueueScreen::play_now(TrackRef); PlaybackQueue::play_now(track, available, draw) |
| Service | AudioHandle apply/set_playing/seek/stop; Receipt revision/token; typed Event Remote/Inbox |
| Status | AudioState and position_ms/duration_ms through QueueScreen::audio_status |

No Source field, model header, worker, command queue, backend, runtime hook or
dependency was added. The new controller method avoids publishing the append's
intermediate plan before jumping. Duplicate explicit plays are fresh occurrence
authorities; old EOF/seek events cannot act on the new one.

At Hummingbird pin e15e8ba0ef6ff5445294030d373e3c8ccc7d780c,
`src/ui/library/context_menus.rs:261–273` implements Play now by appending through
PlaybackInterface and then jumping to the old queue length. The track wrapper
at lines322–325 constructs QueueItemData. The menu action is in
`context_menus/track.rs:79–85`. In contrast, listing clicks use
`play_from_track_listing` and can replace an album/playlist context. This port
matches the named Play-now append/jump semantics, not that broader listing flow.
Source hashes are in `LIBRARY-PLAY-UPSTREAM.json`; the original Apache notice
remains in LICENSE.upstream.

For API review, the port adds 54 net production lines across Library,
QueueScreen and PlaybackQueue, excluding the four-line exhaustion assertion.
The pinned menu + track wrapper + Play-now helper + queue/jump interface bodies
occupy roughly 31 lines, backed by their existing global models/command service.
The port's explicit selection/generation/availability and serial guards add
code; this is not a claim that it is fewer total lines or a faster application.
Public tests infer the heterogeneous Win lane type; a local Owners alias names
the test fixture bundle without adding an application wrapper or dispatcher.

Three complete public-owner scenarios use the real Library, Sources,
Questions, SQLite worker, Remote/Inbox, queue, Symphonia and audio service.
Only OutputProvider is replaced by a bounded sink. They verify:

- Exact canonical nonzero WAV and FLAC samples, partial tail, paused seek to
  zero, latest queued successor, compatible stream retention and final drain.
- Zero and 257-frame output credits, pause retention, immediate Stop permission,
  fresh explicit occurrences, retired token/selection rejection, and close with
  a pending Question and a zero-credit service.
- Database source replacement, retained old prepared-action rejection, old row
  retirement, and revalidation/playback of the same ID's actual new FLAC path.

The initial full-song harness coupled 257-frame drain credits to every full
debug UI redraw and exceeded a 5-second lifecycle barrier while decoded frames
continued advancing. The preserved source/logs are under
`/tmp/gpui-hummingbird-library-play-stall`; this is not a proved production
stall or performance regression. The final harness retains separate zero/257
credit assertions and uses ordinary 4096-frame credits for full-song drain,
with a loose 15-second lifecycle bound. No audio production fix was made for
that timeout. Temporary service tracing was removed byte-for-byte.

Qualification: 35 default tests and 78 all-audio tests pass, with the single
quiet-host scheduled gate ignored by default. Strict all-target Clippy with
cpal-output passes. A separate cleanup commit preserves upstream f32 literals
with a documented local precision allowance, moves the unchanged FFT test
module after its implementation, and names its test-only owner tuple. These
make strict checks pass without changing DSP arithmetic. Logs and source hashes
are in `qualification/library-play-prepared`.

There is no new timing campaign, native-window capture or hardware playback
result. Full navigation, scanner/watch/import UI, artwork/settings/platform
media, remaining transport/audio features and the rate-admission gaps documented
in AUDIO.md remain outside this slice. Frozen earlier audio sources and captures
remain in their original worktree and snapshots.
