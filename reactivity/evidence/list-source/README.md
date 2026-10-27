# Controlled list offsets: qualified local behavior

This slice adds `.scroll_offset(&Signal<f64>)` to the existing uniform list.
The registered source is the absolute requested position. Description clamps the
viewport without changing that source; wheel and public scroll operations write
the actual clamped position through the exclusive source bank. Uncontrolled lists
retain key-anchor behavior. This is a native workload prerequisite, not a speed
result or a claim to beat ZGX. All work remains local in isolated branches.

Base41acc60740f4; protocol4f1bc0c6aaf5; first production729fe1c7ae; qualified
productiona971ac3ccf; final production93f63b4a03. Test-only0ae34897d6 corrects the
native counter and adds allocation ledgers; d6b7f9a8e8 supplies the failing epoch
regression. Final test-onlyf6adc27955 makes each native wheel position explicit
before injecting it; production remains93f63b4a03. No dependency, vendor or generated shader changes, new unsafe, shared
mutable root, retained model/source pointer or external runtime were introduced.

Borrowed description resolves the signal through existing source/component identity.
Only its qualified FieldId survives. A closed safe numeric writer validates read/
write agreement and downcasts to Signal<f64>; it neither parses strings nor retains
a generic erased value. Nested wheel movements gather their ordered path, deduplicate
shared fields with last-write semantics, validate writers, then perform one source
barrier and ordinary Question refresh/owner repair. Applied-prefix faults use the
existing logical revocation policy. No unrelated source edit scans all lists: a
closed Owner fanout marker routes controlled fields to owner realization and removes
redundant sparse destinations only after all sinks have been admitted.

Known offset/index/retained-key input uses current geometry. A distant key needs an
unpublished borrowed description to resolve its index, followed by source write and
complete repair. Its extra description is charged. Epoch overflow now rejects
before that first description. An actual failing production-path test at MAX
proved the original candidate described twice despite rejection; the same test
passes with the guard and checks source, target, viewport and cohort preservation.

Full qualification:989 default and1063 X11 GPUI+Canvas tests, strict all-target
Clippy,8 native-port tests and11 actual native scripts. Public tests cover direct
source invalidation without another sink, component namespace, live rebinding,
wrong/unregistered projectors, finite/extreme/fractional/clamped positions, shared
fields, nested wheel residuals, scroll-into-view, index and distant-key input,
source->wheel->timer coherence, absolute position across prepend, removal and stale
authority, failed newer descriptions with eligible older ACK, and full pixels
against fresh windows. Native controlled/default/overscan250K lists exercise wheel,
source values, retained targets, resize/resume and server pixels. Source/remote/
Question/cancellation/Todo and both real D-Bus accessibility/IME scripts pass.
Software X11/Vulkan is correctness evidence, not physical GPU/scanout performance.

A fresh bounded negative removes only the Owner eligibility exclusion. The ordinary
public no-other-sink test fails at offset0 versus320. Initial fixture mistakes are
preserved: wrong writer admission already fails during update, logical revocation
returns StaleTarget, and native controlled wheel adds two source operations before
the click (three total). Assertions were corrected to existing semantics; no
production checks were weakened. The first native script's final bookkeeping
failure and clean source guard remain alongside corrected and final runs.

Costs: shipping36699->36962 (+263 lines). Optional boxed list settings restore
ElementExtra/LeafExtra64->56/48B and ListSpec56->40B; customized ListOptions costs32B.
ListState and ViewportState112->120B; transient ListPlan136->144B and ListDraft176->184B.
Node24, Presented64, El184, Draft160, ListRow32, Fanout32 and Runtime1824B remain.
Plain list descriptions cost56B/one request; overscan or controlled offset88B/two;
combined overscan/control/name128B/three. Existing first-list mount9644->9756 requested
and7364->7452 retained bytes across39 requests; ordinary viewport and warm scroll
ledger unchanged. A complete100K source fixture with two-row overscan mounts with
466 requests/179528B (both modes), retaining83600B unbound or83584B controlled. Its
16scrolls cost2127/801638B unbound versus2327/820239B controlled; controlled also
updates the text source and source epochs, so this is a feature bill, not equal-work
performance evidence. Headless counters exclude native/GPU buffers and allocator
metadata. Full four-mode raw allocation ledgers are retained.

Build-only native example ELF26281296->26305568B. List planner2178->2189B with local
stack reservation280B unchanged; row-style284B unchanged; present-walk25792->25808B
with local reservations4096+216 unchanged. These are prologues, not complete stack
bounds. This example still has positional rows and does not instantiate every new
controlled writer path; native unit Library does. Candidate SHA
 a888b6e154786bf62c8a2f9956c3f64113a8a678baafb16081543fac69f8a06a
is preserved. Earlier native unit executables and the epoch failure are separately
preserved by hash. One historical build-only example path was overwritten by final
compilation before preservation: its receipt/source/digest remain, its old ELF bytes
do not. No native execution, timing or machine comparison used that former ELF.
Completed cache removals and lossless test archives retain recovery receipts.

The next isolated example experiment uses the public controlled keyed list and
real offset readback before timer work, with a frozen positional pixel oracle.
Reference native wheel policy, deferred controls, native retained-count observability,
matched release profiles, text quality and two physical hardware classes remain
named gates. The BBTree/Solid transfer remains ordered gather/validate/publication
and distinct memory-latency yields versus real external-task wakeups. No noop
external-task polling or asynchronous mutable-owner borrow was added.

Run `python3 verify.py` for raw-file digests, clean guards, outcomes, preserved
executables and cost receipts. This dossier contains no timing campaign.

Reference input correction: the preregistration inherited an incorrect “wheel28”
note. At pinned a3678578980e, desktop/scrollers.rs step(None) is40 logical pixels,
with Linux desktop wheel-line settings scaling it; scroll_resample.rs enables
resampling by default.28 is the list row height. This does not alter any exercised
GPUI32px input or fixed14px timer test. Matching native wheel trajectories requires
both platform conversion and resampling, not merely a28px constant. The mistaken
protocol remains historical evidence; this correction supersedes that proposal.

Native test-driver correction: after the final full native gate, six inherited
scripts passed but the default Library script failed to queue its second frame.
The same ELF reproduced that failure with backtraces. Real X11 cursor events can
replace the scripted position between ACKs; the second synthetic wheel had omitted
its own CursorMoved. f6adc27955 supplies that position like the first wheel/click,
and adds the stage to the unchanged pending-frame assertion. Both failures and
clean guards are retained; the corrected actual suite is recorded separately.
