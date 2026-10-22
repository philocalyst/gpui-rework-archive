# Borrowed properties and contiguous sparse ports

Production source: `7687b3224682523bdb53b91b77209763b2bbc844`, based on
`ef631b11a6`. This is a refinement of the separately preserved initial slot
implementation, not a replacement of its losing controls. No timing campaign
has run for this refinement.

`Styles::with` lends the actual default/dense/palette style to the typed property
getter. Only source-colored records synthesize a resolved temporary. The
optimized public `Win::property(BACKGROUND)` caller no longer copies an 88 B
ordinary Style. Its linked body changes from 622 B to 522 B, but its stack
reservation grows from 96 B to 112 B. The original pre-slot caller was 431 B
with a 64 B reservation. The bound path still reconstructs Style; this is not a
claim of no copies for bound records or a latency improvement.

The transient per-port BTreeMap becomes one exactly sized `Vec<Binding>`.
Each Binding is the existing checked Destination plus Slot, 8 B on this target.
Capture copies resolved color destinations from existing fanouts and sorts once;
it does not project sources again. There is no allocation when colors are absent.
The distinct-source BTreeMap remains. Reconciliation still performs two
lower-bound searches per node (binding fields and declaration); there is no
constant-time streaming claim. No retained header, public API, or Canvas/GPU
representation changes in this refinement.

## Allocation controls

The identical public fixture produces all 30 rows in `memory-refined.csv`.
All 24 non-source rows match `memory-initial-slots.csv` exactly, including
allocation count, requested bytes, retained bytes, peak, and command lanes.

| Shared-source case | Initial slots | Refined | Retained bytes |
| --- | ---: | ---: | ---: |
| One node mount allocations | 53 | 53 | 7,452 unchanged |
| One node mount requested bytes | 10,112 | 9,888 | unchanged |
| 4,096 node mount allocations | 10,129 | 9,449 | 2,399,700 unchanged |
| 4,096 node mount requested bytes | 10,081,929 | 9,947,489 | unchanged |
| 4,096 nodes with pending C allocations | 20,964 | 19,604 | 2,973,412 unchanged |
| 4,096 nodes with pending C requested bytes | 23,896,027 | 23,627,155 | unchanged |

The pre-slot baseline uses 9,459 allocations for the same 4,096-node mount.
Thus the earlier +670 allocation regression is removed (now 10 fewer than that
baseline). Peak bytes are unchanged at 2,886,040 for mount and 5,283,588 with C.
This is an allocation observation, not a performance result. The unique literal
and unique-space losses documented in the initial report remain unchanged.

The focused reference test actually constructs the old
`BTreeMap<(usize, bool), Slot>` with its node-major insertion order. Its measured
requests compare to the new vector as follows:

| Bound nodes | Ports/node | Old allocations / requested | New allocations / requested | Hypothetical paired payload |
| ---: | ---: | ---: | ---: | ---: |
| 1 | 1 | 1 / 232 B | 1 / 8 B | 12 B |
| 1 | 2 | 1 / 232 B | 1 / 16 B | 12 B |
| 16 | 1 | 3 / 792 B | 1 / 128 B | 192 B |
| 16 | 2 | 5 / 1,256 B | 1 / 256 B | 192 B |
| 4,096 | 1 | 681 / 167,208 B | 1 / 32,768 B | 49,152 B |
| 4,096 | 2 | 1,365 / 335,400 B | 1 / 65,536 B | 49,152 B |

The 12 B paired-node alternative is payload arithmetic only, not an implemented
or measured allocator control. The chosen vector uses less payload for sparse
single-port nodes, more for dual ports, and directly reuses Destination.

## Source, code generation, and validation

`provenance.json` records source hashes, executable hashes, fixture hashes,
commands, target and profile. Original baseline/initial assembly is preserved in
the parent evidence directory; `property-refined.asm` is the actual linked
public consumer, not an isolated implementation microbenchmark. Refined linked
text/data/bss are 7,970,906 / 154,888 / 2,867 B for the property consumer and
7,964,617 / 153,832 / 5,139 B for the storage consumer. Linked-size totals include
generic consumer code and dependencies and are not library-only size deltas.

The first dependency build overlapped source editing and is not the authoritative
artifact. A final explicit release rebuild followed every production edit.
The later old-map test is cfg(test)-only and cannot alter these release binaries.

The inherited CPU/GPU color cohort, frozen candidate/P, mask, equal-value
override, drop and actual bridge tests remain intact. This cut adds pointer
identity checks for borrowed ordinary styles, exact sparse/dual-field fanout
capture, empty capture, and old-map reference allocation controls. Native Todo
also runs the real SDR/HDR paint-bank bridge and full fresh-render pixel oracle.
See the recorded gate logs and machine-derived counts in provenance. Counts from
overlapping profiles are not additive; `--lib --tests` excludes documentation
tests. The inherited documentation results are not claimed as rerun here.

This source is ready for parent review. Timing and adoption remain separate;
the bound reconstruction, extra stack, cold sort, and initial unique-case costs
remain visible. Literal COW interning is deliberately a separate follow-up.
