+++
title = "Edit a running example"
description = "Change Rust in the Miri workbench or save a native hot patch with the GPUI CLI."
weight = 110
+++

Change a label, click its button, and follow the value through the next frame.
Each walkthrough uses one Rust component in its native program and browser
workbench.

## Edit Rust in the browser

Start the local documentation server from the checkout:

```sh
python3 site/scripts/dev.py
```

Open a walkthrough and choose **Edit Rust**. The workbench runs your component
under [Miri](https://github.com/rust-lang/miri), using the real `gpui` crate.
GPUI lays out and paints the component; the browser displays that scene and
sends input back to the running interpreter. Clicks update the same entities
between frames.

Edits run after a short typing pause. **Run** or Ctrl/⌘ Enter runs immediately.
A source change starts a fresh component; **Reset state** restarts the current
source. Errors appear below the editor, with the last successful frame still
visible. Fix the source to resume interaction.

The workbench edits the component, including its setup function. The complete
source download also contains the native application entry point. Use that
program in your editor with ordinary Cargo:

```sh
cargo run -p gpui-documentation-examples --example counter
```

The published site can display the original programs without a local service.
To execute edits, use the local server above.

## Save a native hot patch

The [`gpui` CLI](https://github.com/gpui-ce/cli) builds and watches native
applications. Install it, then select the walkthrough's Cargo example:

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
[the CLI's watch behavior](https://github.com/gpui-ce/cli#behavior-and-limitations) for
its target selection and rebuild rules.
