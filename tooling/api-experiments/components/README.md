# Component identity and element wrappers

This experiment folder contains a historical `Component<C>` wrapper prototype and current
consumer tests for the selected component APIs. The retained wrapper prototype is rejected as a
general `RenderOnce` conversion strategy: it consumes `C` when rendering, so it cannot promise
that callable reflection on `C` remains available for later layout or selector work. We are not
proposing to change the `IntoElement` derive to wrap every `RenderOnce` value.

The current direction distinguishes two cases:

- Use `Select::component::<Badge>()` to lend a `RenderOnce` component before its one-time render.
  Query the rendered root separately when it is laid out.
- Derive `gpui::Element` for a durable concrete element when its own identity, custom capability,
  or reflected fields need to remain available through layout. The aggregate derive delegates
  lifecycle/accessibility hooks and selected builder traits to its `#[element]` field. Generic
  wrappers get reflection entries for selected builtin delegates without an explicit
  `#[reflect(...)]`; custom traits and capabilities still require explicit registrations.

For example:

```rust,ignore
#[derive(gpui::Element)]
#[reflect(capability(DRAG => |card| card))]
struct Card {
    #[element(style, children, interactive, stateful)]
    inner: gpui::Stateful<gpui::Div>,
    payload: Option<String>,
}
```

The external `wrapper` integration tests cover a `RenderOnce` component selected and mutated
before consumption, a generic `Element` wrapper with no reflection attribute, and delegated
accessibility through a real rendered window root. The borrowed-field fixture also documents the
`'static` storage boundary. Its retained `Component<C>` implementation is kept as a historical
prototype only.

Run the current tested subset with:

```sh
CARGO_TARGET_DIR=/Users/mileswirht/.codex/worktrees/5226/gpui-ce3/target \
  cargo test --manifest-path tooling/api-experiments/components/Cargo.toml --test wrapper
```

The latest run passed all 3 tests. This command runs the `wrapper` integration target, not every
target in the standalone package.
