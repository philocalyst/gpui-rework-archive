# Portable presenter boundary: keep CPU-floor gating and move platform leases inward

## Recommendation

Put automatic GPU admission behind a two-stage API owned by the renderer/platform boundary. Stage one must be a documented *cheap eligibility hint* that is allowed to return `Unavailable`, `Maybe`, or `Unknown` without constructing a WGPU instance, adapter, device, surface, or pipeline. In `Auto`, only `Maybe` starts asynchronous backend initialization; `Unavailable` and `Unknown` keep the existing CPU presenter. Stage two runs after the CPU presenter has produced a frame and the real window is available: create a target-bound surface, request an adapter compatible with that surface, validate format/alpha/present capabilities, then create the device and renderer. Do not configure/present until the CPU lane remains authoritative. `Unknown` is an honest result, not a hidden “try WGPU anyway.” Explicit GPU policy can force the expensive path.

This keeps useful automatic upgrades on platforms with a defensible cheap hint while preserving the zero-GPU floor. The existing Linux hint (`/dev/nvidiactl`, `/dev/dxg`, `/dev/dri/renderD*`) at [`crates/gpui/src/native/upgrade.rs`](../crates/gpui/src/native/upgrade.rs) is a useful first implementation but is only a hint: its source comment already identifies remote/custom ICDs it misses. Retain an opt-in or explicit-GPU path for those. Windows must preserve the current same-HWND software-recovery restriction. macOS already admits a background probe after the first CPU frame; preserve its delayed native layer creation. A future cheap hardware hint needs measurement before changing either default; OS discovery APIs are not assumed cheap.

## Concrete vendor API shape

Keep the OS details out of application code by adding a backend-owned protocol, for example:

```rust
enum AutoEligibility {
    Unavailable { reason: NoCandidate },
    Maybe { backends: BackendMask, fallback: FallbackClass },
    Unknown { reason: ProbeUnavailable },
}

enum FallbackClass {
    CpuPresenterRetained,
    CpuPresenterRestorable,
    CpuPresenterNotRestorable,
}

trait AutoPresenterProbe {
    // Must not instantiate WGPU, create a device/surface, or mutate the native target.
    fn cheap_eligibility(&self, target: TargetClass) -> AutoEligibility;
    // Called only after an eligible hint and a CPU-presented frame.
    async fn prove_target(&self, window: WindowLease) -> Result<SurfaceProof, ProbeError>;
}
```

`SurfaceProof` should describe target-compatible adapter(s), supported surface formats and alpha modes, and whether the selected present path leaves a tested CPU recovery path. Treat it as an expiring lease tied to a window/display generation, not a persistent boolean. A resize, display migration, window recreation, device removal, or failed configure invalidates the proof. WGPU's target compatibility request is essential: the current upgrade worker asks for `compatible_surface: None`, then creates a surface later on the event thread. A headless adapter can therefore pass early discovery but fail on the actual window. Target proof belongs inside the vendor boundary and must run before expensive device/pipeline creation where possible.

The app should see one portable decision and lifecycle (`hint → prove target → prepare renderer → first successful present → commit`), not native handle probes, Objective-C layer cleanup, DXGI/GDI rules, or display-specific conditions. A renderer capability result should be descriptive and testable; it must not be inferred from “adapter exists.” Keep explicit GPU mode available even when automatic eligibility is `Unknown`.

## Why the split is required by this tree

- [`native/upgrade.rs`](../crates/gpui/src/native/upgrade.rs) currently has a policy gate, but the admitted worker initializes WGPU and requests an adapter without a surface. It filters `DeviceType::Cpu` before requesting a device, which is the right software-renderer safeguard, but adapter enumeration still has to be gated before it starts.
- [`native.rs`](../crates/gpui/src/native.rs) already starts on the CPU presenter in `Auto`, waits for a CPU frame, prepares the GPU candidate, and transfers authority only after the candidate's first present. Preserve those frame/state handoff semantics. The gap is where platform policy/probing lives and that the worker's adapter proof is not target-bound.
- WGPU/HAL configure is a real ownership transition. HAL's unsafe configure contract requires no in-flight GPU work, no live acquired textures/views, and no surface configured on another device; acquire allows only one outstanding texture, which must be presented or discarded. Those requirements justify a single vendor-owned presenter state machine rather than application callbacks around swaps ([vendored HAL contract](/root/gpui-ce3/reactivity/vendor/wgpu-hal/src/lib.rs:657)).
- WGPU surface targets may retain their native window owner, while raw-handle creation requires caller-managed lifetimes. Keep the `WindowLease`/surface owner together and make cancellation/window-close invalidate it ([WGPU surface API](https://docs.rs/wgpu/30.0.1/src/wgpu/api/surface.rs.html)).

## Platform-specific constraints and bounded claims

**Linux:** Keep the existing render-node/device-file check as one cheap backend hint. It must be overrideable for remote/custom ICD deployments and must not be promoted to a proof of a compatible display surface. Do target-compatible adapter discovery only after the hint. If the hint sees only CPU Vulkan/lavapipe, stop before device or pipeline creation. A missing node should be `Unavailable` under default Auto policy; an explicit opt-in can try `Unknown` systems. Measure CPU/RSS on cold blank-window starts to ensure `Instance::new` and driver scans did not move earlier.

**Windows:** The current DX12 HAL creates `CreateSwapChainForHwnd` only in `Surface::configure`, and configures `DXGI_SWAP_EFFECT_FLIP_DISCARD`; creating the WGPU surface itself is not yet that swapchain commit ([vendored DX12 configure](/root/gpui-ce3/reactivity/vendor/wgpu-hal/src/dx12/mod.rs:1472)). However, Microsoft's `DXGI_SWAP_EFFECT` documentation explicitly says that after the first successful `Present1` of a flip-model swapchain, GDI no longer works with its HWND even after swapchain destruction ([Microsoft DXGI_SWAP_EFFECT](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ne-dxgi-dxgi_swap_effect)). Therefore a design that configures/presents flip on the same HWND cannot promise recovery to the current Softbuffer/GDI presenter. This is stronger than a conservative code comment: Windows Auto must not commit a same-HWND flip path if automatic GDI fallback is a product requirement.

Do not substitute “render to an offscreen DXGI texture, then copy to the HWND” as a free fix: admission still initializes a device/pipeline and must have a presentation bridge; device removal can still leave the HWND without a presenter. A separate composition visual/child target might isolate leases, but only pursue it if the windowing API can preserve clipping, hit-testing, z-order, DPI, accessibility, resize, and destruction semantics and has a proven GDI fallback. Otherwise keep `Auto` on CPU for that target and let explicit GPU mode accept the nonrecoverable choice. This report does not claim all Windows GPU paths are inherently irreversible; the documented irreversible clause specifically concerns GDI on an HWND after successful flip-model `Present1`.

**macOS:** The vendored Metal surface creation can inject a `CAMetalLayer`; this fork records whether the layer pre-existed and only owns/detaches injected layers, dispatching cleanup to main when needed ([Metal layer lease](/root/gpui-ce3/reactivity/vendor/wgpu-hal/src/metal/mod.rs:160), [drop cleanup](/root/gpui-ce3/reactivity/vendor/wgpu-hal/src/metal/surface.rs:210)). Softbuffer similarly owns an AppKit layer/KVO cohort and removes only its own sublayer on the main queue ([Softbuffer cleanup](/root/gpui-ce3/reactivity/vendor/softbuffer/src/backends/cg.rs:115)). This is precisely the kind of lease logic the portable presenter must absorb; do not let app code keep duplicate cleanup flags.

`CAMetalLayer.nextDrawable()` can wait; Apple documents a one-second timeout when enabled, otherwise it may wait indefinitely. Apple also warns that retained drawables exhaust the pool. HAL already maps an invisible/occluded macOS surface to timeout to avoid blocking (`vendor/wgpu-hal/src/lib.rs` acquire contract; [Apple CAMetalLayer](https://developer.apple.com/documentation/quartzcore/cametallayer/allowsnextdrawabletimeout)). Keep drawable acquisition late, release promptly, suspend retry loops while occluded, and make layer leases cancellation-safe. Do not assume `MTLCopyAllDevices` is a cheap preflight. Preserve the existing macOS background-probe policy and CPU authority while evaluating any replacement; this report does not establish a zero-driver-cost macOS hint.

**Old/software-only systems:** The CPU path remains the blank-window floor and fallback; Auto must reject `DeviceType::Cpu` before `request_device` and pipeline compilation. Test this against WARP/lavapipe/SwiftShader and a machine with no display GPU. Explicit software renderer selection should remain distinct from CPU canvas presentation and should report its cost plainly.

## Proof gates and measurements

Use deterministic counters and platform integration tests, not a throughput benchmark, to prove the no-regression floor:

1. **No candidate:** no-GPU, headless/remote, zero-size/minimized, and unknown-hint starts show a CPU frame; counters stay `WGPU instances=0, adapter probes=0, devices=0, pipelines=0`. Record cold process RSS and startup CPU against current CPU-only baseline. This directly catches the “CPU first frame then unconditional adapter scan” regression.
2. **Software candidate only after a positive hint:** adapter discovery necessarily constructs an Instance and probes. Auto rejects a CPU adapter before requesting a device or compiling a pipeline; those two counters remain zero. Explicit GPU may attempt it, with deterministic error if unsupported.
3. **Eligible hardware:** only after a positive cheap hint, prove target-compatible adapter, format/alpha support, and valid fallback class; then create device/pipeline. Assert the first GPU present is visible before authority switches and that the last accepted frame/state epoch is not lost or duplicated.
4. **Fault injection:** close/resize/migrate the window during each stage; adapter/device/pipeline failure; device loss immediately before and after first present; occlusion and restore; destruction off-main. Every path returns to a valid presenter or a typed terminal error, releases exactly one acquired texture, and drops owned Metal leases once.
5. **Windows fallback:** after any configured/presented flip target, assert the declared recovery class. Do not label same-HWND GDI as recoverable after successful flip `Present1`; if recovery requires composition child targets, test the full native-window semantics above.
6. **Observability:** expose bounded events `Eligibility{Unavailable|Maybe|Unknown}`, `TargetProof`, `AdapterAccepted/Rejected`, `RendererReady`, `FirstPresent`, `Commit`, `Fallback`, and `DeviceLost`, tagged with target/backend and policy. Keep hardware IDs out of default telemetry.

## Source map reviewed

Pinned source is the GPUI tree at `36921e2c42efe8569889d16a27295d8ee7b790a2`. Relevant files: `crates/gpui/src/native.rs` (CPU-first state and admission), `crates/gpui/src/native/upgrade.rs` (Auto policy and background adapter selection), `vendor/wgpu-hal/src/lib.rs` (surface safety/acquire contracts), `vendor/wgpu-hal/src/dx12/mod.rs` (flip swapchain creation at configure), `vendor/wgpu-hal/src/metal/mod.rs` and `metal/surface.rs` (owned layer lease), and `vendor/softbuffer/src/backends/cg.rs` (AppKit CPU-layer lease). The cited vendor paths are pinned GitHub links above.

## Source review corrections, 2026-10-22

The proposal above is not the current default: macOS Auto already starts a background probe after the first CPU frame. Preserve that behavior and defer its native Metal layer until final admission unless a measured replacement proves equivalent ownership and visible fallback. Returning Unknown/CPU by default on macOS would be a deliberate behavior change, not a transparent boundary refactor.

The software-candidate counter proposed in gate 2 is too strong. A positive Linux file hint with only a software Vulkan adapter necessarily constructs an Instance and probes adapters to discover that device type. The valid gate is zero device requests and pipeline builds after CPU-adapter rejection. Zero Instances/probes applies only to cheap-rejected hints. A missing device file is a lossy local hint, not proof about remote/custom ICDs. Explicit GPU preserves their opt-in path.

Moving application OS policy into vendor source does not remove its implementation or its code from broad source accounting. The next slice must establish a reusable capability boundary and target-compatible adapter proof, while preserving delayed Metal attachment and the documented Windows GDI limitation.
