# Integrated audio and source authority

Root independently applied the complete `9145411365adfe850b58cb6dafcfb64d1cc73221`
audio/queue package and then the narrow source-authority successor
`9f83f23288bbb364142ff2a82d059b6d99670a7e`. The latter changes exactly six
application/test paths, all independently compared with their frozen Git blobs.
It imports no Browser work and changes no UI library. The original package
verification and earlier 914 checks remain separately pinned in
[`../main-eos-integration`](../main-eos-integration).

## Completed checks

`commands.json`, individual logs/exits and `test-summary.json` record:

- Default all-target tests: 50 passed across 14 harnesses.
- Native-feature all-target tests: 116 passed across 16 harnesses, one ignored.
- Default and native all-target Clippy with `-D warnings`: both pass.
- Formatting and the native-service example build: both pass.

All 2,160 recorded source/config/vendor inputs match before tests, after tests
and after the native client. The frozen native executable is 466,935,944 debug
bytes with SHA-256
`10a3a3b9562d327a7aa9833267270c3e2347f772ec013b84f1e8e465253a6494`;
that is an artifact identity, not an application-size performance result.
The original 914 executable remains separately frozen and was not overwritten.

The unchanged external `native-service.py` client passes against this executable.
It uses an ordinary public Window, a private Xvfb/DBus/Registry session, real
SQLite and the production decoder/service with a counting output. Its actions
import a row, search Greek text, leave pure preparation and an unmatched
Selection collision inert, explicitly Play once, accept exactly 64 real PCM
frames, Stop, disconnect the worker and close through WM_DELETE_WINDOW. Normal
application shutdown and all owned client/display processes complete. The
client's source and binary guards match. Existing client deadlines are unchanged.
`native-service/result.json`, events and logs retain the actual observations.
No device playback, audible completion, GPU timing, RSS or foreign-OS runtime
result is established by this capture.

The ordinary application binary is independently built and frozen. Its original
headless transcript and unchanged external Registry/X11 client pass under CPU,
forced Vulkan and Auto policies. These exercise the original missing-file and
absent-ALSA-device failure paths as well as input, SQL sorting, search and row
actions. All 1,491 recorded inputs and the frozen binary match across the three
captures; each owned display is stopped before reuse. `original-clients/` retains
the commands, exact submitted-renderer observations, logs and binary identity.
The Vulkan adapter is llvmpipe. These are functional checks, with no startup,
frame-time, hardware or memory-performance inference.

## Authority and scope

A queued Prepared reply previously remained actionable after the worker had
replaced its database but before the UI consumed Replaced. The source successor
checks the worker's published generation across queue adoption, holding Source
authority before Audio authority. Existing track leases survive same-source
imports; full-version guards are available for operations depending on the exact
query cohort. There is no second pending Version mirror. The worker holds a
Weak producer between commands, preserving final-handle disconnection, and
publishes the already-reserved terminal generation before disconnect delivery.
Source construction/replacement rejects caller-active SQLite transactions;
fixture imports commit their transaction before publishing a version. External
database writers/watchers are not covered. A callback must not re-enter its own
source guard, and queue work under that lock has no hard latency bound.

The identical four-cohort public constructor probe charges the authority fix:
one additional live spawn allocation, 64 additional requested spawn bytes,
unchanged connected-stage allocation, and eight fewer mounted-stage bytes.
Win's inline size falls 664 to 656 bytes. Library and Questions each also lose
eight inline bytes but overlap the containing owner and must not be added again.
Retained measured heap plus Win therefore grows **48 bytes per cohort**; total
requested bytes grow 56. Producer's Arc allocation requests 56 bytes. The source
guard itself requests no allocation. These are requested-byte controls, not RSS,
native-window memory or a net memory improvement.

The package also fixes the earlier full-Selection collision, Stop/control-token
and queued-EOF authority defects. Unsupported natural resampler geometry is
rejected before abandoning valid output tails. Decoder, output and queue remain
application owners connected through the public GPUI interfaces; there is no
private UI test dispatcher or entity compatibility layer.

This is a Library/queue/audio vertical slice, with 5,633 nontest, noncomment
application source lines including the binary and all feature branches. The six
shipping UI libraries remain 30,987 lines including their 18 build lines. Apps,
vendors, examples, tests and evidence are excluded from that library bill.
The original DSP 1.429 constructor ratio and four baseline tail failures remain
adverse history. The later untimed constructor formulation, bounded rate-family
admission, CPAL pause/fade limitations, UI-mediated EOF progression, OS/device
drain and retained silent output are documented in AUDIO-BUDGET.md/AUDIO.md.
No complete Hummingbird/Zed port or universal audio-format support is claimed.
