# Examples

The [example guide](../crates/gpui/examples/README.md) lists the native targets, their purpose, and focused tests. Run `cargo run --example <name>` from the repository. The walkthrough targets use `cargo run -p gpui-documentation-examples --example <name>`.

```sh
cargo test -p gpui-ce --examples --features test-support
```

This uses GPUI's existing test context and simulated inputs. The example cleanup is independent of the portable rendering and reporting infrastructure.
