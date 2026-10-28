# Upstream application inventory and current gaps

The reference is Hummingbird e15e8ba0ef6ff5445294030d373e3c8ccc7d780c.
`qualification/main-port/upstream-api-inventory.json` records every source path
and Git blob in the seven areas below, plus the entire upstream source manifest. The groups overlap intentionally, for
example artwork work within scanning and library settings within both scanning
and settings. This is an API inventory, not a parity count.

| Area | Pinned upstream API and behavior | Current port |
| --- | --- | --- |
| Navigation and library UI: 38 files | `ui/library.rs` owns `NavigationHistory`, capped at 100 entries, back/forward/refresh, `ViewSwitchMessage::{Albums,Tracks,Artists,Files,Release,Artist,Playlist}`, scroll restoration and two-column detail. Album/artist/release/playlist/file pages, sidebar, collection summary, track context menus and search have distinct views. | Tracks/Albums/Artists/Playlists and detail routes, bounded back/forward history, shared search/sort, queue and explicit context Play-all/from-here. Files has roots and directory routes. Complete upstream table/context/scroll-restoration behavior remains absent. |
| Scanner/import/availability: 44 files | `ScanInterface` exposes scan/force scan/targeted paths/settings/stop/missing-folder resolution/storage availability. `ScanEvent` distinguishes cleaning, progress, missing-folder decision, playlist updates and watching/idle/targeted completion. Discovery, record/session state, tags, transactional artist/album/track links, watcher reconciliation and platform storage availability are separate stages. | Port-owned persistent library roots, explicit cancellable WAV/FLAC/MP3 metadata indexing and transactional artist/album/track updates on the existing worker. Missing/unreadable trees preserve records; explicit root removal can keep or delete database recordings. Watchers, targeted reconciliation, storage notifications and rename identity matching remain absent. |
| Artwork: 7 directly related files | Hash lookup, migration adoption, processing/thumbnailing, folder-vs-embedded candidates, finalization/cache, managed image ownership and current-art image events. | Schema retained; no image decoding, thumbnail cache or displayed cover art. |
| Settings: 25 files | Persisted scanning/playback/interface/services/update settings; corrupt-file recovery, legacy theme adoption and external-file watching. Playback includes output/replaygain/equalizer controls; UI includes library folders, services, appearance and update options. | Library roots persist in the port-owned SQLite database. General settings persistence/editor and output selector remain absent; the public constructor chooses a provider. |
| Platform media/services: 13 files | `InitPlaybackController`, `PlaybackController` and `ControllerBridge` connect Linux MPRIS, Windows and macOS media controls. Events include metadata/art, duration/position, volume, repeat/shuffle and state. Discord/LastFM/ListenBrainz services are additional consumers. | No OS media bridge, volume/replaygain/equalizer, scrobbling or presence integration. |
| SQL and library models: 16 files | Typed album/artist/playlist/track queries and models, query direction, playlist order and library statistics. | Real track and collection queries, album/artist/playlist browse/detail/context actions, search and queue snapshots. Playlist editing/import and the entire upstream statistics/filter surface remain absent. |
| Media metadata and providers: 11 files | MediaProvider feature lookup, metadata/tag/date/number parsing, Lofty and Symphonia providers, stream decode/seek and channel pipeline. | Real WAV/PCM, FLAC and MP3 decoding plus WAV INFO/FLAC/ID3 metadata inspection. The selected title/artist/album/number/duration fields do not establish complete tag/provider parity. AAC/Opus and other codecs remain absent; service rate/channel/admission limits remain in AUDIO-BUDGET.md. |

The native rehearsal now uses the public `application::window(Database,
OutputProvider)` constructor. Production uses `system_window` with the same
Library, Questions, bounded result lane and audio service. The actual Registry
qualification substitutes only a 64-frame counting output provider; hardware,
latency and complete application parity remain unqualified. Historical DSP
failures and changed-filter regressions remain in PORT-REHEARSAL.md and their
original reports.

## Current application boundary

The routed browser is implemented with one typed Route/Navigation component and
bounded history, the existing pure SQL Question, existing worker and bounded
result lane. Context playback prepares one ordered immutable listing only after
an explicit Play-all/from-here action. Receipt/token, source Version, route,
query and request authority reject stale continuations before queue mutation.
Named preparation remains pure. Sources and nested SourcePath fields serve the
production Window and headless Win tests; no separate test dispatcher is used.

[FILES.md](FILES.md) describes the acquisition successor and its public APIs,
source-publication/metadata invalidation policy, resource costs and limitations.
It adds real folders and metadata discovery to the same worker rather than a
second scanner executor. Native tests use the actual Registry/public actions,
real SQLite/worker/audio owners and a bounded output provider. They do not
establish physical-device, deadline or full upstream parity.

Remaining domains include artwork processing/cache/display, general settings
and output selection, OS media controls/services, filesystem watching/targeted
reconciliation/rename identity, full metadata/codec/provider coverage and richer
library/context/playlist editing. Existing DSP constructor regression, unresolved
old processing controls, rate admission and backend EOF/pause limitations remain
part of the port review; no Files or text result offsets those findings.
