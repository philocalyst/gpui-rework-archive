# Selected analytic-gradient slice: a2dd

Selected, qualified, **unadopted** source is `/tmp/gpui-gradient-bank-sol` at **`a2dd48e908d6bb5e999f5b613af3a82407353ee5`**. The worktree is restored cleanly to this commit. Baseline is `4b44b21a187c5029a83357eb03034cdad5aec141`; the earlier mapped-property cost dossiers remain separate and unchanged. Main was not edited. No further implementation tuning is proposed for this slice.

This is a real CPU/GPU/public-Element vertical slice, **not comprehensive CSS gradient support**. It implements `.bg(&gradient)`, closed typed background reflection, linear/elliptical-radial/conic geometry, explicit multi-stops including duplicate hard edges, pad/repeat/reflect, premultiplied extended-linear-sRGB interpolation, element transforms, current device-rectangle clips and correlated rounded self coverage. A native nine-panel example exercises all geometry/spread combinations and immutable resource replacement. Oklab/Oklch, hue policy, CSS stop fixup/hints, gradient text and durable replay remain required continuation work.

## Source lineage and qualification

| Role | Exact source | Status/evidence |
|---|---|---|
| Original gradient caller-guard version | `472a2d8825ed2bca747f128259c9fe53a72e4b8c` | Separate immutable worktree `/tmp/gpui-gradient-paint-sol`; prior report `../gpui-gradient-paint-sol-evidence/guard472/REPORT.md` |
| First solid-authority allocation fix | `fb97b82078356989be12f1dc07f9b53792476918` | `qualified-fb97/`: default 864 passed/13 ignored; GPU 63; scalar 2; strict passed |
| Selected in-place reconciliation | `a2dd48e908d6bb5e999f5b613af3a82407353ee5` | `qualified-a2dd/`: default 866 passed/13 ignored; GPU 63; scalar 2; strict passed |
| Rejected finalizer experiment | `c1977dd9b6709b215fcc85b5d16ab0ec1cd378dd` | Focused 8 passed; matched native cost regressed; not fully qualified or selected |

Selected gates ran `qualify.sh`: locked default Canvas+GPUI tests/docs; locked GPU tests with `vulkan-tests`; independent Canvas scalar oracle without default features; strict all-target Clippy on Canvas/GPUI/GPU with `-D warnings`. Every exit is 0. Before/after guards match all 2033 tracked crate/vendor/Cargo/config inputs, with clean git before/after. Toolchain records, complete output and result counts are in `qualified-a2dd/`. The 866 default passes span 98 test-result blocks; GPU 63 includes 49 render tests, 13 unit tests and 1 doctest. These counts are not 866 independent gradient-only tests.

Exact selected native demo ELFs also passed real ReferenceCpu and GPU runs, each acknowledging two frames with `source_epoch=1`, `presentation_epoch=1`, nine gradients and `owner_rebuild=true`. See `remote-final/native-{cpu,gpu}.log/.exit` and `native-proof.sh`; both exits 0, ELF before/after hashes match, and Xvfb/children were reaped. No speed or timing claim is made.

Earlier failures remain separately preserved, including the stale image-permutation upload expectation, numeric-frontier fixture corrections, strict/editor/catalog failures and the first solid test's author-color mismatch. The corrected permutation contract is zero resource upload for the same key set while the prefix fits. `270b869eea97f3ee9560110bd5f6c9c1fb938cbf` failed because its test compared differently authored transparent colors; fb97 corrected the fixture, without changing that implementation. No failing run is represented as a pass.

## API, authority and ownership

`Gradient::new(geometry, stops, extend, Interpolation::LinearSrgb)` constructs an immutable analytic resource. `.bg(&gradient)` borrows it during description. `BACKGROUND` remains PropertyId 7, now typed `Property<Brush, PaintStyle>` with the closed Solid(Color)/GradientKey value. This changes the selector's public type in the prototype; existing color literals/signals/mapped colors retain their builder path and erased Color values are wrapped canonically. The selected constructor destructures the sole interpolation variant exhaustively, so a future variant cannot silently compile as LinearSrgb.

Solid contributions live only in the existing Styles override mask/value. The sparse bank stores only gradient overrides. Resolution is gradient override, explicit solid override, declared gradient, then solid base; Inherit clears both override lanes and reveals the latest declaration. Style.bg is the compiled solid arm and transparent for a selected gradient. This avoids a second background authority and prevents plain solid overrides from creating a material bank.

Gradient keys have private lanes and a checked monotonic 64-bit process identity, independent of allocation addresses. Target generation and current owner-bank membership are checked before mutation; an arbitrary copied/mapped key is not registration or a capability. `Win::gradient` requires a live target and matching resolved key, then borrows original geometry/stops. Deep serialization records the key, **not a self-contained resource**. It does not support durable replay, resource remapping or persistence. Mounted inspection supports existing solid channels and a typed read-only gradient summary; there is no stop/hue editor.

The existing cold Runtime image pointer owns `SceneResources`, logically grouping images and gradients. Redundant image presented/pending Vec cohorts were deleted: production image lookup read only logical resources, Canvas retains the latest complete scene across failed preparation, and submitted backend objects retain their buffer ownership. Tests exercise complete predecessor, failed newer source, stale ACK, renderer loss, replacement and removal with image/gradient keys, pixels and authority. The deletion does not assert that all image-description refcounts disappeared: the remaining logical image description still acquires one lease per distinct new image.

Canonical gradient draws borrow one lease per distinct scene resource. An exclusive staged Canvas replacement records exact predecessor references and moves leases only at commit; abort/noop leaves the predecessor intact. This does not retain allocator-address identity/history. GPU packs borrowed immutable words and retains keys/offsets, without a per-draw Arc clone or CPU stop-vector mirror.

## Allocation, capacity and work ledger

Measured ordinary floors are unchanged: Color 16, Style 88, Node 40, Destination 4, PropertyValue 28, PropInput 48, ElementExtra 56, Runtime 1824 and Metadata 264 bytes. Gradient handle 8, private key 8 aligned 4, borrowed view 24. A two-stop resource allocates once, 200 bytes: 24-byte ThinArc envelope +48-byte packet headers +64 bytes/stop. The 176 payload bytes retain exact author Color bits alongside prepared interval coefficients. There is no temporary stop Vec in construction.

SceneResources is 32 bytes versus old Images 80 (−48), after deleting its presented Vec and pending sequence/Vec. This also removes their per-candidate Vec allocations and redundant handle/refcount cohorts: 8*(N_presented+N_candidate) logical handle bytes, with allocated Vec capacities additional. It is a structural deletion ledger, not a paired whole-owner benchmark. Canvas and GPU each add an optional gradient-bank pointer to their existing cold image resource envelope (+8 bytes each when present). Gradient-only Canvas shares that envelope. No ordinary retained Canvas/Runtime header was widened.

Backgrounds is 72 bytes for three BTreeMaps: declared identity→key, resource key→Gradient, override identity→key. Heap nodes/control/capacity exceed these headers and remain charged in allocation measurements. Description adds a transient 24-byte drafts Vec header; a gradient plus other extra geometry can use two existing 56-byte ElementExtra boxes. The source's 64 MiB combined image/gradient limit counts payload, not every owner allocation or map node.

Matched plain `BACKGROUND.set` measurements use the same named 16 px div fixture and old Color/new Brush catalog paths, physical build path, nightly and flags. Baseline test pin is `e0c8701ade748cea416b2e85d33c742fecf64c69`; prior 472 diagnostic is `6843118d39c09dcc6148bf4659bce6693e2127c5`. See `plain-set-allocation.json`, original logs and selected `final-focused.log`.

| Plain contribution phase | Baseline 4b44 = selected a2dd: allocs/requested | Retained delta / peak delta | Prior 472 allocs/requested |
|---|---:|---:|---:|
| First solid override | 7 /2056 B | +1680 B /2056 B | 10 /2480 B |
| Warm changed solid | 5 /376 B | 0 /376 B | 5 /376 B |
| Equal solid | 1 /16 B | 0 /16 B | 1 /16 B |
| Inherit | 1 /16 B | −1680 B /0 | 1 /16 B |

Selected and baseline keep SceneResources absent throughout and existing StyleDense capacity 88 B. Prior 472 retained a redundant cold bank (+424 B on first override, 3 additional allocations); it remained until Inherit. These measured allocations include fixture metadata; the equal 16 B row must not be conflated with the separate typed-gradient fixture's equal 0 B row.

Selected reconciliation sorts the already-owned drafts in place by key for unique-budget admission and retention, then by node for in-place declaration reconciliation. It reuses the authoritative new IdentityIndex for liveness. It deletes a temporary live BTreeSet, needed BTreeMap and replacement declared BTreeMap. A sparse override-key BTreeSet still allocates when needed; two O(D log D) sorts and input-draft allocation remain. Setter pruning checks only a displaced key's O(D+O) liveness, replacing the old per-resource nested scan. There is no second shadow identity graph or retained history. Budget preflight finishes before moving/mutating the predecessor bank.

| Measured path | fb97 before scratch deletion | Selected a2dd |
|---|---:|---:|
|16 unchanged owner descriptions |336 allocs /28736 B requested |256 /20544 B; 0 retained delta; 960 B peak |
|16 equal typed gradient contributions |0 /0 B; 0 descriptions |0 /0 B; 0 descriptions |
|16 changed Solid↔Gradient contributions |112 /8416 B; 0 descriptions |112 /8416 B; 0 retained delta; 376 B peak; 0 descriptions |
|1 unchanged reconcile with live override, excluding input Vec allocation |5 /512 B |1 /104 B;−16 B net as input Vec drops; 104 B peak |
|1 unchanged reconcile without override, excluding input Vec allocation |— |0 /0 B;−16 B net as input Vec drops |

This is genuine bounded scratch/work elimination, not universal zero-allocation owner description. Budget/resource tests cover duplicate declarations, multiple override owners sharing one key, dropped owners, base changes under overrides, rejection rollback, stale keys, clear/redeclare and source failure. Combined-budget tests deduplicate two shared new declarations and two old override resources before mutation, admit the exact 64 MiB limit, and reject the next 4 B image without changing the complete scene/token/pixels.

Separate clone/drop instrumentation, **not shipping source**, proves warm lease reuse. Positive diagnostic `ea574d759ccb1a3574683d4b11b6c60e4f93ba82` passes with 0 clones/drops for 16 unchanged owner descriptions, equal contributions and both isolated reconcile paths. Changed Solid↔Gradient produces 8 clones /8 drops. Deliberately replacing occupied entries in negative `8669466b1eae9048385791a1073218ff4c06f609` fails 101 with 16 clones/16 drops on unchanged descriptions. `lease-audit/` contains exact patches, pins, logs and exits, including the first diagnostic compile failure. The local Cargo target's last test executable is this deliberately failing diagnostic; use the sealed selected native ELFs or rebuild selected source, not that cached test executable.

GPU same-key sets, including permutations, upload 0 resource bytes while the reserved record prefix fits. New keys or prefix growth repack/upload the complete image+gradient set. There is no partial stop-range update. Immutable stop replacement creates a new resource and currently performs a legitimate owner rebuild. Coverage uses Fearless SIMD; parameter/interval evaluation is scalar per covered sample. Requested full description, scene lanes, binning and output sampling still run.

## Matched linked code, readonly data and frames

Counter baseline 4b44, prior 472 and selected a2dd used the same physical remote source/target paths, release profile, X11 features and pinned Rust nightly 7189d39d9/Clang 21. Build scripts use jobs 2. Source transitions were clean and guard-matched; `gpui_gpu` release artifacts/build-script freshness was forced. Actual generated WGSL was saved, asserted newer than the lane guard, and found twice byte-for-byte in each linked ELF. Selected shader SHA256 is `2bc6d1496958940cbea031eb0f08233ce74c7a2f6bfad7038d81c3ebdce5ab9d`, unchanged from 71 through a2dd and the rejected finalizer. Native artifacts/logs/guards/freshness checks are in `remote-final/`; source capsule is `remote-final/source-a2dd.tar.gz`.

| Counter, bytes | Baseline 4b44 | Selected a2dd | Delta vs baseline | Delta vs 472 |
|---|---:|---:|---:|---:|
| Whole ELF |23849600 |23975872 |+126272 |+8968 |
| `.text` |10903280 |10978016 |+74736 |+3312 |
| `.rodata` |5853504 |5859608 |+6104 |0 |
| `.eh_frame` |1141268 |1147260 |+5992 |+1864 |
| `.data.rel.ro` |396232 |397712 |+1480 |+344 |

All whole-ELF and section growth is charged, including monomorphized BTree/sort helpers, unwind data and linker layout. Function source alone does not establish causal attribution. The gradient demo ELF is 24034024 B: `.text`11004096, `.rodata`5859976, `.eh_frame`1150692, `.data.rel.ro`397760. Versus 472 it shrinks 24400 B overall/11680 B text while readonly+128 B, CFI−2608 B and reloc-readonly+280 B. No representable same-capability solid baseline exists for the analytic demo; it is not an equivalence benchmark.

| Actual Counter function | Baseline code/CFA bytes | Selected code/CFA bytes |
|---|---:|---:|
| after_source_changed |9017 /1200 |9017 /1200 |
| describe_inner |31853 /2336 |34720 /2448 |
| flatten_lists |11455 /2096 |11024 /2160 |
| ElementExtra::into_parts |1738 /288 |1785 /304 |
| IdentityIndex::from_ids |1516 /112 |1516 /112 |
| background::reconcile |absent |5151 /320 |
| Fanout::freeze |1533 /320 |1533 /320 |
| Fanout::map |836 /288 |836 /288 |
| Fanout::finish_description |1488 /176 |1488 /176 |
| MappedFanout::publish_colors |833 /208 |833 /208 |

Ordinary describe retains **+112 CFA bytes** versus 4b44 (+32 versus 472), flatten+64 and into_parts+16. The resource helper is skipped when no gradient drafts or bank exist, but the caller's frame is reserved first. Actual Counter call sites: describe_with_changed→describe_inner at 0xfecf4; describe_inner→background::reconcile via relative GOT at 0x118848; flatten_lists→into_parts at 0x16e708. IndexBuilder call is 0x1187cc, draft-length test0x1187d9; empty drafts branch 0x118a06 tests SceneResources at 0x118a0c and backgrounds at 0x118a11, skipping to geometry 0x118a1c when absent. Existing bank/nonempty drafts enter the helper. Full resolved calls and assembly are preserved.

Reconcile's 320 B CFA is smaller than 472's 384 B, **not a total peak-stack reduction**: new key-order small_sort_general is 1217 B code/CFA 880, node-order small_sort_general 1295/CFA 864, key quicksort 1503/CFA 112. Other BTree/sort frames, recursion/fallback and their callers remain charged. `gradientfinal-counter.material-helper-family.json`, `.all-functions.json`, `.all-function-deltas.json`, `.resolved-calls.json`, `.asm.txt.gz` and `.frames.txt.gz` preserve the actual inventory. CFAs are static function-frame bounds including saved registers/return address, not measured whole-call-chain peaks. The selected demo's describe is 34720/CFA 2448 and flatten 11698/CFA 2112.

The bounded alternative c197 moved index construction and conditional resource reconciliation into concrete `image::finish_description`. Actual matched Counter whole ELF grew another 16856 B, text 5040 B, readonly 256 B and CFI 2816 B; describe CFA rose 2448→2464 and every ordinary description entered the new 2015 B/CFA 240 finalizer. Reconcile rose 5151/320→5559/336. Demo ELF also grew 7880 B/text 544 B/CFI 1496 B. It was rejected despite the demo describe code reduction. Return layout diagnostics (Index 24 B, Result<bool,Error> 56 B, Result<(Index,bool),Error> 56 B) did not predict away the observed cost. See `remote-finalizer/REJECTED-COST.json` and preserved exact native artifacts; no aggregate-return or ordinary-frame improvement is claimed.

Exact Syn/Tokei shipping count is **33594 six-library non-test source lines + unchanged inline-call helper 50 = 33644**, **+1279** over 4b44's 32365. `final-core-lines.json` records exclusions and tool/source hashes. fb97 is 33609 and 472 is 33586. Test/diagnostic/docs/demo/evidence lines are excluded; conditional/macro ambiguity stays charged. Helper source SHA remains `fd7a17dd45f972bb3b7387ebf36edc7bf93efd4828d2c04bc7f1ec335c2525ad`; its parent's 64 Miri test executions remain the separate qualification. This slice adds no unsafe code.

## PreparedSource, packet tail and clip composition contract

Review these boundaries explicitly when composing with newer Main text-tail/certified-solid work and clip b164. Selected source predates those changes; its old append/reserve text path should not overwrite the newer canonical text transaction/capacity logic.

* Canvas `canvas.rs`: private `GRADIENT_SOURCE=1<<28`; `RESOURCE_INDEX=(1<<28)-1`. Existing image bit 30, nearest bit 29 and rounded-source bit 31 remain. `resource_material` excludes rounded-source and recognizes image/gradient. Gradient source resolves to `PreparedSource::Gradient { gradient: GradientView, radius }`, distinct from Solid/Image. `PreparedSource::is_solid()` matches only Solid. Resource common color is WHITE as a material placeholder; it is **not a uniform-solid or opaque certificate**. Resource draws do not consume the shared solid PaintSlot/Color row. Stored paint/radius lane meanings must be preserved alongside clip flags.
* GPU `renderer/images.rs`: gradient marker is **bit 29 of atlas.x**, with absolute WORDS-buffer address in low 29 bits; images use bit 31 of this field and rounded solid uses bit 30. These are field-specific tags, not permission to reuse/erase Main's independent certified-solid record-tag bit 30. Gradient atlas lanes are `[GRADIENT|word_address, radius_bits, radius_scale_bits]`; metadata/correction words outside these three lanes stay intact. Shader gradient decoding precedes generic solid/glyph handling and strips `0x1fffffff`. Alpha-one gradients still vary spatially.
* Shared immutable resource schema is 3 vec4<u32> headers plus 4 vec4<u32> words/stop. CPU and WGSL use the same prepared data. Existing WORDS binding holds draw-record prefix, optional unused prefix reservation, image pixels, then gradient packets. There is no added storage binding. `images::prepare` takes the full prefix end, reserves its power-of-two extent, and repacks when it grows beyond the previous reservation. All resource ends must fit below 1<<29 and device/budget limits.
* **Clip composition must save `draw_words_end` before appending clip nodes.** Forward placement decoding and reverse CSR traversal currently terminate/start at `records.len()` (renderer.rs:879/895); after adding clip records they must use `draw_words_end`. `images::prepare` currently receives `records.len()` at 829; with clips this prefix must include draw+clip words, so packed images/gradients start after both. Clip-node addresses and gradient addresses must remain absolute in the same WORDS space. Prefix growth must invalidate the stable resource tail even when material keys do not change. Draw-record byte statistics need an explicit draw-vs-clip meaning after composition.
* Clip chains remain material-independent. Preserve parent-prefix/intersection semantics and apply them at the same 16 canonical sample positions as material/rounded coverage; do not multiply independently averaged coverages. Conservative finite rects/hit geometry must not be confused with clip raster encodings. New borrowed clip-chain fields on PreparedDraw/PreparedGroup must be threaded through literal constructors, including gradients. Clip words precede material tails, and all re-lowering/viewport certificates remain the clip implementation's responsibility.

## Numeric coverage and honest limits

Offsets/geometry are finite and bounded by 1e6; 2..4096 explicitly ordered stops are required. Duplicate zero intervals are hard edges; positive subnormal intervals/nonfinite reciprocals are rejected. Prepared geometry coefficients above 1e12 are rejected. Repeat/reflect require a nonzero period and at most 2^20 periods over the admitted normalized rectangle. Zero/degenerate cases are admission errors, not CSS averaging/fixup guarantees. Original author colors, including HDR/out-of-gamut/transparent-endpoint bits, remain inspectable; premultiplied interpolation intentionally loses hidden RGB only in the rendered sample.

Independent scalar oracle uses authored stops and f64 geometry/interpolation/compositing, not compiled interval words. It covers tiny normal adjacent intervals, rejected subnormal overflow, negative repeated phases, conic seam/center/rotation, normalized extremes, half-ULP hard-edge boundaries, tiny alpha and transparent endpoints. GPU tests include 72 HDR geometry/spread/transform/radius cases and independent exact hard-edge/premultiplication checks. Actual linked shader faults changing the upper-bound tie and removing interpolation both fail pixel assertions with valid initialized Vulkan pipelines, preserved in the original evidence. These tests do not prove universal f32/transcendental/tie equivalence.

**Public evaluator limitation:** constructor admission certifies the renderer's sampling domain derived from points in the normalized background rectangle. Public `GradientView::sample`/`sample_parameter` currently also accept arbitrary points/finite parameters. Far outside the certified domain, Repeat/Reflect phase arithmetic can overflow or become non-finite; public evaluation has no fallible domain guard, and its result is not covered by the pipeline certificate. Do not imply all finite parameters are safe. A continuation should document/enforce a supported domain or split a fallible public evaluator from the private certified kernel. This report records the issue without changing the selected numeric implementation.

Still unsupported: Oklab/Oklch and other interpolation spaces; hue routing and missing components; CSS omitted-stop fixup/hints/double positions/degenerate averages; focal/two-circle radial; independent paint transforms; gradient text/borders; rounded descendant clip chains until qualified composition; arbitrary new mapped GradientKey registration; mutable stop editing/partial uploads; self-contained serialization/resource replay; typed stop/hue inspector; vectorized interval evaluation and analytic AA. These are required designer-API continuation work, not established by this slice.

Future polynomial Oklab discussion is a hypothesis only: inverse Oklab is cubic for linearly interpolated LMS; varying-alpha premultiplication can be reparameterized by `v=t*a1/((1-t)*a0+t*a1)`, then multiplied by interpolated alpha. Equal-alpha and one-transparent-endpoint reductions and constant-hue Oklch may simplify it. No such mode is implemented or certified here. Coefficient cancellation, negative near-zero HDR and subnormal alpha still require independent oracles and bounds.

Semantics were checked against primary [CSS Images 3](https://www.w3.org/TR/css-images-3/), [CSS Images 4](https://www.w3.org/TR/css-images-4/), [CSS Color 4](https://www.w3.org/TR/css-color-4/) and [Skia's explicit interval implementation](https://skia.googlesource.com/skia/+/a17799aa59f3fadd18729e1c76e41086fcaae9ca/src/shaders/gradients/SkGradientShader.cpp). These references informed explicit choices; they do not make this subset CSS-complete.

## Artifacts and release

`HANDOFF.json` indexes source/patch/qualified logs/costs/native proofs and rejected evidence. `selected-vs-4b44.patch` is the complete selected patch, including tests/docs/example; it is not an instruction to overwrite independently advanced Main code. `remote-final/source-a2dd.tar.gz` is the exact bounded compile-input source capsule. Native ELF hashes: Counter `dc0b2c32087e48427643d6346ea5885b554e27f58884e31e690520ee58455bde`; demo `4db64500661b94e8c172d25df8142c93b77da9d3eb173d0c378ec43c2ebf344d`.

All local qualification/native/diagnostic processes and remote build/copy/SSH jobs are reaped and leases explicitly released. No remote timing overlapped our builds. Remote 8 GiB free-space floor was maintained. One overbroad source archive copy was stopped before extraction/build and replaced by the bounded 8.3 MB compile-input archive; its own redundant local failed archive is retained separately, not part of the selected source capsule. Historical failed/aborted evidence remains intact. The worktree can now be handed off for read-only review or isolated composition.
