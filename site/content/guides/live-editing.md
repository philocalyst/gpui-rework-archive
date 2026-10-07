+++
title = "Edit a running example"
description = "Choose native hot patching, browser compilation, or the Miri guest workbench."
weight = 110
+++

The workflows below execute different kinds of source. Choose the one that
matches the program you are editing.

## Edit a full GPUI program in the browser

The walkthrough preview is built from its canonical Rust program. Open “Edit
and run the Rust source” to change that program. A local compiler compiles it
to WebAssembly and replaces the iframe after a successful build. Compiler
errors leave the last successful preview visible.

```sh
python3 site/scripts/dev.py
```

This starts the Zola preview and the loopback compiler. The compiler uses the
same checkout and dependencies as the walkthroughs. A production static host
serves the prebuilt programs; it does not provide a public Rust compilation
service. Downloads and reading remain available without a compiler.

## Hot-patch a native debug application

Enable `hot-patching` on the core dependency, then use the matching Dioxus CLI:

```sh
cargo install dioxus-cli --version 0.7.10 --locked
dx serve --hot-patch
```

Use a separate Cargo application depending on this checkout. DX can reject
examples launched directly from the workspace with a dependency-cycle error.
Edits to supported render and element entry points can redraw existing windows;
other changes require a rebuild or restart.

> [!WARNING]
> Hot patching is experimental and a patch can fail or crash the application.
> Keep the ordinary restart workflow available. It does not run in WASM or
> release builds, and indirect dependency changes may need a rebuild.

## Use the Miri guest workbench

The separate codepen integration interprets Rust through vendored Miri and
transports a supported element tree to GPUI. Its source imports
`gpui_codepen_guest`, a smaller API. It cannot execute an arbitrary `gpui::Render`
program unchanged.

The workbench uses a local companion at `/api/render` and `/api/cancel`, with
its own setup and toolchain. Its speed settings disable several Miri checks;
it is an execution workflow, not an undefined-behavior verification run.
See the integration's README for its supported operations and setup. The full
GPUI previews above continue to use compiled WebAssembly.
