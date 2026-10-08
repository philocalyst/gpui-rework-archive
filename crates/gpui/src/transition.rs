//! Follow a changing goal with a value sampled during rendering.
//!
//! A transition stores its target in an [`Entity`] and samples it during
//! rendering. [`Transition::evaluate`] caches one sample in its wrapper,
//! requests another frame while motion is active, and returns a reference to
//! that sample. Recreate the wrapper with a window hook on each render to
//! sample again while retaining the animated entity. A changed goal starts
//! from the current presentation; [`Transition::continuous`] can instead
//! restart from the initial value. The hook that owns this state must keep a
//! stable key across renders; see
//! [`Window::use_keyed_transition`](crate::Window::use_keyed_transition).
//! This value-transition API does not consult reduced-motion preferences;
//! style-property transitions have their own reduced-motion handling.

use std::{
    cell::{Ref, RefCell},
    time::Instant,
};

use crate::{Animated, App, Entity, EntityId, Motion, Progress, Window, lerp::Lerp};

#[derive(Clone)]
struct TransitionCache<T> {
    value: Option<T>,
    progress: Progress,
    is_active: bool,
}

impl<T> TransitionCache<T> {
    fn empty() -> Self {
        Self {
            value: None,
            progress: Progress::END,
            is_active: false,
        }
    }

    fn clear(&mut self) {
        self.value = None;
    }
}

/// A value that moves toward a changing goal, with one cached sample per wrapper.
///
/// Obtain a fresh wrapper from [`Window::use_keyed_transition`] during each
/// render. The window retains the [`Animated`] entity under that key; the
/// wrapper holds the motion for the next changed goal and a cache for this
/// render. Call [`update`](Self::update) to set the goal, then
/// [`evaluate`](Self::evaluate) to paint its current presentation. An active
/// sample requests another frame.
///
/// Goal and presentation are different values. If opacity is halfway from
/// zero to one, [`read_goal`](Self::read_goal) returns one while `evaluate`
/// returns about one half. Changing the goal then starts from that half,
/// avoiding a jump back to zero. With [`.continuous(false)`](Self::continuous),
/// each changed goal instead starts from the state's original value.
///
/// # Example
///
/// This render helper retains opacity independently of the element that uses
/// it. The first call starts at zero; later calls keep the same animated state.
///
/// ```
/// use std::time::Duration;
/// use gpui::{App, Window, ease_in_out};
///
/// fn opacity(window: &mut Window, cx: &mut App, visible: bool) -> f32 {
///     let transition = window
///         .use_keyed_transition("opacity", cx, Duration::from_millis(300), |_, _| 0.0_f32)
///         .with_easing(ease_in_out);
///     let goal = if visible { 1.0 } else { 0.0 };
///     if cx.reduce_motion() {
///         transition.jump_to(goal, cx);
///     } else {
///         transition.update(cx, |value, _| *value = goal);
///     }
///     let value = *transition.evaluate(window, cx);
///     value
/// }
/// ```
///
/// This API does not apply reduced motion itself. The helper checks the
/// preference and presents the target immediately when requested.
///
/// # State and clock
///
/// Updating a goal outside rendering requires a notification to start drawing;
/// see [`update`](Self::update). Retaining the same wrapper across frames also
/// retains its cached sample. Cloning shares the animated entity but copies
/// the cache: a mutation through one wrapper does not clear another's sample.
/// Prefer one fresh wrapper per render over storing it on the view.
/// Drop sample and cache borrows before changing that wrapper: its cache uses
/// [`RefCell`], so a conflicting write panics.
///
/// Sampling uses [`std::time::Instant`], not the app executor's test clock.
/// Use [`Animated`] with an explicit clock to test exact interpolation times,
/// or an [animation element](crate::AnimationExt) for executor-clock playback.
/// The [animation chapter](crate::_documentation::animation) compares these
/// adapters and their ownership rules.
#[derive(Clone)]
pub struct Transition<T: Lerp + Clone + PartialEq + 'static> {
    motion: Motion,

    state: Entity<TransitionState<T>>,

    /// The transition sample cached for this render.
    cache: RefCell<TransitionCache<T>>,

    /// Whether to continue the transition from the current value when the goal changes.
    /// If true, transitions smoothly from current animated value to new goal.
    /// If false, restarts from the original start value.
    continuous: bool,
}

impl<T: Lerp + Clone + PartialEq + 'static> Transition<T> {
    /// Wraps an existing animated entity with an empty sample cache.
    ///
    /// `motion` applies to the next changed goal. It does not replace a run
    /// already stored in `state`. The initial value restored by [`Self::reset`]
    /// also belongs to that state, not to this wrapper. Prefer
    /// [`Window::use_keyed_transition`] when the state should follow a
    /// rendered element's lifetime.
    pub fn new(state: Entity<TransitionState<T>>, motion: impl Into<Motion>) -> Self {
        Self {
            motion: motion.into(),
            state,
            cache: RefCell::new(TransitionCache::empty()),
            continuous: true,
        }
    }

    /// Sets forward easing for the next changed goal and clears this wrapper's cache.
    ///
    /// The easing function maps normalized local pass time to presentation
    /// progress, which may be non-monotonic or overshoot zero through one.
    /// An existing run keeps its original motion. Updating to an equal goal
    /// does not start a run with the new easing.
    pub fn with_easing(mut self, easing: impl Fn(f32) -> f32 + 'static) -> Self {
        self.motion = self.motion.with_easing(easing);
        self.clear_cache();
        self
    }

    /// Chooses whether a changed goal starts from the current presentation.
    ///
    /// When `continuous` is `true` (the default), the next run starts from the
    /// value currently presented. When `false`, it starts from the value that
    /// initialized the animated state. This only affects changed goals.
    pub fn continuous(mut self, continuous: bool) -> Self {
        self.continuous = continuous;
        self
    }

    fn sample(&self, cx: &mut App) -> Ref<'_, TransitionCache<T>> {
        if self.cache.borrow().value.is_none() {
            let mut state = self.state.as_mut(cx);
            let sample = state.sample(Instant::now());

            *self.cache.borrow_mut() = TransitionCache {
                value: Some(sample.value),
                progress: sample.progress,
                is_active: sample.is_active,
            };
        }

        self.cache.borrow()
    }

    fn clear_cache(&self) {
        self.cache.borrow_mut().clear();
    }

    /// Returns the wrapper's cached sample, computing it on first access.
    ///
    /// An active sample requests another animation frame for the view currently
    /// being drawn. Recreate the wrapper through a window hook on each render;
    /// merely retaining this wrapper across frames does not clear its cache.
    /// A changed goal and the mutation methods also clear this wrapper's cache.
    /// Drop the returned borrow before mutating the transition.
    ///
    /// # Panics
    ///
    /// Panics on a conflicting cache borrow, such as evaluating an empty cache
    /// while holding the result of [`Self::read_cache`].
    pub fn evaluate(&self, window: &mut Window, cx: &mut App) -> Ref<'_, T> {
        let sample = self.sample(cx);
        if sample.is_active {
            window.request_animation_frame();
        }

        Ref::map(sample, |sample| sample.value.as_ref().unwrap())
    }

    /// Borrows the logical target, which may differ from the value currently painted.
    pub fn read_goal<'b>(&'b self, cx: &'b mut App) -> &'b T {
        self.state.read(cx).value()
    }

    /// Borrows this wrapper's last sample, or `None` before it has sampled.
    ///
    /// This does not advance the animation or request a frame. A changed goal,
    /// [`Self::with_easing`], [`Self::jump_to`], [`Self::scale_by`], or
    /// [`Self::reset`] clears this cache. Drop the borrow before an operation
    /// that needs to write the cache.
    pub fn read_cache(&self) -> Ref<'_, Option<T>> {
        Ref::map(self.cache.borrow(), |cache| &cache.value)
    }

    /// Returns eased presentation progress, which may overshoot zero through one.
    /// This does not indicate whole-run completion: restarting iterations begin
    /// again and alternating iterations run in reverse.
    ///
    /// Uses the cached sample's progress when present. Otherwise it reads
    /// progress at the current wall-clock time without filling the cache,
    /// settling the animated state, or requesting a frame. The two paths can
    /// therefore refer to different sampling times.
    pub fn evaluate_delta(&self, cx: &App) -> f32 {
        if self.cache.borrow().value.is_some() {
            return self.cache.borrow().progress.get();
        }

        self.state.read(cx).progress_at(Instant::now()).get()
    }

    /// Edits a copy of the logical goal and starts a run if the result differs.
    ///
    /// The closure's return value is discarded. A changed goal uses this
    /// wrapper's motion, clears its cache, and returns `true`. An equal goal
    /// returns `false` without changing the run or cache, even if this wrapper
    /// has a different motion. [`Self::continuous`] selects the new run's origin.
    ///
    /// This does not notify. During rendering, the following
    /// [`evaluate`](Self::evaluate) schedules frames while the sample is active.
    /// For an update outside rendering, call `cx.notify()` inside this closure
    /// to notify the animated entity. A window hook observes that entity and
    /// invalidates the view that created it. A manually constructed transition
    /// needs its own observation or an explicit notification of its owning view.
    ///
    /// # Panics
    ///
    /// Panics if the goal changes while a sample or cache borrow is held.
    pub fn update<R>(
        &self,
        cx: &mut App,
        update: impl FnOnce(&mut T, &mut crate::Context<TransitionState<T>>) -> R,
    ) -> bool {
        let mut was_updated = false;

        self.state.update(cx, |state, cx| {
            let mut value = state.value().clone();
            update(&mut value, cx);
            was_updated = if self.continuous {
                state.set(value, &self.motion, Instant::now())
            } else {
                state.restart(value, &self.motion, Instant::now())
            };
        });

        if was_updated {
            self.clear_cache();
        }

        was_updated
    }

    /// Presents `target` immediately and cancels the active animation.
    ///
    /// Subsequent evaluations return `target` until the next changed goal.
    /// Use this for an immediate reset or a reduced-motion presentation.
    /// The original value restored by [`reset`](Self::reset) is unchanged.
    /// This does not notify observers.
    ///
    /// # Panics
    ///
    /// Panics if a sample or cache borrow is held.
    pub fn jump_to(&self, target: T, cx: &mut App) {
        self.state.update(cx, |state, _cx| state.jump_to(target));
        self.clear_cache();
    }

    /// Multiplies the presentation anchor and logical goal by `ratio`.
    ///
    /// For linearly interpolated coordinates, scaling both endpoints preserves
    /// the relative progress of an in-flight animation after a resize. The
    /// operation does not validate `ratio`; choose a finite value suitable for
    /// `T`'s multiplication and interpolation. The original value restored by
    /// [`reset`](Self::reset) is unchanged. This does not notify observers.
    ///
    /// # Panics
    ///
    /// Panics if a sample or cache borrow is held.
    pub fn scale_by(&self, ratio: f32, cx: &mut App)
    where
        T: std::ops::Mul<f32, Output = T>,
    {
        self.state.update(cx, |state, _cx| state.scale_by(ratio));
        self.clear_cache();
    }

    /// Returns the animated entity's identity, shared by all its wrappers.
    ///
    /// This identifies retained state, not a sample, goal, or element ID.
    pub fn entity_id(&self) -> EntityId {
        self.state.entity_id()
    }

    /// Restores the animated state's original value and ends the current run.
    ///
    /// This also undoes [`Self::jump_to`] and [`Self::scale_by`]. The wrapper's
    /// cache is cleared; observers are not notified.
    ///
    /// # Panics
    ///
    /// Panics if a sample or cache borrow is held.
    pub fn reset(&self, cx: &mut App) {
        self.state.update(cx, |state, _cx| state.reset());
        self.clear_cache();
    }
}

/// The animated value retained by [`Window::use_keyed_transition`].
pub type TransitionState<T> = Animated<T, Instant>;

#[cfg(all(test, feature = "headless"))]
mod tests {
    use std::cell::RefCell;
    use std::rc::Rc;
    use std::time::Duration;

    use crate::{AppContext, Context, IntoElement, Render, canvas, px, size};

    use super::*;
    use gpui::TestAppContext;

    /// Helper to create a Transition directly without using window hooks.
    /// This bypasses the render-phase restriction of use_transition/use_keyed_transition.
    fn create_transition<T: Lerp + Clone + PartialEq + 'static>(
        cx: &mut App,
        motion: impl Into<Motion>,
        initial: T,
    ) -> Transition<T> {
        let motion = motion.into();
        let state = cx.new(|_| TransitionState::new(initial, motion.clone()));
        Transition::new(state, motion)
    }

    struct TransitionTestView {
        transition: Transition<f32>,
        rendered_values: Rc<RefCell<Vec<f32>>>,
    }

    #[gpui::test]
    fn unkeyed_hooks_use_distinct_caller_locations_and_retain_state(cx: &mut TestAppContext) {
        struct Hooks {
            seen: Rc<RefCell<Vec<[EntityId; 2]>>>,
        }
        impl Render for Hooks {
            fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
                let first = window.use_transition(cx, Duration::from_secs(1), |_, _| 2.0_f32);
                let second = window.use_transition(cx, Duration::from_secs(1), |_, _| 7.0_f32);
                assert_eq!(*first.read_goal(cx), 2.0);
                assert_eq!(*second.read_goal(cx), 7.0);
                self.seen
                    .borrow_mut()
                    .push([first.entity_id(), second.entity_id()]);
                crate::Empty
            }
        }
        let seen = Rc::new(RefCell::new(Vec::new()));
        let window = cx.open_window(size(px(100.0), px(100.0)), {
            let seen = seen.clone();
            move |_, _| Hooks { seen }
        });
        cx.run_until_parked();
        window.update(cx, |_, _, cx| cx.notify()).unwrap();
        cx.run_until_parked();
        let seen = seen.borrow();
        assert!(seen.len() >= 2);
        assert_ne!(seen[0][0], seen[0][1]);
        assert!(seen.iter().all(|ids| *ids == seen[0]));
    }

    impl Render for TransitionTestView {
        fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
            let transition = self.transition.clone();
            let rendered_values = self.rendered_values.clone();
            canvas(
                move |_, window, cx| {
                    rendered_values
                        .borrow_mut()
                        .push(*transition.evaluate(window, cx));
                },
                |_, _, _, _| {},
            )
        }
    }

    #[gpui::test]
    fn transition_exercises_state_updates_and_cache(cx: &mut TestAppContext) {
        cx.update(|cx| {
            let transition =
                create_transition(cx, Duration::from_secs(1), 0.0_f32).with_easing(|_| 0.5);

            assert!(transition.read_cache().is_none());
            assert!(transition.update(cx, |value, _| *value = 100.0));
            assert_eq!(*transition.read_goal(cx), 100.0);
            let entity_id = transition.entity_id();
            assert_eq!(entity_id, transition.entity_id());

            let value1 = *transition.sample(cx).value.as_ref().unwrap();
            let value2 = *transition.sample(cx).value.as_ref().unwrap();
            assert_eq!((value1, value2), (50.0, 50.0));
            assert_eq!(transition.evaluate_delta(cx), 0.5);

            assert!(!transition.update(cx, |value, _| *value = 100.0));
            assert!(transition.read_cache().is_some());
            assert!(transition.update(cx, |value, _| *value = 200.0));
            assert!(transition.read_cache().is_none());

            let transition = transition.with_easing(|_| 0.75);
            assert!(transition.read_cache().is_none());
            assert_eq!(*transition.sample(cx).value.as_ref().unwrap(), 125.0);
            assert_eq!(transition.evaluate_delta(cx), 0.5);

            let motion = Motion::new(Duration::from_secs(1)).with_easing(|_| 0.5);
            let continuous = create_transition(cx, motion.clone(), 0.0_f32);
            let restarting = create_transition(cx, motion, 0.0_f32).continuous(false);

            for transition in [&continuous, &restarting] {
                assert!(transition.update(cx, |value, _| *value = 100.0));
                assert_eq!(*transition.sample(cx).value.as_ref().unwrap(), 50.0);
            }

            assert!(continuous.update(cx, |value, _| *value = 200.0));
            assert!(restarting.update(cx, |value, _| *value = 200.0));

            assert_eq!(*continuous.sample(cx).value.as_ref().unwrap(), 125.0);
            assert_eq!(*restarting.sample(cx).value.as_ref().unwrap(), 100.0);

            let motion = Motion::new(Duration::from_secs(1)).with_easing(|_| 0.5);
            let mutators = create_transition(cx, motion, 2.0_f32);

            assert!(mutators.update(cx, |value, _| *value = 10.0));
            assert_eq!(*mutators.sample(cx).value.as_ref().unwrap(), 6.0);

            mutators.scale_by(2.0, cx);
            assert_eq!(*mutators.read_goal(cx), 20.0);
            assert_eq!(*mutators.sample(cx).value.as_ref().unwrap(), 12.0);

            mutators.jump_to(7.0, cx);
            assert_eq!(*mutators.read_goal(cx), 7.0);
            assert_eq!(*mutators.sample(cx).value.as_ref().unwrap(), 7.0);

            mutators.reset(cx);
            assert_eq!(*mutators.read_goal(cx), 2.0);
            assert!(mutators.read_cache().is_none());

            let alternating = create_transition(
                cx,
                Motion::new(Duration::ZERO).iterations(2).alternate(),
                0.0_f32,
            );
            assert!(alternating.update(cx, |value, _| *value = 100.0));
            let sample = alternating.sample(cx);
            assert_eq!(sample.value, Some(0.0));
            assert_eq!(sample.progress, Progress::START);
            assert!(!sample.is_active);
            drop(sample);
            assert_eq!(alternating.evaluate_delta(cx), 0.0);
        });
    }

    #[gpui::test]
    fn evaluate_uses_samples_and_requests_frames_while_active(cx: &mut TestAppContext) {
        let transition = cx.update(|cx| {
            create_transition(
                cx,
                Motion::new(Duration::from_secs(1)).with_easing(|_| 0.5),
                0.0_f32,
            )
        });
        cx.update(|cx| {
            assert!(transition.update(cx, |value, _| *value = 100.0));
        });
        let rendered_values = Rc::new(RefCell::new(Vec::new()));
        let window = cx.open_window(size(px(100.0), px(100.0)), {
            let transition = transition.clone();
            let rendered_values = rendered_values.clone();
            move |_, _| TransitionTestView {
                transition,
                rendered_values,
            }
        });
        cx.run_until_parked();

        assert_eq!(*rendered_values.borrow(), vec![50.0]);
        cx.update(|cx| transition.jump_to(100.0, cx));
        assert_eq!(
            window
                .update(cx, |_, window, cx| window.simulate_next_frame(cx))
                .unwrap(),
            1
        );
        cx.run_until_parked();

        assert_eq!(*rendered_values.borrow(), vec![50.0, 100.0]);
        assert_eq!(
            window
                .update(cx, |_, window, cx| window.simulate_next_frame(cx))
                .unwrap(),
            0
        );
    }
}
