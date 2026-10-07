+++
aliases = ["getting-started/counter-tutorial.html", "guide/getting-started/counter-tutorial/"]
title = "Take an example into an editor"
description = "Download a complete program and use dependencies from the same checkout."
weight = 20
+++

Each walkthrough offers `main.rs` and a Cargo project. The source contains the
platform helper as well as the view; copying a display snippet alone does not
create an application.

## Run the downloaded project

The download targets this checkout's APIs. Extract it under the checkout's
`target` directory so its relative dependency paths resolve:

```sh
mkdir -p target/counter
unzip site/public/examples/counter.zip -d target/counter
cargo run --manifest-path target/counter/Cargo.toml
```

For a project saved elsewhere, replace the two path dependencies with the paths
to `crates/gpui` and `crates/gpui_platform` in your checkout. Keep both on the
same revision. The package names are `gpui-ce` and `gpui_ce_platform`; the Rust
imports in the download use `gpui` and `gpui_platform`.

> [!NOTE]
> These downloads follow the development checkout. They do not imply that an
> older crates.io release contains every API shown here. Choose a release first
> if you need published dependencies, then read that release's reference.

## Keep the program small

Start with the [counter](@/examples/counter.md) before moving code into modules.
Put state on the view, extract a reusable presentation into `RenderOnce`, and
use another entity when several views need the same model. Splitting files does
not require another entity for every helper function.

The repository's larger examples are under `crates/gpui/examples`. Run
`scripts/gpui-example list` to see the available targets. Those examples include
capture scenarios and platform helpers beyond the small walkthrough programs.
