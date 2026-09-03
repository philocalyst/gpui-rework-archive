//! Test support for GPUI.
//!
//! GPUI provides first-class support for testing, which includes a macro to run test that rely on having a context,
//! and a test implementation of the `ForegroundExecutor` and `BackgroundExecutor` which ensure that your tests run
//! deterministically even in the face of arbitrary parallelism.
//!
//! The output of the `gpui::test` macro is understood by other rust test runners, so you can use it with `cargo test`
//! or `cargo-nextest`, or another runner of your choice.
//!
//! To make it possible to test collaborative user interfaces (like Zed) you can ask for as many different contexts
//! as you need.
//!
//! ## Example
//!
//! ```
//! use gpui;
//!
//! #[gpui::test]
//! async fn test_example(cx: &TestAppContext) {
//!   assert!(true)
//! }
//!
//! #[gpui::test]
//! async fn test_collaboration_example(cx_a: &TestAppContext, cx_b: &TestAppContext) {
//!   assert!(true)
//! }
//! ```
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

    let empty_range = || 0..0;

    let iter = {
        let env_range = if let Some(env_num) = env_num {
            env_num..env_num + 1
        } else {
            empty_range()
        };

        // if `iterations` is 1 and !(`explicit_seeds` is non-empty || `SEED` is set), then add     the run `0`
        // if `iterations` is 1 and  (`explicit_seeds` is non-empty || `SEED` is set), then discard the run `0`
        // if `iterations` isn't 1 and `SEED` is set, do `SEED..SEED+iterations`
        // otherwise, do `0..iterations`
        let iterations_range = match (iterations, env_num) {
            (1, None) if explicit_seeds.is_empty() => 0..1,
            (1, None) | (1, Some(_)) => empty_range(),
            (iterations, Some(env)) => env..env + iterations,
            (iterations, None) => 0..iterations,
        };

        // if `SEED` is set, ignore `explicit_seeds`
        let explicit_seeds = if env_num.is_some() {
            &[]
        } else {
            explicit_seeds
        };

        // With `SEED` set and `iterations > 1`, `env_range` (`SEED..SEED+1`) and
        // `iterations_range` (`SEED..SEED+iterations`) intentionally overlap, so the
        // seed is emitted twice: once as the env pin and once as the first iteration.
        env_range
            .chain(iterations_range)
            .chain(explicit_seeds.iter().copied())
    };
    let is_multiple_runs = iter.clone().nth(1).is_some();
    (iter, is_multiple_runs)
}

/// A test struct for converting an observation callback into a stream.
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

/// observe returns a stream of the change events from the given `Entity`
pub fn observe<T: 'static>(entity: &Entity<T>, cx: &mut TestAppContext) -> Observation<()> {
    let (tx, rx) = async_channel::unbounded();
    let _subscription = cx.update(|cx| {
        cx.observe(entity, move |_, _| {
            let _ = gpui::block_on(tx.send(()));
        })
    });
    let rx = Box::pin(rx);

    Observation { rx, _subscription }
}

#[cfg(test)]
mod tests {
    use super::*;
    use proptest::strategy::ValueTree;
    use std::sync::{Arc, Mutex};

    /// Serializes `SEED`/`ITERATIONS` env-var mutation between the seed tests in
    /// this module. Only these tests mutate env vars, and every one restores the
    /// previous values on exit (including unwinds), so the window during which other
    /// `#[gpui::test]` cases could observe a synthetic `SEED` stays as small as
    /// possible.
    static ENV_LOCK: Mutex<()> = Mutex::new(());

    /// Captures the previous `SEED`/`ITERATIONS` values (if any) and clears
    /// them, restoring them on drop.
    struct EnvResetGuard {
        seed: Option<String>,
        iterations: Option<String>,
    }

    impl EnvResetGuard {
        fn take() -> Self {
            let guard = Self {
                seed: env::var("SEED").ok(),
                iterations: env::var("ITERATIONS").ok(),
            };
            unsafe {
                env::remove_var("SEED");
                env::remove_var("ITERATIONS");
            }
            guard
        }

        fn set_seed(&self, value: &str) {
            unsafe {
                env::set_var("SEED", value);
            }
        }

        fn clear_seed(&self) {
            unsafe {
                env::remove_var("SEED");
            }
        }
    }

    impl Drop for EnvResetGuard {
        fn drop(&mut self) {
            unsafe {
                match &self.seed {
                    Some(value) => env::set_var("SEED", value),
                    None => env::remove_var("SEED"),
                }
                match &self.iterations {
                    Some(value) => env::set_var("ITERATIONS", value),
                    None => env::remove_var("ITERATIONS"),
                }
            }
        }
    }

    fn record_seeds(
        guard: &EnvResetGuard,
        iterations: usize,
        explicit: &[u64],
        set_seed: Option<&str>,
    ) -> Vec<u64> {
        match set_seed {
            Some(value) => guard.set_seed(value),
            None => guard.clear_seed(),
        }
        let seen = Arc::new(Mutex::new(Vec::new()));
        run_test(
            iterations,
            explicit,
            0,
            &mut {
                let seen = Arc::clone(&seen);
                move |_dispatcher, seed| seen.lock().unwrap().push(seed)
            },
            None,
        );
        seen.lock().unwrap().clone()
    }

    #[test]
    fn run_test_seed_selection_default_and_explicit() {
        let _lock = ENV_LOCK
            .lock()
            .unwrap_or_else(|poisoned| poisoned.into_inner());
        let guard = EnvResetGuard::take();

        assert_eq!(record_seeds(&guard, 1, &[], None), [0]);
        assert_eq!(record_seeds(&guard, 3, &[], None), [0, 1, 2]);
        assert_eq!(record_seeds(&guard, 3, &[10, 20], None), [0, 1, 2, 10, 20]);
    }

    #[test]
    fn run_test_seed_env_pins_and_overrides_explicit() {
        let _lock = ENV_LOCK
            .lock()
            .unwrap_or_else(|poisoned| poisoned.into_inner());
        let guard = EnvResetGuard::take();

        assert_eq!(record_seeds(&guard, 1, &[7], Some("42")), [42]);
        assert_eq!(record_seeds(&guard, 3, &[7], Some("42")), [42, 42, 43, 44]);
    }

    #[test]
    fn seed_env_bridges_proptest_config_and_strategy() {
        let _lock = ENV_LOCK
            .lock()
            .unwrap_or_else(|poisoned| poisoned.into_inner());
        let guard = EnvResetGuard::take();

        guard.clear_seed();
        assert_eq!(
            apply_seed_to_proptest_config(proptest::test_runner::Config::default()).rng_seed,
            proptest::test_runner::RngSeed::Fixed(0)
        );
        guard.set_seed("42");
        assert_eq!(
            apply_seed_to_proptest_config(proptest::test_runner::Config::default()).rng_seed,
            proptest::test_runner::RngSeed::Fixed(42)
        );
        let mut runner =
            proptest::test_runner::TestRunner::new(proptest::test_runner::Config::default());
        let value = seed_strategy().new_tree(&mut runner).unwrap().current();
        assert_eq!(value, 42);
    }

    #[gpui::property_test]
    fn calculate_seeds_replay_is_deterministic(
        #[strategy = 0usize..64] iterations: usize,
        #[strategy = ::gpui::proptest::collection::vec(0u64..1000u64, 0..8)] explicit: Vec<u64>,
    ) {
        // The same inputs (including whatever `SEED`/`ITERATIONS` the environment pins)
        // must reproduce the same seed vector, so a failing seed can be replayed.
        let (first, _) = calculate_seeds(iterations as u64, &explicit);
        let (second, _) = calculate_seeds(iterations as u64, &explicit);
        assert_eq!(first.collect::<Vec<_>>(), second.collect::<Vec<_>>());
    }
}
