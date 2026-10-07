# Authoring examples

Examples live in ordinary Rust files and carry a small, deliberately strict
annotation language. The annotations are comments, so the source still builds
as Rust and remains useful when copied into an editor.

```rust
// docs:step state | Keep state in an entity
// An entity owns the value that changes. The view reads it through its context.
// docs:api gpui::Entity gpui::Context::notify
// docs:code
let counter = cx.new(|_| Counter { value: 0 });
// docs:end
```

Each step needs a unique lowercase `slug`, a title, at least one ordinary `//`
prose line, and a non-empty code section. The parser rejects nesting, duplicate IDs,
unmatched markers, missing prose or code, and marker-looking text inside a
multiline Rust string or block comment. Normal comments inside the code section
are retained in the downloadable source.

Declare the example in `site/examples.toml`. The canonical source is a binary
under `site/examples/src/bin`; it uses the shared `site/examples/src/support.rs`
launcher so native and browser previews exercise the same program:

```toml
[[examples]]
slug = "counter"
title = "A counter with an entity"
summary = "Build state, render it, and notify the view."
source = "site/examples/src/bin/counter.rs"
support = "site/examples/src/support.rs"
run = "cargo run --manifest-path site/examples/Cargo.toml --bin counter"
preview = "counter"
weight = 10

[api."gpui::Entity"]
crate = "gpui-ce"
version = "0.2.2"
path = "gpui/struct.Entity.html"
source = "crates/gpui/src/app/entity_map.rs"
declaration = "pub struct Entity<"
```

Run `python3 scripts/docs/generate.py` to write the chapter, full source
download, and `site/static/api-examples.json`. `--check` performs a deterministic
staleness check. Run `python3 scripts/docs/sync_links.py` after generation to
create the docs.rs include files and bounded `docs:examples` attributes. Both
commands are safe to rerun; they remove only their own generated outputs.

The generated chapter uses stable anchors (`#state` above), links each annotated
API to its versioned docs.rs page, and links back to the exact example step.
`scripts/docs/postprocess.py` adds those backlinks to local rustdoc HTML and
turns rendered `> [!NOTE]`, `> [!TIP]`, and `> [!WARNING]` blocks into accessible
`aside` elements. It accepts a path prefix and does not fetch the network.
