# Shared immutable GPU ownership

Base `d6203e6ac4`; final source `1b200d66cfc28a76e4c61b3d154a26055ae908a0`.
Shipping GPU source last changed in `72b8c1c3ce`. This is an offscreen sharing
seam, not native multiwindow support or a first-window shader optimization.

The source chain is:

- `7f83fbc110`: freeze the existing public owned-renderer fixture and lock.
- `f8e90a1b10`: extract fixed-format context/state, retain the ordinary owned API,
  check context identity before mutation, and scope inferred-layout validation.
- `8cdeee1abe`: reserve the shared window Vec before pipeline construction,
  matching the control's allocation order.
- `72b8c1c3ce`: reject unsupported formats before requesting a device, return
  ResourceLimit on identity exhaustion, document/probe the live-context boundary.
- `1b200d66cf`: also drop state leases after the last explicit device owner.

## Ownership and work

`GpuContext` owns one device, queue, format, checked WGSL pipeline and inferred
layout. The pipeline already retains shader metadata, so no extra shader handle
is stored. Each `RendererState` owns its buffers, atlas, images, scratch and
packet. Methods borrow the context explicitly. There is no context allocation,
pipeline map, context generic, self-reference, shared mutable cell, new per-draw
Arc clone, or process GPU cache. Different formats require separate contexts;
they still rebuild their shader/pipeline even on the same device.

Ordinary `Renderer` owns these two values and forwards to the same implementation.
The optional `PaintRenderer` still owns a Renderer and its existing positional
map; shared states expose the canonical bank-slot path. The public convenience
API and native admission order remain intact. No vendor/manifest/production-lock
changes are part of this slice.

The stronger control already shares one actual device/queue across N existing
Renderer::new calls. It constructs N GPUI modules, pipelines and inferred-layout
queries. Shared construction uses one of each and N sets of mutable resources.
The additional per-device control uses N ordinary Renderer::request calls.
Its GPUI device label differs from the default-descriptor same-device controls.
All reported successful GPUI constructor calls are explicit in the pinned source.

Separate `counts` builds observe N native render pipelines versus one, and N+2
native shader modules versus three on the same device. The two compute pipelines
belong to WGPU's device machinery. Live counters are not historical constructor
events. The upstream texture counter becomes negative in this path; raw values
are preserved and are not used for exact residency or total object claims.

## Charged storage and allocations

Linux x86-64 Rust layouts:

| Object | Before | Final |
| --- | ---: | ---: |
| Owned Renderer |872 B |896 B |
| GpuContext |— |56 B |
| RendererState |— |840 B |
| PaintRenderer |896 B |920 B |
| Slot guard |40 B |48 B |
| Paint guard |48 B |48 B |
| Native candidate box payload |984 B |1008 B |

There are two 8-byte identities in the ordinary owner, plus an 8-byte layout
difference. Shared ownership stores one context identity and one identity per
state. The generator also adds **8 bytes of process static data**, separately
from every owner/heap figure below. It stores no GPU resource. The native
candidate remains one existing allocation; its actual requested payload is
1008 bytes. The active GpuSurface's existing boxed payload also grows by 24 bytes.
No NativeHost field is added.

The complete offscreen owner includes its context/header, window Vec allocation,
all per-window state, output texture/view, warmed buffers/atlas/images/packet,
and device construction. Canvas/font/input scenes and instance/adapter discovery
are outside that GPU-owner scope in both controls. Window headers are already in
the Vec allocation; the outer owner header is charged once separately.

| Windows | Old same-device requests | Shared requests | Old net heap + owner | Shared net heap + owner | Old peak heap + owner | Shared peak heap + owner |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
|1 |9,763 |9,763 |462,262 B |462,286 B |822,096 B |822,120 B |
|2 |17,850 |10,030 |838,351 B |475,297 B |1,193,723 B |823,128 B |
|8 |66,315 |11,571 |3,081,493 B |539,735 B |3,415,593 B |829,176 B |

Add the new 8-byte static once per final process. Thus the first owner costs
24 more bytes, plus that static; it saves no allocator requests or shader/device
construction. Final ordinary owned renderers retain the old request counts and
cost 24 more bytes each. Full same-device/per-device/ordinary/shared data is in
`summary-table.md` and `summary.json`.

These are current-thread Rust allocator requests/net accounting, not RSS,
driver-C allocations, background-thread allocations, or GPU residency. Cold and
warm scopes are sequential; combined peak is max(cold_peak,
cold_retained+warm_peak). It includes the fixed owner header, not complete
temporary stack peak. Background destruction can cross the accounting boundary;
the later drop record includes unmeasured readback releases and is not a balanced
leak detector. Instrumented `counts` allocation values are kept separate from
the default-feature comparison. No CPU/GPU timing claim is made.

Release ASM shows that the owned render/redraw forwards inline into the caller.
The hot rendering body grows 9265→9317 bytes and reserves 0x558→0x568 stack bytes;
redraw grows 292→314 bytes. Identity comparison precedes packet mutation. Full
entries and compressed bodies are retained. This qualifies the emitted wrapper
path and charges its 16-byte frame growth; it is not a speed claim.

## Correctness and limits

- GPU: 9 unit tests, 4 presentation tests, 43 Vulkan tests pass (40 existing and 3
  new sharing/admission/lifecycle tests).
- GPUI: 449 pass, 25 ignored across all targets on this isolated base. These are
  not counts for the later main integration.
- Strict GPUI+GPU and standalone-fixture all-target Clippy pass; targeted format
  checks pass. Apple AArch64 and Windows MSVC GPUI desktop+parallel all-target
  build-std checks pass.
- Both existing real X11 programs pass: eight admission/close/drop cases, then
  the five renderer-policy edit/resize/stale/cancel/handoff cases. The script
  owns display 131/private buses/runtime directory and retires them afterward.
- All 1/2/8 GPU/CPU readbacks and retained redraws pass. Exact pixel hashes match
  every owned/shared/per-device control. Targets have distinct sizes, image
  identities/pixels, glyph masks and packets. Slot edits and replacement/drop
  of one state leave the survivor's output/cache intact.
- Different context identity, including same-device/same-format inferred
  layouts and another device, rejects before uploads, record edits or packet
  revocation. Wrong target format rejects before writes. An actual isolated
  unsupported-format request leaves all WGPU registries unchanged: devices,
  kept and released counts remain 0.
- Actual Device::destroy+poll invokes Destroyed. New-context construction on
  that destroyed device returns an error through the existing validation scope.
  Old states reject a replacement context; identity exhaustion cannot wrap.
  Context-first and last-explicit-device-owner-first drop cases pass.

**A matching context identity is not device-health proof.** The separate actual
loss probe records that State::new after destruction returns invalid handles on
this backend; rendering then panics through WGPU validation at Queue::write_buffer
for the invalid globals buffer. State construction requires a live context.
The caller retains its existing device-loss callback and must retire the context
and all states on loss. No extra callback, global scope or persistent loss flag
was installed. Native retains its existing worker panic containment and fault
handling; these tests do not qualify physical GPU reset/driver-loss recovery.

A raw target view must belong to the supplied context's device and satisfy the
existing WGPU render-target preconditions. WGPU's public view API does not expose
device identity; foreign views can still cause checked validation panics. This
inherited safe-Rust API boundary was not replaced with a broad core fork or a new
target wrapper. No runtime Apple/Windows presentation, Wayland, hardware GPU,
unsafe passthrough, artifact, pipeline-cache or damage-repair claim is made.

## Source and reproduction

`source-lines.json` uses the recorded Syn test-span helper and Tokei 15. GPU/src
non-test comment-free code grows 2284→2427 (**+143**); physical source grows
2686→2878 (+192), known test lines209→229, and non-test physical source
2477→2649 (+172). All forwards and helpers are included. The added standalone
first-party fixture separately contains 401 physical Rust lines/380 code lines,
its 23-line manifest and 1798-line lock. Public Vulkan tests grow 239 physical lines;
the 20 added inline-test lines are excluded from the shipping numerator. Evidence
scripts/data/docs are additional archival work, not a shipping line reduction.

`checks.json`, `inputs.sha256`, binary hashes, source analyses and `SHA256SUMS`
record the actual inputs/results. Raw logs and entry disassembly with trailing
whitespace are gzip-compressed losslessly, without normalizing their bytes. Source is clean apart from the untracked
evidence at capture. Commands use Rust 1.97.1 and two build jobs, offline/locked.
Run the checked-in capture scripts from reactivity/ after checking out the pinned
source; the Nix/native paths and preserved binaries are specific to this host.
Rebuild the baseline fixture at 7f83fbc110 in an isolated checkout for its controls.
`summarize.py` validates every default pixel hash before emitting the table.
`capture-asm.py` uses preserved default release binaries, not instrumented builds.

`f8e90a1b10/` retains its actual predecessor captures and Apple/Clippy checks.
`controls/context-before-window-vector/` preserves the earlier reservation-order
confound; its lower cold peak is not used for a first-window claim. Other controls
preserve the uncommitted extraction draft's missing-poll callback timeout,
destroyed-pipeline layout lookup outside scope, and transparent SDR clear fixture
failure. The prototype state-loss probes are preserved without relabelling them
as final source; `final/lost-state.txt` is the final pinned public probe.
