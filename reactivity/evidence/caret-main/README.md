# Integrated caret qualification

Main source `538191fa01` passes 193 Canvas cases/docs, four ignored, across
28 harnesses, plus parallel all-target Clippy with warnings denied and package
formatting. Raw logs and the actual Cargo unit artifact are recorded here.

The Canvas/core/Parley/Engine/manifests/lockfile/compiler-config pathspecs in
`metadata.json` have an empty Git diff through combined source `f0bd5335ae`.
Later GPUI basis/property changes do not inherit a GPUI qualification from these
Canvas tests. The separate combined GPUI/GPU campaign was interrupted after an
independent property counter regression was identified; it is not certified.

Text timing, allocation, bitwise/packed-stop/public equivalence and linked
assembly controls retain their isolated sources under
`benchmarks/caret-pair-controls/cached-edge/`.
