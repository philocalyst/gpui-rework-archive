# Hot patching

GPUI-CE can update UI rendering code in a running native debug application
without restarting its process or recreating its windows. The integration uses
Dioxus CLI's Subsecond runtime.

## Setup

Enable the `hot-patching` feature on the dependency. Until a release includes
the feature, use the repository revision that contains it:

```toml
gpui-ce = { git = "https://github.com/gpui-ce/gpui-ce", features = ["hot-patching"] }
```

Install the compatible Dioxus CLI:

```sh
cargo install dioxus-cli --version 0.7.10 --locked
```

From the application Cargo project, run:

```sh
dx serve --hot-patch
```

Edit and save a `Render::render` function. A successful patch redraws the
existing window without starting a new process. The [browser and native
examples](../site/content/examples/_index.md) provide small starting points for
a separate application that depends on this checkout.

## Limits

This feature is experimental. A patch can fail or crash the application, so
keep the ordinary restart workflow available. Dioxus CLI monitors the
application crate and its direct workspace dependencies; changes in indirect
dependencies require a rebuild. Hot patching is unavailable on WASM and in
release builds. The integration covers view rendering and element layout,
prepaint, and paint; other functions may require a restart.

Dioxus CLI 0.7.10 can reject examples launched directly from the GPUI-CE
workspace with `Cycle in workspace dependency graph`. Run a separate application
that depends on this checkout instead. Report problems in the
[issue tracker](https://github.com/gpui-ce/gpui-ce/issues).
