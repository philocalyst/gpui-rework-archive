# Compact typed Flex recipes

Source: `3b710c9d33`, after first style-port source `2926d66cdd` and evidence
`fb2f56387a`. This refinement stores original Copy operands in a generic recipe
and converts present fields only when `El::layout` lowers it. It adds no source
graph, runtime property model or persistent fields. These are functional and
requested-allocation checks; no latency, throughput or RSS campaign was run.

## Representation and const behavior

| Recipe | Bytes | Construction allocation requests |
|---|---:|---:|
| Original f019 literal Flex | 12 | 0 |
| First reactive erased recipe | 104 | 0 |
| Final default-f32 literal Flex | 12 | 0 |
| Final integer-gap Flex<i32> | 12 | 0 |
| Final four borrowed signal fields | 40 | 0 |

The first104B source and its raw logs remain historical evidence. Its narrative
had estimated the original literal recipe at16B; `baseline-size.txt` corrects
that estimate using the exact public f019 style source. The standalone probe
stubs only imported Color/Affine, neither of which is stored in Flex; this is a
type-layout probe, not a baseline application benchmark. Probe sources and hashes
are retained here; `baseline-style.rs` is the unmodified `git show f01947e679`
style module. Its original probe refers to that file under `/tmp`.

Stable Rust1.97 accepts the public constant recipes:

```rust
const TOOLBAR: Flex = Flex::row().gap(8.0).align(Align::Center).wrap(true);
const INTEGER_GAP: Flex<i32> = Flex::row().gap(8);
```

Inline integer and borrowed-signal recipes infer their operand types, and
borrowed recipes copy those same operands. Missing fields leave earlier
declarations untouched. Default typed `Flex` means an f32 gap, so its named
integer-gap spelling needs `Flex<i32>` or8.0. Whole `Signal<Flex>` is still
deferred. The public midpoint regression preserves inherited f019 numeric
integer-to-f64-to-f32 conversion, including its double rounding; this refinement
does not change numeric admission.

## Exact final gates

- Full `cargo test -p gpui`:365 passed across39 summaries,8 intentionally ignored,
  including23 compile-fail docs. The focused total includes98 library cases,
  10 public Flex cases and13 public style-port cases.
- Strict all-target Clippy passed headless and standard accessible X11.
- Actual X11 native pointer resize/recolor test passed on private Xvfb106. Each
  operation awaited actual acknowledgement; complete server pixels matched the
  Canvas image. It used ReferenceCpu and initialized no Wgpu device. The0.08s
  test-harness duration is not a performance claim.
- The public headless `reactive_styles` example kept pixel digest
  `665863fae8c84b85`, source reads2, destination compares3, layout runs1,
  descriptions0 and owner reruns0.

No new AT activation or cross-OS runtime proof is claimed by this narrow recipe
refinement. Standard X11 features include the real AccessKit backend.

## Unchanged floor and construction ledger

Final64-bit layouts are Style88, El176, Draft152, Node40, Presented80,
Runtime<()>2384, Fanout32, Destination4. The recipe change introduces no ordinary
node, owner or presentation field. Final owner and element ledgers in
`allocations.csv` exactly reproduce the first source's requested counts:

| Bound element sinks | Requests | Cumulative bytes | Retained bytes | Peak live bytes |
|---:|---:|---:|---:|---:|
| 0 literal | 0 | 0 | 0 | 0 |
| 1 | 2 | 80 | 80 | 80 |
| 2 | 3 | 128 | 104 | 128 |
| 8 | 5 | 416 | 248 | 344 |
| 1 + radius + scroll + name, repeated1000 times | 3 | 128 | 128 | 128 |

The empty-source ordinary owner remains34 requests,6824 cumulative,5580 retained,
5740 peak requested bytes. These allocator request counts do not describe actual
allocator bins or OS memory. Native projection and full retained-scene preparation
costs remain outside the recipe-size claim.

## Reproduction

From the worktree, with the pinned toolchain and native loader paths:

```sh
cargo test --manifest-path reactivity/Cargo.toml -p gpui
cargo clippy --manifest-path reactivity/Cargo.toml -p gpui --all-targets -- -D warnings
cargo clippy --manifest-path reactivity/Cargo.toml -p gpui --features x11 --all-targets -- -D warnings
cargo test --manifest-path reactivity/Cargo.toml -p gpui --lib style::recipe_tests
cargo test --manifest-path reactivity/Cargo.toml -p gpui --lib style_port_tests -- --nocapture --test-threads=1
cargo test --manifest-path reactivity/Cargo.toml -p gpui --lib semantic::decoration_tests -- --nocapture --test-threads=1
DISPLAY=:106 cargo test --manifest-path reactivity/Cargo.toml -p gpui --features x11 --lib native::style_tests::native_reactive_dimensions_and_color_match_full_server_image -- --ignored --exact --nocapture
cargo run --manifest-path reactivity/Cargo.toml -p gpui --example reactive_styles
```

The native test requires real X11 and fails when unavailable. The captured run
used Xvfb21.1.24 on an isolated display, the native loader environment recorded in
`native-env.sh`, and the exact binary hash in `source.txt`. The native proof was
an untimed functional test, not part of a quiet performance capture.
