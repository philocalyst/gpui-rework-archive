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

A callback/schema panic quarantines the owner and revokes delivery. A fault in a
delivery turn closes its receivers and drops queued/staged values. Quarantine
from another owner operation immediately rejects new sends; its bounded queued
storage is released on the next delivery attempt, close, or drop. There is no
rollback promise for mutations before a panic. A delivery reaching the last legal
source epoch retires the stream immediately; discovering exhaustion at delivery
entry consumes zero values and also retires it. Remaining queued values drop,
new sends return `Closed`, and subsequent delivery reports `EpochExhausted`.
The owner remains available for reading and closing.

Close, normal drop, unopened-builder drop, and every failed mount close receivers
before model destruction. Mount preparation owns a field-ordered temporary until
the complete window exists; description never owns an unguarded model. An optional
shared atomic revocation token contains transport liveness only. It carries no
model data or address. Enqueue and revocation are not one atomic transaction: a
concurrent send can succeed, but no revoked message is applied. Sends begun after
observing completed close/quarantine return the same payload as `Closed`.

## Costs and limits

A channel admits at most C queued messages and preallocates C staging slots.
While callbacks run and producers refill the channel, aggregate retention can be
2C payloads, plus payloads moved into application state. Queue capacity counts
occurrences, not payload byte lengths. No transport allocation occurs per message;
application callbacks, descriptions, text and rendering have their own costs.

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
| Remote handle | 24 |
| Inbox header | 64 |
| One lane with a function-pointer callback | 80 |
| Delivery / inline DeliveryError | 72 / 128 |
| Cold channel + staging allocations, no native feature | 864 across 4 allocations |
| Same with native wake attachment storage enabled | 904 across 4 allocations |
| First owner revocation lease | 24 across 1 allocation |

The optional revocation pointer adds 8 bytes to retained runtime storage; it is
allocated only when a lane is bound. Native wake proxies stay leased by remaining
sender handles until those handles drop. Full delivery includes the existing
owner pipeline allocations. Tests separately prove zero allocations for 8,000
transport/staging messages, enqueue into preallocated storage, and idle turns.

This stream is the ingress primitive for finite worker results and event messages.
It does not implement `Reader`, dependency discovery, automatic frozen-input
validation, latest-question cancellation, reliable action journaling, or async
cohort publication. Existing `RequestGate` tickets require explicit input/policy
invalidation by their owner; applying that primitive does not create a Reader
graph. Questions, actions and streams retain their distinct policies.
