# Exact endpoint bounds kernel

Base: `b60af3a4f9`. This branch changes only the shared bounds calculation,
tests and evidence. It does not include the held P56 storage branch, change any
public type, add allocations, or introduce a geometry tolerance.

Admission order remains invalid rectangle, uncertain/nonfinite mapping, then
empty rectangle or zero determinant. For each axis, coefficient signs select
the two extremal corners. Each expression retains the original operation order
`(u * x + v * y) + translation`. The finite path is admitted only when all four
selected f64 results are finite. Otherwise the original four-corner reducer is
executed, including its NaN/Infinity behavior. Outward conversion and final
rectangle admission are unchanged.

For the finite path, finite selected results imply finite endpoint products and
selected sums: a nonfinite product/sum cannot become finite by adding the other
finite terms. Rounded multiplication and addition are monotone over those finite
values. Every mixed corner lies between the selected extrema, so the numerical
minimum and maximum equal the original reduction. Ties may choose a different
zero sign; existing f32 `next_down`/`next_up` produces the same outward bits for
either zero sign. No center/extents reassociation, FMA, quantization or shortcut
around the original exceptional classification is introduced.

The independent unit oracle copies the complete pre-change implementation and
is kept out of line. Four tests perform 329,623 exact-bit/classification
comparisons across coefficient signs, signed zeros, subnormals, arbitrary f32
and f64 bit patterns, invalid/empty/singular/uncertain mappings, and deep public
composition. Eight inverse-axis scale compositions produce finite f64 matrix
coefficients above f32 range while their determinant stays usable; mapping a
large valid local rectangle then overflows products and exercises the fallback.

The public GPUI test independently computes original corner bounds for 97
transformed nodes across five pending/acknowledged sheet changes and resize.
It checks all rectangle bits and real query bounds, including old-P stability
while a newer sheet waits for acknowledgement. Existing AccessKit Consumer
tests exercise the same public semantic geometry, including the 100,000-node
full/sparse projection and frozen pending/failure cases.

## Initial actual code generation

The separately compiled core consumer initially emitted a 6 B tail jump to
`mapped_bounds`. The original callee was 1,146 B and the candidate 1,356 B;
neither reserved stack nor called another function. In the regular GPUI
consumer, `inspect` stayed 384 B and `Part::unclipped_bounds` stayed 105 B;
the shared core callee changed from 1,161 to 1,375 B. The exceptional fallback
therefore has a real code-size cost.

The candidate's finite arithmetic uses four packed f64 multiplications and four
packed additions (eight multiply lanes and eight add lanes), plus sign-mask
endpoint selection and a packed finite check. The original compiler already
reused endpoint products: six scalar and one packed multiplication likewise
represent eight multiply lanes. It then performs sixteen scalar corner
additions and eight min/eight max reductions. The implemented reduction is in
corner additions and reductions; it does not halve actual emitted
multiplications. Arithmetic counts alone establish no timing improvement.

The checked-in consumers compile against ordinary release rlibs in independent
baseline/candidate Cargo targets. Optional timing loops keep setup, trig,
mounting and initial rendering outside the measured region. Controls include
ordinary finite rotated core bounds, empty admission and composed-product
overflow, plus regular public Part visitors with common/two/unique authored
transforms. These measure call/visitor work, not native startup or full frames.
The capture helper alternates fresh-process order and records every row,
binary hash and current source commit. Run it only in an explicitly coordinated
quiet CPU window.

## Paired measurement and decision

Reject this formulation for adoption on the measured target. Correctness and
fewer corner additions/reductions do not establish a latency improvement.
All seven pairs lose on ordinary finite core calls and each public visitor
control. No further source variant or retiming is folded into these results.

The frozen source is `27552412edaea1a8d2abac93ea650e3fc35d4788`, compared
with baseline `b60af3a4f9` in a separate worktree/target. The capture checked
clean source, every source-file hash, and all four executable hashes before
starting. Root, production and research peers explicitly held heavy work for
this window and were released immediately after capture. The helper ran seven
alternating fresh-process pairs pinned to CPU 2 on the AMD Ryzen 7 3700X,
using the same Rust 1.97.1 release consumers described above. All output
digests/counts matched. The complete [84 raw rows](bounds-kernel-cost.csv),
[capture pins](bounds-kernel-cost.json), [codegen pins](bounds-kernel-codegen.json)
and [paired summary](bounds-kernel-summary.csv) are retained.

| Operation | Baseline median | Candidate median | Median paired change | Paired range |
| --- | ---: | ---: | ---: | ---: |
| Finite rotated core call | 20.877 ns | 22.398 ns | +7.25% | +6.28 to +7.87% |
| Empty core admission | 7.399 ns | 7.139 ns | -3.49% | -4.26 to -3.03% |
| Composed-overflow fallback call | 16.364 ns | 22.363 ns | +36.46% | +34.96 to +37.28% |
| 4,097-node common-transform visit | 93.329 µs | 97.409 µs | +4.20% | +3.63 to +7.74% |
| 4,097-node two-transform visit | 93.672 µs | 97.751 µs | +4.49% | +3.04 to +5.01% |
| 4,097-node unique-transform visit | 93.209 µs | 97.366 µs | +4.30% | +3.71 to +4.82% |

Each core row times 1,280,000 public calls per process over a prebuilt
256-case subset. Each visitor row times 100 ordinary public visits after
construction and the initial render, requesting transform, local bounds and
unclipped bounds for every node. Medians are per-variant operation times;
percentage columns are medians/ranges of the seven within-pair ratios, so they
need not equal the ratio of the displayed medians. These are call/visitor
measurements, not full-frame or native application latency claims.

The common-path source removes arithmetic, but emitted sign-mask selection and
the finite-result guard add real work. These costs are consistent with the loss;
this capture does not separately attribute cycles to each instruction class.
The fallback additionally evaluates selected endpoints before rerunning the
original reducer. Empty admission executes no endpoint work; its small win
cannot be attributed to the new mathematical formulation.

The retained owner/node/description layouts and allocation behavior are
unchanged. Neither emitted callee reserves stack or calls another function.
The core-only callee adds 210 B; the regular GPUI callee adds 214 B. Linked
`.text` grows 261,395 to 261,603 B in the core consumer and 2,894,855 to
2,895,063 B in the GPUI consumer, with no public visitor/wrapper size change.
Keep the production kernel unchanged on main unless a later independently
measured formulation improves these controls.
