# Owned text planning: CPU-qualified, unadopted composition

Scoped cmap borrows stay inside TextShaper; only owned FontContext,
LayoutContext, paragraph storage and immutable font leases cross successful
passes. Font identity mismatch rebuilds planning state. Panic drops the cache;
failed GPUI preparation does not restore it. Removing all text drops it.
View/Signal/Source application APIs are unchanged. Canvas gains additive
TextCache/CachedTextShaper/shaper_reusing interfaces.

Sources: sparse baseline d5848eb970, original recorder 75a9e2b06b; initial cache
42a83c7bca; compatible cache c7194c74e6. The initial full build exposed a real
public borrow regression: a destructor on the ordinary shaper extended its font
borrow. The fix uses a separate cached-session wrapper; unchanged Unicode tests
now compile, including moving a font after the scoped shaper's final use.
Preserve the failing build, old timings and correction separately. The common
base's retained-output and sparse-publication changes are also still unadopted.

The preregistered CPU gates passed again after that correction, in a four-way
interleaved campaign shared with the subsequent bounded-cache experiment.
Five processes × five sizes × four alternatives × 2000 measured updates =
200000 operations; all 20000 batches are in raw/paired-compat. Each operation
sets the source, prepares the real canonical scene and acknowledges its token.
A fresh independent full window supplies the final pixel oracle outside timing.

| Static labels | Cache/full median paired CPU ratio | Cache/sparse ratio |
| ---: | ---: | ---: |
| 0 | 0.272635 | 0.271863 |
| 25 | 0.182818 | 0.246719 |
| 100 | 0.108704 | 0.250696 |
| 1000 | 0.016458 | 0.269838 |
| 10000 | 0.002130 | 0.259736 |

These are recording/ACK results, not native presentation or a ZGX ranking.
Pinned nightly 2026-10-23, identical default release/simd profile and exact font;
compiler JSON proves the changed libraries rebuilt. p50/p95/p99 wall and process
CPU values, all losing/noisy batches, cold/teardown and max RSS are retained.
Do not substitute ratios of medians for these median paired ratios.

Validation at c7194c74e6: full GPUI/Canvas with X11 and parallel rendering,
1044 passed / 42 ignored / 111 result groups; strict GPUI X11 all-target Clippy;
58 Vulkan readback tests plus 8 GPU units. Actual private X11 Todo exercises
CPU/GPU/Auto, edits, pointer actions, resize, exposure and inspection. The first
Cargo wrapper returned 143 despite a successful test transcript after its long
build; the exact compiled executable was rerun directly and exited zero with
one nonzero-count passing test. Preserve both attempts. This is software Vulkan,
not hardware or scanout latency. No unavailable platform gate is claimed.

Exact public cache tests compare Unicode metrics/glyphs, original-byte caret
geometry, font replacement, invalid inputs, panic recovery and held layouts.
The foreign-font mutant removes the same-face check and fails with ForeignLayout;
its production certificate is unchanged by the wrapper-only compatibility fix.
Sparse publication's independent bad-layout control remains in its own dossier.

Costs: shipping core 36578 lines vs sparse's 36488 (+90), original full 36191
(+387 combined). No dependency/vendor or new production unsafe changes. Shared
font bytes are outside the owner allocation ledger. At 1000 static labels the
warm owner update drops from 146 allocations in full recording and 115 in sparse
to 32 here; retained planning adds about 28 KiB. Every tested owner returns its
measured net allocation to zero on drop. Ledger fixtures and separate baseline,
sparse and cache results are preserved; compatibility reruns have their own
ledger-compat folder. No whole-process/RSS/stack improvement is claimed.

The long-paragraph stress exposes a material cost: a 31,200-byte paragraph
shrinking to a short label retains 3,256,796 bytes, rising to 3,290,684 after mixed
scripts. A foreign font replaces that historical scratch; clear reclaims it all.
The first oversized fixture was rejected before measurement and is preserved in
the native campaign. The bounded follow-up reduces this retained cost, but misses
its own CPU no-regression gates. Neither alternative is adopted by this dossier.

Native lab output/typography/feature equivalence and matched-profile comparison
are unfinished; software diagnostics fail the required scheduled-tick gate.
Two physical hardware classes remain unavailable. Run `python3 verify.py` for
payload hashes, independently recomputed CPU ratios, reclamation and test counts.
