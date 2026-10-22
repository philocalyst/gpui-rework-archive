# Actual source fixtures

These are byte-for-byte upstream Rust source files stored as `.rs.txt` test
data. Both projects use Apache-2.0; their original code/comments are retained.
They are not tool production code, translated applications, or invented
all-pass examples.

| Fixture | Source pin and original path | SHA-256 |
|---|---|---|
| `hummingbird-window-header.rs.txt` | Hummingbird `e15e8ba0ef6ff5445294030d373e3c8ccc7d780c`, `src/ui/components/window_header.rs` | `26cc71f26833e5551bd07d35ab568865e01ca1fe2733db72a561073280f2e0b1` |
| `gpui-counter.rs.txt` | GPUI-CE repository commit `41a42eb96d6c04e5e71f3577d12934d4de569b20`, `crates/gpui/examples/counter.rs` | `567f4fee8f9ee8c293d33d3bc0d4aac1d8ee7c399e5510837bd55c9d47c41d9a` |

Hummingbird's [actual source](https://github.com/hummingbird-player/hummingbird/blob/e15e8ba0ef6ff5445294030d373e3c8ccc7d780c/src/ui/components/window_header.rs)
contains glob imports, a derived element, RenderOnce/context scaffolding,
conditional macros, decorations, nested layout and window controls. The full
file receives diagnostics and **zero edits**. Its exact line-104 expression
`div().w(px(72.0))` is tested separately inside explicit canonical imports and a
small declared parser-context function. The expression is verified to occur in
the preserved source before that positive local-rule test runs. No claim is
made that the wrapper is upstream code or that the header has been ported.

The full actual GPUI counter contains app/entity/render/context/input-handler
scaffolding and unsupported chains. It receives diagnostics and **zero edits**.
The old source remains accessible in this repository at the pinned commit.

Rule proof sources at that same original GPUI pin:

- `crates/gpui/src/geometry.rs:4058`: `px(pixels: f32) -> Pixels`.
- `crates/gpui/src/styled.rs:81`: canonical `Styled` builder trait;
  its `flex` documentation at line 218 explicitly specifies default row flow.
- `crates/gpui/src/elements/div.rs:2598`: the original div constructor.

The clean-room target contract is pinned by tool-base commit `8a157b3b47`:
`reactivity/crates/gpui/src/element.rs:513` and following define numeric
`w/h/size/gap/p`; `style.rs:10` and `style.rs:57` define default column flow;
`style_port.rs` and the sealed `IntoLength` implementations retain f32 input
conversion. Explicit row `flex()` applies `Flex::row()` without changing other
properties. These are local property/API conditions, not evidence that the two
frameworks implement every layout or application behavior identically.
