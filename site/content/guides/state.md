+++
aliases = ["fundamentals/entities.html", "fundamentals/globals-subscriptions.html", "fundamentals/models-contexts.html", "guide/fundamentals/entities/", "guide/fundamentals/globals-subscriptions/", "guide/fundamentals/models-contexts/"]
title = "Share state without copying it"
description = "Choose an entity, a global, or a local field according to who owns the value."
weight = 30
+++

Start with the owner. Keep a value in a view field when only that view uses it.
Create an `Entity<T>` when multiple views share one model, when another entity
must observe it, or when the value needs its own release lifecycle. Cloning an
entity clones a strong handle to the same `T`; it does not duplicate the model.
Use a global only for one app-wide value of a type, such as a service or
configuration object.

## Read and update through a context

Read with `Entity::read` and update with `Entity::update`, each through an app
context. An update gives one closure an exclusive lease to the entity. Keep
that lease within the closure; trying to read or update the same entity again
while it is leased panics. In a view listener, use the `&mut View` supplied by
`Context::listener` rather than looking up the current view through another
handle.

After changing observable state, call `cx.notify()` in that entity's context.
GPUI does not detect field assignments. A view that reads an entity while
rendering is tracked so notification can invalidate its window. Use
`Context::observe` when a subscriber needs to perform work, such as updating a
derived field; it must then notify itself if its own rendered state changed.
The [counter](@/examples/counter.md) shows one entity, while the
[subscription walkthrough](@/examples/subscriptions.md) shows two owners and
both notification steps. Notifications can coalesce, so use a typed event when
each operation needs its own payload or distinct delivery.

## Retain the relationship

`Context::observe` returns a `Subscription`. Store it on the consumer when the
observation should live as long as that consumer. Dropping a temporary
subscription cancels the relationship immediately. Detach only when an
independent owner and cleanup condition are deliberate; a detached observer can
otherwise outlive the UI that motivated it.

`App::set_global` installs one value per global type for the application. Use
it for app-wide services or configuration, not to avoid deciding which view
owns a model. `App::global` panics when the value is absent; use `try_global`
when absence is a normal state and the caller can proceed without it.
Reading a global while rendering does not register a redraw dependency. Retain
a `Context::observe_global` subscription and notify the view in its callback
when a replacement should change the interface. See
[app-wide state](https://gpui-ce.github.io/book/ownership.html#share-one-value-across-the-app)
for initialization and observer timing.

## Keep row state with its record

A view entity and its returned elements have different lifetimes. The entity
survives through strong handles; the element values are rebuilt during render.
Give a repeated row an ID derived from its record's key so retained interaction
or animation state follows that record after sorting. An index instead ties
state to a position.

`Window::use_keyed_state` retains an entity under an element identity while the
state participates in consecutive frames. It is suitable for mounted component
state, not a draft that must survive removing and later reopening the component.
Keep such a draft on a longer-lived owner. The
[identity section](https://gpui-ce.github.io/book/ownership.html#give-retained-element-state-an-identity)
shows the storage choices and the call-site collision to avoid in repeated
`use_state` calls.

## Let a view disappear

Use `Entity::downgrade` for callbacks or work that should not keep a view alive.
After an `await`, update through that weak handle and handle failure: the view
may have closed while the operation was pending. If another owner must keep the
model alive, retain a strong `Entity` there instead. The
[async guide](@/guides/async.md) applies this rule to task completion.

Read the [ownership explanation](https://docs.rs/gpui-ce/0.2.2/gpui/_ownership_and_data_flow/index.html)
for the entity map, leases, notifications, and event subscriptions. It is the
contract behind these choices.
