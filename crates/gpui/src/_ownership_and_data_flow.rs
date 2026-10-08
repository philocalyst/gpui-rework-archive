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
//! ```rust
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
//! `Application` configures the platform and starts its run loop; it is not
//! the state context passed to callbacks. `App` is the live, synchronous state
//! context. `Context<T>` is the same app access plus the identity and operations
//! of the entity being constructed or updated. For work that crosses an
//! `.await`, use [`AsyncApp`](crate::AsyncApp) or
//! [`AsyncWindowContext`](crate::AsyncWindowContext): each operation reacquires
//! access for its callback, so an entity or app borrow never spans the wait.
//! These async handles are weak references to the app and cannot keep a shut
//! down application alive.
//!
//! A lease is exclusive. Reading or updating the same entity from inside its
//! update closure panics. Use the closure's `&mut T` instead of reaching through
//! another handle to the same value. Updating a different entity is allowed,
//! provided it does not call back into an entity already leased on the stack.
//!
//! For a short read, [`Entity::read_with`](crate::Entity::read_with) keeps the
//! borrow inside a callback:
//!
//! ```rust
//! use gpui::{App, Entity};
//! struct Counter { count: u32 }
//! fn displayed_count(counter: &Entity<Counter>, app: &App) -> String {
//!     counter.read_with(app, |counter, _| format!("Count: {}", counter.count))
//! }
//! ```
//!
//! [`Entity::read`](crate::Entity::read) returns a reference tied to the app
//! borrow. Use it when several expressions need the same borrowed value. Neither
//! read operation copies the entity or schedules a notification.
//!
//! ## Give retained element state an identity
//!
//! A view entity survives while its strong handles do. The element values it
//! returns are rebuilt as the view renders. GPUI uses a separate identity path
//! to carry interaction and animation state from one element value to the next.
//! [`ElementId`](crate::ElementId) supplies one component of that path;
//! [`GlobalElementId`](crate::GlobalElementId) contains the full path through
//! the element's ID-bearing ancestors, within one window.
//!
//! For repeated rows, use the record's key rather than its current position:
//!
//! ```rust
//! use gpui::{div, prelude::*, text};
//!
//! fn contacts(records: &[(u64, String)]) -> impl IntoElement {
//!     div().id("contacts").children(records.iter().map(|(id, name)| {
//!         div().id(("contact", *id)).child(text!(name.clone()))
//!     }))
//! }
//! ```
//!
//! Sorting these records preserves each row's identity. Using the row index
//! would attach retained state to a position, so a reordered row could inherit
//! another record's hover or animation state. A random ID on each render
//! has the opposite problem: every frame starts with fresh element state.
//! A named ancestor creates a scope, so different rows can each contain a
//! child named `"edit"`. Two siblings within the same scope need different IDs.
//!
//! Choose storage according to how long the value must survive:
//!
//! | Storage | Lifetime and purpose |
//! | --- | --- |
//! | A field on an entity | Application state retained by strong entity handles, even when the view is absent from the element tree |
//! | [`Window::use_keyed_state`](crate::Window::use_keyed_state) | An entity retained under an element identity while that state participates in consecutive frames; notifying it invalidates the containing view |
//! | [`Window::with_element_state`](crate::Window::with_element_state) | A caller-defined value under an element identity and state type, for custom element bookkeeping |
//! | [`Element::RequestLayoutState`](crate::Element::RequestLayoutState) and [`PrepaintState`](crate::Element::PrepaintState) | Values carried through the phases of one draw, rather than retained by an ID between draws |
//!
//! Cached subtrees carry their accessed element state forward when GPUI reuses
//! their drawing. Once an identity is absent from a finished frame, the window
//! releases its retained state. An entity obtained through `use_keyed_state`
//! can still survive through another strong handle, but a later mount at that
//! key creates a new entity. Store drafts, selections, or other state that must
//! survive removal on a longer-lived owner.
//!
//! [`Window::use_state`](crate::Window::use_state) uses its Rust call site as the
//! key. That is sufficient for one instance in a scope. Repeated calls at the
//! same site, including calls inside a helper or loop, need distinct keyed
//! state or parent identity scopes.
//! IDs on a returned element enter the path when that element is drawn.
//! Assigning `.id(...)` to a `div` after calling a state hook does not scope
//! that earlier hook. Pass the item key to `use_keyed_state`, or use
//! [`Window::with_id`](crate::Window::with_id) around repeated construction.
//!
//! Focus has its own retained handle. Keep a [`FocusHandle`](crate::FocusHandle)
//! on its owner and attach it to the rendered control with `track_focus`.
//! Merely giving a new control the old element ID does not recreate a dropped
//! focus handle. [`LayoutId`](crate::LayoutId), in contrast, names layout work
//! within the draw and is not an application identity. The
//! [rendering chapter](crate::_documentation::rendering) follows these values
//! through a frame, and the [input chapter](crate::_documentation::input)
//! explains how a focus handle becomes part of the dispatch path.
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
//! callback registered without a cancellation handle. The callbacks installed
//! by `Context::observe` and `Context::subscribe` hold their consumer weakly.
//! Detaching those callbacks does not keep the consumer alive, unless the
//! closure itself captures a strong handle.
//!
//! [`Context::observe_self`](crate::Context::observe_self) and
//! [`Context::subscribe_self`](crate::Context::subscribe_self) hold their target
//! strongly. Keep their subscriptions on a separate owner. Storing either
//! subscription on its own target creates a cycle: the target owns the
//! subscription, whose callback owns the target.
//!
//! Registration and event delivery are deferred until effect processing. When
//! both are queued in one update, registration must come before emission; the
//! queue activates the subscriber before delivering that event. The listener
//! still runs after the update closure returns, so an assertion later in that
//! closure runs before the queued callback.
//!
//! ## Share one value across the app
//!
//! A [`Global`](crate::Global) is one value of a Rust type stored in an `App`.
//! It is shared by that app's windows, not by every app in the process. Use it
//! for settings or a service that belongs to the whole application. Use an
//! entity when consumers need distinct instances or a handle with its own
//! observation and release lifetime.
//!
//! ```rust
//! use gpui::{App, Global};
//!
//! #[derive(Default)]
//! struct Preferences {
//!     show_line_numbers: bool,
//! }
//! impl Global for Preferences {}
//!
//! fn install_preferences(cx: &mut App) {
//!     cx.set_global(Preferences::default());
//! }
//!
//! fn toggle_line_numbers(cx: &mut App) {
//!     let preferences = cx.global_mut::<Preferences>();
//!     preferences.show_line_numbers = !preferences.show_line_numbers;
//! }
//! ```
//!
//! Install the value before using [`App::global`](crate::App::global) or
//! [`App::global_mut`](crate::App::global_mut); these lookups panic when it is
//! absent. Use [`App::try_global`](crate::App::try_global) for optional state.
//! Mutable global access schedules its observers even when the caller makes
//! no change. Replacing the global also schedules observers, but a copied
//! value or cloned handle still refers to what the consumer retained earlier.
//!
//! Reading a global during rendering does not establish a redraw dependency.
//! A view that depends on these preferences should retain a
//! [`Context::observe_global`](crate::Context::observe_global) subscription
//! and notify itself in that callback. Read the current global when rendering
//! again. The [`colors` module](crate::colors) applies this pattern to a shared
//! palette and explains why following a window's appearance is a separate
//! policy decision.
//!
//! ## Reacquire state after waiting
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
//! Releasing the entity does not itself cancel that future. A task retained
//! elsewhere or detached can keep running; a later weak update returns an
//! error. Store the task on the entity when releasing the entity should cancel
//! its work. The [task ownership test](https://gpui-ce.github.io/book/testing.html#separate-task-ownership-from-entity-ownership)
//! checks the case where the task deliberately outlives its entity.
//!
//! The [delayed-task walkthrough](https://gpui-ce.github.io/examples/async-task/)
//! shows the full sequence: store the task, wait without holding an app borrow,
//! then attempt a weak update. The [scheduling explanation](crate::_documentation::scheduling)
//! describes which executor runs that future and when to use a background task.
//!
//! ## Choose the window an operation belongs to
//!
//! An entity is app state, not the property of one window. A shared model can
//! be read by several windows. [`App::with_window`](crate::App::with_window)
//! uses the most recently rendered window that referenced the entity, falling
//! back to its creation window before a render establishes another association.
//! This lookup can therefore change without replacing the entity.
//!
//! [`Context::observe_in`](crate::Context::observe_in),
//! [`subscribe_in`](crate::Context::subscribe_in), and
//! [`defer_in`](crate::Context::defer_in) use that current association. Their
//! supplied window establishes a fallback only when the entity has no window
//! yet; it does not pin later callbacks to that window. Delivery is skipped
//! when the selected window is closed or already borrowed.
//!
//! Retain a [`WindowHandle`](crate::WindowHandle) or
//! [`AnyWindowHandle`](crate::AnyWindowHandle) when the operation belongs to a
//! particular window, such as changing the title of the window that started a
//! request. Updating that handle targets the same window and returns an error
//! after closure. The handle does not keep a closed window open.
//!
//! An [`AsyncWindowContext`](crate::AsyncWindowContext) also remembers one
//! window: [`update`](crate::AsyncWindowContext::update) borrows that window
//! and the app together. Calling [`Entity::update_in`](crate::Entity::update_in)
//! through the same context still selects the entity's current association.
//! To use the remembered window, enter the context's window update first, then
//! update the entity through the supplied app. Follow the same borrow rules
//! as any nested entity update.
//!
//! Creating app state has a different requirement. Calling
//! [`AppContext::new`](crate::AppContext::new) through an async window context
//! attempts window-associated creation, then falls back to app-only creation
//! when that window is unavailable. Use
//! [`VisualContext::new_window_entity`](crate::VisualContext::new_window_entity)
//! when the constructor needs a live window; it returns an error rather than
//! calling that constructor without one.
#![doc = "\n\n[Read this chapter in the GPUI Book](https://gpui-ce.github.io/book/ownership.html)."]
