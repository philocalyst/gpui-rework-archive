# Input and window API documentation audit

This pass covers the public input and interaction vocabulary in `crates/gpui/src/input.rs`,
`interactive.rs`, `gestures.rs`, `keymap.rs`, `key_dispatch.rs`, `action.rs`, `tab_stop.rs`,
`platform/keystroke.rs`, and `platform/keyboard.rs`. The comments describe observable contracts
and link the related types so that a reader can move from platform input to keymap dispatch and
then to a view handler.

The primary walkthroughs are the [counter update example](https://gpui-ce.github.io/examples/counter/#update)
and the [actions examples](https://gpui-ce.github.io/examples/actions/#focus), especially its
[bindings](https://gpui-ce.github.io/examples/actions/#bindings) and
[dispatch](https://gpui-ce.github.io/examples/actions/#dispatch) sections. They provide the
reader-facing context for the API-level explanations in rustdoc.

## Coverage

- UTF-8/UTF-16 conversion and `EntityInputHandler` lifecycle in `input.rs`.
- Platform event vocabulary, touch cancellation, mouse focus semantics, and click metadata in
  `interactive.rs`.
- Axis locking, gesture thresholds, and iOS/Android momentum models in `gestures.rs`.
- Keymap revision, append order, precedence, pending prefixes, and disabled bindings in
  `keymap.rs`.
- Action naming, registration, JSON construction, and error meaning in `action.rs`.
- Tab-group replay and wraparound traversal in `tab_stop.rs`.
- Keystroke parsing, IME metadata, modifier portability, and keyboard-layout adapters in the
  platform modules.

## Review ledger

| Module | Reviewed declarations | Changed doc lines | Retained | Remaining gap |
| --- | ---: | ---: | ---: | --- |
| `window.rs` | 302 documented public or implementation-facing declarations | 31 | Existing comments retained elsewhere | Native backend behavior still varies by platform; a few `pub(crate)` plumbing methods are intentionally undocumented. |
| `input.rs` | 5 | 26 | Existing comments retained elsewhere | None found in the assigned public surface. |
| `interactive.rs` | 53 | 28 | Existing comments retained elsewhere | Platform-specific event synthesis remains backend-owned. |
| `gestures.rs` | 13 | 13 | Existing comments retained elsewhere | Physics constants should follow the live gesture examples as they settle. |
| `keymap.rs` | 12 | 12 | Existing comments retained elsewhere | Context tree examples belong in the Zola walkthrough. |
| `action.rs` | 11 externally documented registry/action declarations | 10 | Existing comments retained elsewhere | Registry internals are crate-private. |
| `tab_stop.rs` | 8 documented operations | 0 | Existing comments retained elsewhere | Traversal visualization belongs in the site examples. |
| `platform/keystroke.rs` | 36 | 16 | Existing comments retained elsewhere | Display mapping remains OS-specific. |
| `platform/keyboard.rs` | 3 | 6 | Existing comments retained elsewhere | Backend adapters determine available layout metadata. |

The reviewed counts include declarations whose Rust visibility is `pub` inside crate-private
implementation types, because those methods still shape the implementation contract. “Changed” is
the number of added or replaced documentation lines in the working diff; retained comments were
checked against the implementation and left in place when they already stated ordering, ownership,
platform scope, or fallback behavior clearly. The remaining gaps are integration or backend details
rather than undocumented public semantics.

## Follow-up limits

`window.rs` and `key_dispatch.rs` are large internal integration surfaces. Their dispatch ordering
and platform capability notes still deserve a focused pass against the live Zola walkthroughs,
particularly around deferred callbacks, pointer capture, IME preference, and action replay. Those
details should be documented only after the corresponding example and implementation tests settle,
so the prose does not promise behavior that is still changing on the example/live-reload branch.

The docs.rs post-processor and comment-DSL renderer are site-level work and are intentionally not
implemented in this API-only slice. The links above are stable reader entry points for integrating
that work later.
