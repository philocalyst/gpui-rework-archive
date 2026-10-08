# Animate a change without losing its state

An animation needs a target, a value to present now, and a way to request the
next frame. GPUI separates those jobs. [`Motion`](crate::Motion) describes
timing. [`Animated`](crate::Animated) retains an interpolation's target and
starting value. Element adapters connect that state to rendering.

Choose an adapter according to what changes:

| What you need | Use |
| --- | --- |
| Animate selected style properties when their authored values change | [`InteractiveElement::transitions`](crate::InteractiveElement::transitions) |
| Play a duration-based effect on an element | [`AnimationExt::with_animation`](crate::AnimationExt::with_animation) |
| Follow a changing target while retaining spring velocity | [`AnimationExt::with_spring`](crate::AnimationExt::with_spring) |
| Sample an interpolated value while rendering | [`Window::use_keyed_transition`](crate::Window::use_keyed_transition) |
| Own the clock and presentation outside an element | [`Animated`](crate::Animated) or [`SpringConfig::step`](crate::SpringConfig::step) |

## Start with a change in application state

For a control that expands when selected, retain the selection in its view.
Render the width that selection calls for, and attach motion to the width:

```rust
use gpui::{div, millis, prelude::*, px};

fn disclosure(expanded: bool) -> impl IntoElement {
    div()
        .id("disclosure")
        .w(px(if expanded { 240.0 } else { 80.0 }))
        .h(px(40.0))
        .transitions(|motion| motion.w(millis(180)))
        .child("Details")
}
```

The first render presents its authored width immediately. A later render with
the same identity and a different width starts the transition. An input handler
must still change `expanded` and notify its view. Configuring a transition does
not subscribe the view to arbitrary state changes.

The ID is the continuity of the animation. Keep it stable when the same control
rerenders; change it to mount fresh state. Repeated controls need different
IDs, usually an item key. If two rows share an identity, their retained state
cannot reliably describe two independent animations. See
[ownership and identity](crate::_ownership_and_data_flow).

[`StyleTransitions`](crate::StyleTransitions) keeps separate state for each
selected property. Changing width does not restart an unrelated background
transition. Builders that overlap follow ordinary setter order:
`motion.p(slow).pl(fast)` uses `fast` on left padding and `slow` on the other
three sides.

> [!WARNING]
> Width and height transitions interpolate absolute lengths, resolving pixels
> and rems to pixels. Percentage dimensions bypass interpolation. `auto`
> endpoints use retained layout bounds; they do not animate every intrinsic
> size change caused by new content. Use explicit measured endpoints when the
> animation must track a changing content size.

Other lengths use their [`Lerp`](crate::Lerp) implementation. Compatible units
interpolate; incompatible units usually switch at the endpoint. Position
offsets have a separate path that resolves percentages against the containing
bounds. These rules describe the transition's requested style. Flex and grid
constraints can still change its final bounds, as the
[layout chapter](crate::_documentation::layout) explains.

For optional properties, prefer explicit endpoints when their meaning matters.
An absent text color can mean inheritance, while an absent opacity paints as
fully opaque. During a transition, a missing option is interpolated using its
value type's default, which need not match that inherited or painting value.

## Retarget from the value being presented

[`Animated::set`](crate::Animated::set) starts a changed target from the current
sample. This prevents a second change from jumping back to the first run's
origin. A duration clock makes the behavior visible without opening a window:

```rust
use std::time::Duration;
use gpui::{Animated, Motion, millis, px};

let motion = Motion::new(millis(200));
let mut width = Animated::<_, Duration>::new(px(0.0), motion.clone());
width.set(px(100.0), motion.clone(), Duration::ZERO);
assert_eq!(width.sample(millis(100)).value, px(50.0));

width.set(px(200.0), motion, millis(100));
assert_eq!(width.sample(millis(200)).value, px(125.0));
let finished = width.sample(millis(300));
assert_eq!(finished.value, px(200.0));
assert!(!finished.is_active);
```

Retargeting preserves the sampled position. It starts a new easing response,
so it does not preserve velocity. Setting the same target again is a no-op,
including when the supplied motion differs. [`Animated::jump_to`](crate::Animated::jump_to)
presents a target immediately; [`Animated::reset`](crate::Animated::reset)
restores the value used at construction.

[`Transition`](crate::Transition) connects this interpolation to a window.
Call its keyed window hook during rendering, update the goal, then evaluate it.
The hook retains the animated entity but returns a fresh wrapper whose sample
cache belongs to that render. Retaining one wrapper indefinitely also retains
its cached sample. See [`Transition::evaluate`](crate::Transition::evaluate)
for the borrowing and frame-request contract.

## Use a spring when velocity should survive an interruption

A spring keeps both position and velocity. If a user reverses a toggle while
its indicator is moving, it can slow down and turn around instead of beginning
a new easing curve from rest.

```rust
use gpui::{div, prelude::*, px, rgb, AnimationExt, SpringAnimation, SpringConfig};

fn indicator(on: bool) -> impl IntoElement {
    let spring = SpringAnimation::new(SpringConfig::new(180.0, 22.0, 1.0))
        .to(px(if on { 36.0 } else { 0.0 }));
    div()
        .size(px(20.0))
        .rounded_full()
        .bg(rgb(0x3b8067))
        .with_spring("indicator", spring, |knob, offset| knob.ml(offset))
}
```

The adapter retains scalar spring state under `"indicator"`. The first mount
starts at the target; `.from(px(0.0))` would supply a different initial position.
On subsequent renders, a changed target keeps the previous position and
velocity. The `from` value does not restart an existing spring. A settled
spring snaps exactly to its target with zero velocity and stops requesting
frames.

[`SpringConfig`](crate::SpringConfig) takes stiffness, damping, and mass. Keep
stiffness and mass finite and positive, and damping finite and non-negative;
construction does not validate them. More stiffness increases the natural
frequency. Damping controls oscillation. Zero damping never settles unless
the state is already at rest at the target. The type's
[`canonical`](crate::SpringConfig::canonical) method explains the damping ratio.

For a multi-property effect, target a boolean or an
[`AnimationPhase`](crate::AnimationPhase). A boolean targets zero or one but
resolves to an unbounded phase, so the same spring can drive position, size,
and color. Use `interpolate_clamped` when a property should not overshoot.

> [!NOTE]
> A [`Motion::spring`](crate::Motion::spring) sampled directly always starts
> from rest at zero progress. Passing it through [`AnyMotion`](crate::AnyMotion)
> does not add retained velocity. The element's `with_spring` adapter, or a
> caller-owned [`SpringState`](crate::SpringState), supplies that state.

## Distinguish progress from completion

One duration *pass* travels in one direction. An iteration count includes the
first pass, and `alternate()` reverses every second one. A 200ms motion with
two alternating passes therefore takes 400ms and ends at its origin. Delay
applies once at the beginning. An explicit reverse pass can use a different
duration and easing curve.

[`MotionSample::progress`](crate::MotionSample::progress) is eased presentation;
[`local_time`](crate::MotionSample::local_time) is normalized time within the
selected pass. Progress can overshoot, revisit one, or return to zero while a
run is still active. Use [`is_complete`](crate::MotionSample::is_complete) to
ask whether a finite run has finished. Use `is_active` to decide whether
another sample could change the presentation.

Color interpolation also depends on the adapter. [`Lerp`](crate::Lerp) converts
HSL colors through sRGB and clamps at the endpoints. The spring phase's
[`Interpolate`](crate::Interpolate) implementation follows the shortest hue
path and allows extrapolation. Neither operation is alpha compositing;
[`ColorExt::blend`](crate::ColorExt::blend) places an overlay over a base color.

## Respect reduced motion at the adapter boundary

Style transitions, duration animation elements, and spring animation elements
consult [`App::reduce_motion`](crate::App::reduce_motion). They present a resting
value without continuing the usual animation. A repeating or alternating
duration effect can have a different resting endpoint from a single forward
pass; keep essential information in application state rather than conveying
it only through movement.

Direct `Motion` and `Animated` sampling have no application context, and the
value-transition hook does not apply reduced motion automatically. Check the
preference yourself and use `jump_to` when those paths drive a UI.
The [animation walkthrough](https://gpui-ce.github.io/examples/animation/)
shows a complete duration effect, replay, and its reduced-motion fallback.
