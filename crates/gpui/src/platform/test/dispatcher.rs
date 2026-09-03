use crate::{PlatformDispatcher, Priority, RunnableVariant};
use scheduler::Instant;
use scheduler::{Clock, Scheduler, SessionId, TestScheduler, TestSchedulerConfig, Yield};
use std::{
    sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    },
    time::Duration,
};

/// TestDispatcher provides deterministic async execution for tests.
///
/// This implementation delegates task scheduling to the scheduler crate's `TestScheduler`.
/// Access the scheduler directly via `scheduler()` for clock, rng, and parking control.
#[doc(hidden)]
pub struct TestDispatcher {
    session_id: SessionId,
    scheduler: Arc<TestScheduler>,
    num_cpus_override: Arc<AtomicUsize>,
}

impl TestDispatcher {
    pub fn new(seed: u64) -> Self {
        let scheduler = Arc::new(TestScheduler::new(TestSchedulerConfig {
            seed,
            randomize_order: true,
            allow_parking: false,
            capture_pending_traces: std::env::var("PENDING_TRACES")
                .map_or(false, |var| var == "1" || var == "true"),
            timeout_ticks: 0..=1000,
        }));
        Self::from_scheduler(scheduler)
    }

    pub fn from_scheduler(scheduler: Arc<TestScheduler>) -> Self {
        TestDispatcher {
            session_id: scheduler.allocate_session_id(),
            scheduler,
            num_cpus_override: Arc::new(AtomicUsize::new(0)),
        }
    }

    pub fn scheduler(&self) -> &Arc<TestScheduler> {
        &self.scheduler
    }

    pub fn session_id(&self) -> SessionId {
        self.session_id
    }

    pub fn drain_tasks(&self) {
        self.scheduler.drain_tasks();
    }

    pub fn advance_clock(&self, by: Duration) {
        self.scheduler.advance_clock(by);
    }

    pub fn advance_clock_to_next_timer(&self) -> bool {
        self.scheduler.advance_clock_to_next_timer()
    }

    pub fn simulate_random_delay(&self) -> Yield {
        self.scheduler.yield_random()
    }

    pub fn tick(&self, background_only: bool) -> bool {
        if background_only {
            self.scheduler.tick_background_only()
        } else {
            self.scheduler.tick()
        }
    }

    pub fn run_until_parked(&self) {
        while self.tick(false) {}
    }

    pub fn allow_parking(&self) {
        self.scheduler.allow_parking();
    }

    pub fn forbid_parking(&self) {
        self.scheduler.forbid_parking();
    }

    /// Override the value returned by `BackgroundExecutor::num_cpus()` in tests.
    /// A value of 0 means no override (the default of 4 is used).
    pub fn set_num_cpus(&self, count: usize) {
        self.num_cpus_override.store(count, Ordering::SeqCst);
    }

    /// Returns the overridden CPU count, or `None` if no override is set.
    pub fn num_cpus_override(&self) -> Option<usize> {
        match self.num_cpus_override.load(Ordering::SeqCst) {
            0 => None,
            n => Some(n),
        }
    }
}

impl Clone for TestDispatcher {
    fn clone(&self) -> Self {
        let session_id = self.scheduler.allocate_session_id();
        Self {
            session_id,
            scheduler: self.scheduler.clone(),
            num_cpus_override: self.num_cpus_override.clone(),
        }
    }
}

impl PlatformDispatcher for TestDispatcher {
    fn is_main_thread(&self) -> bool {
        self.scheduler.is_main_thread()
    }

    fn now(&self) -> Instant {
        self.scheduler.clock().now()
    }

    fn dispatch(&self, runnable: RunnableVariant, priority: Priority) {
        self.scheduler
            .schedule_background_with_priority(runnable, priority);
    }

    fn dispatch_on_main_thread(&self, runnable: RunnableVariant, _priority: Priority) {
        self.scheduler.schedule_local(self.session_id, runnable);
    }

    fn dispatch_after(&self, _duration: Duration, _runnable: RunnableVariant) {
        panic!(
            "dispatch_after should not be called in tests. \
            Use BackgroundExecutor::timer() which uses the scheduler's native timer."
        );
    }

    fn as_test(&self) -> Option<&TestDispatcher> {
        Some(self)
    }

    fn spawn_realtime(&self, f: Box<dyn FnOnce() + Send>) {
        std::thread::spawn(move || {
            f();
        });
    }
}

#[cfg(test)]
mod tests {
    // Hermeticity notes: the scheduler reads the `PENDING_TRACES`/`DEBUG_SCHEDULER`
    // env vars at construction/step time, and `TestDispatcher::spawn_realtime` runs
    // on a real OS thread; none of the tests below set those vars or spawn realtime.
    use super::*;
    use crate::TestAppContext;
    use std::sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    };

    /// Default `num_cpus()` reported by a test executor with no override. Mirrors
    /// the `4` fallback in `BackgroundExecutor::num_cpus` (executor.rs) and the
    /// `0` = "no override" sentinel in `TestDispatcher::set_num_cpus`.
    const TEST_NUM_CPUS_DEFAULT: usize = 4;

    fn spawn_timer_fire(
        executor: &crate::BackgroundExecutor,
        fired: Arc<AtomicUsize>,
        delay: Duration,
    ) {
        let timer = executor.timer(delay);
        executor
            .spawn(async move {
                timer.await;
                fired.fetch_add(1, Ordering::SeqCst);
            })
            .detach();
    }

    /// Clock deltas visited by repeatedly jumping to the next timer and draining it.
    fn visited_times(
        dispatcher: &TestDispatcher,
        executor: &crate::BackgroundExecutor,
    ) -> Vec<Duration> {
        let start = executor.now();
        let mut visited = Vec::new();
        while dispatcher.advance_clock_to_next_timer() {
            visited.push(executor.now() - start);
            executor.run_until_parked();
        }
        visited
    }

    #[gpui::test]
    async fn advance_clock_moves_clock_and_fires_expired_timers(cx: &mut TestAppContext) {
        let executor = cx.executor();
        let fired = Arc::new(AtomicUsize::new(0));
        spawn_timer_fire(&executor, Arc::clone(&fired), Duration::from_millis(100));

        let start = executor.now();
        executor.advance_clock(Duration::from_millis(50));
        assert_eq!(fired.load(Ordering::SeqCst), 0);
        assert_eq!(executor.now() - start, Duration::from_millis(50));

        executor.advance_clock(Duration::from_millis(50));
        assert_eq!(fired.load(Ordering::SeqCst), 1);
        assert_eq!(executor.now() - start, Duration::from_millis(100));
    }

    #[gpui::test]
    async fn advance_clock_to_next_timer_visits_timers_in_expiration_order(
        cx: &mut TestAppContext,
    ) {
        let executor = cx.executor();
        let fired = Arc::new(AtomicUsize::new(0));
        for millis in [300, 100, 200] {
            spawn_timer_fire(&executor, Arc::clone(&fired), Duration::from_millis(millis));
        }
        assert_eq!(
            visited_times(&cx.dispatcher, &executor),
            vec![
                Duration::from_millis(100),
                Duration::from_millis(200),
                Duration::from_millis(300),
            ]
        );
        assert_eq!(fired.load(Ordering::SeqCst), 3);
    }

    #[gpui::test]
    async fn tick_runs_one_task_while_run_until_parked_drains_all(cx: &mut TestAppContext) {
        let executor = cx.executor();
        let count = Arc::new(AtomicUsize::new(0));
        for _ in 0..3 {
            executor
                .spawn({
                    let count = Arc::clone(&count);
                    async move { count.fetch_add(1, Ordering::SeqCst) }
                })
                .detach();
        }

        assert!(cx.dispatcher.tick(false));
        assert_eq!(count.load(Ordering::SeqCst), 1);
        cx.dispatcher.run_until_parked();
        assert_eq!(count.load(Ordering::SeqCst), 3);
    }

    #[gpui::test]
    async fn run_until_parked_leaves_future_timers_pending(cx: &mut TestAppContext) {
        let executor = cx.executor();
        let fired = Arc::new(AtomicUsize::new(0));
        spawn_timer_fire(&executor, Arc::clone(&fired), Duration::from_millis(100));

        let start = executor.now();
        executor.run_until_parked();
        assert_eq!(fired.load(Ordering::SeqCst), 0);
        assert_eq!(executor.now() - start, Duration::ZERO);

        assert!(cx.dispatcher.advance_clock_to_next_timer());
        assert_eq!(executor.now() - start, Duration::from_millis(100));
        executor.run_until_parked();
        assert_eq!(fired.load(Ordering::SeqCst), 1);
    }

    #[gpui::test]
    async fn new_app_isolates_session_but_shares_scheduler(cx: &mut TestAppContext) {
        let other = cx.new_app();
        assert_ne!(cx.dispatcher.session_id(), other.dispatcher.session_id());

        let executor = cx.executor();
        let fired = Arc::new(AtomicUsize::new(0));
        spawn_timer_fire(&executor, Arc::clone(&fired), Duration::from_millis(50));

        let start = other.executor().now();
        other.executor().advance_clock(Duration::from_millis(50));
        assert_eq!(fired.load(Ordering::SeqCst), 1);
        assert_eq!(cx.executor().now() - start, Duration::from_millis(50));
    }

    #[gpui::test]
    async fn num_cpus_override_is_observable(cx: &mut TestAppContext) {
        let executor = cx.executor();
        assert_eq!(executor.num_cpus(), TEST_NUM_CPUS_DEFAULT);
        executor.set_num_cpus(2);
        assert_eq!(executor.num_cpus(), 2);
        executor.set_num_cpus(0);
        assert_eq!(executor.num_cpus(), TEST_NUM_CPUS_DEFAULT);
    }
}
