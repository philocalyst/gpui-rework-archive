# One-source typed questions

This implementation adds one explicit source per question. It is not a Reader
DAG, dependency capture, demand parking, a transactional multi-reader cohort, or
a framework executor. Ordinary windows retain their existing `Win<M, ()>`
storage and do not allocate a question plan.

```rust,ignore
let mut worker = SearchWorker::new()?; // an application-owned ordinary service
let (questions, results) = Questions::new().question(
    SearchLibrary::QUERY,
    |query| freeze(query, 250_000),
    move |input, completion| worker.start(input, completion),
)?;
let window = Window::document(SearchLibrary::new(250_000, results))
    .questions(questions);
```

The model holds a Copy `Reader<SearchPage>`, not an executor, request gate,
completion, result reference, or loading flag. `results.project(|page| ... )`
returns the ordinary concrete `El`. The callback may borrow `page`; it cannot
return an element borrowing a shorter closure capture. Put a borrowed model
caption next to the projection. `loading` and `failed` select explicit status
chrome. A previous answer stays visible and interactive during Pending/Fault;
it is not reported Ready. Its content occupies a stable child position.

`Win::with_questions` is the same headless owner. `deliver_ready(budget)` is the
same bounded admission operation called by native WorkReady. `with_ready`
provides a scoped current-Ready borrow; `question_info` reports logical status,
version, physical lease, and saturating work counters. These are logical reads,
whereas queries and accessibility still observe the acknowledged presentation.
`retry` explicitly changes the question policy generation. Generic helpers use
the existing `Win<M,L>` / `L: LaneSet<M>` spelling.

## Admission and lifetime

A version contains registered source identity, source revision, a conservative
owner-change generation, and retry generation. A separate monotonic ticket and
owner scope must also match. An unrelated exact edit changes source epoch but
does not invalidate this question. A coarse owner callback refreshes questions
even when replacing a Signal resets its revision and preserves equal text.
The input is frozen into owned `Send + 'static` work before dispatch. Start
callbacks must enqueue promptly; they are not permitted to block the UI.

Question storage is a concrete slot in the existing static lane chain. A
transient borrowed owner turn separates model, lane, and layout borrows. Only
the heterogeneous El projection boundary uses checked borrowed `Any` and a
projector trait object. No result is stored in `Box<dyn Any>`, no producer or
future is boxed, and no model address is retained. Reader namespaces are
monotonic and cannot be deserialized or rebound to another restored owner.
Models containing Reader do not directly implement the ordinary `from_json`
restoration path in this slice. The Library saves a domain-only DTO (query,
selection, catalogue size), builds a fresh Questions plan, and passes its fresh
Reader into `SearchLibrary::restore`. No Default Reader or persisted capability
is invented. The restore test checks old worker rejection and reminted Targets.

Normal source callbacks commit S before freezing or presentation can fail.
Accepted owned results likewise enter the slot and advance S before describing
or painting. A rendering failure retains that answer for repair; old P stays
immutable. A rejected stale completion does not advance S. A model callback
panic quarantines the owner and closes delivery; worker/executor panics produce
question faults. A checked source binding failure returns a typed error and
still retires any staged physical completion lease.

## One physical credit

Each question permits exactly one live linear Completion. New logical inputs
cancel its ticket immediately and replace one latest owned pending input; they
do not pretend a canceled worker has stopped retaining memory. When the old cap
publishes its terminal state, the owner acquires that state before reusing the
credit. Queued results carry independent owned tickets and versions.

`Completion::complete` consumes the cap. Closed returns the same owned
`Result<T,E>`; the linear response has no Full case. Drop publishes Abandoned; `run` catches a worker panic separately
from domain E. Start rejection cancels the logical gate and cooperative hint,
but keeps the physical credit occupied if the executor retained the cap. A
hung executor or intentionally forgotten cap therefore prevents another
physical dispatch; this slice supplies no forced thread termination or timeout.

The response slot is a safe Mutex<Option<Message>> inside one controller Arc.
The producer unlocks, Release-publishes its terminal, then posts one wake. Owner
staging acquires only the terminal byte. The response stays sealed in its
controller slot across ordinary callbacks; another cap cannot exist until
owner retirement. Apply then takes it with try_lock: the sole writer has already
unlocked and can no longer access that slot.
Close only sets an atomic closed flag and drops the owner Arc lease; it never
locks or waits for a descheduled producer. The last Arc uniquely reclaims any
unconsumed response. A physical cap can defer that reclamation, but cannot admit
work after owner revocation. No user payload destructor runs inside the mutex.

Close also revokes scope, cancels current work, releases ready/pending values and executor closures before model destruction. A send racing
close can return success but is never admitted afterward. Retained physical caps
can retain controller backing and one response until dropped. Native proxy/OS
event posting allocation is not measured by owner-thread allocation counters.
Nine same-source Loom cases check publication, close races, exact drops,
physical reuse and a producer paused inside the mutex while close must return.

## Concrete bounds and costs

The framework bounds the number of physical work snapshots, not arbitrary
generic payload bytes. At most one running/queued result, one latest pending
input, and one previous ready result exist per question. During replacement a
new owned result may overlap the previous ready allocation. There is one
physical response reservation, inside the mailbox, and no inline staging copy.
Its credit is returned after admission, not while staging. Per-lane
FIFO applies; there is no cross-lane ordering or atomic cohort guarantee.
The static chain is intended for a small declared set: staging can scan
O(lanes × budget), lookup traverses the typed chain, and monomorphized code grows
with declarations. This is not a demand-discovered graph or a claim of constant
lookup cost for arbitrarily many producers.

The Library proof bounds frozen query text to 256 UTF-8 bytes inline and output
to 128 u64 IDs (1,024 requested heap bytes), even though it scans all 250,000
definitions. Its explicitly created worker reserves a 256 KiB stack and owns a
one-job queue. Search remains an O(catalogue size) ASCII-insensitive title scan;
the UI stays responsive because this work runs on that service. No native
thread is spawned implicitly by the question API. The original synchronous
Library remains available; `library --search` selects this proof.

The first u64/Infallible question allocates a cold scope and one controller
(2 allocations/152 requested bytes headlessly; 200 bytes with native wake).
Additional questions share the scope and allocate one controller each.
The response slot and retained answer scale with concrete result size. The
inline window contains only its retained answer; staging adds one terminal byte,
not a second result reservation. See the storage matrix for exact sizes. A Completion clones that controller lease once per physical job;
it is not a per-node/per-message result allocation. Each projected description
currently allocates two boxes: the typed-erased projector plus existing cold
ElementExtra. It also contributes a fixed status/content region. Folding these
boxes would require changing ordinary El storage, its concrete public type, or
introducing lower-level erased ownership machinery; this slice keeps the clear
safe boundary. No zero-description-allocation or frame-time improvement claim
is made. See `question-sealed-staging.md` for current storage and evidence;
`question-mailbox.md` preserves the initial safe-mailbox comparison;
`reader-question-evidence.txt` preserves the earlier channel baseline.

## Validation

`cargo test -p gpui` includes question owner tests, compiler rejection of escaping
borrows/frozen borrowed input/reentrant mutation, and a real Library oracle.
`cargo test -p gpui_reactivity_ownership_lab --features loom --test question_mailbox`
checks the exact current synchronization implementation; question_credit keeps
the earlier channel-based protocol experiment as historical evidence. With an actual X11 display,
`cargo test -p gpui --features x11 --lib native_question_result_and_credit_wake_without_unrelated_input -- --ignored --nocapture --test-threads=1`
requires result and credit progress through real WorkReady callbacks; a watchdog
only fails the test and never polls delivery. The existing native adapter,
presentation acknowledgement, semantic visitor, focus and input barriers are
shared.
