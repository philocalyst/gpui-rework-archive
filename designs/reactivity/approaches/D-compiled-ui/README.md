# Approach D — Compiler-Owned UI Syntax

Status: **optional authoring layer, deliberately last**. `tw!` is a good early bounded macro; a
general `#[component]` macro is not part of the core performance plan. See
[../../03-hybrid-plan.md](../../03-hybrid-plan.md) and [../../migration.md](../../migration.md).

## Original hypothesis

A stable proc macro would rewrite local state reads/writes, synthesize positional slots and keys,
infer per-property dependency scopes, and generate skip groups—bringing Compose/Svelte-like syntax
to Rust over the attribute graph.

The desired authoring experience is compelling. The original semantic claim is too broad for a
token-level proc macro.

## What survives

- A stable `tw!` proc macro parsing a literal into the same style schema operations as fluent calls.
- Compile-fail tests for missing keys and invalid classes, plus strict-mode conflict tests.
- Source-location metadata for generated reactive nodes.
- An optional future `#[component]` that expands to readable explicit GPUI primitives.
- Conservative runtime tracking whenever a macro cannot prove a dependency set.

## Hard limits

A proc macro sees syntax before full type resolution. It cannot generally know what an arbitrary
method call reads, whether an overloaded operator mutates reactive state, or how a helper function's
dependencies vary. Rewriting identifiers can also collide with patterns, shadowing, async moves,
macros inside the body, and user-defined control-flow abstractions.

Therefore static dependency inference may only be an optimization with a debug verifier. Around
opaque calls the macro must use normal runtime tracking. It must never guess and silently omit a
dependency.

Positional slot identity is also less attractive when explicit components mount once. `cx.state()`
creates owner-scoped state during mount; it does not need a slot on every reinvocation. Structural
loops already require keys through `list(rows.keyed_by(...), ...)`, with `.virtualize(...)` as a
policy. A compiler protocol should solve
demonstrated boilerplate, not import a slot table because another framework reinvokes functions.

## `tw!` is the bounded success case

```rust
div().class(tw!("flex flex-col gap-2 px-4 hover:bg-red-500"))
```

The input is a literal with a closed grammar. A stable proc macro can validate it, provide spans,
canonicalize static payloads, and emit the same field ids and variant layers as fluent builders.
This needs neither nightly const string generics nor a claim that arbitrary fluent chains are
const-evaluated.

Dynamic class strings use an explicit runtime API and cache; they do not pass through `tw!`.

## Acceptance bar for `#[component]`

Do not ship the general macro unless it:

- expands solely to public explicit primitives with identical semantics;
- preserves useful source spans and rust-analyzer behavior;
- has compile-pass/fail coverage for shadowing, patterns, loops, branches, returns, async, nested
  macros, and opaque calls;
- reports every runtime-tracking bailout;
- can be removed from an application without changing complexity class;
- demonstrates a substantial UX win on migrated product code.

Peak runtime performance must remain available without it. This keeps the retained substrate
debuggable, lets ordinary Rust abstractions compose, and prevents the macro from becoming an
unreplaceable compiler-within-a-compiler.

## Examples

The examples are syntax experiments, not promised expansions:

- [examples/counter.rs](examples/counter.rs)
- [examples/dashboard.rs](examples/dashboard.rs)

Their `tw!` portions align with the final plan. Their automatic state/assignment/dependency rewrites
are candidates for Phase 9 only.
