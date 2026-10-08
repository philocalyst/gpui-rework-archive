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

Declare the example in `site/examples.toml`. The canonical source is a Cargo
example under `site/examples/examples`; it imports the shared
`site/examples/src/support.rs` launcher. Give each example a component
constructor that creates its root entity. Its concrete return type depends on
the view, for example `Entity<Counter>`. Keep the native entry point as
`pub fn main() { support::run(component); }`. The generator uses the canonical
source to produce the displayed walkthrough and downloads. Keep runtime
descriptions aligned with the implementation actually shipped: the current
native Miri companion is not a browser-portable execution environment, and
documentation must not describe it as one.

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
download, component registry, and `site/static/api-examples.json`. `--check`
performs a deterministic staleness check. Run
`python3 scripts/docs/sync_links.py` after generation to create the docs.rs
include files and bounded `docs:examples` attributes. Both commands are safe
to rerun; they remove only their own generated outputs.

The generated chapter uses stable anchors (`#state` above), links each annotated
API to its versioned docs.rs page, and links back to the exact example step.
`scripts/docs/postprocess.py` adds those backlinks to local rustdoc HTML and
turns rendered `> [!NOTE]`, `> [!TIP]`, and `> [!WARNING]` blocks into accessible
`aside` elements. It accepts a path prefix and does not fetch the network.

## Share conceptual chapters

The mdBook under `book/` renders the same explanations as the conceptual API
guides. Its chapter stubs select canonical sources through `scripts/docs/book.py`;
the preprocessor adapts links, not prose. Edit `crates/gpui/docs/*.md`, or the
ownership module's inner documentation, rather than maintaining a second copy.
Testing, accessibility, and drawing also render at their Zola guide routes.

Build local rustdoc before building the book so every API member link can be
checked against an actual page and anchor:

```sh
cargo doc --locked -p gpui-ce --lib --no-deps --features test-support,bench-support
mdbook build book
```

The full site build includes the book and checks its links. It needs mdBook
0.5.4; CI installs that version. Set `MDBOOK` to an executable outside `PATH`
when using a task-local installation. `--with-api` directs book links to the
checkout's API, while the published build uses versioned docs.rs links.

Run `python3 site/scripts/dev.py` to serve the combined artifact at
`http://127.0.0.1:1111` and rebuild after changes to API docs, walkthroughs,
site assets, or the book. A failed build keeps the previous checked artifact.
The server does not start a native compiler or interpreter service by default.
`--native-companion` explicitly enables the native Miri service for runtime
development; it does not establish browser-only editing.

Use `rust,test_harness` for a fenced example containing `#[gpui::test]` so
rustdoc executes the generated test. A plain Rust fence around a test
declaration can compile without running its assertions.
