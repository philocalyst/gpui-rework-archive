# Portable presentation admission

Final source: `665c0a467c`, based on `ff49d8482e`. Source and evidence commits
are separate. `checks.json` records full commits, source/lock/config hashes,
compiler versions, commands and preserved native executable hashes.

Automatic X11 presentation now proves the actual surface/adapter and intended
BGRA8/sRGB/opaque/FIFO configuration before requesting a device or compiling the
renderer. Missing cheap device hints return before creating a worker, channel or
cancellation allocation. A CPU-only adapter is discovered through an instance
and adapter probe, then rejected before renderer construction; it is not a
zero-instance path.

HAL owns backend masks, Linux device hints, Win32 software-recovery exclusion and
target preparation order. WGPU supplies a safe handle query and an owned
Surface/Adapter proof helper. GPUI consumes that capability and retains frame
admission: the CPU presenter remains authoritative until the current canonical
frame has actually presented through the candidate. Queue/present acknowledgement,
renderer code and the existing Metal injected-layer repair are unchanged.

## Final checks

- Strict GPUI+GPU all-target Clippy and formatting pass.
- `gpui.log.gz`: 449 tests pass, 25 ignored, on this integration base. Later
  main-branch totals are a different snapshot. The cohort test is included here.
- `vendor.log.gz`: four public API tests cover target preparation classes,
  same-HWND recovery rejection, unsupported capabilities and an HDR-only
  format/color-space pair absent from the automatic SDR-format list.
- `vulkan.log.gz`: all 40 existing Vulkan CPU/GPU oracle tests pass.
- `native.log.gz`: two real native test programs pass under private Xvfb and
  CPU Vulkan. One exercises eight admission/lifecycle cases; the other retains
  the existing five renderer-policy Todo edit/resize/stale/cancel/handoff cases.
- Apple AArch64, Windows MSVC and Linux Wayland all-target compile checks pass.
  Apple/MSVC use the existing build-std check command; their earlier benign
  X11-observer warning is fixed in the final source.

The native admission cases are missing device hint, CPU adapter, unsupported
format/color-space/alpha/present mode, pending CloseRequested, and direct host
Drop. Rejections observe that Renderer::request never starts. Positive target
proof uses the actual configured FIFO mode. Its negative mode control injects
AutoVsync, which is not an advertised concrete mode; alpha similarly injects
Auto, and the color-space control requests unadvertised DisplayP3. The separate
public-capability fixture also rejects a concrete FIFO request against
Mailbox-only capabilities.

The close controls retain an actual proved, unconfigured Vulkan surface and
its safe Arc window lease behind a worker gate. They invoke the normal close
handler or directly drop the initialized host without dispatching Exiting to
it. The UI retires model/action authority, an independent X11 query observes
the retained target UNMAPPED, and releasing the gate drops the final lease
without constructing a renderer. The held worker proves there was no UI join.
These controls do not inject a truly hung driver call.

`run-native.sh` owns display 128, starts/stops its Xvfb, and uses fresh private
D-Bus sessions. Run from `reactivity/`; the recorded Nix tool/environment paths
are specific to this capture. The tests use normal native host lifecycle
callbacks and actual presentation/server queries; they are not an external
keyboard/AT-SPI transcript. No timing/performance claim is made from raw elapsed
build/test lines or scheduler-dependent submission counts.

## Charged ownership costs

Linux debug test-configuration measurements are in `cohort.log.gz`. The old
message/Upgrade/channel layouts reconstruct the exact prior field types.
Requested allocations are narrow scopes, not process memory measurements.

| Component | Previous | Final |
| --- | ---: | ---: |
| Message header |32 B |24 B |
| Upgrade header, including test gate |56 B |40 B |
| Bounded result channel |2 allocations,680 B |2 allocations,672 B |
| Renderer/candidate box payload |872 B Renderer layout |984 B actual Candidate allocation |
| Cancellation lease |none |1 allocation,24 B |

The existing renderer box becomes one Box<Candidate>; no second renderer box,
separate Box<Surface>, or extra channel is added. The unused JoinHandle detaches
immediately instead of occupying the host cohort. The isolated active
queue+box+flag ledger calculates 128 additional requested bytes after renderer
readiness, alongside a 16-byte smaller Upgrade header. This excludes thread
bookkeeping, stacks, allocator overhead, WGPU/native surface and retained-window
resources, driver allocations and whole-process peak/RSS. It is not a
memory-neutrality claim. The larger Candidate value also carries 112 more bytes
than Renderer during moves; no stack/copy performance claim is inferred.

## Platform and provenance limits

Only Xlib/Xcb targets permit early worker-owned surface preparation here. Winit
initializes XInitThreads and flushes XUnmapWindow when hiding; WGPU's safe Surface
retains its owned producer until backend cleanup. Cancellation cannot interrupt
a blocked driver call. The owner hides/retires immediately, including implicit
Drop/early failure, while that safe lease can outlive it until the call returns.

Metal preserves window-free/headless renderer preparation followed by late
event-thread surface attachment. Its actual target proof remains after pipeline
work. Wayland also retains the window-free late path because Winit set_visible
is a no-op there. A future early Wayland proof needs a legal null-buffer
unmap/reconfigure lifecycle, including role/configure/CPU-recovery tests; raw
proxy destruction or a hidden flag would not establish it. Windows Auto retains
CPU presentation because the current same-HWND DX12 flip path cannot restore
GDI. Explicit GPU policy remains available.

These runs do not qualify real hardware Auto admission, macOS/Windows runtime
presentation, the AppKit layer harness or Wayland runtime unmapping. They use
Mesa CPU Vulkan only through the existing test-only override.

`c5ed918668` imports the complete published WGPU 30.0.1 archive with SHA-256 and
licenses. All 191 original file hashes were verified at that commit. The sole
modified original WGPU file is src/lib.rs, adding the new module; authored APIs,
policy and consumer changes are recorded separately. The published README's
Markdown trailing spaces are deliberately retained. This vendor import and
policy relocation are not line-count reductions.

`controls/` retains the unfrozen 120-byte message draft, its failed button-lookup
test, the initial wrong Linux feature invocation and the attempt to test a
nonmember dependency package. Those drafts are not byte-exact final source pins.
The 76f6 Apple/MSVC warning logs retain their actual historical pin. No losing
control has been relabelled as the final source.
