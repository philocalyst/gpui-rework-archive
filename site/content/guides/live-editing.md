+++
title = "Edit a running example"
description = "Change Rust in the browser, retain compatible state, and take the edited program into a native project."
weight = 110
+++

Open a walkthrough and choose **Edit Rust**. The editor puts the component
beside its result. Change the Rust and press **Run**, or use Cmd+Enter on macOS
and Ctrl+Enter elsewhere. **Auto-run** submits an edit after a short typing
pause; turn it off while making several related changes.

## Change behavior without losing the count

In the [counter walkthrough](@/examples/counter.md), increment once. Find its
`increment` method and change `saturating_add(1)` to `saturating_add(5)`.
Run the edit: the count remains one. The next click displays six because the
existing entity now calls the revised helper.

Function-body edits can preserve compatible running state. Changing a type's
layout or a closure's captures can require a new component instance. Watch the
result after an edit; use **Reset state** when you want a fresh instance of
the current program.

| Control | What changes |
| --- | --- |
| **Run** | Checks and runs the current source. Compatible edits can retain state. |
| **Reset state** | Recreates the component from the current source. |
| **Restore** | Replaces the editor text with the original example; it does not itself reset state. |
| **Copy Rust** | Copies the component displayed in the editor, without a platform launcher. |
| **Download** | Saves the edited component as `main.rs`, including its native launcher. |

A Rust error is underlined in the source and reported in **Diagnostics**.
The last successful result stays visible. Input to that old result is paused
while the source differs, so a click cannot silently run the previous program.
Correct the error and run again. Drafts are saved per example in this browser
when local storage is available; download work you need to keep.

Use **Rust**, **Result**, and **Split** to choose the visible panels. The
divider accepts arrow keys as well as dragging, and **Wrap** makes long lines
fit the source pane. API suggestions and hover links lead back to the contract
and the walkthrough steps that explain it.

## Run the edited program natively

Download the walkthrough's Cargo project and extract it into
`target/counter/` inside this checkout. Replace its `src/main.rs` with the
editor's **Download**, then run:

```sh
cargo run --manifest-path target/counter/Cargo.toml
```

Use the matching example name for another walkthrough. These manifests refer
to the checkout's core and platform crates; they are not pinned to the older
published crate with the same declared version. For the original repository
example, ordinary Cargo works:

```sh
cargo run -p gpui-documentation-examples --example counter
```

The page's initial preview runs compiled GPUI WebAssembly. Opening the editor
starts the bundled Rust compiler and Miri interpreter in browser Workers;
editing needs no local compiler service. The first editor load downloads that
runtime and its metadata. Later requests reuse browser-cached assets. Execution
cost and memory use remain higher than the initial compiled preview.

The editor supports these walkthrough components and their bundled
dependencies, rather than arbitrary Cargo dependency installation. Browser
execution cannot establish native dialogs, GPU sharing, IME behavior, or
screen-reader support. Follow the [platform guide](@/guides/platforms.md) for
those boundaries and test the native app when they matter.

## Patch a native example

The [`gpui` CLI](https://github.com/gpui-ce/cli) builds and watches native
applications. Its repository currently requires access to `gpui-ce/cli`. With
that access, install it and select a walkthrough's Cargo example:

```sh
cargo install --git https://github.com/gpui-ce/cli --locked
gpui watch -p gpui-documentation-examples --example counter --features gpui/hot-patching
```

Edit `site/examples/examples/counter.rs` and save. A supported render or element
change redraws the existing window, keeping its entity values. Invalid Rust
leaves the running application intact until the next valid save.

> [!WARNING]
> Restart after changing a struct's fields, an enum's variants, or a function's
> signature. A hot patch replaces code; it does not migrate existing state to
> a different Rust layout.

Manifest, lockfile, build-script, shader, and local dependency changes cause a
full rebuild and restart. Native hot patching supports macOS and Linux. See
[the CLI's watch behavior](https://github.com/gpui-ce/cli#behavior-and-limitations)
for its target selection and rebuild rules.
