# Renderer API documentation audit

This pass reviewed the public Rust surface in `crates/gpui_render/src` and
`crates/gpui_wgpu/src`, including the generated shader artifact records, host
ABI records, CPU replay path, WGPU context and recovery handles, atlas, surface
settings, renderer controls, headless replay, and telemetry. The source
inventory contains 353 public declaration lines in 26 render files and 242 in
26 WGPU files. Those counts include feature-gated declarations, re-exports,
and shader helper declarations generated from Rust modules; they are not
rustdoc page counts.

The reviewed contracts now state the boundaries that matter to users:

- Scene and blur coordinates are scene or device pixels as named; blur texture
  dimensions are physical pixels and downsampled by the fixed factor.
- CPU replay and WGPU replay consume the same compiled scene plan and atlas
  capture format. CPU readback is straight RGBA and is deliberately outside
  replay timing.
- Shader artifact strings are generated and dialect-specific. Host records
  carry stable ABI layouts; binding metadata describes visibility, transport,
  and byte widths rather than promising a driver allocation.
- WGPU contexts own devices and queues. A device-loss flag invalidates custom
  resources; controls must reacquire a handle and recreate resources after
  recovery. Render targets normalize zero dimensions to one physical pixel.
- Headless measurements distinguish CPU submission/completion time, GPU
  timestamp envelopes, and exact selected resource sizes. Driver VRAM and
  intermediate allocations are outside the owned-memory total.
- WebGL2/downlevel transport, D3D11 instance-base constants, dual-source
  blending, LCD subpixel order, and transparent surfaces are documented at
  their selection boundaries.

The remaining public declarations are shader-stage helpers and generated ABI
records whose semantics are documented by their containing shader module and
host-side layout assertions. They are renderer-internal building blocks
re-exported for backend integration; they do not expose additional application
state or lifecycle guarantees. No executable code or build metadata changed in
this pass, and no new missing-documentation suppression was added.
