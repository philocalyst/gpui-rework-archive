# Local text publication: mechanism qualified, performance gate failed

Unadopted local experiment. Final production/test candidate
`957719565444c9900c6e6c20916a6fb88c933395`; control
`6895a10440abb8496e5e6eabbf16cf01877e68f0`. Both contain the separately qualified
image-placement correction `2c4e7e65b1`. The complete cost harness, native Workload
port, copied upstream Workload, renderer, workspace manifest and lockfile are
byte-identical between alternatives (raw/matched-cost-inputs.json).

BBTree's gather/validate/ordered-write structure, Ripple's compiled destinations
and Solid's separate computation/publication motivate retaining an exact text
update through GPUI publication. No application API, task contract, dependency,
shader, unsafe code or retained field is added. Owner callbacks still run their
complete description; there is no inferred purity or second reactive graph.

## Mechanism and preserved failures

The original blanket optional-feature guard discarded local text publication
beside unchanged lists, images or metadata. Logical indexes also differ from P
indexes when overscan rows are omitted. The candidate resolves exact P identity,
uses that sheet's admitted transform, and reconstructs rectangular clips with
Canvas's existing sample-lattice lowering. Rounded/sheared unsupported cases
fall back. Canvas still verifies grouped length, exact common state and existing
resource leases before mutation. Text/geometry change together only at ACK.

Owner description now records a transient single-text witness during existing
reconciliation. Non-text changes revoke it: topology, node state, style/bindings,
images/backgrounds, action eligibility, list metadata, names and clip geometry.
Logical viewport offsets must match old P before recording a witness. A surviving
witness preserves omitted row visibility; normal complete paint recomputes it.

All attempts remain in raw evidence and local history:

- First candidate `7afc8a2dad` admitted0/80 actual stream edits. Continuous semantic
  bounds differed by float bits from the canonical sample clip; no tolerance was
  introduced to bypass the existing exact check.
- Raster candidate `9e6fd06e11` admitted direct stream80/80 but owner0/80, failing
  RASTER-TRIAL.md's joint criterion. Small public oracles did not override it.
- First owner witness `1f75a5ec2b` passed focused public tests but still admitted
  owner0/80 because it incorrectly required overscan buffer rows to be visible.
  The corrected attempt preserves actual P membership and admits both streams
  80/80. Scroll/both/fractional remain0/80, including two fractional frames whose
  layout did not change. All counts are retained.
- Early fixture compile/acknowledgement mistakes, a test-only Clippy lint, and the
  independent preexisting image-placement failure remain recorded. Temporary image
  diagnostic prints were removed before the final candidate and all timing.

## Qualification and falsification

997 default and1082 X11 GPUI+Canvas tests pass, with13/45 ignored respectively;
strict all-target Clippy passes both configurations. The actual native port has
10 passing tests. Eleven explicitly executed private-X11 Todo/Library/list/
controlled-list/overscan/IME/AT-SPI scripts pass. Public tests compare complete
pixels and acknowledged text/grapheme geometry, names/actions, row identity,
coalesced edits, resize, new glyphs, nested fractional/reflected clips, unsupported
rounded/sheared clips, and failed newer descriptions with older eligible ACKs.

Two bounded mutants on the corrected candidate fail actual observable output:
`1a720ef1ef` selects an adjacent valid run after compacted P lookup and fails
pixels; `2a24197706` omits name invalidation and fails acknowledged semantics
(variant1) after matching pixels. Earlier versions of both mutants are retained.
The adjacent equal-length text fixture prevents an invalid Canvas length alone
from masking wrong semantic identity.

60 independent workload qualification processes and20 allocation processes pass
exact full-GPU pixel, epoch and copy-count checks. Qualification/allocation ran
while default tests compiled and supply no timing evidence. All300 timed fresh
processes ran after compilation/tests/allocations/cleanup ended, in the committed
seed20261029 order, with16 warmups and64 measured updates. Every source guard is
empty. Exact binaries were preserved before feature rebuilds.

## Fixed performance verdict

Endpoint: UI-owner/model operation, native packet preparation, explicit software
GPU completion and acknowledgement. Excludes producer transport, OS dispatch,
WSI/scanout and device setup. Explicit llvmpipe LLVM20.1.2/Mesa25.2.8, LP threads4,
private X11 :94, KVM AMD9950X guest. No physical-GPU or ZGX ranking follows.

Estimator is the median of15 paired process-median ratios. Bootstrap is paired,
seed20261029,10000 resamples; intervals describe uncertainty, not a relaxed gate.
Both stream primaries require<=0.8; every other control requires<=1.05.

| Case | Candidate/control paired ratio | Paired95% interval | Limit | Gate |
| --- | ---: | --- | ---: | --- |
| scroll | 1.000129854 | 0.985709–1.015453 | 1.05 | pass |
| both | 1.002918806 | 0.992970–1.015074 | 1.05 | pass |
| stream | 1.016588093 | 1.004992–1.032929 | 0.80 | **fail** |
| stream-owner | 1.023470685 | 1.014346–1.043157 | 0.80 | **fail** |
| fractional | 1.003528837 | 1.000330–1.011108 | 1.05 | pass |
| flat-tiny | 0.959566593 | 0.863884–0.980542 | 1.05 | pass |
| flat-full | 0.985468635 | 0.934370–0.998912 | 1.05 | pass |
| list-tiny | 0.971118303 | 0.920810–0.987484 | 1.05 | pass |
| list-flat | 0.977494785 | 0.935585–1.023940 | 1.05 | pass |
| exposure | 0.981883577 | 0.900389–1.087367 | 1.05 | pass |

Both primary gates fail; all other point gates pass. Direct stream is1.66%
slower and owner stream2.35% slower by the preregistered paired estimator.
The ratio of unpaired process medians differs (direct stream is near1.0);
raw/cost-analysis preserves both estimators, all pairs, p50/p95/p99, construction,
first frame and first update. It is invalid to substitute the favorable estimator
or lower the20% requirement after seeing results. Exposure's interval extends
above1.05 despite its passing point estimate. No performance adoption.

## Allocation, storage and code costs

Invoking-thread warm medians from four post-warmup frames per allocation process:
stream245->216 requests and188319->123995 requested bytes; owner stream405->376
requests and284248->219924 bytes. Both save29 requests/64324 requested bytes and
reduce measured peak above frame start74381->43541. Net live-byte delta is equal
(+304 in these probes), as are retained GPU image bytes2764800 and copied
pixels691200. Tiny-flat remains69 requests/10135 bytes/6353 peak. All ten cells,
cold allocation records and raw frames are preserved; these are not whole-process
or worker-thread allocation totals.

Shipping source36962->37113 (+151). No retained fields/capacity categories added.
Measured SceneDamage40, RetainedRenderer920 and GpuSurface1056 bytes are unchanged.
Native example ELF26306600->26309704 (+3104). Linked describe_inner34831->36395
bytes, explicit local stack subtraction2456->2472; try_sparse_text2141->2274,
stack360->408. New optional placement query686 bytes/136 stack, admission helper
1087/40, tiny wrapper48/no local subtraction. present_walk remains25792 bytes,
prologue4096+200. Stack prologues are not total dynamic stack-depth claims.

## Next question, not a post-hoc win

Code inspection after timing found a downstream distinction: complete Canvas
replacement compares individual commands, whereas sparse text unions support of
all old/new glyphs in the run. Coarser damage may erase CPU savings or add GPU
work. Actual Workload damage and phase costs have not yet established the cause.
A further experiment must preregister that diagnosis and preserve the complete
ordered/resource/epoch certificate, including paint-slot support and fallback
costs. This result is evidence that locality must survive the entire pipeline;
it does not prove a cache-hit or async-runtime advantage.

Run `python3 verify.py` to check the manifest, source guards, gate counts,
mutants, exact workload oracles, fixed process manifest, recomputed paired point
ratios and preserved binary hashes. All work remains local.
