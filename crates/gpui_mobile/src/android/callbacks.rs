//! Owner-thread registry for Android's non-Send GPUI callbacks.
//!
//! AndroidWindow and AndroidPlatform are shared handles. Their state stores only
//! opaque registration IDs; callback closures stay in the thread-local registry
//! of the thread that created them. Cross-thread callers may enqueue typed events
//! through AndroidDispatcher, but the callback is always invoked and destroyed on
//! its owner thread.

use std::{
    cell::RefCell,
    collections::VecDeque,
    num::NonZeroU64,
    sync::{
        Arc,
        atomic::{AtomicBool, AtomicU64, Ordering},
    },
    thread::{self, ThreadId},
};

use super::window::WindowAppearance;
use super::{AndroidKeyEvent, DevicePixels, Size, TouchPoint, dispatcher::AndroidDispatcher};
use crate::owner_thread_registry::OwnerThreadRegistry;
use gpui::{RequestFrameOptions, WindowInsets};

static NEXT_CALLBACK_ID: AtomicU64 = AtomicU64::new(1);

#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq)]
pub(super) struct CallbackId(NonZeroU64);

thread_local! {
    static CALLBACKS: OwnerThreadRegistry<Callback> = OwnerThreadRegistry::new();
    static LOCAL_EVENTS: RefCell<VecDeque<(CallbackId, Arc<AtomicBool>, Event)>> = RefCell::new(VecDeque::new());
    static DRAINING_LOCAL_EVENTS: RefCell<bool> = const { RefCell::new(false) };
}

pub(super) enum Callback {
    Frame(Box<dyn FnMut(RequestFrameOptions) + 'static>),
    Touch(Box<dyn FnMut(TouchPoint) + 'static>),
    Key(Box<dyn FnMut(AndroidKeyEvent) -> bool + 'static>),
    Resize(Box<dyn FnMut(Size<DevicePixels>, f32) + 'static>),
    Close(Option<Box<dyn FnOnce() + 'static>>),
    Appearance(Box<dyn FnMut(WindowAppearance) + 'static>),
    Active(Box<dyn FnMut(bool) + 'static>),
    Visibility(Box<dyn FnMut(bool) + 'static>),
    Insets(Box<dyn FnMut(WindowInsets) + 'static>),
    DisplaysChanged(Box<dyn FnMut() + 'static>),
    Quit(Box<dyn FnMut() -> bool + 'static>),
    OpenUrls(Box<dyn FnMut(Vec<String>) + 'static>),
    Reopen(Box<dyn FnMut() + 'static>),
    KeyboardLayout(Box<dyn FnMut() + 'static>),
}

pub(super) enum Event {
    Frame(RequestFrameOptions),
    Touch(TouchPoint),
    Key(AndroidKeyEvent),
    Resize(Size<DevicePixels>, f32),
    Appearance(WindowAppearance),
    Active(bool),
    Visibility(bool),
    Insets(WindowInsets),
    DisplaysChanged,
    OpenUrls(Vec<String>),
    Reopen,
    KeyboardLayout,
}

pub(super) struct Registration(Arc<RegistrationInner>);

struct RegistrationInner {
    id: CallbackId,
    active: Arc<AtomicBool>,
    dispatcher: Option<Arc<AndroidDispatcher>>,
    owner: ThreadId,
}

impl Clone for Registration {
    fn clone(&self) -> Self {
        Self(Arc::clone(&self.0))
    }
}

impl Registration {
    pub(super) fn new(dispatcher: Option<Arc<AndroidDispatcher>>, callback: Callback) -> Self {
        let owner = thread::current().id();
        if let Some(dispatcher) = &dispatcher {
            assert!(
                dispatcher.is_main_thread(),
                "Android GPUI callbacks must be registered on their owning event-loop thread"
            );
        }
        let raw = NEXT_CALLBACK_ID
            .try_update(Ordering::Relaxed, Ordering::Relaxed, |id| id.checked_add(1))
            .expect("Android callback ID space exhausted");
        let id = CallbackId(NonZeroU64::new(raw).expect("callback IDs start at one"));
        CALLBACKS.with(|callbacks| {
            let previous = callbacks.insert(id.0.get(), callback);
            debug_assert!(previous.is_none());
            drop(previous);
        });
        Self(Arc::new(RegistrationInner {
            id,
            active: Arc::new(AtomicBool::new(true)),
            dispatcher,
            owner,
        }))
    }

    pub(super) fn dispatch(&self, event: Event) {
        self.dispatch_deferred(event);
        if thread::current().id() == self.0.owner
            && self.0.dispatcher.as_ref().is_none_or(|d| d.is_headless())
        {
            drain_owner_events();
        }
    }

    /// Invoke a key callback synchronously on its owner thread and return its
    /// handled result. Native Android uses this only for Back so it can let the
    /// Activity fallback run when GPUI does not consume Escape.
    pub(super) fn call_key(&self, event: AndroidKeyEvent) -> Option<bool> {
        assert_eq!(
            thread::current().id(),
            self.0.owner,
            "key callback called off owner thread"
        );
        if !self.0.active.load(Ordering::Acquire) {
            return None;
        }
        let id = self.0.id;
        let mut callback = CALLBACKS.with(|callbacks| callbacks.remove(id.0.get()))?;
        let result = match &mut callback {
            Callback::Key(callback) => Some(callback(event)),
            _ => {
                log::error!("Android callback kind mismatch for synchronous key event");
                None
            }
        };
        if self.0.active.load(Ordering::Acquire) {
            CALLBACKS.with(|callbacks| {
                let previous = callbacks.insert(id.0.get(), callback);
                debug_assert!(previous.is_none());
                drop(previous);
            });
        }
        result
    }

    pub(super) fn dispatch_deferred(&self, event: Event) {
        if !self.0.active.load(Ordering::Acquire) {
            return;
        }
        let id = self.0.id;
        let active = Arc::clone(&self.0.active);
        if let Some(dispatcher) = &self.0.dispatcher {
            if dispatcher.is_headless() && dispatcher.is_main_thread() {
                LOCAL_EVENTS.with(|queue| queue.borrow_mut().push_back((id, active, event)));
            } else {
                dispatcher.dispatch_on_main_thread(move || invoke(id, active, event));
            }
        } else if thread::current().id() == self.0.owner {
            LOCAL_EVENTS.with(|queue| queue.borrow_mut().push_back((id, active, event)));
        } else {
            log::error!("dropping Android callback event without an owner dispatcher");
        }
    }

    pub(super) fn call_once(&self) -> bool {
        assert_eq!(
            thread::current().id(),
            self.0.owner,
            "one-shot callback called off owner thread"
        );
        let id = self.0.id;
        let Some(mut callback) = CALLBACKS.with(|callbacks| callbacks.remove(id.0.get())) else {
            return false;
        };
        match &mut callback {
            Callback::Close(callback) => {
                if let Some(callback) = callback.take() {
                    callback();
                }
                true
            }
            _ => {
                log::error!("Android callback kind mismatch for one-shot");
                false
            }
        }
    }

    pub(super) fn call_quit(&self) -> Option<bool> {
        assert_eq!(
            thread::current().id(),
            self.0.owner,
            "quit callback called off owner thread"
        );
        let id = self.0.id;
        let mut callback = CALLBACKS.with(|callbacks| callbacks.remove(id.0.get()))?;
        let result = match &mut callback {
            Callback::Quit(callback) => Some(callback()),
            _ => {
                log::error!("Android callback kind mismatch for quit");
                None
            }
        };
        if self.0.active.load(Ordering::Acquire) {
            CALLBACKS.with(|callbacks| {
                let previous = callbacks.insert(id.0.get(), callback);
                debug_assert!(previous.is_none());
                drop(previous);
            });
        }
        result
    }
}

impl Drop for RegistrationInner {
    fn drop(&mut self) {
        self.active.store(false, Ordering::Release);
        let id = self.id;
        if thread::current().id() == self.owner {
            remove(id);
        } else if let Some(dispatcher) = &self.dispatcher {
            dispatcher.dispatch_on_main_thread(move || remove(id));
        }
    }
}

pub(super) fn drain_owner_events() {
    let already_draining = DRAINING_LOCAL_EVENTS.with(|draining| {
        let was = *draining.borrow();
        if !was {
            *draining.borrow_mut() = true;
        }
        was
    });
    if already_draining {
        return;
    }
    struct DrainGuard;
    impl Drop for DrainGuard {
        fn drop(&mut self) {
            DRAINING_LOCAL_EVENTS.with(|draining| *draining.borrow_mut() = false);
        }
    }
    let _guard = DrainGuard;
    loop {
        let next = LOCAL_EVENTS.with(|queue| queue.borrow_mut().pop_front());
        let Some((id, active, event)) = next else {
            break;
        };
        invoke(id, active, event);
    }
}

fn invoke(id: CallbackId, active: Arc<AtomicBool>, event: Event) {
    if !active.load(Ordering::Acquire) {
        return;
    }
    let Some(mut callback) = CALLBACKS.with(|callbacks| callbacks.remove(id.0.get())) else {
        return;
    };
    let reusable = match (&mut callback, event) {
        (Callback::Frame(cb), Event::Frame(v)) => {
            cb(v);
            true
        }
        (Callback::Touch(cb), Event::Touch(v)) => {
            cb(v);
            true
        }
        (Callback::Key(cb), Event::Key(v)) => {
            cb(v);
            true
        }
        (Callback::Resize(cb), Event::Resize(size, scale)) => {
            cb(size, scale);
            true
        }
        (Callback::Appearance(cb), Event::Appearance(v)) => {
            cb(v);
            true
        }
        (Callback::Active(cb), Event::Active(v)) => {
            cb(v);
            true
        }
        (Callback::Visibility(cb), Event::Visibility(v)) => {
            cb(v);
            true
        }
        (Callback::Insets(cb), Event::Insets(v)) => {
            cb(v);
            true
        }
        (Callback::DisplaysChanged(cb), Event::DisplaysChanged) => {
            cb();
            true
        }
        (Callback::OpenUrls(cb), Event::OpenUrls(v)) => {
            cb(v);
            true
        }
        (Callback::Reopen(cb), Event::Reopen) => {
            cb();
            true
        }
        (Callback::KeyboardLayout(cb), Event::KeyboardLayout) => {
            cb();
            true
        }
        _ => {
            log::error!("Android callback event kind did not match its registration");
            true
        }
    };
    if reusable && active.load(Ordering::Acquire) {
        CALLBACKS.with(|callbacks| {
            let previous = callbacks.insert(id.0.get(), callback);
            debug_assert!(previous.is_none());
            drop(previous);
        });
    }
}

fn remove(id: CallbackId) {
    let removed = CALLBACKS.with(|callbacks| callbacks.remove(id.0.get()));
    // Drop user state after the TLS RefCell borrow is gone. Destructors may
    // reenter callback registration or dispatch.
    drop(removed);
}

pub(super) fn clear_current_thread() {
    LOCAL_EVENTS.with(|events| events.borrow_mut().clear());
    let callbacks = CALLBACKS.with(OwnerThreadRegistry::take_all);
    // Callback destructors can touch the platform; never run them under the
    // TLS registry borrow.
    drop(callbacks);
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::{cell::RefCell, rc::Rc, sync::mpsc};

    #[test]
    fn headless_dispatch_invokes_non_send_callback_on_owner_thread() {
        let dispatcher = AndroidDispatcher::new_headless();
        let observed = Rc::new(RefCell::new(None));
        let callback_observed = Rc::clone(&observed);
        let registration = Registration::new(
            Some(Arc::clone(&dispatcher)),
            Callback::OpenUrls(Box::new(move |_| {
                *callback_observed.borrow_mut() = Some(thread::current().id());
            })),
        );
        let worker_registration = registration.clone();
        thread::spawn(move || {
            worker_registration.dispatch(Event::OpenUrls(vec!["test".into()]));
        })
        .join()
        .unwrap();

        assert!(observed.borrow().is_none());
        dispatcher.flush_main_thread_tasks();
        assert_eq!(*observed.borrow(), Some(thread::current().id()));
        drop(registration);
        dispatcher.flush_main_thread_tasks();
        dispatcher.shutdown();
    }

    struct DropProbe {
        owner: ThreadId,
        dropped_on_owner: mpsc::Sender<bool>,
        _not_send: Rc<()>,
    }

    impl Drop for DropProbe {
        fn drop(&mut self) {
            let _ = self
                .dropped_on_owner
                .send(thread::current().id() == self.owner);
        }
    }

    #[test]
    fn dropping_registration_on_worker_drops_non_send_callback_on_owner() {
        let dispatcher = AndroidDispatcher::new_headless();
        let (tx, rx) = mpsc::channel();
        let probe = DropProbe {
            owner: thread::current().id(),
            dropped_on_owner: tx,
            _not_send: Rc::new(()),
        };
        let registration = Registration::new(
            Some(Arc::clone(&dispatcher)),
            Callback::OpenUrls(Box::new(move |_| {
                let _keep_probe_alive = &probe;
            })),
        );

        thread::spawn(move || drop(registration)).join().unwrap();
        assert!(rx.try_recv().is_err());
        dispatcher.flush_main_thread_tasks();
        assert_eq!(rx.recv().unwrap(), true);
        dispatcher.shutdown();
    }

    #[test]
    fn removing_registration_drops_nested_registration_without_registry_borrow() {
        let dispatcher = AndroidDispatcher::new_headless();
        let nested = Registration::new(
            Some(Arc::clone(&dispatcher)),
            Callback::Reopen(Box::new(|| {})),
        );
        let outer = Registration::new(
            Some(Arc::clone(&dispatcher)),
            Callback::OpenUrls(Box::new(move |_| {
                let _keep_nested_alive = &nested;
            })),
        );

        drop(outer);
        dispatcher.flush_main_thread_tasks();
        // The outer callback destructor drops its captured registration,
        // which reenters the registry to remove the nested callback.
        dispatcher.shutdown();
    }

    #[test]
    fn headless_owner_dispatch_preserves_synchronous_delivery() {
        let dispatcher = AndroidDispatcher::new_headless();
        let count = Rc::new(RefCell::new(0));
        let callback_count = Rc::clone(&count);
        let registration = Registration::new(
            Some(Arc::clone(&dispatcher)),
            Callback::Reopen(Box::new(move || *callback_count.borrow_mut() += 1)),
        );

        registration.dispatch(Event::Reopen);
        assert_eq!(*count.borrow(), 1);
        drop(registration);
        dispatcher.shutdown();
    }

    #[test]
    fn synchronous_key_callback_returns_consumption_on_owner() {
        let observed = Rc::new(RefCell::new(Vec::new()));
        let callback_observed = Rc::clone(&observed);
        let registration = Registration::new(
            None,
            Callback::Key(Box::new(move |event| {
                callback_observed.borrow_mut().push(event.key_code);
                false
            })),
        );
        assert_eq!(
            registration.call_key(AndroidKeyEvent {
                key_code: 4,
                action: 0,
                meta_state: 0,
                unicode_char: 0,
            }),
            Some(false)
        );
        assert_eq!(*observed.borrow(), [4]);
        drop(registration);
    }
}
