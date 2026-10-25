# Cross-module schema discovery frontier

This experiment keeps an isolated copy of the GPUI value runtime and adds two mechanisms:

1. `shape_at_site!(T)` expands an autoref probe at the concrete field-type expression. The
   `T: Describe` implementation handles a real described type, including one from another module;
   the fallback consults a linked `inventory` table by `TypeId`, then returns an opaque schema.
2. `register_schema!(T)` models the small registration that a monomorphic reflection derive could
   emit for every non-generic reflected type. It contains a type-id function and a lazy schema
   factory, so registration does not initialize the schema while inventory is enumerated.

`Vec<T>`, `Option<T>`, `Box<T>`, and `[T; N]` have blanket `Describe` implementations. These return
typed `Schema<Container>` values with lazy child factories. The user-defined `shadow::Vec`,
`shadow::Option`, and `shadow::Box` resolve as structs; Rust aliases of standard containers resolve
as those containers. Classification follows the actual type's trait implementation, never the
last identifier in its source path.

## Run

```sh
cargo test --manifest-path tooling/api-experiments/schema-discovery-frontier/Cargo.toml \
  --target-dir /tmp/schema-discovery-frontier-target
```

The experiment exercises an external module's types, Rust aliases, same-named user types,
monomorphic schema discovery from unbounded generic code, generic `Vec<T>`, canonical opaque-slot
upgrade, recursive `Box<Option<Self>>` initialization, arrays, and concurrent cold lookups. It
imports the runtime tests from its isolated snapshot. Tests run with an isolated target directory
and do not build GPUI.

## Stable Rust limits

The autoref probe belongs in the generated expression at the concrete field site. A helper such
as `fn shape_of<T>()` cannot specialize later for a concrete `T`. However, an unconstrained generic
field whose actual monomorphization happens to be a `Vec<U>` remains opaque unless that exact type
has a linked factory or code explicitly calls `Type::of::<Vec<U>>()`. Stable Rust cannot inspect a
future monomorphization from an unconstrained generic `T` body.

For a declared `Vec<T>` field inside a generic parent, there is no such problem: `Vec<T>: Describe`
is known from the blanket impl, so its sequence schema is available even though `T` is generic. Its
child factory calls `Type::discover::<T>()`. If `T` has a linked monomorphic schema, the child is
described immediately. Otherwise it gets the canonical opaque `Type` slot; that same handle sees
the description later if some code calls `Type::of::<T>()`. The nested-wrapper test exercises this
upgrade. It preserves laziness and avoids re-entering a recursive root's schema initializer.

The production expression for a concrete named field is conceptually:

```rust
|| {
    let probe = Probe::<FieldType>(PhantomData);
    (&probe).shape()
}
```

The fallback calls `Type::discover::<FieldType>()`, which looks for a linked monomorphic factory by
`TypeId` and otherwise returns the canonical opaque slot. The standard-container implementations
return an unpublished `Schema<Container>` built by `Schema::vec/option/boxed/array`; calling the
public `Type::vec` family from `Describe::build_type` would publish the root before `Type::of`
finishes and re-enter initialization. Each `Schema::Container` constructor stores only the lazy
child function. This small typed constructor family is the production API addition the experiment
needs.

This removes AST container-name heuristics for `Vec`, `Option`, `Box`, and arrays, including aliases
and generic `Vec<T>` fields. It does not make arbitrary unconstrained generic `T` discoverable at
compile time. No per-container registration macro is needed; the existing monomorphic reflection
derive can emit the user-type registry entry.

The inventory table's cold lookup is linear in linked registration count in this prototype. A
production version should build a once-initialized `TypeId` map, use the existing linked metadata
pattern, and measure cold allocation/lookup costs before choosing the cache. No allocation or
performance claim is made here. The current runtime's schema cache does canonicalize handles under
concurrency, though simultaneous first builders can each construct and leak a losing schema before
the winner is selected; this is existing runtime behavior and warrants separate cache work.
