use crate::{App, PlatformDispatcher, PlatformScheduler};
#[cfg(not(target_family = "wasm"))]
use futures::channel::mpsc;
use futures::prelude::*;
use gpui_util::{TryFutureExt, TryFutureExtBacktrace};
use scheduler::Instant;
use scheduler::Scheduler;
use std::{future::Future, marker::PhantomData, rc::Rc, sync::Arc, time::Duration};
#[cfg(not(target_family = "wasm"))]
use std::{mem, pin::Pin};

pub use scheduler::{
    DedicatedExecutor, FallibleTask, LocalExecutor as SchedulerLocalExecutor, Priority, Task,
};

/// A cloneable handle for work that may run away from the foreground thread.
///
/// Futures passed to [`Self::spawn`] must be `Send`; use [`ForegroundExecutor`]
/// for UI state and other `!Send` work. Dropping the returned [`Task`] cancels
/// that task once its current poll returns. Cancellation does not wait for
/// cleanup or undo work already performed.
///
/// The platform dispatcher decides where background work runs. In the browser,
/// ordinary dispatch falls back to the browser thread when worker support is
/// unavailable. A `Send` bound alone does not guarantee parallel execution or
/// make a long synchronous poll safe for the UI.
#[derive(Clone)]
pub struct BackgroundExecutor {
    inner: scheduler::BackgroundExecutor,
    dispatcher: Arc<dyn PlatformDispatcher>,
}

/// A cloneable handle for work that must run on GPUI's foreground thread.
///
/// Tasks may retain `!Send` values, but every poll runs on the foreground
/// thread. `async` does not move expensive synchronous work off that thread:
/// use [`BackgroundExecutor::spawn`] for owned work that would block input.
/// Awaiting another task or a timer lets the foreground scheduler do other work.
#[derive(Clone)]
pub struct ForegroundExecutor {
    inner: scheduler::LocalExecutor,
    dispatcher: Arc<dyn PlatformDispatcher>,
    #[cfg(feature = "profiler")]
    foreground_runnables: Option<crate::profiler::journal::ForegroundRunnableCounter>,
    not_send: PhantomData<Rc<()>>,
}

/// Extension trait for `Task<Result<T, E>>` that adds `detach_and_log_err` with an `&App` context.
///
/// This trait is automatically implemented for all `Task<Result<T, E>>` types.
pub trait TaskExt<T, E> {
    /// Detach the task and log its error if it resolves to `Err`.
    ///
    /// A foreground task waits for the supplied task and logs an `Err` at
    /// this call site. The supplied task keeps running on its original
    /// executor. This returns immediately and gives up the caller's ability
    /// to cancel the work or retrieve its output; it does not catch panics.
    fn detach_and_log_err(self, cx: &App);
    /// Like [`Self::detach_and_log_err`], but uses `{:?}` formatting on failure so `anyhow::Error`
    /// values emit their full backtrace. Prefer `detach_and_log_err` unless a backtrace is wanted.
    fn detach_and_log_err_with_backtrace(self, cx: &App);
}

impl<T, E> TaskExt<T, E> for Task<Result<T, E>>
where
    T: 'static,
    E: 'static + std::fmt::Display + std::fmt::Debug,
{
    #[track_caller]
    fn detach_and_log_err(self, cx: &App) {
        let location = core::panic::Location::caller();
        cx.foreground_executor()
            .spawn(self.log_tracked_err(*location))
            .detach();
    }

    #[track_caller]
    fn detach_and_log_err_with_backtrace(self, cx: &App) {
        let location = *core::panic::Location::caller();
        cx.foreground_executor()
            .spawn(self.log_tracked_err_with_backtrace(location))
            .detach();
    }
}

impl BackgroundExecutor {
    /// Creates a background executor backed by `dispatcher`.
    pub fn new(dispatcher: Arc<dyn PlatformDispatcher>) -> Self {
        #[cfg(any(test, feature = "headless"))]
        let scheduler: Arc<dyn Scheduler> = if let Some(test_dispatcher) = dispatcher.as_test() {
            test_dispatcher.scheduler().clone()
        } else {
            Arc::new(PlatformScheduler::new(dispatcher.clone()))
        };

        #[cfg(not(any(test, feature = "headless")))]
        let scheduler: Arc<dyn Scheduler> = Arc::new(PlatformScheduler::new(dispatcher.clone()));

        Self {
            inner: scheduler::BackgroundExecutor::new(scheduler),
            dispatcher,
        }
    }

    /// Clone the scheduler-level executor for code that does not depend on GPUI.
    pub fn scheduler_executor(&self) -> scheduler::BackgroundExecutor {
        self.inner.clone()
    }

    /// Spawn a closure on a fresh session pinned to its own [`SchedulerLocalExecutor`].
    /// The closure receives a local executor, so the future it constructs may
    /// contain `!Send` state. Under the native platform scheduler it runs on a
    /// new OS thread; the test scheduler instead controls its polling.
    ///
    /// Prefer this over [`Self::spawn`] for futures whose polls need more stack
    /// than shared background threads guarantee. Dedicated threads get the
    /// standard library's configured thread stack, while `spawn` polls futures on
    /// whatever threads the platform dispatcher provides. On macOS those are
    /// GCD workers whose stacks are fixed at 512 KiB by the kernel (see `PTH_DEFAULT_STACKSIZE` in
    /// <https://github.com/apple-oss-distributions/libpthread/blob/42d026df5b07825070f60134b980a1ec2552dfee/kern/kern_internal.h#L154>),
    /// so deep synchronous calls need particular care there.
    ///
    /// On WebAssembly, a dedicated session requires the scheduler's
    /// `wasm-threads` feature and a shared-memory build; without them it panics.
    /// A dedicated worker is expensive to start. Reuse its local executor for
    /// related work rather than creating a session for each small operation.
    #[track_caller]
    pub fn spawn_dedicated<F, Fut>(&self, f: F) -> Task<Fut::Output>
    where
        F: FnOnce(SchedulerLocalExecutor) -> Fut + Send + 'static,
        Fut: Future + 'static,
        Fut::Output: Send + Sync + 'static,
    {
        self.inner.spawn_dedicated(f)
    }

    /// Enqueues `future` for background polling and returns its cancellation handle.
    ///
    /// The future and output must be `Send`. Native platform dispatchers use
    /// background workers; the browser dispatcher uses its browser-thread
    /// fallback when worker support is unavailable. Retain, await, or detach
    /// the task so it is not immediately cancelled.
    #[track_caller]
    pub fn spawn<R>(&self, future: impl Future<Output = R> + Send + 'static) -> Task<R>
    where
        R: Send + 'static,
    {
        self.spawn_with_priority(Priority::default(), future.boxed())
    }

    /// Spawn a background future with a scheduling priority.
    ///
    /// When `Priority::RealtimeAudio` is used, the task runs on a dedicated thread with
    /// realtime scheduling priority where the platform supports it. Keep those
    /// polls bounded; a priority does not make blocking or unbounded work safe.
    /// Retain or detach the returned task, as with [`Self::spawn`].
    ///
    /// The browser dispatcher does not provide a realtime thread. Its
    /// microtask fallback cannot run this blocking audio loop safely; use
    /// ordinary background priorities for portable application work.
    #[track_caller]
    pub fn spawn_with_priority<R>(
        &self,
        priority: Priority,
        future: impl Future<Output = R> + Send + 'static,
    ) -> Task<R>
    where
        R: Send + 'static,
    {
        if priority == Priority::RealtimeAudio {
            self.inner.spawn_realtime(future)
        } else {
            self.inner.spawn_with_priority(priority, future)
        }
    }

    /// Runs background tasks that may borrow from their environment and waits for all of them to complete.
    ///
    /// Dropping the returned future cancels its tasks and synchronously waits for their futures to
    /// be destroyed before returning.
    ///
    /// # Panics
    ///
    /// A panic in `scheduler` propagates after the registered, unstarted
    /// futures are destroyed. Jobs are not submitted until that closure
    /// returns normally.
    #[cfg(not(target_family = "wasm"))]
    pub async fn scoped<'scope, F>(&self, scheduler: F)
    where
        F: FnOnce(&mut Scope<'scope>),
    {
        let mut scope = Scope::new(self.clone(), Priority::default());
        (scheduler)(&mut scope);
        let spawned = mem::take(&mut scope.futures)
            .into_iter()
            .map(|f| self.spawn_with_priority(scope.priority, f))
            .collect::<Vec<_>>();
        for task in spawned {
            task.await;
        }
    }

    /// Runs prioritized background tasks that may borrow from their environment and waits for all
    /// of them to complete.
    ///
    /// Dropping the returned future cancels its tasks and synchronously waits for their futures to
    /// be destroyed before returning.
    #[cfg(not(target_family = "wasm"))]
    pub async fn scoped_priority<'scope, F>(&self, priority: Priority, scheduler: F)
    where
        F: FnOnce(&mut Scope<'scope>),
    {
        let mut scope = Scope::new(self.clone(), priority);
        (scheduler)(&mut scope);
        let spawned = mem::take(&mut scope.futures)
            .into_iter()
            .map(|f| self.spawn_with_priority(scope.priority, f))
            .collect::<Vec<_>>();
        for task in spawned {
            task.await;
        }
    }

    /// Returns the scheduler's current time.
    ///
    /// Use this instead of `std::time::Instant::now` when code must behave
    /// deterministically with the test scheduler's controllable clock.
    pub fn now(&self) -> Instant {
        self.inner.scheduler().clock().now()
    }

    /// Returns a task that will complete after the given duration.
    /// Depending on other concurrent tasks the elapsed duration may be longer
    /// than requested.
    #[track_caller]
    // docs:examples:begin
    #[doc = include_str!("docs/examples/gpui-BackgroundExecutor-timer-31971174.md")]
    // docs:examples:end
    pub fn timer(&self, duration: Duration) -> Task<()> {
        if duration.is_zero() {
            return Task::ready(());
        }
        self.spawn(self.inner.scheduler().timer(duration))
    }

    /// Yield through a seeded random amount of test-scheduler work.
    ///
    /// Use this to expose additional runnable orderings without sleeping.
    /// Panics when this executor is not backed by a test dispatcher.
    #[cfg(any(test, feature = "headless"))]
    pub fn simulate_random_delay(&self) -> impl Future<Output = ()> + use<> {
        self.dispatcher.as_test().unwrap().simulate_random_delay()
    }

    /// In tests, advance simulated time and run work due by the new time.
    ///
    /// The test scheduler drains runnable tasks while crossing timers whose
    /// deadlines fall within `duration`, then leaves the clock at the requested
    /// destination. This does not model wall-clock scheduling latency.
    #[cfg(any(test, feature = "headless"))]
    pub fn advance_clock(&self, duration: Duration) {
        self.dispatcher.as_test().unwrap().advance_clock(duration)
    }

    /// Process due test timers and run at most one runnable task.
    ///
    /// Returns whether work ran. This does not advance to a future deadline.
    /// Panics when this executor is not backed by a test dispatcher.
    #[cfg(any(test, feature = "headless"))]
    pub fn tick(&self) -> bool {
        self.dispatcher.as_test().unwrap().scheduler().tick()
    }

    /// In tests, poll ready tasks until the scheduler has no runnable work.
    ///
    /// This does not advance the test clock. Pending timers remain pending;
    /// use [`Self::advance_clock`] to advance time and run work due in that
    /// interval.
    #[cfg(any(test, feature = "headless"))]
    pub fn run_until_parked(&self) {
        let scheduler = self.dispatcher.as_test().unwrap().scheduler();
        scheduler.run();
    }

    /// In tests, prevents `run_until_parked` from panicking if there are outstanding tasks.
    #[cfg(any(test, feature = "headless"))]
    pub fn allow_parking(&self) {
        self.dispatcher
            .as_test()
            .unwrap()
            .scheduler()
            .allow_parking();

        if std::env::var("GPUI_RUN_UNTIL_PARKED_LOG").ok().as_deref() == Some("1") {
            log::warn!("[gpui::executor] allow_parking: enabled");
        }
    }

    /// Sets the range of ticks to run before timing out in block_on.
    #[cfg(any(test, feature = "headless"))]
    pub fn set_block_on_ticks(&self, range: std::ops::RangeInclusive<usize>) {
        self.dispatcher
            .as_test()
            .unwrap()
            .scheduler()
            .set_timeout_ticks(range);
    }

    /// Undoes the effect of [`Self::allow_parking`].
    #[cfg(any(test, feature = "headless"))]
    pub fn forbid_parking(&self) {
        self.dispatcher
            .as_test()
            .unwrap()
            .scheduler()
            .forbid_parking();
    }

    /// In tests, returns the rng used by the dispatcher.
    #[cfg(any(test, feature = "headless"))]
    pub fn rng(&self) -> scheduler::SharedRng {
        self.dispatcher.as_test().unwrap().scheduler().rng()
    }

    /// How many CPUs are available to the dispatcher.
    pub fn num_cpus(&self) -> usize {
        #[cfg(any(test, feature = "headless"))]
        if let Some(test) = self.dispatcher.as_test() {
            return test.num_cpus_override().unwrap_or(4);
        }
        num_cpus::get()
    }

    /// Override the number of CPUs reported by this executor in tests.
    /// Panics if not called on a test executor.
    #[cfg(any(test, feature = "headless"))]
    pub fn set_num_cpus(&self, count: usize) {
        self.dispatcher
            .as_test()
            .expect("set_num_cpus can only be called on a test executor")
            .set_num_cpus(count);
    }

    /// Whether we're on the main thread.
    pub fn is_main_thread(&self) -> bool {
        self.dispatcher.is_main_thread()
    }

    #[doc(hidden)]
    pub fn dispatcher(&self) -> &Arc<dyn PlatformDispatcher> {
        &self.dispatcher
    }
}

impl ForegroundExecutor {
    /// Creates a new ForegroundExecutor from the given PlatformDispatcher.
    pub fn new(dispatcher: Arc<dyn PlatformDispatcher>) -> Self {
        #[cfg(any(test, feature = "headless"))]
        let (scheduler, session_id): (Arc<dyn Scheduler>, _) =
            if let Some(test_dispatcher) = dispatcher.as_test() {
                (
                    test_dispatcher.scheduler().clone(),
                    test_dispatcher.session_id(),
                )
            } else {
                let platform_scheduler = Arc::new(PlatformScheduler::new(dispatcher.clone()));
                let inner = platform_scheduler.foreground_executor();
                return Self {
                    inner,
                    dispatcher,
                    #[cfg(feature = "profiler")]
                    foreground_runnables: Some(platform_scheduler.foreground_runnable_counter()),
                    not_send: PhantomData,
                };
            };

        #[cfg(not(any(test, feature = "headless")))]
        let platform_scheduler = Arc::new(PlatformScheduler::new(dispatcher.clone()));
        #[cfg(not(any(test, feature = "headless")))]
        let inner = platform_scheduler.foreground_executor();
        #[cfg(all(not(any(test, feature = "headless")), feature = "profiler"))]
        let foreground_runnables = Some(platform_scheduler.foreground_runnable_counter());

        #[cfg(any(test, feature = "headless"))]
        let inner = {
            let scheduler_for_dispatch = Arc::downgrade(&scheduler);
            scheduler::LocalExecutor::new(session_id, scheduler, move |runnable| {
                if let Some(scheduler) = scheduler_for_dispatch.upgrade() {
                    scheduler.schedule_local(session_id, runnable);
                }
            })
        };

        #[cfg(all(any(test, feature = "headless"), feature = "profiler"))]
        // The deterministic test scheduler does not invoke GPUI's task profiler
        // hooks, so an increment here would have no matching decrement.
        let foreground_runnables = None;

        Self {
            inner,
            dispatcher,
            #[cfg(feature = "profiler")]
            foreground_runnables,
            not_send: PhantomData,
        }
    }

    /// Enqueues `future` for polling on the foreground thread.
    ///
    /// Dropping the returned task cancels it. The future is local to this
    /// executor and therefore does not need to be `Send`.
    #[track_caller]
    pub fn spawn<R>(&self, future: impl Future<Output = R> + 'static) -> Task<R>
    where
        R: 'static,
    {
        self.inner.spawn(future.boxed_local())
    }

    /// Spawn a foreground future; `priority` is currently ignored.
    ///
    /// This has the same scheduling behavior as [`Self::spawn`]. Foreground
    /// work stays on the application's foreground thread.
    #[track_caller]
    pub fn spawn_with_priority<R>(
        &self,
        _priority: Priority,
        future: impl Future<Output = R> + 'static,
    ) -> Task<R>
    where
        R: 'static,
    {
        // Priority is ignored for foreground tasks - they run in order on the main thread
        self.inner.spawn(future)
    }

    /// On platforms with dedicated support, enqueues the given future to run
    /// on the main thread during platform idle time. Without a `timeout`,
    /// polls may be deferred indefinitely while the platform stays busy;
    /// with one, a poll still waiting after that long runs as ordinary main-thread work.
    /// Each poll occupies part of one idle slice, so long synchronous stretches
    /// should bound themselves against [`Self::idle_time_remaining`] and yield.
    ///
    /// On platforms without dedicated support, schedules the given future to run
    /// with a low priority, ignoring `timeout`.
    #[track_caller]
    pub fn spawn_when_idle<R>(
        &self,
        timeout: Option<Duration>,
        future: impl Future<Output = R> + 'static,
    ) -> Task<R>
    where
        R: 'static,
    {
        let dispatcher = self.dispatcher.clone();
        #[cfg(feature = "profiler")]
        let foreground_runnables = self.foreground_runnables.clone();
        self.inner
            .spawn_with_dispatch(future.boxed_local(), move |runnable| {
                #[cfg(feature = "profiler")]
                if let Some(foreground_runnables) = &foreground_runnables {
                    foreground_runnables.queued();
                }
                dispatcher.dispatch_on_main_thread_when_idle(runnable, timeout);
            })
    }

    /// The time remaining in the current idle slice, when called from a task
    /// spawned via [`Self::spawn_when_idle`] on a platform that meters idle
    /// time. `None` when idle time is unmetered (or the caller is not inside
    /// an idle slice); work that must bound itself should then fall back to a
    /// budget of its own.
    pub fn idle_time_remaining(&self) -> Option<Duration> {
        self.dispatcher.idle_time_remaining()
    }

    /// Used by the test harness to run an async test in a synchronous fashion.
    #[cfg(all(not(target_family = "wasm"), any(test, feature = "headless")))]
    #[track_caller]
    pub fn block_test<R>(&self, future: impl Future<Output = R>) -> R {
        use std::cell::Cell;

        let scheduler = self.inner.scheduler();

        let output = Cell::new(None);
        let future = async {
            output.set(Some(future.await));
        };
        let mut future = std::pin::pin!(future);

        // In async GPUI tests, we must allow foreground tasks scheduled by the test itself
        // (which are associated with the test session) to make progress while we block.
        // Otherwise, awaiting futures that depend on same-session foreground work can deadlock.
        scheduler.block(None, future.as_mut(), None);

        output.take().expect("block_test future did not complete")
    }

    /// Block the current thread until `future` resolves.
    ///
    /// This is a synchronous escape hatch for integration code. Calling it from
    /// a foreground callback can prevent the very work needed to resolve the
    /// future; prefer [`Self::spawn`] in application code. Use
    /// [`Self::block_with_timeout`] when the future depends on external input.
    #[cfg(not(target_family = "wasm"))]
    pub fn block_on<R>(&self, future: impl Future<Output = R>) -> R {
        self.inner.block_on(future)
    }

    /// Block until `future` resolves or the scheduler's timeout expires.
    ///
    /// Returns `Ok(output)` on completion. On timeout, returns `Err(future)`
    /// containing the partially polled future, which the caller can resume or
    /// drop. Timing out does not undo effects already performed by that future.
    /// See [`Self::block_on`] for the foreground-thread deadlock constraint.
    #[cfg(not(target_family = "wasm"))]
    pub fn block_with_timeout<R, Fut: Future<Output = R>>(
        &self,
        duration: Duration,
        future: Fut,
    ) -> Result<R, impl Future<Output = R> + use<R, Fut>> {
        self.inner.block_with_timeout(duration, future)
    }

    #[doc(hidden)]
    pub fn dispatcher(&self) -> &Arc<dyn PlatformDispatcher> {
        &self.dispatcher
    }

    #[doc(hidden)]
    pub fn scheduler_executor(&self) -> SchedulerLocalExecutor {
        self.inner.clone()
    }
}

/// A group of background jobs that may borrow data from the caller.
///
/// Obtain it inside [`BackgroundExecutor::scoped`] or
/// [`BackgroundExecutor::scoped_priority`]. Register jobs with [`Self::spawn`];
/// they are submitted after that registration closure returns. The enclosing
/// async scope waits for all jobs, so borrowed data cannot outlive its owner.
/// Dropping the scope waits for unfinished job futures to be destroyed.
#[cfg(not(target_family = "wasm"))]
pub struct Scope<'a> {
    executor: BackgroundExecutor,
    priority: Priority,
    futures: Vec<Pin<Box<dyn Future<Output = ()> + Send + 'static>>>,
    tx: Option<mpsc::Sender<()>>,
    rx: mpsc::Receiver<()>,
    lifetime: PhantomData<&'a ()>,
}

#[cfg(not(target_family = "wasm"))]
impl<'a> Scope<'a> {
    fn new(executor: BackgroundExecutor, priority: Priority) -> Self {
        let (tx, rx) = mpsc::channel(1);
        Self {
            executor,
            priority,
            tx: Some(tx),
            rx,
            futures: Default::default(),
            lifetime: PhantomData,
        }
    }

    /// How many CPUs are available to the dispatcher.
    pub fn num_cpus(&self) -> usize {
        self.executor.num_cpus()
    }

    /// Register a job to be scheduled after the scope's closure returns.
    ///
    /// The future may borrow for the scope's lifetime but must be `Send`.
    /// Await the enclosing scope to know all jobs have completed. See
    /// [`BackgroundExecutor::scoped`] for cancellation and cleanup behavior.
    #[track_caller]
    pub fn spawn<F>(&mut self, f: F)
    where
        F: Future<Output = ()> + Send + 'a,
    {
        let tx = self.tx.clone().unwrap();

        // SAFETY: The 'a lifetime is guaranteed to outlive any of these futures because
        // dropping this `Scope` blocks until all of the futures have resolved.
        let f = unsafe {
            mem::transmute::<
                Pin<Box<dyn Future<Output = ()> + Send + 'a>>,
                Pin<Box<dyn Future<Output = ()> + Send + 'static>>,
            >(Box::pin(async move {
                f.await;
                drop(tx);
            }))
        };
        self.futures.push(f);
    }
}

#[cfg(not(target_family = "wasm"))]
impl Drop for Scope<'_> {
    fn drop(&mut self) {
        // Registration may unwind before these jobs are submitted. Their
        // captured senders must be released before waiting for disconnection.
        self.futures.clear();
        self.tx.take().unwrap();

        // Wait until the channel is closed, which means that all of the spawned
        // futures have resolved.
        let future = async {
            self.rx.next().await;
        };
        let mut future = std::pin::pin!(future);
        self.executor
            .inner
            .scheduler()
            .block(None, future.as_mut(), None);
    }
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::{App, AssetRegistry, TestDispatcher, TestPlatform};
    use std::cell::RefCell;

    /// Helper to create test infrastructure.
    /// Returns (dispatcher, background_executor, app).
    fn create_test_app() -> (TestDispatcher, BackgroundExecutor, Rc<crate::AppCell>) {
        let dispatcher = TestDispatcher::new(0);
        let arc_dispatcher = Arc::new(dispatcher.clone());
        let background_executor = BackgroundExecutor::new(arc_dispatcher.clone());
        let foreground_executor = ForegroundExecutor::new(arc_dispatcher);

        let platform = TestPlatform::new(background_executor.clone(), foreground_executor);
        let http_client = crate::http_client::FakeHttpClient::with_404_response();

        let app = App::new_app(platform, AssetRegistry::default().into(), http_client);
        (dispatcher, background_executor, app)
    }

    #[test]
    fn sanity_test_tasks_run() {
        let (dispatcher, _background_executor, app) = create_test_app();
        let foreground_executor = app.borrow().foreground_executor.clone();

        let task_ran = Rc::new(RefCell::new(false));

        foreground_executor
            .spawn({
                let task_ran = Rc::clone(&task_ran);
                async move {
                    *task_ran.borrow_mut() = true;
                }
            })
            .detach();

        // Run dispatcher while app is still alive
        dispatcher.run_until_parked();

        // Task should have run
        assert!(
            *task_ran.borrow(),
            "Task should run normally when app is alive"
        );
    }

    #[test]
    #[cfg(not(target_family = "wasm"))]
    fn scoped_registration_panic_destroys_unstarted_jobs() {
        use std::sync::{
            atomic::{AtomicBool, Ordering},
            mpsc,
        };

        struct DropProbe(Arc<AtomicBool>);
        impl Drop for DropProbe {
            fn drop(&mut self) {
                self.0.store(true, Ordering::SeqCst);
            }
        }

        // A broken cleanup path blocks in Scope::drop. Keep that wait off
        // the test thread so the regression fails with a bounded timeout.
        let (completed_tx, completed_rx) = mpsc::channel();
        let worker = std::thread::spawn(move || {
            let dispatcher = Arc::new(TestDispatcher::new(0));
            let executor = BackgroundExecutor::new(dispatcher);
            let destroyed = Arc::new(AtomicBool::new(false));
            let probe = DropProbe(destroyed.clone());
            let unwound = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                futures::executor::block_on(executor.scoped(|scope| {
                    scope.spawn(async move {
                        drop(probe);
                        panic!("an unsubmitted job must not run");
                    });
                    panic!("registration failed");
                }));
            }));
            completed_tx
                .send((unwound.is_err(), destroyed.load(Ordering::SeqCst)))
                .unwrap();
        });

        assert_eq!(
            completed_rx.recv_timeout(Duration::from_secs(5)),
            Ok((true, true)),
            "registration must unwind after destroying its unstarted futures"
        );
        worker.join().unwrap();
    }
}
