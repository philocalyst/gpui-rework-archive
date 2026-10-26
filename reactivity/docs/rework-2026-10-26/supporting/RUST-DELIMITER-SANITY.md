# Bounded lexical delimiter sanity (not a compiler)

```sh
python3 -I rust_delimiter_sanity.py path/to/changed.rs ...
python3 -I test_rust_delimiter_sanity.py
```

The checker reads complete source files and checks matching parentheses, brackets,
and braces after skipping Rust-like strings, raw strings, chars/lifetimes, and
nested comments. It invokes no Rust tools. The portable synthetic suite has
26 lexical controls and needs no Git history, worktree, network, or generated log.
It prints its results without modifying source files.

Limits:8 MiB/file,4096 nesting,255 raw-string hashes. Exhaustion rejects this
sanity audit, not Rust. No macro/cfg/include expansion, grammar, type, name,
borrow, feature, edition, formatting, or generated-code qualification is implied.
Balanced tokens are NOT a compile pass. Use the required pinned compiler gate
for actual Rust qualification. Unsupported lexical cases need manual/compiler
review rather than a blanket pass.
