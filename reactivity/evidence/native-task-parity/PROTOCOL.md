# Deferred native workload controls

Preregistered before implementation. Port-only prerequisite on the corrected
original control bb83c5d8f3da446d4cc1c259141f335797b1b60d, not adoption of either
failed sparse-repair performance trial. Keep source/owner workload generation,
font/typography/overscan/scroll offsets and existing tick pacing unchanged.

Pinned ZGX a3678578980ef239058c557338ef9c544d356b0c: component_workload's + and =
handlers spawn UI tasks, await yield_now, then batch their list/done mutations.
The third control sets999 synchronously. LocalExecutor::tick snapshots ready work;
each ready task is polled at most once per tick. yield_now returns Pending once,
posts a wake and becomes Ready on the following poll. Window close cancels tasks.
Current GPUI port applies all three controls synchronously, so it is not equivalent.

Use existing public GPUI interfaces, not a new general executor or library change.
A UI-owned FIFO records the two deferred control operations. A capacity-one Remote
wake coalesces scheduling signals without dropping operations. Each delivery polls
only the entry snapshot: unyielded operations advance to yielded and request a
later wake; already-yielded operations apply in FIFO order. deliver_ready freezes
its inbox batch before callbacks, so the self-wake cannot be consumed in that same
delivery. The operation queue is not artificially capped: reference task submission
is unbounded. Charge its capacity and the additional application inbox/model state.
Do not confuse list capacity4 with task capacity. No Rc/Cell/RefCell or unsafe.

Keep the ordinary complete-workload model mutations on the UI thread. Preserve
exact stream ingress as a separate lane; deferred controls use an owner lane.
No asynchronous worker may mutate the model. Closing the window revokes delivery
and drops pending owned tasks; sending wakes after close must report Closed.
No stale task may be routed to a replacement window. Internal owner reruns or
inbox allocations are charged behavior, not assumed equal to ZGX's runtime cost.

Required tests through public Win/Remote/click interfaces: no effects at click or
first delivery; effects at second delivery even with a large delivery budget;
FIFO/interleaved submissions; immediate999 between polls; one coalesced wake for
multiple tasks without loss; empty = error; capacity4 partial append semantics;
close before first/second poll, late sender rejection and independent replacement
owner; coexistence with exact stream ingress and exact final state/pixels against
a separately constructed expected owner. Preserve all ten existing port tests.
A synchronous-control mutant must fail the new intermediate-state witness; a
skip-yield mutant must fail the first-delivery witness. Both fresh isolated source
worktrees/targets and source/ELF receipts; no changes to the positive source during
its own build/test/source-guard gates.

Run locked/offline release example tests, strict Clippy, native X11 example build
and an actual-window control script, plus minimal-native build/check. Native trace
may expose test progress when explicitly enabled; normal user-facing flows stay
unchanged. Record cold app model/inbox/capacity costs. Library production source is
unchanged; inherit qualified core tests explicitly via source equality rather than
claiming a full rerun. Preserve exact generated shader and executable identities.
No timing/adoption or ZGX/hardware/cache-hit claim is part of this prerequisite.
Wheel resampling, render quality, equal-profile and physical-hardware comparison
remain open. Keep all changes local and seal a verified dossier before composition.
