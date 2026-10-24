Mapped property outlining: isolated, unadopted successor

Final source: a89fc0241aa32cbf7db9bcd62983bb943f186028
Source precursor: 653167d141d24219d23a0d78ef997ea786269265
Frozen original source: 0062bf589829c4f28807ad0fde3e13285379294c
Frozen original evidence: 51a5fc839632aa78d88062e86f4410a38012172a
Worktree /tmp/gpui-mapped-properties-outline-sol, branch spike/mapped-properties-outline-sol.
Only runtime.rs and semantic.rs changed. No API, retained field, allocation,
unsafe helper, Canvas, native or paint.rs changes. No Main changes or benchmark
jobs by this implementation slice. Source0062 and its comparison remain intact.

Outcome and limits

This bounded refactor shares erased source/mapping mechanics and removes actual
recursive decoration decomposition. Compared with0062, the ordinary native
Counter executable .text is 2,544 B smaller and whole ELF 10,920 B smaller. Most of
the whole-file reduction is readonly data, not removed executable instructions.
The mapped native application has a smaller whole ELF but executable .text
GROWS 3,744 B. Remaining ordinary code/frame costs are charged. This is not a
zero-cost API, a total peak-stack improvement, a speed claim, or adoption approval.

Code structure and invariant review

- Concrete noninline Fanout::freeze accepts the existing borrowed &dyn Any,
  computes direct needs, freezes once, evaluates every map into retained scratch,
  and validates ALL mapped/direct outputs before its caller can mutate a sink.
  The source remains borrowed only for the existing Frozen text lifetime. No
  generic model work, additional dynamic dispatch or source identity is added.
- Concrete noninline Fanout::map admits MapDraft recipe/value and inserts the
  owned recipe at the existing heterogeneous fanout boundary. Source authority
  resolution stays with typed Sources<M>. Recipe errors still precede value
  computation. The new description fanout is unpublished local state on error.
- Fanout::finish_description shares stable-slot discovery and normalization.
  One concrete local closure registers mapped destination slots separately and
  same-source direct Color destinations through their one identity slot. Direct
  destinations sort before discovery; mapped scratch is still overwritten in
  sorted record order on every patch before any value consumer can observe it.
- MappedFanout::publish_colors runs ONLY after every comparison and inspector
  base update sees the old bank. It publishes disjoint mapped output slots and
  the one shared direct slot exactly once, using admitted cached values only.
  No mapper/validator is called after writes. Changing slot publication order
  is unobservable: slots do not alias and no callback/observer runs between them.
- The merged destination iterator uses three borrowed slice cursors, eliminating
  nested Peekable/flat_map state and cached large result tuples. It preserves
  ascending packed destination order and last_changed grouping. Records and
  scratch always have equal length by construction; no new storage is retained.
- ElementExtra::into_parts initializes one result and iteratively unwraps the
  normalized mapped layer. It no longer recursively returns another large
  aggregate. An exhaustive constructor search found only bind_map creates a
  Mapped variant, and it refuses to wrap an existing Mapped. Decorations' leaf
  base cannot contain ElementExtra. Thus the existing single-layer invariant
  holds; overwrite/drop/release behavior remains covered by existing tests.

The noninline boundaries are intentional shared erased operations and are hot
when maps are hot. They are not annotated cold. Typed public Model/Source/View,
closed properties/validators/impacts/reflection, purity law, source authority,
Reader gates and presentation ACK laws are unchanged. No new behavioral tests
were invented for this refactor; the existing public/adversarial tests are the
gates, including the actual fault controls retained in the original dossier.

Functional and allocator qualification

Final source a89: 634 passed, 10 ignored, 69 harnesses including docs; default all-
target Clippy -D warnings passed. Allocation/description cohorts passed again.
The initial 653 precursor also passed 183 focused tests / 5 ignored with exact guards;
653 was archived but NOT built/measured in the matched release cost experiment.
Both final mapped and description metric streams exactly equal 0062 (13 + 9 lines),
including ordinary literal/direct allocation floors and every retained header.
Ordinary Destination 4 B, Binding/Draft 24 B, Fanout 32 B, ElementExtra 56 B remain unchanged.
Mapped33 fanout 2,068 B; first/warm private property patch 0 allocations; 4,094 unique mapped
colors 0 allocations/retained growth; 10k unrelated direct-color rows retain O(1) tick.

The graphics limit is unchanged: one visible mapped color in that 10k-row cohort
requests 1,215,456 B in 15 allocations for full scene preparation, despite the private
propertypatch being allocation-free. Root's paint followup is not present here.

CostSol independently ran the EXACT a89 native ReferenceCpu ELF: one Frame 32 B /
Signal 40 B update reached source/presentation epoch 1 with 0 owner reruns, 0 row rebuilds
and 1,000 initial rows. This is a real native ACK/counter gate, not native pixel or
inspector instrumentation. Those laws remain covered by public recording/private
core tests; Root's separate paint tests/composition are outside this source pin.

Exact same-path release cost experiment (CostSol)

See verbatim a89-implementation-cost-review.txt and paired-costs.json. All three
pins were freshly built sequentially at the same physical source path, same
cache/toolchain/config and offline locked release, x11/native/accessibility,
nightly 7189 / Clang 21, debug 0 / incremental 0 / jobs 2. No custom optimization flags or
remote timing. Six fresh ELFs and sourceguard pairs were verified; all remote
jobs were reaped before the lease returned to benchmark work. Implementation
agent did not run remote jobs. Raw artifacts remain at
/tmp/gpui-mapped-cost-sol-successor-653-evidence (folder retains the 653 archive,
but measured-successor-pin.txt identifies a89). Original0062 cost evidence remains
untouched at /tmp/gpui-mapped-cost-sol-evidence.

                                  Main7df      original0062     a89
Counter ELF bytes                 23829320       23851320       23840400
Counter executable .text          10890432       10906512       10903968
Counter .rodata                    5852992        5853248        5843136
Mapped ELF bytes                  23865456       23898832       23893760
Mapped executable .text           10899632       10917552       10921296
Mapped .rodata                     5853120        5853376        5843392

Ordinary code bytes / maximum fixed CFA:
                                  Main7df      original0062     a89
after_source_changed              8002/1104     10213/1728      9862/1216
describe_inner                   30998/2320     33837/2480     31853/2336
ElementExtra::into_parts           1200/240       2137/576       1738/288
flatten_lists                     9406/1968     11423/2096     11455/2096

Outlined helpers code/CFA: freeze 1533/320, map 836/288, finish_description 1488/176,
publish_colors 313/144. These callees can be live with caller frames; reduced root
CFA DOES NOT establish smaller total peak stack. Residual ordinary CFA versus 7df
is +112/+16/+48/+128 for the four listed functions. Ordinary description still
calls common finish_description; its 176 B frame is not free. Actual CFI shows the
old into_parts self-call and no self-call in a89. No surviving standalone optimized
builder symbol exists, so no builder frame was inferred from source layout.

Source charge

Existing qualified Syn/Tokei six-library counter: 32269 lines; unchanged shipping
helper 50 => 32319 all-shipping non-test/non-comment lines. This is 3 fewer than
0062 and +505 versus adopted Reader Main7df 31814. Helper/build/manifests/tests are
unchanged. Per-file final count and counter identities are preserved. This small
source decrease is reported independently of executable code/readonly costs.

Evidence integrity

Final build/test/allocation/strict sourceguard before/after covers all 11,444
tracked/unignored reactivity files (target ignored); exact equality. Evidence-only
files were added afterward. evidence-integrity.json checks every frozen path hash
against that run. Final test lib/public ELFs are retained externally with hashes
in final-elf-index.json; native ELFs are retained by the independent cost dossier.
The original helper/Miri qualification remains applicable because its bytes are
unchanged; no new unsafe operation or Miri rerun was added by this slice.

Commands (local native/nightly envs, CARGO_BUILD_JOBS=2,
CARGO_TARGET_DIR=/tmp/gpui-mapped-outline-target):
  cargo test -p gpui -p gpui_inline_call --offline
  cargo test -p gpui --lib mapped_qualification --offline -- --nocapture --test-threads=1
  cargo test -p gpui --lib decoration_tests --offline -- --nocapture --test-threads=1
  cargo clippy -p gpui -p gpui_inline_call --all-targets --offline -- -D warnings
See sourceguard.py, compressed logs, raw counts and manifest.sha256.
