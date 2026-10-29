# Address interpretation and submitted predecessors

This is a source audit of the current serialized renderer, not a new fenced extent implementation or an overlapping-submission test. The trace test waits for completion between frames. CPU mapping and cold-store leases do not establish submitted-GPU lifetime.

The four names have different authorities:

| Name | Authority | Change under insertion |
| --- | --- | --- |
| Runtime semantic node identity | Existing IdentityIndex and reconciliation/remint rules, exact source/presentation version | Keyed nodes survive and move; unkeyed mixed children remint |
| Canvas draw ordinal / node's command interval | Actual synchronous emission and exact prepared scene | Root stays ordinal0; keyed follower4→5; zero/multiple commands prevent node=draw assumptions |
| Packet word address | One successful preparation and its buffer/bind group | Inline6 words; compact5 common+2 per placement; clip suffix depends on total prefix size |
| ImageKey / GlyphKey / clip dependency | Immutable resource key while corresponding resource version lives; clip positional index is scene-local | Same image/glyph keys may retain GPU coordinates while draws move; same clip geometry may move in WORDS |

The native `render_packet` seam admits damage only from the exact packet predecessor. It takes/revokes the packet token before mutation, admits paint/region/scroll certificates only under matching from/to authority, falls back to full preparation, and restores the token only on success. `RendererState::render_observed` clears replay eligibility before preparation. `RetainedRenderer` invalidates its backing before mutations and marks it valid only after successful submission. These protect current serial packet interpretation; they do not authorize arbitrary deferred candidates or semantic subtree reuse.

Actual preparation serializes four domains:

1. Build draw/common words and correction indices, then append clip words. Clip references are absolute WORDS offsets; clip parent references use the same base. Compact placement metadata points to its common record. Slot colors (absent in this fixture) point into a paint-bank prefix whose size/flag directory can move when the bank grows.
2. `images::prepare` places immutable image/gradient payloads after a power-of-two prefix reservation. It skips payload uploads only when the admitted identity sets and prefix capacity suffice. Exceeding the prefix or changing resources rebuilds its index and stages payloads; buffer capacity determines whether the handle is replaced or reused. Holding a buffer lease does not preserve overwritten contents.
3. The mask atlas appends unseen masks while space permits; rebuilding creates a new texture and repacks the complete current set. Submitted bind groups retain the previous texture handle. Existing keys skip upload. A stable GlyphKey is not itself a perpetual lease on atlas coordinates in a future independently mutable atlas.
4. Patch material coordinates, build the ordered tile CSR, stage globals/records/ranges/indices/corrections, create the binding group, and immediately submit the frame. Tile references encode physical draw addresses. Uniform tiles encode their single draw address directly in a range. `Packet` retains only the current binding, not an immutable second scene.

Vendored wgpu `api/queue.rs` specifies that write_buffer immediately copies caller bytes into staging memory, then executes those transfers on the next Queue::submit before its explicit commands. Native staging allocations survive until that submission finishes. Current write→submit A, write→submit B queue order permits A's GPU reads before B's overwrites without a CPU fence between A and B. Growing buffers/new atlas handles preserve their allocation lifetimes through submitted bindings. The ordinary API borrows the renderer mutably; the audit assumes its existing serialized use of the shared queue, not arbitrary concurrent writes/submissions from outside callers.

A retained multi-version implementation must therefore do one of the following, with measured costs:

- Keep this serial write/submit order and forbid later replay of an obsolete packet interpretation. Retain current exact predecessor/token authority and reject stale candidates before staging when possible. Stale writes already staged cannot be made harmless merely by rejecting a CPU acknowledgement; they must not mutate bytes read by another admitted version.
- Allocate version-private/COW extents and retain **every** referenced common record, clip chain, correction, material buffer, atlas texture, directory/descriptor, and retained-output dependency through the last submitted reader. Bind the version's root/directory to its submission. Reclaim using actual completion/fence ownership, not candidate age, CPU epoch, or descriptor equality. Later replay needs that whole interpretation closure.
- Reuse a physical range only after its prior readers' fences complete; charge the wait/backpressure, staging, fragmentation and peak retained versions. A fixed-size descriptor does not eliminate payload writes or rendering work.

The domain-relative model additionally needs a versioned clip-base descriptor. Mixing the new mixed-insertion encoded prefix with the predecessor descriptor reconstructs eight wrong 32-bit lanes. Relative common pointers still require the intended group interpretation; they do not authorize reusing old inverse/error/clip/color state. A stable virtual directory would have the same version/lease obligation and would add address translation storage/reads; it is not automatically superior to explicit relocation or relative domains.

Source anchors in the frozen experiment: `gpu/src/renderer.rs` (Buffer, Packet, render_observed, prepare_atlas), `renderer/images.rs`, `renderer/clips.rs`, `renderer/slots.rs`, `renderer/retained.rs`; `gpui/src/native.rs::render_packet`; `reactivity/vendor/wgpu/src/api/queue.rs`. Exact files are preserved in the dossier, and the complete input digest set binds the audit to the executed source.
