# Safe linear response mailbox

Historical initial safe-mailbox implementation at e8017da488. The follow-up in
[question-sealed-staging.md](question-sealed-staging.md) removes its duplicate
inline staging reservation while preserving this publication protocol. Sizes
and timings below describe the initial implementation, not the follow-up.

This replaces only the one-response question transport from c6ac1481d1.
General Remote remains a bounded multi-producer stream. The question already
has one linear physical completion; allocating a general channel and a deque
for it was unnecessary. The new transport uses one controller Arc containing
`Mutex<Option<Message<T,E>>>`, terminal/current/closed atomics and an inline
native Wake attachment. No new dependency or first-party unsafe code is added.

The first question still allocates its existing owner scope. Headlessly a u64
question now requests two allocations/152B instead of five/880B. The bound static
lane grows432→448B because its staging message moves inline. Reader16B,
Completion72B, InputVersion32B and El176B are unchanged. No ordinary owner,
Node, Presented or element gains a field. Native X11+Wayland measurement is
six allocations/952B→two/200B; the native wake is inline in the controller rather
than another notification Arc. These are allocator requests, not RSS.

## Publication and authority

1. The owner marks the one physical credit Running and moves one non-Clone
   Completion into the application executor. New inputs only replace the latest
   pending snapshot while that credit is occupied.
2. Complete moves its independently stamped response into the slot under the
   mutex, unlocks, Release-publishes a terminal, then signals once. Abandonment
   and worker panic publish a terminal without a response. The cap never touches
   this physical slot after terminal publication.
3. Staging checks the terminal with Acquire, then uses `try_lock` to freeze its
   response and terminal into UI-owned fields before any model callback. The
   sole producer has already unlocked, and another producer cannot exist until
   owner retirement. Thus staging never waits on a worker, even if the producer
   is descheduled. WouldBlock diagnoses a broken internal invariant instead of
   waiting. Poison recovery preserves safe ownership; user drops/notifications
   never run inside the mutex.
4. Normal owner admission still checks source identity/revision, conservative
   generation, policy and consume-once ticket before accepting the owned value.
   Only after admission/rejection does the owner retire the physical credit and
   start the latest pending input. A stale older terminal cannot fault a newer
   logical ticket. Checked binding rejection still retires its staged credit.

The response and terminal now share one publication, so the old send-wake /
terminal-wake ordering problem disappears. There is no Full response state:
the unique cap can publish only one response, and no new cap exists while it is
staged. `CompleteError::Closed` still returns the exact owned Result<T,E>.

## Closing without waiting

Close revokes the question gate, atomically marks the mailbox closed, takes the
owner's `Option<Arc<Controller>>` lease, then releases UI-owned staged, pending,
ready and executor values. Option uses the Arc's existing pointer niche.
No close path locks or joins a worker. A send racing close can return success;
it cannot enter the revoked owner. A later send that observes closed returns
the original payload.

A physical cap still holds its own Arc. If it is descheduled while holding the
producer mutex, close returns immediately and that cap defers reclamation of
one response/controller until its lease drops. The last Arc owns the mutex
uniquely, so ordinary Mutex/Option destruction requires no locking. This bounds
retention by the existing physical lease; it does not promise immediate release
while an external executor retains a cap. UI-owned staging releases promptly.
Destructor work itself is application work, and may panic; there is no rollback
promise. A destructor panic cannot leave the mailbox open or poison a held lock.

## Storage tradeoff

`question_storage.rs` is copied unchanged onto the detached c6 baseline for the
comparison. Both use separate target directories for authoritative verification.
The PageSized304 case models size/alignment, not the concrete Library type's
internal niches. The align64 case shows padding costs explicitly.

| Result | Old requested heap / Win | New requested heap / Win | Total reduction |
|---|---:|---:|---:|
| u64 | 880 / 440 | 152 / 456 | 712B |
| String | 912 / 448 | 168 / 480 | 712B |
| 304-byte array | 1472 / 720 | 448 / 1032 | 712B |
| 4096-byte array | 9056 / 4512 | 4240 / 8616 | 712B |
| align64 4096-byte result | 9112 / 4736 | 4456 / 8896 | 496B |

This moves storage into a larger static owner type; it does not make arbitrary
inline results free. For a large result the relative saving is small, and cold
owner moves can copy more bytes. There is at most one initialized response in
the mailbox OR staging, plus the separately retained previous answer and latest
pending input. The two storage reservations are explicit even when empty.

## Evidence and limits

The exact transport source is compiled with std synchronization in GPUI and a
small `super::sync` Loom facade in ownership-lab. There is no protocol macro or
abstract substitute. Seven cases check one-wake liveness, close/publication
races and exact drops, delayed old notification after reuse, abandonment,
payload drops outside the mutex, deferred reclamation, and a producer paused
inside the mutex while close must return. Native Wake posting/OS allocations
remain unmeasured.

The retained raw timing files distinguish a contaminated capture from a quiet
initial capture; no timing claim is based on the contaminated data. The quiet
initial safe-mutex version measured neutral owner-turn behavior (question
220373ns→219789ns median; ordinary Remote control254002→252857ns), before the
atomic-close refinement. These observations compare the same owner fixture
between transports, not Remote and Question as equivalent work.

The final atomic-close version measured question222404→225427ns (+1.36%) and
ordinary Remote control255722→261772ns (+2.37%). This capture demonstrates no
speedup; its small losing result is retained rather than normalized away using
the control. Five fresh-process alternating pairs each contain seven timed
rounds, with200 edit+delivery turns per round. Timed work is command-only owner
admission/layout/preparation, not native pixel presentation. The two unused
controller/refcount paths and layout differences must not be inferred to make
all applications faster. See `question-mailbox-evidence.txt` and the three raw
CSV files for methods, artifact identities and discarded-contended evidence.

No unsafe SPSC implementation is adopted. Safe Acquire/try-lock staging and
atomic close already eliminate UI waiting on producers. Removing the remaining
uncontended mutex atomics has no demonstrated application benefit here. Any
future unsafe candidate needs a typed linear safe API, same-source race/drop
proofs and a measured benefit beyond this memory reduction.

Run the new protocol gate with:
`cargo test -p gpui_reactivity_ownership_lab --features loom --test question_mailbox`.
The earlier question_credit cases remain historical evidence for the retired
channel protocol, not proof of this implementation.
