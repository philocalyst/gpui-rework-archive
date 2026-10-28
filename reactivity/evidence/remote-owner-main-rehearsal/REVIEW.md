# Rehearsal review

Base f102ef111c7214c7ace900f76a74c9d3e7ca14e2; exact independent source
d198075bbc604a06ac75c1f84261f9601687c90b. Only nine gpui files change, from
e62a4ae5ae..2aec8e8f5b. No source tuning or whole-ancestry cherry-pick.

All eleven native accessibility files are byte-identical to Root's base.
NativeHost::accessibility_work and ::retire_window bodies remain byte-identical.
The producer, Question and delivery modules match the frozen candidate exactly;
the corresponding base modules match the frozen control exactly.

Status delivery rejects zero capacity because nonblocking zero-capacity receive
cannot progress. Ordinary message lanes retain their old zero-capacity behavior.
Producer fields drop sender before Notification, so final wake observes real
disconnection. observe_close's temporary strong reference covers binding/drop;
attach's temporary reference covers wake install/drop. Failed Weak upgrade still
signals the owner's Wake to stage buffered data/terminal. Closed inboxes skip
attachment. A live clone prevents terminal; final data precedes exactly one
budgeted None. No public finish ceremony, extra queue/worker or blocking sender.

The receiver Option marks disconnection. The existing capacity marks terminal
consumption before invoking the callback, preventing a second None. Panic enters
the ordinary owner quarantine; close retires every lane and suppresses rearm.
The public FIFO/round-robin, clone/zero-budget/zero-capacity, callback panic,
Question supersession/credit and zero-per-message-allocation controls apply.

NativeHost consumes Delivery.more once after handling the owner result. Stale
Question receipts with applied=0 return a successful unchanged Commit, so their
bounded turn can rearm. Applied model/Question changes advance S before derived
projection; recoverable derivation failure therefore preserves Delivery and
passes the S-advanced recovery branch. The native tests exercise failed
projection followed by a later buffered repair. Poison and maximum epoch clear
more; closed/no-owner/fatal paths stop. Root's accessibility action loop still
handles each outcome before borrowing its next command; its separate sixteen
command budget and wake remain intact. Controller::signal still handles actual
asynchronous Question completion/credit. LaneSet::signal traversal is removed.

Prior resource bills remain scoped to their sealed controls: native endpoint
pair +8 B (allocation+24/header−16), +109 shipping core lines, +99 bytes optimized
caller text, all unfavorable out-of-line functions/frames retained; headless
headers/allocations and caller object byte-identical. These are not new whole
application machine-code or timing claims. Rehearsal Syn/Tokei independently
charges 30,696→30,805 (+109). Exact modules determining endpoint layouts and
requested lane allocations are unchanged from the sealed controls.

Hummingbird is inventory only here. The 45-file port-only review patch contains
21 runtime/manifest,13 changed test/fixture,9 current doc/license/provenance and
2 example/tool files;26 historical qualification files stay separate. The
unchanged final manifest declares audio_output, so that example accompanies a
faithful final patch. Runtime FFT adaptation requires the complete MIT license
and precise AUDIO-FFT-UPSTREAM attribution. Five optional production dependencies
plus two dev oracle dependencies add37 lock packages without removing any.
Use final197fb full-Selection port-path delta, not whole ancestry. The historical
chain is recorded for provenance; request-only a357 is a rejected intermediate.
No application patch was applied and no frozen audio/app/evidence source changed.

The first native suite Cargo exited0 before GPU quiet. Its wrapper was stopped
to prevent queued Clippy, then intentionally terminated143 after Cargo's exact
Linux wait status was preserved. No gate is inferred from the wrapper status.
After explicit quiet end, strict Clippy and all six actual-native controls pass
with matching source/binary hashes and all owned services exited. Fresh scoped
layout/allocation controls reproduce headless3/832 and native4/912 requested
allocations/bytes, zero binding allocations, empty Win8B. Platform results and
remaining details are recorded in the final qualification summary.

The197fb inventory is faithful source provenance, not an adoption recommendation.
Root subsequently identified a real concurrent Stop publication race in that
frozen audio service. Its deterministic regression/correction belongs to a
separate successor; this transport rehearsal does not fix or qualify it. The
optional startup OnceLock proposal is also excluded.
