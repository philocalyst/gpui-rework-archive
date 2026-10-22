# Fixed-lightness designer chroma limits

Source: `4ce80ae5b1b4e77e1169d427099318fbb865bc22`, then
`76cae9c95e19c7c547fb5328bb2c12cd8ac8f0e1`, based on `ec9b7165cf`.
The second commit tightens numerical admission; both are required. No renderer,
composition, output transfer/range, retained header, dependency, or Cargo feature
was changed. This is the first designer color primitive, not palette mixing,
contrast, CSS mapping, or HDR tone mapping.

`OutputProfile::max_chroma(L,h)` finds the neutral-connected first outward OKLCH
boundary of the profile's **linear RGB unit cube**. It accepts finite f32 L in
[0,1] and finite hue, uses existing hue wrapping, and returns zero at L=0/1.
`Color::fit_chroma(profile)` accepts admitted OKLCH authors, preserves all bits of
already-valid colors (including a real disconnected reentry), and otherwise
changes chroma only. RGB author spaces, including HDR authors, return
`InvalidColor`; they are never converted or clipped by this operation. Existing
Color admission still rejects excessive chroma before fitting; admitted C=1e6
is tested. Alpha is preserved, including negative zero.

The cap is a floating-point approximation, **not a correctly rounded root**.
`ColorOutOfRange` means numerical non-admission if a contact cannot be separated,
no independent finite cap is found, or the final production-chain membership
check cannot be satisfied within 64 inward f32 steps. It does not advertise a
later root as the maximum. All successful results satisfy the exact existing
f64 production conversion's inclusive [0,1] channel predicate. This is not RGB
clipping. The numerical admission guard is conservative and may reject valid
L/h inputs; none of the recorded actual-profile fixtures/sweep inputs did so.

## Shared formulation and numerical limits

One `f64x4<S>` holds the three RGB channel polynomials and an inert pad. Shared
scalar hue preparation and one generic kernel serve baseline SIMD and Fallback;
there is no parallel shipping reference renderer, retained dispatcher, CPUID,
backend option, heap owner, or global cache. The public default uses baseline
SSE2 on this host. The scalar Cargo policy instantiates exactly the same code
with fearless_simd Fallback. Native instruction inspection confirms packed
arithmetic; Fallback also receives substantial LLVM automatic vectorization.
It is not an unvectorized machine-code comparator.

Coefficients derive from the exact existing matrix constants. Constant matrix
composition and polynomial expansion reassociate floating operations, so they
are algebraically equivalent rather than bit-identical to production. The P3
chain includes the actual LMS→XYZ→sRGB→XYZ→P3 path. C=0 retains the existing exact
neutral shortcut. Lower-face roots are hue-only in t=C/L; solving these first
conditions the upper-face search even for the smallest positive f32 L. Positive
derivative roots split monotone intervals; each lane selects its first outward
exit, never the largest root. Lower/upper bisections are bounded at 96/64 steps.

The fixed-family guard encloses simple derivative roots with endpoints having
separated opposite derivative signs. It includes enclosures overlapping the
search bound and treats an ambiguous discriminant as unresolved. The 32ε Horner
magnitude bounds and a Taylor radius account for evaluation and derivative-root
uncertainty for ordinary finite coefficients in this profile family. Uncertain
extrema can hide an outward root pair **before** the extremum: uncertainty covers
the preceding monotone interval, or starts at zero after failed enclosure. That
lane cannot supply a later answer. Admission compares this independently carried
uncertainty against other resolved faces. Final narrowing is checked with the
unreassociated production path and corrected in chroma only.

This is not a proof of every canonical f32 hue/lightness on every libm/compiler.
In particular, the 32ε fixed-family bounds, coefficient composition, and libm
sine/cosine preparation do not constitute a general interval-arithmetic or
correctly-rounded polynomial library. The measured f32 error budget below is a
fixture result, not a universal rounding guarantee. Portability runs here are
Linux x86_64 only; no new Apple/Windows runtime or cross-build claim is made.

## Correctness controls

`numerical-controls.tar.gz` preserves the reference scripts, raw results, initial
pre-edit pins, and rejected formulations. The reference is a separately labelled
100-digit Decimal monotone-interval solver using exact f64 matrix constants and
high-precision trigonometry; it is not old production behavior or CSS local-MINDE.
The 902 initial rows and direct-C/normalized formulation controls were frozen
before production edits. The 288 contact-neighbor rows were generated later,
using the same independent oracle, and are explicitly labelled post-prototype.

- All 1190 oracle rows are checked, including 164 endpoint rows. The 1026
  nonendpoint rows exercise Fallback, SSE2, SSE4.2, and AVX2 on this host; AVX512
  was unavailable. Results match Fallback bit-for-bit. Worst measured error is
  1.021364 f32 ULPs; worst normal-L absolute error divided by L is 6.855179e-8.
  Each returned cap passes production membership and has an outward witness
  within eight f32 increments.
- A deterministic 10,000-input sweep samples f32 lightness bit patterns and
  wrapped hues, for 20,000 profile/input cases. All admit, match Fallback bits,
  pass production membership, preserve fitted author bits, and have the same
  nearby outward witness. This is a bit-pattern sweep, not uniform sampling of L.
- Tests cover endpoint fits, signed zeros/alpha, extreme admitted C, malformed
  L/h, huge finite hue wrapping, RGB/HDR rejection, mixed lanes, three roots,
  degree reduction, and unresolved rational tangencies. A real sRGB reentry
  at (L=.1,C=.067,h=264.2) is preserved beyond its first neutral-connected cap.
- Exact-rational Sturm isolation finds two real roots in each degree-six
  lower-face discriminant (four hue directions per channel/profile, 24 total).
  Nearest ±2 f32 hue probes have no relevant ambiguous contact. The closest
  relevant value is about 9.45 million times a conservative 128ε magnitude
  bound. This is algebraic contact isolation plus floating neighbor diagnostics,
  not an interval certificate for platform libm.
- A 0.01-degree sweep checks 72,000 profile/hue cases. Of 9183 positive local
  maxima before the first lower exit, none gives a white-face contact before
  another upper channel exits. This is a bounded diagnostic, not an exhaustive
  continuous proof.

Final full all-feature Canvas gate: **182 passed, 4 ignored**. Final Fallback
serial gate: **172 passed, 3 ignored**. Strict release all-target/all-feature
Clippy and package formatting pass. The final parallel Fallback run preserves
an unrelated process-global font-counter failure (`NEXT_FONT` 4 versus expected
3 at text.rs:625), while all gamut tests pass. The same full Fallback suite
passes serially and the font test passes alone. Earlier parallel Fallback gates
also passed; those logs retain their original source scope. No unrelated font
source was changed to mask this observed race. `checks.json` retains per-binary
counts and failed runs.

## Allocation and linked-cost ledger

Each final control is an external consumer with its own Cargo target and a
frozen executable. The common workload always keeps the same existing OKLCH
conversion code alive; the `primitive` feature additionally calls max_chroma and
fit_chroma. Machine Cargo artifact records pin the linked rlib and its features;
source/executable hashes are checked before and after three fresh captures each
at 0 and 1000 iterations. All six final controls request/retain/peak at **0 Rust
heap bytes and 0 allocation calls** inside the measured scope. These are exact
allocator requests, not allocator overhead, loader memory, stack, or RSS.
Color=16B, OutputProfile=1B, Error=8B throughout; no new retained type or field.

| Final consumer | File bytes | .text | .rodata |
|---|---:|---:|---:|
| Original ec9 common conversion | 559584 | 267893 | 25432 |
| Candidate, primitive unused | 558864 | 267893 | 25432 |
| Candidate baseline SIMD, primitive used | 569976 | 277333 | 25944 |
| Candidate Fallback, primitive used | 571536 | 278117 | 25968 |
| Rebuilt rejected bare Horner | 569600 | 277253 | 25928 |
| Rebuilt rejected exact endpoint expansion | 570096 | 277205 | 26040 |

The unused-API control adds **0 .text and 0 .rodata bytes**. Its file-size change
is not a memory/performance win. Invoking the primitive adds **9440 .text bytes**
to this common-work consumer with baseline SIMD; Fallback adds 10224. These are
consumer-linked deltas including its additional call path, not universal app
sizes. The normal Canvas rlib archive grows from 7015166 to 7093754 bytes
(+78588), including compiler metadata and code not necessarily linked into an
application; it is not a retained/RSS charge. Normal linking retains only the
SSE2 specialization, scalar policy only Fallback.

Native limit and first_exit reserve 672B and 960B of local stack respectively,
plus saved registers, return addresses, and up to 31B alignment at each aligned
frame. Fallback reserves 608B and 1088B. These are actual prologue reservations,
not whole-call peak stack measurements; nested libm and caller frames are not
included. The rejected bare kernel inlines into a 416B limit frame. The rejected
expansion has 576B limit, 832B first_exit, and an additional **1568B** rare exact
endpoint frame. The conservative candidate therefore buys correctness admission
with more temporary stack than bare Horner; it is not presented as a free
syntax change. Normal assembly has two `sqrtpd` instructions in limit and packed
`mulpd/addpd` bisection/uncertainty operations. No FMA or CPUID occurs in the
recorded primitive bodies. Linked first_exit calls are direct.

The bare and expansion controls were reconstructed **after** their numerical
experiments solely to charge linked shape; they are not old production controls.
The initial bare tangent-failure executable remains frozen at the path/hash in
`retained-executables.json`. The preliminary `consumer`, `consumer-fallback`,
`floor`, `original`, `bare`, and `expansion` artifacts in the analysis JSON use
an earlier driver or pre-tightening source; use only the six table-labelled
final/common controls for the ledger above.

## Rejected formulations and measurement scope

Naive direct-C fixed-64-step bisection failed 53 recorded dark-color rows;
normalized lower/upper solving passed those controls. This rejects that bounded
formulation, not every possible direct-C algorithm. Bare Horner misclassified
12 synthetic exact-dyadic rational tangencies; the actual Rust failure at
(15t−11)^2(t−2)/256 is retained. Error-free endpoint expansions fix signs at the
**rounded** derivative point but do not classify the **true** extremum. That
311-line control and its extra stack/code remain excluded. The shipping
319-line module (268 nonblank noncomment lines), plus the one module declaration,
uses explicit numerical non-admission instead; no generic exact-sign machinery
was adopted solely for an unexposed arbitrary-cubic contract.

Raw CSV `ns` columns were captured while other builds could run. They are
**unqualified and excluded from all timing claims**. No old-production gamut API
existed, no CPU speedup is claimed, and no GPU/frame/startup performance was
measured. A future quiet-window comparison needs a meaningful real designer
workload. This slice establishes the typed operation, shared native/Fallback
formulation, exact membership/author preservation, zero allocation, and charged
source/linked/stack costs.
