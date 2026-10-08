# Key dispatch

Key dispatch is documented in the canonical [input chapter](input.md), also
published in the [GPUI Book](https://gpui-ce.github.io/book/input.html).
That chapter connects the focus handle, context predicate, typed action, and
listener in one compilable example. It also covers precedence, propagation,
multi-stroke shortcuts, and the boundary between key events and text input.

For a complete program, follow [keyboard actions](https://gpui-ce.github.io/examples/actions/).
For a shortcut that does nothing, use the [focus troubleshooting guide](https://gpui-ce.github.io/guides/focus/).

GPUI supplies bindings and an action registry, but does not prescribe a keymap
file format. An application loading a JSON keymap owns the file's envelope,
validation, and error reporting. Keep that application's format separate from
the Rust binding and action contracts.
