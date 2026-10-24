# Canonical text submission tails

Qualified production source: `a70abc536190566563399638362f8b314d52e3d4` on base `4b44b21a187c5029a83357eb03034cdad5aec141`. Initial red fixture: `eb763b6399c360c8a64999bbf54c1af138813481`. Matched extended control: `02b72aad0676c96d0d3cbf56e71278ff7ab503fb`. No Main edits or remote jobs.

`Canvas::draw_text_working` now appends unpublished placements and mask leases directly into the final DisplayList lanes. Its existing MaskIndex is the only resource index. The per-call pending Vec, resource Vec and HashMap are deleted. A single admitted glyph stays on the stack and publishes through the existing inline representation. A longer run publishes its already stored placement tail after every fallible check and reserve succeeds. This also removes the old generic bulk append/reserve machinery: ordinary solid/image commands have a single-command admission/append path.

On an error, the placement tail and new masks are discarded, exactly their new keys are removed, and the previous primary-face identity is restored. Painter order, common/paint rows, reference/mask-byte counters, dirty state, bins and pixels publish only after successful admission. Capacity may grow on an error, and raster-cache warming on an error remains allowed. Public tests reject after a new mask and 127 duplicate placements with another face already retained; they compare exact scene/pixel fingerprints, old resource keys and render_count, and exercise a failed replacement candidate followed by a successful draw. Runtime tests separately preserve old P and eligible C geometry, exact ACK authority, coalescing and selection after failed preparation.

This is a bounded Canvas transaction change. Runtime still stages a new Canvas for complete presentation, decodes and keys every layout glyph, prepares transformed geometry, reconstructs glyph groups, and leases each unique visible mask once per new scene. The final order and placement lanes still require O(glyphs) publication. There is no retained cross-frame glyph-group cache and no claim that shape/metadata traversal or unique-resource Arc increments disappeared. Repeated admitted placements and later labels still look up their scene key before any Arc lease. Clipped-mask lookups and temporary leases have the previous behavior. TextLayout remains the authoritative packed owner; its 12-byte glyphs, 16-byte glyph owner and 48-byte layout are unchanged. Selection, hit testing and accessibility geometry were not moved or copied.

## Allocation and retained capacity

All figures count allocations and requested bytes, not latency, RSS, allocator size classes or live peak bytes. Raster caches are warm before the counted cold submission. The following ledger comes from identical release public-API fixtures; debug checks agree.

| Submission | Cold allocations old → new | Cold requested bytes old → new | Warm allocations old → new | Warm bytes old → new |
|---|---:|---:|---:|---:|
| One glyph | 7 → 4 | 532 → 356 | 3 → 0 | 176 → 0 |
| One label, 22 admitted glyphs | 12 → 12 | 2,992 → 2,884 | 7 → 0 | 1,672 → 0 |
| 48 labels | 75 → 28 | 139,524 → 146,836 | 54 → 0 | 34,572 → 0 |
| 48 completely clipped labels | 48 → 0 | 33,600 → 0 | 48 → 0 | 33,600 → 0 |

Ordinary Vec growth is a real tradeoff. For 48 labels, retained placements grow from 1,408 to 2,048 slots: 45,056 → 65,536 bytes. Mask-handle capacity grows 112 → 128 bytes. The cold cumulative requested-byte total therefore increases by 7,312 bytes despite 47 fewer allocations. One-glyph inline storage and the 288-byte DisplayList header remain unchanged. No scratch fields are retained. Allocation growth follows actual admitted placements: an all-clipped draw allocates no submission storage, and large mostly invisible layouts do not reserve their full glyph-count upper bound.

The adjacent-count release probe changes foreground color, fractional translation, highlights and caret while rebuilding a scene with warmed lane shapes. It reports every requested cohort, including capacity losses:

| Labels | Cold allocations old → new | Cold bytes old → new | Warm update allocations old → new | Warm update bytes old → new | Retained placement bytes old → new |
|---:|---:|---:|---:|---:|---:|
| 32 | 59 → 28 | 76,428 → 74,460 | 38 → 0 | 23,372 → 0 | 22,528 → 32,768 |
| 48 | 78 → 31 | 140,876 → 148,188 | 54 → 0 | 34,572 → 0 | 45,056 → 65,536 |
| 64 | 94 → 31 | 152,076 → 148,188 | 70 → 0 | 45,772 → 0 | 45,056 → 65,536 |
| 96 | 129 → 34 | 280,972 → 295,644 | 102 → 0 | 68,172 → 0 | 90,112 → 131,072 |

These are bounded warm-allocation wins, not universal cold-byte or retained-memory wins. The probe source, compile commands, full metadata/rlib hashes and final executable hashes are archived. It links the actual guarded release libraries from the two source pins. Two preliminary external rustc invocations failed while selecting the new compiler's separated metadata format; the successful invocation supplies both full rmeta and rlib, with all dependency directories. Neither setup failure is a test rejection or counted pass. The earlier Rust 1.97 standalone diagnostic is also excluded from qualification; all archived canonical builds use genuine nightly 2026-10-23 (Rust 1.101, 7189d39d9), Clang 21 and two build jobs.

## Qualification

Every final build/check guarded the same 2,034 tracked input files before and after, required a clean exact source pin, and reported matching guards. Executables were copied from Cargo compiler-artifact JSON, frozen separately, hashed before/after execution, and run sequentially.

| Gate | Result |
|---|---|
| Default Fearless Canvas | 218 passed, 3 ignored, 29 frozen test executables |
| Scalar/Fallback focused Canvas | 20 passed, 4 frozen executables: transaction, grouped, DPI, independent render oracles |
| Vulkan GPU | 47 passed on llvmpipe, 1 frozen executable |
| Runtime text cache/geometry/selection/compound selection | 33 passed, 4 frozen executables |
| Strict Canvas Clippy | All targets, `-D warnings`, passed |
| Canvas formatting | Passed |
| Release transaction fixture | Candidate 5 passed; matched control 4 passed plus the required allocation-red failure |

The seven baseline fingerprints cover wrapped mixed-script ligatures/combining marks/RTL, selection/caret, foreground color, fractional translation, scroll revealing more glyphs (43 → 52 admitted), reflection/shear and 1.25 physical raster density. They compare exact canonical geometry/order/material/mask bytes and exact CPU output. Existing GPU tests independently cover grouped versus inline packets at every pixel, fractional glyph error envelopes, physical masks and upload/key lifecycle. These gates do not claim hardware-GPU timing, native platform integration beyond the exercised runtime tests, or a universal SIMD speedup.

## Source and assembly ledger

Production canvas.rs is 3,031 → 3,034 physical lines (+3). The private bins test is 456 → 457 (+1); the new integration fixture is 344 lines. No retained production fields or dependencies were added. No unsafe code was added.

The optimized baseline text body calls RawVec allocation and RandomState's thread-local initialization before its glyph loop, then drops the private full-key map/resource Vec and invokes a Vec<PendingDraw>-specialized append. The candidate has no per-call RandomState initialization or temporary full-key map/resource Vec destruction; conditional growth targets the final scene lanes, and rollback drains only the unpublished resource tail.

The isolated text body grows from 3,670 bytes to 5,310 including its outlined admission closure. The explicit local symbol basket (text body; its closure if present; both old DisplayList append instantiations versus new append_inline/publish_group; Canvas::admit) shrinks 9,537 → 7,265 bytes. This inventory measures those named machine-code bodies only; it is not a whole-ELF/reachable-code or latency result. Exact optimized disassembly excerpts and symbol sizes are archived.

Complete frozen executables and full disassemblies remain in `/tmp/text-sol-evidence/`, including `candidate-frozen/`, `scalar-frozen/`, `gpu-frozen/`, `runtime-frozen/`, and the candidate/control release executables and adjacent probes. This repository evidence package stores their identity manifests, logs, source guards and focused assembly instead of committing binary blobs.
