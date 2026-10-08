//! Seeded async tests and observation streams.
//!
//! `#[gpui::test]` constructs a [`TestAppContext`] for each context argument.
//! The applications have separate state but share a scheduler and test clock.
//! Their foreground and background tasks are polled in an order selected by
//! the scheduler seed. Use `iterations`, `seed`, or `seeds(...)` to choose the
//! schedules to exercise; rerun a failure with the reported `SEED` value.
//!
//! The macro emits an ordinary Rust test, usable with Cargo or nextest.
//! Its async runner polls the test future on the controlled foreground
//! executor. This example waits for a notification rather than sleeping or
//! assuming the task ran immediately:
//!
//! ```rust,test_harness
//! use futures::StreamExt as _;
//! use gpui::{AppContext as _, TestAppContext};
//!
//! #[gpui::test]
//! async fn task_publishes_a_change(cx: &mut TestAppContext) {
//!     let count = cx.new(|_| 0_u32);
//!     let mut changes = gpui::observe(&count, cx);
//!     let task = cx.spawn({
//!         let count = count.clone();
//!         |mut cx| async move {
//!             count.update(&mut cx, |count, cx| {
//!                 *count = 3;
//!                 cx.notify();
//!             });
//!         }
//!     });
//!
//!     assert_eq!(changes.next().await, Some(()));
//!     task.await;
//!     assert_eq!(count.read_with(cx, |count, _| *count), 3);
//! }
//! ```
//!
//! Retain a task to keep it running and retain a subscription to keep it
//! observing. [`observe`] packages a subscription with its stream so dropping
//! the stream unsubscribes. See the [testing guide](https://gpui-ce.github.io/book/testing.html)
//! for timer boundaries, cancellation, input, and platform checks.
use crate::{Entity, Subscription, TestAppContext, TestDispatcher};
use futures::StreamExt as _;
use proptest::prelude::{Just, Strategy, any};
use std::{
    env,
    panic::{self, RefUnwindSafe, UnwindSafe},
    pin::Pin,
};

/// Strategy injected into `#[gpui::property_test]` tests to control the seed
/// given to the scheduler. Doesn't shrink, since all scheduler seeds are
/// equivalent in complexity. If `$SEED` is set, it always uses that value.
///
/// Note: this function is not intended to be used directly. Rather, it is
/// public so that it can be used from the `property_test` macro.
pub fn seed_strategy() -> impl Strategy<Value = u64> {
    match std::env::var("SEED") {
        Ok(val) => Just(val.parse().unwrap()).boxed(),
        Err(_) => any::<u64>().no_shrink().boxed(),
    }
}

/// Applies a fixed RNG seed to a proptest config so that case generation
/// is deterministic. Uses `$SEED` if set, otherwise defaults to `0`.
/// This bridges the GPUI `SEED` env var to proptest's RNG seed, so that
/// a single variable controls both the scheduler seed and case generation.
///
/// Note: this function is not intended to be used directly. Rather, it is
/// public so that it can be used from the `property_test` macro.
pub fn apply_seed_to_proptest_config(
    mut config: proptest::test_runner::Config,
) -> proptest::test_runner::Config {
    let seed = env::var("SEED")
        .ok()
        .and_then(|val| val.parse::<u64>().ok())
        .unwrap_or(0);
    config.rng_seed = proptest::test_runner::RngSeed::Fixed(seed);
    config
}

/// Similar to [`run_test`], but only runs the callback once, allowing
/// [`FnOnce`] callbacks. This is intended for use with the
/// `gpui::property_test` macro and generally should not be used directly.
///
/// Doesn't support many features of [`run_test`], since these are provided by
/// proptest.
pub fn run_test_once<R>(
    seed: u64,
    test_fn: Box<dyn UnwindSafe + FnOnce(TestDispatcher) -> R>,
) -> R {
    let result = panic::catch_unwind(|| {
        let dispatcher = TestDispatcher::new(seed);
        let scheduler = dispatcher.scheduler().clone();
        let res = test_fn(dispatcher);
        scheduler.end_test();
        res
    });

    match result {
        Ok(r) => r,
        Err(e) => panic::resume_unwind(e),
    }
}

/// Run the given test function with the configured parameters.
/// This is intended for use with the `gpui::test` macro
/// and generally should not be used directly.
pub fn run_test(
    num_iterations: usize,
    explicit_seeds: &[u64],
    max_retries: usize,
    test_fn: &mut (dyn RefUnwindSafe + Fn(TestDispatcher, u64)),
    on_fail_fn: Option<fn()>,
) {
    let (seeds, is_multiple_runs) = calculate_seeds(num_iterations as u64, explicit_seeds);

    for seed in seeds {
        let mut attempt = 0;
        loop {
            if is_multiple_runs {
                eprintln!("seed = {seed}");
            }
            let result = panic::catch_unwind(|| {
                let dispatcher = TestDispatcher::new(seed);
                let scheduler = dispatcher.scheduler().clone();
                test_fn(dispatcher, seed);
                scheduler.end_test();
            });

            match result {
                Ok(_) => break,
                Err(error) => {
                    if attempt < max_retries {
                        println!("attempt {} failed, retrying", attempt);
                        attempt += 1;
                        // The panic payload might itself trigger an unwind on drop:
                        // https://doc.rust-lang.org/std/panic/fn.catch_unwind.html#notes
                        std::mem::forget(error);
                    } else {
                        if is_multiple_runs {
                            eprintln!("failing seed: {seed}");
                            eprintln!(
                                "You can rerun from this seed by setting the environmental variable SEED to {seed}"
                            );
                        }
                        if let Some(on_fail_fn) = on_fail_fn {
                            on_fail_fn()
                        }
                        panic::resume_unwind(error);
                    }
                }
            }
        }
    }
}

fn calculate_seeds(
    iterations: u64,
    explicit_seeds: &[u64],
) -> (impl Iterator<Item = u64> + '_, bool) {
    let iterations = env::var("ITERATIONS")
        .ok()
        .map(|var| var.parse().expect("invalid ITERATIONS variable"))
        .unwrap_or(iterations);

    let env_num = env::var("SEED")
        .map(|seed| seed.parse().expect("invalid SEED variable as integer"))
        .ok();

    let iter = seed_sequence(iterations, explicit_seeds, env_num);
    let is_multiple_runs = iter.clone().nth(1).is_some();
    (iter, is_multiple_runs)
}

fn seed_sequence(
    iterations: u64,
    explicit_seeds: &[u64],
    environment_seed: Option<u64>,
) -> impl Iterator<Item = u64> + Clone + '_ {
    let range = match (iterations, environment_seed) {
        (1, None) if !explicit_seeds.is_empty() => 0..0,
        (iterations, Some(start)) => start..start + iterations,
        (iterations, None) => 0..iterations,
    };
    let explicit_seeds = if environment_seed.is_some() {
        &[][..]
    } else {
        explicit_seeds
    };
    range.chain(explicit_seeds.iter().copied())
}

#[cfg(test)]
mod seed_tests {
    use super::seed_sequence;

    #[test]
    fn environment_seed_starts_one_sequence_without_duplicate_first_run() {
        assert_eq!(
            seed_sequence(3, &[80], Some(17)).collect::<Vec<_>>(),
            [17, 18, 19]
        );
        assert_eq!(seed_sequence(1, &[80], Some(17)).collect::<Vec<_>>(), [17]);
    }

    #[test]
    fn explicit_seeds_replace_default_run_or_extend_iteration_range() {
        assert_eq!(seed_sequence(1, &[], None).collect::<Vec<_>>(), [0]);
        assert_eq!(
            seed_sequence(1, &[17, 80], None).collect::<Vec<_>>(),
            [17, 80]
        );
        assert_eq!(
            seed_sequence(3, &[80], None).collect::<Vec<_>>(),
            [0, 1, 2, 80]
        );
    }
}

/// A stream of entity-change notifications that owns its observation
/// subscription.
///
/// Dropping the stream unsubscribes. Notifications are signals rather than
/// snapshots: read the entity after each item to observe its current state.
pub struct Observation<T> {
    rx: Pin<Box<async_channel::Receiver<T>>>,
    _subscription: Subscription,
}

impl<T: 'static> futures::Stream for Observation<T> {
    type Item = T;

    fn poll_next(
        mut self: std::pin::Pin<&mut Self>,
        cx: &mut std::task::Context<'_>,
    ) -> std::task::Poll<Option<Self::Item>> {
        self.rx.poll_next_unpin(cx)
    }
}

/// Observes changes to an entity as a stream of unit notifications.
///
/// The returned [`Observation`] keeps the underlying subscription alive; drop
/// it to stop observing. Each notification indicates that the entity changed,
/// so read the entity to obtain its state.
pub fn observe<T: 'static>(entity: &Entity<T>, cx: &mut TestAppContext) -> Observation<()> {
    let (tx, rx) = async_channel::unbounded();
    let _subscription = cx.update(|cx| {
        cx.observe(entity, move |_, _| {
            // This channel is unbounded, so notification never needs an executor.
            let _ = tx.try_send(());
        })
    });
    let rx = Box::pin(rx);

    Observation { rx, _subscription }
}

#[cfg(test)]
mod tests {
    use super::observe;
    use crate::{AppContext as _, TestAppContext};
    use futures::StreamExt as _;

    #[gpui::test]
    async fn observation_stream_receives_each_notify_and_unsubscribes_on_drop(
        cx: &mut TestAppContext,
    ) {
        let counter = cx.update(|cx| cx.new(|_| 0usize));
        let mut observation = observe(&counter, cx);

        for expected in 1..=2 {
            counter.update(cx, |value, cx| {
                *value = expected;
                cx.notify();
            });

            assert_eq!(observation.next().await, Some(()));
            assert_eq!(counter.read_with(cx, |value, _| *value), expected);
        }

        drop(observation);

        // A post-drop notification is safe even though the receiver has been discarded.
        counter.update(cx, |value, cx| {
            *value = 3;
            cx.notify();
        });
        assert_eq!(counter.read_with(cx, |value, _| *value), 3);
    }
}
