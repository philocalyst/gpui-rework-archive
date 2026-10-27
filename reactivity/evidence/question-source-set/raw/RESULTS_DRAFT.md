# Precise source cohorts through the existing Question graph

Disposition: correctness-qualified; preregistered CPU comparison is in progress.
No competitor/hardware claim or implicit adoption. All branches remain local.

The previous multi-source transport preserved exact fields for text sinks but
collapsed several changed fields to an unknown source when refreshing Questions.
An unrelated settled task could therefore be cancelled/restarted, causing Pending
and Ready owner publications for an update that did not affect any of its inputs.
The candidate carries the complete bounded four-field set through one earlier-
first graph refresh. Known unrelated source-only declarations are skipped; Reader
inputs still resolve against the updated preceding dependency graph. Dependent
families freeze once from final owner values. Owner-dependent, opaque, terminal
and overflow batches retain coarse invalidation. If no Question projection changed
and no response was accepted, the existing disjoint text certificate can publish
without describing the owner. Application View/Source/Reader/Question APIs are
unchanged; the private Change representation gains a Sources variant.

This applies the useful overlap between BBTree's batch authority and Solid's real
data-dependency model. It does not introduce a generic async scheduler, a result
cache, or automatic atomic multi-output transition groups. External waits retain
real wake/cancellation/teardown credit; no noop-waker busy polling. Prior tree-lane
experiments tested memory-yield Futures independently and did not pass their
no-regression gates. Skipping an unrelated task is different from making a cache
miss hit, and hardware cache counters are unavailable here.

Correctness: 690 default GPUI unit/integration tests plus 28 doctests; 763 with
X11 features plus 28 X11 doctests; strict Clippy. A later test-only revision covers
all four changed-source positions (seven source-set tests pass again). Both
children of a batch diamond dispatch once; its join cannot freeze after just one
child becomes Ready, and old joined content remains visible until settlement.
Tuple/A-B-A, cancellation credit, opaque/owner/overflow paths remain covered.
A separate mutant dropping the first changed member fails on the missing actual
worker dispatch. All six actual private-X11 scripts pass, including source and
remote delivery, producer shutdown, Question wake, Future cancellation and Todo
interaction. These scripts qualify composition, not a new native performance win.

The first fixture build used the wrong explicit recording Question transport
return type. Both candidate and identical control failed to compile; both were
corrected with an inferred LaneSet. Those failures and full before/after guards
are preserved. Production code was unchanged during fixture corrections.

The public cost fixture enqueues 1/2/4 typed updates, delivers/records/ACKs them,
then delivers the immediate task result and ACKs if one was applied. Thus both
versions reach the same settled Ready result, not Pending versus Ready. Starters
complete through the existing mailbox and never poll the UI reentrantly. Each
step also reads the Ready result for an endpoint assertion (including its clone
cost in both variants). Final fresh-window pixels/model/result are exact, outside
timing. Source epochs and intentional task/publication counts differ; final
output must not. All 48 correctness preflight processes pass; those timings are
excluded because compilers were active.

Separate allocator instrumentation reports all 48 cells. At 1000 labels,
unrelated two-field requests 9334→86 and requested bytes 5043910→342511;
four-field 9363→122 and 5045324→344481. Warm retained delta is zero in every
cell. Single-field, dependent, owner-dependent and opaque counts/bytes match
exactly. Concrete Win wrapper sizes match: 520 B unrelated/owner, 600 B tuple
input, 480 B opaque. Cold recording-owner/task creation is reported separately.
The source set was already transient in the base; no persistent window field was
added. Private Change's by-value representation and any spills are code-generation
costs, not claimed to be zero. No measured stack-size claim is made.

Shipping inventory is 36692 lines, +31 over the 36661-line source-batch base.
The linked cost ELF grows 10360664→10371032 B (+10368). Four inspected
monomorphized delivery routines grow 6705→7429 B each; three inspected Question
refresh routines remain 3153/3153/3159 B. Full symbol tables and targeted assembly
are retained compressed with the measured ELF hashes. Library/helper APIs and
machine-code costs are separate from source lines.

CPU verdict and paired uncertainty: PENDING. Five alternating process pairs per
24 cells, pinned CPU2, 200 warmups and 40×100 complete settled operations. No
compilers, tests or allocator probes run during this stage. This is an AMD9950X
KVM guest with shared host noise and background environment capture; raw process
receipts preserve that limitation. No /dev/dri, software Vulkan only; documented
remote hardware remains unavailable. Neither recorder timings nor these six
software-X11 scripts establish superiority over ZGX on equivalent real hardware.
