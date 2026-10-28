The certified-solid shader submitted more host receipts under the failed animation workload: 224/224/223 versus the original’s 182/179/182. Every animation window failed the unchanged model-delivery and host-count gates. This is an observed overload-throughput improvement, with different delivered model work; it is not an equal-work CPU saving or a qualified animation win. Banked-four submitted 188/187/188 and remains unadopted.

All nine two-second Busy windows qualified. Their CPU samples vary substantially, so this small capture supports no broad CPU claim. All pairs, CPU seconds, actual sample intervals, PSS and rejected animation resources remain below and in [summary.json](summary.json). No window was replaced, no threshold relaxed, and no thirty-second promotion occurred. The earlier 75-row five-app and 21-row mapped campaigns are unchanged.

This separately registered shader follow-up holds exact core `0062bf589829c4f28807ad0fde3e13285379294c` and mapped Todo fixture `739c074f1dbd07d35d976fb64cd33a9c15030051` fixed. Only `reactivity/crates/gpu/src/renderer.rs` and `shader.rs` vary. The candidate source pins identify those two-file overlays, not replacement whole-core snapshots:

| Profile | Two-file source pin |
|---|---|
| original | `0062bf589829c4f28807ad0fde3e13285379294c` |
| certified | `7ccc65d2673a64499d805f41aaa0e423f15de2ce` |
| banked4 | `1a553e6726417309c424fa55327a7eddc88109ff` |

The same full Todo app retains editable input, add/complete/filter/delete/undo, eager row descriptions, 1,000 seeded animation rows, 32 marker-color sinks plus the animation transform, normal X11 accessibility, fonts and forced-GPU renderer policy. Domain callbacks still rebuild their owner. This is neither an Auto-policy profile nor a renderer-only row microbenchmark. Heavy mode’s eager 10,000-row implementation is preserved but was not measured in this bounded Busy/Animation protocol.

The headless twelve-logical-CPU host used Mesa 26.1.4 llvmpipe with four configured worker threads. Hardware GPU utilization and physical scanout/smoothness are unsupported. Host receipts and X11 drawable readbacks observe software/backend boundaries. The full [runtime manifest](runtime-manifest.json) records environment and tools. One-second warmup preceded each two-second Busy or six-second Animation measurement. Profile orders were original/certified/banked4, banked4/certified/original, then certified/original/banked4; mode order alternated. Builds/copies held the common shared lease; native controls and trials held its exclusive lease. All remote work is reaped and released.

Three positive controls and six native faults passed their expected outcomes. Suppressing Complete was rejected despite hover/input activity; stale markers were rejected even when final model and ordered callbacks matched. The three positive-control initial 540×620 client RGB images are byte-identical: zero changed channels and maximum channel delta zero, with independent nonblank chrome anchors. This is same-input static equality, not every-frame animation equality. Each profile’s external GPU pixel qualification was separately supplied by Root; those test counts are not included in this capture’s native-control count.

| Profile | Positive Busy | Suppressed Complete rejected | Stale marker rejected |
|---|---|---|---|
| original | True | True | True |
| certified | True | True | True |
| banked4 | True | True | True |

Every qualified Busy row completed the same eight injector events and seven button callbacks, with canonical full-model equality, exact ordered callbacks, targeted pixel/revision acknowledgments, nonblank final chrome, and normal close. Owner descriptions advanced from 1 to 8 and row descriptions from 0 to 5. CPU percent uses one core = 100%; process CPU seconds are divided by the sampled process interval, which differs slightly from the requested wall interval. PSS and RSS are sampled peaks, in KiB. The short workload has seven callbacks, not the older thirty-second macro’s 105 callbacks.

| Repeat | Profile | CPU % | CPU s | Process sample s | Measurement s | PSS KiB | RSS KiB | Receipts |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| 1 | original | 33.043 | 0.66 | 1.997407083 | 2.000149706 | 134134 | 137684 | 10 |
| 1 | certified | 32.968 | 0.66 | 2.001940983 | 2.000428389 | 134315 | 137932 | 11 |
| 1 | banked4 | 47.877 | 0.96 | 2.005118110 | 2.000358002 | 133727 | 137332 | 10 |
| 2 | original | 31.455 | 0.63 | 2.002885317 | 2.000393347 | 134176 | 137764 | 11 |
| 2 | certified | 21.988 | 0.44 | 2.001065516 | 2.000158021 | 134078 | 137652 | 11 |
| 2 | banked4 | 51.933 | 1.04 | 2.002569316 | 2.000422010 | 134036 | 137656 | 10 |
| 3 | original | 41.443 | 0.83 | 2.002746271 | 2.000178363 | 134401 | 137988 | 11 |
| 3 | certified | 40.480 | 0.81 | 2.001005803 | 2.000152423 | 134285 | 137908 | 11 |
| 3 | banked4 | 38.928 | 0.78 | 2.003679895 | 2.000149362 | 133728 | 137316 | 11 |

Candidate-minus-original differences preserve all three matched repeat numbers. Descriptive sample standard deviation uses n−1; there is no significance or population-confidence claim. In these short windows the certified paired CPU differences are −0.075/−9.466/−0.963 percentage points (median −0.963, sample SD 5.185); CPU-second differences are 0/−0.19/−0.02 (SD 0.1044 s). Paired PSS differences are +181/−98/−116 KiB (median −98, SD 166.52). Banked-four CPU differences are +14.835/+20.479/−2.515 points (median +14.835, SD 11.983); CPU-second differences +0.30/+0.41/−0.05 (SD 0.2402 s), PSS −407/−140/−673 KiB (median −407, SD 266.50). These few samples do not establish a general resource improvement. Any future timing needs longer qualified windows registered before capture.

All nine animation rows below are rejected. Each had scheduler skips, too few delivered updates for its measured lifetime, and fewer than the mandatory `floor(6*60)-2 = 358` in-window host receipts. The independent audit also checked raw/in-window subset equality, timestamps, first-present epoch, alignment, duration and overflow. Model structure, callback order, drawable changes, mapped-description gate, final chrome and normal close passed. Repeated owner/row descriptions after first present were zero, which does not imply zero scene, glyph or packet work. The phase diagnostic is inapplicable when scheduler ticks skip. The CPU and memory columns are diagnostic only and never enter qualified animation comparisons.

| Repeat | Profile | Host receipts | Lifetime delivered ticks | Lifetime skipped ticks | CPU % (diagnostic) | PSS KiB (diagnostic) | Qualified |
|---|---|---:|---:|---:|---:|---:|---|
| 1 | original | 182 | 241 | 181 | 369.333 | 142038 | False |
| 1 | certified | 224 | 279 | 144 | 364.608 | 142056 | False |
| 1 | banked4 | 188 | 239 | 183 | 369.434 | 141548 | False |
| 2 | original | 179 | 235 | 189 | 366.714 | 142176 | False |
| 2 | certified | 224 | 283 | 139 | 364.326 | 141668 | False |
| 2 | banked4 | 187 | 251 | 171 | 369.448 | 141284 | False |
| 3 | original | 182 | 230 | 193 | 370.992 | 142022 | False |
| 3 | certified | 223 | 283 | 139 | 363.935 | 142028 | False |
| 3 | banked4 | 188 | 233 | 189 | 368.661 | 141597 | False |

Ticks/skips count the app’s animation lifetime including warmup/closing; host receipts above are restricted to the actual measurement interval. They are not interchangeable denominators. The certified runs perform more delivered model work while submitting more receipts, preventing an equal-work CPU comparison. No hardware bottleneck or individual shader-stage attribution is inferred from these numbers.

The source change specializes already-certified lowered solids without changing the packet layout or retaining new fields; the four-row variant reduces live sample colors from sixteen to four while reloading records for each four-row group. Root’s separately reviewed shipping-source count is five fewer lines for certified and one additional line removed for banked-four. The built WGSL remains larger than the original, so that source count is not a machine-cost claim.

| Profile | ELF bytes | .text bytes | .rodata bytes | .eh_frame bytes | Actual WGSL bytes | Renderer::render symbol bytes |
|---|---:|---:|---:|---:|---:|---:|
| original | 24203640 | 11094304 | 5875048 | 1157340 | 15139 | 10293 |
| certified | 24203640 | 11093888 | 5875688 | 1157292 | 15438 | 10022 |
| banked4 | 24203640 | 11093888 | 5875560 | 1157292 | 15390 | 10022 |

The retained native x86-64 disassemblies show `RendererState::render` shrinking 10,293→10,022 bytes (−271); `bin_draw` remains 4,884 and renderer request/block_on remains 4,447 bytes. Render’s prologue reserves 0x4d8→0x4b8 bytes; full function interpreted CFI has maximum rsp-based CFA offset 1,328→1,296 bytes. These are linked CPU-side function facts, including saved registers/temporary outgoing stack use in the CFI value, not shader JIT stack size or a complete call-chain stack bound. Whole .text is 416 bytes smaller, .rodata 640 bytes larger for certified (512 larger for banked-four), and total ELF file sizes remain equal. Full interpreted CFI and the three largest renderer symbol disassemblies per profile are in the raw archive. No new llvmpipe shader-JIT ISA capture was made for these variants; the earlier baseline anonymous-RX profile cannot identify the changed shader’s cost.

Every linked ELF contains its preserved actual generated WGSL, independently checked after build. The original ELF byte-for-byte reproduces the earlier mapped fixture ELF. All 2,036 source files, source modes, actual two-file overlays, compiler/build receipts and runtime fingerprints matched before/after. The deliberately scoped source export is a Linux native build-input scope, not a full repository or cross-platform source snapshot. Its base archive/patch provenance and exact per-file membership are retained in the source capsule. SHA256 identities:

| Profile | Linked ELF SHA256 | Actual ui.wgsl SHA256 |
|---|---|---|
| original | `5f58bda9135bb5b88706f44112b7cbb3b1445eda9831549819d5686fd07d6538` | `ab3accf5a441b5eb03a9c7a690fdd40c13471ba6475b406183a7e86369b9605b` |
| certified | `a2634195ba98b16e99b5c5301f8048c5d3fc48a21ecac286a0877b295c98f828` | `bfc3c458b4632b081f03ceeb2b33cd5d4cef757dbb6063ae55838c01ffa1f185` |
| banked4 | `faaebe2dee5f1c33d4c84c34bdce161a155d5652938643b6c799f307d78cc801` | `77c211077c5a8731515cbdddbab8557df47d52768505a3672f6b6b9b4f0676c5` |

The first build supervisor failed closed after a successful original compile because its generated-WGSL locator assumed the old Cargo OUT_DIR layout. That failed attempt, command/log/receipt and quarantined old binary remain sealed. The separately named attempt2 discovers and crosschecks the actual rustc OUT_DIR, package-cleans gpui_gpu, checks generated WGSL freshness and embeds the exact output in a fresh ELF. Attempt2 supervisor 3187662 completed/reaped before controls; runtime supervisor 3193169 completed/reaped at 2026-10-24 09:56:51 UTC. The original failing locator is preserved as remote_build.py, with the corrected captured executable source retained as remote_build-v2.py in the source capsule; no failure is relabeled successful.

The raw archive covers every failed setup/build record, all nine controls, all eighteen trials, screenshots, process samples, clocks, independent host audits, source/binary guards, static disassembly/CFI and both postcapture analysis versions. The disjoint source capsule covers three complete frozen build scopes, actual generated WGSL, three linked ELFs, quarantines, common archive/adapter patch, overlay manifests and exact runner/orchestration sources. Both archives were reread remotely and locally for exact member sets, every member byte/hash/type/mode and archive SHA256:

| Capsule | Bytes | Payload members | SHA256 |
|---|---:|---:|---|
| raw-evidence | 6849857 | 158 | `8eb4916ea2a166a0a106e7061e14fb8cde93e555c442121a64a3d3c51e05bb79` |
| source-and-elfs | 105094551 | 6145 | `8ceb6961e5fa929473b4d749abbdaa102b41c0ee2e028c063b9b56b4a3db9803` |

The [raw archive](raw-evidence.tar.gz) is committed here. The source/ELF archive is retained at `/tmp/gpui-todo-shader-profiles-sol-build/final-artifacts/source-and-elfs.tar.gz` and remotely at `/home/miles/gpui-ce3-compute-20261024/artifacts/todo-shader-profiles-v1/source-and-elfs.tar.gz`; the [archive receipts](archive-receipts.json) carry its exact identity. Source identities are in [build-verification.json](build-verification.json), host gates and all paired statistics in [summary.json](summary.json), CPU-side machine costs in [static-cost.json](static-cost.json), and release status in [capture-status.json](capture-status.json).

Local verification reran the mandatory historical 33-row/six-failure audit and the presentation/semantic boundary tests: twenty tests passed with no skips ([log](offline-tests.log)). The readable analyzer reproduced summary.json byte-for-byte from the extracted raw archive. To reproduce after safe extraction, run `python3 ../analyze.py EXTRACTED/evidence/capture-v1 OUTPUT`, then compare `OUTPUT/summary.json` with this summary. Compile helpers with `python3 -m py_compile ../*.py`. The sealed source capsule supplies the captured runner version; no new live runs are required to inspect these results.
