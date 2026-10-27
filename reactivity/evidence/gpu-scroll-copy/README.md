# Certified integer viewport scroll copy: failed performance gate

Local experiment; not adopted. Production source49514e3cb6, final test/cost overlay
8eebb25bd8. Baseline4afe067fe3e243fac40369301321f44962aa808d; identical cost overlay
6269bdfafc. Registered architecture protocol52aff0e85903, concrete cost protocol
and300-process order df6b1bf132. All changes stay local; the original checkout is
untouched. No ZGX or physical-GPU performance claim.

## Verdict

Complete public model update + scene publication + native packet bridge + GPU
completion + ACK is12.1x faster for scroll and2.26x faster for mixed updates on this
software-Vulkan trace. Nevertheless the8x8 flat control has a1.071750023 paired
median ratio, exceeding the preregistered1.05 ceiling. Preserve that failure;
do not round it away or select the large wins as an acceptance verdict.
The tiny-control95% interval is wide[1.008743,1.256080]; this uncertainty neither
establishes a precise causal slowdown nor reverses the failed point gate.

All300 timing processes passed full-render final pixels, matching cross-variant
hashes/source epochs and expected per-frame work counters.60 separate qualification
processes and20 separate allocation processes passed. Timing overlapped no builds,
tests, allocation probes or cleanup.15 randomized process pairs/case,16 warmups
and64 measured updates/process;24,000 total timed-process updates including warmup.
Primary estimator is the median of15 paired process-median ratios. Intervals are
paired bootstrap10000 resamples, seed20261027. Per-process samples, p50/p95/p99,
construction/first-frame/first-update and allocation records are preserved.

| Case | Baseline p50 µs | Candidate p50 µs | Paired ratio |95% interval| Gate |
|---|---:|---:|---:|---|---|
|scroll|34278.507|2800.276|0.082524407|[0.081335,0.089343]|pass|
|both|57010.592|25203.031|0.443327737|[0.441169,0.447754]|pass|
|stream|21770.247|21787.680|1.002994204|[0.992353,1.006739]|pass|
|stream-owner|21863.493|22007.459|1.006468872|[0.994646,1.012003]|pass|
|fractional|35707.060|35531.274|0.996308574|[0.992634,1.001984]|pass|
|flat-tiny|89.479|95.114|1.071750023|[1.008743,1.256080]|**FAIL**|
|flat-full|868.056|843.316|0.987516274|[0.954727,1.018862]|pass|
|list-tiny|293.307|152.762|0.502825873|[0.450482,0.539111]|pass|
|list-flat|19512.926|1931.563|0.098486116|[0.096000,0.105805]|pass|
|exposure|803.336|793.255|0.984224630|[0.964037,1.004195]|pass|

Table latency columns are medians of the process medians; the paired-ratio
estimator is deliberately distinct from their quotient. Cold state means a fresh
owner and retained image on an already-created, surface-compatible device; it does
not mean a cold OS file cache or cold device initialization. Exposure is explicit
redraw, not an idle UI. The actual native idle port's zero ticks/one initial ACK
remains a separate earlier correctness gate. Device/OS initialization, native event
dispatch, producer scheduling, swapchain presentation and scanout are outside this
micro gate. Direct registered-source stream input has the same content operation;
it does not include the native inbox callback transport. All allocation measures
are invoking-thread observations; driver threads and physical GPU allocations are
not exhaustively attributed.

## Mechanism and authority

Canvas staging compares ordered old/new pixel contributions over the overlap of
one integral vertical scroll. Rectangular integer clips, identity linear maps,
bounded integral translations, solid coverage and immutable glyph masks form the
initial exact domain. Changed content/order/clear/resource identity and unsupported
maps/materials/clips fall back to existing complete damage. No epsilon or render
quality change. Old and new glyph sample coordinates must remain identical in both
CPU-f64 and GPU-f32 arithmetic.

Runtime proposes exact author geometry, not interval-expanded hit-test bounds.
Admission requires an acknowledged predecessor with no coalesced pending candidate.
The native bridge binds reuse to exact from/to presentation tokens; source epoch
alone is insufficient for unbound scrolling. Canonical commands/input/a11y still
publish completely. Ordinary application calls need no changes.

The GPU copies overlap into a separate lazy scratch texture and then back into the
destination, repairs at most four disjoint rectangles, and presents the complete
backing. It never assumes swapchain preservation or issues an overlapping same-texture
copy. Resize/failure/invalidation force complete repair. Shader/dependencies unchanged.
See raw/prior-art.md for historical DXGI scroll reuse and the distinct BBTree/Solid
transfer; this is not claimed as a novel scroll primitive or async cache-hit result.

## Correctness and failures preserved

- Full production composition:995 default GPUI/Canvas tests,1070 X11 GPUI/Canvas
  tests,10 native workload-port tests,74 GPU tests and strict all-target Clippy.
  Full suites used2123124d66/954f7c50d9; later8eebb25bd8 changes are test-only,
  with strict Clippy, full GPU rerun and actual native workload oracle rerun.
-11 actual native scripts pass, including Todo, default/overscan/controlled Library,
  AT-SPI and IME. The added native workload oracle uses the actual100K-row model and
  unchanged Driver.owner operation in both scroll and mixed modes. Complete pixels
  equal independent full GPU rendering; existing CPU conversion limits are unchanged.
-6 public Canvas proof tests cover repeated both-direction/end/large deltas, labels,
  alpha, stationary overlap, wrong proposals, changed color/order/font identity,
  fractional geometry, transforms, images, rounded clips/materials and gradient reuse.
  GPU oracle covers repeated copies, invalid preparation, redraw, resize and all
  supported formats:RGBA/BGRA sRGB andRGBA16Float.
- Removing contribution equivalence (eb0efec660) fails complete pixels after a changed
  row. Restoring that proof but removing predecessor-token equality(674960d414) fails
  the actual native full-GPU pixel oracle on an unbound stale image. Both immutable
  failing executables and input guards remain available.
- First gradient proof tried a prepared-scene view before staged gradient lease
  transfer; the regression failed, then direct borrowed-command inspection fixed it.
- First GPU fixture requested unsupportedRGBA8Unorm; the renderer correctly rejected
  it. The corrected fixture uses only supported targets; no admission weakening.
- First native proposal used conservative60.000008x48.000008 bounds and rejected the
  otherwise valid60x48 scroll. Diagnostics preserved; exact author geometry fixed it.
- First cost harness compiled but strict Clippy rejected duplicate modules/helpers
  after a test module. Corrected before performance execution; no lint suppression.

## Complete cost bill

Shipping first-party non-test code36962→37434(+472), no vendor/dependency/shader
change. Build-only native example26306600→26329184 bytes(+22584); both immutable
ELFs and fingerprints are preserved. Main presentation function25808→26776 bytes,
local stack allocation4096+216→4096+248. Retained render2117→2235 bytes, local
stack664→792. GPU submission636→1176 bytes, local stack1344 unchanged. Proof
certify1506 bytes/local376; scratch preparation723/local168. See exact symbol and
assembly receipts; prologue stack bytes are not a whole-call-stack bound.

Header measurements: Metadata264→272(native only); SceneDamage40→48; GPU Output40→48;
GPU slot guard80→88; Backing112→192. RetainedRenderer920, Renderer888, Canvas464,
Runtime1824, Node24, Presented64, El184 and Draft160 remain unchanged. ScrollCopy48
and the lazily allocated/reused token transition80 bytes. The retained backing's
larger header is charged even when no copy is admitted.

At960x720, the explicit GPU image bill grows2764800→4185280 bytes on an admitted
920x386 overlap(+1420480 scratch bytes). Each such frame copies1401440 pixels,
including both overlap copies and the complete presentation copy, versus691200
without reuse. Scratch is retained until backing replacement and included in every
subsequent image-byte report. Tiny-list storage4096→5056; ordinary flat and text
controls retain exactly their baseline image bytes.

Invoking-thread mount adds8 requested/live bytes for a list's native metadata;
ordinary flat mount is unchanged. First retained image adds80 requested/live bytes
on every case. Warm ordinary controls have identical allocator counts/bytes; admitted
scroll adds a median6 requests/368 requested bytes, mixed adds7/816. Warm current
byte deltas are equal between variants, not a total retained-window-size claim.
First admitted copy includes lazy transition/scratch setup, and every warmup sample
is preserved. See raw/allocation-summary.json for mount/first-frame/net/peak and
all per-case records. Exact GPU capacities supplement those thread-local counters.

## Remaining work

This variant is unadopted because the flat-tiny gate failed. A distinct follow-up
will isolate the common renderer output/dispatch footprint without retuning this
result. It must preserve the exact proof and token guards, repeat equivalent-work
checks and the original gates, and compare the failed predecessor as a mechanism
control. No threshold or fixture is to be changed retroactively.

The broader goal remains open: matched native execution profiles, interactive
conversion/resampling/deferred-control parity, cross-framework text-quality gates,
actual retained-row observability and two physical hardware classes. This VM has
no physical GPU; llvmpipe cannot establish hardware cache behavior, GPU throughput
or scanout latency. Pinned ZGX's Linux wheel default is40 with resampling, not28;
GPUI currently uses32/direct input. Fixed14px timer arithmetic is matched.
