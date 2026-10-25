# Borrowed path frontier

Standalone experiment for removing the `Outer::Leaf: 'static` bound from GPUI's
`Then` typed path composition. It intentionally uses only `std` and a separate
Cargo workspace. Build output should go to `/tmp`:

```sh
CARGO_TARGET_DIR=/tmp/borrowed-path-frontier-target cargo test --manifest-path tooling/api-experiments/borrowed-path-frontier/Cargo.toml
```

`TypedPath` stores only the path's root and leaf types and its `then` metadata.
The companion `BorrowPath<'a>` provides reference operations for one selected
borrow lifetime. This moves the intermediate `Outer::Leaf: 'a` requirement onto
the lifetime-indexed implementation and lets `Then` compose borrowed
intermediate types while retaining the ordinary `path.get(&root)` call syntax.

Tests cover nested shared and mutable projection through a non-static
intermediate, direct borrowed projection, and compile-fail examples for a
borrow escaping the root and two overlapping mutable results. All code is safe
Rust and std-only. This is a promising standalone API shape; integrating it in
the production trait still needs review of interactions with reflection's
other path consumers.
