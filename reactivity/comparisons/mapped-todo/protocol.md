# Separate mapped-source Todo experiment

This is an unadopted API experiment on exact core commit
`0062bf589829c4f28807ad0fde3e13285379294c`, with fixture commit
`739c074f1dbd07d35d976fb64cd33a9c15030051`. It does not alter the frozen
five-application capture at `7adac78cc2` or adopt the mapped API into Main.
The later color fast path and subsequent implementation-cost successors are absent.

The mapped fixture retains the ordinary Todo model, editable draft, add, complete,
filter, delete and undo operations; eager 10,000 Heavy / 1,000 Animation rows;
540×620 geometry; Noto Sans; 31-bit revision plus parity marker; normal X11 and
accessibility capabilities; deadlines, bounded animation inbox, and first-present
clock epoch. One 32-byte Frame in a 36-byte Signal feeds 32 marker color sinks and
one list transform through Source, map/map_with and with_inbox_for. Domain input
callbacks still use ordinary model invalidation. Description counters distinguish
owner/row construction from renderer preparation and drawing work.

Every performance row requires the unchanged ordered callback and canonical full
model checks, actual targeted drawable changes and revision acknowledgments,
normal close without escalation, complete measurement interval, source and ELF
guards, and final independent header/compose-field/background pixel anchors.
Animation additionally requires zero scheduler skips, expected delivered updates,
the independent host-receipt audit (at least floor(60×duration)−2 receipts, exact
window subset, monotone timestamps and no observer overflow), and zero mapped
owner/row descriptions after first present. Host receipts establish a host drawing
or submission boundary; neither receipt counts nor readback establish scanout.

Actual native preflights precede longer captures. Forced-GPU mapped Animation
failed the six-second delivery and host-receipt gates. Strict two-second Heavy
input deadlines failed for mapped GPU and both Auto variants, despite a slower
full eight-event Heavy semantic/paint qualification passing. Those failures remain
raw evidence; no 30-second rows are substituted for these profiles.

The registered conditional schedule is three repetitions of mapped forced-GPU
Idle and Busy (30 seconds after 5 seconds warmup) and warm host-boundary Startup;
plus three matched same-core mapped/control Auto pairs for Busy and Animation
with the same windows. Mode and application order alternate by repetition.
Policies are separate. No Auto Heavy or GPU Animation performance median is
reported. All 21 scheduled outcomes are retained, including failed outcomes.

CPU is process CPU including software-renderer workers, with 100% representing
one logical core. Memory uses sampled process PSS/RSS/private pages. Xvfb and
observer costs are outside process CPU; readback is part of this fixed protocol.
The host is headless llvmpipe: hardware GPU utilization and physical smoothness
are unsupported. Startup is warm external spawn to first host receipt, with final
visible chrome checked separately; it is not visible-UI startup latency.

Fault qualification includes suppressed callbacks with hover, stale marker,
duplicate updates, observer overflow, missing first receipt, TERM-handled zero
exit, and actual native backend present starvation. The latter original-runner
false-positive must be rejected by the independent host-receipt audit. These
controls and the mandatory historical six-failure archive audit are required.

Separate six-second perf_event_open diagnostics use owned child threads and user
CPU-clock samples without changing kernel policy, source, or ELF. They are never
pooled with performance rows. Anonymous executable samples returned through
libvulkan_lvp worker frames; this alone does not name a shader stage. An optional
bounded read-only snapshot is limited to the owned child's hot anonymous RX
mappings (8 MiB maximum); errors stop reads and no policy changes are attempted.
