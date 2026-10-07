# Hot patching

Save a change to `Render::render` and see it in the existing window. The
[`gpui` CLI](https://github.com/gpui-ce/cli) builds the native application,
watches its source, and sends patches through GPUI's Subsecond integration.

## Run a walkthrough

The CLI repository currently requires access to `gpui-ce/cli`. With that access,
install it from the repository:

```sh
cargo install --git https://github.com/gpui-ce/cli --locked
```

From this checkout, run the counter with hot patching enabled:

```sh
gpui watch -p gpui-documentation-examples --example counter --features gpui/hot-patching
```

Change the button's label in `site/examples/examples/counter.rs` and save. A
successful patch redraws the running window. Invalid Rust leaves the current
application running; correct the source and save again.

For an ordinary build and restart, the same program is a Cargo example:

```sh
cargo run -p gpui-documentation-examples --example counter
```

## Use it in your application

Enable `hot-patching` on your GPUI dependency, then run `gpui watch` from the
application's Cargo directory. Use `--bin name` or `--example name` when there
is more than one target. In a virtual workspace, select the package with `-p`.

```toml
gpui-ce = { git = "https://github.com/gpui-ce/gpui-ce", features = ["hot-patching"] }
```

A path dependency on this checkout works too. On macOS, add the linking feature
used by the CLI's generated application:

```toml
[target.'cfg(target_os = "macos")'.dependencies]
io-surface = { version = "0.16.1", features = ["link"] }
```

## What survives a patch

The process and its existing windows remain alive. GPUI's patch boundaries
cover view rendering and element layout, prepaint, and paint. Edits to those
functions can use the existing entity values.

Changes to data layouts, function signatures, statics, or code outside those
boundaries need a restart. Manifest, lockfile, build-script, shader, and local
dependency changes trigger a full rebuild and restart. The watcher does not
watch arbitrary asset files. See the [CLI reference](https://github.com/gpui-ce/cli#behavior-and-limitations)
for the current rebuild rules.

> [!WARNING]
> A patch does not migrate entity state to a new Rust type layout. Restart the
> watcher after changing a struct's fields or an enum's variants.

The CLI targets native debug applications on macOS and Linux. It does not
hot-patch the browser previews. Their editor runs Rust under Miri instead;
see [editing a walkthrough](../site/content/guides/live-editing.md).
