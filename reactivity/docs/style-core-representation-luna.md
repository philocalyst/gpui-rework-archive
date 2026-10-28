# Style-core representation: exact storage costs and viable cuts

Research checked 2026-10-21 against the shared cleanroom at `0be36253cd` (immediately after the reported `b20a627b08` layout; compact-color changes are included). This is a read-only representation review. No production code or heavy build was changed/run. The standalone allocator probes are in `/tmp/style_btree_variants.rs` and `/tmp/style_override_variants.rs`.

## Recommendation

The most defensible first memory cut is to encode the two validated `Option<f32>` dimensions in four bytes each, preserving `None` with a reserved NaN payload and retaining the public typed `Option<f32>` boundary. It removes 8 bytes from every `Style`, or 0.8 MB across 100,000 retained nodes, with no per-window table, extra lookup, allocation, or pointer. This depends on keeping finite/nonnegative validation at every authoring and typed-property ingress.

For overrides, do not put a `(base, current)` pair in each existing inner `BTreeMap` entry: actual node capacity reverses the field-size arithmetic. A single flat `BTreeMap<(identity, property), {base,current}>` is a credible sparse-workload experiment if real windows usually override one to three properties per affected node. It wins strongly at that density, but loses at eight properties per node. If the common case is known to be one property, an inline-one-plus-spill representation is smaller still; it is custom container code and loses at high density, so it needs an observed distribution before adoption.

Do not replace `Node.style` with interned IDs as an unconditional optimization. A new author-style table can save node bytes only when styles repeat enough to pay for the hash table and lookup path; it cannot reuse Cephal’s table because Cephal stores derived layout styles, not full authored styles. Keep the author style as the logical S record and Cephal style as a derived layout record.

## What is retained today

`Style` is 88 bytes in the current branch: width and height are `Option<f32>` (8 bytes each), gap/padding/font size are `f32`, foreground/background are 16-byte `Color`s, plus `Flow` and a 24-byte affine transform. The 128-byte `Node` embeds that style inline. This is the right source of truth for logical S: `Runtime::property` reads it, reconciliation resolves new author values into it, and a failed presentation can leave the prior P intact while S has advanced.

The cold override store is nested:

```text
BTreeMap<identity, Overlay { base: Style(88), values: BTreeMap<PropertyId, PropertyValue(28)> }>
```

`base` is the latest declared style so a later `Inherit` restores the new base. Presence remains separate from value equality, including explicit `Set(None)` for auto dimensions. The current `get` copies `base`, reapplies stored values, and extracts the selected field. `set` rebuilds a resolved full style with `apply_except`; `resolve` refreshes the full base on re-description. These semantics are valuable, but retaining the entire 88-byte base for a one-field override is expensive.

The Cephal `StyleTable` is a distinct derived representation. Its pinned source keeps `styles`, reference counts, hashes, collision chains, free IDs, dependency flags, leaf boxes, and a hash map; it interns/reclaims equal **layout** styles. GPUI `layout_style` drops font size, colors, and transform, while `list::row_style` also synthesizes parent-dependent list flex and virtual-row absolute positioning. Consequently, a Cephal style is neither an authored-style replacement nor always current S: it is an input to a separately updated layout workspace and can contain list-derived values. The Bevy UI API similarly presents authored `Node` values separately from computed `ComputedNode` geometry; that is useful precedent for the distinction, not a GPUI memory result. [Bevy `Node` 0.19.1](https://docs.rs/bevy_ui/0.19.1/bevy_ui/struct.Node.html), [Bevy `ComputedNode` 0.19.1](https://docs.rs/bevy/0.19.1/bevy/ui/struct.ComputedNode.html).

## Measured override allocator ledger

I ran a standalone global-allocator counter under the configured `rustc 1.97.1 (8bab26f4f 2026-07-14)`. The model uses exact observed record sizes (`Style=88`, `PropertyValue=28`, paired property value `56`; verified by a separate `size_of` probe), real standard `BTreeMap` nodes, and measures requested live allocation bytes plus allocation/reallocation calls after construction. It excludes application allocator size classes, retained map capacity after deletes, runtime CPU, and unrelated window/node storage. Numbers are a deterministic data-structure comparison on this compiler, not whole-process RSS.

| Affected identities | Properties per identity | Current nested map | Pair stored in each inner map | One flat identity/property map |
|---:|---:|---:|---:|---:|
| 1 | 1 | 1,680 B / 2 calls | 1,024 B / 2 | 808 B / 1 |
| 1 | 2 | 1,680 B / 2 | 1,024 B / 2 | 808 B / 1 |
| 1 | 3 | 1,680 B / 2 | 1,024 B / 2 | 808 B / 1 |
| 1 | 8 | 1,680 B / 2 | 1,024 B / 2 | 808 B / 1 |
| 1,000 | 1 | 569,416 B / 1,167 | 719,760 B / 1,167 | 137,240 B / 167 |
| 1,000 | 2 | 569,416 B / 1,167 | 719,760 B / 1,167 | 274,480 B / 334 |
| 1,000 | 3 | 569,416 B / 1,167 | 719,760 B / 1,167 | 409,104 B / 498 |
| 1,000 | 8 | 569,416 B / 1,167 | 719,760 B / 1,167 | 1,095,304 B / 1,333 |

The key surprise is visible in the current Rust B-tree implementation: a leaf node stores a fixed array of key/value slots (capacity 11 in the measured toolchain), so for one through eight entries per inner map, increasing each value from 28 to 56 bytes grows the whole leaf allocation even though most slots are unused. At 1,000 one-property overrides, paired inner maps therefore add 150,344 requested bytes; the “save 60 bytes per overridden node” field ledger is false once leaf capacity is charged. The standard implementation is explicit about fixed `CAPACITY` and allocates leaf nodes as whole `LeafNode<K,V>` values. [Rust B-tree node source](https://github.com/rust-lang/rust/blob/8bab26f4f/library/alloc/src/collections/btree/node.rs) (toolchain commit).

The flat map removes the outer `Overlay { base: Style }` and each inner tree, and charges only one entry per actual override. At 1,000 nodes it saves 432,176, 294,936, and 160,312 bytes for one, two, and three overrides respectively; with eight overrides it costs 525,888 bytes more than the nested baseline. The key becomes a 16-byte `(u64,u16)` tuple and the flat tree gains nodes as override count rises, so this is a density trade, not an unconditional win.

Two safe inline/spill layouts (`first: Option<Entry> + Vec<Entry>` and `first: [Option<Entry>; 2] + Vec<Entry>`, where each entry stores id plus two 28-byte values) were also counted. At 1,000 nodes, inline-one uses 181,328 / 421,328 / 421,328 / 661,328 bytes for 1/2/3/8 overrides (savings 388,088 / 148,088 / 148,088; loss 91,912 at 8). Inline-two uses 284,200 / 284,200 / 524,200 / 764,200 (savings 285,216 / 285,216 / 45,216; loss 194,784 at 8). These reduce tree overhead but introduce bespoke insertion, removal, iteration, and ordering code. Prefer a flat map unless profiling proves the narrower inline specialization is worth the maintenance burden.

### Flat-map update semantics to preserve

The current `Node.style` already holds the resolved logical value. A flat entry needs only `(identity, property, base_value, override_value)`:

* On `Set`, read the current declared base if no entry exists; if an entry exists, retain its base. Apply the new value directly to current resolved `Node.style`, and insert/update the entry even if the destination compares equal. That retains explicit `Set(default)` presence.
* On `Inherit`, if present, restore that entry’s saved base into current resolved style, then remove the entry.
* On re-description, update each entry’s base from the newly declared style while leaving its override in resolved S. Repeating this requires a range over that identity’s keys; no second style mirror is needed.
* Purge entries for retired identities during the existing lifetime retain step. Empty map replacement must release the global root if the last entry is removed.

The cold property catalog has nine entries today. Test all nine, especially explicit auto, a base change between Set and Inherit, changing one override while retaining other fields, Set equal to declared value, identity reuse policy, remove/recreate, and invalid validation proving no map/style mutation. Measure description/override operation CPU at K=1,3,8 as well as allocator bytes.

## Two exact compression/derivation candidates

### Pack width and height without losing `Option` semantics

The authoring API and typed `WIDTH`/`HEIGHT` property already reject nonfinite and negative dimensions before storage. A private `DimensionBits(u32)` can encode `None` as one reserved quiet-NaN bit pattern (for example `0x7fc0_0000`) and encode `Some(v)` as `v.to_bits()`. Every valid `Some` is finite and nonnegative, so it cannot collide with that sentinel; negative zero remains a distinct stored `Some(-0.0)` just as it is today. Decode at public/internal option boundaries. Keep selector `WIDTH`/`HEIGHT` types as `Option<f32>` and validate before packing.

Do not use raw-bit equality if preserving current `Option<f32>` `PartialEq` matters: `Some(+0.0) == Some(-0.0)` today. Compare decoded values for equality, or explicitly redefine and test semantics before changing them. Construction-time tests should cover `None`, ±0, smallest subnormal, largest finite, rejected infinities/NaNs/negative values, typed property edits, and `Inherit` after a base update. The implementation is a two-field `Style` change with zero allocation and no extra runtime lookup; it saves 8 bytes from each Style and Node. It is currently a proposal, not implemented or benchmarked.

### Avoid needless Cephal style conversion on font/text-only dirtiness

`layout_changed` includes `font_size`, because font-size changes need remeasurement. But `layout_style` does not include font size: it translates only size, padding, gap, flow and default flex properties. In `present_inner`, every identity in `layout_dirty` currently calls `list::row_style` then `LayoutTree::set_style` before `mark_dirty`; a font-size-only change therefore constructs and compares a complete Cephal style that cannot differ, then correctly invalidates measurement.

Split “remeasure/recompute” from “layout input style changed,” or conditionally skip `set_style` when only font/text measurement inputs changed. Preserve the List-specific case: parent flow can change a child List’s synthesized grow/basis, and a `ListRow` slot changes absolute position/height, so those causes still require `set_style`. A precise dirty-cause bit may be cheaper and clearer than comparing generated Cephal styles on every dirty node. Gate with retained-vs-cold geometry equality and paired timings for font-only, text-only, width-only, parent-flow, list-slot, mixed updates at 1k/10k/100k. This removes work, not storage; no speed claim is made here.

## Why full-style interning is conditional

Replacing inline Style88 with a u32 ID shrinks each Node from 128 to 48 bytes (−80 bytes/node, due to handler alignment), but adds an author-style pool alongside Cephal’s layout-style pool. A minimally practical reclaiming pool needs the Style key (88 bytes) plus refcount/hash/chain/free metadata and hash-table capacity per unique style. Using a rough 120 bytes per unique record, the memory delta is approximately `−80N + 120U` before table slack and headers (`N` nodes, `U` distinct authored styles); it breaks even only below roughly two-thirds unique styles. All-unique styles lose around 40 bytes/node before hash-table slack. Style hash/lookup now also sits on node creation, change, and ordinary field access unless the ID is cached in a local borrowed style. The Cephal table does not disappear because it interns transformed layout styles. Reclamation is mandatory: a never-reused style pool leaks historical styles under editor churn.

The underlying idea is real but workload-dependent. Filliâtre and Conchon’s 2006 hash-consing paper explicitly conditions memory and operation wins on maximal structural sharing and requires all constructors to pass through the interning boundary. It supports the mechanism, not a blanket GUI optimization. [Paper PDF](https://usr.lmf.cnrs.fr/~jcf/ftp/publis/hash-consing2.pdf), [conference record](https://gallium.inria.fr/ml2006/accepted/5.html). Benchmark default-heavy shared styles, moderate repeated templates, high-cardinality dynamic styles, all-unique styles, update/retirement churn, and hot paint/geometry iteration; include table high-water capacity and construction hashes.

An explicit component style-template API could provide a stronger sharing prior: instances would reference an immutable template and store only sparse instance differences. There is no such template identity or frozen template lifecycle in this runtime today, and dynamic component styles can be all unique. This needs a product/API design and measured repeated-instance workload; adding an implicit interner does not create template semantics.

## Sources and validation boundaries

* Primary GPUI sources inspected: `crates/gpui/src/style.rs`, `element.rs`, `property.rs`, `runtime.rs` (Node, reconcile, property, layout dirtiness, present), `runtime/list.rs::row_style`; pinned vendor `vendor/cephal/src/owned/styles.rs` (`StyleTable::intern/release`) and `vendor/cephal/src/owned/mod.rs` (`LayoutTree::set_style`).
* The Cephal pin is recorded in the project’s [platform research](research-platform.md): Cephal 0.1.1, commit [`3c1747d2722f18f1f72811882e4cdede17b52362`](https://github.com/zortax/cephal/tree/3c1747d2722f18f1f72811882e4cdede17b52362). That source confirms a separate style-ID table and reclamation path, not an authored GPUI style pool.
* Bevy’s author/computed split is an API-level comparison only. It does not establish GPUI’s style bytes or a performance result.
* The allocator ledger used a structural stand-in with exact record sizes and standard maps under Rust 1.97.1. It validates requested allocator layout for these representations but is not a whole-application profile. Next acceptance step is an isolated GPUI prototype plus paired app-level allocations, retained bytes, description/update p50/p95, and workload density; do not implement the B-tree-pair variant based on the struct-size ledger.
