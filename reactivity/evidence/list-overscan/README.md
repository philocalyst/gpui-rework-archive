# Optional keyed overscan: qualified local behavior

The native comparison needs ZGX's two-row keyed buffer. GPUI's existing uniform
list had zero overscan and discarded invisible row identities. This isolated
slice adds `.overscan(usize)` with default0 and keeps the existing constructor.
It is a behavior prerequisite, not a speed result or competitor victory. All
changes remain local; the original archive and remote branches are untouched.

Base49f2221f8f2; protocol9dfef6b74b; first source840252bc5a; clipping correction
efe11b9df4; complete default/native gates48e73461ce. Finalf760f319d9 adds only
cost-ledger output and documentation; its focused native ledger and Clippy pass.
Shipping sources are unchanged after efe11b9df4; later edits are tests/docs.

Visible and realized ranges are distinct. Requested overscan expands the latter
with saturating/clamped arithmetic; actual realized rows still cannot exceed4096.
All realized key/index agreement is validated before any row description. The
first visible key anchors edits. Materialization starts at realized.start and
uses local rebased coordinates. The source remains a borrowed coherent snapshot.
No full catalogue, historical identity table, new unsafe or dependency is added.

Opt-in buffering retains keys while their rows stay realized. Offscreen actions,
queries and focus still obey existing candidate visibility authority; a buffered
row returning to visibility can reuse its target. Leaving the buffer permanently
retires it. Default zero overscan retains the previous visible-only policy.
Logical buffered slots receive empty paint/input clips before geometric lowering.
This matters at exact boundaries: outward conservative envelopes otherwise create
small spurious semantic slivers. No epsilon or reduced geometry precision fixes
that error. Existing row/viewport coordinate and transform limits still apply.

Qualification:974 default and1048 X11 GPUI+Canvas tests, strict all-target Clippy,
8 native-port tests and10 actual native scripts. Public tests cover a lazy250K
source, visible/realized bounds, fractional/end offsets, usize::MAX clamping,
4096 admission before row work, buffered malformed keys, first-visible anchors
across prepend/reversal, identity/authority/focus, failed newer descriptions with
older eligible ACK and recovery. Complete pixels match zero-buffer fresh windows
and independently materialized eager rows; keyed bounds are checked separately.
Native accessibility projection excludes buffered rows, freezes old P until ACK,
and reuses returning IDs through AccessKit Consumer. Actual default and overscan
250K native scripts validate wheel/pointer, resize/resume and server-pixel equality.
Source/remote/Question/cancellation/Todo and two real D-Bus/AT-SPI IME scripts pass.
Software X11 and Vulkan do not establish physical GPU or scanout performance.

Fresh negative5263081eb5 materializes realized keys from visible.start. It passes
the independent image-only oracle: displayed content can be correct under wrong
keys. That inadequate standalone negative is preserved. The SAME immutable binary
fails both public buffered visibility/target authority and keyed bounds-vs-fresh
oracles. The combined identity and image checks therefore detect the error without
altering the mutant or relaxing correctness. Initial candidate boundary failures,
geometry diagnostic snapshots and exact allocation-ledger corrections are retained.

Costs: shipping36657→36699(+42 lines). ListSpec48→56B, ElementExtra/LeafExtra56→64B;
ListRow32B, Node24B, Presented64B, El184B, Draft160B, Runtime1824B and ListState112B
remain unchanged in the native ledger. Current transient ListPlan136B/ListDraft176B
are charged. A plain semantic or list description requests64 rather than56B;
combined list/name120 rather than104B. Default-list mount requests9644 rather than
9604B across39 requests, retained7364B unchanged. The existing ordinary viewport
and warm-scroll ledger is unchanged; these fixtures do not isolate every buffered
row's allocation or provide performance adoption evidence.

Native port ELF26281592→26281296B, list planner2078→2178B with local prologue stack
reservation248→280B; row-style284B unchanged. Present-walk25843→25792B, local
reservations4096+232→4096+216B. Whole ELF shrink is not a general code/stack win;
prologue reservations are not complete call-stack measurements. Example ELF SHA
c25b253b39b722334e5b4346294c3112abd55e764c422fe9e6ab87b5f62fa80e is preserved.
Native test ELF used by scripts was copied by content hash before later unit
rebuilds. Completed caches were pruned and test binaries losslessly archived with
recovery receipts, preserving measured executables and source/evidence.

Next: controlled source offset with actual wheel writeback before UI ticks,
reference wheel line28, deferred controls and matched profiles. The native lab
still uses positional rows until controlled list integration; this slice alone
does not claim its native workload has become equivalent. Text edge/quality and
two physical hardware classes remain gates. The BBTree/Solid research still calls
for gather/validate/ordered publication and distinct memory-yield versus real-task
readiness; overscan is prerequisite behavior, not a new asynchronous executor.

Run `python3 verify.py` for file, source-guard, outcome, native-script, mutant,
executable, symbol and cost verification. No timing campaign was run in this slice.
