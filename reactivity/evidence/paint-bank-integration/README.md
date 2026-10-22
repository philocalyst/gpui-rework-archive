# Source-owned working colors and literal sharing

Integrated sources: `be3809f750`, `d7fcdf62ca`, `7687b32246`, `570b4d9274`,
and `2f70493566`, reviewed against parent `131c6123f5`. Their original controls,
fixtures, assembly, source pins and failed attempts are preserved losslessly:

| Archive | Frozen evidence commit | Content |
| --- | --- | --- |
| initial.tar.gz | ef631b11a6 | Original bank, spaces, allocation and native/GPU controls |
| refinement.tar.gz | 854406bb5f | Borrowed properties and contiguous discovery ports |
| rebind.tar.gz | b61120c24e | Equal-coarse stale-Canvas regression and repair |
| literal-cow.tar.gz | c6e81a18b4 | Immutable literal sharing, six consumer guards and complete losing controls |

A qualified color source now owns one author color and one complete-Canvas
working row. Effective and declared styles retain that relationship instead of
rewriting a color at every destination. Equal explicit inspector contributions
detach from the source; inheritance restores the current declaration. An equal
coarse description conservatively rebuilds complete Canvas bindings before a
later exact patch. The old runtime paint map and native positional map are gone.
Native uploads one changed color word only when its preceding complete-scene
token matches; missed transitions and exceptional GPU proof colors rebuild.

CPU commands factor exact inverse basis/clip and retain inverse translations
unchanged. Literal rows share exact working bits through bounded discovery;
mutable sources never join. Positional writes reserve all detachments first,
then make exclusive rows that subsequent writes reuse. No refcount, second
destination array, unsafe block or production dependency is added.

## Integration differences

The existing cursor-free CSR, packed ordinals/cuts, hit proofs and target index
remain integrated. Both positional and source-bank color commits now revoke
cached cuts on either HDR eligibility transition, using the existing lazy bit.
A new public shared-color regression checks dropped/rejected plans, zero commit
allocations, full scalar-oracle pixels, cut rediscovery and unchanged bin bytes.
The ordinary Application HDR regression also exercises the source-bank path.

Typed property getters use `Styles::with` after the single admitted target
lookup. The integration also installs discovered color fanouts directly from
the borrowed discovery iterator, eliminating the temporary collected field Vec.
Historical allocation numbers below retain their original source pins; they
are not relabelled measurements of this additional elimination.

## Measured benefits and costs

The original 4,096-node shared-source owner retains 2,727,404 → 2,399,700 B
(12.02% less). The refinement removes the original allocation regression:
9,459 pre-bank mount allocations → 9,449. Literal sharing then saves 98,208 B
and ten allocations on the separate 4,096-node repeated-nondefault fixture.
These controls include owner/layout/presentation/command storage, rather than
only the color payload. They are allocation observations, with no timing claim.

The fully unique color plus inverse-basis case still costs an additional
20 B/draw before capacities. Detaching every member of 2,048 literal pairs
retains an extra 49,152 B (12 B/draw), including dead immutable rows until scene
replacement. Alternating late discovery misses still grow rows. GPU bank prefixes
duplicate intervening literal colors, and the banked shader keeps sixteen local
RGBA accumulators. Its register/spill and hardware-time costs remain unqualified.
These costs are reasons for further structural work, not omitted outliers.

Node remains 40 B, Presented 80 B, public Style 88 B, Canvas 488 B and headless
Runtime 2,320 B in the historical same-profile ledger. PreparedScene grows
48 → 56 B to retain its original viewport independently from mutable public
headers; active bound-color storage has its separately charged cold box.

## Actual integration checks

`checks.json` distinguishes the initial combined 572-test pass from checks on
the final source after removing the temporary field Vec. Final public tests,
strict accessible all-target Clippy, all 40 actual Vulkan tests, the actual
X11 Todo/CPU/GPU oracle, and the shared-HDR bin test pass. The initial strict
check's test-only `drop_non_drop` failure is preserved; a lexical guard scope
fixes it. Vulkan uses Mesa llvmpipe and native tests use private Xvfb `:120`;
neither proves physical-GPU performance or compositor/scanout latency. The owned
display was stopped after the gate. Raw logs are compressed without alteration.
