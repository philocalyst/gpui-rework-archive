# API state documentation audit

This pass covers the public state and execution interfaces in the requested
files. The goal is to make the ownership rules visible at the operation that
depends on them: who keeps an application alive, when an entity can be read or
updated, what a weak upgrade means during teardown, how subscriptions end, and
which executor owns a future.

## Coverage

The declaration counts below include public structs, enums, traits, constants,
and methods in each file (including test and benchmark contexts behind their
feature gates). “Rewritten” means the contract was materially clarified in this
pass; “retained” means it was read against the implementation and already
described the behavior accurately enough to keep.

| File | Public declarations read | Rewritten | Retained |
| --- | ---: | ---: | ---: |
| `app.rs` | 201 | 8 | 193 |
| `app/context.rs` | 42 | 8 | 34 |
| `app/async_context.rs` | 23 | 10 | 13 |
| `app/entity_map.rs` | 48 | 13 | 35 |
| `app/headless_app_context.rs` | 24 | 0 | 24 |
| `app/test_app.rs` | 49 | 0 | 49 |
| `app/test_context.rs` | 79 | 0 | 79 |
| `app/bench_context.rs` | 29 | 0 | 29 |
| `app/visual_test_context.rs` | 33 | 0 | 33 |
| `executor.rs` | 37 | 7 | 30 |
| `global.rs` | 3 | 3 | 0 |
| `subscription.rs` | 8 | 2 | 6 |
| `_ownership_and_data_flow.rs` | guide | full rewrite | — |

Feature-gated test and benchmark APIs were reviewed for their documented
deterministic scheduling, teardown, and simulated platform behavior. Their
contracts were retained because the current text already follows the
implementation; changing wording there without the corresponding test-site
walkthrough would add noise rather than accuracy.

- `crates/gpui/src/app.rs`: application construction and startup, embedded
  lifetime, re-entry through `ApplicationHandle`, and the app module's
  ownership model.
- `crates/gpui/src/app/context.rs`: entity-scoped context, observation,
  subscriptions, release callbacks, and quit callbacks.
- `crates/gpui/src/app/async_context.rs`: weak app lifetime, foreground task
  cancellation, update re-entry, window errors, globals, and deferred entity
  updates.
- `crates/gpui/src/app/entity_map.rs`: strong versus weak handles, downcasts,
  borrowing/double-lease behavior, and teardown races.
- `crates/gpui/src/executor.rs`: foreground/background ownership, cancellation,
  blocking caveats, and error logging.
- `crates/gpui/src/global.rs`: marker semantics and panic/absence behavior for
  global access.
- `crates/gpui/src/subscription.rs`: RAII cancellation, detach semantics, and
  joined handles.
- `crates/gpui/src/_ownership_and_data_flow.rs`: corrected stale references to
  the old entity-construction API.

## Remaining limitations

The requested surface is broad and `app.rs` contains a large platform facade.
Its system-service methods (clipboard, credentials, notifications, menus,
capture, restart, and platform paths) still need a separate platform-behavior
pass: several return types delegate to platform implementations whose exact
error and availability guarantees are outside these files. The existing API
docs should therefore be treated as the source of truth until those platform
contracts are audited together.

The walkthrough URLs are intentionally linked from the API docs so the static
site can own runnable examples. Their exact page structure is a site concern
and was not created in this API-only pass.

## Changed files

Only the requested Rust files and this audit were changed. No executable code,
signatures, tests, Cargo metadata, or branches were modified, and no commits or
pushes were made.
