# Real consumer boundary after the renderer controls

This is a design note, not an implemented API or a compatibility claim.

The ordinary Todo animation currently needs a timer worker, a start channel,
bounded Remote messages and a cross-thread wake for each sample. Sampling a
page transition belongs on the exclusive UI owner; its immutable clock input
does not need that delivery machinery. Legacy animation caches/Entities are
also unnecessary for a pure interpolation sampled at explicit time.

A possible native API is a third policy parameter `Window<V, L, A = ()>`.
`A = ()` has no state and statically removes scheduling. Only opt-in A owns a
monotonic native clock anchor, its callback and pending deadline. Win/headless
must drive the identical policy using explicit elapsed Duration. Native code
only supplies time, wakes and suspend/visibility/presentation lifecycle.
Sampling mutates the model solely inside the ordinary source admission; no
model receives Win or a native context. A deterministic public page/inspector
example should be the consumer, not a second test-only animation implementation.

One subtle requirement is idle-to-active wakeup. A page action can retarget a
previously idle motion. Calling a mutable animation callback through another
Win.update after every action would manufacture a second source epoch and
description even when no animation is active. An explicit policy can instead
query `next(&M, elapsed) -> Option<Duration>` immutably and admit
`sample(&mut M, elapsed)` only when due. Do not hide this distinction in an
async completion lane. The policy must still admit a late final sample before
settling, not merely declare inactive when elapsed exceeds duration. Closure
captures, policy/clock size, normal unit specialization and callback code are
part of the cost, even without an ordinary retained-header increase.

Pure Motion endpoints/start/duration can live exclusively in the application
model. Sampling should have explicit interruption, restart, endpoint and
overshoot rules. A scalar/array interpolation kernel may share code for
Affine and color channels; SIMD is justified only by generated code and a
real bulk consumer, not for naming four scalar operations. Affine retains f64
coefficients without narrowing or reassociation. Color must document its
interpolation space: tagged author channels cannot be mixed across spaces as
if they were the compositor's premultiplied extended-linear RGBA. Exact
authored endpoints, transparent colors and HDR/out-of-gamut channels need
separate qualification. Do not introduce an approximate equality that quietly
settles before the endpoint.

Consumer-defined fragment shaders are a different boundary. A compile-time
program set could link pure fragment functions into the ordered compositor,
using static program identities and typed immutable parameter encoding rather
than per-expression Arc nodes and runtime compilation caches. That still needs
an honest CPU reference contract, scene material storage, registration across
borrowed components, checked WGSL linking, binding/resource capabilities and
artifact-source admission. Texture/derivative/backdrop/custom-geometry shaders
are not automatically supported by a pure math function set. Multiple passes
or intermediates would need explicit sample/compositing and lifetime rules.
No current stride/reflection test or generated Image is evidence that these
consumer APIs already exist.
