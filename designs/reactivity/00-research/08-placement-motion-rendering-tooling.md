# 08 — Placement, Motion, Custom Rendering, and Tooling

Research date: 2026-08-12; temporal-motion update: 2026-08-21. This note records the external
behavior checked before making arbitrary placement, animation, custom rendering, testing, and
inspection first-class in the final plan.

## Sources and limits

- [PanGui](https://www.pangui.io/) demonstrates `PositionRelativeTo`/`SizeRelativeTo`, root-relative
  overlays, layout-mode blending, direct draw-list access, controlled input injection, and an output
  command list intended for arbitrary rendering pipelines. It is currently a closed-alpha C# system;
  these are expressiveness references, not independently reproduced performance results or a Rust
  implementation dependency.
- [Lilt](https://github.com/cyypherus/lilt) and its
  [`Animated` documentation](https://docs.rs/lilt/latest/lilt/struct.Animated.html) provide a small
  stable-Rust, interruption-safe transition model sampled as a function of time. Duration, delay,
  repeat, auto-reverse, and asymmetric easing are supported. Its public model does not provide a
  complete spring/keyframe/gesture/layout-transition/retained-GPU system, and it imposes no inherent
  `Send` requirement.
- [Web Animations](https://www.w3.org/TR/web-animations-1/) separates a static effect from the
  timeline that samples it, makes pause/seek/reverse/playback-rate/fill/iteration semantics
  explicit, and defines replace/add/accumulate composition when several effects target one
  property. Its time source need not be wall time; scroll and gesture timelines fit the same model.
- [CSS View Transitions](https://www.w3.org/TR/css-view-transitions-1/) treats structural motion as
  a visual enhancement over an already-committed state change. It captures old and new rendered
  states into a temporary presentation tree, pairs named participants, and tears that tree down
  after completion. This is stronger prior art for GPUI enter/exit/hero motion than pretending two
  logical trees coexist.
- [Motion values](https://motion.dev/docs/motion-value) retain the last presented value and velocity,
  automatically replace an animation when a new one starts, and render subscribers once per frame.
  The useful lesson is the separation between source state, presented value, and velocity; GPUI can
  keep it without a JavaScript subscription or one object per destination.
- Maxime Heckel's [Shading Motion](https://blog.maximeheckel.com/posts/shading-motion/) derives a
  useful temporal-rendering ladder from ordinary frame-graph operations: current/previous frame
  differencing, ping-pong history with decay, a compute-produced mask, compact blob buffers,
  optical-flow-like direction fields, object/camera velocity attachments, and a final render pass.
  It also records practical constraints that an API must expose: quarter/half-resolution analysis,
  first-frame initialization, read/write texture compatibility, tiny optional CPU readback, and
  the aliasing/wagon-wheel failure of undersampled motion. These are render-graph semantics, not
  more easing functions.
- [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/) separates
  inspection into versioned command/event domains. Its
  [Overlay domain](https://chromedevtools.github.io/devtools-protocol/tot/Overlay/) shows the value
  of node highlighting with geometry, style, and accessibility information.
- [Playwright locators](https://playwright.dev/docs/locators) prioritize role/name, label, text, and
  explicit test ids. [Actionability](https://playwright.dev/docs/actionability) re-resolves a locator
  and waits for unique, visible, stable, enabled, event-receiving targets rather than relying on
  sleeps or cached node references.
- [Naga validation](https://wgpu.rs/doc/naga/valid/index.html) and wgpu's pipeline validation are the
  appropriate build/runtime boundary for checked WGSL interfaces. Validation is not a security
  sandbox and cannot make arbitrary shader execution harmless.
- Current GPUI already provides source/path-based inspector ids and a picker in
  [`inspector.rs`](../../../crates/gpui/src/inspector.rs), an accessibility debug capture in
  [`window/a11y/debug.rs`](../../../crates/gpui/src/window/a11y/debug.rs), and a convenient
  [`canvas`](../../../crates/gpui/src/elements/canvas.rs). The existing
  [`TestAppContext`](../../../crates/gpui/src/app/test_context.rs) is a useful deterministic-host
  seed. The current canvas boxes one-shot
  `'static` prepaint/paint closures with mutable `Window`/`App` access and no retained identity,
  dependency/damage declaration, or GPU resource contract. These are migration seeds, not the final
  retained tooling/rendering design.

## Adopted conclusions

### Placement is a graph, not more Taffy flags

Normal flow, an anchored overlay, a presentation transform, and a mutually constrained layout group
have different dependency semantics. The public API may make them equally easy, but the runtime must
not pretend they are the same operation.

A retained geometry anchor is a copyable generational key into presentation geometry, not application
state. Anchored placement resolves after normal layout against one coherent presentation draft. It
tracks coordinate spaces, scrolling, transforms, scale, clipping roots, writing direction, safe
areas, and anchor revisions. Ordinary anchor outputs cannot feed intrinsic measurement, which keeps
the graph acyclic. Explicit local constraint groups have a bounded solver and located cycle/failure
diagnostics.

### Motion is sampled data

Keep Lilt's strongest property: changing a target starts from the value presented at the interruption
time, and sampling at a given monotonic time is deterministic regardless of tick frequency. Lower
static motion descriptions to compact retained programs and sample active programs in typed dense
lanes. A frame does not write one reactive state cell or run one general effect per animation.

The complete program family also needs timed easing/Bezier, physical spring state and velocity,
keyframes/sequences/repeat, gesture-driven progress, FLIP/structural lifetime, reduced-motion policy,
and explicit interruption behavior. Fit/expand and other intrinsic layout modes are not generally
linearly interpolable through Taffy; use FLIP, a measured proxy where valid, or a declared crossfade/
reflow fallback.

The Web Animations comparison adds details that the earlier draft left implicit. A motion program
has a timeline (monotonic frame time, scroll, gesture, media, or explicit test time), an effect, a
playback state, fill/cancel semantics, and a composition rule at the destination. `Replace` is the
ordinary UI default; `Add`/`Accumulate` are opt-in only for values with reviewed algebra. Seeking,
negative/zero playback rate, delayed start, pause/resume, and completion/cancel are part of the
kernel contract rather than ad hoc methods on individual effects. A new target still interrupts
from the presented sample; `jump` is the explicit discontinuous operation that resets velocity.

Structural motion follows the View Transitions rule: commit the logical state first, then retain
bounded old/new presentation snapshots under a transition host. The snapshots do not re-enter the
logical, input, or accessibility tree. A failed/unsupported transition never cancels the state
change, and every retained snapshot has a time/byte lease.

### Shading motion is temporal dataflow, not property animation

Heckel's examples should not become `motion_mask()` methods in the GPUI kernel. They show the
smallest general primitives a professional canvas/effect library needs:

- a typed current scene/color/depth/identity/velocity input;
- persistent history textures or buffers with explicit `previous`/`current` ping-pong roles;
- compute and render passes with declared reads, writes, dispatch size, format, and bounds;
- resize/scale/first-frame/device-loss reset policy;
- direct clock, pointer, gesture, property, and motion-lane uniforms;
- an explicit, asynchronous and bounded GPU-to-CPU readback edge.

Frame differencing, temporal decay, masks, blob tracking, approximate optical flow, SDF overlays,
velocity blur, trails, feedback paint, onion skinning, wet brushes, stabilization, and temporal
denoise can then live in an optional `gpui_motion_fx`/creative-graphics crate. The kernel owns the
retained temporal resource and hazard contract, not a catalog of visual tastes.

There are two different motion sources and they must remain named. **Inferred motion** compares
frames and is sensitive to lighting, occlusion, cadence, and aliasing. **Known motion** comes from
retained identity plus previous/current transforms (or a custom canvas-provided velocity stream)
and can produce a velocity attachment without rendering a duplicate portal scene. A pass asks for
only the attachments it uses. An ordinary UI frame allocates no history texture, emits no velocity,
runs no compute pass, and requests no animation frame.

| Candidate surface | Result | Decision |
|---|---|---|
| `with_animation(id, frame_closure)` | easy start; string identity and Rust rerun every frame | migrate away |
| one signal/effect per animated field | fine semantics; graph/schedule/write overhead scales with tracks | reject as kernel |
| dense sampled property lanes | direct typed destinations, deterministic clock, cheap interruption | adopt |
| built-in `motion_mask`/`optical_flow` element methods | pleasant demos; freezes a creative catalog into GPUI | optional recipe crate |
| typed retained history/compute/render graph | supports those effects plus editor-specific temporal work | adopt |
| native backend command callback | maximum reach; weak portability/testing/damage guarantees | retain as isolated expert edge |

### Canvas and shaders are retained nodes

The common canvas surface is a normal retained node with identity, typed property ports, bounds,
clip, hit behavior, semantics, damage, cache policy, and inspector metadata. It records immutable
scene operations or a typed render-pass descriptor; it is not merely two frame-local boxed closures.
An advanced native command callback is still possible, but declares conservative bounds, resources,
blend/readback behavior, and normally receives isolated full-node damage.

Shader parameter structs have generated, checked layout. Static WGSL/interface mismatch is a build
error. Development hot reload validates before replacing a pipeline; failure keeps the last valid
pipeline and reports diagnostics. Frame packets own referenced GPU resources until their fences
retire, and device loss rebuilds pipelines/resources from retained CPU descriptors.

Temporal resources extend that rule across frames. The render graph owns their generation and
swaps them only after successful submission; a dropped frame never makes an unsubmitted write the
next `previous` value. History is invalidated on incompatible resize/format/profile changes and
recreated under the node's byte budget. Read/write aliasing is rejected unless the backend exposes
and the pass explicitly requests a supported read-write storage mode; portable recipes lower to
separate ping-pong resources.

### Inspector and tests share a snapshot protocol

Neither an inspector-only mirror tree nor tests that call callbacks directly are acceptable. After a
successful presentation publication, an opt-in immutable `UiSnapshot` describes the exact retained
logical/layout/paint/semantic/property/owner state and its epoch. The in-process inspector, optional
authenticated loopback protocol, integration harness, trace viewer, and failure reports consume the
same snapshot/delta contract.

Tests inject events through the real dispatcher, use a virtual monotonic clock and seeded executor,
and explicitly settle or advance time. Locators re-resolve against the latest snapshot, prefer
role/name and semantic labels, and verify actual hit testing/actionability. Exact pixels are promised
only for a pinned software/reference renderer and pinned fonts; real GPU/platform goldens require
per-platform baselines or stated perceptual tolerance. Arbitrary shaders need an optional CPU
reference implementation for exact software pixels; otherwise tests assert the pass description and
use a platform/tolerant GPU image baseline.

## Required edge cases

- anchor removal, owner teardown, scroll/scale/transform changes, portal remount, cross-window
  coordinate spaces, mutual anchor cycles, and offscreen/safe-area fallback;
- interruption at irregular frame cadence, spring velocity preserve/reset, zero duration, delayed
  reversal, pause/seek/negative playback rate, replace/add composition, reduced motion, background
  suspension, missed deadlines, and layout fallback;
- shader compile failure/hot reload, pipeline cache churn, device loss, oversized resources,
  read-after-write pass hazards, clip/backdrop damage, and a stalled GPU fence;
- temporal first frame, ping-pong publication after a dropped/failed frame, resize/profile reset,
  downsampled coordinates, history-budget eviction, motion-vector disocclusion, cadence aliasing,
  and bounded asynchronous readback;
- stale inspector ids, redacted private state, virtualized semantic materialization, remote-control
  authentication, infinite animation during `settle`, async nondeterminism, font/scale/color-profile
  fixtures, and trace/snapshot memory budgets.
