# Development setup

Use Rust 1.95 or newer, as declared by the [core crate](crates/gpui/Cargo.toml).
Install Rust with [rustup](https://rustup.rs), then add the development tools:

```sh
rustup component add rustfmt clippy
```

Follow the [platform setup guide](site/content/guides/setup.md) for Xcode,
Linux development libraries, or the Windows MSVC toolchain.
That page is the maintained source of the website’s setup instructions.
From the repository root, check the setup by opening one window:

```sh
cargo run -p gpui-documentation-examples --example first-window
```

For browser builds and local editing, follow [documentation authoring](docs/documentation-authoring.md).
For headless tests, follow [the testing guide](site/content/guides/testing.md).
