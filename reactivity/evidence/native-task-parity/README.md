# Deferred native workload controls — qualified prerequisite

Local port-only change, not a performance victory or adoption of the rejected
sparse-repair trials. Preregistered7478ef16ec97be1984106498f078d9286f2a1a2c;
implementation8de61164f7b163eda62843206e56b2a4ab50c3c9 on corrected original
bb83c5d8f3da446d4cc1c259141f335797b1b60d. No GPUI application API or library
production source changes. All changes remain local.

Pinned ZGX a3678578980ef239058c557338ef9c544d356b0c schedules + and = through
UI tasks which yield once, then batch their mutations. Its third control sets999
immediately. The old port performed all three synchronously. This port now keeps
an owned FIFO of the two known operations; one coalesced Remote wake drives each
poll snapshot. The first poll yields, and a later frozen inbox delivery applies.
Task submission is not capped; list capacity remains4. No operation is discarded
when the capacity-one wake is already queued. New operations queued between polls
must themselves yield while older ready operations can finish. Closing the owner
revokes delivery and drops pending operations. This is a specialization of these
finite workload operations, not a general async executor or evidence of cache hits.

The model remains exclusively borrowed on the UI thread. The existing exact
stream inbox remains a separate lane. A later deferred operation can overwrite
an intervening immediate999, matching the reference's behavior; it does not gain
unrequested latest-result suppression or Solid-style reveal semantics. Solid and
BBTree research informs explicit publication/scheduling boundaries, not a silent
change to the application's observable contract.

## Qualification

Seventeen public-interface port tests pass: all ten previous tests plus seven
scheduling/storage tests. They check click/first-poll/second-poll visibility with
an unbounded delivery budget, FIFO and interleaving, wake coalescing, immediate999,
empty rewrite, capacity4 partial append, close before either poll, rejected late
wake and replacement-owner isolation. Exact CPU pixels are checked against a
fresh independently populated owner with matching focus. Exact stream delivery
coexists with deferred control work. Strict all-target X11 Clippy passes.

Full X11 and minimal-native examples build; minimal example Clippy passes. Each
preserved native executable passes a real private-X11 control script: empty =,
+, =, +, immediate999. The13 trace rows require queue→yield→apply ordering and
expected lengths/status values, then a final presentation ACK and normal exit.
The full build includes accessibility; the minimal build does not. No claim is
made that this script reads the unrendered first item's value; public Win tests
check that value directly. Generated WGSL is verified inside both executed ELFs.

Fresh isolated mutants prove the intermediate-state witnesses: synchronous apply
fails “click must only enqueue”; skipping the initial yield fails “first poll must
yield”. Both fail the intended runtime assertion, not compilation. Source guards
are clean for positive, negative and native runs. Core production qualification is
explicitly inherited from the corrected original, with exact source equality;
this is not a claimed full core-test rerun.

## Charged costs and preserved failures

The application model is128 bytes; its new Controls field is48 bytes. Each queued
operation is2 bytes. Remote is8 bytes and Inbox24. Creating the wake lane requests
one120-byte allocation, retained while its capabilities live. Growing to64 queued
operations requests248 bytes over5 allocations and retains128 bytes/capacity64.
These are invoking-thread allocation observations, not whole-process/driver memory.

A yield-only delivery incurs one owner rerun, one description, one coarse source
operation and103 destination comparisons. It incurs no layout, measure, paint or
presentation in that public test. This is real framework overhead, not free async
work. The additional native lane and queue are part of future complete-app costs.

Shipping first-party core remains36956 lines (examples/tests excluded). Full native
ELF26339472 bytes versus corrected original26306384 (+33088); minimal native ELF
20527656 bytes. Selected caller/control function sizes, local stack reservations
and complete section sizes are in raw/candidate/machine.json. Local reservations
exclude pushes/callees/driver stacks. No dependency or shader change.

Two initial native harness attempts are preserved as failed: the full trace reached
all13 rows, then target-specific Alt+F4 sent a key release to a destroyed window;
the minimal attempt observed an ACK before the window became visible. A corrected
harness polls visibility with a deadline, uses global XTest keys on private :94,
and waits for the final ACK before closing. The same frozen application ELFs pass.
No production code or behavioral oracle was changed for these harness corrections.

A fresh synchronous-mutant build briefly reduced free space below the repository's
8GiB floor (observed7.6G). No timing was running. The incident and cleanup attempts
are retained. After restoring space, the exact preserved mutant was rerun and failed
the same intended assertion. Additional verified compiler-module archives restored
more than12GiB before the independent skip-yield build. Completed-target cache
removals preserve sources, evidence, generated shaders and all executable identities;
compiler modules are retained as SHA256-verified gzip archives. No measured global
executable was deleted.

This closes the workload's deferred-control scheduling gap. Wheel normalization/
resampling, rendering-quality equivalence, equal profiles and physical-hardware
comparison remain open. The earlier sparse-repair/static-submission complete cost
gates remain failed; no successful subset or new ZGX ranking is claimed.


The first dossier-verifier attempt used repository-relative diff pathspecs from
the nested dossier directory and failed its changed-file assertion. Its code and
failure output are retained. The corrected verifier resolves the repository root
before Git source checks; no application code, raw results or thresholds changed.

Run `python3 reactivity/evidence/native-task-parity/verify.py` to check the manifest,
source boundaries, tests, native traces, failed attempts and preserved artifacts.
