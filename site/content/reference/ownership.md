+++
aliases = ["fundamentals/application.html", "getting-started/mental-model.html", "guide/fundamentals/application/", "guide/getting-started/mental-model/", "guide/system/utilities/", "system/utilities.html"]
title = "Ownership and data flow"
description = "Understand entities, leases, contexts, notifications, and subscriptions."
weight = 10
+++

An `Entity<T>` is a strong handle to app-owned `T`; cloning the handle does not
clone the value. A context grants scoped access and provides operations such as
`notify`, `observe`, and task spawning. A notification reports that consumers
should read the latest value; it does not describe the mutation. These
boundaries determine who can access a value, when a view is invalidated, and
what ends an observation.

Read the [ownership explanation](https://docs.rs/gpui-ce/0.2.2/gpui/_ownership_and_data_flow/index.html)
for entity leases, weak handles, coalesced notifications, and event lifecycle.
Then use the [counter](@/examples/counter.md) for state owned by one view, or
[subscriptions](@/examples/subscriptions.md) for a model observed by another
view and a `Subscription` that owns that relationship.

| Contract | API |
| --- | --- |
| Need | Use | Consequence |
| --- | --- | --- |
| Keep state alive and share one value | [Entity](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Entity.html) | A strong handle keeps the entity alive. |
| Access state for one operation | [Context](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Context.html) | The closure holds an exclusive lease; do not reborrow the same entity. |
| Refer to state without extending its lifetime | [WeakEntity](https://docs.rs/gpui-ce/0.2.2/gpui/struct.WeakEntity.html) | Upgrade/update can fail after release. |
| Keep an observer or event subscription active | [Subscription](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Subscription.html) | Dropping it cancels the relationship. |
