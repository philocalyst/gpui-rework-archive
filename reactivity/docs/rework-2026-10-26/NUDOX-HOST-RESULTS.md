# Nudox checkpoint: source, evidence and remaining work

This is a checkpoint of an unfinished rework. The central missing implementation is the actual persistent target/index consumer of canonical damage. No new unified real-scenario latency or matched peak-memory result exists. Component correctness and codegen measurements below must not be read as end-to-end speed or shipping qualification.

## Frozen implementation sources

| Source | Actual commit | State |
|---|---|---|
| Compact physical catalog | `a6278268abbe95210647402d8d7de8983c863404` |35 focused/43 full core-cut tests, intended free-chain falsifier/restoration, allocation and linked-code controls passed. Standalone source-root history. |
| Catalog in coherent common core | `3f26549bc4d228df72a2eadc0d4b90b9db2aef04` |122 tests passed; exact catalog module plus export, real newer core contract retained. |
| Fused recording/material-owner precursor | `55d97528a5f9d1a31a9a792778ae4744ad9dd0f3` |Canvas/GPUI release compile passed;21 named passes, one stale test expectation failed. |
| Corrected rendering test descendant | `ef3bd59b7301c722271e757a3bd4c04dd1016981` |All22 named tests passed; production source identical to55d. |
| Qualified borrowed partition | `42927b4aaff46e1d72009c5cfa9b081eba1ff0f9` |269 parallel/257 no-default tests,4 doctests each, common-plan and full-pixel/pool controls. |
| Qualified prefix kernel | `149cc86c659958b1ea3b588aa5d11db650507ecd` |273 parallel/261 no-default,4 docs each, mechanism/threshold/whole-image/complete-stat/pool controls. |
| Qualified by-reference handoff | `c0b4c1da330dc866c193edbbc08d1c793511a53f` |Same complete controls, original sample/blend/mean math retained. |
| Qualified CSR end-cursor update | `8be82d4d0aeb245e912c23b2152990add0cfe90a` |274 parallel,262 default-SIMD,262 scalar tests;4 docs each;12 images,48 full-stat rows,36 pool checks;3 intended mechanism failures plus restored positives. |
| Actual coherent renderer merge | `59acb124a0a2148ffb8cc55d39725f1fb2012491` |Exact11-path renderer delta on55d;1494 guarded inputs. Release compile and9 focused tests passed; legacy header assertion failed. No new consumer implementation. |
| First default coherent host assembly | `ce18a57492076ae6038795c42ae842242326d748` |Four exact smoke tests passed after narrow shared compiler corrections and host-owned stable-port adaptation. |
| Retained-text path correction | `4b0ff7f7a527addc2756bc2b4dcdb587fcec3e9a` |Production and full libtest compilation passed; named late-owner/raw-width-identity test passed. |
| Solver/write sink | `8a17eeae05b232f0c85aad14884c3a84f042d832` |22 selected passes;2 failures reproduced on identical-feature4b0 predecessor. Original errors and test bodies preserved. |
| Region-local observation compatibility | `7a9fcd76ed40b517fc6ad0e165f4a431535630a5` |21 selected controls passed, including unchanged full cross-product/cold outputs. |
| External provider boundary | `effcf0a99e56ff3bc6ef9f7a4ce79d8fb1b6b740` |Test-only descendant; external len1→2 remains outside disjoint transform observation, resize discovers the new row and matches full cold output. |
| Selective solver output | `5c674a8575e796de5c1923bbfb0c92efe9b8ffdf` |29 selected passes:core3,GPUI22,public4. Distinct from renderer merge; not silently adopted there. |
| Omitted-offset mechanism mutant | `e2a27e05fc89901eda4aff6f1e28d29b66e7b6d6` |Expected0 pass/1 fail/exit101 at frozen assertion111:9, after actual cold/full output checks. |
| Fresh reverse-restored selective source | `ccaecc38488edde9beb4e256e1d7fe69bfdde32d` |All bytes/modes/Git tree equal correct5c; fresh compile and restored exact positive passed. |

The source inventory and Git transports preserve exact histories. Separate source roots, controls, mutants and unsupported drafts are not automatically compatible. A latest cloud experimental composition is a separate checkpoint family until actual host integration and gates run. No merge to the default branch is part of this publication.

## Exact failures and corrections

The original55d sixth rendering test, `truncated_paint_plus_hidden_layout_requires_full_snapshot_before_publication`, failed at `crates/canvas/tests/publication.rs:146:5`: prepared batch entries length0 versus expected1. Current core intentionally keeps pending facts privately but exports no unusable copied rows for hard-full candidates. The slot rejection assertion on the following line was initially unreached. Test-only539973/hostef3 now requires exact length/capacity0/0, preserves the CAPACITY and IncompleteChanges checks, proves retry history survives rejection, and proves only successful full commit drains it. All22 exact gates then passed. No production guard was loosened.

The coherent renderer59ac has a separate, still-preserved failure: `canvas::bins::tests::recording_has_no_scratch_allocation_and_first_raster_charges_one_owner`, `bins.rs:471:13`, Canvas size864 versus legacy464. Actual common-model Binding/OptionBinding is400 bytes; Receipt48, Batch80, Groups64. The baseline common-layout test passed and explicitly charges this inline cost. Other measured values remained2 allocation requests/76 bytes, retained76, CSR20, Scratch56, Stats96, Frame88, warm0/0. No accounting repair was applied to59ac and no whole-suite pass is claimed.

Solver compilation first exposed two independent callback lifetime errors, then six missing test imports. Narrow private Engine lifetime separation and test-only El/Signal imports corrected them without public signature/runtime-body/oracle changes. Two later failures were paired on identical default+SIMD opt0/debug0 source4b0 and8a: cross-product descriptions1 versus0, and coalesced preserved-surface `full_rect_tiles < full_work` after complete pixels already matched. The b6d observation correction fixed the unchanged cross-product on7a. The separate work-reduction assertion remains unresolved. The five-buffer/64-frame aged/expired-history pixel corpus passed. A successful diagnostic collector exit is not a test pass.

## Structural measurements, with adverse costs retained

The original full-copy catalog stages about4,082,856 requested bytes at40k contributors. Paged/lazy/rank-split/bulk-builder controls, independent inner hash seeds, compact≤512-byte payload storage, and outlined promotion were developed as separate frozen sources. The current catalog's observed tiny live requests were128/176/512/512 bytes for N=0/1/7/8. A40k rank edit plus freeze requested5,600 bytes. The8→9 promotion requested6,500 bytes/44 requests. Large old/new membership still rebuilds **two16MB reference vectors**; page sharing has not removed that cost. Requested backing unions exclude allocator overhead, RSS and hardware-cache traffic. Random hash distribution affects observed capacities.

The outlined catalog's linked insert/remove/rank CFA values are192/640/144 bytes; shared promotion remains4,412 code bytes/CFA784, history validation707/CFA320 with a256-byte visited array. Builder/reserve frames remain1,936/3,664. These are static linked-code facts, not elapsed speed.

Borrowed row partitioning removed a224-byte worker copy and reduced BGRX worker CFA1680→1232, with an explicit branch tradeoff21→30 and admission CFA208→240. Prefix control avoids Samples construction for clear/uniform/covered-only bands, constructing it once at the first sampled continuation. By-reference handoff reduced sampled CFA73760→72544 and static copy sites5→3; blend576→336 and1→0. The sampled path still initializes69,664 bytes; prepare retains a2624-byte frame. Combined sampled call-chain costs and elapsed speed are not qualified.

CSR prepare removes the old offset memmove: source `base+4` to `base`, length4×(offset length−1). Linked prepare2087→2061 bytes, copy site1→0, branches40→37, frame224 unchanged, memset2 and allocator sites2 unchanged. This removes one O(T) offset-copy pass; two command-bound traversals, reference generation and index zeroing remain.

## Actual consumer: implemented versus missing

The current route is native CPU presentation → `Runtime::render_preserved_bgrx` → Canvas region rendering/common executor. Existing `Prepared.damage` bounding union and surface-age history preserve conservative old behavior, and native ACK follows successful presentation. These are useful existing controls, not the new target-domain consumer.

**Missing at this checkpoint:** actual storage/domain/generation binding and completed C; ingest of contiguous canonical receipts; shared physical old/new expansion while exact old/current resources remain leased; bounded target tile union across skipped outputs; explicit prewrite preservation versus first-write image revocation; completion after actual joined writes and required copies/fences. No production code implementing this new consumer was written before the checkpoint reset.

The concrete synchronous seam is `CanvasScene`, which already owns an exclusive old-target/new-pending borrow before commit. Pending gradient leases can intentionally be None until moved from the predecessor. Precommit expansion must resolve through those exact predecessor semantics; pending PreparedScene is not an accepted/render-ready snapshot. Async jobs also need real resource owners until actual completion. Catalog bindings and nominal resource kinds do not provide this lifetime authority.

Required tests remain: C2-left/C3-right/C4-left-revert without intermediate rendering; C0→left paint→metadata with same draw token→right paint→one render; ordinary insertion/removal/clip/order exposure; actual global paint-bank shader-mode changes; dropped receipt chains and surface-generation changes; failed preparation, invalid prewrite admission and injected postwrite failure. Compare complete cold/full pixels, not only counts. No named popover bypass is acceptable.

## Realistic benchmarks and honest graph scope

The six unchanged names are hover-source-paint, hover-property-paint, hover-property-layout, popover-scroll, window-resize-layout, app-ticked-geometry. Older source3a3a4cdec8dc40d2b491ab80e7b9cfdfd0e226d1 completed side32/warmup32/240 samples each with normal correctnessc85abb947ad8ee4ea190c71c73019da8ac486c2a. Its descriptive counters explicitly are not cross-source timing. The older software corpus compares ordinary FULL and REPAIR at observer128e07209c2868996a98b9071ff2dfbc036b9e87:24 cells/640 exact subframes, with full scene preparation/binning/uploads still charged. Scheduled area is not operation time.

The software timing pilot source9ec80d13fcc6d151096ee6f1af759cce57a576ac passed a new clock-disabled41-frame exact preflight. Its first FULL timing process then stopped on the strict affinity guard with empty sample output. There are **zero complete operation timing samples, zero usable pairs and zero matched peak-memory samples**. Aborted initialization RSS and unpaired preflight RSS are not scenario-memory comparisons. No trustworthy unified speed graph exists. Historical plots must retain their exact source/compiler/workload provenance and never be relabeled as current performance.

## Weakest areas and designs not yet tried

- Finish one source composition and actual consumer before another isolated optimization. The source/test/worktree count itself is not progress toward this missing path.
- Share unchanged tile membership pages/rows and avoid rebuilding both large reference vectors. Price directory/index copies, old-reader retirement and rank relabeling; do not hide an O(N) rebuild behind page sharing.
- Replace full DependencyNode BTree expansion with compact per-site phase masks, implicit tree relationships and sparse explicit non-tree edges while preserving exact closure. The measured1000-site graph control retained637368 bytes flat/1458720 nested; sparse Paint visits3 versus Layout6003/7001. Those generated graph probes are not production-population or RSS results.
- Bind actual solver cached-question replay, answer/placement/overflow facts and completeness to the combined consumer. Missing facts force Full. Final-layout writes alone are insufficient.
- Complete registered unique-backing accounting and real resource retirement across mandatory model/packed/font/image/gradient/GPU owners. Optional raw-shape quota is not a global memory/OOM bound; Any-kind or nominal font-free labels are not immutable-content proof.
- Close ordinary-stable SourceValue nominal record/enum/nonClone/ownedDrop compatibility without blanket traits or weakened negative tests. Current host c288 is explicitly scoped and experimental; Mac owns broader migration.
- Evaluate safe epoch-tagged Uniform/Mixed sampling only after coherent workload evidence justifies it. Epoch wrap, enum size/stride/copies, original sample correlation and scalar/SIMD mean order must be exact. Rejected Option storage and borrowed-array copy controls stay rejected/undemonstrated.
- Measure actual parallel scheduling and cache effects on qualified realistic workloads. Current worker-pool correctness on one pinned CPU proves outputs, not scaling. Static copy-call/CFA counts do not prove traffic or peak stack.
- Qualify native display/input/IME/accessibility and actual hardware GPU execution separately. Software llvmpipe exactness is not hardware speed or scanout latency. Any future task-local Mesa affinity correction is a new dependency identity with new gates; no override/retry was performed.
- Run precommitted, genuinely quiet matched cold/warm realistic baseline/candidate processes only after source/consumer correctness and work gates. Preserve all partial/invalid attempts and raw distributions. Do not manufacture wins from unrelated production load or synthetic microprobes.
- Reduce orchestration overhead: repeated source families, source-mode reconciliation, wrong helper paths, a nonexistent `/bin/bash`, and Rex's64-pane capacity caused real setup-only interruptions. Consolidate exact-source import and bounded execution into fewer stable controllers, with early small compiler gates and portable thin bundles. Keep the strong source/compiler/ELF checks; remove repeated registry copies and redundant audit restarts, not correctness evidence.
- Test protocol drift needs explicit ownership. Hard-full batching changed before its public length assertion; legacy Canvas header checks outlived a400-byte binding; one feature-gated observation target was initially mistaken for a default control and corrected before execution. Machine-readable feature/case inventories and tested helpers should prevent these mistakes without treating ignored or zero-selected tests as passes.

## Reproduction and publication limits

All project Rust compute used verified Nudox Prod through the existing authenticated Rex route. Three lanes used CPUs13/14/15, one Cargo job each, nice15, idle I/O and6GiB address-space bounds. Admission retained IOavg10≤20%, memory PSIavg10 zero, >8GiB available memory and >30GiB disk. Production services were not changed. Global Cargo/Nix/auth/network settings were not modified. Actual compiler/rustdoc were qualified Nix Rust1.99.0 with rust-src; ordinary stable was correctness authority, release artifacts assembly authority. JIT qualification remains narrow; no global ra-jit enable or bootstrap/nightly escape was used.

Source restorations, missing-lock repair and complete input manifests stay explicit. The source tree's historical AGENTS nightly/mothership notes are not current-host authorization. Preserve current per-lane external Cargo state/fresh targets, actual Cargo compiler provenance and source/ELF guards. Publication excludes executables, caches, raw pixel bulk, credentials and raw environment dumps. Git bundles are transport only; alternatives retain clearly indexed archival status. Root is the sole push owner, and only the verified private project checkpoint branch is authorized. No default-branch merge, force push, deployment or sharing change is implied.
