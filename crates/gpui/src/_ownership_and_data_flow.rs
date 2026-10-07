//! # Ownership and data flow
//!
//! GPUI keeps entity values in the application's entity map. An [`crate::Entity<T>`]
//! is a typed, reference-counted handle into that map; cloning the handle does
//! not clone `T`, and dropping one handle does not immediately drop `T`. The
//! value is released after the last strong handle disappears and the app flushes
//! its effects.
//!
//! The app is the access boundary. A handle alone cannot read or mutate its
//! value. Use [`crate::Entity::read_with`] for a short read and [`crate::Entity::update`] for
//! an exclusive mutation. The callback receives a [`crate::Context<T>`], which is the
//! same app access plus entity services such as notifications and subscriptions.
//!
//! ## Create, update, notify
//!
//! ```no_run
//! # use gpui::{App, AppContext, Context, Entity};
//! # struct Counter { count: usize }
//! # fn start() {
//! gpui_platform::application().run(|cx: &mut App| {
//!     let counter: Entity<Counter> = cx.new(|_cx| Counter { count: 0 });
//!     counter.update(cx, |counter, cx| {
//!         counter.count += 1;
//!         cx.notify();
//!     });
//! });
//! # }
//! ```
//!
//! `notify` is an explicit invalidation signal. It does not diff fields and it
//! does not clone the value; observers run during GPUI's normal effect cycle.
//!
//! ## Read without retaining a borrow
//!
//! ```no_run
//! # use gpui::{App, AppContext, Entity};
//! # struct Counter { count: usize }
//! # fn start() {
//! gpui_platform::application().run(|cx: &mut App| {
//!     let counter = cx.new(|_| Counter { count: 3 });
//!     let count = counter.read_with(cx, |counter, _app| counter.count);
//!     assert_eq!(count, 3);
//! });
//! # }
//! ```
//!
//! `read_with` keeps the borrow inside its callback. Calling `read` directly is
//! useful when a larger expression needs a reference, but the reference is tied
//! to the current app borrow and must not escape it. GPUI rejects a second lease
//! of the same entity while an update is in progress.
//!
//! ## Weak handles and asynchronous work
//!
//! Long-lived callbacks should capture [`crate::WeakEntity<T>`] rather than a strong
//! entity handle. Upgrading is a race-safe test of liveness:
//!
//! ```no_run
//! # use gpui::{AppContext, Entity, WeakEntity};
//! # struct Counter { count: usize }
//! # fn later(_: WeakEntity<Counter>) {}
//! gpui_platform::application().run(|cx| {
//!     let counter: Entity<Counter> = cx.new(|_| Counter { count: 0 });
//!     let weak = counter.downgrade();
//!     later(weak.clone());
//!     drop(counter);
//!     assert!(weak.upgrade().is_none());
//! });
//! ```
//!
//! This prevents an async task or subscription from keeping a model alive
//! accidentally. [`crate::AsyncApp::spawn`] can use a weak entity after an await;
//! the update returns an error when the entity has gone away.
//!
//! ## Notifications and typed events
//!
//! Notifications describe state invalidation. Typed events describe an action
//! or occurrence and require [`crate::EventEmitter<E>`] on the emitting type:
//!
//! ```no_run
//! # use gpui::{App, AppContext, Context, Entity, EventEmitter};
//! # struct Counter { count: usize }
//! struct Incremented { amount: usize }
//! impl EventEmitter<Incremented> for Counter {}
//! gpui_platform::application().run(|cx: &mut App| {
//!     let counter: Entity<Counter> = cx.new(|_| Counter { count: 0 });
//!     let listener = cx.new(|cx: &mut Context<Counter>| {
//!         cx.subscribe(&counter, |listener, _, event: &Incremented, _| {
//!             listener.count += event.amount;
//!         }).detach();
//!         Counter { count: 0 }
//!     });
//!     counter.update(cx, |counter, cx| {
//!         counter.count += 1;
//!         cx.emit(Incremented { amount: 1 });
//!     });
//!     assert_eq!(listener.read(cx).count, 1);
//! });
//! ```
//!
//! A [`crate::Subscription`] cancels its callback when dropped. Store it when the
//! relationship has a bounded owner; call [`crate::Subscription::detach`] only when
//! the callback should remain registered until its publisher or weak target is
//! released. See the [subscription walkthrough](https://gpui-ce.github.io/examples/subscriptions/#lifetime).
//!
//! ## The ownership rule in one sentence
//!
//! Handles identify and retain entities, the app owns their storage, contexts
//! authorize access, `notify` drives invalidation, and weak handles make
//! teardown explicit.
