use crate::{
    AnyView, AnyWindowHandle, AppContext, AsyncApp, DispatchPhase, EntityId, EventEmitter,
    FocusHandle, FocusOutEvent, Focusable, Global, KeystrokeObserver, Priority, Reservation,
    SubscriberSet, Subscription, Task, WeakEntity, WeakFocusHandle, Window, WindowHandle,
};
use anyhow::Result;
use futures::FutureExt;
use gpui_util::Deferred;
use std::{
    any::{Any, TypeId},
    borrow::{Borrow, BorrowMut},
    future::Future,
    ops,
    sync::Arc,
};

use super::{App, AsyncWindowContext, Entity, KeystrokeEvent};

/// App access scoped to the entity currently being constructed or updated.
///
/// GPUI passes `Context<T>` alongside `&mut T`. Use that value to read or
/// change this entity, and the context to create other entities, notify
/// consumers, register callbacks, or start tasks. The context dereferences to
/// [`App`], so app operations remain available without a second argument.
///
/// # Callbacks and ownership
///
/// [`listener`](Self::listener), [`observe`](Self::observe), and
/// [`spawn`](Self::spawn) refer to this entity weakly. They can work with it
/// while an owner remains and stop calling it after release. Keep returned
/// [`Subscription`] and [`Task`] handles on the owner when dropping that owner
/// should cancel the work. [`processor`](Self::processor) retains a strong
/// handle because its caller requires a return value.
/// [`observe_self`](Self::observe_self) and [`subscribe_self`](Self::subscribe_self)
/// also retain this entity; keep those subscriptions on an external owner.
///
/// # Borrowing this entity
///
/// `cx.entity()` returns a handle, but reading or updating that handle while
/// the current `&mut T` is borrowed panics. Use the supplied value instead.
/// [`defer_in`](Self::defer_in) schedules a later update after the current
/// borrow has ended. See [ownership and data flow](crate::_ownership_and_data_flow)
/// for notification and subscription timing.
// docs:examples:begin
#[doc = include_str!("../docs/examples/gpui-Context-0b5c5181.md")]
// docs:examples:end
pub struct Context<'a, T> {
    app: &'a mut App,
    entity_state: WeakEntity<T>,
}

impl<'a, T> ops::Deref for Context<'a, T> {
    type Target = App;

    fn deref(&self) -> &Self::Target {
        self.app
    }
}

impl<'a, T> ops::DerefMut for Context<'a, T> {
    fn deref_mut(&mut self) -> &mut Self::Target {
        self.app
    }
}

impl<'a, T: 'static> Context<'a, T> {
    pub(crate) fn new_context(app: &'a mut App, entity_state: WeakEntity<T>) -> Self {
        Self { app, entity_state }
    }

    /// Returns the identity of the entity being constructed or updated.
    pub fn entity_id(&self) -> EntityId {
        self.entity_state.entity_id
    }

    /// Returns a strong handle to this entity without borrowing its value.
    ///
    /// The handle retains the entity, but reading it while the current update
    /// is in progress panics. Use the supplied `&mut T` during that update.
    pub fn entity(&self) -> Entity<T> {
        self.weak_entity()
            .upgrade()
            .expect("The entity must be alive if we have a entity context")
    }

    /// Returns a weak handle to this entity without extending its lifetime.
    ///
    /// Use it for callbacks whose work should stop after the last owner leaves.
    pub fn weak_entity(&self) -> WeakEntity<T> {
        self.entity_state.clone()
    }

    /// Calls `on_notify` whenever `entity` is notified.
    ///
    /// Registration takes effect when the app next flushes effects. Dropping
    /// the returned subscription cancels the observer. The callback holds a
    /// weak handle to this entity and is skipped after this entity is released.
// docs:examples:begin
#[doc = include_str!("../docs/examples/gpui-Context-observe-803e9c7a.md")]
// docs:examples:end
    pub fn observe<W>(
        &mut self,
        entity: &Entity<W>,
        mut on_notify: impl FnMut(&mut T, Entity<W>, &mut Context<T>) + 'static,
    ) -> Subscription
    where
        T: 'static,
        W: 'static,
    {
        let this = self.weak_entity();
        self.app.observe_internal(entity, move |e, cx| {
            if let Some(this) = this.upgrade() {
                this.update(cx, |this, cx| on_notify(this, e, cx));
                true
            } else {
                false
            }
        })
    }

    /// Observes this entity's own notifications.
    ///
    /// The callback runs during effect processing, after the update that
    /// called [`notify`](Self::notify) has returned. Avoid notifying
    /// unconditionally from this callback: another notification schedules
    /// another delivery.
    ///
    /// > [!WARNING]
    /// > The callback retains a strong handle to this entity. Keep the returned
    /// > subscription on an external owner; storing it on this entity creates
    /// > an ownership cycle. Dropping the external subscription ends observation
    /// > and releases the callback's handle.
    ///
    /// ```no_run
    /// use gpui::{App, Context, Entity, Subscription};
    ///
    /// fn observe_count(count: &Entity<u32>, cx: &mut App) -> Subscription {
    ///     count.update(cx, |_, cx| {
    ///         cx.observe_self(|value, _| eprintln!("count changed to {value}"))
    ///     })
    /// }
    ///
    /// # fn example(count: Entity<u32>, cx: &mut App) {
    /// let observation = observe_count(&count, cx);
    /// count.write(cx, 1);
    /// // The external owner chooses when observation ends.
    /// drop(observation);
    /// # }
    /// ```
    pub fn observe_self(
        &mut self,
        mut on_event: impl FnMut(&mut T, &mut Context<T>) + 'static,
    ) -> Subscription
    where
        T: 'static,
    {
        let this = self.entity();
        self.app.observe(&this, move |this, cx| {
            this.update(cx, |this, cx| on_event(this, cx))
        })
    }

    /// Subscribes to typed events emitted by another entity.
    ///
    /// The emitter must implement [`EventEmitter<Evt>`]. Registration is
    /// deferred until effect processing; install it before the update that
    /// emits the event. The callback runs during app effect processing with
    /// exclusive access to this entity. Retain the returned subscription.
    pub fn subscribe<T2, Evt>(
        &mut self,
        entity: &Entity<T2>,
        mut on_event: impl FnMut(&mut T, Entity<T2>, &Evt, &mut Context<T>) + 'static,
    ) -> Subscription
    where
        T: 'static,
        T2: 'static + EventEmitter<Evt>,
        Evt: 'static,
    {
        let this = self.weak_entity();
        self.app.subscribe_internal(entity, move |e, event, cx| {
            if let Some(this) = this.upgrade() {
                this.update(cx, |this, cx| on_event(this, e, event, cx));
                true
            } else {
                false
            }
        })
    }

    /// Subscribes to typed events emitted by this entity.
    ///
    /// Registration and delivery follow [`subscribe`](Self::subscribe). The
    /// callback runs after the emitting update has released its entity borrow.
    ///
    /// > [!WARNING]
    /// > The callback retains this entity strongly. Store the returned subscription
    /// > on an external owner and drop it when event delivery should end. Storing
    /// > it on this same entity creates an ownership cycle.
    pub fn subscribe_self<Evt>(
        &mut self,
        mut on_event: impl FnMut(&mut T, &Evt, &mut Context<T>) + 'static,
    ) -> Subscription
    where
        T: 'static + EventEmitter<Evt>,
        Evt: 'static,
    {
        let this = self.entity();
        self.app.subscribe(&this, move |this, evt, cx| {
            this.update(cx, |this, cx| on_event(this, evt, cx))
        })
    }

    /// Registers a callback for the moment GPUI releases this entity.
    ///
    /// Release means that the last strong handle is gone and the app is cleaning
    /// up the value; it is not the same as dropping this subscription.
    pub fn on_release(&self, on_release: impl FnOnce(&mut T, &mut App) + 'static) -> Subscription
    where
        T: 'static,
    {
        let (subscription, activate) = self.app.release_listeners.insert(
            self.entity_state.entity_id,
            Box::new(move |this, cx| {
                let this = this.downcast_mut().expect("invalid entity type");
                on_release(this, cx);
            }),
        );
        activate();
        subscription
    }

    /// Calls `on_release` when GPUI releases `entity`'s stored value.
    ///
    /// The callback can inspect the released value and update this observer.
    /// This observer is held weakly: if it has also been released, the callback
    /// is skipped. Retain the subscription; dropping it cancels the callback.
    pub fn observe_release<T2>(
        &self,
        entity: &Entity<T2>,
        on_release: impl FnOnce(&mut T, &mut T2, &mut Context<T>) + 'static,
    ) -> Subscription
    where
        T: Any,
        T2: 'static,
    {
        let entity_id = entity.entity_id();
        let this = self.weak_entity();
        let (subscription, activate) = self.app.release_listeners.insert(
            entity_id,
            Box::new(move |entity, cx| {
                let entity = entity.downcast_mut().expect("invalid entity type");
                if let Some(this) = this.upgrade() {
                    this.update(cx, |this, cx| on_release(this, entity, cx));
                }
            }),
        );
        activate();
        subscription
    }

    /// Observes updates to the app's global value of type `G`.
    ///
    /// Registration becomes active during effect processing. The callback
    /// updates this entity through a weak handle and is removed after this
    /// entity is released. Keep the returned subscription to receive updates.
    pub fn observe_global<G: 'static>(
        &mut self,
        mut f: impl FnMut(&mut T, &mut Context<T>) + 'static,
    ) -> Subscription
    where
        T: 'static,
    {
        let handle = self.weak_entity();
        let (subscription, activate) = self.global_observers.insert(
            TypeId::of::<G>(),
            Box::new(move |cx| handle.update(cx, |view, cx| f(view, cx)).is_ok()),
        );
        self.defer(move |_| activate());
        subscription
    }

    /// Register a callback to be invoked when the application is about to restart.
    pub fn on_app_restart(
        &self,
        mut on_restart: impl FnMut(&mut T, &mut App) + 'static,
    ) -> Subscription
    where
        T: 'static,
    {
        let handle = self.weak_entity();
        self.app.on_app_restart(move |cx| {
            handle.update(cx, |entity, cx| on_restart(entity, cx)).ok();
        })
    }

    /// Runs a callback as the application begins quitting.
    ///
    /// The returned future is polled for at most [`crate::SHUTDOWN_TIMEOUT`].
    /// Work that needs more time should be persisted before requesting quit.
    pub fn on_app_quit<Fut>(
        &self,
        mut on_quit: impl FnMut(&mut T, &mut Context<T>) -> Fut + 'static,
    ) -> Subscription
    where
        Fut: 'static + Future<Output = ()>,
        T: 'static,
    {
        let handle = self.weak_entity();
        self.app.on_app_quit(move |cx| {
            let future = handle.update(cx, |entity, cx| on_quit(entity, cx)).ok();
            async move {
                if let Some(future) = future {
                    future.await;
                }
            }
            .boxed_local()
        })
    }

    /// Invalidates rendering that depends on this entity and schedules its observers.
    ///
    /// Call after changing state that a consumer displays or observes. GPUI
    /// does not detect field mutations automatically. Observers run during
    /// effect processing; repeated pending notifications may be coalesced.
// docs:examples:begin
#[doc = include_str!("../docs/examples/gpui-Context-notify-d32eb388.md")]
// docs:examples:end
    pub fn notify(&mut self) {
        self.app.notify(self.entity_state.entity_id);
    }

    /// Runs an asynchronous operation on the foreground executor.
    ///
    /// The operation receives a weak handle to this entity and an [`AsyncApp`]
    /// that can cross `await` points. It does not retain the entity. Attempt a
    /// weak update after waiting and handle the error if the entity disappeared.
    /// Keep or detach the returned task; dropping it cancels remaining work.
    ///
    /// A foreground future still blocks input while it is being polled. Move
    /// long CPU work into [`BackgroundExecutor::spawn`](crate::BackgroundExecutor::spawn),
    /// then await that task here to deliver its result.
    #[track_caller]
// docs:examples:begin
#[doc = include_str!("../docs/examples/gpui-Context-spawn-b83a55ae.md")]
// docs:examples:end
    pub fn spawn<AsyncFn, R>(&self, f: AsyncFn) -> Task<R>
    where
        T: 'static,
        AsyncFn: AsyncFnOnce(WeakEntity<T>, &mut AsyncApp) -> R + 'static,
        R: 'static,
    {
        let this = self.weak_entity();
        self.app.spawn(async move |cx| f(this, cx).await)
    }

    /// Adapts an element callback to exclusive access to this entity.
    ///
    /// The returned closure accepts the event, window, and app expected by
    /// element listeners. It upgrades a weak handle, leases the entity, and
    /// calls `f` with the entity and its context. If the entity has disappeared,
    /// it skips the call. The callback does not keep the entity alive.
    ///
    /// Calling it while this entity is already leased panics. Use the `&mut T`
    /// passed to `f` rather than reading this entity again through a handle.
// docs:examples:begin
#[doc = include_str!("../docs/examples/gpui-Context-listener-350baf86.md")]
// docs:examples:end
    pub fn listener<E: ?Sized>(
        &self,
        f: impl Fn(&mut T, &E, &mut Window, &mut Context<T>) + 'static,
    ) -> impl Fn(&E, &mut Window, &mut App) + 'static {
        let view = self.entity().downgrade();
        move |e: &E, window: &mut Window, cx: &mut App| {
            view.update(cx, |view, cx| f(view, e, window, cx)).ok();
        }
    }

    /// Adapts a callback that must return a result from this entity.
    ///
    /// Unlike [`Self::listener`], the returned closure retains a strong handle
    /// because it must always produce `R`. Avoid storing it on the entity it
    /// retains: that creates an ownership cycle. The update panics if this
    /// entity is already leased.
    pub fn processor<E, R>(
        &self,
        f: impl Fn(&mut T, E, &mut Window, &mut Context<T>) -> R + 'static,
    ) -> impl Fn(E, &mut Window, &mut App) -> R + 'static {
        let view = self.entity();
        move |e: E, window: &mut Window, cx: &mut App| {
            view.update(cx, |view, cx| f(view, e, window, cx))
        }
    }

    /// Returns a guard that calls `f` when the guard is dropped.
    ///
    /// The guard keeps only a weak entity handle and an async app context. If
    /// either is gone at drop time, `f` is skipped. Dropping the guard during
    /// an update of this same entity still attempts a recursive borrow and
    /// can panic; use [`App::defer`] when the work needs a later effect cycle.
    pub fn on_drop(
        &self,
        f: impl FnOnce(&mut T, &mut Context<T>) + 'static,
    ) -> Deferred<impl FnOnce()> {
        let this = self.weak_entity();
        let mut cx = self.to_async();
        gpui_util::defer(move || {
            this.update(&mut cx, f).ok();
        })
    }

    /// Focuses the handle returned by another view's [`Focusable`] implementation.
    ///
    /// The view must already attach that handle to its element tree. Reading
    /// this same entity through `view` during its update panics; use
    /// [`focus_self`](Self::focus_self) to focus the entity being updated.
    pub fn focus_view<W: Focusable>(&mut self, view: &Entity<W>, window: &mut Window) {
        window.focus(&view.focus_handle(self), self);
    }

    /// Runs `f` with this entity before drawing at the next frame opportunity.
    ///
    /// The queued callback retains a strong entity handle until it runs or is
    /// discarded with the window. Use this for work requiring a frame boundary,
    /// rather than a timer or the end of the current effect cycle. Call
    /// [`notify`](Self::notify) if the callback's mutation needs a new draw;
    /// registration alone does not invalidate this view.
    pub fn on_next_frame(
        &self,
        window: &mut Window,
        f: impl FnOnce(&mut T, &mut Window, &mut Context<T>) + 'static,
    ) where
        T: 'static,
    {
        let view = self.entity();
        window.on_next_frame(move |window, cx| view.update(cx, |view, cx| f(view, window, cx)));
    }

    /// Defers a window-aware update until the current entity borrow has ended.
    ///
    /// Associates this entity with `window`, then queues an app effect. The
    /// callback upgrades a weak handle and reacquires the associated window;
    /// it is skipped if either is unavailable. Use this for work that would
    /// otherwise recursively borrow this entity. It does not wait for a frame;
    /// [`on_next_frame`](Self::on_next_frame) does.
    pub fn defer_in(
        &mut self,
        window: &Window,
        f: impl FnOnce(&mut T, &mut Window, &mut Context<T>) + 'static,
    ) {
        let view = self.weak_entity();
        let entity_id = self.entity_id();
        self.ensure_window(entity_id, window.handle.id);
        self.app.defer(move |cx| {
            cx.with_window(entity_id, |window, cx| {
                view.update(cx, |view, cx| f(view, window, cx)).ok();
            });
        });
    }

    /// Observes `observed`'s notifications with access to `window`.
    ///
    /// This associates the observer with the supplied window and follows
    /// [`observe`](Self::observe)'s notification and subscription timing.
    /// Both entity handles are weak. Delivery is skipped after either entity
    /// is released; a closed associated window cannot supply the callback's
    /// window access.
    pub fn observe_in<V2>(
        &mut self,
        observed: &Entity<V2>,
        window: &mut Window,
        mut on_notify: impl FnMut(&mut T, Entity<V2>, &mut Window, &mut Context<T>) + 'static,
    ) -> Subscription
    where
        V2: 'static,
        T: 'static,
    {
        let observed_id = observed.entity_id();
        let observed = observed.downgrade();
        let observer = self.weak_entity();
        let observer_id = self.entity_id();
        self.ensure_window(observer_id, window.handle.id);
        self.new_observer(
            observed_id,
            Box::new(move |cx| {
                let Some((observer, observed)) = observer.upgrade().zip(observed.upgrade()) else {
                    return false;
                };
                cx.with_window(observer_id, |window, cx| {
                    observer.update(cx, |observer, cx| {
                        on_notify(observer, observed, window, cx);
                    });
                });
                true
            }),
        )
    }

    /// Subscribes to typed events with access to this entity's associated window.
    ///
    /// Associates this entity with `window` and follows [`subscribe`](Self::subscribe)'s
    /// registration and delivery timing. Both entity handles are weak. Delivery
    /// is skipped if either entity or the associated window is unavailable.
    /// Retain the returned subscription for as long as events should arrive.
    pub fn subscribe_in<Emitter, Evt>(
        &mut self,
        emitter: &Entity<Emitter>,
        window: &Window,
        mut on_event: impl FnMut(&mut T, &Entity<Emitter>, &Evt, &mut Window, &mut Context<T>) + 'static,
    ) -> Subscription
    where
        Emitter: EventEmitter<Evt>,
        Evt: 'static,
    {
        let emitter = emitter.downgrade();
        let subscriber = self.weak_entity();
        let subscriber_id = self.entity_id();
        self.ensure_window(subscriber_id, window.handle.id);
        self.new_subscription(
            emitter.entity_id(),
            (
                TypeId::of::<Evt>(),
                Box::new(move |event, cx| {
                    let Some((subscriber, emitter)) = subscriber.upgrade().zip(emitter.upgrade())
                    else {
                        return false;
                    };
                    let event = event.downcast_ref().expect("invalid event type");
                    cx.with_window(subscriber_id, |window, cx| {
                        subscriber.update(cx, |subscriber, cx| {
                            on_event(subscriber, &emitter, event, window, cx);
                        });
                    });
                    true
                }),
            ),
        )
    }

    /// Calls `on_release` during release of this entity, if `window` is available.
    ///
    /// The callback receives the value before it is dropped and a fresh window
    /// borrow. A closed or currently borrowed window causes the callback to be
    /// skipped. Retain the subscription; dropping it cancels the callback.
    pub fn on_release_in(
        &mut self,
        window: &Window,
        on_release: impl FnOnce(&mut T, &mut Window, &mut App) + 'static,
    ) -> Subscription {
        let entity = self.entity();
        self.app.observe_release_in(&entity, window, on_release)
    }

    /// Observes another entity's release with access to `window`.
    ///
    /// The released value can be inspected before it is dropped. This observer
    /// is held weakly, and the callback is skipped if the observer or window is
    /// unavailable. Retain the returned subscription.
    pub fn observe_release_in<T2>(
        &self,
        observed: &Entity<T2>,
        window: &Window,
        mut on_release: impl FnMut(&mut T, &mut T2, &mut Window, &mut Context<T>) + 'static,
    ) -> Subscription
    where
        T: 'static,
        T2: 'static,
    {
        let observer = self.weak_entity();
        self.app
            .observe_release_in(observed, window, move |observed, window, cx| {
                observer
                    .update(cx, |observer, cx| {
                        on_release(observer, observed, window, cx)
                    })
                    .ok();
            })
    }

    /// Observes changes to the window's bounds, including movement and resizing.
    ///
    /// Registration is immediate. The callback holds this entity weakly;
    /// dropping the subscription or releasing this entity stops delivery.
    pub fn observe_window_bounds(
        &self,
        window: &mut Window,
        mut callback: impl FnMut(&mut T, &mut Window, &mut Context<T>) + 'static,
    ) -> Subscription {
        let view = self.weak_entity();
        let (subscription, activate) = window.bounds_observers.insert(
            (),
            Box::new(move |window, cx| {
                view.update(cx, |view, cx| callback(view, window, cx))
                    .is_ok()
            }),
        );
        activate();
        subscription
    }

    /// Observes changes to the window's activation state.
    ///
    /// Registration is immediate. Query [`Window::is_window_active`] in the
    /// callback for the new state. Retain the subscription; the callback does
    /// not retain this entity.
    pub fn observe_window_activation(
        &self,
        window: &mut Window,
        mut callback: impl FnMut(&mut T, &mut Window, &mut Context<T>) + 'static,
    ) -> Subscription {
        let view = self.weak_entity();
        let (subscription, activate) = window.activation_observers.insert(
            (),
            Box::new(move |window, cx| {
                view.update(cx, |view, cx| callback(view, window, cx))
                    .is_ok()
            }),
        );
        activate();
        subscription
    }

    /// Observes changes to the window's platform appearance.
    ///
    /// Query [`Window::appearance`] in the callback. Registration is immediate;
    /// retain the subscription to receive changes. This entity is held weakly.
    pub fn observe_window_appearance(
        &self,
        window: &mut Window,
        mut callback: impl FnMut(&mut T, &mut Window, &mut Context<T>) + 'static,
    ) -> Subscription {
        let view = self.weak_entity();
        let (subscription, activate) = window.appearance_observers.insert(
            (),
            Box::new(move |window, cx| {
                view.update(cx, |view, cx| callback(view, window, cx))
                    .is_ok()
            }),
        );
        activate();
        subscription
    }

    /// Observes changes to the platform window-button layout.
    ///
    /// Use this to update content placed beside native window controls.
    /// Registration is immediate; retain the subscription. The callback stops
    /// updating this entity after its release.
    pub fn observe_button_layout_changed(
        &self,
        window: &mut Window,
        mut callback: impl FnMut(&mut T, &mut Window, &mut Context<T>) + 'static,
    ) -> Subscription {
        let view = self.weak_entity();
        let (subscription, activate) = window.button_layout_observers.insert(
            (),
            Box::new(move |window, cx| {
                view.update(cx, |view, cx| callback(view, window, cx))
                    .is_ok()
            }),
        );
        activate();
        subscription
    }

    /// Register a callback to be invoked when a keystroke is received by the application
    /// in any window. Note that this fires after all other action and event mechanisms have resolved
    /// and that this API will not be invoked if the event's propagation is stopped.
    pub fn observe_keystrokes(
        &mut self,
        mut f: impl FnMut(&mut T, &KeystrokeEvent, &mut Window, &mut Context<T>) + 'static,
    ) -> Subscription {
        fn inner(
            keystroke_observers: &SubscriberSet<(), KeystrokeObserver>,
            handler: KeystrokeObserver,
        ) -> Subscription {
            let (subscription, activate) = keystroke_observers.insert((), handler);
            activate();
            subscription
        }

        let view = self.weak_entity();
        inner(
            &self.keystroke_observers,
            Box::new(move |event, window, cx| {
                if let Some(view) = view.upgrade() {
                    view.update(cx, |view, cx| f(view, event, window, cx));
                    true
                } else {
                    false
                }
            }),
        )
    }

    /// Observes changes to the window's pending key-binding input.
    ///
    /// This concerns unresolved multi-keystroke bindings, not IME composition.
    /// Registration is immediate. Retain the subscription; this entity is held
    /// weakly by the callback.
    pub fn observe_pending_input(
        &self,
        window: &mut Window,
        mut callback: impl FnMut(&mut T, &mut Window, &mut Context<T>) + 'static,
    ) -> Subscription {
        let view = self.weak_entity();
        let (subscription, activate) = window.pending_input_observers.insert(
            (),
            Box::new(move |window, cx| {
                view.update(cx, |view, cx| callback(view, window, cx))
                    .is_ok()
            }),
        );
        activate();
        subscription
    }

    /// Observes a transition to `handle` as the directly focused node.
    ///
    /// Moving focus into a descendant does not satisfy this test; use
    /// [`on_focus_in`](Self::on_focus_in) for the whole subtree. Registration
    /// becomes active after the current update. Retain the subscription.
    pub fn on_focus(
        &mut self,
        handle: &FocusHandle,
        window: &mut Window,
        mut listener: impl FnMut(&mut T, &mut Window, &mut Context<T>) + 'static,
    ) -> Subscription {
        let view = self.weak_entity();
        let focus_id = handle.id;
        let (subscription, activate) =
            window.new_focus_listener(Box::new(move |event, window, cx| {
                view.update(cx, |view, cx| {
                    if event.previous_focus_path.last() != Some(&focus_id)
                        && event.current_focus_path.last() == Some(&focus_id)
                    {
                        listener(view, window, cx)
                    }
                })
                .is_ok()
            }));
        self.defer(|_| activate());
        subscription
    }

    /// Observes focus entering the subtree rooted at `handle`.
    ///
    /// Moving focus between two descendants stays inside the subtree and does
    /// not call the listener. Registration becomes active after the current
    /// update. Retain the subscription; this entity is held weakly.
    pub fn on_focus_in(
        &mut self,
        handle: &FocusHandle,
        window: &mut Window,
        mut listener: impl FnMut(&mut T, &mut Window, &mut Context<T>) + 'static,
    ) -> Subscription {
        let view = self.weak_entity();
        let focus_id = handle.id;
        let (subscription, activate) =
            window.new_focus_listener(Box::new(move |event, window, cx| {
                view.update(cx, |view, cx| {
                    if event.is_focus_in(focus_id) {
                        listener(view, window, cx)
                    }
                })
                .is_ok()
            }));
        self.defer(|_| activate());
        subscription
    }

    /// Observes `handle` ceasing to be the directly focused node.
    ///
    /// Moving focus from this node to a descendant also counts as blur. Use
    /// [`on_focus_out`](Self::on_focus_out) to observe leaving the entire subtree.
    /// Registration is deferred until after this update. Retain the subscription.
    pub fn on_blur(
        &mut self,
        handle: &FocusHandle,
        window: &mut Window,
        mut listener: impl FnMut(&mut T, &mut Window, &mut Context<T>) + 'static,
    ) -> Subscription {
        let view = self.weak_entity();
        let focus_id = handle.id;
        let (subscription, activate) =
            window.new_focus_listener(Box::new(move |event, window, cx| {
                view.update(cx, |view, cx| {
                    if event.previous_focus_path.last() == Some(&focus_id)
                        && event.current_focus_path.last() != Some(&focus_id)
                    {
                        listener(view, window, cx)
                    }
                })
                .is_ok()
            }));
        self.defer(|_| activate());
        subscription
    }

    /// Observes the window losing its focused node without a replacement.
    ///
    /// This can happen when the focused element leaves the tree. Use the
    /// callback to choose a remaining focus target. Registration becomes active
    /// after this update. Retain the subscription; this entity is held weakly.
    pub fn on_focus_lost(
        &mut self,
        window: &mut Window,
        mut listener: impl FnMut(&mut T, &mut Window, &mut Context<T>) + 'static,
    ) -> Subscription {
        let view = self.weak_entity();
        let (subscription, activate) = window.focus_lost_listeners.insert(
            (),
            Box::new(move |window, cx| {
                view.update(cx, |view, cx| listener(view, window, cx))
                    .is_ok()
            }),
        );
        self.defer(|_| activate());
        subscription
    }

    /// Observes focus leaving the subtree rooted at `handle`.
    ///
    /// Moving between descendants does not call the listener. The event identifies
    /// the previously focused leaf through a weak focus handle. Registration is
    /// deferred until after this update. Retain the subscription.
    pub fn on_focus_out(
        &mut self,
        handle: &FocusHandle,
        window: &mut Window,
        mut listener: impl FnMut(&mut T, FocusOutEvent, &mut Window, &mut Context<T>) + 'static,
    ) -> Subscription {
        let view = self.weak_entity();
        let focus_id = handle.id;
        let (subscription, activate) =
            window.new_focus_listener(Box::new(move |event, window, cx| {
                view.update(cx, |view, cx| {
                    if let Some(blurred_id) = event.previous_focus_path.last().copied()
                        && event.is_focus_out(focus_id)
                    {
                        let event = FocusOutEvent {
                            blurred: WeakFocusHandle {
                                id: blurred_id,
                                handles: Arc::downgrade(&cx.focus_handles),
                            },
                        };
                        listener(view, event, window, cx)
                    }
                })
                .is_ok()
            }));
        self.defer(|_| activate());
        subscription
    }

    /// Starts a foreground task with weak entity ownership and a window context.
    ///
    /// The [`AsyncWindowContext`] can cross `await`; it reacquires app and window
    /// access for each operation. Handle failed updates after teardown. Keep or
    /// detach the returned task, because dropping it cancels remaining work.
    /// Each poll runs on the foreground thread; use the background executor for
    /// long CPU work, as described by [`spawn`](Self::spawn).
    #[track_caller]
    pub fn spawn_in<AsyncFn, R>(&self, window: &Window, f: AsyncFn) -> Task<R>
    where
        R: 'static,
        AsyncFn: AsyncFnOnce(WeakEntity<T>, &mut AsyncWindowContext) -> R + 'static,
    {
        let view = self.weak_entity();
        window.spawn(self, async move |cx| f(view, cx).await)
    }

    /// Starts a window-aware foreground task with the given scheduling priority.
    ///
    /// Ownership, cancellation, and teardown follow [`spawn_in`](Self::spawn_in).
    /// Priority affects scheduling; it does not move the future to a background
    /// thread or interrupt a poll already running.
    #[track_caller]
    pub fn spawn_in_with_priority<AsyncFn, R>(
        &self,
        priority: Priority,
        window: &Window,
        f: AsyncFn,
    ) -> Task<R>
    where
        R: 'static,
        AsyncFn: AsyncFnOnce(WeakEntity<T>, &mut AsyncWindowContext) -> R + 'static,
    {
        let view = self.weak_entity();
        window.spawn_with_priority(priority, self, async move |cx| f(view, cx).await)
    }

    /// Observes global `G` with access to the supplied window.
    ///
    /// Registration takes effect after this update. If the window is closed or
    /// temporarily borrowed, that notification is skipped and the observer stays
    /// registered. Releasing this entity removes the observer. Keep the returned
    /// subscription to receive changes.
    pub fn observe_global_in<G: Global>(
        &mut self,
        window: &Window,
        mut f: impl FnMut(&mut T, &mut Window, &mut Context<T>) + 'static,
    ) -> Subscription {
        let window_handle = window.handle;
        let view = self.weak_entity();
        let (subscription, activate) = self.global_observers.insert(
            TypeId::of::<G>(),
            Box::new(move |cx| {
                // If the entity has been dropped, remove this observer.
                if view.upgrade().is_none() {
                    return false;
                }
                // If the window is unavailable (e.g. temporarily taken during a
                // nested update, or already closed), skip this notification but
                // keep the observer alive so it can fire on future changes.
                let Ok(entity_alive) = window_handle.update(cx, |_, window, cx| {
                    view.update(cx, |view, cx| f(view, window, cx)).is_ok()
                }) else {
                    return true;
                };
                entity_alive
            }),
        );
        self.defer(move |_| activate());
        subscription
    }

    /// Register a callback to be invoked when the given Action type is dispatched to the window.
    pub fn on_action(
        &mut self,
        action_type: TypeId,
        window: &mut Window,
        listener: impl Fn(&mut T, &dyn Any, DispatchPhase, &mut Window, &mut Context<T>) + 'static,
    ) {
        let handle = self.weak_entity();
        window.on_action(action_type, move |action, phase, window, cx| {
            handle
                .update(cx, |view, cx| {
                    listener(view, action, phase, window, cx);
                })
                .ok();
        });
    }

    /// Move focus to the current view, assuming it implements [`Focusable`].
    pub fn focus_self(&mut self, window: &mut Window)
    where
        T: Focusable,
    {
        let view = self.entity();
        window.defer(self, move |window, cx| {
            view.read(cx).focus_handle(cx).focus(window, cx)
        })
    }
}

impl<T> Context<'_, T> {
    /// Queues a typed event from this entity for its subscribers.
    ///
    /// The entity must implement [`EventEmitter<Evt>`]. Delivery happens during
    /// effect processing after this update releases the entity borrow. Unlike
    /// [`notify`](Self::notify), each emission carries a payload; it does not
    /// by itself invalidate rendering that reads the entity.
    pub fn emit<Evt>(&mut self, event: Evt)
    where
        T: EventEmitter<Evt>,
        Evt: 'static,
    {
        self.app.emit(&self.entity(), event);
    }
}

impl<T> AppContext for Context<'_, T> {
    #[inline]
    fn new<U: 'static>(&mut self, build_entity: impl FnOnce(&mut Context<U>) -> U) -> Entity<U> {
        self.app.new(build_entity)
    }

    #[inline]
    fn reserve_entity<U: 'static>(&mut self) -> Reservation<U> {
        self.app.reserve_entity()
    }

    #[inline]
    fn insert_entity<U: 'static>(
        &mut self,
        reservation: Reservation<U>,
        build_entity: impl FnOnce(&mut Context<U>) -> U,
    ) -> Entity<U> {
        self.app.insert_entity(reservation, build_entity)
    }

    #[inline]
    fn update_entity<U: 'static, R>(
        &mut self,
        handle: &Entity<U>,
        update: impl FnOnce(&mut U, &mut Context<U>) -> R,
    ) -> R {
        self.app.update_entity(handle, update)
    }

    #[inline]
    fn as_mut<'a, E>(&'a mut self, handle: &Entity<E>) -> super::GpuiBorrow<'a, E>
    where
        E: 'static,
    {
        self.app.as_mut(handle)
    }

    #[inline]
    fn read_entity<U, R>(&self, handle: &Entity<U>, read: impl FnOnce(&U, &App) -> R) -> R
    where
        U: 'static,
    {
        self.app.read_entity(handle, read)
    }

    #[inline]
    fn notify(&mut self, entity_id: EntityId) {
        self.app.notify(entity_id)
    }

    #[inline]
    fn emit<EntityType, EventType>(&mut self, entity: &Entity<EntityType>, event: EventType)
    where
        EntityType: EventEmitter<EventType>,
        EventType: 'static,
    {
        self.app.emit(entity, event)
    }

    #[inline]
    fn update_window<R, F>(&mut self, window: AnyWindowHandle, update: F) -> Result<R>
    where
        F: FnOnce(AnyView, &mut Window, &mut App) -> R,
    {
        self.app.update_window(window, update)
    }

    #[inline]
    fn with_window<R>(
        &mut self,
        entity_id: EntityId,
        f: impl FnOnce(&mut Window, &mut App) -> R,
    ) -> Option<R> {
        self.app.with_window(entity_id, f)
    }

    #[inline]
    fn read_window<U, R>(
        &self,
        window: &WindowHandle<U>,
        read: impl FnOnce(Entity<U>, &App) -> R,
    ) -> Result<R>
    where
        U: 'static,
    {
        self.app.read_window(window, read)
    }

    #[inline]
    fn background_spawn<R>(&self, future: impl Future<Output = R> + Send + 'static) -> Task<R>
    where
        R: Send + 'static,
    {
        self.app.background_executor.spawn(future)
    }

    #[inline]
    fn read_global<G, R>(&self, callback: impl FnOnce(&G, &App) -> R) -> R
    where
        G: Global,
    {
        self.app.read_global(callback)
    }

    #[inline]
    fn insert_global_entity<E: 'static>(&mut self, entity: Entity<E>) {
        self.app.insert_global_entity(entity)
    }

    #[inline]
    fn remove_global_entity<E: 'static>(&mut self, entity: &Entity<E>) {
        self.app.remove_global_entity(entity)
    }

    #[inline]
    fn global_entities<E: 'static>(&self) -> impl Iterator<Item = Entity<E>> {
        self.app.global_entities()
    }
}

impl<T> Borrow<App> for Context<'_, T> {
    fn borrow(&self) -> &App {
        self.app
    }
}

impl<T> BorrowMut<App> for Context<'_, T> {
    fn borrow_mut(&mut self) -> &mut App {
        self.app
    }
}
