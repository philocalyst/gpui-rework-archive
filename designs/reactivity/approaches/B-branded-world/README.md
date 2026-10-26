# Approach B — A Public Branded UI World

Status: **research boundary, not the selected public API**. Phase capabilities and contained branded
storage survive; a public generative `'ui` lifetime does not. See
[../../03-hybrid-plan.md](../../03-hybrid-plan.md).

## Original hypothesis

Mint a generative lifetime for the whole UI, make signals branded indices, and route access through
borrowed phase tokens. GhostCell-style ownership would replace dynamic alias checks and make
cross-window/use-after-world mistakes fail to compile.

```rust
fn app<'ui>(ui: &mut Ui<'ui>) {
    let count: Sig<'ui, u64> = ui.sig(0);
    // reads/writes require phase tokens carrying the brand
}
```

The mechanism is sound in a contained scope and valuable for internals. The problem is architectural
composition, not soundness.

## What survives

- `Scope`, `Update`, inferred dynamic `Read`, and phase-specific capabilities; inert copyable keys need
  the right capability to resolve rather than carrying an ambient runtime.
- Generated direct field cells and destination-owned edit methods instead of separately paired
  read/write projections.
- Local `!Send + !Sync` storage and an explicit `'static + Send` sender boundary.
- Internal branded arenas/cells where a framework callback contains the brand.
- Typestate for initialization sequences that are genuinely linear in one call chain.
- Unforgeable paint/encoder capabilities around low-level drawing APIs.

These deliver high-value compile-time boundaries without branding every application struct.

## Why the public brand is rejected

Stable Rust cannot let a long-lived runtime mint a fresh lifetime and then hide values borrowing
that lifetime inside itself. Dynamically stored windows, heterogeneous retained nodes, event
closures, and application objects would all need to carry `'ui`, use higher-ranked callback APIs, or
erase the lifetime behind runtime checks. Per-window sub-brands make cross-window composition still
more viral.

The lifetime also proves membership in a world, not that a dynamically removed node is still alive.
Long-lived node handles still need generations or scoped borrows that cannot cross callbacks. Async
work still needs a runtime-checked sender because `'ui` cannot be captured by an arbitrary `'static`
task.

## Protocol limit

Session/typestate APIs work when one value is consumed through a synchronous chain:

```rust
let drag = update.begin_drag(payload).grant().over(target).finish();
```

Native UI protocols do not normally execute this way. Pointer down, move, focus loss, window close,
and drop arrive as independently dispatched callbacks. A retained runtime state machine must own
the protocol between them and handle OS cancellation/reentrancy. Typed transition helpers can make
one callback correct, but cannot eliminate runtime state.

The final plan therefore retains explicit focus/drag/IME/capture state, owner epochs, and defined
cancellation. It does not claim these are compile-time-complete.

## Where brands still pay

Inside a `with_arena(|brand, arena| ...)` callback, branded cells prove that resolved references
belong to that arena view, cannot escape the callback, and flow through read/exclusive-write owner
tokens. This is a required internal hardening boundary in the final plan. It stays behind
generational public ids because lifetime branding alone cannot prove that a node dynamically
removed between callbacks still exists.

The implementation can use a fully contained GhostCell-style token when the runtime ownership
shape permits it, or an HRTB-minted branded facade over the generational arena. In both cases, unsafe
unchecked slot access is reachable only after id/window/generation validation and only for the
duration of the branded batch.

Phase contexts are the more durable public idea:

- compute can track reads but not write;
- event can read/write and queue commands;
- paint can consume settled frame data and issue draw operations;
- APIs unavailable in a phase are compile errors.

## Examples

The examples demonstrate the maximal branded design and its ergonomic cost; they are not target
signatures:

- [examples/counter.rs](examples/counter.rs)
- [examples/editor_pane.rs](examples/editor_pane.rs)

Use them to evaluate which phase/typestate boundaries deserve dedicated APIs, not as the migration
plan.
