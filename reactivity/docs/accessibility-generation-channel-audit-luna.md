# AccessKit Unix generation-channel audit

Audit date: 2026-10-21. Source baseline: GPUI `d91737d5ac710cc4a61db76d451080236c277d56` (Luna research worktree); the cleanroom lockfile resolves `accesskit_unix 0.24.0`, `accesskit_atspi_common 0.21.0`, `async-channel 2.5.0`, `concurrent-queue 2.5.0`, `zbus 5.19.0`, and `async-io 2.6.0`. This is a source audit and bounded queue prototype. It contains no startup or timing measurement and is not a proof of the GPUI `NativeAdapter` lifecycle.

## Finding

Binding each active AT-SPI bus generation to its own event receiver can isolate stale tree/interface/cache events without putting an epoch word on each event. The design is sound only if transition code **closes and drains** the old receiver before dropping it, then retires every old `Active` or `Pending` adapter state before creating callbacks for the new generation. Dropping the receiver alone does not release queued payloads while an old callback sender still owns the channel.

The queue proof is strong for `async-channel 2.5.0`'s default `try_send` path: close and push reservation are ordered on the queue's sequentially consistent tail atomic. A send that reserved a slot before close must publish that slot; pop waits for its write bit, and a closed/empty result is reached only after those reservations have been popped. A send that loses the race to close cannot reserve a slot and returns its payload to the caller. Thus `receiver.close(); loop { try_recv() until Closed }` empties all accepted messages and permanently prevents later old-generation sends from reaching a new receiver. A callback currently executing a failed `try_send` can still temporarily hold its rejected value on its stack; waiting for adapter-state synchronization to finish deactivation retires that in-flight producer too.

This is a lifecycle/correctness boundary, not a cold-window memory win. The per-generation channel is created only when an AT-SPI bus is active; the existing AccessKit session worker and global control channel remain. On an inactive blank window, there is no active bus queue to remove. When a bus is active, the design adds one channel and queue allocation and trades a per-event tag for more transition code. It does not justify an accessibility-off switch.

## Pinned implementation semantics

The production lockfile uses the default, non-Tokio `accesskit_unix` feature. In [`accesskit_unix 0.24.0 context.rs`](https://docs.rs/crate/accesskit_unix/0.24.0/source/src/context.rs), `APP_CONTEXT` and `MESSAGES` are process `OnceLock`s; `get_or_init_messages` creates the unbounded async channel, starts one worker thread, and builds the session connection with `internal_executor(false)`. `run_event_loop` selects the status-property stream and the single global message stream. The `atspi_bus` value is replaced on an `IsEnabled` update, but `sync_adapters` only compares the new bus's `is_some()` state. A direct Some-to-Some replacement therefore does not deactivate/rebuild an already-active tree.

In [`accesskit_unix 0.24.0 adapter.rs`](https://docs.rs/crate/accesskit_unix/0.24.0/source/src/adapter.rs), the process-global sender carries both `AddAdapter`/`RemoveAdapter` controls and callback-produced register, unregister, cache, and event messages. In the default feature, `Callback::send_message` and `Adapter::send_message` call synchronous `try_send` and ignore errors. `Adapter::new` queues `AddAdapter`; its `Drop` queues `RemoveAdapter`. The `AdapterState` mutex protects the caller-side `update_if_active` path and worker-side activation/deactivation. When activation returns `None`, state becomes `Pending`; later `update_if_active` constructs the real `AdapterImpl` and independently creates a callback. A generation sender must therefore be stored in `Pending` as well as in the `Active` callback. Otherwise an update after bus replacement can silently create an adapter attached to the retired channel.

`AdapterImpl` construction registers the root and emits initial interface/tree messages through its callback. Dropping an active `AdapterImpl` emits its final window/tree removal callback. For a generation channel, callback event order remains FIFO within that one channel. If `RemoveAdapter` is handled before older queued tree events, teardown must append its final removal events after those prior callback sends; the event receiver must keep FIFO and must not filter events merely because the control entry was removed. Dropping the worker's stored Arc is insufficient: the caller can still hold the final state Arc while its `Adapter::drop` is executing. Explicit retirement under the state mutex is required before removing that entry, or a delayed destructor can enqueue behind a later fence. Do not use adapter IDs as generation markers: `next_adapter_id()` is a relaxed `AtomicUsize` counter, and no counter is needed when receiver ownership defines the generation.

The proposed transition ordering is:

1. Mark the old AT-SPI bus unavailable to the worker and close its event receiver. This rejects all future old-generation enqueue attempts.
2. Deactivate all adapter entries while holding each existing adapter-state mutex. This waits for an in-progress `update_if_active`, drops active callbacks, resets `Pending`, and runs AccessKit's normal deactivation handler. Store the new event sender in every newly active or pending state.
3. Drain the old receiver synchronously with `try_recv` until `Closed`, dropping every queued message. `Empty` is not a valid terminal result after close. If the bus generation is being retired, the queued old tree traffic is obsolete and the old bus connection is dropped as a whole.
4. Drop the old receiver and generation owner sender; after all old callback senders are gone, the empty channel allocation can be reclaimed. Create a fresh event channel for the new bus, then reactivate adapters so each gets a fresh full tree.

The order matters for both races. Closing first rejects events while deactivation waits for application-side tree updates. Draining after state transitions waits out callbacks still holding the state mutex and also discards any already-accepted messages. An update that acquired the mutex just before close may send successfully and is drained; one that reaches `try_send` after close gets `Closed` and its message is dropped. An update after deactivation sees `Inactive`; a later activation installs the new generation's sender.

The control channel stays process-global and carries only `AddAdapter` and `RemoveAdapter`, so those controls are preserved while the old tree channel is retired. Splitting channels necessarily removes global FIFO ordering *between* controls and tree events. It preserves control FIFO and per-generation event FIFO. Review specifically the control transition window: an `AddAdapter` enqueued while the worker is rebuilding may be processed after the new bus is active, and a `RemoveAdapter` queued during bus construction may cause a short activation before removal. These are bounded by the worker's serialized control handling and resemble the existing status-change-before-control ordering, but require integration tests. Never suppress teardown events based on a live-adapter-ID set; doing so can erase the `AdapterImpl` drop sequence.

For a direct active-bus replacement, explicitly deactivate before installing the new bus even when both old and new `Option<Bus>` values are `Some`. The current `sync_adapters` active-boolean check alone is insufficient. For session-bus restart or the existing late `org.a11y.Bus` appearance failure, a generation event channel is not a repair: the process-global `MESSAGES` sender/receiver and session connection lifecycle need their own reconnect/owner-monitor logic.

## Lower-overhead alternative: fence the existing FIFO

The per-bus receiver is not the strongest memory design. A single process-global FIFO can retain `AddAdapter`/`RemoveAdapter` and tree events, then use a worker-only `Fence` message at each Bus-generation boundary:

1. Set the current AT-SPI bus to `None`; synchronously deactivate every currently known adapter. The existing adapter-state mutex waits for app-side `update_if_active` calls and drops every old callback before the worker proceeds.
2. Enqueue `Fence` through the same `MESSAGES` sender after deactivation has completed.
3. Consume the same FIFO until `Fence`. While the bus is `None`, process `AddAdapter` and `RemoveAdapter` normally and drop callback-produced tree/interface/cache messages. New adapters added before the fence stay inactive; every removal must explicitly retire its state under the mutex before forgetting its Arc, including removals processed before the generation transition. Controls queued after the fence remain for the next event-loop pass.
4. Only after reaching the fence, construct the replacement `Bus` and reactivate current adapters, which produces fresh full-tree registration.

This has no extra channel, no per-event epoch, no global epoch counter, and it preserves the original total FIFO order between adapter controls and callback events. It also empties obsolete queue payloads as the worker consumes them. Its proof boundary is explicit: all old callbacks must be retired under their state mutexes *before* the fence is enqueued. AccessKit's default callback sends are synchronous `try_send`s under those locks, including the `AdapterImpl` drop callback, so each accepted old event has completed its queue write before that lock is released. Once the worker has acquired and released every state lock through deactivation, no old callback can enqueue behind the fence. App-side calls that arrive after deactivation see `Inactive`; a pending adapter is reset and cannot construct an old `AdapterImpl` after the lock transition.

The fence branch should be evaluated before adding a separate event channel: it avoids the extra active-bus channel allocation and the cross-queue `Add`/`Remove` ordering audit. The transition still has O(backlog) work, but the work is confined to bus disable/replacement and drops messages rather than forwarding them to an obsolete connection. This is a design derivation, not a compiled AccessKit patch. It does not detect a late status service, recover the `MESSAGES` `OnceLock` after session-connection failure, monitor well-known-name replacement, or establish action cancellation. Those remain separate lifecycle and authority boundaries.

## Queue close linearization and retention probe

The exact [`async-channel 2.5.0 source`](https://github.com/smol-rs/async-channel/blob/v2.5.0/src/lib.rs) documents that `Receiver::close` closes the channel but leaves remaining messages receivable; `try_recv` maps the underlying queue's `PopError::Empty` and `PopError::Closed` separately. Receiver drop only closes the channel when the last receiver is dropped. The [`concurrent-queue 2.5.0 unbounded queue source`](https://github.com/smol-rs/concurrent-queue/blob/v2.5.0/src/unbounded.rs) implements close as `tail.index.fetch_or(MARK_BIT, SeqCst)`. Push reserves a slot by `tail.index.compare_exchange_weak(..., SeqCst, ...)` before writing the value and publishing its write bit with `Release`. Pop observes the tail, reserves the head, then waits for the write bit with `Acquire` before reading the value. Since reservation CAS and close RMW share the same sequentially consistent atomic, exactly one ordering applies:

* reservation wins first: its incremented tail is visible to close, and the draining pop waits until the accepted value is published and consumes it;
* close wins first: the producer's stale-tail reservation CAS fails, sees the marked tail, and returns `PushError::Closed(value)` without enqueuing it.

This does **not** mean every sender call has returned when drain reports `Closed`. A producer that loses the close race may still be executing and holding its rejected event temporarily. The queue is empty and cannot accept that event; its caller drops the returned error/value when `try_send` completes. In AccessKit's default adapter, callback sends are synchronous and adapter updates and transitions share the state mutex. Deactivation waits on that mutex, so completion of the deactivation pass is the additional synchronization needed before claiming old callback-local event values are gone. If a producer is unexpectedly stalled inside `try_send`, the drainer can wait on a reserved-but-not-yet-written accepted slot; this is correct but may delay teardown.

The standalone probe at [`channel-generation-probe`](../benchmarks/luna-accessibility-floor/channel-generation-probe/) pins `async-channel = 2.5.0` and the lockfile-pinned `concurrent-queue = 2.5.0` (checksums `924ed96d…1158d2` and `4ca0197a…1d3973`). Its counting allocator keeps an 8 MiB event payload queued while old sender clones remain. Dropping the receiver leaves 8,389,896 logical live bytes above baseline; dropping the last sender then releases the queued 8 MiB payload. Calling `close()` alone also leaves it live; draining through `Closed` releases exactly 8,388,608 payload bytes even though those old senders still exist. A bounded stress releases four producers and a closer together for 64 generations (131,072 send attempts). In the recorded run from the saved worktree, 3,476 sends succeeded and all 3,476 were drained; every accepted or rejected payload was dropped exactly once, and post-close `Empty` never appeared. The accepted count varies with scheduling. The schedule did not inject a pause between the queue's internal reservation CAS and slot write, so source ordering—not this stress—is the proof for that narrow in-flight state. The complete output and toolchain are recorded in [`run-20261021.txt`](../benchmarks/luna-accessibility-floor/channel-generation-probe/run-20261021.txt).

Reproduce without network access from the probe directory:

```sh
cargo run --release --offline
```

The allocator counter is logical live allocated bytes, not RSS/PSS. The probe demonstrates channel semantics and payload release; it does not measure AccessKit memory, simulate a real AT-SPI registry, validate GPUI tree delivery, or establish action safety.

## Actions are a separate authority path

AT-SPI actions do not travel through the callback message queue. In [`accesskit_atspi_common 0.21.0 node.rs`](https://docs.rs/crate/accesskit_atspi_common/0.21.0/source/src/node.rs), `ActionInterface::do_action` calls `PlatformNode::do_action`, which upgrades a weak `Context`, resolves the target against the tree, then calls `Context::do_action` and the stored action handler directly. Dropping or closing a generation channel cannot cancel an action request already running on the old object server. A retained old `PlatformNode` may become defunct when its weak context expires, but an in-flight call can already hold an upgraded `Arc<Context>` and may continue. Preserve GPUI's owner/target-generation validation and test an action racing disable/replacement separately from queued tree-event delivery.

## Required integration gates

Before treating this as an AccessKit fix, add a real Linux integration test around the pinned provider and GPUI bridge that covers: service absent at adapter creation then appearing; initial enabled service; disable/re-enable; direct service owner replacement while the previous unique owner stays alive; session-bus loss/restart; active update racing receiver close; `Pending` update racing replacement; `RemoveAdapter` against a queued old event backlog; Add/Remove while bus construction is pending; stale old event rejected by the new bus; full-tree re-registration on the new bus; and an action already in flight during teardown. Verify actual AT-SPI registry/tree/action behavior. Existing name-owner and callback prototypes are callback-level evidence only; they do not establish these `NativeAdapter` semantics.

No timing samples were taken while parallel Luna work may be active. Keep the normal Linux accessibility profile enabled; this audit makes no off-by-default recommendation.

## Follow-up implementation review

The later Sol implementation review found the delayed-final-Arc removal hazard
above. The single-FIFO fence derivation therefore requires retirement on every
`RemoveAdapter` path as well as during generation transitions. Otherwise an
adapter forgotten by the worker can still emit old callbacks after the fence.
The same review found that concurrent creation can deliver Add controls out of
numeric-ID order; a binary-search removal over an append-order vector is invalid.
Neither finding changes the recorded queue probe. They strengthen the production
adoption requirements; this research commit alone remains an incomplete adapter
lifecycle fix. The implementation and real-window evidence are reviewed separately.
