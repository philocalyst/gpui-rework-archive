# Shipping core code ledger

Current frozen source `007f10ccbd`: **29,365** non-test code lines including
13 build-script lines; original GPUI `41a42eb96d6c04e5e71f3577d12934d4de569b20`:
**56,922** including 28 build-script lines. The current per-file snapshot is in
[the current text integration snapshot](../text-main-integration/core-lines.json).
The Future adapter adds 254 first-party shipping lines and acknowledged text
geometry adds 706; pin-project-lite and local vendor changes are charged
separately. Source a951 measured 28,659. Source 815838 measured 28,405, 6d77 measured 28,403 and
preceding 8ea measured 27,696 under the same rule. No feature-equivalence
or future final-size claim follows from this comparison.

Historical source `8350157374` measured **26,069** under `src`; original GPUI
measured **56,894** under `src`.

Those historical snapshots cover the six shipping first-party libraries under
`crates/{canvas,core,gpui,gpu,host,state}/src` and original `crates/gpui/src`.
The current counter also charges each library's Cargo build script: shader
generation moved to the build host still belongs to the library. Source
`6e9839856d` measures **26,806** (26,793 under `src`, 13 build-script lines);
the original measures **56,922** (56,894 under `src`, 28 build-script lines).
The compressed `*-build-inclusive.json.gz` snapshots record that newer rule.
The scripts in these snapshots import no extra source outside the counted
`src` trees. Future external build helpers must also be charged.

Tests are
removed using the pinned Syn parser and Cargo-aware module propagation, including
custom crate roots. Tokei 15.0.0 then counts actual source reports' `code` fields;
its aggregate Total also adds fenced documentation examples and is deliberately
not used. Comments, blanks, documentation examples, all vendors and all support
or experimental code are excluded. Macro/configuration ambiguities stay charged.
Each snapshot records per-file hashes, diagnostics, tools and Cargo manifests.

Reproduce from `reactivity` (provide the installed Tokei binary):

```sh
cargo build --offline --locked --release --manifest-path tools/inventory-rust/Cargo.toml
python3 tools/core_lines.py --ref 8350157374 --src-only \
  --helper tools/inventory-rust/target/release/inventory-rust --tokei /path/to/tokei
python3 tools/core_lines.py --ref 41a42eb96d --original --src-only \
  --helper tools/inventory-rust/target/release/inventory-rust --tokei /path/to/tokei
INVENTORY_RUST_HELPER=$PWD/tools/inventory-rust/target/release/inventory-rust \
TOKEI=/path/to/tokei python3 -m unittest discover -s tools -p test_core_lines.py -v
```

Omit `--src-only` to reproduce the current build-inclusive rule. Five fixtures
cover default/custom/disabled Cargo build scripts, shared Unicode lines, CRLF, raw strings,
nested comments, documentation code fences and test-only modules reached from a
custom `gpui.rs` crate root. This is a source-size ledger, not permission to pack
statements or replace clear structure with code golf.
