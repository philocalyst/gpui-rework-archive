//! Android task dispatcher.
//!
//! Mirrors the two-queue model used in `gpui_linux` and `IosDispatcher`:
//!
//! * **Foreground / main-thread tasks** — posted via a pipe-backed `ALooper`
//!   callback so they run on the Android native-activity main thread (the same
//!   thread that owns the `ANativeWindow` and processes input events).
//!
//! * **Background tasks** — dispatched onto a fixed-size Rust thread-pool
//!   backed by `std::thread`.  The pool size defaults to
//!   `std::thread::available_parallelism()`.
//!
//! ## Design notes
//!
//! `ALooper` (NDK) is the native equivalent of GCD's main queue or a Linux
//! `epoll` loop.  We register a pipe file-descriptor with `ALooper_addFd` and
//! write a single byte to wake it up whenever a foreground task is enqueued.
//! The looper callback drains all pending tasks before returning.
//!
//! ## GPUI integration
//!
//! `AndroidDispatcher` implements `gpui::PlatformDispatcher` so it can be
//! used to construct `BackgroundExecutor` and `ForegroundExecutor` instances.

#![allow(unsafe_code)]

use std::{
    collections::{HashMap, HashSet, VecDeque},
    os::unix::io::RawFd,
    sync::{
        Arc,
        atomic::{AtomicBool, AtomicPtr, Ordering},
    },
    time::{Duration, Instant},
};

use gpui::{LocalTaskScope, PlatformDispatcher, Priority, RunnableVariant};
use ndk::looper::ForeignLooper;
use parking_lot::Mutex;

// ── NDK / libc symbols we need ────────────────────────────────────────────────

/// `ALOOPER_POLL_CALLBACK` — the fd was signalled and the callback fired.
#[allow(dead_code)]
const ALOOPER_POLL_CALLBACK: i32 = -2;

/// `ALOOPER_EVENT_INPUT` — data is available to read on the fd.
const ALOOPER_EVENT_INPUT: i32 = 1;

unsafe extern "C" {
    /// Adds a file-descriptor to the looper.
    fn ALooper_addFd(
        looper: *mut libc_looper_opaque,
        fd: RawFd,
        ident: i32,
        events: i32,
        callback: Option<
            unsafe extern "C" fn(fd: RawFd, events: i32, data: *mut std::ffi::c_void) -> i32,
        >,
        data: *mut std::ffi::c_void,
    ) -> i32;
    /// Removes a file-descriptor from the looper.
    fn ALooper_removeFd(looper: *mut libc_looper_opaque, fd: RawFd) -> i32;
}

// Opaque C type placeholder.
#[repr(C)]
struct libc_looper_opaque {
    _priv: [u8; 0],
}

// ── task queue ────────────────────────────────────────────────────────────────

type BoxedTask = Box<dyn FnOnce() + Send + 'static>;

/// Tasks accepted by the owner-thread queue. Local runnables remain typed so
/// retirement can drop their futures on the owner instead of invoking Runnable::run
/// after the executor has begun closing.
enum MainTask {
    Generic(BoxedTask),
    Local {
        scope: Arc<LocalTaskScope>,
        runnable: RunnableVariant,
    },
}

fn scope_key(scope: &Arc<LocalTaskScope>) -> usize {
    Arc::as_ptr(scope) as usize
}

/// Shared state between the dispatcher and the looper callback.
struct MainQueue {
    tasks: VecDeque<MainTask>,
    /// All platform-local task scopes created by this dispatcher.
    local_scopes: HashMap<usize, Arc<LocalTaskScope>>,
    /// Scopes whose queued runnables must be canceled, not polled.
    retiring_scopes: HashSet<usize>,
    /// Scopes whose queues and task registrations have been sealed.
    sealed_scopes: HashSet<usize>,
    /// Write end of the wake pipe.
    write_fd: RawFd,
}

// ── thread-pool ───────────────────────────────────────────────────────────────

/// A minimal fixed-size thread-pool for background tasks.
struct ThreadPool {
    sender: Mutex<Option<std::sync::mpsc::Sender<BoxedTask>>>,
}

impl ThreadPool {
    fn new(threads: usize) -> Self {
        let (sender, receiver) = std::sync::mpsc::channel::<BoxedTask>();
        let receiver = Arc::new(Mutex::new(receiver));

        for i in 0..threads {
            let rx = Arc::clone(&receiver);
            std::thread::Builder::new()
                .name(format!("gpui-bg-{}", i))
                .spawn(move || {
                    loop {
                        let task = {
                            let lock = rx.lock();
                            lock.recv()
                        };
                        match task {
                            Ok(f) => f(),
                            Err(_) => break, // channel closed
                        }
                    }
                })
                .expect("failed to spawn background thread");
        }

        ThreadPool {
            sender: Mutex::new(Some(sender)),
        }
    }

    fn dispatch(&self, task: BoxedTask) {
        // Linearize enqueue against shutdown while keeping rejected task drops
        // outside the sender lock.
        let mut task = Some(task);
        let result = {
            let sender = self.sender.lock();
            sender
                .as_ref()
                .map(|sender| sender.send(task.take().expect("task available")))
        };
        match result {
            Some(Ok(())) => {}
            Some(Err(error)) => drop(error.0),
            None => drop(task),
        }
    }

    fn shutdown(&self) {
        let sender = self.sender.lock().take();
        drop(sender);
    }
}

// ── delayed task queue ────────────────────────────────────────────────────────

struct DelayedTask {
    due: Instant,
    task: BoxedTask,
}

// ── AndroidDispatcher ─────────────────────────────────────────────────────────

/// GPUI dispatcher for Android.
///
/// * Foreground tasks run on the Android main/native thread via `ALooper`.
/// * Background tasks run on a Rust thread-pool.
/// * Delayed tasks are checked on each `tick()` call (driven by the main loop).
pub struct AndroidDispatcher {
    /// Shared task queue + wake pipe for the main thread.
    main_queue: Arc<Mutex<MainQueue>>,
    /// Read end of the wake pipe (owned here for clean shutdown).
    read_fd: RawFd,
    /// Acquired reference to the main-thread looper. The dispatcher owns it
    /// until drop; fd registration and removal remain owner-thread-only.
    looper: Option<ForeignLooper>,
    /// Background thread-pool.
    pool: ThreadPool,
    /// Delayed background tasks sorted by due time.
    delayed: Mutex<Vec<DelayedTask>>,
    /// Set to `true` once `shutdown()` is called.
    shutdown: AtomicBool,
    /// Tracks whether the owner looper currently holds the main-queue callback.
    /// `ALooper_removeFd` is owner-thread-only, so a late Arc drop must observe
    /// that explicit owner shutdown already unregistered it.
    looper_registered: AtomicBool,
    /// Raw Arc passed to ALooper_addFd; reclaimed after successful removal.
    looper_data: AtomicPtr<std::ffi::c_void>,
    owner_thread: std::thread::ThreadId,
}

impl AndroidDispatcher {
    /// Create a new dispatcher.
    ///
    /// Must be called on a thread with a prepared Android looper.
    ///
    /// # Panics
    ///
    /// Panics if:
    /// * `pipe(2)` fails.
    /// * the calling thread has no prepared Android looper.
    pub fn new() -> Arc<Self> {
        // Create wake pipe.
        let (read_fd, write_fd) = create_pipe().expect("failed to create wake pipe");

        let looper = ForeignLooper::for_thread()
            .expect("AndroidDispatcher::new() requires a prepared Android looper");

        let pool_threads = std::thread::available_parallelism()
            .map(|n| n.get())
            .unwrap_or(4)
            .max(2);

        let main_queue = Arc::new(Mutex::new(MainQueue {
            tasks: VecDeque::new(),
            local_scopes: HashMap::new(),
            retiring_scopes: HashSet::new(),
            sealed_scopes: HashSet::new(),
            write_fd,
        }));

        let dispatcher = Arc::new(Self {
            main_queue: Arc::clone(&main_queue),
            read_fd,
            looper: Some(looper),
            pool: ThreadPool::new(pool_threads),
            delayed: Mutex::new(Vec::new()),
            shutdown: AtomicBool::new(false),
            looper_registered: AtomicBool::new(false),
            looper_data: AtomicPtr::new(std::ptr::null_mut()),
            owner_thread: std::thread::current().id(),
        });

        // Register the read end of the pipe with the looper so we get a
        // callback whenever a foreground task is enqueued.
        dispatcher.register_with_looper();

        log::debug!("AndroidDispatcher created (pool_threads={})", pool_threads);

        dispatcher
    }

    /// Create a dispatcher without a real `ALooper`.
    ///
    /// Safe to call from any thread (including non-Android host environments
    /// and unit tests).  Foreground tasks accumulate in the queue and must
    /// be drained manually via `flush_main_thread_tasks()`.
    pub fn new_headless() -> Arc<Self> {
        let (read_fd, write_fd) = create_pipe().expect("failed to create wake pipe");

        let pool_threads = std::thread::available_parallelism()
            .map(|n| n.get())
            .unwrap_or(2)
            .max(1);

        let main_queue = Arc::new(Mutex::new(MainQueue {
            tasks: VecDeque::new(),
            local_scopes: HashMap::new(),
            retiring_scopes: HashSet::new(),
            sealed_scopes: HashSet::new(),
            write_fd,
        }));

        Arc::new(Self {
            main_queue,
            read_fd,
            looper: None, // no real looper in headless mode
            pool: ThreadPool::new(pool_threads),
            delayed: Mutex::new(Vec::new()),
            shutdown: AtomicBool::new(false),
            looper_registered: AtomicBool::new(false),
            looper_data: AtomicPtr::new(std::ptr::null_mut()),
            owner_thread: std::thread::current().id(),
        })
    }

    // ── public API ────────────────────────────────────────────────────────────

    /// Returns `true` if the calling thread is the main/UI thread.
    pub fn is_main_thread(&self) -> bool {
        std::thread::current().id() == self.owner_thread
    }

    /// Whether foreground work must be drained explicitly instead of by an
    /// Android looper callback. Headless dispatchers still have an owner
    /// thread and preserve inline owner-thread callback semantics.
    pub fn is_headless(&self) -> bool {
        self.looper.is_none()
    }

    /// Enqueue a task to run on the **main** (foreground) thread.
    pub fn dispatch_on_main_thread<F>(&self, f: F)
    where
        F: FnOnce() + Send + 'static,
    {
        if self.shutdown.load(Ordering::Relaxed) {
            return;
        }
        let task: BoxedTask = Box::new(f);
        let mut q = self.main_queue.lock();
        if self.shutdown.load(Ordering::Acquire) {
            drop(q);
            drop(task);
            return;
        }
        q.tasks.push_back(MainTask::Generic(task));
        wake_pipe(q.write_fd);
    }

    /// Enqueue a task on the **background** thread-pool.
    pub fn dispatch<F>(&self, f: F)
    where
        F: FnOnce() + Send + 'static,
    {
        if self.shutdown.load(Ordering::Relaxed) {
            return;
        }
        self.pool.dispatch(Box::new(f));
    }

    /// Enqueue a task on the **background** thread-pool after `delay`.
    pub fn dispatch_after<F>(&self, delay: Duration, f: F)
    where
        F: FnOnce() + Send + 'static,
    {
        if self.shutdown.load(Ordering::Relaxed) {
            return;
        }
        let due = Instant::now() + delay;
        let mut delayed = self.delayed.lock();
        if self.shutdown.load(Ordering::Acquire) {
            drop(delayed);
            return;
        }
        delayed.push(DelayedTask {
            due,
            task: Box::new(f),
        });
        // Keep sorted by ascending due time.
        delayed.sort_by_key(|d| d.due);
        drop(delayed);
        self.wake_looper();
    }

    /// When the earliest delayed task is due, so the main loop can sleep
    /// until then instead of polling `tick()` blindly.
    pub fn next_delayed_due(&self) -> Option<Instant> {
        self.delayed.lock().first().map(|d| d.due)
    }

    /// Interrupts a main loop blocked on the looper so it re-reads
    /// `next_delayed_due()`; a delayed task posted from another thread would
    /// otherwise wait for an unrelated wakeup.
    fn wake_looper(&self) {
        // The borrowed dispatcher keeps its owned looper reference alive
        // for the duration of this nonblocking wake.
        if let Some(looper) = self.looper.as_ref() {
            looper.wake();
        }
    }

    /// Process any delayed background tasks whose due time has passed.
    ///
    /// Should be called from the main loop on every iteration (e.g. just
    /// before calling `ALooper_pollOnce`).
    pub fn tick(&self) {
        let now = Instant::now();
        let mut ready: Vec<BoxedTask> = Vec::new();
        {
            let mut delayed = self.delayed.lock();
            while delayed.first().map(|d| d.due <= now).unwrap_or(false) {
                ready.push(delayed.remove(0).task);
            }
        }
        for task in ready {
            self.pool.dispatch(task);
        }
    }

    /// Drain all pending **main-thread** tasks synchronously.
    ///
    /// Useful in tests or when the looper callback is not set up.
    pub fn flush_main_thread_tasks(&self) {
        loop {
            let task = {
                let mut q = self.main_queue.lock();
                pop_main_task(&mut q)
            };
            match task {
                Some((task, cancel_local)) => run_main_task(task, cancel_local),
                None => break,
            }
        }
    }

    /// Stop accepting new tasks and signal the thread-pool to wind down.
    pub fn shutdown(&self) {
        assert!(
            self.is_main_thread(),
            "AndroidDispatcher must be shut down on its owner thread"
        );
        // Drain to quiescence while still accepting owner-thread wakeups. In
        // particular, dropping GPUI callback senders can notify EventListeners;
        // their LocalRunnables must be run/dropped on this owner after notify
        // releases its internal lock. Seal atomically only after the queue is
        // empty. Native-session retirement removes library-owned producers
        // before reaching this point.
        loop {
            let pending = {
                let mut queue = self.main_queue.lock();
                if queue.tasks.is_empty() {
                    for (key, scope) in &queue.local_scopes {
                        assert!(
                            queue.retiring_scopes.contains(key)
                                && queue.sealed_scopes.contains(key)
                                && scope.is_retiring()
                                && scope.live_task_count() == 0,
                            "AndroidDispatcher shutdown before local task scope retirement"
                        );
                    }
                    self.shutdown.store(true, Ordering::SeqCst);
                    break;
                }
                std::mem::take(&mut queue.tasks)
            };
            for task in pending {
                let cancel_local = match &task {
                    MainTask::Local { scope, .. } => {
                        let queue = self.main_queue.lock();
                        queue.retiring_scopes.contains(&scope_key(scope)) || scope.is_retiring()
                    }
                    MainTask::Generic(_) => false,
                };
                run_main_task(task, cancel_local);
            }
        }
        self.unregister_from_looper();
        let delayed = std::mem::take(&mut *self.delayed.lock());
        drop(delayed);
        self.pool.shutdown();
    }

    /// Begin cancellation for every local executor owned by this dispatcher.
    /// Must run on the owner thread before callback producers are detached.
    pub(crate) fn begin_local_task_retirements(&self) -> Vec<Arc<LocalTaskScope>> {
        assert!(
            self.is_main_thread(),
            "local task retirement is owner-thread-only"
        );
        let scopes = {
            let queue = self.main_queue.lock();
            queue.local_scopes.values().cloned().collect::<Vec<_>>()
        };
        for scope in &scopes {
            <Self as PlatformDispatcher>::begin_local_task_retirement(self, scope);
            // The dispatcher phase is set first under its queue lock; this
            // wake is deliberately outside that lock.
            scope.begin_retirement();
        }
        scopes
    }

    /// Drain callbacks/cancellations until each local executor has no live
    /// task headers and can atomically seal admission.
    pub(crate) fn finish_local_task_retirements(&self, scopes: &[Arc<LocalTaskScope>]) {
        assert!(
            self.is_main_thread(),
            "local task retirement is owner-thread-only"
        );
        loop {
            self.flush_main_thread_tasks();
            if scopes.iter().all(|scope| {
                <Self as PlatformDispatcher>::finish_local_task_retirement(self, scope)
            }) {
                return;
            }
            std::thread::yield_now();
        }
    }

    fn enqueue_local_task(&self, scope: Arc<LocalTaskScope>, runnable: RunnableVariant) {
        let mut queue = self.main_queue.lock();
        assert!(
            !self.shutdown.load(Ordering::Acquire),
            "local runnable scheduled after Android dispatcher retirement"
        );
        let key = scope_key(&scope);
        assert!(
            queue.local_scopes.contains_key(&key),
            "unknown Android local task scope"
        );
        queue.tasks.push_back(MainTask::Local { scope, runnable });
        wake_pipe(queue.write_fd);
    }

    // ── private helpers ───────────────────────────────────────────────────────

    fn register_with_looper(&self) {
        // We pass `main_queue` as the callback data pointer.  The callback
        // is a free `extern "C"` function that reconstructs the Arc from the
        // raw pointer.
        //
        // SAFETY: `self` outlives the looper registration because we hold an
        // `Arc<Self>` for the lifetime of the process (stored in
        // `GLOBAL_DISPATCHER`).
        let data_ptr = Arc::into_raw(Arc::clone(&self.main_queue)) as *mut std::ffi::c_void;

        let Some(looper) = self.looper.as_ref() else {
            drop(unsafe { Arc::from_raw(data_ptr as *const Mutex<MainQueue>) });
            return;
        };
        let ret = unsafe {
            ALooper_addFd(
                looper.ptr().as_ptr().cast(),
                self.read_fd,
                0, // ident — unused when callback is Some
                ALOOPER_EVENT_INPUT,
                Some(looper_callback),
                data_ptr,
            )
        };

        if ret == 1 {
            self.looper_data.store(data_ptr, Ordering::Release);
            self.looper_registered.store(true, Ordering::Release);
        } else {
            // ALooper did not take ownership of the raw Arc passed as callback
            // data, so reclaim it here instead of leaking the queue.
            drop(unsafe { Arc::from_raw(data_ptr as *const Mutex<MainQueue>) });
            log::warn!(
                "ALooper_addFd returned {} (expected 1); foreground dispatch may not work",
                ret
            );
        }
    }

    /// Unregister only on the looper owner. Returns false when a late worker
    /// drop cannot safely perform the owner-only NDK operation; in that case
    /// Drop intentionally leaves the fd/queue alive rather than invalidating a
    /// callback still registered with ALooper.
    fn unregister_from_looper(&self) -> bool {
        if self.looper.is_none() || !self.looper_registered.load(Ordering::Acquire) {
            return true;
        }
        if !self.is_main_thread() {
            log::error!("AndroidDispatcher reached its last Arc before owner-thread shutdown");
            return false;
        }
        let Some(looper) = self.looper.as_ref() else {
            return true;
        };
        let result = unsafe { ALooper_removeFd(looper.ptr().as_ptr().cast(), self.read_fd) };
        if result < 0 {
            log::error!(
                "ALooper_removeFd failed with {}; keeping registration alive",
                result
            );
            return false;
        }
        self.looper_registered.store(false, Ordering::Release);
        let data = self
            .looper_data
            .swap(std::ptr::null_mut(), Ordering::AcqRel);
        if !data.is_null() {
            // ALooper confirms this callback is no longer registered (result
            // 1 removed it; 0 means it had already been removed). Reclaim the
            // strong count transferred by Arc::into_raw in register_with_looper.
            drop(unsafe { Arc::from_raw(data as *const Mutex<MainQueue>) });
        }
        true
    }
}

impl Default for AndroidDispatcher {
    fn default() -> Self {
        panic!(
            "AndroidDispatcher must be constructed via `AndroidDispatcher::new()` \
             on the main thread"
        );
    }
}

impl Drop for AndroidDispatcher {
    fn drop(&mut self) {
        self.shutdown.store(true, Ordering::SeqCst);
        if !self.unregister_from_looper() {
            // ALooper still has the queue Arc and read fd registered. Preserve
            // its native owner reference too; releasing it here could invalidate
            // a registration that only the owner thread may remove.
            if let Some(looper) = self.looper.take() {
                std::mem::forget(looper);
            }
            return;
        }
        // Close file descriptors after the looper callback is detached.
        unsafe {
            libc_close(self.read_fd);
            libc_close(self.main_queue.lock().write_fd);
        }
    }
}

fn pop_main_task(queue: &mut MainQueue) -> Option<(MainTask, bool)> {
    let task = queue.tasks.pop_front()?;
    let cancel_local = match &task {
        MainTask::Generic(_) => false,
        MainTask::Local { scope, .. } => {
            queue.retiring_scopes.contains(&scope_key(scope)) || scope.is_retiring()
        }
    };
    Some((task, cancel_local))
}

fn run_main_task(task: MainTask, cancel_local: bool) {
    match task {
        MainTask::Generic(task) => task(),
        MainTask::Local { runnable, .. } if cancel_local => drop(runnable),
        MainTask::Local { runnable, .. } => {
            runnable.run();
        }
    }
}

// ── ALooper callback ──────────────────────────────────────────────────────────

/// Called by `ALooper` on the main thread when the wake pipe becomes readable.
///
/// Drains the entire task queue before returning 1 (keep the fd registered).
unsafe extern "C" fn looper_callback(fd: RawFd, _events: i32, data: *mut std::ffi::c_void) -> i32 {
    // Reconstruct the Arc without dropping it (we'll re-leak at the end).
    let queue_arc = unsafe { Arc::from_raw(data as *const Mutex<MainQueue>) };

    // Drain the wake pipe (ignore errors — just consume the byte(s)).
    let mut buf = [0u8; 64];
    loop {
        let n = unsafe { libc_read(fd, buf.as_mut_ptr() as *mut std::ffi::c_void, buf.len()) };
        if n <= 0 {
            break;
        }
    }

    // Run all queued tasks.
    loop {
        let task = {
            let mut q = queue_arc.lock();
            pop_main_task(&mut q)
        };
        match task {
            Some((task, cancel_local)) => run_main_task(task, cancel_local),
            None => break,
        }
    }

    // Leak the Arc again so it isn't freed — the data pointer lifetime is
    // managed by `AndroidDispatcher`.
    std::mem::forget(queue_arc);

    1 // keep fd registered
}

// ── pipe helpers ──────────────────────────────────────────────────────────────

fn create_pipe() -> std::io::Result<(RawFd, RawFd)> {
    let mut fds = [0i32; 2];
    let ret = unsafe { libc_pipe(fds.as_mut_ptr()) };
    if ret != 0 {
        return Err(std::io::Error::last_os_error());
    }
    // Set both ends non-blocking so we never block in the callback.
    set_nonblocking(fds[0]);
    set_nonblocking(fds[1]);
    Ok((fds[0], fds[1]))
}

fn set_nonblocking(fd: RawFd) {
    unsafe {
        let flags = libc_fcntl(fd, LIBC_F_GETFL, 0);
        if flags >= 0 {
            libc_fcntl(fd, LIBC_F_SETFL, flags | LIBC_O_NONBLOCK);
        }
    }
}

/// Write a single wake byte to the pipe.
fn wake_pipe(write_fd: RawFd) {
    let buf = [1u8; 1];
    unsafe {
        libc_write(write_fd, buf.as_ptr() as *const std::ffi::c_void, 1);
    }
}

// ── minimal libc bindings ─────────────────────────────────────────────────────
// We declare only the symbols we actually use, keeping the dependency surface
// small.  The `libc` crate could be used here instead, but this avoids adding
// a workspace dependency just for this module.

const LIBC_F_GETFL: i32 = 3;
const LIBC_F_SETFL: i32 = 4;
const LIBC_O_NONBLOCK: i32 = 0o4000;

unsafe extern "C" {
    fn pipe(pipefd: *mut i32) -> i32;
    fn read(fd: i32, buf: *mut std::ffi::c_void, count: usize) -> isize;
    fn write(fd: i32, buf: *const std::ffi::c_void, count: usize) -> isize;
    fn close(fd: i32) -> i32;
    fn fcntl(fd: i32, cmd: i32, ...) -> i32;
}

#[inline(always)]
unsafe fn libc_pipe(fds: *mut i32) -> i32 {
    unsafe { pipe(fds) }
}
#[inline(always)]
unsafe fn libc_read(fd: i32, buf: *mut std::ffi::c_void, count: usize) -> isize {
    unsafe { read(fd, buf, count) }
}
#[inline(always)]
unsafe fn libc_write(fd: i32, buf: *const std::ffi::c_void, count: usize) -> isize {
    unsafe { write(fd, buf, count) }
}
#[inline(always)]
unsafe fn libc_close(fd: i32) -> i32 {
    unsafe { close(fd) }
}
#[inline(always)]
unsafe fn libc_fcntl(fd: i32, cmd: i32, arg: i32) -> i32 {
    unsafe { fcntl(fd, cmd, arg) }
}

// ── impl PlatformDispatcher ───────────────────────────────────────────────────

impl PlatformDispatcher for AndroidDispatcher {
    fn is_main_thread(&self) -> bool {
        // Delegate to the existing `is_main_thread` method.
        AndroidDispatcher::is_main_thread(self)
    }

    fn dispatch(&self, runnable: RunnableVariant, _priority: Priority) {
        if self.shutdown.load(Ordering::Acquire) {
            return;
        }
        // All non-realtime background tasks go to the thread-pool.
        // Priority-based scheduling is not yet implemented; all tasks are
        // treated equally by the pool.
        self.pool.dispatch(Box::new(move || {
            runnable.run();
        }));
    }

    fn dispatch_on_main_thread(&self, runnable: RunnableVariant, _priority: Priority) {
        let mut q = self.main_queue.lock();
        // Pair this check with shutdown empty-queue seal under the same lock.
        // Late posts after retirement are rejected; native-session teardown
        // first drains library-owned local producers on this owner thread.
        if self.shutdown.load(Ordering::Acquire) {
            drop(q);
            return;
        }
        q.tasks.push_back(MainTask::Generic(Box::new(move || {
            runnable.run();
        })));
        wake_pipe(q.write_fd);
    }

    fn create_local_task_scope(&self) -> Option<Arc<LocalTaskScope>> {
        let scope = Arc::new(LocalTaskScope::new());
        let key = scope_key(&scope);
        let mut queue = self.main_queue.lock();
        assert!(
            !self.shutdown.load(Ordering::Acquire),
            "cannot create a local task scope after dispatcher shutdown"
        );
        queue.local_scopes.insert(key, Arc::clone(&scope));
        Some(scope)
    }

    fn dispatch_local_task(&self, scope: Arc<LocalTaskScope>, runnable: RunnableVariant) {
        self.enqueue_local_task(scope, runnable);
    }

    fn dispatch_local_task_when_idle(
        &self,
        scope: Arc<LocalTaskScope>,
        runnable: RunnableVariant,
        _timeout: Option<Duration>,
    ) {
        // Android's current idle hook is the normal owner queue at low
        // priority; retain that behavior while preserving the typed scope tag.
        self.enqueue_local_task(scope, runnable);
    }

    fn dispatch_local_task_cancellation(
        &self,
        scope: Arc<LocalTaskScope>,
        runnable: RunnableVariant,
    ) {
        self.enqueue_local_task(scope, runnable);
    }

    fn begin_local_task_retirement(&self, scope: &Arc<LocalTaskScope>) {
        assert!(
            self.is_main_thread(),
            "local task retirement is owner-thread-only"
        );
        let key = scope_key(scope);
        let mut queue = self.main_queue.lock();
        assert!(
            queue.local_scopes.contains_key(&key),
            "unknown Android local task scope"
        );
        queue.retiring_scopes.insert(key);
        // ForegroundTaskRetirement calls scope.begin_retirement after this
        // hook returns, so waking tasks never occurs while the queue is locked.
    }

    fn drain_local_task_retirements(&self, _scope: &Arc<LocalTaskScope>) {
        assert!(
            self.is_main_thread(),
            "local task retirement is owner-thread-only"
        );
        loop {
            let task = {
                let mut queue = self.main_queue.lock();
                pop_main_task(&mut queue)
            };
            let Some((task, cancel_local)) = task else {
                break;
            };
            run_main_task(task, cancel_local);
        }
    }

    fn finish_local_task_retirement(&self, scope: &Arc<LocalTaskScope>) -> bool {
        assert!(
            self.is_main_thread(),
            "local task retirement is owner-thread-only"
        );
        let key = scope_key(scope);
        let mut queue = self.main_queue.lock();
        if !queue.retiring_scopes.contains(&key)
            || queue.tasks.iter().any(|task| {
                matches!(task, MainTask::Local { scope: queued, .. } if scope_key(queued) == key)
            })
            || !scope.seal_if_quiescent()
        {
            return false;
        }
        queue.sealed_scopes.insert(key);
        true
    }

    fn dispatch_after(&self, duration: Duration, runnable: RunnableVariant) {
        if self.shutdown.load(Ordering::Relaxed) {
            return;
        }
        let due = Instant::now() + duration;
        let mut delayed = self.delayed.lock();
        if self.shutdown.load(Ordering::Acquire) {
            drop(delayed);
            return;
        }
        delayed.push(DelayedTask {
            due,
            task: Box::new(move || {
                runnable.run();
            }),
        });
        delayed.sort_by_key(|d| d.due);
        drop(delayed);
        self.wake_looper();
    }

    fn spawn_realtime(&self, f: Box<dyn FnOnce() + Send>) {
        // Spawn a dedicated thread for realtime (audio) tasks, matching the
        // behaviour of the Linux dispatcher.
        std::thread::Builder::new()
            .name("gpui-realtime".to_string())
            .spawn(move || {
                f();
            })
            .expect("failed to spawn realtime thread");
    }
}

// ── tests ─────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    };

    /// Verify that the thread-pool executes background tasks.
    #[test]
    fn background_tasks_run() {
        let pool = ThreadPool::new(2);
        let counter = Arc::new(AtomicUsize::new(0));

        for _ in 0..10 {
            let c = Arc::clone(&counter);
            pool.dispatch(Box::new(move || {
                c.fetch_add(1, Ordering::Relaxed);
            }));
        }

        // Give threads time to process.
        std::thread::sleep(Duration::from_millis(100));
        assert_eq!(counter.load(Ordering::Relaxed), 10);
    }

    /// Verify that delayed tasks are not dispatched before their due time.
    #[test]
    fn delayed_tasks_not_early() {
        // Build a dispatcher without a real looper by constructing state manually.
        let (read_fd, write_fd) = create_pipe().unwrap();

        let main_queue = Arc::new(Mutex::new(MainQueue {
            tasks: VecDeque::new(),
            local_scopes: HashMap::new(),
            retiring_scopes: HashSet::new(),
            sealed_scopes: HashSet::new(),
            write_fd,
        }));

        let dispatcher = AndroidDispatcher {
            main_queue,
            read_fd,
            looper: None,
            pool: ThreadPool::new(1),
            delayed: Mutex::new(Vec::new()),
            shutdown: AtomicBool::new(false),
            looper_registered: AtomicBool::new(false),
            looper_data: AtomicPtr::new(std::ptr::null_mut()),
            owner_thread: std::thread::current().id(),
        };

        let ran = Arc::new(AtomicBool::new(false));
        let ran2 = Arc::clone(&ran);

        dispatcher.dispatch_after(Duration::from_secs(60), move || {
            ran2.store(true, Ordering::Relaxed);
        });

        dispatcher.tick();
        assert!(!ran.load(Ordering::Relaxed), "task should not run yet");

        // Headless shutdown and Drop are null-looper-safe and close the pipes.
        dispatcher.shutdown();
    }

    #[test]
    fn retirement_cancels_accepted_local_runnables_on_the_owner() {
        struct DropThread {
            observed: Arc<Mutex<Option<std::thread::ThreadId>>>,
        }
        impl Drop for DropThread {
            fn drop(&mut self) {
                *self.observed.lock() = Some(std::thread::current().id());
            }
        }

        let dispatcher = AndroidDispatcher::new_headless();
        let foreground = gpui::ForegroundExecutor::new(dispatcher.clone());
        let owner = std::thread::current().id();
        let dropped_on = Arc::new(Mutex::new(None));
        let probe = DropThread {
            observed: Arc::clone(&dropped_on),
        };
        let polls = Arc::new(std::sync::atomic::AtomicUsize::new(0));
        let polls_future = Arc::clone(&polls);

        // This runnable is accepted before the retirement cut, but is still
        // queued. Retirement must turn it into owner-thread cancellation
        // instead of polling the user future.
        let _task = foreground.spawn(async move {
            let _drop_thread = probe;
            polls_future.fetch_add(1, Ordering::SeqCst);
            std::future::pending::<()>().await;
        });

        let scopes = dispatcher.begin_local_task_retirements();
        dispatcher.finish_local_task_retirements(&scopes);

        assert_eq!(polls.load(Ordering::SeqCst), 0);
        assert_eq!(*dropped_on.lock(), Some(owner));
        assert!(scopes.iter().all(|scope| scope.live_task_count() == 0));
        dispatcher.shutdown();
    }

    #[test]
    fn shutdown_drains_accepted_tasks_and_rejects_late_tasks() {
        let dispatcher = AndroidDispatcher::new_headless();
        let observed = Arc::new(Mutex::new(Vec::new()));
        let owner = std::thread::current().id();
        let dropped_on = Arc::new(Mutex::new(None));
        struct DropProbe(Arc<Mutex<Option<std::thread::ThreadId>>>);
        impl Drop for DropProbe {
            fn drop(&mut self) {
                *self.0.lock() = Some(std::thread::current().id());
            }
        }
        let probe = DropProbe(Arc::clone(&dropped_on));
        let from_task = Arc::clone(&observed);
        dispatcher.dispatch_on_main_thread(move || from_task.lock().push(1));
        dispatcher.dispatch_after(Duration::from_secs(600), move || drop(probe));
        dispatcher.shutdown();
        assert!(dispatcher.pool.sender.lock().is_none());
        assert!(dispatcher.delayed.lock().is_empty());
        assert_eq!(*dropped_on.lock(), Some(owner));
        assert_eq!(*observed.lock(), vec![1]);
        let from_late_task = Arc::clone(&observed);
        dispatcher.dispatch_on_main_thread(move || from_late_task.lock().push(2));
        dispatcher.flush_main_thread_tasks();
        assert_eq!(*observed.lock(), vec![1]);
    }

    /// Verify pipe creation succeeds.
    #[test]
    fn pipe_creation() {
        let (r, w) = create_pipe().expect("pipe");
        unsafe {
            libc_close(r);
            libc_close(w);
        }
    }
}
