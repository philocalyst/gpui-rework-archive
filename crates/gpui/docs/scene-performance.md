# Scene recording and replay

A `Scene` stores paint primitives in type-specific lanes and records a compact
operation stream that refers to those lanes. This lets renderers process batches
by primitive type while retaining the order in which elements recorded layers
and primitives. The scene's public lane vectors remain the primitive storage;
replay does not create a second painted-primitive store.

## Record, finish, and read

Elements add primitives while a scene is recording. Call `Scene::finish` before
reading render commands or batches. Finishing sorts each primitive lane by its
draw-order key and builds the render plan. The scene keeps permutation
information so operation indices still refer to the right primitive after a lane
has been reordered. Calling `finish` again after more recording updates the
render plan while preserving the meaning of operations recorded earlier.

`Scene::replay(range, previous)` copies the selected source operations through
the destination scene's ordinary insertion path. Destination clipping and
draw-order rules therefore apply to replayed primitives alongside newly recorded
content. A finished source uses its saved lane-sort mappings to resolve
operation indices. Replay may clone payloads that are not `Copy`, such as paths
or surfaces; it avoids cloning every primitive into an additional
retained/sorted lane.

A retained view replays its paint-operation range into the current scene. The
destination still records those operations and later finishes its own scene, so
caching a view does not freeze the whole window scene or bypass renderer
compilation.

## What this does not measure

Scene lane sorting, operation replay, retained view rendering, GPU work, and
presentation are separate costs. A microbenchmark of `Scene::finish` or
`Scene::replay` does not measure end-to-end application frame time, GPU
execution, or a native compositor. No performance result is stated here; the
paired baseline/candidate workload and its exact source and binary identities
must be available before publishing measurements.

For view reuse and invalidation, see [Retained view
rendering](crate::_documentation::concepts::retained_rendering). For frame phase
ordering, see [The frame](crate::_documentation::concepts::the_frame).
