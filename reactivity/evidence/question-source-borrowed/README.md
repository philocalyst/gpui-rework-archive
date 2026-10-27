# Borrowed source cohorts for Questions

Rejected performance variant: the zero-static-label, two-field dependent control
exceeds the fixed 5% limit. No adoption, hardware win or ZGX claim.

This separate formulation keeps the by-value trial's complete four-source
invalidation semantics but borrows that fixed array for one synchronous earlier-
first Question refresh. No source-set or mutable owner borrow enters a worker.
External tasks retain real wakeups, request versions, cancellation and physical
teardown credit. Application APIs and persistent window fields are unchanged;
there is no generic executor, result cache or automatic atomic multi-output
transition. Source-only declarations unrelated to every admitted field can remain
Ready; Reader-input families still resolve against the updated dependency graph.
Owner/opaque/overflow/terminal changes retain coarse refresh.

719 default GPUI tests/doctests, 792 X11 tests/doctests, strict Clippy, all four
changed-field positions, tuple/diamond/A-B-A/fallback cases and six actual X11
scripts pass. A separate dropped-first-member mutant fails because its dependent
worker never dispatches. The previous-value/physical-credit guarantees survive.
No new production unsafe code. Correctness does not imply automatic Solid-style
atomic publication of all reactive outputs.

The complete baseline trial contains 240 fresh processes / 960000 settled
operations: enqueue 1/2/4 updates, deliver/record/ACK Pending when needed, then
deliver/record/ACK the immediate completion to reach the same Ready endpoint.
The Ready-result read/clone is included in both timers. Final independent fresh-
window pixels and exact dispatch/accept counters pass in all cells. Five
alternating pairs, CPU2, 200 warmups, 40×100 operations per process. No builds,
tests, allocator probes or source edits run during timing; full guards pass.

Primary unrelated two/four-field 1000-label ratios .05313/.05741 (18.8x/17.4x)
pass. The zero-label two-field dependent median 1.07654 fails, with pair range
.9508–1.1731. The prior by-value trial's losing 25-label dependent and 1000-label
owner controls are .98019/.97210 in this new baseline comparison. Those outcomes
do not erase either trial's failures or establish causality for code-size changes.

Three additional alternating pairs compare borrowed against the old owned
candidate on four preregistered cells, separately from the five-pair verdict.
Median ratios: 25-label two-field dependent 1.00108; 1000-label owner .97194;
unrelated two-field .98759 and four-field .99809. Except the owner case, paired
ranges cross one. This offers little evidence of a general borrowing speedup.
All output/task checks and source guards pass in those 24 extra processes.

All 48 separate allocation probes already matched the intended default build
hashes before artifact recovery; none were repeated to select an outcome.
At 1000 labels, unrelated two-field requests 9334→86, bytes 5043910→342511;
four-field 9363→122, bytes 5045324→344481. Every warm retained delta is zero.
One-field/dependent/coarse allocation records and Win wrapper sizes match exactly:
520 B unrelated/owner, 600 B tuple, 480 B opaque. Change is 24 B and transient
SourceEdits 40 B. Borrowing adds no heap allocation or persistent field.

Shipping inventory: 36697 lines, +5 over the owned candidate, +36 over its
source-batch base. Measured ELF is 10370632 B, versus 10371032 B owned and
10360664 B original control. Four delivery routines are 7369 B each, versus
7429 owned and 6705 original. Three refresh routines remain 3153/3153/3159 B.
These are linked/code-layout observations, not measured hardware-cache hits.

Native tests replaced Cargo's convenience cost-example path. Before timing,
artifact-pin restored the explicit default+simd build and bound its direct hashed
build/out executable. Its ELF hash matches the original first/artifact receipt
exactly. All allocation/default/native feature scopes remain explicit.

This AMD9950X KVM guest has variable host load, no render node and no permitted
hardware perf counters. Software-X11 correctness and recorder timings do not
establish native presentation/scanout latency. Cold owner/task creation and
whole-process maximum RSS, including pixel-oracle work, are reported separately
in raw/paired-cold-rss.json and raw/mechanism-cold-rss.json. Full CPU/wall tails,
raw samples, source/compiler/feature receipts, failures and assembly are retained.

| Static labels | Fields | Mode | CPU candidate/control | Pair range |
|---:|---:|---|---:|---:|
| 0 | 1 | unrelated | 1.01199 | 0.9731–1.0256 |
| 0 | 2 | unrelated | 0.40100 | 0.3707–0.4243 |
| 0 | 4 | unrelated | 0.56141 | 0.5331–0.6371 |
| 0 | 1 | dependent | 1.03193 | 0.9223–1.1425 |
| 0 | 2 | dependent | 1.07654 | 0.9508–1.1731 |
| 0 | 4 | dependent | 1.03192 | 0.8662–1.1603 |
| 25 | 1 | unrelated | 1.02040 | 0.9315–1.0579 |
| 25 | 2 | unrelated | 0.16846 | 0.1395–0.1794 |
| 25 | 4 | unrelated | 0.25554 | 0.2474–0.2642 |
| 25 | 1 | dependent | 1.02896 | 0.9418–1.0675 |
| 25 | 2 | dependent | 0.98019 | 0.9241–1.0819 |
| 25 | 4 | dependent | 0.97794 | 0.9639–1.0303 |
| 1000 | 1 | unrelated | 1.01581 | 0.9521–1.0893 |
| 1000 | 2 | unrelated | 0.05313 | 0.0480–0.0561 |
| 1000 | 4 | unrelated | 0.05741 | 0.0558–0.0598 |
| 1000 | 1 | dependent | 1.01060 | 0.9799–1.0860 |
| 1000 | 2 | dependent | 0.95983 | 0.9089–1.0493 |
| 1000 | 4 | dependent | 0.96397 | 0.9374–0.9718 |
| 0 | 4 | owner | 0.99214 | 0.9388–1.0841 |
| 0 | 4 | opaque | 0.99247 | 0.9877–1.0776 |
| 25 | 4 | owner | 0.94195 | 0.9345–0.9958 |
| 25 | 4 | opaque | 0.96092 | 0.8571–1.0584 |
| 1000 | 4 | owner | 0.97210 | 0.8803–0.9928 |
| 1000 | 4 | opaque | 0.96606 | 0.9635–1.0558 |

Base 6130ca4bb5d982be0505e90fe28a26e8c81874da; final source 1f1f2afe54e05d0e24d89417ca25bd6b5235477d. The actual measured commits, commands, compiler flags, feature/dependency fingerprints and immutable ELF hashes are in raw/artifact-pin and raw/paired/metadata.json. Run `python3 reactivity/evidence/question-source-borrowed/verify.py` to independently reconstruct the verdict.
