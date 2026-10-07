+++
aliases = ["getting-started/counter-tutorial.html", "guide/getting-started/counter-tutorial/"]
title = "Take an example into an editor"
description = "Download a complete program and use dependencies from the same checkout."
weight = 20
+++

Each walkthrough offers the canonical `main.rs` and a Cargo project. The source
contains the shared platform helper, root-view constructor, and application
entry point; copying only a `Render::render` snippet leaves out window creation
and entity ownership.

## Run the downloaded project

The download targets this checkout's APIs and has path dependencies relative to
the checkout. Extract it under the checkout's `target` directory so those
paths resolve, then run its Cargo manifest:

```sh
mkdir -p target/counter
unzip site/public/examples/counter.zip -d target/counter
cargo run --manifest-path target/counter/Cargo.toml
```

For a project saved elsewhere, edit both path dependencies to point to
`crates/gpui` and `crates/gpui_platform` in one checkout. Keep them on the same
revision because the platform crate implements the traits used by core. Cargo
package names are `gpui-ce` and `gpui_ce_platform`; Rust code imports them as
`gpui` and `gpui_platform`.

> [!NOTE]
> These downloads follow the development checkout. They do not imply that an
> older crates.io release contains every API shown here. Choose a release first
> if you need published dependencies, then read that release's reference.

## Keep the program small

Start with the [counter](@/examples/counter.md): keep view-local state in the
view, mutate it in a listener, and notify after a visible change. Once the
presentation repeats, extract a prop-driven component with `RenderOnce`; when
several views share mutable domain state, move that model into another entity
and keep a handle in each consumer. Splitting code into modules alone does not
require another entity.

The repository's larger examples are under `crates/gpui/examples`; from the
workspace root, `cargo run --example <name>` runs one of those targets. Use
them when the walkthrough's small component omits a native service, a full
editor, or a larger application structure. The [platform guide](@/guides/platforms.md)
and [text guide](@/guides/text.md) explain the boundaries those programs rely on.
