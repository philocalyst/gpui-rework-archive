# Main integration rehearsal

This tree is an isolated review candidate based on main
2d14c15acafa64e776e818252b8c7aead927419c. It does not modify main. Production and
public native fixture source is frozen at b73fa7a340ac6db138fc75455c6e7a8274204a05;
later changes package documentation and evidence only. `provenance.json` records
the import, Stop correction, exact gate pins, lock additions and source scope.
`source-comparison.json` compares every current port source blob with 197fb and
d913. Only application.rs, audio/mod.rs, audio/service.rs, lib.rs and main.rs
differ from197fb. The service is the qualified Stop correction; DSP processing,
geometry and decoding remain unchanged. No gpui/core source changes are present.

The imported delta is the exact inventoried 45-file final197 port, then the
separately qualified Stop24/d913 source/test correction. All port licenses,
declared examples, fixture assets and 37 added lock packages are retained. The
archived qualification directories keep their original pins and limits; they
are not new measurements on main's typed SourcePath implementation.

## Functional gates

All 42 default and 92 CPAL tests pass; the one OS-scheduled clock test stays
ignored. After the native-helper cfg cleanup, all 92 native-feature tests pass
again at b73. Strict all-target CPAL and native Clippy pass. The public headless
SQL transcript prepares44, imports5000, rejects two stale completions, realizes
five list rows and exposes its injected source error. Raw commands/output and
exit files are retained. No new performance or hardware qualification ran.

`native-service-sealed/` records actual public Application/Window and actual
AT-SPI Registry, on private Xvfb/session/runtime. The original Library actions
drive Unicode search, Prepare, Play-now and Stop. Public Worker methods import
and finish the existing SQL service from a harness-only stdin coordinator. The
same public `application::window` constructor builds production and fixture
wiring; no private NativeHost/owner hooks are used.

The real audio owner opens the WAV only after Play-now. The bounded counting
output accepts zero frames without credit, then exactly 64 whole frames with
64 queued. Stop retires its one stream, clears queued frames and revokes the
old output gate. A prequeued public id90/sequence1 request cannot turn pure
Prepare44 into playback; this native case covers an unmatched request, while
the existing public headless regression deterministically covers the same
Pending number collision. Final SQL producer disconnect becomes visible while
quiescent, before another UI input. Preparing after close exposes a typed
worker-closed error. The client sends WM_DELETE_WINDOW, audio.finish succeeds
and the app exits0. Before/after source and binary hashes match. All owned
children exit. The provider counts finite submitted PCM and enforces capacity;
it is neither a device nor an audibility/latency measurement.

`production-native-prepare.json` separately drives the production executable,
system provider attached but unopened: actual X11 typing, Unicode EditableText,
SQL resort/stable row action and pure preparation. Its client terminates the
app after assertions; the sealed service capture supplies the explicit WM-close
proof. The fixed service/client watchdogs are 150/180 seconds with 5 second kill
grace. The preparation client's original 40 second deadline / 65 second outer bound
is retained. No deadline was tuned after an app/scheduling failure.

## Failures and limits kept visible

The first native fixture never opened a window: assigning the same file to 44
and 90 violated SQLite UNIQUE track.location. Its client deadline failure,
source/binary hashes and logs are preserved in native-service-first; the frozen
binary remains at the external path in provenance.json. The correction uses
distinct WAV/FLAC paths and a private runtime directory. Earlier CPAL doctest
and initial strict-Clippy failures exposed private provider/stream visibility
while constructor extraction was in progress; their logs remain. The final
implementation keeps the CPAL provider private and returns it opaquely inside
the native-only wiring helper. No failed gate is counted as passing.

Historical DSP qualification remains incomplete: processing cohorts 15–17/22
are unresolved after the untouched baseline tail panic; changed-filter
constructor cohort24 regresses 1.429 with 95% interval[1.427,1.432]. V2 nearest
smooth geometry remains untimed. The 16384-frame / 100 ms / smooth admission policy
does not cover arbitrary valid rational rates. `historical-audio/` additionally
retains all four raw v1 captures, including the panic and constructor samples,
and earlier rejected smooth-policy/root-unit logs/source. Their original reports
and preregistrations remain in the adjacent qualification directories. Faster
processing, allocation controls and this functional native run do not erase
those limits or support universal no-regression/main-adoption claims.

## Cost and application scope

Syn/Tokei measures shipping core 30987 lines, unchanged from base and excluding
ports. The complete port src is 5358 lines versus 5324 after the Stop correction:
the shared native constructor costs 34 net shipping lines. Qualification example
and Python client are separate source, charged in Git; no total-code deletion
claim is made. The constructor moves the same Library/Questions/inboxes and
two existing services; it adds no retained queue, worker, backend or retry state.
Historical owner/heap/codegen bills retain their original scope and pins.

Current-host normal dependency package counts are 81 default, 108 CPAL and 254
native, including the application and excluding dev/build-only/inactive foreign
packages. `feature-dependency-cost.json` lists additions. The actual first
native test build reported 2m04 while rebuilding this path's local graphics,
text and accessibility dependencies against the existing target cache. Later
builds were incremental. This is work performed, not a controlled cold compile
benchmark or a comparison with upstream. Full app foreign-target and physical
device execution are not established by this rehearsal.

The 273-file pinned upstream source manifest and complete grouped API inventory
are in upstream-api-inventory.json. PORT-NEXT.md proposes a substantial routed
album/artist/playlist browser with contextual listing playback and typed route
state, using the existing SQL worker/result lane. Scanner/watch/import UI,
artwork, settings, complete metadata/codecs and platform media remain gaps.
