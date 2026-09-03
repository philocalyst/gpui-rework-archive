use collections::BTreeMap;
use gpui_util::post_inc;
use std::{
    cell::{Cell, RefCell},
    fmt::Debug,
    rc::Rc,
};

pub(crate) struct SubscriberSet<EmitterKey, Callback>(
    Rc<RefCell<SubscriberSetState<EmitterKey, Callback>>>,
);

impl<EmitterKey, Callback> Clone for SubscriberSet<EmitterKey, Callback> {
    fn clone(&self) -> Self {
        SubscriberSet(self.0.clone())
    }
}

struct SubscriberSetState<EmitterKey, Callback> {
    subscribers: BTreeMap<EmitterKey, Option<BTreeMap<usize, Subscriber<Callback>>>>,
    next_subscriber_id: usize,
}

struct Subscriber<Callback> {
    active: Rc<Cell<bool>>,
    dropped: Rc<Cell<bool>>,
    callback: Callback,
}

impl<EmitterKey, Callback> SubscriberSet<EmitterKey, Callback>
where
    EmitterKey: 'static + Ord + Clone + Debug,
    Callback: 'static,
{
    pub fn new() -> Self {
        Self(Rc::new(RefCell::new(SubscriberSetState {
            subscribers: Default::default(),
            next_subscriber_id: 0,
        })))
    }

    /// Inserts a new [`Subscription`] for the given `emitter_key`. By default, subscriptions
    /// are inert, meaning that they won't be listed when calling `[SubscriberSet::remove]` or `[SubscriberSet::retain]`.
    /// This method returns a tuple of a [`Subscription`] and an `impl FnOnce`, and you can use the latter
    /// to activate the [`Subscription`].
    pub fn insert(
        &self,
        emitter_key: EmitterKey,
        callback: Callback,
    ) -> (Subscription, impl FnOnce() + use<EmitterKey, Callback>) {
        let active = Rc::new(Cell::new(false));
        let dropped = Rc::new(Cell::new(false));
        let mut lock = self.0.borrow_mut();
        let subscriber_id = post_inc(&mut lock.next_subscriber_id);
        lock.subscribers
            .entry(emitter_key.clone())
            .or_default()
            .get_or_insert_with(Default::default)
            .insert(
                subscriber_id,
                Subscriber {
                    active: active.clone(),
                    dropped: dropped.clone(),
                    callback,
                },
            );
        let this = self.0.clone();

        let subscription = Subscription {
            unsubscribe: Some(Box::new(move || {
                dropped.set(true);

                let mut lock = this.borrow_mut();
                let Some(subscribers) = lock.subscribers.get_mut(&emitter_key) else {
                    return;
                };

                if let Some(subscribers) = subscribers {
                    subscribers.remove(&subscriber_id);
                    if subscribers.is_empty() {
                        lock.subscribers.remove(&emitter_key);
                    }
                }
            })),
        };
        (subscription, move || active.set(true))
    }

    pub fn remove(
        &self,
        emitter: &EmitterKey,
    ) -> impl IntoIterator<Item = Callback> + use<EmitterKey, Callback> {
        let subscribers = self.0.borrow_mut().subscribers.remove(emitter);
        subscribers
            .unwrap_or_default()
            .map(|s| s.into_values())
            .into_iter()
            .flatten()
            .filter_map(|subscriber| {
                if subscriber.active.get() {
                    Some(subscriber.callback)
                } else {
                    None
                }
            })
    }

    /// Call the given callback for each subscriber to the given emitter.
    /// If the callback returns false, the subscriber is removed.
    pub fn retain<F>(&self, emitter: &EmitterKey, mut f: F)
    where
        F: FnMut(&mut Callback) -> bool,
    {
        let Some(mut subscribers) = self
            .0
            .borrow_mut()
            .subscribers
            .get_mut(emitter)
            .and_then(|s| s.take())
        else {
            return;
        };

        subscribers.retain(|_, subscriber| {
            if !subscriber.active.get() {
                return true;
            }
            if subscriber.dropped.get() {
                return false;
            }
            let keep = f(&mut subscriber.callback);
            keep && !subscriber.dropped.get()
        });
        let mut lock = self.0.borrow_mut();

        // Add any new subscribers that were added while invoking the callback.
        if let Some(Some(new_subscribers)) = lock.subscribers.remove(emitter) {
            subscribers.extend(new_subscribers);
        }

        if !subscribers.is_empty() {
            lock.subscribers.insert(emitter.clone(), Some(subscribers));
        }
    }
}

/// A handle to a subscription created by GPUI. When dropped, the subscription
/// is cancelled and the callback will no longer be invoked.
#[must_use]
pub struct Subscription {
    unsubscribe: Option<Box<dyn FnOnce() + 'static>>,
}

impl Subscription {
    /// Creates a new subscription with a callback that gets invoked when
    /// this subscription is dropped.
    pub fn new(unsubscribe: impl 'static + FnOnce()) -> Self {
        Self {
            unsubscribe: Some(Box::new(unsubscribe)),
        }
    }

    /// Detaches the subscription from this handle. The callback will
    /// continue to be invoked until the entities it has been
    /// subscribed to are dropped
    pub fn detach(mut self) {
        self.unsubscribe.take();
    }

    /// Joins two subscriptions into a single subscription. Detach will
    /// detach both interior subscriptions.
    pub fn join(mut subscription_a: Self, mut subscription_b: Self) -> Self {
        let a_unsubscribe = subscription_a.unsubscribe.take();
        let b_unsubscribe = subscription_b.unsubscribe.take();
        Self {
            unsubscribe: Some(Box::new(move || {
                if let Some(self_unsubscribe) = a_unsubscribe {
                    self_unsubscribe();
                }
                if let Some(other_unsubscribe) = b_unsubscribe {
                    other_unsubscribe();
                }
            })),
        }
    }
}

impl Drop for Subscription {
    fn drop(&mut self) {
        if let Some(unsubscribe) = self.unsubscribe.take() {
            unsubscribe();
        }
    }
}

impl std::fmt::Debug for Subscription {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Subscription").finish()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{AppContext, EventEmitter, Global, TestApp, TestAppContext};

    #[test]
    fn test_unsubscribe_during_callback_with_insert() {
        struct TestGlobal;
        impl Global for TestGlobal {}

        let mut app = TestApp::new();
        app.set_global(TestGlobal);

        let observer_a_count = Rc::new(Cell::new(0usize));
        let observer_b_count = Rc::new(Cell::new(0usize));

        let sub_a: Rc<RefCell<Option<Subscription>>> = Default::default();
        let sub_b: Rc<RefCell<Option<Subscription>>> = Default::default();

        // Observer A fires first (lower subscriber_id). It drops itself and
        // inserts a new observer for the same global.
        *sub_a.borrow_mut() = Some(app.update({
            let count = observer_a_count.clone();
            let sub_a = sub_a.clone();
            move |cx| {
                cx.observe_global::<TestGlobal>(move |cx| {
                    count.set(count.get() + 1);
                    sub_a.borrow_mut().take();
                    cx.observe_global::<TestGlobal>(|_| {}).detach();
                })
            }
        }));

        // Observer B fires second. It just drops itself.
        *sub_b.borrow_mut() = Some(app.update({
            let count = observer_b_count.clone();
            let sub_b = sub_b.clone();
            move |cx| {
                cx.observe_global::<TestGlobal>(move |_cx| {
                    count.set(count.get() + 1);
                    sub_b.borrow_mut().take();
                })
            }
        }));

        // Both fire once.
        app.update(|cx| cx.set_global(TestGlobal));
        assert_eq!(observer_a_count.get(), 1);
        assert_eq!(observer_b_count.get(), 1);

        // Neither should fire again — both dropped their subscriptions.
        app.update(|cx| cx.set_global(TestGlobal));
        assert_eq!(observer_a_count.get(), 1);
        assert_eq!(observer_b_count.get(), 1, "orphaned subscriber fired again");
    }

    #[test]
    fn test_callback_dropped_by_earlier_callback_does_not_fire() {
        struct TestGlobal;
        impl Global for TestGlobal {}

        let mut app = TestApp::new();
        app.set_global(TestGlobal);

        let observer_b_count = Rc::new(Cell::new(0usize));
        let sub_b: Rc<RefCell<Option<Subscription>>> = Default::default();

        // Observer A fires first and drops B's subscription.
        app.update({
            let sub_b = sub_b.clone();
            move |cx| {
                cx.observe_global::<TestGlobal>(move |_cx| {
                    sub_b.borrow_mut().take();
                })
                .detach();
            }
        });

        // Observer B fires second — but A already dropped it.
        *sub_b.borrow_mut() = Some(app.update({
            let count = observer_b_count.clone();
            move |cx| {
                cx.observe_global::<TestGlobal>(move |_cx| {
                    count.set(count.get() + 1);
                })
            }
        }));

        app.update(|cx| cx.set_global(TestGlobal));
        assert_eq!(
            observer_b_count.get(),
            0,
            "B should not fire — A dropped its subscription"
        );
    }

    #[test]
    fn test_self_drop_during_callback() {
        struct TestGlobal;
        impl Global for TestGlobal {}

        let mut app = TestApp::new();
        app.set_global(TestGlobal);

        let count = Rc::new(Cell::new(0usize));
        let sub: Rc<RefCell<Option<Subscription>>> = Default::default();

        *sub.borrow_mut() = Some(app.update({
            let count = count.clone();
            let sub = sub.clone();
            move |cx| {
                cx.observe_global::<TestGlobal>(move |_cx| {
                    count.set(count.get() + 1);
                    sub.borrow_mut().take();
                })
            }
        }));

        app.update(|cx| cx.set_global(TestGlobal));
        assert_eq!(count.get(), 1);

        app.update(|cx| cx.set_global(TestGlobal));
        assert_eq!(count.get(), 1, "should not fire after self-drop");
    }

    #[test]
    fn test_subscription_drop() {
        struct TestGlobal;
        impl Global for TestGlobal {}

        let mut app = TestApp::new();
        app.set_global(TestGlobal);

        let count = Rc::new(Cell::new(0usize));

        let subscription = app.update({
            let count = count.clone();
            move |cx| {
                cx.observe_global::<TestGlobal>(move |_cx| {
                    count.set(count.get() + 1);
                })
            }
        });

        drop(subscription);

        app.update(|cx| cx.set_global(TestGlobal));
        assert_eq!(count.get(), 0, "should not fire after drop");
    }

    struct Emitter;

    struct EvtA(usize);

    struct EvtB(char);

    impl EventEmitter<EvtA> for Emitter {}

    impl EventEmitter<EvtB> for Emitter {}

    #[test]
    fn emit_reaches_subscribers_in_registration_order() {
        let mut cx = TestAppContext::single();
        let emitter = cx.update(|cx| cx.new(|_| Emitter));
        let received = Rc::new(RefCell::new(Vec::new()));

        cx.update(|cx| {
            cx.subscribe(&emitter, {
                let received = received.clone();
                move |_, event: &EvtA, _| received.borrow_mut().push(("first", event.0))
            })
            .detach();
            cx.subscribe(&emitter, {
                let received = received.clone();
                move |_, event: &EvtA, _| received.borrow_mut().push(("second", event.0))
            })
            .detach();
        });

        cx.update(|cx| cx.emit(&emitter, EvtA(1)));
        assert_eq!(
            *received.borrow(),
            vec![("first", 1), ("second", 1)],
            "subscribers must fire in registration order"
        );

        drop(emitter);
        cx.update(|_| {});
    }

    #[test]
    fn distinct_event_types_route_independently() {
        let mut cx = TestAppContext::single();
        let emitter = cx.update(|cx| cx.new(|_| Emitter));
        let a_count = Rc::new(Cell::new(0));
        let b_seen = Rc::new(RefCell::new(Vec::new()));

        cx.update(|cx| {
            cx.subscribe(&emitter, {
                let a_count = a_count.clone();
                move |_, _: &EvtA, _| a_count.set(a_count.get() + 1)
            })
            .detach();
            cx.subscribe(&emitter, {
                let b_seen = b_seen.clone();
                move |_, event: &EvtB, _| b_seen.borrow_mut().push(event.0)
            })
            .detach();
        });

        cx.update(|cx| cx.emit(&emitter, EvtB('x')));
        assert_eq!(a_count.get(), 0, "EvtB must not reach the EvtA subscriber");
        assert_eq!(*b_seen.borrow(), vec!['x']);

        cx.update(|cx| cx.emit(&emitter, EvtA(9)));
        assert_eq!(a_count.get(), 1);
        assert_eq!(
            *b_seen.borrow(),
            vec!['x'],
            "EvtA must not reach the EvtB subscriber"
        );

        drop(emitter);
        cx.update(|_| {});
    }

    #[test]
    fn subscribe_self_receives_own_emit() {
        let cx = TestAppContext::single();
        let emitter = cx.update(|cx| cx.new(|_| Emitter));
        let seen = Rc::new(RefCell::new(Vec::new()));

        let subscription = cx.update(|cx| {
            emitter.update(cx, |_, cx| {
                cx.subscribe_self({
                    let seen = seen.clone();
                    move |_, event: &EvtA, _| seen.borrow_mut().push(event.0)
                })
            })
        });

        cx.update(|cx| emitter.update(cx, |_, cx| cx.emit(EvtA(42))));
        assert_eq!(*seen.borrow(), vec![42]);

        drop(subscription);
        drop(emitter);
        cx.update(|_| {});
    }

    #[test]
    fn no_delivery_after_emitter_drop_with_cleanup() {
        let mut cx = TestAppContext::single();
        let emitter = cx.update(|cx| cx.new(|_| Emitter));
        let count = Rc::new(Cell::new(0));
        let weak = emitter.downgrade();

        let subscription = cx.update(|cx| {
            cx.subscribe(&emitter, {
                let count = count.clone();
                move |_, _: &EvtA, _| count.set(count.get() + 1)
            })
        });

        cx.update(|cx| cx.emit(&emitter, EvtA(1)));
        assert_eq!(count.get(), 1);

        drop(emitter);
        cx.update(|_| {});
        weak.assert_released();

        drop(subscription);
        cx.update(|_| {});
    }

    #[test]
    fn dropped_subscription_stops_receiving() {
        let mut cx = TestAppContext::single();
        let emitter = cx.update(|cx| cx.new(|_| Emitter));
        let count = Rc::new(Cell::new(0));

        let subscription = cx.update(|cx| {
            cx.subscribe(&emitter, {
                let count = count.clone();
                move |_, _: &EvtA, _| count.set(count.get() + 1)
            })
        });

        cx.update(|cx| cx.emit(&emitter, EvtA(1)));
        assert_eq!(count.get(), 1);

        drop(subscription);
        cx.update(|cx| cx.emit(&emitter, EvtA(2)));
        assert_eq!(
            count.get(),
            1,
            "dropped subscription must not receive events"
        );

        drop(emitter);
        cx.update(|_| {});
    }

    #[test]
    fn inert_subscribers_are_not_delivered() {
        let set = SubscriberSet::<usize, fn(&mut Vec<usize>)>::new();
        let (_active, activate) = set.insert(0, |out| out.push(1));
        let (_inert, _) = set.insert(0, |out| out.push(2));
        activate();

        let mut out = Vec::new();
        for callback in set.remove(&0) {
            callback(&mut out);
        }
        assert_eq!(out, vec![1], "inert subscribers must be filtered out");
    }

    #[test]
    fn joined_subscription_unsubscribes_both_when_dropped() {
        let a_dropped = Rc::new(Cell::new(false));
        let b_dropped = Rc::new(Cell::new(false));

        let joined = Subscription::join(
            Subscription::new({
                let a_dropped = a_dropped.clone();
                move || a_dropped.set(true)
            }),
            Subscription::new({
                let b_dropped = b_dropped.clone();
                move || b_dropped.set(true)
            }),
        );

        assert!(!a_dropped.get() && !b_dropped.get());
        drop(joined);
        assert!(a_dropped.get() && b_dropped.get());
    }

    #[test]
    fn detaching_joined_subscription_keeps_both_alive() {
        let a_dropped = Rc::new(Cell::new(false));
        let b_dropped = Rc::new(Cell::new(false));

        let joined = Subscription::join(
            Subscription::new({
                let a_dropped = a_dropped.clone();
                move || a_dropped.set(true)
            }),
            Subscription::new({
                let b_dropped = b_dropped.clone();
                move || b_dropped.set(true)
            }),
        );

        joined.detach();
        assert!(
            !a_dropped.get() && !b_dropped.get(),
            "detach must keep both subscriptions alive"
        );
    }
}
