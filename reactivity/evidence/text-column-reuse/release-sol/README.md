# Public release CPU and codegen control: qualification failed

This is an evidence-only follow-up to `../first-sol`. The candidate remains unmerged. The single preregistered capture reached its hard 300-second cap after 219 of 224 observations and 109 of 112 complete pairs. Independently, the complete true origin-only `Win.update` cell failed the registered no-regression gate: median paired candidate/baseline 1.040914730 (+4.091473%, seven pairs), against the fixed maximum 1.03. There is no successful qualification, performance improvement claim, retry, resampling, threshold change, or adjusted work count.

The capture started at 2026-10-23T06:17:57.038131+00:00 after root's explicit quiet GO and a clean source/profile/binary/process guard. Root and other agents had stopped all builds and CPU campaigns. The normal binaries ran on CPU 0. Capture stopped while running pair 6's typed padding-layout candidate with 0.582564 seconds remaining. That observation produced no completed result; the preceding unpaired baseline result is retained. Both contraction pair 6 cells were never started. `capture-runner.log` preserves the timeout, `capture.json` preserves every completed observation and pair, and `post-capture-guards.json` confirms unchanged frozen inputs. No sample was rerun.

## Complete and incomplete cells

Values are medians of the registered paired candidate/baseline time ratios, not ratios of separate medians. Seven paired rounds were required for every cell. The three incomplete rows are descriptive partial observations and cannot pass qualification. Even completing those rows could not erase the independent complete origin-only failure. Aggregate results cannot excuse any failed cell.

| Workload | Update ratio / pairs / gate | Typed ratio / pairs / gate |
| --- | --- | --- |
| tiny1 | 0.987852 / 7 / pass | 0.982195 / 7 / pass |
| small32 | 0.989226 / 7 / pass | 0.985564 / 7 / pass |
| transform32k | 1.015510 / 7 / pass | 0.997746 / 7 / pass |
| pending32k, C1→C2→ACK | 0.958820 / 7 / pass | 0.991611 / 7 / pass |
| one-map32k | 0.994062 / 7 / pass | 1.000379 / 7 / pass |
| all-map32k | 0.987238 / 7 / pass | 0.980757 / 7 / pass |
| origin32k | **1.040915 / 7 / fail** | padding-layout32k: 0.983909 / 6 / incomplete |
| contract32k | 0.985962 / 6 / incomplete | 0.987549 / 6 / incomplete |

The true origin-only update preserved all 32,768 public layout pointers in preflight by coupling padding with outer width to hold content width constant. The typed case at the same CLI case key is explicitly a different, registered padding-layout workload: genuine `Source.direct` padding with fixed outer width, changing all layout pointers. It must not be called origin-only. Typed contraction uses `Source.field` structural fallback; it is not a direct port. All other typed cells use genuine direct transform/text bindings, with no View snapshot of those sources and zero owner descriptions/reruns. Exact seven ratios for the failed origin cell are 1.0365524214, 1.0409147301, 1.0460605864, 1.0141606845, 1.0381950513, 1.0542988921, 1.0425206443.

## Fixed work and controls

`registration.json` was frozen before release builds. It specifies eight cases and two lanes, seven paired AB/BA rounds, one checked untimed warmup, actual toggled changes on every cycle, ACK after each cycle, and C1→C2→ACK in the pending case. Per sample the exact cycle counts were tiny1 20,000; small32 1,000; transform/pending/one-map/origin32k 4; all-map/contraction32k 2. Each observation used a fresh process; mounting, validation, printing and dropping owners were outside the measured interval. There was no calibration, adaptive count, outlier removal, or retry.

The physical source path `/tmp/gpui-text-column-release-sol`, external fixture path `/tmp/gpui-text-column-public-control`, manifest, lockfile and all source declarations were identical across baseline/candidate. Baseline is `a50b3b85121be0a5741b4733db977173c01806d2`; candidate is test-only `a7604140e643a1ef87d6a706c2125c4a7066ca64`, with both shipping files verified byte-identical to `bd09cb1a971f0fb37e310b882a3a45c2eff5ef42`. The fixture was committed as `a6d254e` before builds and is copied under `fixture/`. Normal binaries contain no counting allocator or allocation-counter dependency; symbol checks and the locked dependency tree are preserved.

Normal release profile: opt-level 3, LTO false, one codegen unit, debug 0, strip none, `gpui default-features=false`; no native/GPU/AT expansion. Builds ran from the fixed source root with generic flag variables unset, jobs 1, and tracked root flags `-C symbol-mangling-version=v0 --cfg tokio_unstable`. Codegen alone appended `-Zemit-stack-sizes` with `RUSTC_BOOTSTRAP=1`; exact merged fingerprint flags were checked. Exclusive targets were `/tmp/gpui-text-column-cpu-target` and `/tmp/gpui-text-column-codegen-target`. GPUI and external consumer were cleaned between variants; both reported `fresh:false` at opt3. Complete tracked source SHA maps, manifests, toolchain, commands, compiler artifacts and fingerprints are in `build-metadata.json`.

All 32 ordinary preflight logs were byte-identical between baseline and candidate. They check public ordered part/text/geometry hashes, canonical scene/draw/mask hashes, epochs, old P while C1/C2 are pending, stale C1 rejection and public layout identity behavior after ACK. Every completed timed observation matched its frozen final public checksum, text/part counts, source/presentation epochs, ACK state, exact cycles and updates; direct lanes had zero descriptions. The real public input/query/prepare caller's baseline/candidate normal and codegen oracles also matched. These guards do not convert a failed or incomplete CPU gate into a pass.

## Real linked code and frame cost

`codegen-review.md` is the original pre-capture code/frame review; its last sentence records that no timing had run **at that review point**. The full linked summaries, symbol extraction scripts and compressed selected assembly are retained. Public P hit/query/prepare wrappers had identical reported sizes and fixed frames across variants. Both actual `Runtime::present_inner` monomorphs changed 21,547→21,452 code bytes and fixed frames 3,624→3,560 bytes. The new helper is genuinely out of line: **731 code bytes and 120 fixed stack bytes**, with two real admitted-row loop callsites proved by GOT relocation in `helper-call-proof.json`. The helper's call/prologue, branches, P-entry reads and fallback clones are real costs. A smaller caller frame does not cancel the separate callee cost or prove reduced total stack.

Whole codegen `.text` increased by 752 bytes, `.rodata` by 128, `.eh_frame` by 224 and `.data.rel.ro` by 168. Normal file size increased 2,048 bytes; the instrumented codegen file increased 2,080. Fixed stack metadata is neither dynamic/cumulative stack nor an allocation measurement. Equal function sizes and frames do not prove identical relocated instructions or equal runtime cost. No inline attributes or caller-specific shipping source were introduced.

Frozen binaries remain outside git at `/tmp/gpui-text-column-cpu-evidence/`; their SHA-256 guards are:

| Binary | SHA-256 |
| --- | --- |
| normal-baseline | c9c8b4c4bffbfa794dfe36026d0f819038b6483b620de5419e18d0b89c057a67 |
| normal-candidate | e7f81f27aba1d4fe0fea88cade401d9d17e4d43bee67b3cfe1b271e75e813246 |
| codegen-baseline | 1d747d09e327a2457bafa642deaa7960994a883895f3f14931b0f57ab1279061 |
| codegen-candidate | 137ca20aefec5803678dda5a7136ae677cb0df05f32fd7b6ed641397496da32a |

## Archive and verification

`raw-observations.tar.gz` contains all 438 raw stdout/stderr files for 219 completed observations. `capture.json` contains all 219 parsed results, 109 complete pair ratios and the timeout; `partial-summary.json` reports completeness and the full-cell gate independently. The timed-out child had no completed stdout result. `original-files.json` records SHA-256 and length of all 505 original nonbinary evidence files, including the unpacked raw streams and selected assembly. The two `*-selected.asm.gz` files expand to the recorded original assembly. All other nonbinary originals are copied verbatim here. `guard-only.json` is the historical pre-GO readiness check that still listed other builds; capture was not authorized at that point. The actual capture's process guards passed before starting and between completed pairs; final post-capture guards also passed.

`verify_archive.py` independently verifies the original-file hashes, all raw/result/pair correspondences, frozen fixture hashes, partial summaries and the failed complete cell; its result is `archive-verification.json`. `SHA256.json` seals this reviewable archive including the frozen fixture. The scripts intentionally retain the original physical build paths. They are evidence and reproduction instructions, not authorization to run another campaign. Root must separately authorize any future capture; this campaign remains incomplete and the registered origin-only cell remains failed.
