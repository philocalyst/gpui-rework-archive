# Animate

GPUI has four ways to move things: a timed [`Animation`] applied to one element, a
[spring](#use-springs-for-interactive-values) that follows a target, a
[`Transition`] between values that change over time, and style transitions that animate
an element's own style when it changes, such as on hover. This guide shows when to use
each, and how animations respect the reduced-motion setting. The
[animation example](crate::_documentation::examples::animation) shows all four together.

## Animate an element over a duration

Call [`AnimationExt::with_animation`] on an element. Pass an id, an [`Animation`] and a
closure that receives the element and a value from `0.0` to `1.0`. The closure runs on
every frame with the eased value and returns the styled element.

```rust
use std::time::Duration;

use gpui::{
    Animation, AnimationExt, Context, IntoElement, Render, TestApp, Window, div,
    ease_out_quint, prelude::*, px,
};

struct Toast;

impl Render for Toast {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().child("Saved").with_animation(
            "toast-enter",
            Animation::new(Duration::from_millis(300)).with_easing(ease_out_quint()),
            |toast, delta| toast.opacity(delta).mt(px(8. * (1. - delta))),
        )
    }
}

let mut app = TestApp::new();
app.open_window(|_, _| Toast);
```

The id identifies the animation's state across frames. Change the id to start the
animation again, as the example's "Replay" button does. Keep it stable otherwise, or the
animation restarts on every render.

An [`Animation`] built from a [`Duration`] runs one pass with linear timing.
[`Animation::with_easing`] changes the curve. The easing is not clamped, so
an overshooting curve gives values outside `0.0..=1.0`. Clamp in your closure if the
property can't take them.

### Easing functions

These are the easing functions GPUI provides. Each one maps a value from `0.0..=1.0` to
a new value, and you pass it to [`Animation::with_easing`] or [`Motion::with_easing`]:

| Function | Shape |
| --- | --- |
| [`linear`] | No easing. The default for a duration with no easing. |
| [`quadratic`] | Starts slowly and speeds up. |
| [`ease_in_out`] | Starts and ends slowly, fastest in the middle. |
| [`ease_out_quint()`] | Starts quickly and decelerates to a stop. Returns a closure. |
| [`bounce`] | Runs `easing` forward and then backward, so it returns to the start. |
| `pulsating_between(min, max)` | Breathes between `min` and `max`, for idle indicators. Returns a closure. |

`ease_out_quint()`, `pulsating_between(min, max)` and `bounce(easing)` return closures, so
call them as shown. Pass any `Fn(f32) -> f32` you write yourself in the same way.

## Repeat, chain and synchronize

Call [`Animation::repeat`] to loop the animation forever. Use [`Animation::repeat_synced`]
to phase-lock it to a clock shared by the whole app, so several repeating elements pulse
together. Limit how often it redraws with [`Animation::with_max_fps`].

```rust
use std::time::Duration;

use gpui::{
    Animation, AnimationExt, Context, IntoElement, Render, TestApp, Window, div,
    prelude::*, px, pulsating_between, rgb,
};

struct Status;

impl Render for Status {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().size(px(12.)).rounded_full().bg(rgb(0x22c55e)).with_animation(
            "pulse",
            Animation::new(Duration::from_millis(1600))
                .repeat_synced()
                .with_easing(pulsating_between(0.3, 1.0))
                .with_max_fps(30.),
            |dot, delta| dot.opacity(delta),
        )
    }
}

let mut app = TestApp::new();
app.open_window(|_, _| Status);
```

To run several steps one after another, use [`AnimationExt::with_animations`]. It takes a
`Vec<Animation>` and calls the closure with the index of the step that is running. Each
step starts when the previous one finishes. A repeating step never finishes, so repeat
only the last one.

```rust
use std::time::Duration;

use gpui::{
    Animation, AnimationExt, Context, IntoElement, Render, TestApp, Window, div,
    ease_out_quint, prelude::*, px,
};

struct Pop;

impl Render for Pop {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().child("Done").with_animations(
            "pop",
            vec![
                Animation::new(Duration::from_millis(150)),
                Animation::new(Duration::from_millis(300)).with_easing(ease_out_quint()),
            ],
            |el, step, delta| match step {
                0 => el.opacity(delta),
                _ => el.opacity(1.0).mt(px(8. * (1. - delta))),
            },
        )
    }
}

let mut app = TestApp::new();
app.open_window(|_, _| Pop);
```

## Use springs for interactive values

A spring follows a target with physical motion. It keeps its velocity when the target
moves, so an interrupted animation bends toward the new target instead of jumping. Use
it for things a user drags or toggles. Build a [`SpringConfig`] with [`spring`], which
takes stiffness, damping and mass, then call [`SpringAnimation::to`] with the target.

Pass the spring to [`AnimationExt::with_spring`]. Keep the id the same as the target
changes, so the spring keeps its position and velocity. A newly mounted spring starts at
its target. Set a different start with [`SpringAnimation::from`].

```rust
use gpui::{
    AnimationExt, Context, IntoElement, Render, SpringAnimation, TestApp, Window, div,
    prelude::*, px, spring,
};

struct Switch {
    on: bool,
}

impl Render for Switch {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        let target = if self.on { 1.0 } else { 0.0 };
        div().w(px(52.)).h(px(30.)).child(
            div().absolute().top(px(3.)).size(px(24.)).with_spring(
                "knob",
                SpringAnimation::new(spring(320., 24., 1.)).to(target),
                |knob, position| knob.left(px(3. + 22. * position)),
            ),
        )
    }
}

let mut app = TestApp::new();
app.open_window(|_, _| Switch { on: true });
```

[`SpringAnimation::to`] accepts an `f32` or a [`Pixels`] value, which is a [`SpringTarget`].
[`SpringAnimation::with_epsilon`] sets how close the spring must be to its target before
it counts as settled. [`SpringAnimation::playback`] takes a [`SpringPlayback`] to pause,
stop, complete or cancel the spring.

If you step a spring yourself, for example to drive a value from your own loop, use
[`SpringConfig::step`] with the current [`SpringState`], a target and a time step. This example
checks that a spring of stiffness 320 and damping 24 has settled after two simulated
seconds:

```rust
use gpui::{SpringState, spring};

let config = spring(320., 24., 1.);
let mut state = SpringState::default();
for _ in 0..240 {
    state = config.step(state, 1.0, 1.0 / 120.0);
}
assert!((state.position - 1.0).abs() < 0.01);
```

[`sampled_easing`] converts a spring into a duration and easing function. Use it when an
API takes an [`Animation`] but you want spring-like motion.

## Transition a value that changes

A [`Transition`] animates a value toward a goal. When the goal changes, the transition
moves from its current value toward the new goal, and by default it continues from where
it is rather than restarting. Create one with [`Window::use_keyed_transition`] during
render. The key keeps its state across frames. Call [`Window::use_transition`] for state
that is recreated on every render, which is rarely what you want.

```rust
use gpui::{Context, IntoElement, Render, TestApp, Window, div, millis, prelude::*};

struct Fade;

impl Render for Fade {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let transition = window.use_keyed_transition("fade", cx, millis(200), |_, _| 0.0_f32);
        let opacity = *transition.evaluate(window, cx);
        div().opacity(opacity).child("Hello")
    }
}

let mut app = TestApp::new();
app.open_window(|_, _| Fade);
```

[`Transition::evaluate`] returns the value for the current frame and requests the next
frame while it is still moving. Change the goal from an event handler with
[`Transition::update`], then call `cx.notify()` so the view redraws. The goal is not
updated during render.

The goal can be checked directly. The next example creates a transition outside a view,
sets a new goal and reads it back:

```rust
use gpui::{AppContext, Transition, TransitionState, TestApp, millis};

let mut app = TestApp::new();
app.update(|cx| {
    let state = cx.new(|_| TransitionState::new(0.0_f32, millis(200)));
    let transition = Transition::new(state, millis(200));

    transition.update(cx, |value, cx| {
        *value = 1.0;
        cx.notify();
    });
    assert_eq!(*transition.read_goal(cx), 1.0);
});
```

## Animate style changes

For an element whose own style changes, such as a background that changes on hover,
[`InteractiveElement::transitions`] animates the change without a closure. Choose the
properties with the builder, and give each one a [`Motion`] or a duration. The builder
includes `bg`, `border_color`, `text_color`, `opacity` and the size properties such as
`w`. Any change to these properties, from hover, a state change or your own code, is
animated.

```rust
use gpui::{Context, IntoElement, Render, TestApp, Window, div, millis, prelude::*, rgb};

struct Button;

impl Render for Button {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("hover-button")
            .px_4()
            .py_2()
            .bg(rgb(0x1f2937))
            .text_color(rgb(0xf9fafb))
            .hover(|style| style.bg(rgb(0x2563eb)))
            .transitions(|transitions| {
                transitions
                    .bg(millis(200))
                    .text_color(millis(200))
            })
            .child("Hover me")
    }
}

let mut app = TestApp::new();
app.open_window(|_, _| Button);
```

Pass an explicit [`InteractiveElement::id`] to elements built in a loop. Without one,
GPUI uses the call site, so every element from the same line would share one transition.

## Respect reduced motion

Some users turn on a system setting that asks for less motion. Read it with
[`App::reduce_motion`] and set it with [`App::set_reduce_motion`]. Nothing in GPUI
reads the operating system setting for you, so your app decides when to set it.

When reduced motion is on, every animation rendered through `with_animation`,
`with_animations`, `with_spring` and `transitions` renders in a static state instead of
moving. One-shot animations show their end state, and repeating ones show their start.
Springs jump to their target. Write the animation so that its end state is a usable
design, and don't rely on the motion to convey information.

```rust
use gpui::TestApp;

let mut app = TestApp::new();
app.update(|cx| {
    cx.set_reduce_motion(true);
    assert!(cx.reduce_motion());
});
```

## See also

- [Animation example](crate::_documentation::examples::animation), which shows each kind of
  motion in one window.
- [Layout and style](crate::_documentation::concepts::layout_and_style), for the styles an
  animation can change.
- [The frame](crate::_documentation::concepts::the_frame), for when animation frames are
  requested and drawn.
