# Color-only pointer latency scenario

This is a follow-up to the accepted native-default GPUI 724/current paired
capture. It measures one pointer action whose only visible state change is an
opaque marker color. It is not a generic framework ranking and it has not been
timed. The existing marker fixtures already implement the same user-visible
transition for NanoUI and MyGo; this directory adds a matched GPUI control and
the direct registered style-port candidate.

The two GPUI fixtures use the same `Bench` fields, registered `Signal<Color>`,
source descriptor, strings, layout, row construction and initial/next colors.
The control reads the current color into a literal and handles the button with
a normal model closure, so it takes the full description path. The candidate
binds `.bg(&self.color)` and uses `Source::update` as its button action, so the
registered style sink can take the exact source patch path. Both display the
same 40×40 marker at the same location and toggle exact red/green colors.

For NanoUI and MyGo, the already-pinned fixtures in `../fixtures/` alter only
the marker-color field on the same click. Their immediate-mode view functions
rebuild their descriptions during the next frame; these are framework-native
controls, not framework forks. The meaningful GPUI attribution is the
same-source control versus direct-port pair. Peer cells provide context only.

## Source evidence and limits

The peer pins are JustRach NanoUI `dfa7f7ab4e890f643703f4ffe4d834ff10defd4f`
and MyGo `ea23ad2975a87db9b20efe6690ffedf88f4fe4f3`, matching
[`docs/research-core.md`](../../../docs/research-core.md). The checked-in
NanoUI fixture flips `Bench.on` in `fixtures/nanoui-main.zig`; its Linux
`Surface.frame` calls `frame_mod.run` and queues GTK draw in
`comparators/nanoui/src/linux/surface.zig`, while `onPress` dispatches the
same UI frame synchronously. MyGo's fixture flips only `bench.on` in
`fixtures/mygo-main.go`; pinned `ui/engine.runFrame` performs view build,
layout, paint, and presentation, and `Window.Update` posts `contentChanged`
from `content.go`. These paths explain why the peers are full-frame controls;
they are not evidence that those frameworks lack every retained update API.

The GPUI control uses an ordinary `MethodRoute`; the candidate uses the
owner-qualified `FieldAction` route and a registered direct style destination.
The existing X11 observer remains the endpoint: input is a synchronized
pointer motion plus synthetic button press/release, and completion requires
the exact changed marker pixel after XDamage/readback on a persistent Xvfb
drawable. This reports input-to-X-server-pixel latency, not handler duration,
compositor/vblank/scanout, or photons. Native-default builds keep accessibility
features enabled; record the actual renderer and session-bus AT status. Do not
claim active assistive-technology use solely from a compiled AccessKit/ATK
backend. The current host's GPUI uses bundled Noto Sans while peers use
DejaVu Sans; the subcase is a before/after GPUI attribution, and peer numbers
must retain the previously recorded font, renderer, and overscan caveats.

The virtual 250,000-row cell is deliberately included as a falsification case.
Current reactive-style handling may still cross the list realization boundary
for a paint update in a window containing a virtual list. If counters show an
owner rerun there, report it; do not label that cell as a zero-work patch.

## Planned cells and protocol

Run eager 0, 1,000, and 10,000 rows plus virtual 250,000 rows for the GPUI
control, GPUI direct-port candidate, MyGo, and NanoUI: 16 cells. The GPUI pair
is the within-framework attribution; MyGo and NanoUI provide native full-frame
context. Before any capture, require per-binary SHA-256 guards, exact peer
source pins, exact GPUI source/build manifests, fixture hashes, reviewed
800×600 pixel screenshots, visible title/text checks, the marker's exact
red/green pixels, and row-count preflight for all four workloads, including
eager 10,000. The guard pins the exact NanoUI `build.zig` patch SHA, requires
separate GPUI build manifests from the same source tree and feature set, and
rejects identical control/direct binary hashes. `capture-paint-only.sh`
supports a guard-only pass and validates every cell before creating output or
launching the observer. Captures remain blocked until the integration build
exists and a reviewer has checked all preflight records.

`preflight-paint-only.sh` is the correctness-only driver for the 16 launch
checks. It creates one screenshot and log per variant/workload, emits records
with `status=awaiting-manual-review`, and hashes the artifacts. Review every
image and log before changing those records to `status=pass`; the capture guard
rejects records that still await review and rechecks the evidence manifest
against every screenshot/log before timing. After editing the record statuses,
regenerate the directory's top-level `sha256.txt`; the immutable
`evidence.sha256` continues to cover the reviewed images and logs.

Use 100 fresh starts and 10 click transitions per start, giving 1,000 click
samples per cell; take the existing five 750 ms idle samples only as a small
memory diagnostic. Preserve raw nanoseconds, errors and order. Rotate the four
variants by workload and keep a single XDamage observer connection open across
all child processes. The runner applies native-default profile to every
framework; this means GPUI `Auto`, MyGo's default Linux surface choice, and
NanoUI's GTK/Cairo CPU surface, not renderer equivalence. Keep these backend
differences in the report.

The full run contains 1,600 fresh process launches, 16,000 marker clicks, and
60 seconds of deliberate idle sampling, before application startup, rendering,
and X-server acknowledgement time. Reserve a 15-minute quiet window; a
reasonable planning estimate is 8–12 minutes, based on the previous 0/1K/
virtual run rather than timed eager-10K results. The observer has a 25-second
initial-pixel deadline and a 5-second exact-marker deadline per click. The
shell runner has no separate global timeout: a timeout fails the cell and
leaves a partial raw file, which must remain an incomplete campaign rather
than be merged with a later attempt.

When the GPUI source-port integration lands, build both examples from the
same immutable production source tree and lockfile into separate targets.
Inject each fixture only as the two example files recorded in its build
manifest. The runner rejects any other untracked or changed compiled GPUI
source/configuration. It also checks exact MyGo and NanoUI commits, the only
allowed injected peer example files, and the NanoUI `build.zig` SHA because
that pinned source needs an example-list edit to build the fixture. The MyGo
and NanoUI records must carry `status=pass`, `binary_sha256`, `fixture_sha256`,
`source_commit`; the NanoUI record must also carry `build_config_sha256`
matching the actual `build.zig`. The peer build manifest pins both peer binary
paths and hashes, both source and fixture pins, and the reviewed NanoUI patch
digest, toolchain versions, and build command. The guard also checks the peer
DejaVu font file path and SHA so the runtime font cannot silently change.
The four fixture SHAs are fixed in the runner; changing a benchmark input
requires an explicit reviewed runner update as well as a new binary build.
Each GPUI build manifest carries `source_commit`, `source_tree`, exact
`fixture_path`/`fixture_sha256`, binary path/hash, `profile=release`, the exact
`cargo_features`, `workspace=reactivity/Cargo.toml`, and `locked=true`. Record
the GPUI fixture SHAs, complete source commit/tree, Cargo feature set,
executable SHAs, peer fixture/source SHAs, observer SHA, preflight record,
and selected renderer/session accessibility status. The wrapper supplies
explicit binary paths and enables the existing `run-one.sh` SHA guard; that
guard alone does not force a path. `LUNA_GUARD_ONLY=1` validates all 16 cells
without making an output directory or starting the observer.

Pass the full variable set named at the top of `capture-paint-only.sh` via
the shell environment, including both GPUI build-manifest paths and the peer
build-manifest path. In particular, select `LUNA_GPUI_SOURCE_TREE` as the
`reactivity` subdirectory inside the cleanroom worktree (its Git top level is
the parent), point both GPUI binaries at immutable files, and provide the
reviewed build/preflight record paths. Set `LUNA_DISPLAY` to the private
persistent Xvfb display already covered by pixel preflight, and supply
`LUNA_RUNTIME_BACKEND_STATUS` and `LUNA_SESSION_A11Y_STATUS` from the reviewed
backend/session probes. The script writes
a run manifest with all source, fixture, binary, record, observer, display,
and sampling identities before the first launch, then hashes it with the raw
observer rows.

The full evidence gate is two parts: the external observer proves that the
requested color reaches the window's drawable, while low-sample uninstrumented
runtime counters verify the mechanism (`View`/layout/command counts) in a
separate diagnostic run. Do not put verbose stage logging into the timed
matrix. Preserve startup distribution separately: a paint-only source should
not be assumed to improve cold or first-present startup.

Primary local implementation references (at the pins above):

- NanoUI Linux: `comparators/nanoui/src/linux/surface.zig` (`frame`,
  `requestFrame`, pointer handlers).
- MyGo: `comparators/mygo/ui/runtime.go` (`runFrame`) and
  `comparators/mygo/content.go` (`Update`, `contentChanged`).
- GPUI: the paired version of `crates/gpui/src/runtime/turn.rs` (`FieldAction`
  exact update) and `crates/gpui/src/native.rs` (input-result/redraw path).
- Observer: `benchmarks/nanoui-mygo-gpui/src/main.rs` plus the reviewed
  executable SHA recorded in the run manifest.
