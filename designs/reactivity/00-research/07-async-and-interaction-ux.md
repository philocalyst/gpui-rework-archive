# 07 — Async and Interaction UX: Removing Transport Ceremony

Research date: 2026-08-12. This note records the stable-Rust patterns checked while simplifying the
final API. It distinguishes source facts from the proposed GPUI surface.

## Current patterns checked

| System | Verified pattern | Useful lesson | What GPUI should not copy |
|---|---|---|---|
| Current GPUI | `App::spawn` runs a future on the foreground executor with `AsyncApp`; `BackgroundExecutor::spawn` requires `Future + Send + 'static`, and GPUI `Task<T>` cancels on drop unless detached. See [local source](../../../crates/gpui/src/app.rs) and [scheduler source](../../../crates/gpui_scheduler/src/executor.rs). | Keep the existing executor and drop-cancellation substrate. | Do not make every retained resource manually shuttle a snapshot through a sender and completion closure. |
| [Xilem 0.4 `task`](https://docs.rs/xilem/0.4.0/xilem/view/fn.task.html) | A view-owned future receives `MessageProxy<M>` and a separate `on_event` handler mutates app state; the task ends when the view leaves the tree. | Owner lifetime and typed completion messages are sound. | The proxy/handler pair is still transport plumbing for a one-input/one-output derivation. |
| [Dioxus 0.7.9 `use_resource`](https://docs.rs/dioxus/0.7.9/dioxus/prelude/struct.Resource.html) | A reactive future reruns when dependencies change and exposes pending/result plus restart/cancel. | A resource should own dependency, task, status, cancellation, and output as one declaration. | Hidden reads inside an async future obscure when UI data was frozen and can accidentally retain values across `await`. |
| [Dioxus 0.7.9 `use_coroutine`](https://docs.rs/dioxus/0.7.9/dioxus/prelude/fn.use_coroutine.html) | The coroutine packages a future with an integrated channel. | A mailbox is useful for long-lived imperative protocols. | Do not make a mailbox the default for a pure latest-input computation. |
| [Leptos 0.8.20 `Action`](https://docs.rs/leptos/0.8.20/leptos/prelude/struct.Action.html) | An action packages async input/output and retains the last value while later dispatches run. | Separate event-triggered actions from dependency-driven resources. | Do not require signal reads or dispatch handles when the retained destination already owns the relationship. |
| [Leptos 0.8 task utilities](https://docs.rs/leptos/0.8.20/leptos/task/index.html) | Provides thread-safe and local spawning plus owner/observer-scoped local tasks with cancellation. | Executor choice and owner cancellation are separate concerns. | Do not expose executor plumbing in common component code. |
| [Tokio 1.53 `JoinSet`](https://docs.rs/tokio/1.53.1/tokio/task/struct.JoinSet.html) | A set owns homogeneous tasks and aborts them when dropped. | Owner-scoped structured task ownership should be the runtime default. | Tokio's runtime handle and join bookkeeping are implementation details, not UI authoring concepts. |
| [Tokio 1.53 `spawn_blocking`](https://docs.rs/tokio/1.53.1/tokio/task/fn.spawn_blocking.html) | Started blocking work generally cannot be aborted. | Cancellation must distinguish “stop polling/delivery” from cooperative CPU cancellation. | Never promise that dropping a UI owner physically stops arbitrary blocking code. |
| [Bevy 0.19 task pools](https://docs.rs/bevy/0.19.0/bevy/tasks/index.html) | Separates frame-critical compute, multi-frame async compute, and I/O pools. | CPU computation and async I/O deserve distinct scheduling policies even if their UI result shape matches. | A global pool plus manually polled task component is too much ceremony for a retained property derivation. |
| [Rayon 1.12 scope](https://docs.rs/rayon/1.12.0/rayon/fn.scope.html) | Scoped work can borrow stack data but the call waits for all jobs; scoped jobs allocate. | Excellent for bounded parallel work inside one compute stage. | It is not a long-lived UI resource/cancellation model and must not block the UI turn. |

## Rejected surface

This is mechanically honest but semantically redundant:

```rust,ignore
let tx = scope.sender(index_results);
let snapshot = scope.snapshot(document, make_input);
scope.worker().spawn(move || tx.send(index(snapshot)));
```

The user states the same edge four times: source, freeze operation, executor, and destination. The
runtime already needs one owner record containing all four plus revision, cancellation, wake, and
delivery policy. Exposing each field does not make the program safer; it creates mismatches.

## Selected surface: a typed work edge

Use ordinary functions. A dependency-driven CPU computation is one declaration:

```rust
fn index_document(document: DocumentSnapshot) -> Result<Index, IndexError> { /* ... */ }

let index = scope.compute(document, index_document);
```

Async I/O uses the same input/output shape with an honest scheduler verb:

```rust
async fn load_symbols(query: SymbolQuery) -> Result<Vec<Symbol>, LoadError> { /* ... */ }

let symbols = scope.resource(workspace.symbol_query, load_symbols);
```

The returned `Work<T, E>` generic instantiation is inferred. Its `value()`, `pending()`, and
`error()` accessors return opaque read-only properties; it can also be passed directly where a
destination accepts the whole load state. The accessors do not expose writable `State` keys. No
destination state, sender, task handle, or snapshot variable exists in product code.

The apparent function call is backed by a sealed stable-Rust protocol:

```rust,ignore
trait WorkInput: private::Sealed {
    type Owned: 'static;

    // UI thread, against the pending logical view; private installer protocol.
    fn freeze(&self, epoch: &PendingLogicalView) -> Versioned<Self::Owned>;
}

fn compute<S, T, E, F>(
    &mut self,
    source: S,
    f: F,
) -> Work<T, E>
where
    S: WorkInput,
    S::Owned: Send,
    T: Send + 'static,
    E: Send + 'static,
    F: Fn(S::Owned) -> Result<T, E> + Copy + Send + 'static;

fn resource<S, T, E, F, Fut>(&mut self, source: S, f: F) -> Work<T, E>
where
    S: WorkInput,
    S::Owned: Send,
    T: Send + 'static,
    E: Send + 'static,
    F: Fn(S::Owned) -> Fut + Copy + Send + 'static,
    Fut: Future<Output = Result<T, E>> + Send + 'static;
```

The concrete return is intentional: stable Rust opaque return types do not expose named fields or
an unnameable family of accessors. `Work<T, E>` itself is only a copyable generational handle; its
accessors can use RPIT precise capture to hide the read-only property descriptor. An infallible
convenience can map `T` to `Result<T, Infallible>` without changing the runtime representation. The
logical state is one coherent `Pending/Ready/Failed` record; accessors are projections, not
independently mutable cells.

`TextDocument` freezes to `DocumentSnapshot`; a `State<Arc<T>>` can freeze cheaply to `Arc<T>`;
tuples compose; generated models can expose a generated snapshot input. There is deliberately no
blanket “clone any local graph object” escape. Application-defined zero-copy/persistent sources use
`scope.input(source, freeze_fn)` to obtain a framework-owned descriptor; downstream code does not
implement the private scheduler trait.

During logical settle, the complete source tuple freezes once against the pending logical view and
stages the new request/pending state in that same draft. Only after successful logical publication is
the owned job enqueued. Completion validates runtime, work generation, owner epoch, monotonically
checked request ticket, exact input stamps, and policy generation. Default policy is latest-input-
wins: a newer request cancels queued work and rejects obsolete delivery. Plain CPU work receives no
token and therefore cannot be cooperatively stopped once running; `compute_cancellable` is the
explicit token-polling form. Dropping an async future stops polling it when cancellation-safe but
does not promise that its external operation or side effect stopped.

The `Copy` callable bound makes free functions/function items and small `Copy` closures the hidden-
sharing-free common path. Every reactive configuration input belongs in `source`; captures are
mount-time configuration. `compute_with`/`resource_with` accept non-`Copy` captured callables and
make shared callable storage/overlap policy explicit and benchmarkable.

Policy is added only when semantics differ:

```rust
let search = scope.resource(query, search_server);                // latest wins
let save = scope.action(save_document).queue(Queue::Reliable);    // event-triggered, every input
let thumbnails = scope.compute(files, render_thumbnails).coalesce();
```

An imperative one-shot remains available without exposing transport:

```rust
scope
    .spawn(upload(bytes))
    .then(move |update, receipt| update.set(upload_receipt, receipt));
```

The completion closure runs on the UI thread with a real `Update`; its owner epoch is checked before
invocation. This resembles plain `Future` composition and is the correct escape hatch when there is
no durable dependency/output relationship. The framework may internally use the same sender/waker
machinery, but the user cannot mismatch its destination, revision, or owner.

## Replacement boundary

| Work shape | Default surface | Replaces manual snapshot/sender/apply? | Irreducible or specialized behavior |
|---|---|---|---|
| Dependency-driven CPU transform, one latest result | `scope.compute(input, fn)` | Yes | freeze/retain input, CPU task, wake, revision check, result publication |
| Dependency-driven async I/O, one latest result | `scope.resource(input, async_fn)` | Yes | future allocation/polling, I/O, cancellation safety, wake, result publication |
| User-triggered save/mutation | `scope.action(fn)` with explicit queue policy | Yes for the completion bridge | reliable ordering, capacity/backpressure, retry/idempotency remain domain policy |
| Imperative one-shot future | `scope.spawn(future).then(...)` | Removes the sender but keeps an explicit apply closure | owner check and UI-thread transaction are still required |
| Many progress values or subscription stream | `scope.stream(...)` or typed `Sender<T>` | No; a mailbox/stream is the protocol | capacity, coalescing, closure race, ordering, acknowledgements |
| Long-lived actor/service with bidirectional requests | actor/service API plus typed bridge | No | supervision, service lifetime, request ids, backpressure |
| Blocking or non-cancellation-safe FFI | dedicated blocking API/pool | No | bounded concurrency; started work may be physically unstoppable |
| Realtime audio/input/render loop | dedicated realtime channel | No | allocation/lock restrictions and deadlines differ from UI resources |
| Framework frame-parallel style/text/scene batch | internal stage scheduler | No | snapshot partition, join boundary, deterministic commit, thresholding |
| Fork-join inside one CPU transform | implementation detail inside `index_document`, optionally Rayon | Only the outer UI bridge | scoped jobs and join cost remain inside the ordinary Rust function |

Thus `compute` replaces the ceremony for the broad one-input/one-output class, including most
background derivations. It is intentionally not a universal worker abstraction. Making it one would
reintroduce queue, stream, actor, realtime, and frame-stage policy into every common work record.

## Stable-Rust boundary

- `Future`, `Fn`, tuples, generational keys, sealed traits, associated types, GATs where useful, and
  RPIT precise capture `use<...>` are stable on the selected Rust 1.97 baseline.
- Only an actual worker crossing requires the owned input/output/future to be `Send + 'static`;
  ordinary UI APIs impose no such bound. `scope.local_resource` removes `Send`/`Sync` and remains
  owner-local. Here `'static` means the stored job owns its captures, not that it lives forever.
- Async closures/functions do not permit a local state key to become worker-readable; only
  `S::Owned` crosses.
- Default CPU work is queue/result-cancelled, not magically interrupted. Cooperative CPU
  cancellation requires the explicit token form; resource-future cancellation has the underlying
  operation's documented safety limits.
- One work edge entails one owner/task record, normally one executor task allocation,
  frozen/retained input, queue/wake synchronization, revision/cancellation metadata, and output
  cells if observed. The API removes *redundant public transport objects*; it does not claim an
  async task is allocation-free or synchronization-free. Its zero-overhead target is parity or
  better versus equivalent manual machinery, verified by the acceptance matrix.

## Acceptance tests

- compile-pass the two-line `compute` and `resource` examples with ordinary free functions;
- compile-fail a non-`Send` frozen input, a future borrowing `Scope`/`Update`, and a raw local
  `State<T>` captured as worker input;
- exact tests for latest/reliable/coalescing semantics, owner teardown, close-versus-complete races,
  input/request ticket rollover, queued/result/cooperative cancellation, panic, and stale result rejection;
- allocation/bytes and wake counts versus the manual sender/snapshot baseline;
- ensure identical work functions can be called normally in unit tests with no UI runtime.
