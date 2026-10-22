# Frozen migration assistant

Source: `489533572f4a1b88ec3cc7251b2a06b36dea5f26`, based on main
`8a157b3b47`. Only standalone tool sources, tests, documentation and pinned
test data were added. Cargo manifests, lockfiles, workspace membership and UI
production sources are unchanged. No UI build was run.

The new binary provides `gpui migrate [--apply] [paths...]`. Default output is
a unified diff, never a write. See [the command and proof contract](../README.md)
and [actual-source provenance](../fixtures/migrate/README.md). Name analysis is
deliberately conservative syntax under explicit pinned GPUI API assumptions;
it is not Rust whole-program name or trait resolution. Ambiguity, opaque
expansion, nested scope imports, comments inside a wrapper and unknown receiver
chains decline edits. There is no migration percentage or whole-app claim.

Seven new unit tests and four CLI integration tests pass, alongside the three
existing AST inventory tests. The real full Hummingbird WindowHeader and GPUI
counter sources are parsed and deliberately receive manual diagnostics and
zero edits. The exact real `div().w(px(72.0))` expression is separately tested
inside a declared canonical parser context; its occurrence in the preserved
upstream source is asserted before that positive local-rule test runs.

Correctness cases include f32 decimal double rounding, integer precision,
negative zero, Unicode character-to-byte spans and paths, preserved CRLF and
missing terminal newlines, actual `git apply --check`, explicit-apply
idempotence, whole-batch parse rejection, aliases/globs/shadowing/macros,
unsupported chains without prefix edits, file permissions, symlink rejection
and a preexisting temporary-file collision that must never be deleted.

Qualified frozen-source commands (isolated target; two jobs):

```sh
source /tmp/gpui-native-env.sh
export CARGO_TARGET_DIR=/root/gpui-migration-tool-target
cargo test --locked --manifest-path tools/inventory-rust/Cargo.toml -j 2
cargo clippy --locked --manifest-path tools/inventory-rust/Cargo.toml \
  --bin gpui --test migrate_cli -j 2 -- -D warnings
```

Both passed. CLI integration tests intentionally use synchronous subprocesses
outside the UI runtime; the inherited UI process prohibition has a documented
test-crate-only allowance, avoiding an unrelated async dependency. Writes use
optimistic byte checks and per-file atomic rename, not an editor lock or a
cross-file transaction; the README states partial-I/O/concurrent-writer limits.

The [all-source ledger](gpui-migrate-lines.json) charges **666 new non-test
code lines**, including the command entrypoint and the complete AST engine,
not just a library helper. The standalone package's existing dependencies are
reused unchanged. Unit/integration tests and 270 lines of verbatim `.rs.txt`
test data are separately identified rather than counted as executable tool
source. No generated implementation, executable example or script was added.
