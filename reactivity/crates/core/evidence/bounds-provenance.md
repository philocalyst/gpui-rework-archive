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
mount and initial raster are outside these call/visitor loops. This is not a
benchmark of native startup or whole-window preparation.

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

## Guarded paired result: reject adoption

The separate provenance formulation also loses and should not replace the main
kernel. The frozen source is `60da69440b`; baseline remains `9176c2ce5e` in its
own worktree and target. Clean source, all source hashes and all six executable
hashes were checked immediately before capture. Root, production and research
peers explicitly held their heavy jobs. Seven alternating fresh-process pairs
ran pinned to CPU 2 on the AMD Ryzen 7 3700X with Rust 1.97.1 release code.
All digest, count and spatial-payload controls matched. The window was released
immediately afterwards; no source tuning or retiming follows these results.

The complete [168 rows](bounds-provenance-cost.csv),
[source/executable capture pins](bounds-provenance-cost.json), and
[paired summary](bounds-provenance-summary.csv) retain every control:

| Operation | Baseline median | Candidate median | Median paired change | Paired range |
| --- | ---: | ---: | ---: | ---: |
| Direct finite bounds | 21.075 ns | 22.349 ns | +5.78% | +4.02 to +12.73% |
| Composed finite bounds | 21.218 ns | 24.881 ns | +17.48% | +16.23 to +29.27% |
| Empty bounds admission | 7.439 ns | 7.222 ns | -3.51% | -4.49 to +5.42% |
| Extreme composed bounds | 16.552 ns | 20.424 ns | +23.85% | +21.85 to +26.83% |
| Common-transform Part visit | 93.638 µs | 97.336 µs | +3.54% | -0.21 to +9.05% |
| Two-transform Part visit | 93.571 µs | 96.864 µs | +3.71% | -0.53 to +8.43% |
| Unique-transform Part visit | 93.352 µs | 97.298 µs | +4.27% | +0.53 to +9.06% |
| Constructor | 2.517 ns | 2.539 ns | +0.36% | -0.97 to +1.74% |
| Compose Direct input | 10.646 ns | 10.676 ns | +1.62% | -0.42 to +7.70% |
| Compose Composed input | 10.694 ns | 10.692 ns | -0.26% | -1.98 to +1.56% |
| Equality | 4.250 ns | 4.249 ns | -0.04% | -2.40 to +4.77% |
| Copy | 2.307 ns | 2.307 ns | +1.31% | -1.30 to +3.44% |

Each core bounds row measures 1,280,000 calls per process over the prebuilt
256-case subset. Each public visit processes 4,097 nodes; 100 visits run per
cell after mount/render. Each producer row measures 250,000 calls. Displayed
medians are per-variant operation times; percentage columns summarize the
seven within-pair ratios and therefore need not equal the displayed-median
ratio. The tiny producer/equality/copy controls are mixed and do not establish
a speedup or a general zero-cost metadata claim.

All seven pairs lose on Direct and Composed finite bounds. Endpoint selection
still costs work after the finite guard is removed. The combined callee also
changes code generation for the original Composed reducer (including packed
NaN-preserving reductions), so selecting it directly does not preserve the old
machine code or its throughput. This capture does not separately attribute
cycles to instruction classes. Some common/two visitor pairs are near-flat or
negative, but all three visitor medians lose and all unique-transform pairs lose.

Layouts and the actual spatial payload remain unchanged; linked `.text` grows
by 208 B in each ordinary consumer: core 261,379 to 261,587 B, GPUI 2,894,855
to 2,895,063 B, copies/layout probe 288,279 to 288,487 B. The mathematical
certificate and equality invariant are sound, but no storage saving or measured
primary-operation improvement justifies adding the cached domain. Keep this
branch and the earlier rejected capture as independent evidence; leave the
original production kernel and type unchanged on main.
