# Certified region draw batching

Preregistered before implementation. Local experiment on static sparse repair
with the qualified deferred-control example, c965a893364b46f965c83d10e2cf94a46dac1304.
Its predecessor's complete performance gate remains failed. This is not adoption
of that code or a change to application APIs, update admission or image authority.

Motivation: native-profile a7fbf5e2fe and thread-attribution ba1d3122a896 show that
the native sparse text path reduces software raster CPU but misses cadence.
Scroll/mixed work is overwhelmingly on llvmpipe workers, not the UI thread. The
current regional submit emits one full-screen draw/scissor per certified region.
Batching their independent coverage into one draw may reduce driver/raster setup.
This transfers BBTree's independent-operation batching to the measured work;
it is not proof that draw count is the cause, or an async cache-hit claim.

## Proposed implementation

Preserve the entire existing typed fragment shader and ordinary full-screen vertex
shader byte-for-byte. Add a separately generated/validated typed vertex program:
six vertices per rectangle, an instance attribute containing its clip-space edges,
no fragment varyings or change to the fragment's builtin pixel position. A single
instanced draw covers the same disjoint integer pixel rectangles. Keep the same
canonical complete-scene packet, painter order, sixteen-sample coverage, color
arithmetic, retained image Load and full presentation copy. No shader simplification,
reduced antialiasing, altered tone mapping or smaller application workload.

Normal WGSL context construction may mint one explicit, fresh bind-group layout
matching the existing six bindings, shared only by that context's ordinary and
regional pipelines. Inferred layouts are pipeline-exclusive in this Wgpu version;
reusing them with another pipeline is invalid. Preserve fresh-context identity,
error scope checks and ordinary packet bindings, so a later redraw/slot patch can
use the normal pipeline. Do not store a regional-only bind group in the canonical
packet. Test cross-context rejection after the layout change.

Keep the regional pipeline and vertex buffer in a lazy private box hanging from
the already boxed retained Backing. The ordinary GpuContext/Renderer/Runtime/node
headers need not grow; charge the Backing pointer and cold allocation. Up to64
regions require at most1024 bytes of instance edges. Use bounded transient CPU
scratch, exact checked count/size and ordered queue upload before the draw.
Do not overwrite GPU-leased memory through mapping; normal queue.write_buffer
ordering applies. First use, resize/recreation, pipeline construction and buffer
storage are charged. No shared mutable window ownership, new unsafe or dependency.

One-region ordinary submission remains the original path. Empty updates copy the
retained image without inventing damage. Keep existing full-render fallback for
absent/resized/invalid backing and validate all input bounds before fallback.
Retain the current conservative multi-scissor route for the experimental
offline-shader feature; its artifact/interface proof and fragment remain unchanged.
No optimization is claimed for that feature. Preserve exact predecessor/token
checks and revoke backing authority before fallible preparation as before.

## Qualification before timing

Through public Canvas/Renderer/RetainedRenderer interfaces, compare complete final
GPU bytes with the ordinary full-render oracle in all three supported formats.
Exercise multiple separated rectangles, holes, screen edges, narrow strips,
non-power-of-two dimensions, 1px dimensions, maximum supported axis, touching/
merged regions and the64-region/overflow behavior. Include translucent overlap,
fractional scene geometry/clip positions, images and text where supported.
Rectangle coverage changes which pixels execute, not their canonical sample math.
Check unchanged redraw, color-slot patch after a regional frame, full fallback,
failed newer bounds, resize and distinct-context/layout authority. Keep all
existing GPU and native image-token witnesses.

A fresh isolated mutant that omits the first regional instance must fail actual
pixels. Run generated-source equality for the original shader, validation of the
new vertex source, and verify both shader strings inside the executable that ran.
Clean GPU after source overlays; use unique target, pinned checksum-freshness
Cargo, locked/offline release builds and complete source guards. Freeze clean
source before gates and preserve every failed attempt and executed binary.

Qualify the complete GPUI composition and application port, strict Clippy,
minimal/native feature builds and existing actual native scripts. Inherit only
unchanged nonnative production gates with explicit source equality. Ordinary
context layout is changed, so GPU/context/packet/lifetime tests must run afresh.
Inventory shipping code, ELF/selected caller code and local stack, headers, cold
construction, vertex bytes/capacity, allocations and retained image/copy work.
Report image pixels unchanged and command batching separately from elapsed cost.

## Cost and end-to-end gates

Only after correctness, freeze a separate timing protocol using the existing28
whole-owner/GPU-completion regimes, including source/owner stream, tiny/full,
text0/25/1000 one/two/four-source/owner and scroll/mixed fallbacks. Preserve the
original, bounds-only and failed static-sparse controls with identical current
application fixtures and compiler profiles. Do not reuse differently configured
ELFs or omit old failing controls. Require candidate/static-sparse<=0.8 for both
stream primaries, candidate/original<=0.8 there, and<=1.05 for every unaffected
comparison against all controls. No post-measurement threshold/region-count tuning.
Use24 balanced groups, all24 four-way orders,16 warm/64 measured updates, seed
20261103; median paired process-p50 ratios, type7,10000 bootstrap draws. Preserve
cold and allocation observations separately. If any fixed gate fails, reject the
complete candidate irrespective of successful cells.

If those gates pass, run the unchanged automatic native application against both
GPUI predecessor and pinned ZGX under the matched fat-LTO profile and the same
six-group protocol. Require the established58–61 update/second gate; no lower CPU
claim from omitted work. Keep scroll/mixed regimes even though text-only batching
does not claim to solve them. Render quality, manual wheel/gesture parity, actual
presentation and physical hardware/two-class gates remain open and required for
the overall user goal. Software Vulkan alone cannot establish a ZGX victory.
