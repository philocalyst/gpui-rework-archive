# Live production seam investigation; no B adoption

Parent B cost2f357586bf213e2daf1043c80f5e02ad7177890d is NOT ADMITTED. Keep
all four tiny bypass gate failures, every32-node raw loss, overlap256 loss,
roughly doubled cold init and46MiB worker RSS increase beside large sparse gains.
No rerun or A combination. The0.98ms prototype endpoint is not native latency.

## Existing authority and smallest seam

1. Ordinary Win::set resolves Source ownership and finishes a complete canonical
scene. finish_color_slot admits equal-working-alpha updates only after canvas
prepare_slots validates the existing paint bank. A source relationship may have
many draw users: changed identity here is PaintSlot qualified by its exact
complete-scene predecessor token, NOT a semantic subtree ID or global handle.
2. PaintSupport already unions the exact conservative raster support of that
relationship. Equal alpha and unchanged geometry mean old and new support are
identical. publish_paint accumulates that support relative to the last presented
image. There is no need for a new parallel per-node bounds table for this seam.
3. SlotTransition stores exactly one predecessor plus edit, deliberately not a
journal of arbitrary coalesced changes. with_paint_scene supplies the borrowed
complete scene, latest token, transition and SceneDamage.base. Obtaining this
borrow does not walk/expand the scene. Native packet_token must equal transition
from, and damage.base must identify its image. A skipped/coalesced transition or
foreign window cannot reuse a positional slot and falls back to full preparation.
4. RendererState::prepare_slots validates current bank flags, working alpha,
proof-color class, context and target. Commit revokes packet before a16B queue
write per changed slot, then performs retained tile traversal and presentation
copy. Existing renderer already has ordered tile indices, clipping, opaque
occlusion proofs and paint-bank indirection. This is the proper baseline; B's
full-scan Python control was not this production renderer.
5. Presented acknowledgement requires the latest complete token. Failed newer
preparation does not transfer source authority to pixels; an older eligible
complete scene can remain valid. Device loss retires context/state. Queue order
preserves already submitted reads of buffers/atlas/image resources; this serial
path does not authorize deferred encoded commands after destructive updates.

Smallest executable integration seam: extract the EXISTING private native packet
rendering decision into one private free function used by GpuSurface and the
headless test. No new public API, metadata registry, external adapter, graph or
runtime is introduced. The test executes ordinary Source updates through this
actual function and retained GPU renderer; no cached offline target/property,
JSON pipe, Python model or recaptured scene is in the eligible patch path.
This stage qualifies the live seam, not compressed B or a generic journal.

## Bounded executable gate

Fresh isolated worktree/target, clean source freeze, source/ELF/generated typed
WGSL guards and strict Clippy. Offscreen software Vulkan, not WSI/hardware timing.
Sizes1/9/32/256/1,024; opaque exact rectangular endpoints with unrelated content,
clipped/overlapping geometry and a source shared by several contributors. Compare
actual retained output to independent full GPU renderer and fresh full Win CPU
pixels. Count source reads/owner/layout/paint/description work, GPU validated
draws/bin visits/upload bytes/repair pixels and retained capacities. At fixed
eligible paint expect16 staged record bytes and zero GPU full-scene validation
or bin rebuilding. Count full initialization separately. No latency claim.

Also exercise two source updates before consumption (exact-predecessor mismatch
must full-rebuild), translation and alpha changes (full path), stale acknowledgement,
failed NaN candidate, foreign-window positional-slot alias and repeated redraw.
An authority-bypass mutant must yield wrong pixels, not only a rejected argument.
Submit successive complete frames before waiting and verify each target retains
its own pixels; do not call queue submission a coherent shared-memory protocol.
No new indexed text/image claim; existing general renderer remains their route.

## Conditional representation hypothesis, after measuring this live baseline

Before any representation change, the live trace must identify a remaining cost
(cold retained storage, repeated cold uploads, decode/traversal or structural
publication). This gate reports baseline storage/upload/work; it does not choose
a codec or authorize a performance claim. B full-scan comparisons do not show a
win over existing production16B updates; A104B is not an upload win against16B.
Semantic subtree addressing and a structural/dependency journal remain missing.

One candidate would replace only the cold GPU packet-word storage/decoder behind
existing virtual word addresses; retain existing raw paint-bank prefix and tile
traversal, exact token/damage checks, queue/resource authority. This is the
shipping paint bank, NOT A's six-version parameter encoding. CPU initial packet
construction and its scratch must be charged. A bounded block codec needs a
raw escape including directory/index/fragmentation cost, and exact random
access over f32 bit patterns. Start with resource-free admitted geometry; image
packed-payload offsets, atlas/text leases, diagnostic PaintRenderer's positional
cold writes and clip/gradient tails require explicit compatibility or full raw
fallback, never silent partial indexing. A compressed mirror alongside retained
expanded records is not a memory win; separate build scratch from retained state.

Description/layout/structural invalidation keeps the original full preparation
route. Constant slot lookup is not constant subtree rewrite. A later generalized
journal must explicitly represent dependency closure and relocations; this seam
does not supply them. Existing raw renderer is the independent practical control.
Future native cost protocol must be prospective and charge its own initialization,
publication/completion/storage, independent of B's Python timing results.

B's index payload/CPU directories and retained textures are inherent explicit
allocations. Its46MiB worker RSS and cold pipeline increase are still unassigned
software driver/compiler/process costs; this experiment must not subtract or
attribute them speculatively. No shipping adoption or performance gate here.
