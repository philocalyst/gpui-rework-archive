+++
aliases = ["guide/guides/performance/", "guides/performance.html"]
title = "Measure a change"
description = "Compare the same work and keep timing claims tied to the measured layer."
weight = 120
+++

First identify the work that became slower: state updates, element construction,
layout, scene building, rendering, asset loading, or native presentation.
Those stages have different remedies and different clocks.

## Reduce work before measuring the GPU

Use virtualization for large lists. Keep stable IDs when you intend to retain
interaction, animation, or scroll state. Avoid expensive I/O and computation
in a render method. Cache a resource where its lifetime belongs, rather than
reconstructing the owner on every frame.

The [list example](@/examples/lists.md) removes hidden-row construction.
The [async example](@/examples/async-task.md) leaves the foreground thread free
while it waits. Neither example demonstrates a universal speedup.

## Compare equivalent workloads

Hold the viewport, data, fonts, backend, build profile, and sample policy
constant. Measure the stage you are changing: time spent constructing a scene
is different from GPU execution or the interval until native presentation.
A faster scene build does not establish a faster displayed frame.

Use a release build when measuring application performance. Warm caches before
sampling if the workload represents steady use; include startup when startup
is the question. Record the command, revision, hardware, backend, workload,
and distribution of results with a reported number. A single frame can reflect
compilation, allocation, asset loading, or unrelated system activity.

Read the profiler APIs and [rendering explanation](@/reference/rendering.md)
when choosing a boundary to instrument.
