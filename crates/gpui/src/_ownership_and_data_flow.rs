//! # Ownership and data flow
//!
//! An [`Entity`](crate::Entity) is a handle to a value stored in the application.
//! Cloning the handle retains the same value; it does not clone that value.
//! The last strong handle marks the value for release. GPUI drops the value and
//! runs release callbacks while flushing the app's effects.
//!
//! A view is an entity whose value implements [`Render`](crate::Render). Models
//! use the same entity machinery without rendering anything. This gives a model
//! the same update, observation, and release rules as a view.
//!
//! ## Access belongs to the context
//!
//! An entity handle identifies a value but cannot access it alone. A read needs
//! an [`App`](crate::App); an update needs an [`AppContext`](crate::AppContext).
//! An update temporarily leases the value out of the entity map and passes it
//! to a closure with its [`Context`](crate::Context):
//!
//! ```
//! use gpui::{App, Context, Entity};
//!
//! struct Counter { count: u32 }
//!
//! fn increment(counter: &Entity<Counter>, app: &mut App) {
//!     counter.update(app, |counter, cx| {
//!         counter.count = counter.count.saturating_add(1);
//!         cx.notify();
//!     });
//! }
//! ```
//!
//! The context dereferences to `App` and adds operations for this entity: notify
//! observers, emit an event, retain a weak handle, or install a subscription.
//! Create an entity with [`AppContext::new`](crate::AppContext::new). Its builder
//! receives a context before returning the entity's initial value.
//!
//! A lease is exclusive. Reading or updating the same entity from inside its
//! update closure panics. Use the closure's `&mut T` instead of reaching through
//! another handle to the same value. Updating a different entity is allowed,
//! provided it does not call back into an entity already leased on the stack.
//!
//! For a short read, [`Entity::read_with`](crate::Entity::read_with) keeps the
//! borrow inside a callback:
//!
//! ```
//! # use gpui::{App, Entity};
//! # struct Counter { count: u32 }
//! fn displayed_count(counter: &Entity<Counter>, app: &App) -> String {
//!     counter.read_with(app, |counter, _| format!("Count: {}", counter.count))
//! }
//! ```
//!
//! [`Entity::read`](crate::Entity::read) returns a reference tied to the app
//! borrow. Use it when several expressions need the same borrowed value. Neither
//! read operation copies the entity or schedules a notification.
//!
//! ## Notify after a change
//!
//! [`Context::notify`](crate::Context::notify) marks the entity as changed.
//! GPUI does not inspect fields to discover mutations. Notifications invalidate
//! rendering that depends on the entity and call registered observers during
//! effect processing; they do not synchronously call every observer at the
//! `notify` statement. Pending notifications for the same entity can be coalesced.
//!
//! This distinction matters when a view observes a model. The model notifies
//! after its data changes. An observer can then update derived view state and
//! notify that view. See [Observe shared state](https://gpui-ce.github.io/examples/subscriptions/)
//! for a complete example, including the lifetime of the subscription.
//!
//! ## Keep the subscription
//!
//! [`Context::observe`](crate::Context::observe) watches notifications.
//! [`Context::subscribe`](crate::Context::subscribe) watches typed events; the
//! publisher must implement [`EventEmitter<E>`](crate::EventEmitter).
//! Use an event when its payload or occurrence matters, such as a completed
//! operation. Use a notification when a consumer should read the current state.
//!
//! Both return a [`Subscription`](crate::Subscription). Dropping it cancels the
//! relationship. Store it on the consumer when the relationship belongs to that
//! consumer. [`Subscription::detach`](crate::Subscription::detach) leaves the
//! callback registered without a cancellation handle. Callbacks installed by an
//! entity context retain a weak target, so detaching does not keep that entity alive.
//!
//! Registration is deferred until effect processing. Install a subscription in
//! one app update before emitting an event in a later update. This also means an
//! assertion later in the same update closure can run before its queued listener callback.
//!
//! ## Let asynchronous work outlive a view
//!
//! A [`WeakEntity`](crate::WeakEntity) identifies an entity without retaining it.
//! [`WeakEntity::upgrade`](crate::WeakEntity::upgrade) returns `None` after the
//! strong count reaches zero, even if the app has yet to drop the stored value.
//! [`WeakEntity::update`](crate::WeakEntity::update) returns an error if the entity
//! has disappeared; treat that as an ordinary outcome after an `await`.
//!
//! [`Context::spawn`](crate::Context::spawn) passes a weak handle and an
//! [`AsyncApp`](crate::AsyncApp) to its future. Keep or detach the returned
//! [`Task`](crate::Task); dropping it cancels the work. Avoid capturing a strong
//! view handle in a task stored on that same view: the task and view can then
//! keep each other alive.
//!
//! The [delayed-task walkthrough](https://gpui-ce.github.io/examples/async-task/)
//! shows the full sequence: store the task, wait without holding an app borrow,
//! then attempt a weak update. The [scheduling explanation](crate::_documentation::scheduling)
//! describes which executor runs that future and when to use a background task.
