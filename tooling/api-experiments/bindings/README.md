# Early-bound native reflection tables

This standalone crate tests one narrow idea for reflected selectors: after a selector has matched an element, validate the whole requested group once and cache the group's typed table record. The callback then reaches native table references directly. A fluent warm registry path repeats the `HashMap<TypeId, Box<dyn Any>>` lookup and typed-table downcast for each capability borrow.

Run the compile-checked prototype and timing loop with:

```sh
cargo run --release --manifest-path tooling/api-experiments/bindings/Cargo.toml
```

The experiment shows:

- `Draggable` and `Badge` are unrelated custom traits, each with a typed `Table<dyn Trait>` and a borrowed projection. `Both<L, R>` composes arbitrary group table records recursively.
- `Interactive: Styled` models inherited builtin access. A second repeated `Styled` group composes through `Both<Styled, Both<Interactive, Styled>>`.
- Builtin access is real storage: the type-level `Off::Slot<T>` is `()`, while `On::Slot<T>` is `&'static T`. `MergeFlag` has all four cases, with `On` absorbing `Off` and `On + On` choosing the left native table. `MergeAccess` derives this record alongside its total type-level OR. Duplicate builtin refs come from the same exact schema entry, so retaining one is safe.
- `Bound::validate` resolves the complete record before any `&mut dyn Any` receiver is passed. A schema missing `Badge` fails binding atomically. The resulting callback carries a 16-byte pair of typed static table refs.
- There is no `unsafe`, `Any` table downcast, or `HashMap` lookup during a callback's trait-method calls. Safe projection from the erased receiver still performs one concrete `Any` downcast per capability borrow; then calls on `&mut dyn Trait` are ordinary native trait-object dispatch. Rust cannot safely lend multiple overlapping mutable trait views at once, so the current example borrows each view sequentially.

On the first release run in this workspace, 2 million four-call callbacks took 94 ms through repeated warm registry resolution and 19 ms through pre-bound tables (4.8x). This small standard-library timing loop is directional, not a Criterion-quality result: it has one element/schema shape, no confidence intervals, and includes the necessary receiver projection in both paths. The useful result is the compiler-checked shape and removal of per-capability registry work; production performance should be remeasured in the existing selector benchmark before adoption.

## Design boundary

This is an API/type-system prototype, not production code. Its `Schema` uses a registry only to resolve references during binding. A production implementation would bind from its immutable `ElementReflection` after selector matching and cache the resulting `NativeTables` record in the selector's existing small cache. The table value can remain a safe function pointer that projects `&mut dyn Any` to `&mut dyn Trait`; no trait-object pointer is stored beyond the receiver borrow. The prototype deliberately avoids expanding the production implementation while the owning worktree is changing it.
