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
    /// Creates a deterministic dispatcher with randomized runnable ordering
    /// seeded by `seed` and with real-time parking disabled.
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

    /// Creates a dispatcher backed by an existing test scheduler and allocates
    /// a new foreground session on it.
    pub fn from_scheduler(scheduler: Arc<TestScheduler>) -> Self {
        TestDispatcher {
            session_id: scheduler.allocate_session_id(),
            scheduler,
            num_cpus_override: Arc::new(AtomicUsize::new(0)),
        }
    }

    /// Returns the scheduler that controls task ordering, time, and parking.
    pub fn scheduler(&self) -> &Arc<TestScheduler> {
        &self.scheduler
    }

    /// Returns this dispatcher's foreground session identifier.
    pub fn session_id(&self) -> SessionId {
        self.session_id
    }

    /// Drops queued tasks and timers without polling their futures.
    pub fn drain_tasks(&self) {
        self.scheduler.drain_tasks();
    }

    /// Advances test time and runs work due through the requested interval.
    pub fn advance_clock(&self, by: Duration) {
        self.scheduler.advance_clock(by);
    }

    /// Moves time to the earliest pending timer without polling tasks.
    /// Returns whether a timer was pending; call [`Self::run_until_parked`]
    /// afterward to process work it wakes.
    pub fn advance_clock_to_next_timer(&self) -> bool {
        self.scheduler.advance_clock_to_next_timer()
    }

    /// Returns a seeded yield point that lets scheduler-driven tests vary how
    /// many ticks to defer a future.
    pub fn simulate_random_delay(&self) -> Yield {
        self.scheduler.yield_random()
    }

    /// Runs at most one scheduler tick, optionally restricting it to
    /// background work. Returns whether a task or expired timer was processed.
    pub fn tick(&self, background_only: bool) -> bool {
        if background_only {
            self.scheduler.tick_background_only()
        } else {
            self.scheduler.tick()
        }
    }

    /// Runs ready tasks until no runnable work remains, without advancing time
    /// to future timers.
    pub fn run_until_parked(&self) {
        while self.tick(false) {}
    }

    /// Allows blocking test waits to yield to real time and external I/O.
    pub fn allow_parking(&self) {
        self.scheduler.allow_parking();
    }

    /// Restores deterministic waits that fail when no test work can make
    /// progress.
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
