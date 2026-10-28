# State-update campaign: preregistration

Status: diagnostic baseline and candidate qualification, not competitor adoption.
Parent: `87a0f2e402` (the retained-output experiment remains unadopted).
Competitor: ZGX `a3678578980ef239058c557338ef9c544d356b0c`.

This record is committed before compiling or measuring this campaign. Each
implementation will be frozen separately. No change to application APIs is
permitted. Keep the complete recorder and fresh-window rendering as oracles.

## Workload and endpoints

Port ZGX's `micro::state`: a 960 x 720 window, padding 8, vertical gap 6,
one `Count: N` label of height 20 above 40 rows of 25 static labels; cells
36 x 18, grid gaps 2, font size 12, the exact comparison DejaVu Sans bytes,
background #0e1218, foreground #e5edf7. Record any geometry or typography
differences before considering results comparable. Additional GPUI-only cells
use 0, 1, 4, and 400 grid rows (0, 25, 100, 10000 static labels).

The initial endpoint is complete source write, layout, canonical paint recording,
and presentation acknowledgement. ZGX's RENDER=0 endpoint includes layout and
damage but does not produce a GPUI-style canonical glyph display list. Therefore
these CPU diagnostics are explicitly NOT a matched end-to-end competitor claim.
Rendering/native ports and independently checked visual/work equivalence remain
required. Report write-only separately only where the framework exposes it; do
not invent a deferred GPUI setter to make that number comparable.

Use 200 warm-up operations, then 2000 operations in 200 batches of 10. Retain
every batch's process CPU and wall time. Five process repetitions per cell,
alternating baseline/candidate order. Setup and complete fresh-window pixel
and semantic oracles are outside update timers; report cold construction and
teardown separately. Preserve executable hashes, compiler/profile, source-input
hashes, failures, allocation categories and process high-water RSS. No builds
or other owned measurements during measured runs.

## Candidate gate (fixed before measurements)

For an API-preserving candidate to advance to native trials: exact pixels and
semantic/geometry authority on the public corpus; a bounded false-certificate
mutant must fail the new oracle; at least 20% lower median process CPU for the
1000-static-label cell, and no more than 5% median process-CPU regression in
any of the other cells. Require all five paired process ratios to be reported,
including tails; noisy results are inconclusive, not passes. Report cold/peak
memory and all maintained metadata, and reject unexplained unbounded storage.
Passing this gate permits a trial, not production adoption.

## Architectural hypothesis and adversaries

Unchanged text currently repeats glyph admission and complete scene publication.
Explore retained command/text segments using immutable resource identities,
or a smaller proved reduction if profiles identify one. Measure the entire
operation, including cache lookup, invalidation, merge and retirement. Never
infer fixed-layout containment solely from a fixed width/height.

Adversaries: changed text length, non-ASCII and bidi, source fanout, layout shifts,
font/DPI/transform/clip/colour changes, selection and IME, failed newer candidate,
pending acknowledgements, removal and remount. Keep ordinary coarse view updates
as fallback and oracle. No unsafe production code or new dependency is planned.

## Environmental limits

The current Linux VM exposes no `/dev/dri` and `ssh mothership` fails DNS.
Software Vulkan can qualify pixels, not hardware performance. The repo's two
hardware-class equivalent-workload gate is still mandatory for a ZGX win.
