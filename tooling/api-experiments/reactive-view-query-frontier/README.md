# Reactive view entity query frontier

This read-only architectural experiment evaluates querying the model behind an
`Entity<V: Render>` view. It does not change GPUI production code. The runnable
miniature in `main.rs` models selector application as a pre-layout transform
with access to `App`, and the compile-fail case checks that a model borrow
cannot escape the callback.

Run `./check.sh` to compile and execute the positive case and verify the
expected borrow-checker rejection.

## GPUI seam

The existing selector transform is `FnMut(AnyElement) -> AnyElement`, so it
does not currently receive application context. However, selector callbacks
are applied from `SelectorRuntime::enter_element` only for before-layout
elements during request-layout. That call is nested under
`Element::with_selector_scope`, whose request-layout caller already has
`&mut App`. The `ViewElement<V>` query subject is the authored `V`; for
`V = Entity<Model>`, that subject is the entity handle. `Entity::update` can
then borrow the model and provide `Context<Model>` for exactly the duration of
its callback.

A focused API could look like:

```rust,ignore
div().select_entity::<SearchView>(
    Select::children().class("search-view"),
    |view, cx| {
        view.query_text.clear();
        cx.notify();
    },
)
```

Internally, select against the subject type `Entity<SearchView>`, downcast the
authored handle, and call `Entity::update(app, |model, cx| edit(model, cx))`.
The closure bound must be higher-ranked over both mutable references, return
unit, and be `'static` as a stored selector callback. This makes the entity
guard callback-local. Do not expose a guard-bearing projection object or
return a borrowed model from the selector. A more general `select_with`
callback that receives `&mut App` (and optionally `&mut Window`) can support
other context-sensitive projections, but expands the public surface and lets
all selector callbacks mutate application state.

## Constraints and costs

- Thread `&mut App` into selector `apply` from the request-layout path. Keep
  the current rule that edits happen before layout; do not run these callbacks
  from prepaint/paint, where a second model lease may conflict with rendering.
- Entity update should use the existing lease/context machinery. A matching
  selector therefore incurs one entity lookup/lease/context construction per
  actual callback invocation, in addition to the existing matcher and boxed
  transform costs. There is no extra model allocation or reflection lookup
  when the subject type is statically selected.
- Callbacks can run more than once because of measurement and layout retries;
  state edits must be repeatable. `notify` is an expected effect, but I/O,
  counters, and append-only side effects are unsafe in this phase.
- The selector must not update a model that is already leased by an enclosing
  render/update. Applying at before-layout entry currently precedes
  `ViewElement`'s `render_view` call, which is the useful ordering guarantee.
- An entity-target selector should match the authored `Entity<V>` handle (the
  subject) and preserve the existing scope/class/ID/position predicates. Its
  matching path must not confuse the `ViewElement` wrapper's physical element
  type with the authored view type.

Native authored values remain the better default when the desired object is
already present in the node: existing `select` lends that value with no app
context, lease, or callback setup. Native `Entity<T>` values also remain
useful as handles when users can capture a context or only inspect identity.
The specialized entity callback is justified for the specific gap of
mutating the rendered entity's model with its proper `Context<T>`.
