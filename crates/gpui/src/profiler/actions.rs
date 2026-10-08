use std::time::Duration;

use itertools::Itertools;
use scheduler::Instant;

#[cfg(feature = "profiler")]
use crate::action::Action;

#[doc(hidden)]
#[derive(Clone)]
/// Legacy action-handler timing sample, including its currently active handler.
///
/// [`take_action_stats`] returns the process-wide sample. Its single active
/// slot assumes sequential action dispatch; use the foreground journal for
/// measurements that must distinguish concurrent test applications.
pub struct ActionStatistics {
    runtime_to_beat: Duration,

    longest_runtimes: heapless::Vec<ActionTiming, 5>,
    running: Option<(&'static str, Instant)>,
}

impl std::fmt::Debug for ActionStatistics {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("ActionStatistics")
            .field("runtime_to_beat", &self.runtime_to_beat)
            .field("longest_runtimes", &self.longest_runtimes)
            .field(
                "running",
                &self.running.map(|(id, started)| (id, started.elapsed())),
            )
            .finish()
    }
}

impl std::fmt::Display for ActionStatistics {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str("Actions that blocked the longest\n")?;
        for action in self
            .longest_runtimes(true)
            .sorted_by_key(|action| action.runtime())
            .rev()
        {
            f.write_fmt(format_args!(
                "{:<20} - {}",
                format!("{:?}", action.runtime()), // impl dbg does not support alignment
                action.name
            ))?;
            writeln!(f)?;
        }
        Ok(())
    }
}

impl Default for ActionStatistics {
    fn default() -> Self {
        Self::new()
    }
}

impl ActionStatistics {
    const fn new() -> Self {
        Self {
            // This keeps more calls on the fast path by only tracking
            // problematic polls
            runtime_to_beat: Duration::from_micros(100),
            longest_runtimes: heapless::Vec::new(),
            running: None,
        }
    }

    /// Takes the collected long-running actions and resets the collection.
    ///
    /// An action currently running at the time of the call remains marked as
    /// running in the reset statistics, so its eventual completion can still
    /// be recorded.
    pub fn take(&mut self) -> Self {
        let taken = std::mem::take(self);
        self.running = taken.running;
        taken
    }

    /// Returns whether any completed action timings are retained.
    pub fn is_empty(&self) -> bool {
        self.longest_runtimes.is_empty()
    }

    /// Marks the action whose handler is currently running.
    ///
    /// With the profiler feature enabled, completed actions are retained only
    /// when they are among the five longest and take at least 100 microseconds.
    #[cfg(feature = "profiler")]
    pub fn update_running_action(&mut self, action: &'static str, started: Instant) {
        self.running = Some((action, started));
    }
    /// No-op when profiling support is disabled.
    #[cfg(not(feature = "profiler"))]
    pub fn update_running_action(&mut self, _action: &'static str, _started: Instant) {}

    /// Records the end time of the currently marked action when profiling is
    /// enabled. Concurrent test execution may leave no current action, in
    /// which case this is a no-op.
    #[cfg(feature = "profiler")]
    pub fn save_action_timing(&mut self) {
        self.save_action_timing_at(Instant::now());
    }

    #[cfg(feature = "profiler")]
    fn save_action_timing_at(&mut self, now: Instant) {
        let Some((action, started)) = self.running.take() else {
            // Actions are ran only on the foreground executor and therefore
            // sequentially _except_ in tests where they can run concurrently.
            //
            // When ran sequentially self.running will always be Some. When ran
            // concurrently that is no longer true. But that is fine, we do not
            // need to track action timings in tests.
            super::cold_path();
            return;
        };

        let timing = ActionTiming {
            name: action,
            start: started,
            end: now,
        };

        let runtime = now.duration_since(started);
        if runtime >= self.runtime_to_beat {
            super::cold_path(); // most actions are not the worst, optimize for that

            if self.longest_runtimes.is_full()
                && let Some(to_replace) = self
                    .longest_runtimes
                    .iter_mut()
                    .min_by_key(|action| action.runtime())
            {
                *to_replace = timing;
            } else {
                self.longest_runtimes
                    .push(timing)
                    .expect("just checked it is not full");
            };

            self.runtime_to_beat = if self.longest_runtimes.is_full() {
                self.longest_runtimes
                    .iter()
                    .map(|action| action.runtime())
                    .min()
                    .expect("never empty")
            } else {
                Duration::from_micros(100)
            };
        }
    }
    /// No-op when profiling support is disabled.
    #[cfg(not(feature = "profiler"))]
    pub fn save_action_timing(&mut self) {}

    /// Returns retained completed timings and, when requested, an estimate for
    /// the currently running action through the current instant. The iterator
    /// is not sorted.
    pub fn longest_runtimes(&self, include_running: bool) -> impl Iterator<Item = ActionTiming> {
        self.longest_runtimes.iter().copied().chain(
            self.running
                .into_iter()
                .filter(move |_| include_running)
                .map(|(name, start)| ActionTiming {
                    name,
                    start,
                    end: Instant::now(),
                }),
        )
    }
}

#[doc(hidden)]
/// UNSTABLE only for use in the profiler and zed-reliability
#[derive(Copy, Clone)]
pub struct ActionTiming {
    /// Registered action name.
    pub name: &'static str,
    /// Start instant of the handler.
    pub start: Instant,
    /// End instant of the handler.
    pub end: Instant,
}

impl core::fmt::Debug for ActionTiming {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("ActionTiming")
            .field("name", &self.name)
            .field("runtime", &self.runtime())
            .finish()
    }
}

impl ActionTiming {
    /// Returns the nonnegative elapsed duration between the recorded instants.
    pub fn duration(&self) -> Duration {
        self.end.saturating_duration_since(self.start)
    }
}

impl ActionTiming {
    #[doc(hidden)]
    pub fn runtime(&self) -> Duration {
        self.end - self.start
    }
}

// The profiler is careful to never block when the lock is held, therefore a
// spinlock is optimal.
#[cfg(feature = "profiler")]
static ACTION_STATISTICS: spin::Mutex<ActionStatistics> =
    const { spin::Mutex::new(ActionStatistics::new()) };

#[doc(hidden)]
#[cfg(feature = "profiler")]
pub(crate) fn update_running_action(
    action: &(dyn Action + 'static),
    cx: &mut crate::App,
) -> &'static str {
    let now = Instant::now();
    let action = action.type_id();
    let action = cx.actions.try_resolve_action(&action).unwrap_or("un-named");
    ACTION_STATISTICS.lock().update_running_action(action, now);
    action
}

#[doc(hidden)]
#[cfg(feature = "profiler")]
pub(crate) fn save_action_timing() {
    ACTION_STATISTICS.lock().save_action_timing();
}

#[doc(hidden)]
#[cfg(feature = "profiler")]
/// Takes the global action timing sample and resets its completed timings.
pub fn take_action_stats() -> ActionStatistics {
    ACTION_STATISTICS.lock().take()
}

#[doc(hidden)]
#[cfg(not(feature = "profiler"))]
/// Returns empty statistics when profiler support is disabled.
pub fn take_action_stats() -> ActionStatistics {
    ActionStatistics::default()
}

#[cfg(all(test, feature = "profiler"))]
mod tests {
    use super::*;

    #[test]
    fn retains_the_five_longest_actions_regardless_of_arrival_order() {
        let start = Instant::now();
        let mut stats = ActionStatistics::new();
        for microseconds in [500, 100, 400, 200, 300, 50, 350, 150, 600] {
            stats.update_running_action("test", start);
            stats.save_action_timing_at(start + Duration::from_micros(microseconds));
        }
        let mut retained = stats
            .longest_runtimes(false)
            .map(|action| action.duration())
            .collect::<Vec<_>>();
        retained.sort();
        assert_eq!(
            retained,
            [300, 350, 400, 500, 600].map(Duration::from_micros)
        );
        assert_eq!(stats.runtime_to_beat, Duration::from_micros(300));
    }
}
