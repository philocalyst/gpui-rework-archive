# Exact compiled raster scale, with retained owner and metadata views

Shipping source: `7c9fc3cf775544d4082fe7c6ce3e0bb8a3a0a407`. Composition is Root metadata `821f486ba1aa84abe96b4150b592abfcf73c28c0`, then owner `65c1152f25ec1f139ef874ca89ccd2eb59cc45da` cherry-picked as `d4d532f1c2bf3a2b5aa85c7b841b4d9166e3ced5`, then MetricScale. Commits `4f86c14ab69f13335f3a6e3839765e92a11fdd96` and `c8af516c6bbc552b4879fec4bc1a728ddbc9920d` add only the matched density probe. The matched production control is therefore the owner+metadata formulation, with identical probe source and build features. Main, Root's metadata tree and its gradient/clip composition were not modified.

MetricScale replaces the existing4B private command scale with a4B private newtype. After the existing raster-scale/geometry validation, the constructor recognizes positive normal powers of two with exponent1..253 and stores the NEGATIVE exact normal reciprocal, using exponent `(254 - exponent)`. Every other scale retains the original positive divisor. In particular exponent254, subnormal scales and arbitrary1.25 take direct division. No retained field, allocation, table, cache or second geometry representation is added.

The four integer metrics are cast to f32 in their original domain, then normalized together. The encoded branch multiplies by an exact normal power of two; the fallback divides directly by the original f32 divisor. These operations round the identical real quotient once; there is no approximate reciprocal. Rectangle construction keeps the original `origin.x + x + xmin` and `origin.y + baseline - ymin - height` add/sub order. Raster keys and physical font size still consume the original raster scale, and the encoded value stays private to rectangle reconstruction.

The actual shipping tests compare4,290,840 normalization results bit-for-bit, across every encodable power and explicit arbitrary/subnormal/exponent254 fallbacks, signed zeros, finite extremes and random float numerators. Another46,620 rectangle fields check integer casts beyond2^24, i32/usize extrema and the original coordinate operation order. The [real negative control](negative-reciprocal.patch) routes only1.25 through rounded0.8 multiplication; the numeric comparison fails by1 ULP. The normal power-of-two identity is exact algebra plus hardware bit tests, not a sampled justification for arbitrary reciprocal multiplication.

## Actual cohorts and instructions

The matched density probe covers16 scene cohorts at each of1,2,1.25. All1056 non-timing fields match exactly across48 cases: rendered pixel hashes, lazy geometry hashes, draws, cold allocation requests/requested/live/peak bytes, header/lane capacities, bins, references and sample queries. Warm admission stays allocation-free. See [comparison](cohort-comparison.json), [control](cohorts-control.log) and [candidate](cohorts-candidate.log). Raw timing columns are diagnostic only; other lanes were active. No CPU, GPU or latency improvement is claimed.

Actual matched optimized assembly shows a sign test controlling separate paths. DisplayList::get executes one mulps and no division for the encoded normal powers (including DPR1/2), or one direct divps for arbitrary scales. Its old formulation emitted two divps. Admission has separate two-mulps/two-divps paths. This deletes actual divisions on the common encoded path without reconstructing bounds in metadata traversal. [Captured assembly](assembly/candidate/result.json) and its paired control preserve the branch bodies.

| Matched default probe function | Control bytes | Candidate bytes |
|---|---:|---:|
|Native render band |7119 |7119 |
|CSR preparation |2141 |2135 |
|DisplayList::get |1036 |1066 |
|Placement expansion closure |812 |647 |
|Text admission closure |4135 |4167 |
|Text admission outer function |1732 |1838 |

Selected helper shrinkage is not a total code-size win. Whole matched probe `.text` grows2234535→2234695B (+160B). Whole matched Vulkan render-test `.text` grows6429111→6429415B (+304B). Its render9947B, mapped render10056B and atlas724B bodies are unchanged; placement expansion changes812→647B. The owner-only GPU ELF had6428759B `.text`; adding Root metadata made it6429111B (+352B), before MetricScale's additional304B. These are linked test/probe program scopes, not production executable or throughput measurements.

The matched default Vulkan suite passes49 tests. All four packet/readback probes match exactly. For704 glyphs in32 runs, the GPU still emits25088B records, uploads33760B, visits3336 CSR memberships and plans6832128 sample-draw evaluations. The existing32B/glyph packet repack and80B/run common packet remain. No instanced renderer or packet/certificate ABI change is assumed.

## Ownership and metadata costs remain charged

The safe EcoVec0.3.1 owner emits packed records directly into one growable refcount/capacity allocation and freezes without an outer Arc allocation or copy. Actual request counts for32 independently shaped unique long labels change Main164→old Arc-owner189→EcoVec157. Empty64→96→64, single106→138→106, pairs112→139→107, triples114→140→108; borrowed long29→24→23. All-clipped128→160→128. See [owner baseline probes](owner-cohorts.json) and separately sealed owner evidence commit `74698bf6846ed52792fc1f0bf61d2692dd0fba8e`.

This is not a thin owner. TextLayout remains56B versus Main48B and Arc-owner40B; the retained run is64B versus Arc-owner56B/Main32B, witness14B versus Main's32B placement+4B order, Canvas464B versus Main488B. Full scoped layout+scene+Canvas live bytes at DPR1.25 remain:32 solids2448B (Main2408), empty2256 (2024), single6404 (5596), pairs7364 (7004), triples7812 (8284), borrowed long13156 (27620), unique long29374 (47318), all-clipped13016 (12272). These charge layout storage and actual allocation capacities, but exclude parser/service/raster-cache warmup, source strings, allocator metadata and RSS; outer layout-array allocation requests are outside all measured regions. MetricScale and Root metadata change none of these retained bytes.

The owner still performs an Acquire uniqueness load/check on every pushed glyph. Each admitted multi-glyph run takes one locked packed-owner increment and a later decrement, even when labels repeat; mask leases remain per unique mask. The single-glyph scene route takes no packed-owner lease. No hot owner HashMap, global raster lock, RefCell/Cell/Rc or first-party unsafe owner is introduced. The exact owner module is byte-identical to qualified65c; its earlier50 runtime ACK/rollback/selection tests, strict Clippy,4 borrow compile-fail doctests and strict-provenance owner Miri results remain separately pinned, not newly rerun claims for this composition.

Root metadata821 uses borrowed source/bounds iterators for scans/CSR, expanding local extents only where a rounded source needs them. It adds no retained fields or allocations and costs+9 shipping lines. In the composed GPU ELF its source closure384B and enumerating iterator117B stay unchanged by MetricScale; cached bounds remain authoritative and metadata traversal has no metric normalization. Root's full/strict/assembly gates are referenced in `metadata-source-reference.json`; Root will package that capsule separately.

Exact first-party shipping source is32403→32433 lines for MetricScale (+30), using Main's core_lines.py and supplied Syn/Tokei helpers. Compared with Main4ee this full text composition is+61 first-party lines (Main32372), not source deletion. The owner adds a separately charged2315-line EcoVec dependency (vec.rs785); no further dependency is added here. Owner source alone deleted14 first-party lines relative to the Arc-owner source, while its matched whole probe `.text` grew1168B. These costs are not hidden behind the erased first-party unsafe owner.

## Qualification boundary and failure record

The frozen all-feature release Canvas+GPU gate passes303 tests across35 harnesses,4 existing ignores, with2040 tracked input hashes unchanged. It includes the numeric/rectangle tests and both probes. The separate matched default GPU suite passes49. Read [qualification.json](qualification.json) and `allfeature-gate/` for the exact scope and binaries. The first all-feature build failed because spirv-val was missing. That failure is preserved; one retry succeeded with Root's exact GPUI_SPIRV_VAL path. No source changed between attempts.

At Root's request for immediate handoff, the optional extra runtime dependency rebuild was terminated as one owned process group and reaped with exit143. It produced no new runtime qualification. MetricScale-specific Clippy, doctests and runtime reruns were not completed; the303-test gate and matched default49 are the current composition's executed qualification. Prior owner-only checks are labeled separately. Root owns final adoption/composition checks.

All source trees are sealed; both targets are released. No build, remote use, Main edit or push remains from this lane. Toolchain is exact nightly2026-10-23 (rustc7189d39d9), jobs2, native llvmpipe/Mesa26.1.4. Both normal power-of-two and arbitrary-divisor paths are reviewable in the captured code.
