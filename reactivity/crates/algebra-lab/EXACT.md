# Exact subpixel translations: an admissible path monoid

The general affine experiment remains numerically inadmissible for unrestricted
floating coordinates. This iteration adds an exact common case: **a sparse forest
of translation-only coordinate spaces**, with explicit 1/256-pixel local units,
i64 sources and i128 aggregates. It shares the same splay/cut/link implementation
with the approximate affine experiment through one private, monomorphized algebra
trait. No public generic callback system, trait object, inverse or duplicated
link-cut implementation was added.

This solves the query-history/cancellation defect for this lane. It does not
solve affine rotations/scales, layout, clipping, subtree bounds, damage or paint
skipping. Allocate a record for a declared coordinate-space group such as a scroll
origin or retained viewport, not one for every UI primitive. A shallow parentwalk
or eager dense pass can still be cheaper.

## The algebra and the overflow proof

The source type is `Translation::from_subpixels(x: i64, y: i64)` with
`SUBPIXELS_PER_PIXEL = 256`. There is deliberately no implicit float constructor.
`WideTranslation` holds exact global sums; `RelativeTranslation` holds an exact
node-minus-viewport difference. Their fields are private. Only the relative type
provides an explicit renderer float conversion.

For each axis, let the local value be s, with `-2^63 <= s <= 2^63-1`. The
append-only forest has at most `2^32-1` nodes; `u32::MAX` is the null index. Every
cached auxiliary aggregate is a subpath with distinct nodes. Thus, for any partial
aggregate and **every reassociation**:

```text
|sum(s_i)| <= sum(|s_i|) <= (2^32-1) * 2^63 < 2^95.
```

Signed i128 holds values through magnitude `2^127-1`, so every combine is exact
and cannot overflow. Two whole-world aggregates differ by magnitude `<2^96`,
which also fits. This proof includes `i64::MIN`, whose absolute magnitude cannot
be formed in i64; the implementation sign-extends to i128 without taking that
absolute value. There is no saturating sum, wrapping sum or untracked truncation.

Pairwise addition has identity `(0,0)` and is associative on all reachable
aggregates. Source values are lifted into i128 before combining. Auxiliary left,
local and right subpaths are disjoint; splaying never duplicates a source into
one aggregate. The ordinary rooted link-cut structural invariant therefore gives
a true exact monoid here. The private trait documents that associativity is an
admission requirement; the floating implementation is explicitly the approximate
experimental exception, not evidence that IEEE multiplication meets that law.

The proof depends on the u32 node bound and i64 source domain. Do not widen the
index or source types without rechecking it. The public API does not allow users
to construct arbitrary i128 aggregates or implement a new algebra externally.

## Viewport rebasing before narrowing

```rust
use gpui_reactivity_algebra_lab::{Translation, TranslationForest};

let mut spaces = TranslationForest::new();
let viewport = spaces.insert(None,
    Translation::from_subpixels(i64::MAX, i64::MIN)).unwrap();
let item = spaces.insert(Some(viewport),
    Translation::from_subpixels(1, -1)).unwrap();
let relative = spaces.viewport_relative(item, viewport).unwrap();
assert_eq!(relative.subpixels(), (1, -1));
assert_eq!(relative.to_pixels_f32().unwrap(), (1.0/256.0, -1.0/256.0));
```

`viewport_relative` first checks both arena keys and represented-component
membership, then subtracts the two **integer** world sums. It returns the node
and origin keys with the result. The separate local/world/relative types make
that staging explicit; origin tags are runtime provenance, not a claim of
compile-time generative frame branding.

`to_pixels_f32` requires both integer subpixel coordinates to survive the cast
to f32 exactly, then divides by 256 (an exact power-of-two scaling). Nonexact
narrowing returns `RendererRange`; it never silently drops a subpixel. Bounds on
relative values keep the checked round-trip cast well within i128. Tiny nonzero
relative units remain normal floats after division. A far nonrepresentable value
should be culled or rebased, not blindly sent to a renderer. Exact large multiples
may still be representable and are accepted; the test rejects `2^24+1` subpixels
while accepting `2^24`.

A returned relative value is an immutable **snapshot**. Moving its origin later
does not update it. This lab has no presentation epochs; integration must carry
these snapshots with the committed frame that produced them. The labels prevent
accidental provenance loss inside this API, not arbitrary application misuse of
returned floats.

The giant-offset test uses two `i64::MAX` offsets before adding one subpixel.
Converting both absolute sums to f64 first yields difference zero; exact integer
subtraction first yields precisely 1/256 pixel. A second edit preserves 1/64
pixel. This connects fixed-point coordinates and floating-origin rendering
without charging a general affine matrix to every translated item.

## Validation

The original seven affine/structural tests still pass. Five exact-lane tests add:

- cancellation `[i64::MAX, -i64::MAX, 1, 0]` invariant under query permutations
  and failed cycle restructuring;
- giant viewport offsets retaining 1/256 and 1/64 pixel, plus snapshot behavior;
- nonexact float-narrowing rejection and cross-component/cross-forest/family keys;
- 100k extreme i64 source values accumulated exactly beyond i64, with 64-byte
  node and 6.4 MB exact-reserved storage assertions;
- 9,000 randomized full-i64 local/structural edits with independent i128 parent
  sums, full expected snapshots and 16 random queries per step. No epsilon.

Both debug and optimized tests pass; clippy all-targets with `-D warnings` and
rustfmt pass. The standalone harness points at actual repository sources/tests,
without editing the root workspace lockfile. The original floating cancellation
characterization remains intentionally visible beside the exact positive test.

## Reproduce the complete comparison

```sh
cargo test -p gpui_reactivity_algebra_lab
cargo run --release -p gpui_reactivity_algebra_lab --example exact_frontier -- 12 > exact-frontier.csv
```

The committed CSV has 171 data rows: deep/balanced/wide at 1k/10k/100k, build,
first query, camera and branch edit plus 1/16/1024/all leaves, world and viewport
modes, and reparent plus an affected leaf. A chain has only one leaf; requested
budgets are capped and actual counts printed. The source workload uses small
integer subpixels that are also exactly representable as binary floats, so timing
is not conflated with the affine cancellation defect.

Each timed operation includes the edit and all queries. Viewport mode includes
component validation, exact subtraction and checked float narrowing in the exact
API. Affine mode queries node and origin and subtracts floats; it has no equivalent
component-check API. Eager and walk baselines use valid private workload indexes,
not public cross-arena keys. Their source/world arithmetic and narrowing are
exact. Thus the exact public viewport API pays stronger validation than those
baselines; the cost is visible rather than omitted. Reparent rows include cycle
validation. Result equality across all implementations is checked outside timing.

All alternatives use complete retained storage: exact LCT 64 bytes/group,
approximate affine LCT 112 bytes/group, exact eager 64 bytes/group plus a u32
traversal stack, and exact parentwalk separate i64-pair source/u32-parent lanes
at 20 bytes/group. LCT CSV bytes additionally include a 16-byte-per-group client
key vector, matching what the example retains. Shared input/query vectors,
container headers and allocator metadata are excluded consistently and disclosed.
There are no per-query heap allocations in either LCT or parentwalk.

At 100k groups, exact LCT internal storage is 6.4 MB vs affine 11.2 MB; including
retained client keys the CSV reports 8 MB vs 12.8 MB. Exact eager retains 6.400016
MB deep, 6.400128 MB balanced, and 6.924288 MB wide including scratch. Exact
parentwalk retains 2 MB. This is a meaningful reduction from 112-byte affine
records; it does not beat the smallest shallow read representation.

The measurement machine/compiler/protocol match `NOTES.md`: Ryzen 7 3700X,
Rust 1.97.1, ordinary release optimization, 12 retained rounds, no CPU pinning or
renderer. Sub-microsecond means are noisy local observations, not p99 UI claims.
Rows reuse paths and include history-dependent cold edit effects; first-ever
queries have their own rows. Selected complete-operation means at 100k groups:

| Trace | Exact LCT | Affine LCT | Exact eager | Exact walk |
| --- | ---: | ---: | ---: | ---: |
| Deep first leaf query | 1.72 ms | 13.89 ms | 0.000310 ms | 0.254 ms |
| Deep camera + one world | 0.000088 ms | 0.000316 ms | 0.417 ms | 0.245 ms |
| Deep camera + one viewport offset | 0.000145 ms | 0.000313 ms | 0.414 ms | 0.241 ms |
| Balanced camera + 16 worlds | 0.00150 ms | 0.0115 ms | 0.412 ms | 0.00131 ms |
| Balanced camera + 1024 worlds | 0.107 ms | 0.876 ms | 0.413 ms | 0.0553 ms |
| Balanced camera + all 50k worlds | 4.45 ms | 35.73 ms | 0.481 ms | 1.85 ms |
| Balanced camera + all viewport offsets | 10.38 ms | 47.34 ms | 1.65 ms | 3.37 ms |
| Wide camera + one world | 0.000085 ms | 0.000207 ms | 0.430 ms | 0.000018 ms |
| Wide camera + all 99,999 worlds | 3.61 ms | 15.48 ms | 0.590 ms | 0.547 ms |
| Balanced reparent + affected leaf | 0.000558 ms | 0.00174 ms | 0.276 ms | 0.000170 ms |

The exact specialization removes expensive matrix arithmetic, classifications and
48-byte caches. It does not remove pointer-index restructuring, cold exposures
or dense-read overhead. All-leaf eager passes and shallow walks still win. Use a
small sparse coordinate-space hierarchy, or choose adaptively by measured shape;
these results do not justify allocating an LCT node for every primitive.

## Generated assembly

Built with `cargo rustc --release --lib -- --emit=asm` and inspected the exact
`Dynamic<ExactTranslations>::pull`, rotate and viewport subtraction. On x86-64,
one axis's i128 sum becomes `addq` followed by `adcq`; source lifting uses sign
extension. The two axes are independent carry chains. There are no floating
classification branches or helper calls in exact combine. A representative
portion of the generated pull is:

```asm
shlq $6, %r8              # 64-byte node index
addq (%rdx,%r8), %r10     # x low word
adcq 8(%rdx,%r8), %rbx    # x signed high word + carry
addq 16(%rdx,%r8), %r9    # y low word
adcq 24(%rdx,%r8), %r11   # y signed high word + carry
```

The 64-byte record uses shifts rather than the affine record's 112-byte stride
multiply. Safe Vec bounds comparisons and cold panic branches remain in the
array path. Viewport subtraction uses low-word subtraction and borrow propagation.
No unsafe array access, manual SIMD, or unsupported target features were needed.
These are inspected assembly facts, not instruction-retirement or cache-miss
measurements. The algebra proof, instead of an unchecked arithmetic trick, is
what makes the common case exact and cheap.
