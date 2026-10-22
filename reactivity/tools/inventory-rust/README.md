# Standalone source tools

This package has its own `[workspace]` and shares no runtime dependency with
the UI. `inventory-rust` remains the existing JSON-lines AST inventory helper.
The additional `gpui` binary is a deliberately rough local migration assistant.

```sh
# From the repository root; only this small tool package is built.
cargo build --release --locked \
  --manifest-path reactivity/tools/inventory-rust/Cargo.toml --bin gpui
cargo install --locked --path reactivity/tools/inventory-rust --bin gpui

# Run inside the application being migrated.
gpui migrate src                 # prints a diff; does not write
gpui migrate --apply src         # prints the same diff, then writes
gpui migrate -- path-with-dashes.rs
```

Without paths, `migrate` scans the current directory. It processes `.rs` files
in deterministic order, skipping `.git`, `target`, `vendor`, `node_modules`,
and directory symlinks. Explicit symlinks are rejected. Files exceeding 4 MiB,
invalid UTF-8, parse errors, or overlapping planned edits are rejected. A parse
error anywhere prevents the entire apply batch from writing. Located manual
diagnostics go to stderr; the reviewable unified diff goes to stdout. Exit 2
means a command/preflight/write error; manual diagnostics alone are not errors.

The sole edit removes a direct `px(<finite nonnegative f32 float literal>)`
wrapper in a closed `div()` leaf-sizing chain containing only `flex()`, `w`,
`h`, `size`, `p`, and `gap`. `-0.0` is retained with its sign. For example:

```diff
 use gpui::{div, px, Styled};
-fn spacer() { let _ = div().w(px(72.0)); }
+fn spacer() { let _ = div().w(72.0_f32); }
```

This is a local rule under **explicit API assumptions**: the input is valid
Rust using the pinned legacy GPUI constructors and Styled methods, and the
destination is this clean-room API. Syn supplies syntax and spans, not Rust
whole-program name or trait resolution. An explicit canonical `use gpui::Styled`
is required. Unqualified helpers additionally require canonical `gpui::div` and
`gpui::px` imports, without competing bindings or globs. Qualified helper paths
bypass local function shadowing, but not glob imports or ambiguous crate aliases. Nested
imports/inline modules, attributes and macros disable file edits conservatively;
the tool does not expand them or infer their bindings. Unknown methods reject
the entire receiver chain rather than rewriting a superficially safe prefix.

The original `px` takes **f32**, a real decimal-rounding boundary. The target
accepts an f32 literal through `IntoLength` (widen to f64, then narrow back).
Emitting an unsuffixed literal or an `as f32` cast after f64 inference can change
rounding. The tool emits an explicit `_f32` literal, preserves an existing f32
suffix, and rejects f64 suffixes, computed expressions and negative lengths.
Tests include a decimal where f64-to-f32 double rounding differs from direct
f32 parsing, as well as the `16777217.0` integer-precision boundary.

The closed chain cannot create children. An empty leaf spacer's direction is
unobservable; an explicit `flex()` row keeps that direction. No flex/layout
normalization is attempted: legacy bare divs and target divs have different
default directions, so any populated or unknown chain remains manual. Colors,
relative units, corner helpers, font helpers, ownership/state/Entity/Context,
Render implementations, input controls and app scaffolding are not translated.
Located diagnostics identify these decisions. Legacy imports remain untouched
and must be reviewed; the result is not claimed to compile as a migrated app.

Edits replace only selected UTF-8 byte ranges; proc_macro2 character columns
are converted through each original line's Unicode character boundaries. Other
source bytes, comments, formatting, newline style and file permissions remain
unchanged. A comment inside a px wrapper declines that entire chain instead of
discarding the comment. The diff is accepted by `git apply --check`, including
Unicode/space paths, CRLF and a missing terminal newline.

`--apply` rereads all proposed files before the first write, then uses a
create-new temporary file and atomic same-directory rename per file, with a
second original-byte check. It never deletes a preexisting temporary path.
This is optimistic conflict detection, not a cross-file transaction or an
editor lock: an I/O error can leave already reported files applied, and a
concurrent writer can race the final check. Review changes in version control.

See [fixture provenance](fixtures/migrate/README.md). Full real sources are
deliberately manual; the positive real expression is a declared clipped parser
context, not an application-port success claim. No migration percentage is
reported.

```sh
cargo test --locked --manifest-path reactivity/tools/inventory-rust/Cargo.toml
cargo clippy --locked --manifest-path reactivity/tools/inventory-rust/Cargo.toml \
  --bin gpui --test migrate_cli -- -D warnings
```

The CLI integration tests intentionally use synchronous subprocesses, scoped
outside the UI's blocking-process prohibition; no async dependency was added.
