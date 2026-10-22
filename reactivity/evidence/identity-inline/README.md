# Exact identity lookup: normalized owner and inline follow-up

Source `f251f4be7bc215644859df8ee2f70a0f104f8d36`, based on affine-run source
`75544537f7596a7e0929306ab27b48f9942b7062`. The entire production change is two
ordinary `#[inline]` attributes on private `IdentityIndex::get` and `required`.
No representation, allocation, identity admission, or public API changes.

The earlier [996-row campaign](../identity-index/README.md)
is preserved separately in evidence commit `582bca6387`. Its tiny owner had only
32–48 property reads per process. Those tiny-case percentages are descriptive,
not confident steady-state regression estimates. This follow-up uses a **new
identical caller across all four variants**, not a candidate-only timing change.

## Matched caller and provenance

`fixtures/owner.rs` differs from the original owner caller only in its read
budget. Each fresh/stable/grown phase uses
`max(16, ceil(65_536 / current_targets.len()))` rounds, with the actual current
length after growth in both the budget and reported denominator. Every ordered
and permuted lookup phase executes at least 65K reads. Cold mount and subsequent
owner operations remain unchanged. The fixture is an untracked example at each
producer checkout; it is intentionally not added to the public example catalog.

| Variant | Exact source | New artifact target |
|---|---|---|
| baseline BTreeMap | `59467a4136d92822e90dfcff329383c75f9c3c33` | `/tmp/gpui-idnorm-base-target` |
| packed range/entry | `8da013d5f81d2687d9fdc7321f91109713e1e6c1` | `/tmp/gpui-idnorm-packed-target` |
| affine runs | `75544537f7596a7e0929306ab27b48f9942b7062` | `/tmp/gpui-idnorm-runs-target` |
| affine runs, inline | `f251f4be7bc215644859df8ee2f70a0f104f8d36` | `/tmp/gpui-idnorm-inline-target` |

All four consumers are freshly compiled at opt-level3. The first three reuse
copied warm-cache root libraries only after exact rlib/rmeta hash comparison to
the original frozen producers. The inline variant rebuilds its root library.
`frozen.json` records this distinction explicitly. Independent new targets leave
all original executable and root-library bits untouched. Source commits may have
evidence-only descendants; `run.py` rejects any relevant production source diff
from the pinned commit, mismatched caller, producer log, root artifact, or binary.

Untimed large preflights require full pixels, all local bounds, stable identities,
retired targets after structural growth, and the final public inspector edit to
agree across all four producers. Read phases assert zero allocation requests.
The capture validates the exact phase-specific operation denominator. Four
rotations give each variant every order position once; no retry/exclusion path.
CPU affinity is CPU2; process snapshots and CPU/I/O/memory PSI are retained.

Build each caller with `source /tmp/gpui-native-env.sh`, the target from the table,
`IDENTITY_INDEX_VARIANT=baseline|packed|runs|inline`, and
`IDENTITY_INDEX_SOURCE=<full corresponding pin>`:

```sh
cargo build --release --manifest-path reactivity/Cargo.toml -p gpui \
  --example identity_inline_control --message-format=json -j2
```

After source, producer, large preflight and executable qualification:

```sh
python3 reactivity/evidence/identity-inline/run.py guard
# Only after an explicitly coordinated quiet START:
IDENTITY_INDEX_QUIET=approved python3 reactivity/evidence/identity-inline/run.py \
  capture --output reactivity/evidence/identity-inline/capture
python3 reactivity/evidence/identity-inline/summarize.py
```

## Linked code generation

`asm/` contains bounded disassembly of the **actual linked consumers** and exact
symbol sizes. The inline consumer has no linked `IdentityIndex::get` or
`required` symbol. Its property read and Runtime resolution contain the checked
Contiguous subtract/range operations directly. The ordinary inline hint therefore
does remove the extra outlined index call; this is not inferred from an attribute.

| Linked body, bytes | BTree | packed | Runs | Runs inline |
|---|---:|---:|---:|---:|
| `read_properties` | 1491 | 552 | 1220 | 552 |
| `Win::style_property<Option<f32>>` | 448 | 315 | 319 | 664 |
| `Runtime::resolve` | 564 | 482 | 482 | 717 |
| outlined index `get` | — | 123 | 283 | absent |
| outlined index `required` | — | 142 | 43 | absent |

The compiler also changes surrounding caller inlining: the baseline and Runs
read loops partially inline the property path while the inline variant calls its
larger property body. Report the complete chain rather than asserting all code
shrinks. Inlining enlarges the property body by345B and resolution by235B versus
Runs. Existing packed-load Apple/Windows code-generation controls belong to the
previous campaign; this follow-up makes no new desktop hardware timing claim.

## Correctness and scope

All11 exact index tests pass. Strict headless all-target Clippy and accessible-X11
library Clippy pass (`gates/`; only trailing blank EOF in the test log is trimmed). The complete owner preflight crosses public
`Win::property`, description/replacement, target retirement and presentation,
not only a private table lookup. This annotation-only follow-up relies on the
already-tested representation invariants; it adds no new resource or lifecycle
state.

The retained header remains24B; contiguous storage allocates nothing, sparse
Runs retain16B/run, dense fallback retains12B/node. Runtime2320B, Node40B and P80B
are unchanged by this follow-up. Previous dense/permuted/even-odd construction
losses remain relevant and are not retimed or erased here. Whole-owner render,
layout, reconciliation and other allocations remain; this is not constant-time
window preparation or a native click-latency result.

## Capture results, all576 rows retained

Four balanced rounds,16 fresh processes, UTC2026-10-22T03:31:23–36Z. Actual child
wall times sum10.51s; source/artifact/oracle guards account for the rest. All576
cost rows and640 guard rows pass. No failures, retries, exclusions, or discarded
rounds. Compiler-process snapshots are clear. CPU PSI avg10 rises0.00→1.60;
I/O PSI some/full avg10 falls2.11→0.57. This is a coordinated hold with observed
background pressure, **not an isolated-machine claim**. `capture/` preserves
untouched stdout, each actual process duration, and before/after telemetry.

`summary.json` retains all four samples, signed retained-byte deltas, and every
allocation observation; `summary.csv` contains all144 phase/count/variant medians
and min/max values. Median public property read, ns/operation:

| Children, state / order | tree | packed | Runs | Runs inline |
|---|---:|---:|---:|---:|
|1 fresh ordered|6.33|8.59|7.87|6.66|
|1 fresh permuted|7.30|9.03|8.56|6.57|
|1 stable ordered|6.28|8.66|7.77|6.65|
|1 stable permuted|7.39|9.15|8.75|6.59|
|1 grown ordered|7.05|11.92|11.65|9.46|
|1 grown permuted|7.90|12.21|12.42|10.44|
|60 fresh ordered|15.90|8.65|7.90|6.44|
|60 grown ordered|15.71|22.12|11.72|9.84|
|4096 fresh ordered|64.05|8.56|7.87|6.40|
|4096 grown ordered|62.89|49.53|11.67|9.66|
|65536 fresh ordered|74.90|8.58|7.82|6.28|
|65536 fresh permuted|120.95|9.12|8.76|7.09|
|65536 stable ordered|75.11|8.62|7.85|6.28|
|65536 stable permuted|119.90|9.21|8.70|7.13|
|65536 grown ordered|74.52|61.21|11.69|9.73|
|65536 grown permuted|119.63|84.03|12.92|11.18|

Inline improves all24 lookup medians versus Runs by13.4–24.6%. The tiny
fresh/stable ordered case still loses5.2–5.9% to the old tree (about0.3–0.4ns),
while its permuted case wins10.0–10.8%. **Tiny post-growth remains a32.1–34.3%
loss**, about2.4–2.5ns/read. Do not replace this with the older short-sample
percentages or claim the small-owner dispatch cost universally disappears.
The public read still resolves the target and then performs a second lookup to
read the style; only the redundant outlined dispatch is removed here.

Whole owner median, milliseconds (mount includes actual initial prepare/ack;
stable/grow include public model update, prepare and acknowledge):

| Children / phase | tree | packed | Runs | Runs inline | inline vs tree |
|---|---:|---:|---:|---:|---:|
|1 mount|0.118587|0.125923|0.120088|0.115243|−2.82%|
|1 stable|0.009556|0.009290|0.010011|0.009261|−3.09%|
|1 grow|0.011400|0.013185|0.012155|0.011246|−1.36%|
|60 mount|0.099207|0.090297|0.092457|0.091382|−7.89%|
|60 stable|0.064627|0.066887|0.063117|0.063117|−2.34%|
|60 grow|0.091652|0.092082|0.088272|0.084552|−7.75%|
|4096 mount|6.346463|6.383829|6.416760|6.311703|−0.55%|
|4096 stable|3.661710|3.641415|3.612864|3.652245|−0.26%|
|4096 grow|5.947480|6.034757|5.893844|5.741360|−3.47%|
|65536 mount|113.093817|112.938954|115.408717|113.720421|+0.55%|
|65536 stable|67.009779|65.307322|65.235690|65.034630|−2.95%|
|65536 grow|117.726343|109.013293|107.939395|106.110635|−9.87%|

Retain the mixed whole-owner outcomes: large mount+0.55% versus tree and+0.69%
versus packed,4096 stable+1.09% versus Runs. Four samples and these short owner
operations are descriptive controls, not significance tests. Code-layout changes
and background pressure remain potential contributors. No native latency claim.

## Allocation ledger and recommendation

Every phase/count's four allocation observations are **exactly identical between
Runs and inline**. No lookup allocation. At65536 children:

| Owner operation / metric | tree | Runs inline |
|---|---:|---:|
|mount requests|17101|11138|
|mount cumulative requested bytes|179792105|176502505|
|mount newly retained bytes|58263521|57071105|
|mount peak newly live bytes|63225641|62033225|
|stable requests|16949|10986|
|stable cumulative requested bytes|99305757|96016157|
|stable peak newly live bytes|44564480|44564480|
|grow requests|28011|22049|
|grow cumulative requested bytes|241631686|238342086|
|grow signed retained delta|−33292167|−33292135|
|grow peak newly live bytes|44564704|44564704|

Growth peak does **not** fall: other scratch dominates. Sparse Runs avoid the
packed candidate's786424B additional cumulative request on this growth, without
an owner-wide identity map. These are allocation-counter results, not RSS/PSS.
The previous primitive even-odd construction loss (Runs+103.6% versus tree,
+22.8% versus packed) and its reverse/gaps sorting costs remain unmodified.

Recommendation to review: if adopting the range/Runs representation for its
common cold-floor and sparse-structure savings, prefer this two-attribute source
over unannotated Runs; the public owner lookup improves across every tested
count/order/state. Adoption still accepts the explicitly measured tiny grown
lookup loss, dense construction losers, and larger linked property/resolve
bodies. No additional representation or sorting variant is smuggled into this
follow-up.
