# Graphics and API documentation audit

This pass covers the public documentation in `geometry`, `color`/`colors`,
`animated`, `lerp`, `motion`, `spring`, `transition`, `path_builder`, `scene`,
`profiler`, and `debug_overlay`. The source remains the contract: examples and
the Zola site should link to the exact rustdoc item rather than copy its
signature.

## Inventory

The review read every public declaration and public field in the assigned
modules: geometry (135 declaration lines), color (36), colors (8), animated
(12), lerp (1), motion (61), path building (20), scene plus plan/ABI/capture
(72), profiler plus actions/journal/hang (143), spring (26), transitions (14),
and the debug overlay (10). These are source inventory counts, including
feature-gated variants and re-exports, rather than rustdoc page counts. The
pass reworked module contracts, unit and coordinate docs, animation semantics,
scene ABI fields, capture/render-plan requirements, and renderer-facing
primitive fields. Existing docs were retained when they matched the code.

## Contract captured

- Geometry uses a top-left origin. Logical `Pixels`, scene `ScaledPixels`, and
  physical `DevicePixels` are distinct units; a scale factor is required at
  conversion boundaries. Bounds use top/right/bottom/left edges and return
  empty intersections instead of inventing a positive area.
- Hex colors are `RRGGBB` or `RRGGBBAA`; `hsla` uses hue as turns and clamps its
  inputs. Gradient angles are degrees and stop positions are normalized.
- Motion is sampled by elapsed time. Easing receives normalized pass time and
  may overshoot, while NaN/non-finite easing output is rejected. Animated
  retargeting starts from the current presentation by default.
- Springs preserve velocity across analytic steps. Configuration and epsilon
  are scalar-coordinate contracts; `SpringTarget` maps richer values onto that
  coordinate. Duration-based spring easing restarts when retargeted.
- Scenes are recorded first and compiled at `Scene::finish`; recording after a
  finish invalidates the plan. `SceneCapture::capture` creates portable
  snapshots, but native paint surfaces cannot be serialized.
- Profiler durations are process-local scheduler-clock measurements. Histograms
  aggregate observations; event streams are feature-gated and tracing-gated.
  Frame and hang boundaries are explicit, so a report is post-hoc rather than
  an instantaneous monitor.

## Deliberate follow-ups

The remaining `#[doc(hidden)]` declarations are compatibility or profiler
plumbing already hidden by the crate (for example serialized task snapshots
and ABI aliases). Scene capture fields remain private by design and expose
validated accessors. `style_transitions` is private machinery; its module now
documents resolution, `auto` capture, and reduced-motion semantics but has no
public API page. Further rustdoc warnings should be treated as documentation
gaps rather than silenced with a new allowance.

No cargo build was run in this documentation-only pass. The browser examples
should be checked against the live Zola site and the docs.rs post-processor
when those branches are integrated. Planned cross-links:

- <https://gpui-ce.github.io/examples/drawing/#paint>
- <https://gpui-ce.github.io/examples/animation/#clock>
- <https://gpui-ce.github.io/guides/testing/>
