# Bounded Future questions

`Questions::question_future(inputs, freeze, executor, make)` returns the same
inert `Reader<T>` as `question`. The inferred lane owns the executor, factory
and one associated task handle. Application models keep their domain state and
Reader; views use existing `project`, `loading` and `failed` builders.

```rust,ignore
let (questions, answer) = Questions::new().question_future(
    Search::QUERY,
    Clone::clone,
    executor,
    move |query| {
        let service = service.clone();
        async move { service.search(query).await }
    },
)?;
```

`freeze` borrows only the declared Source/earlier-Reader input family on the
owner. `make: FnMut(I) -> Fut` runs promptly on the owner and returns an owned
future. `I`, `Fut`, `T` and domain error `E` are Send and static. No owner/model,
Source value or Reader borrow crosses await. The factory may clone an owned
service into its future. GPUI supplies no hidden executor or mandatory macro.
Executor and factory destructors run on the owner during ordinary cleanup.

Implement `QuestionExecutor::spawn(&mut self, future)` for the chosen runtime.
It returns a statically typed `QuestionTask` handle. Spawn enqueues promptly,
never polls inline or reenters GPUI; a worker may finish before spawn returns.
Polls are serialized and non-reentrant. Errors reject and drop the future before
returning; a startup panic must precede acceptance or destroy accepted work
before unwinding. `QuestionTask::cancel` must be prompt, nonblocking,
non-panicking and idempotent, and abort the exact task even before its first
poll or between Pending and waker registration. Handle destruction has the same
prompt/nonblocking/non-panicking requirement and cannot reclaim storage still
borrowed by an active poll. Cancellation cannot preempt a poll; the executor
must synchronize teardown with that poll's return.

| Event | Authority and physical ownership |
| --- | --- |
| Supersede, unavailable input or lane fault | Publish new ticket/current authority first, then request cancellation of the old task. Retain only the newest frozen input. |
| Ready | Keep the result on the poll stack; drop the pinned user Future in place, then publish its result. The completed wrapper owns no user Future, result or Completion. |
| Poll panic | Catch unwind, premark a panic fallback before destroying its payload, destroy the Future, then publish WorkerPanicked. |
| Pending task teardown | Field order destroys the Future and its captures first; the final guard then publishes Abandoned, or WorkerPanicked during an unwind. |
| Terminal admission | Validate the original request stamp, retire the associated task handle, retire the mailbox, then start the latest waiting input. |
| Explicit close | Across the entire static lane chain, detach Inbox receivers, revoke authority, release response owner leases, and cancel/retire task handles. Only then destroy responses, receiver queues, pending inputs or factory/freezer captures. Never join. |
| Natural owner destruction | Release the response owner lease in the existing lane Drop; the opt-in starter's ordinary field teardown requests cancellation. |

Returning from cancel is never credit return. A blocked user Future destructor
still occupies the single physical Completion lease. A successful terminal may
be admitted while the executor finishes a now-trivial poll tail; the executor
must keep its task allocation alive until that borrow ends. Retaining the
completed wrapper after Ready is permitted and does not retain the physical
Completion. A duplicate queued poll of this cleared wrapper is harmless.

Domain Err retains the prior value and uses existing failure projection. Poll
panic becomes WorkerPanicked; factory/spawn panic becomes ExecutorPanicked.
A panicking Future destructor publishes one WorkerPanicked only after teardown.
As in ordinary Rust, another destructor panic during unwinding can abort; there
is no promise to recover from arbitrary double panics.

An executor that enqueues then returns Err or panics without returning its
handle violates the contract. GPUI deliberately retains the physical lease
until the accepted future actually tears down. It cannot recover a handle the
executor lost and never treats start failure as permission to recycle credit.
Public tests retain such unsupported tasks and show that retry waits for their
external destruction.

## Costs and alternatives

The ordinary question's Controller, Completion and lane fields are unchanged.
Its starter closure is wrapped in a transparent generic `SyncStarter`; private
cancel/retire hooks are empty for that wrapper. Future-only storage is the
executor, factory and `Option<Executor::Task>`. The future wrapper is generic,
uses a pinned `Option<Fut>` and a Completion guard, and has no retained Result
slot, GPUI task box, erased Future, Waker or new GPUI-owned request Arc.
Executor allocations and task/waker storage are separate costs. The test
executors intentionally charge their own boxes, threads and shared controls.

Closing uses a transient typed retirement tree on the stack, with one optional
owned response per question and one detached receiver per Inbox. Its size grows
with the inline response types and lane count; it is not retained owner storage.
Safe [`Arc::into_inner`](https://doc.rust-lang.org/std/sync/struct.Arc.html#method.into_inner) atomically releases each owner lease or takes its unique
Controller. A unique mailbox's payload moves into the retirement tree so its
destructor cannot interrupt the cancellation phase. If a worker still owns the
Controller, its eventual teardown owns response reclamation instead. There is
no `try_unwrap`/drop gap in which a racing last worker could leave the owner
running a response destructor before cancelling later tasks.

The direct `pin-project-lite = 0.2.17` dependency provides safe structural pin
projection. This version was already locked transitively; the normal GPUI
dependency edge is new and is charged even for an ordinary build. Its macro is
internal: callers write ordinary typed Rust. The crate's unsafe prohibition
remains unchanged. Safe pin replacement uses [Pin::set](https://doc.rust-lang.org/std/pin/struct.Pin.html#method.set),
which drops the old Future in place before overwriting it; projection follows
the [pinned dependency's documented safety contract](https://docs.rs/pin-project-lite/0.2.17/pin_project_lite/macro.pin_project.html).

Rejected alternatives remain explicit:

- Checking the old cooperative cancellation hint only when polled strands a
  never-waking Pending future and blocks the newest request indefinitely.
- Adding a Waker/task/Arc to every Controller charges ordinary questions for an
  opt-in mechanism. This adapter keeps the associated handle in its own starter.
- An Abortable fallback can support fire-and-forget executors, but requires an
  explicit per-task shared cancellation allocation and a lost-wake protocol.
  It is outside this slice; a native associated abort handle is preferred here.
- A boxed/erased GPUI future or task is unnecessary for this generic boundary.
  An executor may choose its own type erasure and owns that cost.
- Publishing inside user-Future poll before destruction returns credit too
  early. Keeping a Result in the final guard also inflates the task by output
  size and depends on prompt destruction of completed executor wrappers.

This is one terminal-answer adapter. Streams need a separate bounded emission
and retirement policy. Optimistic overlays, commit/rollback/conflict semantics
and arbitrary owner mutation rollback are separate work. This does not assert
Solid parity or claim the inaccessible Solid blog article bodies were read;
[the research audit](async-graph-luna.md) records the actual primary evidence.

Raw source, artifact, allocation, linked-code and gate evidence lives in
[`evidence/future-adapter`](../evidence/future-adapter).
