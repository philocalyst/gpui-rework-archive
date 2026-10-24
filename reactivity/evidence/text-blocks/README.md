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

The removed placements Vec saves one24B scene header. Ordinary inline scenes have2B more per occupied draw before capacity differences, so32 solid markers can regress despite the smaller header. A16B aligned witness is an explicit competing formulation, measured with the same probes and assembly.

## Gates

Release tests cover exact canonical draw/pixel fingerprints, mixed scripts/ligatures/default-ignorables, DPR, reflected/sheared geometry, selection, paint patches, cache clear, failed admissions, and public borrow lifetimes. The new ownership test proves the same packed allocation is shared, layout clone allocates nothing, singleton draws do not pin it, and a scene survives layout/service drop. Negative controls must actually fail the relevant gates.

Matched old/candidate probes include blank,32 solid markers, empty, single/pair/triple labels, independently shaped tiny labels, repeated and unique long labels, mixed fallback/bidi, all-clipped labels, and mixed solids/text. They charge layout/header/Arc allocations and scene live/peak/requested bytes separately, warm scene allocations, exact Vec capacities, CSR bytes/references, sampling queries, preparation/render time, and compatibility expansion time. Timings require matched frozen binaries and are observational within their hardware/run scope.

Final measurements and gates follow below; all shipping source is pinned independently of evidence.

## Measured result on the frozen source

Shipping source is `bbe0c2058c2b3812e0ae8e251db68c329be7734a`; evidence-only follow-up commits do not change that source. Exact nightly is recorded in [toolchain.txt](toolchain.txt). [measurements.json](measurements.json) contains every cohort and its raw allocation/storage/work fields. Local timings remain diagnostic because other lanes were building; they establish no CPU/GPU latency improvement.

The measured headers match the cost model: Canvas488→464B, DisplayList288→264B, TextLayout48→40B plus the32B Arc allocation, Inline56→48B, common/run32→56B, prepared group104B unchanged. Every producer-ledger case keeps the same packed glyph counts/capacities and interaction geometry, with exactly one additional32B retained allocation per independently shaped layout. `GlyphBuffer` still transfers the Vec allocation without allocation or copying, and obsolete production deep-Clone code is removed.

The following totals charge layout header storage, retained shape allocations, actual cold scene live allocations including HashMap controls, and the complete Canvas header. Warm raster pixels, service/parser backing, allocator metadata, and measurement-only source/layout Vec headers are outside this scope. This is a scoped owner comparison, not whole-window resident memory.

| Cohort | Control retained B | Candidate retained B | Delta B | Cold requests old→new |
| --- | ---: | ---: | ---: | ---: |
|32 solid markers |2408 |2448 |+40 |8→8 |
|32 independent empty layouts |2024 |2768 |+744 |64→96 |
|32 independent singleton labels |5596 |6404 |+808 |106→138 |
|32 independent pairs |7004 |7108 |+104 |112→139 |
|32 independent triples |8284 |7556 |−728 |114→140 |
|32 draws borrowing one long layout |27620 |12900 |−14720 |29→24 |
|32 unique long layouts |47318 |29118 |−18200 |164→189 |
|32 all-clipped unique layouts |12272 |13016 |+744 |128→160 |

For32 draws/704 visible glyphs borrowing one layout, scene lanes fall26496→11776B (−55.6%), scene requested bytes53780→24044B, and scene peak live36128→16096B. Whole-cohort requested bytes fall54176→24472B. For32 unique layouts/758 visible glyphs, scene lanes fall31744→12800B, and whole-cohort requested bytes fall94836→51380B, but cold allocation count rises164→189. Warm scene rebuild remains0 requests/0bytes in both implementations. Layout cloning now allocates nothing, while each independent layout still pays the new Arc allocation.

One scene with32 retained calls on the same two-glyph layout has exactly32 packed-owner increments and32decrements, alongside2 unique mask leases. This deliberately does not add an owner-dedup HashMap. Single admitted glyphs retain no packed-owner scene lease. Clearing/dropping the layout and raster service while a retained scene lives preserves pixels; clearing that scene releases its last packed lease.

This is a storage and duplicate-write reduction with explicit cold-allocation and lazy-expansion costs. It does not delete the admission glyph walk, resource lookup, per-glyph raster witnesses, CPU sampling, or GPU repacking. Tiny/empty/all-clipped independent layouts regress; these measurements do not support an unconditional allocation-count or CPU/GPU speed claim.

## GPU and CPU work boundary

Matched old/candidate Vulkan renderer suites both pass49 tests on llvmpipe/Mesa26.1.4. Every [packet probe](candidate-gpu.log) field and readback hash equals the [old source](control-gpu.log). For704 visible glyphs in32 runs, both versions validate704 draws, produce25088B draw records, upload33760B, visit3336 CSR memberships while binning, and plan6832128 sample-draw evaluations; warm atlas mask upload is0B. The32B/glyph compact packet expansion plus80B/run common state is unchanged. No instanced renderer or new packet/certificate encoding is introduced. GPU preparation assembly is archived under `assembly/gpu-control` and `assembly/gpu-final`: ordinary render10022→9993B, mapped observer10015→10140B, atlas helper724B unchanged. Its placement-expansion closure grows511→820B and performs the new exact lazy divisions; unchanged GPU packet counters must not hide this host work.

All Canvas cohorts preserve draw counts, exact expansion fingerprints, CSR byte counts/tile references, and geometric sample-query counts. Conservative bounds are admitted once and borrowed directly by CSR. Common/source-only group and paint traversal does not expand glyph geometry; opaque-cut discovery rejects retained mask witnesses before reconstruction. Actual CPU tile sampling still reconstructs the local rectangle once per glyph/tile visit, outside its pixel loop.

[Optimized assembly](assembly/final/result.json) charges outlined callees. The BGRX band is7119B plus1045B for `DisplayList::get` (old inlined band7052B). Selected preparation/CSR/band/get functions total15003→16162B; this is not a machine-code-size win. The lazy accessor contains two `divps` instructions, and run publication contains one `lock incq` for its packed-owner lease. CSR preparation shrinks2490→2141B, but instruction byte counts establish no timing result.

The final-source16B-aligned witness counterfactual is [witness16.patch](witness16.patch). It preserves the measured geometry/work fingerprints but adds1408B to the704 glyph scene and1536B to the758 glyph scene. Its selected optimized functions total16157B, only5B below the14B formulation. The14B witness is retained for its measured storage advantage; no stride/throughput superiority is claimed. The final-state counterfactual is archived in `assembly/final16`.

## Correctness and source gates

The final default Canvas build yields31 frozen executables and222 passing tests (two unrelated existing ignored tests remain ignored). The selected scalar render/DPR/transaction/prepared-scene suite adds21 passing tests. Four compile-fail doctests check public borrowing and transaction ownership, including a lazy scene iterator that cannot survive its Canvas. Runtime P/C/L, ACK, paint/selection and retained text checks pass50 tests in7 frozen executables. In particular, old P and eligible C survive a newer L reshape followed by failure.

Release all-target Clippy passes with Rust warnings denied; Cargo emits its existing optional `gpui_gpu` unused-dependency manifest warning for the headless GPUI configuration.

Two actual source-negative controls fail their intended tests: [copying the packed owner](negative-owner.patch) breaks the shared-owner identity/lease gate, and [shifting admitted witness bounds](negative-bounds.patch) breaks the canonical draw fingerprint even when the first mode's rendered pixel fingerprint remains equal. Both variants were restored before final-source checks. Logs are archived beside the patches. The16B width counterfactual is also restored; the final source hashes match the frozen source manifest.

Main's `reactivity/tools/core_lines.py`, the supplied inventory Rust helper and qualified Tokei count actual non-test/non-comment shipping source:32372→32408 lines (+36). Per-file provenance is in the compressed shipping-line JSON files. No Cargo manifest/lock, dependency, GPU shipping source, unsafe allocator code, global store, or new synchronization primitive changes. Shared Arc payload/control bytes and all changed Vec/header capacities are charged above.

Potential later work is separate: real block certificates/compositor records, persistent packed-run GPU uploads, or exact per-mask metric normalization at a measured shared scale. The last could avoid repeated divisions at a cost of16B/unique mask plus ownership/scale state; it is not present here. An unproved reciprocal approximation is deliberately not used.
