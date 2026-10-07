# Authoring examples

Write a Markdown explanation beside the Rust it explains:

```rust
// ## Own the count {#state}
// An [`Entity`] handle keeps this value alive. Cloning the handle shares the
// value; it does not copy the count.

let count = cx.new(|_| 0_u32);
```

A `// ##` heading starts a chapter. The following line comments are Markdown;
the first Rust line starts its code block. The next heading starts the next
chapter. There are no code delimiters or closing directives. An optional
`{#state}` anchor keeps links stable when a heading is renamed; otherwise the
parser derives an anchor from its title.

Use rustdoc-style links such as ``[`Entity`]`` and ``[`Context::notify`]`` in
the explanation. Each resolves through the API catalog in `examples.toml` to
an exact type or method page. The same link adds a reciprocal walkthrough link
to that API's documentation. Link an API where you explain its behavior, rather
than appending a list of every imported type.

Ordinary comments inside Rust stay in the code. Strings and block comments
cannot start chapters. Duplicate anchors, empty explanations, empty code, and
unknown API references are authoring errors. Markdown indentation is retained,
including lists, code fences, and note or warning blocks.

Declare the example in `site/examples.toml`. The canonical source is a Cargo example
under `site/examples/examples`; it uses the shared `site/examples/src/support.rs`
launcher. Define a `fn component(window, cx) -> Entity<View>` constructor and
keep the native entry point as `pub fn main() { support::run(component); }`.
The generator strips only that entry point and launcher from the workbench
source; Miri runs the same component with the real GPUI crate:

```toml
[[examples]]
slug = "counter"
title = "A counter with an entity"
summary = "Build state, render it, and notify the view."
source = "site/examples/examples/counter.rs"
support = "site/examples/src/support.rs"
run = "cargo run -p gpui-documentation-examples --example counter"
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
download, Miri component source, component registry, and `site/static/api-examples.json`. `--check` performs a deterministic
staleness check. Run `python3 scripts/docs/sync_links.py` after generation to
create the docs.rs include files and bounded `docs:examples` attributes. Both
commands are safe to rerun; they remove only their own generated outputs.

The generated chapter uses stable anchors (`#state` above), links each annotated
API to its versioned docs.rs page, and links back to the exact example step.
`scripts/docs/postprocess.py` adds those backlinks to local rustdoc HTML and
turns rendered `> [!NOTE]`, `> [!TIP]`, and `> [!WARNING]` blocks into accessible
`aside` elements. It accepts a path prefix and does not fetch the network.
