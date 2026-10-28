# Source inventory

`inventory.py` produces a per-file physical-source ledger, not semantic SLOC.
Blanks and comments count. A final line without a newline counts once. The
inventory makes no feature-equivalence, compression-ratio, or performance claim.

Run from the repository root, with Python 3.11+ and Cargo available:

```sh
python3 reactivity/tools/inventory.py --working > /tmp/inventory.json
python3 reactivity/tools/inventory.py --ref HEAD > /tmp/pinned-inventory.json
python3 reactivity/tools/inventory.py --ref 41a42eb96d --scope original > /tmp/original-inventory.json
```

The first run builds a standalone analysis helper offline, with two build jobs,
from the committed `inventory-rust/Cargo.lock`. It has no production dependencies
or connection to the UI Cargo workspace. Set `CARGO_TARGET_DIR` to choose its
build directory, or pass `--helper /absolute/path/to/inventory-rust` to reuse a
binary. The current inventory tool analyzes both historical and working source;
its own source and lockfile hashes are recorded even for a historical target.

## Boundaries and totals

The experiment scope counts all supported source under `reactivity/`, including
crates, labs, examples, benchmarks and their fixtures, tools, and evidence helper
scripts/fixtures. It includes the inventory implementation itself. Purpose groups
are separate from ownership: libraries, labs, applications, examples, benchmarks,
tools, evidence support, and other support. The original scope uses the same
rules on the original checkout outside `reactivity/`. Custom Cargo test and
production target paths come from each source snapshot's manifests.

`first_party_non_test_lines` includes hand-written first-party source across all
those groups. Generated/disassembled source is charged separately;
`first_party_including_generated_non_test_lines` adds first-party generated
source. `vendor_non_test_lines` separately charges vendored source.
`all_active_non_test_lines` adds the hand-written, vendor, and generated buckets.
`all_active_physical_source_lines` also includes known test lines. Per-file and
group physical, test, and non-test line counts allow these totals to be checked.

The original checkout outside `reactivity/` is excluded as legacy in experiment
scope. `docs/inputs/` and directories named `archive`, `archives`, or `legacy` are
also excluded. Their physical source lines remain in the ledger and
`excluded_archived_physical_source_lines`; they receive no test classification.
`all_repository_physical_source_lines` includes those excluded physical lines.

Recognized source languages are listed in `LANGUAGES` in `inventory.py`: Rust,
WGSL, Python, shell, C/C++/Objective-C, JavaScript/TypeScript, Go, Zig, Java/Kotlin,
GLSL/Metal, HTML/CSS, Nix, and assembly. `justfile` and extensionless scripts with
recognized shebangs count. Manifests, lockfiles, prose, patches, captured images,
logs, CSV/results, and binaries do not. Cargo manifests are hashed separately
because their target declarations affect classification. Tracked source and
nonignored untracked source count; ignored build products and symlinks do not.
Assembly in the known capture directories listed in `DISASSEMBLY_DIRECTORIES`
and exact captures listed in `DISASSEMBLY_FILES`,
minified JS, and files with an explicit generated header in their first twelve
lines receive the generated charge. Assembly elsewhere defaults to authored
source, including assembly under a future core `src/asm/` directory. This is a
visible rule, not a claim to recognize unmarked generated code.

## Test subtraction and uncertainty

The helper uses Syn's Rust AST and proc-macro2 source spans, so nested comments,
raw strings, macros and multiline attributes are lexed by a Rust parser. It
subtracts items, methods, expressions and other attributed syntax that cannot
exist with `cfg(test)` false, and `#[test]` / namespaced `::test` items. Unknown
features and target cfgs remain potentially production. Lines shared with other
syntax remain charged. Comments or blank lines outside a test span also remain
charged; this convention is deliberately reproducible.
Span endpoint columns count Unicode characters, matching proc-macro2; the
Python subtraction slices decoded strings, including non-ASCII identifiers and
string literals at a span's endpoint.

The visitor reads attributes directly from Syn AST fields. It only computes a
node's full source span when an attribute affects test/uncertainty accounting,
instead of re-tokenizing every expression and item. Reading fields is constant
time per node; Syn span construction can still traverse a subtree. With N AST
nodes and depth D, the worst case remains O(N × D) if deeply nested nodes all
require spans, while ordinary unattributed expressions incur one AST traversal.
The helper also computes one whole-file span. These are analysis-tool costs;
the inventory makes no performance claim about either the tool or the UI.

Files in conventional external-test paths, explicitly declared Cargo test
targets, and files reached exclusively by test-only Rust module imports are
excluded as tests. Module resolution includes default paths, explicit `#[path]`,
nested inline modules and custom Cargo crate roots. A production import keeps a
shared file charged. Child modules of test-only files are propagated to a fixed
point. A whole-file `#![cfg(test)]` excludes the entire file.

Conditional test/path injection through `cfg_attr`, unresolved module paths,
Rust parse failures, and test-related attributes or module declarations inside
unexpanded macro tokens appear under each file's `unclassified`. Such ambiguous
code stays charged. The subtotal `unclassified_files_non_test_lines_included`
is the retained non-test total of those files, not an estimate of their test
lines. Macro expansion, arbitrary procedural-macro semantics, computed include
paths, feature resolution, and language-specific inline tests outside Rust are
not evaluated. These limitations make the non-test result a conservative source
accounting measure rather than an exact compiled-program size. In particular,
the baseline's procedural-macro code containing quoted `#[test]` tokens is
retained and flagged, so the snapshots should not be presented as an exact
feature-equivalent reduction ratio.

## Provenance and verification

Every source entry includes SHA-256. The sorted path/hash ledger has a combined
SHA-256, with a separate hash for active source. Each snapshot identifies its
commit or working HEAD, complete working status when applicable, inventory tool
hashes, and Cargo manifest hashes. `--ref` reads immutable Git blobs without
consulting the checkout. A dirty working snapshot can be matched to its hashes;
HEAD alone never identifies dirty contents. Keep a published snapshot's source
commit separate from the later data commit that adds the snapshot.

```sh
cargo test --offline --locked --manifest-path reactivity/tools/inventory-rust/Cargo.toml --jobs 2
cargo build --offline --locked --release --manifest-path reactivity/tools/inventory-rust/Cargo.toml --jobs 2
INVENTORY_RUST_HELPER=/path/to/target/release/inventory-rust python3 reactivity/tools/test_inventory.py
```

Fixtures exercise raw strings containing fake tests, nested comments, multiline
cfg attributes, shared physical lines, out-of-line test modules with explicit
paths, nested modules, production sharing, custom Cargo roots, ambiguous
`cfg_attr` paths, raw identifiers in module names, unexpanded macro imports, and
parse failures. Additional fixtures cover Unicode span endpoints and shared
lines, authored assembly, and known emitted assembly captures.
