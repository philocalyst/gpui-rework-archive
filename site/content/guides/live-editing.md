+++
title = "Edit a running example"
description = "Use the native hot-patching workflow and distinguish it from browser previews."
weight = 110
+++

Walkthrough previews are compiled GPUI WebAssembly applications. The editable
Miri workbench is a separate runtime: its current companion runs natively. That
does not meet the browser-portability requirement for an editor that must run
Miri entirely in WebAssembly. Treat browser editing as unavailable until that
runtime has been implemented and verified; the compiled preview remains useful
for trying the published component.

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
