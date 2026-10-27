# Precise source cohorts through the existing Question graph

Disposition: rejected performance variant. The unrelated-update gains are large,
but two control medians exceed the preregistered 5% limit.
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

CPU verdict: primary ratios .05558 (18.0x) / .06011 (16.6x) pass;
25-label dependent two-field ratio 1.05394 and 1000-label owner-dependent
four-field ratio 1.05134 fail. These are narrow numerical failures with broad
paired uncertainty, not proof of a particular hardware cause. No runs were
discarded or rerun to select a passing outcome. A separate borrowed-set variant
will test whether reducing the larger by-value Change representation helps.

Paired uncertainty and scope: Five alternating process pairs per
24 cells, pinned CPU2, 200 warmups and 40×100 complete settled operations. No
compilers, tests or allocator probes run during this stage. This is an AMD9950X
KVM guest with shared host noise and background environment capture; raw process
receipts preserve that limitation. No /dev/dri, software Vulkan only; documented
remote hardware remains unavailable. Neither recorder timings nor these six
software-X11 scripts establish superiority over ZGX on equivalent real hardware.

| Static labels | Fields | Mode | Candidate/control CPU | Pair range |
|---:|---:|---|---:|---:|
| 0 | 1 | unrelated | 1.04222 | 0.9290–1.2540 |
| 0 | 2 | unrelated | 0.39603 | 0.3570–0.4263 |
| 0 | 4 | unrelated | 0.57732 | 0.4976–0.5983 |
| 0 | 1 | dependent | 1.01714 | 0.9483–1.0696 |
| 0 | 2 | dependent | 1.01681 | 0.9686–1.0986 |
| 0 | 4 | dependent | 0.98468 | 0.8963–1.0456 |
| 25 | 1 | unrelated | 0.96028 | 0.9049–0.9875 |
| 25 | 2 | unrelated | 0.18270 | 0.1662–0.1905 |
| 25 | 4 | unrelated | 0.26917 | 0.2647–0.2823 |
| 25 | 1 | dependent | 1.03037 | 0.8879–1.0630 |
| 25 | 2 | dependent | 1.05394 | 0.9988–1.1057 |
| 25 | 4 | dependent | 0.99596 | 0.9609–1.0364 |
| 1000 | 1 | unrelated | 1.00890 | 0.9426–1.0917 |
| 1000 | 2 | unrelated | 0.05558 | 0.0522–0.0586 |
| 1000 | 4 | unrelated | 0.06011 | 0.0550–0.0629 |
| 1000 | 1 | dependent | 1.04751 | 0.9287–1.0868 |
| 1000 | 2 | dependent | 0.98418 | 0.9235–1.0236 |
| 1000 | 4 | dependent | 1.00355 | 0.9836–1.1339 |
| 0 | 4 | owner | 1.04043 | 0.9860–1.1260 |
| 0 | 4 | opaque | 1.01892 | 0.9543–1.0566 |
| 25 | 4 | owner | 1.01318 | 0.9695–1.0240 |
| 25 | 4 | opaque | 0.99900 | 0.9610–1.0558 |
| 1000 | 4 | owner | 1.05134 | 1.0176–1.0900 |
| 1000 | 4 | opaque | 1.01942 | 0.9542–1.0466 |

Measured candidate fd13116e55071733e397a9fcc9b7d8f6834a9cd5; identical control b0e8e37a2115adac044c618a5bb0b33e8e2fa833. Production is 8679d1aaa0a45ccddab061cfca093a445fde889c; later commits only add/correct fixtures and coverage. Native qualification uses e159b394c0843df03a38751c65bce1bece30a2e6; full-capacity test/doc qualification uses 6130ca4bb5d982be0505e90fe28a26e8c81874da. All source/compiler/ELF receipts, failures, exact commands, raw batches, cold/RSS, allocator probes, symbol tables, assembly, native outputs and the negative witness are under raw/. Run `python3 reactivity/evidence/question-source-set/verify.py` to recompute the verdict.
