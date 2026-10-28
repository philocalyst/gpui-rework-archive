# Explicit GPU packet replay

Baseline: `112f6cf53d2eb71be9183a557aee40a4c430e0a0`.
Implementation: `fd68c69331`.
Implementation and evidence are separate commits; the source manifest records
the exact production/test bytes. All runs use a separate
`/tmp/gpui-gpu-packet-target`; the baseline layout uses
`/tmp/gpui-gpu-packet-base-target`. This is a correctness and work-removal cut,
with no paired latency measurements or GPU speedup claim.

## Authority and invalidation

`PreparedScene` has public mutable dimensions, clear and color configuration.
Neither its address nor a caller-provided key can certify identity. Public
`Renderer::render` always performs the existing preparation and first discards
the previous packet. Public `Renderer::redraw` has no scene/key argument: it
can only submit the packet that this renderer successfully prepared.

The native `GpuSurface` privately binds a complete untouched owner scene to its
opaque `PresentationToken` (window namespace and checked monotonic sequence).
It uses replay only on exact token equality. A different token clears the
native key before full preparation; successful preparation installs the new
key. An actual diagnostic-mode change clears renderer eligibility, so even a
matching native token falls back to full preparation. A new device/renderer
starts with neither key nor packet. No Canvas/runtime/node/per-draw key was
added and no scene is duplicated.

The packet is one bind group and two dimensions. It refers to the renderer's
current private buffers and atlas. Those resources are changed only during
full preparation, which revokes the packet **before** the first mutation.
Failed image/atlas admission therefore cannot expose partially overwritten
resources through an older eligible packet. Wgpu retains resource leases for
already submitted commands when our old binding is dropped. The queue-order
oracle submits A, replay A, then replacement B to three targets before any
poll or readback.

A wrong-size/format `redraw` target is rejected without modifying the prepared
packet; a correct-target retry is allowed. An attempted unkeyed `render`
invalidates even on an early error. Existing view/device admissibility remains
the caller's contract: wgpu 29's public TextureView API exposes the underlying
texture, not arbitrary view mip/format metadata. This cut preserves the old
render checks and adds no backend inspection.

Every replay still creates/encodes commands, clears, draws the full acquired
target, and submits. It does not acknowledge OS presentation, reuse swap-image
pixels, infer GPU completion, or change native source/presentation authority.
The native code calls the same existing present/ack path afterward.

## Storage and allocation ledger

Actual x86_64 Rust 1.97.1 layouts, independently compiled baseline and candidate:

| Type | Baseline bytes | Candidate bytes | Difference |
| --- | ---: | ---: | ---: |
| Renderer | 824 | 872 | +48 |
| Stats | 168 | 200 | +32 |
| Packet / Option<Packet> | absent | 16 / 16 | +16 inline |
| GpuSurface | 992 | 1,056 | +64 |
| NativeHost<Todos> | 672 | 672 | 0 |
| Canvas | 552 | 552 | 0 |
| PreparedScene | 48 | 48 | 0 |

`PresentationToken` and its Option are both 16 bytes. The +64-byte GpuSurface
cost contains the +48-byte renderer and its own 16-byte native token; these
costs are not additive a second time. GPU state is already behind the existing
cold Box. CPU-only and pre-upgrade Auto do not construct this state. No source,
model, tree, per-draw or Canvas header grows.

Full rendering already created one wgpu bind group per successful prepare.
The cut retains that **one** binding until invalidation/replacement/drop; its
opaque backend/resource-allocation cost is additional residency and is not
included in the Rust-header table. A miss drops it before preparation and
creates a replacement only after admission. Replay creates no bind group and
keeps existing CPU vector capacities, GPU buffer capacity, image cache and atlas.
It adds no scene allocation, snapshot, command clone, resource-key map or
per-draw lease. Wgpu command encoding, queue submission and driver/OS allocation
behavior are not measured or claimed allocation-free.

GPU renderers that never replay still pay the header increase and retain this
last binding. A stream of changing packets takes full preparation each time;
this cut makes no latency or allocation improvement claim for that workload.

## Counters and tests

`Stats` counts CPU validation calls, both CSR draw-bound tile traversals, bind
group creations and upload bytes for the last successful submission. Full
preparation reports one validation per draw, two visits per original tile
reference, and one bind group. Replay reports zero for those fields and image
upload bytes, while incrementing submissions and preserving the packet's draw,
planned sample-work and resource-capacity fields. No counter is a GPU timer.
Image upload diagnostics are reset directly, without scanning image keys.

The recorded 11-draw mixed scene changes from 11 CPU draw validations, 98
binning visits, one bind-group creation, 1,028 geometry/global upload bytes and
725 mask upload bytes to zero for each on replay. Its planned 200,704 GPU
sample/draw evaluations remain unchanged, along with buffer, atlas and CPU
vector capacities. Complete target readbacks match; the GPU is still rendering
the frame. See the `packet_prepare`/`packet_redraw` records in `vulkan.log`.

The actual Vulkan tests compare complete fresh-target readbacks, including
glyphs/images, premultiplied RGBA16Float, P3, public header edits, two canvases,
mode toggles, wrong-target retry, and renderer recreation. A failure fixture
uploads a changed image then exhausts the glyph atlas; old replay eligibility
must be absent and a full old-scene rebuild must restore its pixels.

The native five-policy Todo script exercises actual OS exposure after restoring
the complete native packet, cross-window token namespaces, mode fallback,
failed replacement, editing, unsupported-text repair, resize, suspension/resume
and software-first handoff. It runs on Xvfb `:94` with Mesa llvmpipe Vulkan;
this is not evidence of hardware latency or native Apple/Windows behavior.

The raw gate logs, source hashes, layout CSV and extracted release callee are
stored alongside this report. Commands use `/tmp/gpui-native-env.sh`, override
`DISPLAY=:94`, set the separate target directories above, and run:

```sh
cargo test --locked -p gpui_gpu --features vulkan-tests --test render -- --nocapture
cargo test --locked -p gpui
cargo test --locked -p gpui --features x11 --lib \
  native_todo_port_presents_edits_pointer_actions_resize_and_inspection \
  -- --ignored --nocapture --test-threads=1
cargo clippy --locked -p gpui --features x11,wayland --all-targets -- -D warnings
cargo clippy --locked -p gpui_gpu --features vulkan-tests --all-targets -- -D warnings
```

The known pinned Parley deprecation warning is a dependency warning; both strict
first-party Clippy invocations pass. No paired timing campaign was performed.

Final results: 29 actual Vulkan tests, seven portable GPU unit tests, 245 GPUI
runtime/integration cases plus 19 doctests, the actual five-policy native Todo
fixture, and both strict Clippy commands pass. The independent read-only review
found no blocker and requested the added queued A/A/B oracle. Apple/Windows
runtime behavior and combined-main integration gates remain the parent's
separate validation work.

## Release callee inspection

The ordinary non-test release library is built with
`cargo rustc --locked --release -p gpui_gpu --lib -- --emit=asm`.
`redraw.s` is the emitted complete callee (274 bytes of machine code); its sole
call is to the shared `submit` helper (764 bytes). The replay body performs
constant-size eligibility/target checks, counter stores and an optional image
counter store. It contains no scene-dependent loop, key walk, admission,
buffer write or binding creation. `submit.s` still encodes the render pass and
calls wgpu submission; those backend calls and cleanup paths remain real work.

`callee-sizes.txt` records the actual archive symbols, including the full
7,626-byte `render` callee. The complete assembly hash and source SHA-256 values
are in `manifest.json`; artifact hashes identify the test and release binaries.
No baseline optimized library or whole-application binary comparison was built,
so these are candidate code sizes, not a binary-size or instruction-latency win.
