# EOF queue authority and cloned transport reconciliation

Sealed b1d2 is unchanged. Test-only negative8b7fd06590 runs its production code.
Its four public schedules reach a real decoder EOF with two prepared tracks,
withhold actual EOF/Adopted delivery through ordinary public inbox bindings,
then clone Seek(0) or Stop before releasing the old EOF. Both adoption orders
incorrectly advance the queue occurrence1→2 (exit101). The service rejects that
stale Advance: this is queue/control disagreement, not PCM revival or an
unconditional service stop. The paused same-token control also fails because
UI status becomes Opening instead of Paused. The initial test harness failed
to compile due moved held Event; that separate log is preserved and is not a
behavioral negative. Immutable negative binary and patch hashes are retained.

Runtime9468b39af6 shares one private change_if transaction across ordinary
changes, revision-qualified deferred Play and token-qualified natural Advance.
Closed, predicate and checked next revision are evaluated while desired is
locked, before calling the application queue edit. The edit returns an owned
plan; Intent::apply owns the common transition logic and gate publication occurs
under the same lock. The natural transaction returns receipt plus playing as an
ephemeral value, so Pause preserves valid same-token EOS advancement and stays
paused. Seek/Stop mismatch calls no queue edit. No public Receipt growth.

The owner first checks its exclusively owned queue stamp, rejecting duplicate
EOS without a new service revision. That read grants no service authority;
advance_if compares the from Token under the mutex around the queue edit.
PlaybackQueue.end_of_stream checks its only returned error (next occurrence
exhaustion) before queue navigation. The shared Intent::apply token check cannot
fail after the accepted token predicate because that same lock remains held.
No returned error follows queue mutation. Panics follow owner fault policy and
are not rollback. Queue lookup and allocation may scale while desired is held;
this is not a hard latency-bounded callback and must not reenter AudioHandle.
A pre-mutation queue error is surfaced without unconditional Stop that could
revoke a separately newer clone command after the failed transaction unlocks.

Adopted is accepted only when revision/token match the actual current handle
receipt, then reconciles cached receipt/playing/status. The observational read
is not used to authorize queue edits. Latest clone Pause/Resume/Seek/Stop become
visible; stale Adopted cannot overwrite them. New token positions are accepted,
old token positions dropped. These are deterministic functional tests, not
latency or timing claims.

No retained field, worker, queue, callback allocation, static storage or public
API is added. Existing owned Plan cloning remains one clone; success transfers
that plan through the transaction. Header probes and identical constructor
allocation controls are retained separately. Port shipping count5521 versus
5472 (+49); production core unchanged. Whole-app optimized machine code is not
measured. Previous +8B failed-selection identity cost remains.

All prior adverse DSP reports remain in the port: four unresolved pathological
processing comparisons, changed constructor cohort24 ratio1.429 [1.427,1.432],
untimed v2 geometry, changed filters and bounded rate admission. No EOF stream
drain, backend pause/drop, token retirement or owner idle-poll change is included.
CPAL pause/fade caveat and decoder startup/rendezvous limitation remain.

## Final qualification

All44 default,107 CPAL and107 native tests pass (one scheduled test ignored).
Strict all-target CPAL/native Clippy passes. The unchanged actual Registry
fixture passes with150s client/180s outer/5s kill grace, WM close and all
children exited. Its before/after source/binary guards match exactly. The
identical four-cohort public constructor probe reproduces every prior b1d2
row byte-for-byte: zero added requests, total/retained/peak requested bytes.
Library560, Questions600, Win664 and all measured audio headers are unchanged.
The probe excludes worker/C/OS/device allocations and opens no audio output;
these rows are not a whole-player heap ceiling. The source increase is charged,
and no optimized machine-code size or performance comparison is claimed.
All three earlier negative/recovery proofs and adverse DSP records remain at
qualification/audio-authority and the preceding qualification directories.
