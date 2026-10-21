# Owner-owned resolved style lanes

This cut changes retained storage, with unchanged public `Style`, element and
typed property APIs. The authoring style remains 88 B. On x86-64 the logical
node changes from 128 B to 40 B; `Runtime<()>` adds a 40 B style-lane enum
(2,328 → 2,368 B). Presented remains 80 B, Part remains two references, and
elements keep their existing temporary style representation.

The [provenance](retained-styles.json) records exact capture source and executable
hashes. The inline comparison is c3ae3584d4 plus fixture a7b0c7b08d. Prototype
7ca71d6d3c, identity fix 43b719f3b2 and exact-color fix f7fc212a05 are separate
commits so their costs and reasons remain reviewable.

## Ownership and fallback

The owner exclusively holds one of three representations:

* Default: no style allocation; reads borrow the canonical library default.
* Dense: one `Vec<Style>`, addressed by current node index.
* Shared: one exact palette and one boxed `u8` index per current node.

Discovery is bounded to 32 exact styles. The 33rd distinct value selects dense
storage; it is not an admission limit. Owners with at most eight nodes choose
dense storage when the first nondefault style appears. A completed shared lane
must save at least 25% of its dense style payload; otherwise it becomes dense.
The default prefix allocates nothing. Palette discovery scans at most 32
entries per node, not an unbounded interning table. No hash lookup, per-node
allocation, reference count, shared mutable owner, TLS or unsafe code is added.

Each description builds precisely its current lane. Removed/animated styles
leave no historical entries. The prior lane stays borrowed through identity
reconciliation and then drops. A first inspector mutation densifies a default
or shared lane; subsequent mutations edit it directly. A later description can
compress it again. This deliberate one-time cost appears in the measurements.

Style sharing preserves exact channel bits, profile, float bits and Option
presence supplied by the description. `Color::same_authoring` uses its canonical
four-word representation. The disjoint profile tags, injective unit-alpha code,
bounded base-199 linear exponents plus sign/mantissa payloads, and normalized
nonnegative Oklch hue make this equivalent to decoded channel-bit/profile
equality. Public tests independently compare those observables, including
constructor reconstruction and signed zeros. Numeric `PartialEq` stays unchanged.
Existing numeric no-op property admission is also unchanged: this does not turn
`Property::set` into a new bit-preserving signed-zero setter.

Complete P and pending C keep their existing owned geometry and canvas colors;
neither borrows this mutable current-style lane. Failed admission cannot replace
either sheet. Public tests exercise shared/dense transitions, typed override and
inheritance, a failed candidate, old-candidate acknowledgement, recovery, DPI
resize and target retirement. Existing list/component/source/focus tests use
the same lane.

## Measured distributions and retained bytes

The [inline](retained-styles-entropy-baseline.csv) and
[candidate](retained-styles-entropy-candidate.csv) ledgers count exact authored
styles and matrices, not numerical/converted-pixel equivalence.

| Trace | Nodes | Exact styles | Inline node B | New node + style B |
| --- | ---: | ---: | ---: | ---: |
| Counter | 3 | 3 | 384 | 384 |
| Todo, empty | 11 | 10 | 1,408 | 1,408 |
| Todo, 8 tasks | 43 | 13 | 5,504 | 2,907 |
| Todo, 32 tasks | 139 | 13 | 17,792 | 6,843 |
| Workspace | 32 | 26 | 4,096 | 4,096 |
| Library, 250,000 records | 60 | 11 | 7,680 | 3,428 |
| Default adversary | 4,097 | 1 | 524,416 | 163,880 |
| Two-style adversary | 4,097 | 2 | 524,416 | 168,153 |
| Unique/animated adversary | 4,097 | 4,097 | 524,416 | 524,416 |

Add 40 B for the owner slot in every new column. Dense cases add one allocation
compared with inline storage. These are node/lane capacity bytes, not complete
window footprint. P is unchanged. Every real app sheet has one unique linear
map except rotated Workspace, which has two; translations often differ. No
presentation-space sharing is implemented or claimed here.

The counted builder ledger for 4,096 values reports:

| Values | Allocation requests | Requested B | Live B | Counter peak B |
| --- | ---: | ---: | ---: | ---: |
| All default | 0 | 0 | 0 | 0 |
| Eight repeated styles | 3 | 7,616 | 4,800 | 7,616 |
| Unique styles | 3 | 367,360 | 360,448 | 367,360 |

Three small dense values request one 264 B allocation. Shared requests include
the bounded 32-entry discovery palette and its final shrink. Unique fallback
requests include that palette and the temporary index buffer. Allocation-counter
peaks are requested-byte accounting, not allocator usable sizes or RSS.

Removing Style initially removed Flow's niche: `Option<Node>` became 48 B.
Consequently the old-tree `map(Some).collect()` requested another 48 B per node
instead of reusing its buffer. Logical identities already start at one, never
roll back, and reserve a checked interval before minting. Encoding that invariant
as `NonZeroU64` restores `Node` and `Option<Node>` to 40 B. A counted test verifies
the same pointer and zero allocation in both debug and release on this toolchain.
It does not infer allocation reuse from size equality alone.

## Complete owner and pending-cohort accounting

[Raw owner measurements](retained-styles-owner-memory.csv) include the model,
layout topology/caches, logical tree, commands, old P and any pending C. Recording
mode owns no CPU framebuffer; no font-bearing nodes or native backend allocations
are included in these rectangle scenes. Pending rows retain acknowledged P,
perform a coarse source edit, then force a physical resize to retain a complete C.
Constraint histories differ across rows; compare variants within one row.

| Scene / 4,097 nodes | Inline live B | Final live B | Inline → final peak B |
| --- | ---: | ---: | ---: |
| Default, mount | 4,906,196 | 4,545,700 | 5,215,668 → 4,855,172 |
| Two styles, mount | 2,275,892 | 1,919,669 | 2,787,624 → 2,787,664 |
| Nine styles, mount | 2,248,888 | 1,893,281 | 2,787,624 → 2,787,664 |
| Unique, mount | 2,275,892 | 2,275,932 | 2,787,624 → 2,787,664 |
| Default, held C | 2,546,308 | 2,185,812 | 5,003,828 → 4,643,332 |
| Two styles, held C | 2,603,652 | 2,247,429 | 5,061,172 → 4,704,949 |
| Nine styles, held C | 2,576,648 | 2,221,041 | 5,034,168 → 4,678,561 |
| Unique, held C | 2,603,652 | 2,603,692 | 5,061,172 → 5,061,212 |

Repeated scenes save about 15.7–15.8% of the complete mounted owner here. Unique
storage is neutral per node but loses the 40 B slot and additional allocation
requests. The final unique held-C requested-byte excess is 13,866 B; the initial
prototype's excess was 210,522 B, including the avoidable old-node migration.
Earlier description/layout scratch can dominate peak even when retained nodes
shrink. All intermediate peaks and losing cases remain in the CSV.

## Paired operation times and limits

Both [initial](retained-styles-initial.csv) and [final](retained-styles-final.csv)
captures contain 750 rows: five alternating fresh-process pairs, three rounds per
process, pinned to CPU 2 on a Ryzen 7 3700X with Rust 1.97.1, default release and
the checked-in flags. Root and peer builds/captures were explicitly held. The
first run took 40.08 seconds; final took 37.19 seconds. The timed fixture body is
byte-identical in both source variants. A separate font-bearing owner keeps the
immutable face resident. Mount/drop setup and real app preparation outside each
timed interval are retained in the fixture.

These are public operations instantiated inside the GPUI unit harness, not
native-submit, CPU-raster, downstream-codegen or scanout measurements. Medians
below normalize each row by its operation count. A warm override operation
contains two complete override/acknowledge turns. The actual native gates and
downstream assembly check are separate verification boundaries.

| Operation | Initial change | Final inline → candidate ns | Final change |
| --- | ---: | ---: | ---: |
| Default mount | +2.7% | 3,627,998 → 3,305,193 | −8.9% |
| Two-style mount | −1.7% | 3,544,868 → 3,395,560 | −4.2% |
| Nine-style mount | −2.6% | 3,617,398 → 3,350,897 | −7.4% |
| Unique mount | −3.5% | 3,507,888 → 3,344,229 | −4.7% |
| Two-style equal description | +7.8% | 2,029,924 → 2,159,025 | +6.4% |
| Two-style coarse update | +8.3% | 2,009,495 → 2,214,477 | +10.2% |
| Nine-style equal description | +9.2% | 2,140,744 → 2,129,806 | −0.5% |
| Unique visual update | −0.9% | 2,853,337 → 2,884,336 | +1.1% |
| Counter exact action | +1.2% | 70,415 → 69,854 | −0.8% |
| Todo equal description | +10.2% | 47,508 → 47,387 | −0.3% |
| Workspace rotate | +4.6% | 41,488 → 42,781 | +3.1% |
| Library equal description | +11.3% | 26,650 → 27,743 | +4.1% |
| Library scroll | +3.4% | 18,281,094 → 18,348,422 | +0.4% |

First default/shared inspector mutation loses about 10–20% in the final capture;
the unique case is 3.0% faster. Warm mutations range from 0.4% to 2.5% faster.
All 25 cases, including equal/no-op controls and first-edit losses, remain raw.
These results support a storage tradeoff and some faster mounts, not a general
frame-time improvement. Palette discovery adds an exact comparison per probe;
the two-style repeated-description loss remains. An old-slot remap would need
its own lifetime, changed-style and performance evidence and is not in this cut.

The initial unit executable contained a 627 B outlined exact comparator that
decoded colors on each probe. Final exact comparison, getters, identity accessor
and builder are inlined there. The ordinary downstream release `counter` and `first_frame` consumers were
also built in distinct baseline/candidate targets. Neither candidate has an
outlined exact comparator, style getter, identity getter or per-node builder
symbol/call. The per-node builder explicitly permits cross-crate inlining. The unit binary
also includes additional invariant tests, so its aggregate code growth is not
reported as shipping application code growth.

## Reproduction

```sh
cargo test -p gpui --lib real_application_and_adversarial_distribution --release -- --ignored --nocapture --test-threads=1
cargo test -p gpui --lib retained_style_owner_memory --release -- --ignored --nocapture --test-threads=1
cargo test -p gpui --lib retained_style_cost --release -- --ignored --nocapture --test-threads=1
cargo test -p gpui --test retained_styles
cargo test -p gpui_canvas --test color_authoring
```

Use distinct Cargo target directories for the pinned inline and candidate
worktrees. Time the built executables directly in alternating order, with the
same CPU affinity. Do not compare interleaved builds. First-party unsafe remains
forbidden; no dependency or runtime transport was added by this representation.

## Verification and code cost

The final default GPUI + Canvas run passed 318 cases/doctests with no failures
(eight manual/measurement tests remained ignored). Strict `x11,wayland`
all-target Clippy passed. Actual Xvfb `:94` native Todo policy loops passed
(7.31 s), including pixel output, editing, pointer actions, inspection, resize
and suspend/resume. The actual 250,000-record Library wheel/pointer/resize/resume
gate passed (9.80 s). These are functional gates, not native performance claims.
The native test-only fixture imports share the existing Todo/Library modules to
avoid duplicate compilation; production native behavior is unchanged.

Both ordinary release examples execute successfully. Counter's full snapshot,
pixel digest (`1771a813ac7b1ecb`) and runtime counters match the inline baseline
byte for byte. Both `first_frame` programs produce 31 Todo and 116 Graphics draw
records in every iteration. Their untimed wall-clock output is not used as a
speed comparison. GNU section sizes show a code-size cost: Counter `.text`
2,609,271 → 2,616,359 B (+7,088 B, 0.27%); first_frame 2,688,935 → 2,698,551 B
(+9,616 B, 0.36%). Consumer executable hashes are in the provenance JSON.

Before the evidence files, the complete source/test diff against c3ae3584d4 is
1,131 added and 75 removed lines across ten files. This includes the 439-line
ignored distribution/allocation/timing fixture, 183 lines of style-lane unit
tests, 140 lines of public retained-style tests and 76 lines of public color
comparison tests. The new storage module has 151 lines before its test module;
existing runtime/list/property paths are adapted rather than duplicated.
No new dependency, platform API, unsafe block or public style/property type is
introduced. `Color::same_authoring` is the sole new public method. Frozen
presentation storage is deliberately unchanged; sharing presentation matrices
would need its own cohort ownership proof and evidence.
