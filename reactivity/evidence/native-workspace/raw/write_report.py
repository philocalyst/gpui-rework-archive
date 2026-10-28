from pathlib import Path
import json,statistics
r=Path(__file__).parent;a=json.loads((r/'analysis.json').read_text());f=json.loads((r/'frozen/artifacts.json').read_text())
lines=['''# Native workspace comparison — complete native gate fails

The qualified workspace composition passes the earlier complete local matrix,
but this new native trial **fails**. Candidate idle passes; all eight stream
observations miss cadence; scroll and mixed cadence pass but candidate/ZGX CPU-rate
ratios exceed the fixed <=0.8 limit by a wide margin. No observation is dropped,
repeated, normalized by unequal work or relabeled. There is no ZGX/framework,
physical-GPU, render-quality or scanout victory, and the candidate is not adopted.

## Sources and fixed protocol

Preregistration/native candidate **03ca419868b0d538e6847e59b60424a31aa32dfa** adds
only this experiment's protocol to 41a67473a0177fbb17df1f7b8e2f2f36dd6940f6. The
production source, application example, dependencies and shader are identical
to the qualified composition sealed at **f7b3f60c70faf6d548fffda530d4de83b2570e34**.
That independently verified 112/112 local point-gate and six-allocation-gate
result remains valid for its scope; it is not a native or ZGX result. Earlier
failed local/native experiments retain their original verdicts.

Four complete alternatives: original control20919cb160f6, static sparse c965a893364b,
workspace candidate03ca419868b0, ZGX a3678578980e. All use nightly-2026-10-23,
release opt3/fat-LTO/CGU1/debug0/no stripping/unwind/incremental false and identical
explicit Rust flags. Exact preserved reference ELFs are reused with source,
profile, test and shader receipts. The candidate uses a fresh target and clean
source guards. All three GPUI examples are byte-identical. No API, workload,
library, dependency or shader change is made in this native trial.

128 fresh eight-second processes: four modes, eight four-treatment Williams
groups per mode, seed20261107, fixed before compilation. All 128 processes exit
normally. **56 observations fail cadence**: 24 original, 24 static sparse, eight
candidate stream. The other 72 observations pass their per-process checks.
Candidate/ZGX pairs require the complete set of eight qualifying observations
before a CPU ratio is inferred. No subset estimate is supplied for stream.
All source/script/artifact guards pass, and all owned processes are reaped.
No builds, tests, source edits, analysis or cleanup overlapped timing; only short
progress reads/waits occurred. The frozen independent verifier recomputes the
result from raw samples and logs.

## Complete native observations

Whole-run admitted updates and sampled CPU use have different time boundaries.
Updates cover eight seconds; process user+system CPU is sampled from first visible
window+1s to +6s (observed endpoints, >=4.8s), including software raster workers.
One CPU core is one CPU-second per wall-second. Never divide these CPU values by
whole-run ticks to invent per-update cost. Host acknowledgements are not scanout,
and ZGX provides no presentation count in this unmodified adapter.

| Mode | Variant | Qualifying observations | Median whole-run updates | Median sampled CPU cores | Median mean RSS MB |
| --- | --- | ---: | ---: | ---: | ---: |
''']
for mode,variants in a['rows'].items():
 for n,x in variants.items():lines.append(f"| {mode} | {n} | {sum(x['qualified'])}/8 | {statistics.median(x['ticks_all']):g} | {x['cpu_cores_median']:.6f} | {x['median_mean_rss_bytes']/1e6:.3f} |\n")
lines.append('''
Candidate stream admits 450–455 updates; every observation misses the unchanged
464–488 gate. ZGX stream admits479 each time. Stream CPU remains descriptive,
not a qualifying ratio. Candidate scroll and mixed both admit479 in every run;
ZGX scroll also admits479, while one mixed reference observation admits477 and
the others479. Report this unequal pair explicitly; do not claim identical work
inside the sampled interval or exact per-update equivalence.

| Mode | Candidate/ZGX paired CPU-rate median | Paired bootstrap95% interval | Fixed limit | Result |
| --- | ---: | --- | ---: | --- |
''')
for mode in ['scroll','both']:
 x=a['comparisons'][mode]['candidate/zgx'];ci=x['bootstrap_95_type7'];lines.append(f"| {mode} | {x['median_ratio']:.9f} | [{ci[0]:.9f}, {ci[1]:.9f}] | 0.8 | FAIL |\n")
lines.append('''
Candidate idle admits zero updates and has no observed CPU increment at the OS
counter resolution in all runs, passing the <=.01-core gate. That is not proof of
zero instructions. Idle CPU ratios have zero denominators and are not fabricated.
All per-process observations, sample intervals, maximum RSS, ACKs, final model
logs, paired ratios and type-7/10000-resample intervals are in [the analysis](raw/analysis.json).
The fixed seed is reused for each complete paired estimate; no confidence-based
replacement of the preregistered point gate is made.

The combined sparse/scroll work now reaches native scroll/mixed cadence, while
older controls fail it. CPU use drops greatly in the descriptive columns, but
those older controls admit much less work and do not support an equal-work CPU
ratio. Against the cadence-qualified ZGX runs, the remaining gap is substantial.
The next diagnostic must locate candidate time among owner work, raster workers,
task delivery and presentation waits. These observations alone do not identify
cache misses, prove a scheduling cause, or justify a generic async tree runtime.

## Qualification, code costs and limits

Candidate and both GPUI controls each pass17 application tests under the matched
profile; ZGX passes its component/geometry test (52 tests total). Candidate core
qualification is inherited by exact source/build-input equality, not claimed
rerun under this profile. Twenty untimed native preflights pass: four frozen
initial-tick190 images and all four modes for every variant. The three GPUI images
are pixel-identical under exact ImageMagick AE comparison.

Same960x720 client, scale1, private X11:94, staged DejaVu Sans SHA256
7da195a74c55bef988d0d48f9508bd5d849425c1770dba5d7bfc6ce9ed848954.
The reference image has matching content, line wrapping and panel/row geometry,
but GPUI glyphs visibly appear heavier/softer. That existing quality difference
remains unresolved. No cross-renderer pixel/AA/quality equivalence is asserted.
The Vulkan loader reports only llvmpipe with four workers and no /dev/dri.
Software Vulkan CPU includes emulated raster work; hardware/two-class, scanout
and manual-input gates remain open. GPUI FIFO/latency1 and ZGX AutoVsync/default
latency2 are unchanged and documented, not declared inconsequential.

Native ELF sizes under the matched profile: original22,462,304B, static sparse
22,486,408B, candidate22,522,696B, ZGX25,152,256B. Candidate is36,288B larger than
static sparse under this profile. Shipping38,016 lines, headers and retained
capacity are inherited from the qualified composition with exact source equality;
no new shipping code exists here. Whole ELF sections, embedded canonical GPUI
WGSL/reference shader identities and effective profiles are preserved separately.
Startup/visible times are recorded but are not equal-work first-frame latency:
applications begin their workload clocks at different boundaries.

## Preserved operational failures and reproduction

The first reference-reuse check used a narrower checkout of the correct original
commit and found10,327 absent documentation/evidence paths. Its mismatch receipt
is preserved. A new full-cone immutable control worktree at the same20919 commit
then matched all14,466 recorded inputs exactly. The sparse and ZGX inputs also
match exactly. No source was altered or provenance check weakened.

The first candidate build aborted before compilation at the12GiB reserve check.
That capture and original build script remain. Completed inactive Cargo incremental
caches were hashed and reclaimed, preserving source/evidence/shaders/fingerprints
and all exact raw/compressed executable stores. The qualified retry used a fresh
capture directory; both build/test stages remained above8GiB and passed source
guards. No cache cleanup occurred during timed observations.

Run `python3 verify.py` from the dossier after packaging. The verifier is frozen
before timing and checks the complete manifest, matched profiles/tests, balanced
fixed schedule, all raw CPU/RSS intervals, native logs/ticks/ACKs, every failure,
complete paired estimates/gates, image equality, shaders and executed ELF hashes.
An independent pass is required before sealing. All changes remain local.

| Variant | Source | Executed native ELF SHA256 |
| --- | --- | --- |
''')
for n,x in f.items():lines.append(f"| {n} | {x['source']} | {x['artifact']['sha256']} |\n")
(r/'report.txt').write_text(''.join(lines));print('failed native trial report written; no adoption or ZGX advantage')
