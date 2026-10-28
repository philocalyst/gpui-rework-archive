# Compose exact scroll copies and sparse outside repair

Preregistered before implementation or timing. Base is the failed static sparse
variant with qualified deferred controls,c965a893364b46f965c83d10e2cf94a46dac1304.
Instanced region batching is rejected and sealed atb165ec9b62a8cf308c0b693f8a92fe819c30a5e4:
~7–8% slower streaming and ~100ms first use. Do not carry its vertex program,
explicit context layout, pipeline or instance buffer into this experiment.
The old scroll-output trial6bdfad2b75541bfb0cbac2882329c3e31e885bde already accelerated
scroll and mixed work but failed tiny-list versus its predecessor. Preserve both
its useful signal and failed verdict. Its code predates later image-authority and
image-position corrections; do not overlay entire old production files.

## Hypothesis and implementation scope

The old exact translated-contribution proof can copy unchanged list pixels. Its
`subtract(damage_bounding_box, copied_destination)` then repaints large gaps between
an unrelated changed header glyph and that copied list. Preserve both independent
facts: a proved translated overlap and unchanged paint outside it. Compare complete
staged old/new scene contributions outside the copied destination, collect the
old AND new support of changes, and subtract the copied destination from repairs.
No callback purity assumption, discarded view execution, source-epoch image identity
or guessed changed-source shortcut. This applies BBTree's preservation of unaffected
facts and Solid/Ripple's precise publication boundaries to the measured raster work;
no async memory/cache-hit claim or new task semantics follows.

Port only the existing conservative scroll proposal/contribution proof onto the
corrected base. Preserve dimension/profile/clear equality, integer translation,
ordered material/clip checks, exact source/destination bounds and full fallback for
unsupported content. Keep exact PresentationToken from/to authority and GPU's sole
packet token; never reintroduce the old redundant SceneEpoch image authority.
Geometry/broad-phase hints propose work; Canvas proves it. `list_mode` means that
viewports exist and is not itself a mixed-update prohibition.

Add a separate private ScrollOutput implementing the existing static Submission
boundary. Ordinary Output, ordinary render/submit and fragment/vertex WGSL stay
unchanged. Copy old backing to bounded scratch, scratch to translated destination,
then canonical complete-scene scissor repairs, then full presentation copy in one
submission. No region-instanced pipeline or shader specialization. Store scratch
lazily behind a private box on existing Backing, rather than the old inline Texture
header. Keep Runtime/node headers unchanged; charge metadata pointers, ephemeral
SceneDamage growth, cold scratch handle/image, duplicated preparation code and all
copy traffic. No Rc/Cell/RefCell ownership, new dependency or unsafe production code.

Precise repair is used only after the translated overlap proof succeeds. Filter
old/new command streams by conservative support outside that destination. Exact
unchanged geometry/color/clip/material may be skipped; every unmatched command's
old/new conservative support is retained. Positional comparison is sufficient for
correctness; length changes must retain unmatched old and new tails. Immutable glyph
identity may be recognized by existing key/dimensions plus coverage identity or
exact bytes, never by a key alone. Reuse the canonical unchanged-command proof for
other materials. Any uncertainty overstates repair or declines copying.

Use existing bounded DamageRegions (64, overflow to conservative bounds), then
subtract the copy rectangle when iterating repairs. At most256 scissor rectangles
can result, without another unbounded queue. Overlaps may conservatively execute
more than once; canonical fragments overwrite full pixels, never blend with the
retained framebuffer. Count all submitted repair/copy pixels. Keep the complete
scene packet and resource leases. A box/array/Vec size is not total driver memory.

First establish a conservative bounding-repair scroll composition through this
same static path. Freeze it as the copy-bounds ablation before adding precise
outside repair. It must share all production paths except that repair derivation,
and the same application/benchmark/compiler inputs. No performance sampling before
all correctness, counter and source/artifact gates for the complete comparison.

## Required correctness and accounting

Public Canvas/GPU/native exact-pixel oracles: positive/negative integer translation,
source/destination edges, fractional/unsupported fallback, transparent overlap,
paint order, glyph resource identity, differing glyph counts, inserts/removals,
outside images/gradients/clips, changed clear/profile/dimensions, resize/failure,
missing/wrong predecessor, pending newer candidate and old eligible ACK. Keep all
existing image-position, text repair and native accessibility/task tests. Exercise
copy plus unrelated outside edits, including edits above/below/beside/straddling
the copied area and bounded overflow. The ordinary full GPU renderer remains the
independent final-image oracle in all supported formats. No precision/tolerance
relaxation. Software Vulkan is explicit.

Fresh isolated mutants must fail pixels when an outside repair is omitted and
when exact predecessor authority is bypassed. Port/adapt the old contribution and
Load/Clear witnesses where applicable. Verify actual shader bytes and immutable
executed binaries, pinned nightly2026-10-23/locked offline source guards; clean GPU
after overlays. Full composed/default/minimal/native/port/strict Clippy gates are
required where production changed. Inherit only demonstrably unchanged gates.

Before timing, every scroll/both/list-flat/list-tiny operation must admit its
intended copy, with exact work counters and final model/epoch/pixel equality.
The same 28 benchmark fixtures remain unchanged. Original/glyph-bounds/static
sparse copy only the target and retain width*height*4 bytes. Copy variants additionally
count both overlap copies and retained scratch. For fixed integral workloads the
expected overlap is920*(400-14)=355120 pixels (list-tiny16*(16-1)=240):
960x720 copy total1401440 pixels, image4185280B; tiny total1504 pixels, image5056B.
Fractional and other ordinary cases retain their existing full-copy/image counters.
A failed admission/counter gate stops timing; do not silently accept omitted work.
Cold object creation, first operation and allocator/driver limits stay explicit.

## Fixed complete cost comparison

Five whole alternatives: corrected original, glyph-bounds, static sparse,
copy-bounds and precise-copy candidate. The first three immutable current-app
executables from region-batch may be reused as artifacts after exact source,
fixture, profile and ELF guards; no compiled cache sharing. Both new variants have
unique worktrees/targets. If fixtures must change, rebuild every affected control.

Use the same28 cases,16 warmups/64 measured updates. Twenty balanced groups per
case: two cycles of a five-treatment Williams design (base0,1,4,2,3, all five
cyclic label rotations and their reversals). Every variant occupies every position
four times; every ordered adjacent pair occurs four times; each unordered pair
has ten observations in each relative order. Rotate sequence order by case and
shuffle whole groups with seed20261104; freeze all2800 process jobs before timing.
The five-way balanced design supplies a causal copy-bounds control without dropping
the older glyph-bounds control. No pair/case/variant is selected after observations.

Three correctness processes and one allocator process per variant/case, each
16 warmups/4 updates (420 and140), precede timing. Primary estimator: median of20
paired process-p50 ratios, type7 quantiles and10000 paired bootstrap draws with
seed20261104. All raw/warm/cold/tail observations remain separate.

Fixed thresholds for candidate ratios:
- scroll and both <=0.8 versus original, glyph-bounds AND static sparse;
- both <=0.8 versus copy-bounds; scroll <=1.05 versus copy-bounds;
- stream and stream-owner <=0.8 versus original/glyph-bounds, <=1.05 versus
  static sparse/copy-bounds (their inherited stream improvement must remain);
- all other cases <=1.05 versus every control, including tiny-list and exposure.

Any failed fixed comparison rejects the complete candidate. No threshold tuning,
selective reruns, numerical shortcuts or adoption of successful cells. Only a full
passing cost gate permits a matched-profile native comparison against unchanged
GPUI controls and ZGX with58–61Hz admitted-work gates. Manual input/render-quality,
actual presentation and two physical hardware classes remain open requirements for
the overall user goal. Use private X11:94/llvmpipe LP_NUM_THREADS=4, keep8GiB free,
and run no builds/tests/analysis/cleanup/source edits during fixed timing. All work
stays local; seal failures and independently verify the dossier before moving on.
