# Native consumer API audit

This audit reviews the public value-query surface in `docs/element-queries.md`,
`reflection/value*`, `selectors/targets.rs`, and the two value-query integration
tests. It focuses on six consumers who want Go-reflection/Zig-comptime ease,
strong static types, and very little macro ceremony. No production files were
changed. The existing standalone `value-query-consumer` is the executable happy
path probe; this note records the gaps that it does not cover.

## Scenario results

| Consumer | Best current path | Assessment |
| --- | --- | --- |
| Plain `RenderOnce` component | `root.select(..., \|card: &mut Card\| ...)` | Excellent escape hatch: ordinary fields, methods, GATs, and external traits work without registration. The closure usually needs an explicit parameter type; an untyped closure has no target from which Rust can infer the subject. |
| Custom `View` | Same typed `select` callback | Works because the pending `ViewElement` lends its authored view. `component::<T>()` only targets `RenderOnce`, so an untyped callback cannot select a custom `View` through the target-builder route. |
| Borrowed generic domain model | `fields::<T>()` plus `TypedPath::then` and `get/get_mut` | Native typed paths preserve borrowed lifetimes. They cannot be selector subjects: `NativeTarget` and `Any` admission require a `'static` root/leaf. Runtime `Value`/`Describe` also requires `'static`. This is documented, but it prevents selectors over genuinely borrowed model instances. |
| Enum/list inspector | `ValueMut::field/index/variant/walk_mut`, or variant `TypedPath` | Useful and borrow-safe, but dynamic inspection intentionally gives `Option`/`downcast` checks at every step. Typed enum paths are precise and inactive variants are excluded before positional counting. The integration tests cover both behaviors. |
| External role trait | `Select::view(|x: &mut Root| -> &mut dyn External { x })` | Sound and works without schema registration, but the explicit higher-ranked function-pointer coercion is ceremony. `.role::<dyn Trait>()` only sees implementations emitted into the reflected module; adding an external impl later does not register it. |
| Stateful `Entity<Model>` | No direct typed model projection | The view element's query subject is `Entity<Model>`; its inner `Model` is borrowed only through `Entity::update`, which needs `App`. Selector callbacks receive only `&mut Entity<Model>`, with no `App`, so they cannot edit model state. The reflected schema is for the handle unless a custom wrapper explicitly changes the query type. This is the largest consumer-facing gap. |

## Prioritized findings

1. **Stateful entities have no useful native query target.** This is a capability
   gap, not a naming problem: the query callback has no `App`/`Window` context,
   and the subject stored by `ViewElement<Entity<Model>>` is the entity handle,
   not the model. Supporting it needs a deliberate context-aware query design or
   an explicit model projection lifecycle; aliases around `role` or `component`
   will not fix it.
2. **Most reflection conveniences require an inline module.** One module attribute
   is far better than per-field markers, but it only discovers declarations and
   impls syntactically inside that module. Existing split-module code and external
   types cannot opt into generated fields/methods/roles without moving code or
   hand-writing adapters. A per-type derive or explicit `Describe`/role impl
   generation would widen adoption, but would not solve entity state access.
3. **Selector subject inference is less automatic than the docs suggest.** The
   ordinary `.select` route needs a closure annotation for plain components and
   custom `View`s. Typed field paths and `.role` infer callback arguments; for
   whole-root callbacks, `.select_mut(Select::...component::<T>(), ...)` can infer
   the target but changes to a separate method family. A single target-first
   builder for `component`, `of`, and `view` could make both the target and
   callback type obvious.
4. **The API is statically typed after choosing a target, but has a broad surface.**
   `select`, `select_mut`, `inspect`, `field`, `where_field`, `view`, `role`,
   `of`, `component`, `ValueMut`, `Role`, and legacy capability builders all
   overlap. Keep the normal story to typed `select`/paths, inspector `ValueMut`,
   and one explicit role projection. Renaming these operations alone would not
   remove target inference, module discovery, or entity-context limits.
5. **Mutation callbacks can run more than once.** The layout/retry contract is
   documented, but it is easy for an apparently ordinary edit to append twice or
   mutate application state more than once. This is a correctness constraint
   specific to query timing; examples should favor idempotent assignments and
   make the repeatability requirement prominent at the call site.

## Evidence and limits

The current tests demonstrate native `RenderOnce` and concrete `Div` callbacks,
custom `View` callbacks, typed nested fields, borrowed native paths,
enum/list inspection, external `.view` projections, generated trait roles, and
pre-position role/variant admission. They do not demonstrate a `Render` entity
whose model state is edited from a selector. The target code confirms the
limitation: `ComponentTarget` is bounded by `RenderOnce`, while `ViewElement`
exposes the stored `V` as query subject and `Entity<T>` is the `V` when an entity
is embedded. `Entity::update` needs an `App`, which the selector edit callback
does not receive.

The existing standalone consumer can be checked independently with:

```sh
cargo check --manifest-path tooling/api-experiments/value-query-consumer/Cargo.toml
```

That probe validates the supported happy path. It does not test the stateful
entity gap or compile-fail diagnostics.
