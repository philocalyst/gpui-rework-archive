# Shipping core code ledger

Latest measured source `c717df64a9b492b445fa97647deb880fb21b9ef6`:
**30,467** non-test code lines, including 18 build-script lines. Original GPUI
`41a42eb96d6c04e5e71f3577d12934d4de569b20`: **56,922**, including 28 build-script
lines. [The exact source snapshot](c717df64a9.json) records every counted file.
Comments, tests, blanks, examples, vendors and support tools are excluded; host
shader proof/generator source inside the shipping library remains charged.

The [combined text/static source ebfdb2](../compact-static-main/core-lines.json)
measures 29,975. The integrated surface descriptor removal subtracts six and the
controlled checkbox adds 38, giving the [30,007-line source](f490974fdc.json).
Cached-edge text adds six, basis factoring adds 209 and contained property
actions add 168 in the integrated formatting. The property producer separately
measures 169 against its earlier base; export wrapping accounts for the one-line
difference. The exact property/description identity union adds 30 and public
mounted selection with canonical state replies adds 47. These are measured
source bills; the counter correction passes its 11 public regressions and the
[combined desktop/native campaign](../property-selection-main/README.md) qualifies
the later merged source separately.
These measured source deltas do not establish
feature equivalence, future final size, or permission to compress readable code.
All imported vendor code, patches, static shader words and helpers retain their
separate costs in the producer archives.

Earlier source `007f10ccbd` measures 29,365 (13 build-script lines); a951 measures
28,659; 815838 measures 28,405; 6d77 measures 28,403; 8ea measures 27,696 under
the same rule. The Future adapter adds 254 first-party shipping lines and the
initial acknowledged text geometry adds 706; pin-project-lite and local vendor
changes are charged separately.

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
