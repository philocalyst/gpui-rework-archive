# Owned worker delivery

`Remote<T>` sends owned messages into one bounded FIFO stream. Its unique
`Inbox<T>` moves into an owned window; workers receive no UI model or callback.
The OS runtime, standard threads, Tokio, or another executor owns the work.

```rust
use gpui::{Remote, Win};
let (remote, inbox) = Remote::bounded(32);
let mut win = Win::demo(Catalogue::default())
    .with_inbox(inbox, Catalogue::receive)?;
// Move remote into ordinary Rust work. Sending is inert until delivery.
remote.try_send(ResultMessage::Loaded(records))?;
let delivered = win.deliver_ready(16)?;
```

Native construction uses
`Window::document(model).with_inbox(inbox, Model::receive)`. Native `WorkReady`
calls exactly the same `deliver_ready(64)` operation. A sender can be created
before model construction and cloned into a model that starts later work.
Unbound sends are permitted and bounded; moving the sole inbox binds it once.
Capacity zero rejects all sends with `SendError::Full`. `Full(T)` and `Closed(T)`
return the original payload, without requiring `T: Clone` or `T: Debug`.

`Win<M, L = ()>` and `Window<M, L = ()>` infer a static receiver chain. The empty
chain adds no inline window storage or allocation. Requested lanes own concrete
receivers and concrete `FnMut(&mut M, T)` callbacks, without lane boxes, erased
payloads, or per-message reference-count operations. A helper accepting any lane
configuration spells its bound explicitly:

```rust
use gpui::{Error, Key, LaneSet, Role, View, Win};
fn edit_title<M: View + 'static, L: LaneSet<M>>(win: &mut Win<M, L>) -> Result<(), Error> {
    win.focus(win.role(Role::TextInput).one()?)?;
    win.key(Key::Text("title"))?;
    Ok(())
}
```

`LaneSet` is a sealed, publicly nameable implementation hook. Existing `Win<M>`
helpers select the empty chain; they do not accept a bound window automatically.
A mutable dereference wrapper would permit replacing or closing the inner window
independently of its receivers, so the chain stays part of its owning type.
`Runtime<M>` and `Query<'_, M>` retain their original type arity.

## One production barrier

A delivery turn first stages a bounded batch, rotating its admission cursor among
lanes. It then invokes those concrete callbacks inside one ordinary owner
operation and performs one conservative description/presentation barrier. Each
callback consumes one payload. Per-lane FIFO is preserved; ordering between
lanes is unspecified. Arrivals during callback application or description wait
for a later turn. A zero budget is an idle operation on a live owner.

`Delivery` reports received/applied counts, actual source/presentation `Commit`,
and a conservative `more` scheduling hint. Saturation rearms the native wake;
this can produce one harmless empty callback. The driver acknowledges its wake
gate before delivery. Initial wake attachment also signals once, covering messages
sent before mounting. No callback polls or mutates UI state from a worker.

A failed batch returns `DeliveryError` with the same report. Normally returned
callbacks advance source state once, even if description or presentation fails;
they are never replayed. Later queued messages remain available to repair that
state. Native post-commit checked failures use the existing presentation-error
observer and keep the owner alive. Its observer currently receives `Error` only;
default diagnostics include applied count and source/presentation epochs.
Headless callers receive the complete typed report directly.

A callback/schema panic quarantines the owner and revokes delivery. A private
exclusive runtime-borrow guard closes every receiver before a faulting public
operation returns, also dropping queued/staged values. This guard contains only
ordinary mutable references to the runtime and its static lanes; its cleanup
branch is erased for the empty chain. There is no rollback promise for mutations
before a panic. A delivery reaching the last legal
source epoch retires the stream immediately; discovering exhaustion at delivery
entry consumes zero values and also retires it. Remaining queued values drop,
new sends return `Closed`, and subsequent delivery reports `EpochExhausted`.
The owner remains available for reading and closing.

Close, normal drop, unopened-builder drop, and every failed mount close receivers
before model destruction. Mount preparation owns a field-ordered temporary until
the complete window exists; description never owns an unguarded model. There is
no shared owner revocation token or per-message liveness load. A concurrent send
may succeed before receiver shutdown, but no quarantined message is applied.
Sends after the faulting operation returns observe `Closed` with the same payload.

## Costs and limits

A channel admits at most C queued messages and preallocates C staging slots.
While callbacks run and producers refill the channel, aggregate retention can be
2C payloads, plus payloads moved into application state. Queue capacity counts
occurrences, not payload byte lengths. The measured standard-channel and staging operations allocate nothing per
message in headless and unattached-native cases. After wake attachment, native
event-proxy/OS notification may allocate per wake; that allocation was not
measured. Application callbacks, descriptions, text and rendering have their own
costs.

The initial static selector scans lanes and recursively descends the chain for an
indexed receive. Sparse busy patterns can cost O(budget × lanes²), plus an empty
scan; this cut is intended for a small number of typed message lanes. Callbacks
must be bounded/nonblocking: the host bounds message count, not arbitrary Rust
execution time. Reliable effects, persistence and backpressure/retry policy remain
application responsibilities; closing a receiver cancels delivery, not outside I/O.

Measured on x86-64, Rust 1.97.1, for eight `u64` slots:

| Storage | Bytes |
| --- | ---: |
| Empty Win | 8 |
| Remote handle, no native feature / native | 16 / 24 |
| Inbox header, no native feature / native | 56 / 64 |
| One lane with a function-pointer callback, no native feature / native | 72 / 80 |
| Delivery / inline DeliveryError | 72 / 128 |
| Cold channel + staging allocations, no native feature | 832 across 3 allocations |
| Same with native wake attachment storage enabled | 888 across 4 allocations |
| Binding an inbox | 0 allocations |

The runtime has no optional revocation pointer or its allocation. Native wake
proxies and standard-channel backing storage can stay leased by remaining sender
handles until all those handles drop. Receiver close releases queued payloads;
it does not promise that every transport allocation is already freed. Full delivery includes the existing
owner pipeline allocations. Tests separately prove zero allocations for 8,000
channel/staging messages with no attached native wake, enqueue into preallocated
storage, and idle turns. Real native tests prove bounded wake delivery and
liveness, without claiming zero allocation in the proxy or OS.

This stream is the ingress primitive for finite worker results and event messages.
It does not implement `Reader`, dependency discovery, automatic frozen-input
validation, latest-question cancellation, reliable action journaling, or async
cohort publication. Existing `RequestGate` tickets require explicit input/policy
invalidation by their owner; applying that primitive does not create a Reader
graph. Questions, actions and streams retain their distinct policies.

The guard comparison, exact benchmark source and raw pinned-CPU samples are in
[evidence/remote-guard.md](evidence/remote-guard.md). Timing is neutral; this change
claims a storage/allocation reduction and immediate receiver cleanup, not a frame
time improvement.
