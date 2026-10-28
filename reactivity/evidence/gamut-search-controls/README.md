# Gamut search controls: fixed, ordered lattice, adaptive floor

These are **alternative experimental source branches**, not an adoption or a
sequence to cherry-pick together. The integrated fixed primitive remains the
selected implementation. All three start from the same frozen `86d0effdca`
worktree source; this evidence does not retag them as the later combined main.

- Fixed: gamut source `76cae9c95e`, contained in frozen handoff `86d0effdca`.
- Ordered lattice: `/root/gpui-gamut-lattice`, source `c7514aae50`.
- Adaptive floor: `/root/gpui-gamut-adaptive`, source `1fcb09f078`.

No Cargo feature, public API, retained header, allocation owner, renderer,
composition, transfer/range policy, or HDR behavior changes between these forms.
Both experiments retain the fixed-profile coefficients, derivative/root
uncertainty, explicit numerical non-admission, author/alpha preservation and
exact production-chain membership correction. They do not add a general cubic
root API or an application backend knob.

## Search geometry

The lattice control floors L*start and ceils L*end into ordered positive f32 bit
indices. Its upper index is **exclusive**: it is never assumed to be an outside
sample and is never evaluated. Infinity bits are only a sentinel, keeping
f32MAX searchable without sampling infinity. Every strict integer midpoint lies
before end even if ceil(end) has crossed a local extremum or reentry. Flooring
start is safe only because preceding intervals were certified no-exit; an
unresolved interval blocks that lane's later answers.

A narrow outward excursion can contain no representable outside sample. The
search still returns the predecessor of its first boundary rather than the
later reentry: if all strict midpoints before end are inside, the greatest
representable point below end is at/before that first boundary. The initial
exact-rational geometry model, frozen before lattice source edits, and actual
Rust helper fixtures exercise this case, a floor-rounded start, subnormal L,
and a finite-maximum sentinel. Actual helper counts are 30, 2, 0 and 31 for the
recorded cases. Ordered positive finite indices plus the exclusive sentinel span
less than 2^31, so any certified-interval search takes at most 31 evaluations.

Lattice lower-face results are already inward f32 chroma. An upper boundary
between that result and the true continuous lower boundary has the same or an
earlier inward f32 predecessor; restricting the upper search to the conservative
lower result cannot lose a larger admissible f32 answer. This is a discretized
first-boundary operation, not a search for later representable reentries.

The adaptive control retains f64 t midpoints. Positive f32 ordering serves only
as a convergence test: freeze a lane when **both inward floors are the same**,
or when its f64 midpoint cannot advance. Adjacent floors were deliberately not
used because they can lose another inward ULP. A stalled midpoint prevents an
infinite solve around an exact/near-representable root. The final result is the
inward lower lattice value. A lower t bracket may then be loose in continuous t
while still identifying the required f32 result; an intervening upper boundary
shares that inward floor or requires an earlier result. Earlier uncertainty
continues to block admission. No per-iteration division is added to this form.

## Numerical checks and observed difference

Both full serial Canvas suites pass for **each** experiment: all features
183 passed / 4 ignored; no-default-features 173 passed / 3 ignored. Strict release
all-target/all-feature Clippy and package formatting pass. Serial execution
avoids the already-preserved process-global font-counter race; no font code was
changed here. The lattice's initial missing closure-parameter type diagnostic
is preserved separately from the successful gates.

All 1190 independent high-precision oracle rows and the 20,000 profile/input
membership sweep pass unchanged tolerances, exact production membership,
nearby eight-ULP outward witnesses and author-preservation checks. Tests also
cover sub-ULP excursions, exact roots, finite extremes, subnormal L, rational
contacts, mixed lanes, degree reduction, constructors, hue wrapping, endpoints
and HDR/RGB rejection. Host-private Fallback/SSE2/SSE4.2/AVX2 checks pass; no new
Apple/Windows runtime or cross-build claim is made.

Source/executable/linked-rlib guarded external consumers compare all **21,190**
caps. Both experiments match each other and match their Fallback policies
bit-for-bit. Each differs from fixed at exactly one oracle row, index 969:

| sRGB input/result | Value |
|---|---:|
| L | 0.9999999403953552 |
| hue | 99.03509521484375 |
| Decimal oracle cap | 1.2481828462667486550342582861683e-7 |
| Fixed cap bits | 872809930 |
| Both experimental cap bits | 872809929 |
| Fixed error / f32 ULP | +0.0604106651 |
| Experimental error / f32 ULP | -0.9395893349 |

Both pass the exact production membership predicate; the new answer is one ULP
more conservative. Worst oracle error over all rows remains 1.021364 f32 ULPs
and the existing two-ULP-plus-scaling tolerance is unchanged. No upward correction
is added: production membership by itself does not prove neutral-connected
first-boundary authority after a narrow excursion. Already-valid authors,
including the real disconnected reentry fixture, retain every author bit.
No new numerical non-admission occurs in these recorded inputs. The original
primitive's explicitly documented precision/admission limitations still apply;
none of these controls is a correctly rounded polynomial library.

## Source, linked code and temporary stack

Shipping code counts use the **same Syn/Tokei tool as the integrated ledger**:
tests, comments and blanks are removed. Complete counter JSON files pin the
committed source and helper/Tokei/tool hashes. Test-only gamut files count zero.
The shared color.rs module declaration contributes one additional shipping line
to every variant. Physical module lines are supplemental, not shipping counts.

| Measure | Fixed | Lattice | Adaptive |
|---|---:|---:|---:|
| gamut.rs shipping code lines | 265 | 308 | 288 |
| Including shared declaration | 266 | 309 | 289 |
| Supplemental physical module lines | 319 | 369 | 346 |
| Native common consumer .text | 277333 | 277653 | 277685 |
| Fallback common consumer .text | 278117 | 278389 | 278517 |
| Native limit local reserve | 672B | 672B | 672B |
| Native first_exit local reserve | 960B | 1024B | 992B |
| Fallback limit local reserve | 608B | 576B | 576B |
| Fallback first_exit local reserve | 1088B | 1120B | 1120B |

Native linked text grows 320B / 352B, Fallback 272B / 400B. Neither experiment
reduces native local stack. The Fallback summed local reserves remain 1696B,
with different splits. These are actual `sub rsp` reservations, excluding saved
registers, return addresses, alignment and callers/libm; they are not whole-call
peak stack measurements. Raw prologues are retained. The common consumer keeps
the same existing conversion and primitive workload alive for each variant.
Cargo artifact metadata pins normal external-consumer feature sets and rlibs;
normal linking retains only baseline SSE2, scalar policy only Fallback.

Actual packed native first_exit bodies contain these static conversion/division
instruction sites (not dynamic counts or cycles):

| Instruction | Fixed | Lattice | Adaptive |
|---|---:|---:|---:|
| divpd | 0 | 2 | 0 |
| cvtpd2ps | 0 | 4 | 4 |
| cvtps2pd | 0 | 8 | 4 |

The lattice adds conversion, division and integer midpoint work. Adaptive avoids
those divisions but evaluates both floor bounds repeatedly. Both produce more
static first_exit instructions than fixed. Fallback also benefits from LLVM
automatic vectorization, so it is not an unvectorized machine-code comparator.
These instruction changes prevent treating fewer evaluations as a speed win.

Three guarded fresh captures at zero and 1000 iterations retain **0 requested,
retained and peak Rust heap bytes, and 0 allocation calls** in both experimental
policies. Color remains 16B, OutputProfile 1B, Error 8B. This is allocator-request
accounting, excluding loader memory, allocator overhead, stack and RSS. No new
blank-window/startup measurement was made.

## Counted work, separate from production assembly

`counted-controls.tar.gz` contains diagnostic copies of the exact committed
color/gamut modules. The generator changes visibility, copies the exact Error
and PixelWriter declarations needed to compile the color module alone, and
adds a thread-local counter only to `Polynomial::evaluate`. These instrumented
binaries are **not linked into GPUI** and are not used for assembly, stack,
allocation or timing claims. Their before/after sources, executable hashes,
Cargo artifacts and raw per-input counts are preserved. Every one of their
21,190 returned caps matches the corresponding actual GPUI consumer.

The following counts are observed **source-level four-lane polynomial
evaluations**, including endpoint classification, on baseline SSE2. They exclude
coefficient preparation, derivative/enclosure arithmetic, production membership
conversions, and convergence-test conversion work. Instrumentation can change
code generation; these are not executed instruction/FLOP counts.

| Input set | Fixed mean / max | Lattice mean / max | Adaptive mean / max |
|---|---:|---:|---:|
| 1190 oracle rows (including endpoints) | 140.5412 / 262 | 46.5622 / 93 | 49.4681 / 120 |
| 20,000 profile/input sweep | 138.9536 / 262 | 44.2241 / 93 | 46.0308 / 104 |

The 20,000-case sweep samples f32 L bit patterns, so most values are dark;
it is not a representative uniformly spaced designer palette. Lower evaluation
counts establish that over-solving was removed in these controls. They do not
establish lower CPU cost after conversion, division, masking, stack traffic or
public-call preparation.

All raw common-consumer CSV `ns` columns are **unqualified concurrent captures**
and excluded from performance claims. There is no timing-based adoption, GPU or
frame-performance claim. Final comparison stops here; the integrated fixed
primitive remains unchanged until a later quiet, realistic palette workload can
justify a replacement. Both alternatives, the one-ULP difference, source/stack
losses and failed setup diagnostic remain preserved.
