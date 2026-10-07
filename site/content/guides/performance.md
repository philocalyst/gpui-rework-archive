+++
aliases = ["guide/guides/performance/", "guides/performance.html"]
title = "Measure a change"
description = "Compare the same work and keep timing claims tied to the measured layer."
weight = 120
+++

First identify the work that became slower. GPUI's profiler separates task
polls, action handlers, input dispatch, window drawing, and platform
presentation. Within drawing, distinguish element construction/layout from
scene recording; an interval that ends at scene construction says nothing by
itself about GPU completion or presentation.

## Reduce work before measuring the GPU

Use virtualization for large lists. Keep stable IDs when you intend to retain
interaction, animation, or scroll state. Avoid expensive I/O and computation
in a render method. Cache a resource where its lifetime belongs, rather than
reconstructing the owner on every frame.

The [list example](@/examples/lists.md) avoids constructing off-screen rows.
The [async example](@/examples/async-task.md) awaits a timer without occupying
the foreground executor between polls. A long synchronous future poll can
still delay input; move independent CPU work to a background executor. These
examples show where work occurs, not a universal speedup.

## Compare equivalent workloads

Hold the viewport, data, fonts, backend, build profile, and sample policy
constant. Measure the stage you are changing. The profiler's per-process
scheduler-clock durations are useful for comparisons within that process, not
for comparing absolute wall-clock times across machines. A faster scene build
does not establish a faster GPU frame or a shorter interval to presentation.

Use a release build for application performance. Warm caches only when the
question is steady-state use; include startup when startup is the question.
Collect enough frames to report a distribution, and record the command,
revision, hardware, backend, and workload. The optional `profiler` feature
enables the more expensive frame-event trace; disabled builds return empty
trace snapshots. A single frame can reflect compilation, allocation, asset
loading, or unrelated system activity.

Choose a metric that matches the user-visible symptom, then instrument that
boundary. Read the profiler module's timing definitions and the
[rendering explanation](@/reference/rendering.md) before interpreting a frame
duration as time spent drawing or presenting.
