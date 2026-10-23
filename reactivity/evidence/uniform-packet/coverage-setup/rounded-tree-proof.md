# Whole visited-rectangle filter: proof obligation and implementation audit

Source base is a81bc7536b002b1f81e1b36137c1c4de543e2204. The shader and
full_tile remain byte-for-byte unchanged. A successful new filter must imply
that every tile emitted by visit passes that exact old rounded predicate.
This is not a new assertion about the soundness of the old shader envelope.

Unlike the first proposed gamma filter, the implementation propagates intervals
through every node of the existing rounded computation tree. Let a node's
interval contain all possible prior rounded values, as well as its exact node
values. For each multiply by a finite constant, use its sign to select the
endpoint products. For addition/subtraction use the monotone endpoint sums or
differences. Expand each computed low/high by next_down/next_up. Monotonic
round-to-nearest arithmetic therefore encloses the old rounded node outputs;
the outward step also encloses its exact real outputs. Induction proves the
complete expression enclosure. A contracted product/add is enclosed because
the exact unrounded product and sum are also included. Arbitrary fast-math
reassociation is not authorized for the new or old code; no such flags or
attributes are introduced. A separate gamma approximation is unnecessary.

Per axis, old position has this tree:
  ((a*x + b*y) + c) - origin
Old nonnegative magnitude has this tree:
  ((((abs(a)*x + abs(b)*y) + abs(c)) + abs(origin)) + abs(extent)) + 1
The packed margin is scale*magnitude + error, scale=16*f32::EPSILON;
the canonical guard is scale*magnitude, scale=32*f64::EPSILON. Both scales
are exactly represented. The single axis kernel encloses both tuples with the
same operation tree and the same interval policy. Requiring position.low to
exceed margin.high, and interval(extent-position).low to exceed margin.high,
implies both old rounded strict comparisons at every included sample corner.
The second subtraction is interval-evaluated, rather than testing an upper
bound on extent-position. Exact-zero operands can bypass an operation because
adding zero or multiplying a finite value by zero has the same numeric value;
signed-zero signs are not inspected by these geometry comparisons.

NaN/infinite or nonzero subnormal endpoints decline the filter, including
outward steps into the subnormal band. Nonzero subnormal coefficient inputs
also decline. An interval whose normal endpoints straddle zero encloses zero
and every subnormal in between; zero-only intervals represent exact-zero
operations. Overflow/cancellation ambiguity therefore returns false or stays
conservatively enclosed. The proof is for strict Rust IEEE arithmetic. It does
not certify externally altered hardware DAZ/FTZ modes. An attempted bit-zero
guard was folded back to FP zero comparisons by LLVM and grew linked text;
that production change was discarded, with its source and codegen preserved.
This does not change the old predicate's separate shader f32 error authority.

The certificate uses visit's exact integer casts and inclusive x/y endpoints,
then calls the unchanged tile_bounds on the first and last visited tiles.
This produces the union [L,T,R,B], including a clipped last viewport row/column.
Its sample intervals are [L+1/8,R-1/8] and [T+1/8,B-1/8], exactly representable
at admitted viewport sizes. Every old tile corner is in that box. Geometry
AABBs alone do not define this box. Clip endpoints are evaluated with the same
old f64 expressions and compared with the extremal union edges; because these
expressions are tile-invariant, their global containment implies all old clip
comparisons, including equality. Invalid/empty arithmetic declines the filter.

Material opacity is not part of this geometric certificate. The old source
kind, alpha-one and sign/subnormal opacity checks stay in bin_draw. The old
constant-coverage eligibility and cursor reset remain exactly where they were.
A certified translucent draw cannot restore a previously lost constant tag.
Tile counting, reference caps, forward/reverse visits, record upload policy,
failure revocation, and all resource admission/correction paths are unchanged.

Setup is per-draw stack state. It starts only on a second actual request for a
tile proof, and its result (including failure) is cached for that draw. There
is no pre-scan, heap allocation, retained field, scene key, SIMD-only policy,
new dependency, shader branch, or alternate scalar renderer. Mask/image/rounded
sources and already-sampled translucent ranges make no setup request. A single
eligible tile uses the old predicate. This is a logical avoidance criterion,
not a measured break-even threshold or a promise about tiny-loop branch cost.

Verification must retain independent integer geometry, global=>old-rounded
tile implication over boundary/correction/transform cases, separate/FMA
interval checks, SDR/HDR readbacks and an actual pixel-failing fault control.
Source/linked frame and core line growth remain adoption costs. No timing
campaign has been authorized for this implementation.
