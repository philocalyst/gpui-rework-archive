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

## Compare equivalent captures

Hold the viewport, data, fonts, backend, checkpoint, and sample policy constant.
Read the report's scene-build and render measurements separately. A CPU render
benchmark does not measure native presentation or GPU-driver behavior.

Use the testing launcher's benchmark mode for the scenario suite. Record the
command, revision, hardware, backend, and workload with any reported number.
If a measurement cannot be reproduced, describe it as an observation rather
than a performance guarantee.

Read the profiler APIs and [rendering explanation](@/reference/rendering.md)
when choosing a boundary to instrument.
