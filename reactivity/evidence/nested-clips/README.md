# Nested clipping qualification

Qualified shipping source: **b164198e02ca4172a8cd56308ad204d30f1da333**, based on immutable text source **a70abc536190566563399638362f8b314d52e3d4**. This capsule is a later evidence-only commit. Main, the qualified text branch, and the gradient branches were not changed. Source remained clean and frozen for all final gates. No remote jobs were used.

The implementation provides nested local rectangles and uniform rounded rectangles under admitted affine transforms, declarative `.clip()`/typed `property::CLIP`, continuous acknowledged input geometry, and a sparse native accessibility shape. It does not provide paths, independent corner radii, inverse masks, arbitrary Boolean operations, or a proof of compressed convex sample intervals. Existing rotated/sheared list/scroll viewport restrictions remain.

## Qualification

Genuine nightly 2026-10-23, rustc 1.101.0-nightly/7189d39d9, LLVM 23.1.4. Own target `/root/target-clips-sol-nightly`, Cargo jobs 2. `source-closure.json` records the 2,040 tracked build inputs; `qualification.json` records per-gate before/after hashes. The vendor formatting subset checks 991 inputs. Commands, exact toolchain reports, Cargo feature identities, and copied-ELF hashes are retained beside each result.

| Final gate | Executed result |
|---|---:|
| Canvas + GPUI default, 97 copied ELFs | 836 passed, 13 ignored |
| Canvas no default features, 30 copied ELFs | 225 passed, 3 ignored |
| GPU all features, 3 copied ELFs | 65 passed |
| GPUI x11 library, copied ELF | 232 passed, 31 ignored |
| Actual private-Xvfb/AT-SPI wire fixture | 1 passed |
| AccessKit with serde/schemars | 362 passed |
| Common consumer with serde/schemars | 210 passed |
| GPUI library under vendor schema unification | 163 passed, 5 ignored |
| Formatting, changed-vendor formatting | passed |
| Strict all-target Clippy, Canvas/GPU/GPUI with x11 and all GPU features | passed |
| Release allocation probe and emitted assembly/IR | passed |

These are functional counts, not independent statistical observations or timing evidence. Frozen execution reran all ordinary tests; ignored tests remain ignored except the explicitly invoked native point-query fixture. The copied executables and full Cargo JSON/source guards remain in `/tmp/clips-sol-evidence`; this committed capsule contains their identities, commands, logs, compact summaries, and focused code generation. Rejected invocations are preserved: the first all-feature command lacked SPIR-V validation, a vendor-only command could not enable workspace dependency features, and the baseline vendor test needed its existing schemars/std configuration. None changed source.

The Fearless oracle executes Fallback plus locally supported SSE2/SSE4.2/AVX2; detection was AVX2. It verifies mapping bits and all 16 primitive/ancestor sample sites. It does not claim AVX512, ARM, or wasm execution. GPU execution used local Mesa 26.1.4 llvmpipe/LLVM 21 software Vulkan, not hardware. CPU/Fearless use ordered f64; WGSL retains compensated pairs and the existing GPU precision/FTZ admission. Pixel comparisons retain the existing one-channel-unit tolerance. This does not prove every possible f64/WGSL rounded tie equivalent.

The GPU render ELF contains the exact generated WGSL (16,404 bytes, SHA256 `defb31515dfae7bedbecb6beeec4275f3cbe8d0dba84a95f2f26c391c5a1f20f`) and all four validated SPIR-V variants byte-for-byte. `shader-artifacts/elf-embedding.json` records offsets and hashes. SPIR-V validation used `/nix/store/z5hs3p3inrq3w8cv71jycz7l4y3ny5xk-spirv-tools-1.4.363.0/bin/spirv-val`.

## Semantic controls

Canvas tests cover sample-level intersection rather than multiplying separate coverage alphas; identical rounded ancestor/primitive edges retain their original coverage. Independent inverse/circle oracles cover reflection, shear, signed zero, adjacent ULPs, small/large radii, exact axis lowering, parent overlap, depth 64, node limit 16,384, invalid/foreign/cleared/aborted/replaced capabilities, and prior pixels/groups after rejected work. Parents must be strictly older. An 8-byte checked global owner counter cannot wrap; no pointer-ABA identity or retained identity history is used.

GPUI integration tests cover builder order, literal/mapped/inspector CLIP authority, coalescing without model description, failed newer candidates, eligible older ACKs, depth failure, scroll newly visible glyphs, canonical CPU pixels, and hits remaining on P until ACK. Canvas IDs remain internal to ordinary applications. Input and native point geometry follow Canvas's existing continuous arithmetic: the f32(0.1)/f32(0.3) edge and adjacent ULPs are explicit oracles. Half-open rectangle and closed circle rules remain; raster lattice snapping is not used for input.

The original native delta defect was reproduced at source `69bea2a68509a1d1fb8eaeae281085f60caf754b`: after the host acknowledged clip=false at epoch 2, the provider still clipped the child. The wire negative ends at a bounded semantic assertion, rather than relying on timeout. Separate clip-only and radius-only delta tests fail with unchanged bounds/map. Source `3368df37f7b2ec4122f0e3b8f6e76605ae5e89b5` adds frozen shape comparison to the frontier. The final source passes those controls and the wire fixture, including scale 1.25, physical 120x120, negative window origin(-40,-30), direct subtree rejection, overflow after ACK, and real surface readback against canonical CPU pixels. Reflection/shear and ULP native geometry are separate pure projection/consumer tests; those transforms were not exercised on macOS/Windows wire providers.

A second public consumer defect has a frozen negative at `51e8d8603de377d99cca1f30272c37ad12f898b2`: own radius 0 with descendant radius 5 incorrectly suppressed the parent itself. Final b164 schedules the parent's own test before pruning descendants. The regression covers child priority, ExcludeNode, ExcludeSubtree, and subtree ancestor clipping. Source `7695533f31797b8fa2d102b10ae8e7cc724bec4f` and its original failed native ELF are also preserved; the stronger later negative provides the bounded proof.

`provider-resolution.json` is extracted from the actual all-feature Cargo graph. Unix's AT-SPI common provider, macOS 0.27.1, and Windows 0.35.1 all resolve patched consumer 0.39.1 and AccessKit 0.25.1; `provider-call-sites.txt` records their common point-query calls. This is dependency/source evidence for those platforms, not cross-platform runtime proof. Native extents remain conservative rectangles; the analytic property is internal to AccessKit and does not invent AT-SPI/UIA fields or add a second GPUI snapshot.

## Exact costs

Measured baseline control `3205619ca99ac720e239941079bab06aa8c39279` changes only tests atop a70. Its three header probes pass under the same genuine toolchain. `controls/baseline-headers-schema` retains commands, outputs, and executable identities.

| Value/owner | Baseline | Final |
|---|---:|---:|
| Canvas / CanvasScene / DisplayList | 488 / 496 / 288 | unchanged |
| Existing boxed ImageResources header | 80 | 88, including image-only scenes |
| Common row / Scope / PreparedGroup | 24 / 48 / 104 | unchanged |
| PreparedDraw / borrowed CPU command | 168 / 144 | 184 / 160, transient |
| GeometryStyle | 4 | 8 logical bytes; sparse identity/style stride stays 16 |
| Decorations / ElementExtra / ExtraParts | 48 / 56 / 208 | unchanged |
| ImageSpec / ImageDraft / El | 16 / 24 / 176 | unchanged |
| GPUI Node / Presented / Style / sparse radius Record | 40 / 64 / 88 / 16 | unchanged |
| AccessKit Node / Properties / PropertyValue | 128 / 112 / 40 | unchanged |
| AccessKit property indices | 87 | 88, existing padding |
| Native borrowed RowView / ComparedRows | 24 / 48 | 32 / 64 |

A new optional arena is 32 bytes, each canonical node 104, ClipId and Option<ClipId>16, public Clip argument 24 versus Rect 16, borrowed geometry 8, chain 16, exported PreparedClipNode 96. `SceneStorage` reporting value grows 72 to 80 bytes (one added usize); it is not retained in Canvas. The new Runtime clip-chain Vec contributes a 24-byte temporary header, even with zero capacity. No Runtime or Renderer retained field was added. No clip Arc was introduced; existing image/text resource lease traffic remains.

One root reserves four nodes. It requests three allocations totaling 536 bytes: existing resource extension 88 + arena 32 + node capacity 416. This includes 312 bytes of unused node capacity. Appending three draws under that root requests zero further clip allocations. Plain El construction allocates 0; `.clip()` allocates one 56-byte semantic extension. Sparse native shapes add a 72-byte box plus one logical 40-byte property slot, with normal property-Vec capacity/slack; ordinary native node headers do not grow.

| Cold canonical roots | Allocations | Cumulative requested bytes | Retained node capacity bytes |
|---:|---:|---:|---:|
| 1 / 2 / 4 | 3 | 536 | 416 |
| 8 | 4 | 1,368 | 832 |
| 16 | 5 | 3,032 | 1,664 |
| 64 | 7 | 13,016 | 6,656 |

The release probe changes color and fractional translation after warming. At 1/32/48/64 labels, plain scenes allocate 0; axis and rounded capability scenes each allocate 3/request 536 for the whole rebuild. There is no per-label clip allocation. Clear/rebuild releases the arena, so this cost recurs. Rounded scenes retain 192 additional common/column capacity bytes compared with plain/axis scenes in this fixture. Placement capacities are 512/16,384/32,768/32,768 bytes; this standalone source still uses a70's placement growth. Root's separately qualified71ed successor must be preserved during composition and remeasured there. These results do not claim a universal allocation or memory improvement from adding clipping.

**Runtime residual:** `runtime.rs:3013` sets `list_capacity=N` when list_mode OR clip_mode. In clip-only preparation, five temporary columns reserve 53*N bytes: clip_chains 16*N, clips 16*N, hit_clips 16*N, clip_membership 1*N, published 4*N. The latter two are unused when list_mode=false. In a pre-existing list scene, clipping adds the 16*N chain column. Root will remove the two list-only reserves during composition with separate allocation/source qualification; b164 is deliberately unchanged. Existing spaces and other scene preparation allocations remain additional costs.

General continuous hit queries are O(depth); general raster predicates are O(depth*16) per visited pixel. CPU/GPU packing is O(nodes). Current GPU preparation also walks groups to detect general chains, even in ordinary scenes. General clip tables pack all canonical arena nodes, including unused nodes, when a complex chain is referenced. Only axis-proved draws can omit the table. No idempotence cache, duplicate admission scan, interval compressor, or retained coverage table is implemented.

## Code and packet ledger

The helper-aware Syn/Tokei inventory counts seven first-party shipping libraries, excluding tests/comments/blanks/docs/examples/vendors. a70 has 32,363 lines; final b164 has 33,132: **+769**. Changed vendor core is separately scoped to `accesskit/src/{geometry,lib}.rs` and `accesskit_consumer/src/node.rs`:3,870→3,988, **+118**. Counter/helper/Tokei identities and per-file inventories are in `source-cost`. Physical full diff is 3,284 insertions/171 deletions across 34 files, including tests, example, and documentation; it is not the shipping-code count.

`codegen.json` uses the real code ELF member extracted from rustc's release rlib (object 2,118,984 bytes). Focused emitted assembly is retained. Current method sizes: Canvas::create_clip 2,218 bytes ( +109-byte map closure; Scene wrapper 6), continuous contains_at 535, fill_shape 742, draw_text_working 2,108 plus its existing transaction closure 21,421, draw_image_working 1,477. There is one concrete large body per method, not one per Into<Clip> type. Depth64/node 16,384 comparisons precede allocation. Continuous membership has no locked instruction; creation's only lock is the fresh owner compare/exchange. Existing text/image lease atomics remain visible and are not claimed removed. These are current code sizes, not matched baseline code-size or latency improvements. The system Clang 21 assembler rejected LLVM 23's new `.prefalign`; no reassembled object is used as evidence.

Clip nodes consume five existing WORDS records, 80 bytes each, with a 1,310,720-byte logical table budget, depth 64, and node count 16,384. Draw/common packet strides, material flags, bindings, and renderer headers stay unchanged. `draw_words_end` is saved before clip append; forward/reverse bank processing uses that saved end. Image/material resource preparation receives the full prefix including clips. Vec capacity slack and immutable material tails remain additional storage.

**Composition requirements:** preserve Root 71ed's text placement reserve helper. Preserve complex-chain decline in sampled_rect_clip, lowered-solid and full-tile admission when composing Main's certified-solid source; a finite PreparedGroup.clip is only a conservative envelope. The all-solid negative must remain green after that merge. Gradient source owns material bits and immutable image-then-gradient tails. Clips use no material bits and must remain before those tails; address preparation must include clip words. This branch's permutation fixture permits the old a70 image-cache 8-byte reupload; the gradient branch's zero-upload optimization is independent. Root's composed gradient+clip/material-tail and P/C resource-lifetime fixtures are required for the final combined source; this standalone branch has no gradient implementation.
