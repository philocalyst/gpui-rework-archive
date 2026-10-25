# Native presenter ownership patches

Complete published source archives are retained, with these bounded local changes.
The source archives and all upstream licenses are present; this is a source fork,
not fewer dependencies or fewer lines of code. The root workspace uses explicit
`[patch.crates-io]` entries and excludes both vendor packages from membership.

| Package | Upstream commit | Published .crate SHA256 |
|---|---|---|
| softbuffer 0.4.8 | d871852faa1137d4615b99b9ad31c3ba80f345b5 | aac18da81ebbf05109ab275b157c22a653bb3c12cf884450179942f81bcbf6c3 |
| wgpu-hal 29.0.4 | e99f5305ded96ff7006f0714d043a7f735bd45c2 | 97ace1c17727311c22a46e4e3faf56ea6de81af99dcc839bdfb54857b94d448d |

Archives: [softbuffer](https://static.crates.io/crates/softbuffer/softbuffer-0.4.8.crate),
[wgpu-hal](https://static.crates.io/crates/wgpu-hal/wgpu-hal-29.0.4.crate).

## The actual ownership defect

Softbuffer's AppKit backend appends a CALayer under the NSView's root layer. Its
original CGImpl destructor only unregisters KVO. wgpu-hal creates a
raw-window-metal sublayer and transfers its retained CAMetalLayer into Surface;
Surface originally has no layer detach operation. The superlayer independently
retains both injected layers, so merely dropping the Rust retain does not remove
them. raw-window-metal's ObserverLayer destructor cannot break that retention:
it executes only when the retained Objective-C object is actually deallocated.
An abandoned Metal layer can remain above the working CPU layer; repeated CPU
surface creation also leaves old contents/image payloads attached.

Pinned source: [softbuffer CG](https://docs.rs/crate/softbuffer/0.4.8/source/src/backends/cg.rs),
[Metal surface](https://docs.rs/crate/wgpu-hal/29.0.4/source/src/metal/surface.rs),
[Metal creation](https://docs.rs/crate/wgpu-hal/29.0.4/source/src/metal/mod.rs),
[raw-window-metal observer](https://docs.rs/crate/raw-window-metal/1.1.0/source/src/observer.rs).
Apple's [addSublayer](https://developer.apple.com/documentation/quartzcore/calayer/addsublayer(_:))
and [removeFromSuperlayer](https://developer.apple.com/documentation/quartzcore/calayer/removefromsuperlayer())
are the matching ownership/hierarchy operations.

## Local changes and thread contract

* softbuffer CGImpl::Drop unregisters KVO, disables implicit animations in a
  transaction, and removes **its own newly allocated layer**. Surface is Send;
  construction requires the main thread but off-thread destruction is allowed.
  A complete retained layer/root/observer cohort is cleaned on main immediately
  or transferred to the main dispatch queue. No caller-owned sibling or NSView
  root layer is removed.
* wgpu-hal records an extra retained `raw_window_metal::Layer` lease only when
  `pre_existing()` is false. Surface::Drop detaches that owned injected layer.
  It does not detach layers passed by callers or pre-existing CAMetalLayer roots.
* HAL Surface is Send+Sync. Main-thread drop detaches immediately; off-thread
  drop transfers the retained, upstream-Send Layer lease to dispatch2's main
  queue and returns without joining/waiting. The lease keeps the Objective-C
  layer and its KVO object alive until main-thread removal. If a process exits
  without ever servicing its main queue, deferred cleanup has not run; no UI
  thread wait or cross-thread AppKit mutation is introduced.
* dispatch2 is pinned at 0.3.1, Apple only (HAL uses it only with Metal). It already exists in the native
  dependency graph. No new unsafe block enters the safe GPUI/GPU application API;
  the one local HAL pointer conversion is documented against the retained Layer.
* Native Auto compiles a BGRA8-sRGB renderer on its owned worker **before creating
  any native surface**. Only the final Redraw admission creates/verifies that
  surface and immediately attempts the latest complete canonical scene. A
  different required surface format leaves Auto on CPU; explicit GPU keeps its
  negotiated format path. Failure/cancellation drops the owned layer lease;
  no CAMetalLayer is installed during a long pending pipeline build.

These patches correct known layer ownership and pending-initialization ordering.
They do not constitute an actual macOS compositor/screenshot or hardware-startup
proof. The visible handoff still requires native AppKit validation.

## Checks

`reactivity/tools/check_apple_presenters.sh` is a macOS-only gate. It typechecks
native GPUI and runs two custom `harness=false` binaries on the process main
thread. The workspace-only `gpui_presenter_tests` package runs the vendor test sources
with the root lock, avoiding unrelated archived vendor dev-dependency graphs.
The tests cover 20 creation/presentation/drop cycles without accumulating
layers, KVO deregistration, caller-owned sibling/external Metal layer preservation,
and worker-thread HAL/CG Surface destruction without waiting on the main queue.
The worker-drop case then pumps the main CFRunLoop and checks deferred detachment.
The GitHub macOS job invokes this gate; running it elsewhere fails explicitly.
Cross-checking from Linux can typecheck the same Apple code using Rust std sources
and `RUSTC_BOOTSTRAP=1 cargo check -Zbuild-std=std,panic_abort --target aarch64-apple-darwin`.
That is compilation evidence, not execution evidence for the layer-count tests.

Wayland remains a separate platform test gate. Softbuffer commits XRGB shm buffers
on the existing wl_surface; dropping its mapping/file handle does not itself
reuse or mutate backing storage. The protocol permits destroying an unreleased
buffer if storage is not reused; this audit found no confirmed backing-storage
violation in that path. CPU/Vulkan queue/attachment transition and actual visible
recovery still need a native compositor test. See the
[Wayland attach/release contract](https://wayland.freedesktop.org/docs/html/apa.html#protocol-spec-wl_surface).
