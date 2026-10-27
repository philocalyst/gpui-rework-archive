# Precise glyph support and sparse image repair — failed full cost gate

Local, unadopted experiment. Application View/Signal/Source APIs are unchanged.
The bounded sparse repair candidate reduces complete source/owner streaming time
by about 9.3x/9.1x on this software-Vulkan endpoint. It nevertheless fails six
registered no-regression comparisons across three cases. Large streaming gains
and wide uncertainty on small cases do not override the fixed failed verdict.
No ZGX, physical-GPU, cache-hit or display-scanout victory is claimed.

Production qualification source cee7b76d00d90684e8addd8515619f28363c1a36;
measured test overlay aed951bc175d7bdf624b293a95d4c05a3401849e. The four-way
protocol and balanced order were committed at 4a1e6f24c748e9e345b8b3c51ffed7404a7d1ef5
before the common cost fixture and before timing. All alternatives contain the
same exact-image authority correction and qualified image-placement fix.

| Variant | Measured source | Immutable executable SHA256 |
|---|---|---|
| candidate | aed951bc175d7bdf624b293a95d4c05a3401849e | 42a031b65e2555336d04a696951efc276f9d1803f18cf14f04847b3121b466be |
| control | bb83c5d8f3da446d4cc1c259141f335797b1b60d | 140a754feaf0715d09d37632e9292a141eac748f6c7045056da45fcbc0d26302 |
| predecessor | f9fd1d140555c1b3e230bfa9a2dd3b2247e19adc | 4acfd1d814fa974c3ef277e2d285ae7dff8336747f644232bbb830b2a0d30825 |
| bounds | be8300c1e3eafacedfa20c062bf2e31ed1ada9ca | 44bfdf22e404210b3d27977157a3da2890c32601b67199c52400409e329079d6 |

Control is original full publication; predecessor is the previously failed local
publication mechanism; bounds adds exact changed-glyph bounding damage; candidate
adds bounded disjoint regions. Public Canvas observer/region APIs and GPU regional
rendering are additive. Complete canonical GPU packet rebuilding remains.

## Complete paired cost matrix

2688 fresh processes, 28 cases, 24 four-process groups per case. Every permutation
appears once per case; group shuffle seed20261030. Each process has16 warmup and64
measured updates (172032 measured updates total), plus separate mount/first image.
All timing processes pass independent full-GPU pixels, exact final hashes/epochs,
full-copy/image counters and clean all-input guards. No owned builds, other tests,
allocation probes, source edits or cleanup overlapped timing. The timing driver
journals one result per process rather than rewriting the cumulative result set;
its earlier qualification/allocation version and change receipt are preserved.

The estimator is the median of24 paired process-p50 ratios. Type7 p95/p99,
10000-resample paired bootstrap95% intervals (seed20261030), first update and cold
results are retained. Ratio of unpaired medians is reported separately and never
substitutes for this estimator. Confidence intervals are not used to waive point
gates. Required candidate/control <=0.8 in both streaming cases and <=1.05 in all
other cases; candidate/predecessor and candidate/bounds <=1.05 in every case.

| Case | /Control | /Predecessor | /Bounds | All point gates |
|---|---:|---:|---:|---|
| scroll | 0.993840228 | 1.001603660 | 1.003547637 | pass |
| both | 1.005195027 | 0.993852062 | 1.007863203 | pass |
| stream | 0.107037387 | 0.106068002 | 0.107116759 | pass |
| stream-owner | 0.109522705 | 0.106383454 | 0.112452792 | pass |
| fractional | 1.005029862 | 1.001015926 | 0.995804885 | pass |
| flat-tiny | 1.073339175 | 1.056318804 | 1.117021753 | **FAIL** |
| flat-full | 1.058354510 | 1.048029083 | 1.069131172 | **FAIL** |
| list-tiny | 1.013092478 | 1.008993807 | 1.002727077 | pass |
| list-flat | 1.002281000 | 0.982027599 | 0.994082632 | pass |
| exposure | 1.007520669 | 0.993863400 | 0.973655039 | pass |
| text-0-1-source | 1.002017673 | 1.007633020 | 1.000092942 | pass |
| text-0-1-owner | 0.975943709 | 0.987930820 | 0.982362910 | pass |
| text-0-2-source | 0.986221472 | 1.027035594 | 1.008950030 | pass |
| text-0-2-owner | 1.000137076 | 0.958791813 | 0.990649317 | pass |
| text-0-4-source | 0.996322033 | 1.017390561 | 1.031283906 | pass |
| text-0-4-owner | 0.988943932 | 0.975020049 | 0.952123238 | pass |
| text-25-1-source | 0.968936751 | 0.970709762 | 0.970206451 | pass |
| text-25-1-owner | 1.020985670 | 1.004205686 | 1.048800055 | pass |
| text-25-2-source | 1.030984758 | 1.047170491 | 0.979476197 | pass |
| text-25-2-owner | 1.026108473 | 0.999838888 | 1.041987308 | pass |
| text-25-4-source | 1.017283123 | 1.037427114 | 1.058992056 | **FAIL** |
| text-25-4-owner | 1.011288281 | 1.025464436 | 1.008290935 | pass |
| text-1000-1-source | 0.969685026 | 0.987094980 | 0.975182556 | pass |
| text-1000-1-owner | 0.746627144 | 0.996758182 | 1.006775188 | pass |
| text-1000-2-source | 0.998382257 | 1.018630907 | 0.983286965 | pass |
| text-1000-2-owner | 1.006039668 | 1.001378664 | 1.035971259 | pass |
| text-1000-4-source | 1.002054048 | 1.010066222 | 1.009899197 | pass |
| text-1000-4-owner | 0.980557568 | 0.989915708 | 0.983544373 | pass |

Failed comparisons and their95% paired intervals:

- flat-tiny/control: 1.073339175, [0.976573319, 1.178911205].
- flat-tiny/predecessor: 1.056318804, [0.972212420, 1.167447178].
- flat-tiny/bounds: 1.117021753, [0.908966129, 1.213951373].
- flat-full/control: 1.058354510, [1.007979548, 1.135310113].
- flat-full/bounds: 1.069131172, [1.003260115, 1.154066121].
- text-25-4-source/bounds: 1.058992056, [1.014266970, 1.091548294].

Source-stream/control is0.107037387, interval[0.105273399,0.112999304]; owner-stream/
control is0.109522705, interval[0.106187406,0.119072611]. The broad tiny-flat intervals
leave the size and cause of a slowdown uncertain; they do not reverse rejection.
Raw process p50/p95/p99 and every frame remain in raw/candidate/matrix-analysis
and matrix-timing. No successful subset is adopted.

The endpoint includes public model operations/string generation, owner/scene work,
native GPU preparation/submission, explicit GPU completion and ACK. It excludes
OS dispatch, producer transport, active NativeHost accessibility-provider projection,
WSI, scanout and device startup. Software Vulkan is llvmpipe, LP_NUM_THREADS=4,
private X11 :94, the pinned nightly locked/offline release profile. Native interaction
and accessibility are separately tested, not timed by this bridge harness.

## Authority, correctness and rejected attempts

Stage A diagnoses why local publication alone did not speed streaming: old damage
covered the run bounds. Median exact changed glyph union was2891 pixels versus
99495 bounding pixels; bounded merged regions used16 rectangles/2905 pixels.
Final native qualification observes2960 versus99630 pixels in its four post-warmup
updates. These are conservative work counters, not a claim of measured cache hits.
Canvas retains exact common state/resource admission, reference budgets, mask
remapping and last-use retirement. Observers run only after fallible validation;
observer panic leaves Canvas unchanged. The region set merges touching bounds,
keeps one region inline, and collapses to bounding damage after64 disjoint regions.
GPU repair draws the complete canonical packet under separated scissors, then
copies the complete backing image. No shader, dependency or unsafe-code change.

A real native adversary exposed an inherited bug in candidate and original
control: another presenter can ACK an unbound scroll without changing source
epoch. Subsequent damage was accepted against an older GPU image. AUTHORITY.md
registered the correction before implementation: reuse requires exact acknowledged
window/sequence identity. Existing acknowledged sequence becomes available to all
native configurations; obsolete scene-epoch/native packet-epoch fields are removed.
Every timing variant contains this prerequisite. Before/after original-control
pixel failures and corrected success are preserved, so speed is never compared
against a known incorrect image-authority control.

Production candidate qualification:1001 default GPUI/Canvas tests (13 ignored),
1086 X11 (45 ignored),74 GPU,319 minimal-native library tests (25 ignored), strict
all-target Clippy,10 workload-port tests,11 actual native scripts and4 minimal
scripts pass. The GPU oracle exercises all three formats, translucent overlap,
empty changes, resizing and failure recovery. Original corrected control passes
1075 X11 tests,10 port and11 native scripts. Fresh corrected predecessor/bounds
pass1083/1085 X11 tests,10 port tests each, strict Clippy and11 native scripts each
using their exact cost binaries. The minimal qualification is the library scope,
not a claim to have executed every minimal-feature integration test.

All four cost fixture and GPU header/Clippy gates pass. Before timing,336 fresh
correctness and112 separate allocation processes pass all28 cases. The added
small controls cover0/25/1000 unrelated labels ×1/2/4 fields ×source/owner paths.
They include final model checks, CPU pixels against a fresh owner and full GPU
pixels. They do not reuse the old pre-shaped GPU diagnostic as a whole-frame claim.
Generated WGSL matches typed source and is verified byte-for-byte inside every
measured native ELF; no offline SPIR-V feature is selected.

Preserved failed attempts include initial region fixtures that assumed author
bounds equaled conservative raster support; the real stale-image failure; a later
fixture that used a poisoning NaN width instead of the established recoverable
NaN-radius error; and a strict-lint failure in the new test fixture corrected
identically in all variants. Production predicates and pixel oracles were not
weakened to pass these fixtures. The omit-region mutant fails actual GPU pixels.
A broad ignored-base mutant first fails an existing counter witness; it is not
claimed as the pixel mutant. A narrower same-window/ignored-sequence mutant reaches
and fails the new full-GPU pixel witness. All attempts and source guards remain.

## Charged storage, allocation and code

Runtime<()>1824, Prepared40, TextResources168, RetainedRenderer920, Renderer888,
Backing112, Output40 and GpuSurface1040 bytes agree across the four variants.
TextPatch grows40→96 and SceneDamage24→32 only in the candidate. Native repair
capacity is at most64 eight-byte rectangles (512 heap bytes when allocated).
There is no per-canvas tile bitset or additional retained GPU texture. The common
authority prerequisite is shared by all variants; minimal-native availability of
the acknowledged sequence is part of that prerequisite, not a free hidden field.

At960×720, all alternatives retain2764800 explicit backing-image bytes and copy
691200 pixels per update. Invoking-thread warm allocation observations:
source stream control245 requests/188319 bytes, predecessor/bounds216/123995,
candidate221/131315. Owner stream405/284248,376/219924,381/227244 respectively.
Peak source-stream requested bytes74381→43597 (predecessor/bounds43541); warm net
bytes304 agree. Single small text adds56 requested bytes and no request; the
four-field owner fallback's allocation record is unchanged. These are caller-thread
allocation measurements, not total driver/process memory; all cells, cold setup,
first update and individual samples are retained.

Shipping first-party lines: control36956, predecessor37107, bounds37149,
candidate37361 (+405 original, +254 predecessor, +212 bounds). Whole native example
ELFs:26306384,26309536,26310776,26306728 bytes respectively. Total ELF size is not a
substitute for function or stack accounting. Candidate ordinary submit695 bytes /
1344 explicit local stack bytes versus control636/1344; outlined regional submit
adds592/1320. Candidate render wrapper56/16 and render_repair2231/680 versus control
render2117/664. try_sparse_text2508/440 versus control2141/360; present_walk25795/
(4096+216) versus25792/(4096+200). Full four-way symbols and assembly are preserved.
These prologue reservations exclude pushes, callees and driver stacks.

The next isolated hypothesis is to restore the unchanged ordinary Output/render/
submit route and place regional preparation/dispatch behind a separate entry path.
The current shared repair enum changes the ordinary submission and render bodies;
that is a concrete code-generation difference to test, not a proven cause of these
losses. Keep this full failed verdict and compare any follow-up against it, the
corrected original control and bounding-only mechanism. No source change is part
of this dossier's recorded timing result. The campaign goal remains open.

Run `python3 reactivity/evidence/glyph-damage/verify.py` to check source/evidence
hashes, raw process records, fixed failed gates and preserved executable identities.
