# Retained packed text with direct raster witnesses

Base: `4ee08a32def2ca70371c1764a0153a57053ae0e4`. This slice keeps the fullscreen GPU tile compositor and its existing packet ABI. GPU preparation still expands and repacks individual glyphs. No CPU/GPU latency claim follows from the storage change.

## Authority and lifetime

`TextLayout` and a multi-glyph scene command share the same immutable `GlyphBuffer` allocation through `Arc<GlyphBuffer>`. The existing Vec transfer remains allocation-free; the new Arc adds a separate allocation containing the 16-byte owner plus the 16-byte strong/weak header. Font leases and optional interaction geometry remain separate. Packed positions preserve the original float bits and shaping order, including fallback and bidi. There is no new layout ID, global store, interior mutation, lock, dependency, or unsafe code.

Each text call with at least two admitted glyphs retains one command containing the existing common state, canonical owner lease, original origin/raster scale, and painter range. A single admitted glyph stays inline and does not retain a packed-owner scene lease. Current unique-mask Arc leases and scene-local resource lookup are unchanged.

The scene keeps one direct painter-indexed raster witness per admitted draw: cached device bounds, command index, packed glyph index, and mask index. Its fields are all u16, totaling 14 bytes. Packed glyph indices are below32768; the otherwise impossible index65535 selects ordinary inline draws. Existing admission bounds every command/resource index to0..65535. The witness replaces both32-byte Placement geometry and its4-byte order address for text. It contains no duplicated local rectangle or copied packed glyph positions. CPU CSR uses the cached bounds directly and its existing16-bit painter ordinals; there is no binary search and no repeated conservative transform/clip work.

Borrowed public prepared draws/groups reconstruct exact local rectangles from the retained packed position and the immutable raster metrics, using the original f32 operation order and scale division. CPU reconstruction occurs once per glyph/tile visit, before the existing per-pixel sampling loop. GPU consumers retain their current compatibility traversal; repeated division/addition here is a measured cost, not free work. Paint positions, selection/caret authority, Canvas error rollback and runtime P/C/L ownership remain unchanged.

## Charged costs

On64-bit targets the intended headers are TextLayout40B (old48B), Arc allocation32B (old0), retained text command56B (old common32B), raster witness14B (old Placement+order36B), inline draw48B plus14B witness (old56B plus4B order), and DisplayList264B (old288B). Actual compiled headers and Vec capacities are recorded by release probes below. A new independently shaped layout therefore costs24B more including the Arc payload/control block, before allocator metadata; empty and all-clipped layouts pay it too. A layout clone instead stops copying/reallocating glyph storage. Each admitted multi-glyph text call adds one Arc increment and a later decrement; repeated labels do not deduplicate that lease. Scene clear retains Vec capacities but releases run/mask leases.

Ignoring capacity slack, one independent layout rendered once withV>=2 visible glyphs changes owner-plus-scene bytes by `24 + 24 - 22V`; V=2 saves no bytes (4B regression), V=3 saves18B. A singleton instead pays24B for the owner and2B for the inline representation, offset by24B of removed DisplayList header once per scene. Empty/all-clipped text changes only the cold owner cost and scene header. Actual allocator sizes, request totals, peaks, capacity rounding, fonts and interaction geometry must be assessed with the whole-scene cohort, not this lower bound.

The removed placements Vec saves one24B scene header. Ordinary inline scenes have2B more per occupied draw before capacity differences, so32solid markers can regress despite the smaller header. A16B aligned witness is an explicit competing formulation, measured with the same probes and assembly.

## Gates

Release tests cover exact canonical draw/pixel fingerprints, mixed scripts/ligatures/default-ignorables, DPR, reflected/sheared geometry, selection, paint patches, cache clear, failed admissions, and public borrow lifetimes. The new ownership test proves the same packed allocation is shared, layout clone allocates nothing, singleton draws do not pin it, and a scene survives layout/service drop. Negative controls must actually fail the relevant gates.

Matched old/candidate probes include blank,32solid markers, empty, single/pair/triple labels, independently shaped tiny labels, repeated and unique long labels, mixed fallback/bidi, all-clipped labels, and mixed solids/text. They charge layout/header/Arc allocations and scene live/peak/requested bytes separately, warm scene allocations, exact Vec capacities, CSR bytes/references, sampling queries, preparation/render time, and compatibility expansion time. Timings require matched frozen binaries and are observational within their hardware/run scope.

Validation and final measurements pending.
