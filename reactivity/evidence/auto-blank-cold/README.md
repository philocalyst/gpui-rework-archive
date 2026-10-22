# Keep automatic blank windows cold

Shipping source `8158386886a45e66f9baba54643042638496e59b` reuses the canonical
`PreparedScene::solid_bgrx` certificate already computed by CPU presentation.
After a certified command-free opaque sRGB/SDR fill, Auto leaves adapter/target
probing, its worker, device and pipeline unstarted. This works whether the
software backend has native solid fill or requires an ordinary CPU buffer.
The first uncertified scene is software-presented before ordinary asynchronous
GPU admission begins. Explicit GPU mode and an initialization already in flight
retain their policy; this does not evict a GPU after complex content was shown.

The existing private CPU result tuple now carries hardware demand; the caller
keeps its existing destination repair flag. No owner fields, new allocations,
second scene scan, OS binding, driver guess, timer or user-facing switch is added.
Shipping code grows by **two actual code lines**: 28,403→28,405 including 13 build
lines. The complete Syn/Tokei report is archived under checks.

The new real X11 oracle forces an admissible llvmpipe candidate, so an
unconditional upgrade attempt would be observable. Initial blank, resize, and
suspend/resume each assert no attempted upgrade, no rejection/probe, no worker,
no WGPU instance, and exact white server pixels. Complex content first matches
an independent 24×24 black-rectangle/white-background CPU pixel oracle. Target
proof then waits before Renderer construction; releasing it permits actual GPU
handoff with matching source/presentation epoch. The test passes.

All seven explicit native cases pass on a copied actual Cargo unittest artifact:
the new blank transition, target rejection/worker-held close lease, five-policy
Todo, inspector controls, provider lifecycle, real registry Unicode editing and
no-session-bus presentation. Source and executable hashes are checked around
cases and the owned display is stopped. The same binary passes 173 ordinary
GPUI unit tests (23 environment-gated ignored). Strict GPUI all-target Clippy,
formatting and Apple AArch64/Windows MSVC desktop/parallel all-target compilation
pass. Exact commands, raw logs, source guards, artifact path and executable hash
are retained.

The preceding full [combined campaign](../core-catalog-integration/README.md)
remains pinned to 6d77; it is not retagged as a full public/app rerun for 815.
Only native.rs and its native test changed in this refinement. Core/Canvas/GPU
algorithms and headless/application APIs are unchanged.

Linux execution uses Xvfb/Mesa 26.1.4 llvmpipe, not a hardware device. These are
functional work-elimination checks, not a new startup-time, RSS/PSS, GPU residency
or native Apple/Windows runtime result. No zero-memory window claim follows;
software/OS/compositor storage and accessibility still have their own costs.
