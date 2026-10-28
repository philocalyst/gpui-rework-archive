# Inline opaque schema: constructibility only

This standalone probe establishes that the pinned rustc can define a private
generic type alias from a generic function returning a View's opaque schema,
and store that alias inline in `Runtime<M>`. The public owner need not acquire
a second schema type parameter. Nested child schema types are inferred inside
the generic component constructor. Source/component declarations are borrowed;
there is no schema Box in this experiment. The code has no unsafe operations.

It uses **unstable `type_alias_impl_trait`**, enabled for this isolated compile
with `RUSTC_BOOTSTRAP=1` on rustc 1.97.1. That is not a shipping configuration
or a recommendation to bypass toolchain feature gates. Compiling the same
source normally on the pinned stable compiler rejects it with E0554. A
nightly/toolchain decision remains a material adoption cost.

The final executable checks root and child u64 reads, wrong value type and
unknown path rejection, and an empty schema. Its tiny layouts are empty 0,
child 8, app schema 24 and Runtime<App> 40 bytes. They describe only this toy's
two source declarations and one child, **not GPUI's production layouts or a
matched memory reduction**. An earlier by-value component declaration occupied
32 schema/48 runtime bytes; borrowing that declaration makes the final 24/40.
The app data itself occupies 16 bytes. No allocation or latency was measured.

The retained optimized probe assembly inlines the schema traversal and removes
root trait dispatch. It still contains **three indirect projector calls** for
the two source reads and child projection: arbitrary declaration function
pointers do not become monomorphic merely because the schema product does.
No claim of zero indirection or whole-program code-size improvement is made.
The only `inline(never)` marks the observation entry, keeping it inspectable;
the schema implementation has no inlining annotations.

An instantiated self-recursive component product rejects with E0275. A first
metadata-only probe with no instantiation succeeded and is preserved; it did
not test layout and is not counted as a rejection control. Recursive schemas
need an explicit erased/indirect edge or a supported legacy fallback. The
first ordinary compile also lacked a required child `'static` bound; its
source and error are retained separately from the corrected positive case.

This is not a production Source registry. It omits writers/projector-alias
validation, checked namespace/scope assignment, duplicate detection, handler
erasure, text/style capabilities, Question invalidation, arbitrary schema
construction, unwind cleanup and recursive fallback. Those existing GPUI
contracts must remain before any replacement can be considered. The companion
[product research](../../docs/source-schema-products-luna.md),
[child erasure analysis](../../docs/source-schema-erasure-luna.md),
[stable root-dispatch correction](../../docs/source-schema-root-dispatch-luna.md)
and [TAIT proposal](../../docs/source-schema-tait-luna.md) keep the alternatives
and their costs distinct. The stable once-erased product still has a root
virtual call; this unstable inline product is a separate design choice.

`probe.rs`, `summary.json` and the hash-verified archive preserve exact source,
logs, assembly, toolchain, negative fixtures and the initial unsuccessful
control. The executable remains external with its hash. Example compile:

```sh
RUSTC_BOOTSTRAP=1 rustc --edition 2024 --crate-name gpui_schema_tait_spike \
  --emit=asm,link -C opt-level=3 -C codegen-units=1 probe.rs
```

This direct rustc command does not inherit Cargo configuration flags. There
are no production source, dependency, unsafe-policy or toolchain changes.
