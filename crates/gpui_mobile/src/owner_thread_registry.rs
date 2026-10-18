//! Small registry primitive for values that must stay on their owner thread.
//!
//! Android uses this for GPUI callbacks: only numeric IDs cross the dispatcher;
//! closure values remain in the owner thread's TLS registry. Kept platform
//! independent so the exact production storage and drop behavior is host-tested.

use std::{cell::RefCell, collections::HashMap};

pub(crate) struct OwnerThreadRegistry<T> {
    entries: RefCell<HashMap<u64, T>>,
}

impl<T> OwnerThreadRegistry<T> {
    pub(crate) fn new() -> Self {
        Self {
            entries: RefCell::new(HashMap::new()),
        }
    }

    /// Insert and return a replaced value. Its destructor runs only after the
    /// RefCell borrow is released, when the caller drops the returned value.
    pub(crate) fn insert(&self, id: u64, value: T) -> Option<T> {
        self.entries.borrow_mut().insert(id, value)
    }

    /// Remove and return a value without invoking or dropping it under borrow.
    pub(crate) fn remove(&self, id: u64) -> Option<T> {
        self.entries.borrow_mut().remove(&id)
    }

    /// Detach all registrations. The returned map must be dropped by its owner.
    pub(crate) fn take_all(&self) -> HashMap<u64, T> {
        std::mem::take(&mut *self.entries.borrow_mut())
    }
}

#[cfg(test)]
mod tests {
    use super::OwnerThreadRegistry;
    use std::{cell::RefCell, rc::Rc, sync::mpsc, thread, thread::ThreadId};

    thread_local! {
        static CALLBACKS: OwnerThreadRegistry<Box<dyn FnMut()>> = OwnerThreadRegistry::new();
    }

    struct DropProbe {
        owner: ThreadId,
        tx: mpsc::Sender<bool>,
        _not_send: Rc<()>,
    }

    impl Drop for DropProbe {
        fn drop(&mut self) {
            let _ = self.tx.send(thread::current().id() == self.owner);
        }
    }

    #[test]
    fn non_send_callback_is_invoked_and_dropped_only_by_owner_thread() {
        let owner = thread::current().id();
        let invocations = Rc::new(RefCell::new(Vec::new()));
        let callback_invocations = Rc::clone(&invocations);
        let (drop_tx, drop_rx) = mpsc::channel();
        let probe = DropProbe {
            owner,
            tx: drop_tx,
            _not_send: Rc::new(()),
        };

        CALLBACKS.with(|registry| {
            let replaced = registry.insert(
                7,
                Box::new(move || {
                    callback_invocations
                        .borrow_mut()
                        .push(thread::current().id());
                    let _keep_probe_alive = &probe;
                }),
            );
            assert!(replaced.is_none());
        });

        // Only the integer ID crosses the worker boundary. The Rc-capturing
        // closure itself is statically !Send and remains in owner-thread TLS.
        let (id_tx, id_rx) = mpsc::channel();
        thread::spawn(move || id_tx.send(7_u64).unwrap())
            .join()
            .unwrap();
        let callback_id = id_rx.recv().unwrap();
        let mut callback = CALLBACKS
            .with(|registry| registry.remove(callback_id))
            .unwrap();
        callback();
        drop(callback);

        assert_eq!(*invocations.borrow(), vec![owner]);
        assert!(drop_rx.recv().unwrap());
    }

    struct ReenterRegistryOnDrop;

    impl Drop for ReenterRegistryOnDrop {
        fn drop(&mut self) {
            CALLBACKS.with(|registry| drop(registry.remove(2)));
        }
    }

    #[test]
    fn removed_callback_drops_after_registry_borrow_and_can_reenter() {
        CALLBACKS.with(|registry| {
            registry.insert(2, Box::new(|| {}));
            let reenter = ReenterRegistryOnDrop;
            registry.insert(
                1,
                Box::new(move || {
                    let _keep_reenter_until_callback_drop = &reenter;
                }),
            );
        });

        let outer = CALLBACKS.with(|registry| registry.remove(1)).unwrap();
        drop(outer);
        CALLBACKS.with(|registry| assert!(registry.remove(2).is_none()));
    }

    #[test]
    fn owner_shutdown_detaches_before_dropping_callbacks() {
        CALLBACKS.with(|registry| {
            registry.insert(3, Box::new(|| {}));
            registry.insert(4, Box::new(|| {}));
        });
        let callbacks = CALLBACKS.with(OwnerThreadRegistry::take_all);
        assert_eq!(callbacks.len(), 2);
        drop(callbacks);
        CALLBACKS.with(|registry| assert!(registry.take_all().is_empty()));
    }
}
