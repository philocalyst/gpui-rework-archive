+++
aliases = ["fundamentals/platform-loop.html", "guide/fundamentals/platform-loop/"]
title = "Scheduling and lifetimes"
description = "Understand foreground work, background work, cancellation, and weak updates."
weight = 40
+++

A task can outlive its initiating event, but it does not own an unrestricted
borrow of the application. Executors decide where work runs; contexts decide
how that work can return to state.

Read [tasks and the UI thread](https://docs.rs/gpui-ce/0.2.2/gpui/_documentation/scheduling/index.html)
for executor and task ownership. The [async walkthrough](@/examples/async-task.md)
keeps a task handle and handles the view's lifetime at completion.
