+++
title = "Animation: motion, springs, transitions"
description = "Make change visible over time with frame requests, animation state, and interpolation."
weight = 29
aliases = ["/graphics/animation.html"]
[extra]
category = "GRAPHICS"
legacy_source = "gpui-ce-docs/build/html/graphics/animation.html"
+++

**Animation** is value changing over time with repaints to show it. Three layers carry you: **Motion** owns time plus easing, **Animated** and **Transition** own state over time, and **Animation** elements drive the repaints. Springs trade fixed durations for physical feel.

```rust
// Time plus a curve — that is the whole of Motion.
// 200 ms with a soft start and a soft landing, your default friend.
use std::time::Duration; // durations name the trip length
let motion = Motion::new(Duration::from_millis(200)) // linear clock `motion.rs:126`
    .with_easing(ease_in_out); // slow, fast, slow `motion.rs:135`
```

**Progress** is a clamped `0–1` newtype ([crates/gpui/src/motion.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/motion.rs), `:25`). **Easing** maps one progress to another (`motion.rs:72`). `sample(elapsed)` turns wall time into an eased sample (`motion.rs:141`), and `Duration::with_easing` compresses the two verbs into one (`motion.rs:50–60`).

## Motion and easing

Pick the curve that matches the feeling you want. Each easing is a plain `fn(f32) -> f32`, re-exported for you ([crates/gpui/src/elements/animation.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/animation.rs)).

|  |  |  |
| --- | --- | --- |
| Function | Shape | Reach for it when |
| `linear` | `f(x) = x` | Progress bars, mechanical fills |
| `quadratic` | `f(x) = x²` | Accelerating entrances |
| `ease_in_out` | Slow, fast, slow | Default for UI moves |
| `ease_out_quint()` | `1 − (1−x)⁵` | Fast entry, feather landing |
| `bounce(f)` | Forward then reverse | Attention pulse |
| `pulsating_between(min, max)` | Breathing alpha | Status glow |

Table 17: Easing curves and their everyday jobs.

Easing output is never clamped inside `Animation::with_easing` ([crates/gpui/src/elements/animation.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/animation.rs)). Curves may overshoot past `1.0`, and springs rely on that freedom. Clamp at the use site if your property cannot survive overshoot.

> **Tip.** Default to `ease_in_out` under  300 ms for moves and fades. Save `bounce` and `pulsating_between` for moments that deserve attention.

## Lerp and Animated

**Lerp** is the ability to blend ([crates/gpui/src/lerp.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/lerp.rs)). Anything animated implements `fn lerp(&self, to: &Self, delta: f32)`. Floats, `Pixels`, `Point`, `Size`, `Bounds`, `Rgba`, and friends already do.

```rust
// `Animated` holds where you are and where you are headed.
// `set` retargets from the live position, `sample` reads the clock.
let mut a = Animated::new(px(0.), motion); // settled at zero `animated.rs:35`
a.set(px(120.), &motion, Instant::now()); // glide, anchored mid-flight `animated.rs:63`
let s = a.sample(Instant::now()); // eased blend of old toward new `animated.rs:107`
```

Two subtleties save you later. `Hsla` lerps by detouring through `Rgba` ([crates/gpui/src/lerp.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/lerp.rs)), so hue never takes the long way around the wheel. Mixed-unit lengths refuse to blend and snap at the endpoints instead (`lerp.rs:154`), so keep both ends in `Pixels` or both in `Rems`.

**Transition** is the entity-backed sibling for views ([crates/gpui/src/transition.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/transition.rs)). Call `evaluate` each frame and it samples, caches, and requests the next frame while motion runs (`transition.rs:135`). Call `jump_to` to snap (`transition.rs:208`), `scale_by` to survive coordinate changes, `reset` to return home. Its alias says the shape plainly: `TransitionState<T> = Animated<T, Instant>` (`transition.rs:246`).

> **Pitfall.** Do not restart a motion to chase a moving target. `set` anchors continuously from the live value, while `restart` re-anchors from the start (`animated.rs:63`). Chasing with restarts stutters, retargeting with `set` glides.

## Springs

**SpringConfig** holds stiffness, damping, and mass (`crates/gpui/src/spring.rs:13–19`). Stiffness snaps, damping calms, mass weighs. Together they sing instead of ticking.

|  |  |  |
| --- | --- | --- |
| Param | Symbol | What turning it up does |
| `stiffness` | k | Snappier return, higher natural frequency |
| `damping` | c | Less overshoot, past critical turns sluggish |
| `mass` | m | Slower and heavier, lower frequency |

Table 18: Spring knobs and their honest effects.

```rust
// Numbers with physical meaning: stiff spring, gentle damper, unit mass.
// `canonical` speaks frequency, `step` advances the simulation one tick.
let cfg = SpringConfig::new(300.0, 30.0, 1.0); // k, c, m `spring.rs:24`
let (omega_0, zeta) = cfg.canonical(); // `sqrt(k/m)`, `c / 2√(km)` `spring.rs:33`
let state: SpringState = cfg.step(state, target, dt); // analytic hop `spring.rs:43`
```

`canonical` returns natural frequency plus damping ratio, where critical damping sits at `2√(k·m)`. Settling checks both stillness and slowness: position within `epsilon` of target and velocity within `epsilon` times frequency ([crates/gpui/src/spring.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/spring.rs)). Zero damping oscillates forever, so every ambient spring needs an epsilon.

Bridges exist when an API only takes `Motion`. `sampled_easing(cfg, eps)` bakes a spring into a duration plus easing fn ([crates/gpui/src/spring.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/spring.rs)), overshoot included. `style_transitions.rs` stays `pub(crate)` ([crates/gpui/src/style_transitions.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/style_transitions.rs)), so style-property transitions remain internal machinery, not app API.

## Animated elements

**Animation** elements do the repainting ([crates/gpui/src/elements/animation.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/animation.rs)). Build one, attach it, and let it tick. `repeat` loops freely, `repeat_synced` locks phase to a shared clock (`animation.rs:44–50`), and `with_max_fps` throttles ambient loops (`animation.rs:69`).

```rust
// Attach motion to any element with one trailing closure.
// `delta` arrives eased each frame — spend it on opacity, offset, scale.
div().with_animation( // `AnimationExt` adds this verb `animation.rs:82`
    Animation::new(Duration::from_secs(1)).repeat().with_easing(ease_in_out), // loop it softly
    |el, delta| el.opacity(delta), // paint the eased value
)
```

Animate position, opacity, and scale under  300 ms with `ease_in_out` or a spring. Jump on data changes, first paint, reduced-motion, or a target that moved mid-flight — restarting a short motion beats chasing a stale one. Static content never earns an `Animation`, and ambient loops always earn a `with_max_fps` cap.

> **Tip.** Cap every ambient loop with `with_max_fps`. Your glow keeps breathing while the laptop fan stays asleep.

Where next? Shape the text you fade (`./text-system.html`), measure the boxes you slide (`./geometry-color.html`), or record it all into the scene (`./scene-rendering.html`).

## Sources

- `Progress`: [crates/gpui/src/motion.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/motion.rs); `clamped`: `motion.rs:25`; `with_easing`: `motion.rs:50–60`; `Easing::sample`: `motion.rs:72`
- `Motion::new`: `motion.rs:126`; `with_easing`: `motion.rs:135`; `sample`: `motion.rs:141`
- `Lerp`: [crates/gpui/src/lerp.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/lerp.rs); `Animated`: [crates/gpui/src/animated.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/animated.rs); `new`: `animated.rs:35`; `set`: `animated.rs:63`
- `jump_to`: `animated.rs:91`; `reset`: `animated.rs:99`; `sample`: `animated.rs:107`
- `Transition`: [crates/gpui/src/transition.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/transition.rs); `evaluate`: `transition.rs:135`; `jump_to`: `transition.rs:208`; `TransitionState`: `transition.rs:246`
- `SpringConfig`: `crates/gpui/src/spring.rs:13–19`; `new`: `spring.rs:24`; `canonical`: `spring.rs:33`; `step`: `spring.rs:43`
- `SpringState`: `spring.rs:252`; `SpringTarget`: `spring.rs:264`; `Interpolate`: `spring.rs:408`; `SpringAnimation`: `spring.rs:475`; `sampled_easing`: `spring.rs:541`
- `Animation::new`: [crates/gpui/src/elements/animation.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/animation.rs); `repeat` / `repeat_synced`: `animation.rs:44–50`; `with_easing`: `animation.rs:60`; `with_max_fps`: `animation.rs:69`; `AnimationExt`: `animation.rs:82`
- `style_transitions.rs` (`pub(crate)`): [crates/gpui/src/style_transitions.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/style_transitions.rs)
