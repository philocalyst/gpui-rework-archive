# Canonical text tails, with reviewed placement growth

Main adopts the canonical-tail transaction plus the reviewed reserve formulation
from `71ed91f0ae42eeaa1d845c7e26d17be8b83e1c7b`. The original Sol source,
measurements and qualification remain in [producer-stage.md](producer-stage.md);
its `a70abc5` retained-capacity regression is superseded, not concealed.

Text submission builds directly in unpublished final display-list lanes. It
deletes the temporary pending-command Vec, resource Vec and full-key HashMap.
The scene's existing mask index deduplicates before leasing. Admission publishes
order, paint/common rows and counters only after all fallible work succeeds;
failure discards precisely the unpublished placement/resource tail. A single
glyph keeps the existing inline representation.

Review caught ordinary per-glyph Vec growth retaining substantially more memory
than the original batched append. The adopted reserve helper uses an already
admitted group's actual cardinality as its growth quantum. No history, predictor,
extra header, glyph-count upper-bound reservation or second traversal is added.
The warm path returns after its capacity check; division and growth remain on
the cold path. The optimized executable's actual instruction window is archived
in [capacity-review/reserve-placement-assembly.txt](capacity-review/reserve-placement-assembly.txt).

The identical public release probe changes color, fractional translation,
selection highlights and caret while rebuilding warmed lanes:

| Labels | Cold allocations old → adopted | Cold requested bytes old → adopted | Warm allocations old → adopted | Retained placement bytes, both |
| ---: | ---: | ---: | ---: | ---: |
| 32 | 59 → 28 | 76,428 → 54,620 | 38 → 0 | 22,528 |
| 48 | 78 → 31 | 140,876 → 107,868 | 54 → 0 | 45,056 |
| 64 | 94 → 31 | 152,076 → 107,868 | 70 → 0 | 45,056 |
| 96 | 129 → 34 | 280,972 → 214,364 | 102 → 0 | 90,112 |

All four warm byte totals are zero. Mask-handle capacity remains 128 bytes versus
the original 112: that 16-byte increase is still charged. DisplayList stays 288
bytes; no production fields, unsafe code or dependencies are added. These are
allocation and retained-capacity results, not latency, peak-live memory or RSS.
Mixed run lengths can have different growth costs; the four cohorts do not prove
a universal optimal reserve policy.

The new public `text_capacity` test fails the preceding canonical-tail source:
32 labels retain 32,768 bytes against the original 22,528-byte budget. Its frozen
executable exits 101 at the real capacity assertion. The final source passes:

| Exact final-source gate | Result |
| --- | --- |
| Default Canvas, including documentation | 222 passed, 3 ignored, 31 harnesses |
| Optimized, frozen transaction and capacity executables | 6 passed, 2 executables |
| Scalar transaction and capacity tests | 6 passed |
| Strict all-target Canvas Clippy | Passed with `-D warnings` |

Each final Cargo gate required clean source `71ed91f`, with 2,035 tracked input
hashes matching before and after. The earlier producer's GPU/runtime tests and
independent baseline fingerprints remain separately attributed to `a70abc5`;
they are not relabeled as final-source results. Main's shipping source equivalence
is recorded in [main-source-equivalence.json](main-source-equivalence.json).
The composed Main at `19037365297ae1fb29e1f69fc74d07c87dbbcba7` also passes
strict native all-target Clippy, including the ordinary, mapped and inspector
examples, with all 2,039 scoped input hashes unchanged; see
[main-native-lint/result.json](main-native-lint/result.json).
The later certified-solid composition at `4ee08a32def2ca70371c1764a0153a57053ae0e4`
passes 226 native library tests plus the actual native GPU/paint/inspector bridge;
[its evidence](../certified-solid/main-integration/result.json) retains the
frozen executable and generated-shader identity. Text shipping bytes remain the
reviewed reserve formulation above.

The actual seven-library Syn/Tokei inventory is **32,377 non-test, non-comment
shipping code lines**, including build code and the 50-line inline-call helper:
**+12** versus the adopted mapped-property baseline's 32,365. This replaces the
producer's physical-line comparison for the adopted source. No future line-count
prediction is used.

Compact guards, commands, logs, executable identities, negative controls, probe
source/compile identity, exact output and inventory are in `capacity-review/`.
Full selected executables remain at `/tmp/gpui-text-capacity-final-release-elf/`
and `/tmp/gpui-text-capacity-negative-elf/`; the optimized probe and complete
disassembly are at `/tmp/gpui-text-capacity-final-probe/`. Resource ownership and
rollback still use the same public Canvas API. New scenes still walk and prepare
glyphs and lease each unique mask; this change does not erase that remaining work.
