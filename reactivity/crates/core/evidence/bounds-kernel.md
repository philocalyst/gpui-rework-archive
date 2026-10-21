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
multiplications. There is no timing claim yet.

The checked-in consumers compile against ordinary release rlibs in independent
baseline/candidate Cargo targets. Optional timing loops keep setup, trig,
mounting and initial rendering outside the measured region. Controls include
ordinary finite rotated core bounds, empty admission and composed-product
overflow, plus regular public Part visitors with common/two/unique authored
transforms. These measure call/visitor work, not native startup or full frames.
The capture helper alternates fresh-process order and records every row,
binary hash and current source commit. Run it only in an explicitly coordinated
quiet CPU window.
