# Stage readiness without duplicating response storage

This refines the safe mailbox from e8017da488. It changes no public API,
allocation count, producer synchronization, ticket/version validation or wake
ordering. The controller still owns the only `Mutex<Option<Message<T,E>>>`.
The static question lane no longer reserves another `Option<Message<T,E>>`.

Staging acquires the terminal and freezes only its byte. Release publication
already sealed the response: the unique completion has stopped touching the
slot, and no new physical completion can be created until owner retirement.
Ordinary callbacks can replace the logical ticket/latest input, but their
`start_pending` check still sees occupied physical credit. Thus they cannot
modify the staged response. Apply takes that response with an uncontended
`try_lock`, validates it against the current source and ticket, then retires the
physical credit and starts the newest pending input. An abandoned/panicked
completion supplies a terminal with no response, as before.

This freezes the same batch boundary without moving a response before normal
callbacks. A response arriving after the stage scan remains for a later turn.
A callback panic quarantines the owner before apply: close revokes the gate,
marks the mailbox closed and drops its controller lease, reclaiming the sealed
response without taking the mutex. A still-live physical lease may defer this
reclamation until its final Arc drop, exactly as in the initial mailbox. Payload
destructors and notifications never run while the mutex is held.

## Requested storage

The unchanged public `question_storage` fixture measures these exact concrete
types on Linux x86_64 with Rust 1.97.1. Heap requests include the first shared
owner scope and controller, and exclude model/result-owned external allocations.

| Result | Heap requests before/after | Win before | Win after | Reduction |
|---|---:|---:|---:|---:|
| u64 | 2 / 152 B | 456 B | 384 B | 72 B |
| String | 2 / 168 B | 480 B | 392 B | 88 B |
| 304-byte array | 2 / 448 B | 1032 B | 664 B | 368 B |
| 4096-byte array | 2 / 4240 B | 8616 B | 4456 B | 4160 B |
| align64 4096-byte result | 2 / 4456 B | 8896 B | 4736 B | 4160 B |

The retained answer still lives inline in the question lane. The response still
lives inline in the controller allocation, and admission needs local temporary
storage; this removes a redundant persistent reservation, not all copies or
arbitrary payload costs. Reader, Completion, Controller and ordinary Win types
are unchanged. No dependency or first-party unsafe code is added.

## Verification

The exact private transport file is compiled under both std synchronization and
the ownership-lab Loom facade. Nine cases include delayed taking across owner
refresh, close after staging without taking the response, old notifications
after credit reuse, exact drops, publication/close races and nonblocking close
while a producer is paused inside its mutex. Public owner tests independently
exercise a queued model callback superseding a sealed result, same-turn newest
dispatch, and a callback panic releasing the unadmitted resource exactly once.

The earlier safe-mailbox timings and implementation remain in
`question-mailbox.md`; they must not be attributed to this refinement.

The fresh paired capture measures question 223333→221119 ns (-0.99%) and unchanged
Remote control 260103→253653 ns (-2.48%) per edit+delivery turn. These small changes
do not establish a question speedup; the control moves more than the changed
path. Five alternating fresh-process pairs, raw rows and actual release
codegen are retained in `question-sealed-staging-evidence.txt` and
`question-sealed-staging-cost.csv`. The measured reason to adopt this refinement
is its smaller persistent owner type and simpler staging ownership.
