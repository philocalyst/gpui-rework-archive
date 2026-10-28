# Bind live scene prefixes

Shipping source `7248895bce3433fefad44d6e3272bba998621875` changes one private
buffer-binding helper and four binding sites. Buffer capacities, owner fields,
uploads and bind-group creation count remain unchanged. WORDS uses its live
record prefix only when there are no packed images; image payloads retain the
whole binding because they follow a separately reserved record prefix.
Runtime-sized storage arrays retain one admissible element when empty.

The matched control uses the same physical source paths, compiler, configuration,
lock and fixture. Only renderer source differs between baseline and candidate;
both builds temporarily log immediately before actual Core initialization
`clear_buffer` dispatch. Guard maps prove that exact instrumentation difference,
and all 1,978 tracked inputs are restored afterward. The probe does not replace
HAL behavior. Actual Cargo fingerprints and frozen executable hashes are retained.

Across empty → growing → shrinking scenes, Core scene initialization falls from
eight clears/1,360 bytes to two clears/20 bytes: **six tail clears and 1,340 bytes
of clear work disappear**. The 16-byte empty WORDS and 4-byte empty INDICES clears
remain. Readback clears match exactly. This measures command ranges, not GPU
allocation savings, hardware timings, VRAM or process RSS. Existing capacity is
still allocated. Unused image padding and the glyph atlas/Core zero source are
outside this change.

Both instrumented variants pass 61 distinct cases: 47 Vulkan renderer cases,
10 GPU unit cases and 4 presentation cases. The growth control additionally
verifies complete retained-packet replay. After restoring all instrumentation,
the shipping candidate passes 62 cases including its doctest, strict all-target
Clippy and scoped formatting. Independent Sol review checks every private address
domain, empty arrays, bank/paint writes and image cache/reorder lifetime.

Apple Metal and Windows MSVC/DX12 library checks pass with root configuration
flags intact, using `RUSTC_BOOTSTRAP=1` and `-Zbuild-std=std,panic_abort` to build
the target standard libraries. These are compilation checks, without foreign
linking or runtime. The initial aarch64-Apple attempt failed for missing installed
`std`; that failure remains archived and is not reported as ARM qualification.

The six libraries measure **30,692** code lines, +11 from source a50. Tests,
comments, blanks, apps, vendors and evidence are excluded; build source remains
charged. There is no retained header, dependency, unsafe or public API addition.
The source commit message undercounts presentation cases as two; the actual
archived logs and totals above correctly record four.

`qualification.tar.gz` includes the exact source patch, observer bytes, both build
guards and artifacts, raw controls, restored shipping test log, strict/cross
results, failed installed-std attempt, independent review, research audit and
counter output. All 86 manifest members were verified after compression.
`summary.json` records every clear range and the archive digest. Large executable
files remain at their recorded `/tmp` paths rather than being copied into Git.

Main integration independently checks all 122 core source/test module bytes
against the producer before building, then passes the same 62 GPU tests/docs
at the main physical path. All 1,978 producer input files match after the run.
`main-integration.json` and `main-tests.log.gz` retain that check separately from
the frozen producer archive and the earlier full GPUI/native campaign.
