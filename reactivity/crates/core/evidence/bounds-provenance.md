# Direct affine provenance for exact bounds

This is a separate formulation based on `9176c2ce5e`. The rejected
`27552412ed` / `e9c92d7481` guard-based formulation and its 84-row capture remain
unchanged in their original branch. None of the held P56 storage cut is included.

`CoordinateSpace` replaces its private uncertainty byte with a closed
`Direct / Composed / Uncertain` domain. `new(Affine)` sets Direct; copying retains
the domain. Every `compose`, including identity composition, yields Composed or
Uncertain and discards the direct range certificate. Matrix fields remain
private. `coefficients()` returns a copy, not mutation authority.

The existing invalid-rectangle, uncertainty/nonfinite-matrix, empty-rectangle and
zero-determinant checks stay in their original order. Only admitted Direct
spaces take the sign-selected endpoint path. Finite f32 coefficients are less
than 2^128 in magnitude; f64 rectangle endpoints formed from f32 coordinates
and extents are less than 2^129. Every product is therefore below 2^257 and the
original multiply/add expression below 2^259, well inside finite f64 range.
There is no per-result finite guard. The certificate does not claim that an
arbitrary input Affine is numerically valid: NaN/Infinity still fail admission.

The finite monotonicity proof and operation order are unchanged: select each
axis's two extreme corners without center/extents reassociation, compute
`(u*x + v*y) + translation`, and retain the original outward f32 rounding.
Endpoint zero-sign ties are erased by that rounding. Composed spaces branch
directly to the original four-corner reducer before selected-endpoint
arithmetic. No guarantee about composed f64 coefficient range is invented.

Value equality still compares the six float values and uncertainty class.
The cached Direct/Composed distinction is ignored. Manual `PartialEq` is inline;
NaN remains non-reflexive and signed zeros compare numerically equal, matching
the previous derive. Debug output now includes the private domain. The type has
no stable C/serialization ABI; normal Rust value layout and copy code are
measured rather than treated as a public representation promise.

## Representation controls before timing

A two-bool alternative used the existing trailing padding. The closed enum is
preferred because it excludes a contradictory direct-plus-uncertain state and
retains the original single-byte constructor store. Both alternatives and an
enum-order control are preserved as unmeasured code-generation evidence.
Reordering variants to make composed/uncertain use 0/1 did not reduce the emitted
compose callee, so the clearer Direct/Composed/Uncertain order is retained.

All three representations measured 56 B for CoordinateSpace, 56 B for its
Option, 72 B for the NodeId/space scratch tuple and 120 B for the spatial
record. All emitted the same 31 B copy wrapper and reported the same
11,816 B allocated spatial payload for the identical 65-node fixture. The
payload method excludes allocator and struct headers. These results establish
no allocation or whole-frame latency improvement.

The first ordinary downstream constructor/equality inspection measured:

| Emitted function | Baseline | Two bools | Closed enum |
| --- | ---: | ---: | ---: |
| Constructor wrapper | 27 B | 29 B | 27 B |
| Value equality wrapper | 97 B | 101 B | 102 B |
| Copy wrapper | 31 B | 31 B | 31 B |
| Compose callee | 530 B | 542 B | 563 B |
| Bounds callee | 1,146 B | 1,322 B | 1,325 B |

These are code-generation controls, not performance results. The enum has a
real compose/equality code-size tax despite avoiding an extra flag. The initial
bounds inspection confirms that Composed enters its original reducer without
computing Direct endpoints, and Direct has no finite-result guard. Compiler
choices for packed reductions still differ from the old callee; timing must
cover the composed path separately.

The independent complete original oracle checks exact returned bits and
classification across signed zeros, subnormals, arbitrary f32/f64 bit patterns,
invalid/empty/singular/uncertain mappings and deep composition. Added tests check
copy/identity-compose domain transitions, equality across provenance classes,
NaN and signed-zero behavior, extreme direct products/cancellation, and containing
layouts. A public GPUI Part/query test checks every geometry bit across pending
acknowledgements and resize; AccessKit Consumer gates use the same authority.

The identical downstream timing fixtures expose Direct and Composed finite
bounds, empty admission, extreme Composed bounds, three public Part visitors,
constructor, both compose-input classes, equality, and copy. Setup, trigonometry,
mount and initial raster are outside these call/visitor loops. No timing result
is claimed until a guarded quiet capture has run. This is not a benchmark of
native startup or whole-window preparation.

Before the capture freeze, core debug and release with layout each pass 36
cases. The full default GPUI run passes 260 cases/doctests (six explicit manual
ignores); the focused native semantic/AccessKit Consumer run passes 20 cases
(four manual ignores). Strict X11+Wayland all-target Clippy passes for GPUI and
core. Separately compiled ordinary core, Part visitor and layout/copy consumers
produce matching functional outputs. No actual native-script or scanout
performance claim follows from these gates.

The final ordinary core callee is 1,146 to 1,325 B (+179 B), and its regular
GPUI instantiation is 1,161 to 1,340 B (+179 B). The ordinary Part caller and
105 B bounds wrapper stay unchanged. Source and all six timed executable pins,
emitted actual-consumer assembly, representation-control patches and untimed
outputs are recorded in `bounds-provenance-codegen.json`. The two-bool patch is
a library-codegen alternative; the selected-domain private unit tests are not
written for that discarded representation.
