# Direct reactive style ports

First implementation source: `2926d66cdd`, foundation `f01947e679`.
The `first/` artifacts record that implementation before the separately requested
compact generic-Flex refinement. These are untimed functional/requested-allocation
checks; there is no latency, throughput, RSS or OS-memory claim.

The [combined integration gates](integration/checks.json) pin `b1fc101435`
after the pointer protocol and paint substrate were integrated: 609 workspace
cases/doctests, 126 accessible native units, strict Linux/macOS/Windows desktop
checks, and actual X11 reactive-style/Todo/scroll pixel oracles pass. macOS and
Windows checks are cross-compilation only. The reports below preserve each
isolated implementation and the first recipe's measured regression.

The implementation uses the existing owner-relative field registry and static
property schema. A source freezes once per exact publication; all text/style
sinks are admitted before any destination/base edit. Dynamic inspector bases
advance beneath masks. Read-only unregistered operands retain no address/observer.
See [public input scope and limits](../../crates/gpui/STYLE_PORTS.md).

## Actual gates

- Full `cargo test -p gpui`: 362 passed across 39 test summaries, including 23
  compile-fail docs; 8 intentionally ignored fixtures. Twelve new public style
  cases cover masks, both installation orders, failures/cohorts, component
  namespaces, last write, borrowed Flex, numeric admission and virtual lists.
- Strict all-target Clippy passed headless and normal accessible X11.
- Actual X11 style test passed on private Xvfb106: native pointer press/release
  resized a bound dimension and then recolored a bound surface, awaiting real
  acknowledgement after each input. Source reads2, descriptions0, owner reruns0;
  complete server pixels exactly matched the Canvas diagnostic image. Explicit
  ReferenceCpu did not initialize Wgpu. This is not a new AT-SPI/GPU timing claim.
- The ordinary `reactive_styles` example passed its headless public input/semantic
  and pixel run, with source reads2, destination comparisons3, layout runs1,
  descriptions0 and owner reruns0. Native users run the same model with
  `cargo run -p gpui --features x11 --example reactive_styles -- --cpu`.

## Requested storage

64-bit host layouts: Style88, El176, Draft152, Node40, Presented80, Runtime<()>2384,
Destination4. These ordinary headers are unchanged. SourceCodec is8 and Fanout32
(previously TextCodec16/Fanout40); existing fanout vectors remain build/retained
Vecs. Freezing them to Box slices would require a separate build-map conversion;
that additional construction tradeoff was not silently added to this slice.

Decorations48 and ElementExtra56 share dynamic fields, radius, scroll and names.
The closed leaf enum is56, and can never contain another decoration. A decorated
image/reader/list may need that one additional leaf box. Literal/semantic-only
legacy forms retain their existing fast shape. Flex is104 in this first source,
a real transient/stored-recipe regression targeted by the separate refinement;
recipes allocate nothing. The previous description estimated the preceding
literal recipe at16B; an independent probe of the exact f019 source measured12B.
The raw first-source artifacts remain unchanged. See the final generic recipe
and baseline probe in [compact-Flex evidence](compact-flex/README.md).

Element construction, requested bytes (allocator requests, not allocator bins):

| Bound sinks | Requests | Cumulative bytes | Retained bytes | Peak live bytes |
|---:|---:|---:|---:|---:|
| 0 literal | 0 | 0 | 0 | 0 |
| 1 | 2 | 80 | 80 | 80 |
| 2 | 3 | 128 | 104 | 128 |
| 8 | 5 | 416 | 248 | 344 |
| 1 + radius + scroll + name, repeated1000 times | 3 | 128 | 128 | 128 |

The binding Vec starts with capacity1 and grows1/2/4/8. Repeated same-property
builders replace one entry. A final literal releases the obsolete binding and
empty extra; no borrow/edge remains installed. Peak counts reallocating storage
while old capacity is still live. The repeated composition does not grow a
recursive wrapper chain or allocate per repetition.

Fresh recording owners (no CPU framebuffer), same three registered sources and
identical initial resolved style in all four controlled rows:

| Bound sinks | Requests | Cumulative bytes | Retained bytes | Peak live bytes | Fanouts | Destination capacity bytes |
|---:|---:|---:|---:|---:|---:|---:|
| 0 | 43 | 7688 | 6372 | 6532 | 0 | 0 |
| 1 | 48 | 8336 | 6844 | 7004 | 1 | 16 |
| 2 | 49 | 8384 | 6844 | 7004 | 1 | 16 |
| 8 | 55 | 8928 | 6892 | 7052 | 3 | 64 |

The separate plain empty-source owner remains exactly34 requests,6824 cumulative,
5580 retained,5740 peak bytes, matching the preceding ordinary-scroll floor.
The controlled rows include schemas, model, runtime, layout and scene preparation,
not just bindings; they are not comparable to the plain row as isolated fanout cost.
A first independent style edit can densify the existing shared style palette;
that established style-lane cost is not removed by direct binding.

## Limits and reproduction

This removes View work for registered direct sinks. Ordinary scene preparation
still traverses retained nodes. Paint-only ports in mixed virtual-list windows
also skip re-description; layout/geometry style changes conservatively realize
lists once. No sparse paint-command/AT traversal guarantee is claimed here.

From the repository, with the pinned Rust toolchain on PATH:

```sh
cargo test --manifest-path reactivity/Cargo.toml -p gpui
cargo clippy --manifest-path reactivity/Cargo.toml -p gpui --all-targets -- -D warnings
cargo clippy --manifest-path reactivity/Cargo.toml -p gpui --features x11 --all-targets -- -D warnings
cargo test --manifest-path reactivity/Cargo.toml -p gpui --lib style_port_tests -- --nocapture --test-threads=1
cargo test --manifest-path reactivity/Cargo.toml -p gpui --lib semantic::decoration_tests -- --nocapture --test-threads=1
DISPLAY=:106 cargo test --manifest-path reactivity/Cargo.toml -p gpui --features x11 --lib native::style_tests::native_reactive_dimensions_and_color_match_full_server_image -- --ignored --exact --nocapture
```

The native command requires a real X11 server; it does not skip success when
unavailable. This run used Xvfb21.1.24 and the loader configuration in
`/tmp/gpui-native-env.sh`; source/binary/toolchain pins and raw logs are under
`first/`. Native standard profiles include the real AccessKit backend, but no
screen reader activation or cross-OS runtime proof was added in this slice.
