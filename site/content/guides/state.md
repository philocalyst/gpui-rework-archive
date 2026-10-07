+++
aliases = ["fundamentals/entities.html", "fundamentals/globals-subscriptions.html", "fundamentals/models-contexts.html", "guide/fundamentals/entities/", "guide/fundamentals/globals-subscriptions/", "guide/fundamentals/models-contexts/"]
title = "Share state without copying it"
description = "Choose an entity, a global, or a local field according to who owns the value."
weight = 30
+++

A local view field is enough when only that view owns the value. Use an entity
when several views need one model, or when the model needs GPUI observation and
release behavior. Cloning `Entity<T>` clones the handle, not `T`.

## Read and update through a context

Read a model through its entity handle and an app context. Update it inside the
entity's update closure. Keep the borrow within that operation; another update
cannot lease the same entity mutably at the same time.

After changing visible state, call `cx.notify()` in that entity's context. A
consumer view must observe the model and notify itself if it should redraw.
The [subscription walkthrough](@/examples/subscriptions.md) shows both notifications.

## Retain the relationship

Observation returns a `Subscription`. Store it on the consumer to make that
relationship last as long as the view. Dropping a temporary subscription cancels
it immediately. Detach only when a deliberate longer lifetime is appropriate.

A global represents one value of a type for the application. Use it for
application-wide services or configuration, rather than to avoid deciding which
model owns a value. Missing required globals can panic; choose the optional
lookup when absence is an ordinary state.

## Let a view disappear

Use a weak entity handle in work that should not retain a view. Upgrading or
updating it can fail after release. That is an expected lifecycle outcome,
including after async work completes.

Read the [ownership explanation](https://docs.rs/gpui-ce/0.2.2/gpui/_ownership_and_data_flow/index.html)
for the entity map, leases, notifications, and event subscriptions. It is the
contract behind these choices.
