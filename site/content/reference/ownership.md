+++
aliases = ["fundamentals/application.html", "getting-started/mental-model.html", "guide/fundamentals/application/", "guide/getting-started/mental-model/", "guide/system/utilities/", "system/utilities.html"]
title = "Ownership and data flow"
description = "Understand entities, leases, contexts, notifications, and subscriptions."
weight = 10
+++

An entity handle identifies state owned by the application. A context grants
access to that state for a specific operation. A notification tells consumers
that the state changed. Those responsibilities are related, but distinct.

Read the [ownership explanation](https://docs.rs/gpui-ce/0.2.2/gpui/_ownership_and_data_flow/index.html)
for the entity map, borrowing rules, weak handles, and event lifecycle.
Then use the [counter](@/examples/counter.md) to see a local update, or
[subscriptions](@/examples/subscriptions.md) to see a separate model observed by a view.

| Contract | API |
| --- | --- |
| Retain one value | [Entity](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Entity.html) |
| Update a view and notify observers | [Context](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Context.html) |
| Refer to a value without retaining it | [WeakEntity](https://docs.rs/gpui-ce/0.2.2/gpui/struct.WeakEntity.html) |
| Own an observation lifetime | [Subscription](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Subscription.html) |
