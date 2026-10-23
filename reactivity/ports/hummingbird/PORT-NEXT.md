# Upstream application inventory and proposed next slice

The reference is Hummingbird e15e8ba0ef6ff5445294030d373e3c8ccc7d780c.
`qualification/main-port/upstream-api-inventory.json` records every source path
and Git blob in the seven areas below, plus the entire upstream source manifest. The groups overlap intentionally, for
example artwork work within scanning and library settings within both scanning
and settings. This is an API inventory, not a parity count.

| Area | Pinned upstream API and behavior | Current port |
| --- | --- | --- |
| Navigation and library UI: 38 files | `ui/library.rs` owns `NavigationHistory`, capped at 100 entries, back/forward/refresh, `ViewSwitchMessage::{Albums,Tracks,Artists,Files,Release,Artist,Playlist}`, scroll restoration and two-column detail. Album/artist/release/playlist/file pages, sidebar, collection summary, track context menus and search have distinct views. | One searchable recording list and queue. Explicit named-track Prepare/Play-now; no routed collection pages or listing-context Play-from-here. |
| Scanner/import/availability: 44 files | `ScanInterface` exposes scan/force scan/targeted paths/settings/stop/missing-folder resolution/storage availability. `ScanEvent` distinguishes cleaning, progress, missing-folder decision, playlist updates and watching/idle/targeted completion. Discovery, record/session state, tags, transactional artist/album/track links, watcher reconciliation and platform storage availability are separate stages. | The explicit fixture import writes real SQLite and publishes a revision. It does not scan directories, read tags, watch files or resolve missing roots. |
| Artwork: 7 directly related files | Hash lookup, migration adoption, processing/thumbnailing, folder-vs-embedded candidates, finalization/cache, managed image ownership and current-art image events. | Schema retained; no image decoding, thumbnail cache or displayed cover art. |
| Settings: 25 files | Persisted scanning/playback/interface/services/update settings; corrupt-file recovery, legacy theme adoption and external-file watching. Playback includes output/replaygain/equalizer controls; UI includes library folders, services, appearance and update options. | No settings persistence/editor or output selector; the public constructor chooses a provider. |
| Platform media/services: 13 files | `InitPlaybackController`, `PlaybackController` and `ControllerBridge` connect Linux MPRIS, Windows and macOS media controls. Events include metadata/art, duration/position, volume, repeat/shuffle and state. Discord/LastFM/ListenBrainz services are additional consumers. | No OS media bridge, volume/replaygain/equalizer, scrobbling or presence integration. |
| SQL and library models: 16 files | Typed album/artist/playlist/track queries and models, query direction, playlist order and library statistics. | Existing track-query filters/order/joins plus search and queue snapshots. Album/artist/playlist screens and their complete queries remain absent. |
| Media metadata and providers: 11 files | MediaProvider feature lookup, metadata/tag/date/number parsing, Lofty and Symphonia providers, stream decode/seek and channel pipeline. | Real WAV/PCM, FLAC and MP3 decoding. AAC/Opus and the upstream complete codec/tag/provider surface are absent; the current service supports only mono/stereo through 768 kHz and has explicit bounded-ratio admission limits. |

The native rehearsal now uses the public `application::window(Database,
OutputProvider)` constructor. Production uses `system_window` with the same
Library, Questions, bounded result lane and audio service. The actual Registry
qualification substitutes only a 64-frame counting output provider; hardware,
latency and complete application parity remain unqualified. Historical DSP
failures and changed-filter regressions remain in PORT-REHEARSAL.md and their
original reports.

## Proposed next implementation: routed collection browser and context playback

Build the actual library shell: Tracks, Albums, Artists and Playlists navigation,
album/release and artist detail, playlist ordered recordings, back/forward and
refresh, with a shared search/sort/header and queue. Read-only playlist browsing
comes before playlist editing/import. Files, scanning, artwork/settings and OS
media remain distinct later work; placeholder screens do not establish parity.

Use one application-owned typed `Route` and bounded navigation history instead
of constructing a forest of mutable page entities. A declared Navigation source
owns the current route/history; expose nested controls through the current main
typed SourcePath API and existing component sources. Route, search, sort and
source Version freeze into the existing pure SQL Question. Its typed page
result carries the collection identity and source version; a stale result cannot
rebind a new route's recording actions. Ordinary local selection and navigation
stay in the owner. No second library worker or result queue is needed.

Extend the current SQLite worker with collection-page reads and an explicit
prepare-listing command. The latter prepares an ordered immutable track snapshot
and selected position only after a user authorizes Play-from-here or Play-all.
The existing result lane returns a typed result. The owner consumes that result
once under route/source/request/Receipt authority, then installs the queue in a
single transition. This adds listing-context replacement missing from the
current named-track append/jump action. Search/retry/refresh remain pure; neither
a completed page query nor merely visiting an album starts playback.

The public developer surface should let a component name its own typed route or
selection field and bind a child edit through SourcePath, without repeating
the root's field IDs or copying a second selected-value mirror. Use the existing
`with_inbox_status` API on main; Root's isolated `with_inbox_for` is not available
here. Any further core API change needs a separate source/type/codegen bill.

Qualify real album/artist/playlist SQLite fixtures and original ordering/joins,
route back/forward and source replacement, stale page/result cancellation,
missing/unavailable recordings, and exact queue occurrence identity. Drive the
new public buttons through headless Win and an actual Registry native run with
the same bounded real-service output boundary. Preserve the source/owner/header
and allocation bills, count application code separately from shipping core,
and compare actual application call sites with the pinned upstream UI. This is
a substantial application slice; no further DSP microbenchmark is a substitute.
