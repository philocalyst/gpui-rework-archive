# Cold semantic text and frozen list metadata

Production implementation: `7d0d2dd1e2`, based on `e03d423091`.
Measurements: x86_64 Linux, Rust 1.97.1, debug unit harness, 2026-10-21.
The fixtures and exact commands below are in the repository; these are storage
and allocation measurements, with no frame-time or RSS claim.

```rust
text_input(&self.draft)
    .name("New task")
    .description(&self.validation_message)
```

`name` and `description` accept the same `IntoText` operands as read-only text.
An input's value is separate and never becomes its name. Absent explicit names
retain the existing visual text fallback for other roles. `Part::name`,
`description`, `value`, `list`, and `list_item` borrow one acknowledged sheet;
queries use the same visitor. `Query::name` and `description` avoid snapshots.
The closed `semantic::{NAME, DESCRIPTION}` selectors support
`Win::set_semantic(target, selector, Contribution::{Inherit, Set(...)})`.
`Set(None)` explicitly clears a name, including its fallback. `Inherit` reveals
the latest declaration. Rejected owned contributions return the original value.
`semantic_text`/`semantic_contribution` inspect logical state, which may lead P.
These methods retain the existing `Win<M,L>`/`LaneSet<M>` generic helper contract.

## Allocation and header ledger

On this base, `Node` stays 232 B, `Presented` 104 B, `El` 184 B, `DraftNode`
160 B, `Part` 16 B, and `ListRow` 32 B. Parent-index/shape work on subsequent
branches is independent; these numbers do not claim those optimizations.

| Description case | Allocations | Requested payload bytes |
|---|---:|---:|
| Plain `div()` | 0 | 0 |
| Name and description on `div()` | 1 | 56 |
| List alone | 1 | 56 |
| List plus annotations | 2 | 104 |
| Component alone | 3 | 88 |
| Component plus annotations | 4 | 144 |

The previous list-only box was 48 B. The existing optional list pointer now owns
an enum: List, Semantic, or Combined. Combined boxes the 48 B list payload,
keeping the enum 56 B. Components keep their separate existing extension.
There is no semantic pointer or empty vector in each ordinary element/node.

The window pays one optional 8 B pointer, with no allocation while unused.
Used metadata owns a 240 B box containing logical declarations, contributions,
and frozen sparse columns for P and an optional complete candidate. Logical
annotation entries are 40 B. `Arc<str>` is a 16 B fat pointer here. Name and
description columns each use 24 B entries; entry presence distinguishes an
explicit cleared name from inheritance. The temporary combined snapshot record
would have used 48 B even for a name alone. Splitting saves 24 B per name-only
snapshot entry, adds 48 B to the cold window box, and leaves paired-column
payloads at 48 B per annotated site. Full preparation reserves sparse column
capacity from declaration/override counts; it may overreserve for duplicates or
clipped entries. It captures entries inside the existing admitted-node loop.

List containers add 24 B entries (identity, ListId, count); visible row entries
are 32 B (identity, containing identity, ItemKey, zero-based source index, count).
Row index fits existing `ListRow` padding. Keys and physical y never stand in
for ordinal. These columns advance with P, not with logical list state.

Source destinations pack checked node index and two port bits into 4 B. A
four-entry vector payload is 16 B, previously 32 B for `usize`. Registered
fields share one read/codec and one lazy string promotion across changed visual,
name, and description ports. Only visual changes invalidate shape/layout/paint.
Frozen/base operands share the immutable promotion; no per-slot string copy.

## Reproduce the dense comparison

```sh
cargo test -p gpui --lib sparse_metadata_storage_and_cold_allocation_ledger -- --nocapture
cargo test -p gpui --lib shared_ports_retain_one_payload -- --nocapture
cargo test -p gpui --lib dense_annotation_capacity_evidence -- --ignored --nocapture
cargo test -p gpui --test semantic_metadata
```

`semantic-metadata.csv` records 10,000 rect-only children plus their root. All
cases register the same single source and use command-only recording, then ack.
One signal supplies all requested annotations. The fixture first warms Cephal's
existing dependency scratch pool. Allocation-counter retained delta excludes
that already allocated pool and the model payload created before measurement;
it includes new owned window storage, layout, source maps, and retained columns.
The un-warmed first case held an additional 5,800,672 B of pooled scratch and is
not used as an annotation comparison. This measurement does not imply allocator
pages return to the OS.

Relative to absent annotations, name-only retains 706,336 B more, including
400,000 B logical column, 240,000 B frozen names, 65,536 B destination capacity,
and 800 B cold box/map/payload overhead. Both annotations retain 1,011,872 B
more; both use exactly one string promotion. The source-descriptor boxes and
flattening annotation column are temporary but contribute to allocation count
and peak. List-only and component/list combinations pay the cold enum costs in
the earlier table, rather than inheriting a universal header increase.

The implementation commit adds 1,833 lines and removes 63 across 11 files,
including 650 lines of public integration fixtures and private allocation/layout
proofs. This is a bounded production slice, not an accessibility framework.

## Publication and limits

Semantic-only edits publish only when the complete visual sheet covers the
*preceding* source epoch and there is no unresolved dirty visual preparation.
With a complete candidate pending, only its metadata/coverage advances; P stays
frozen until its token is acknowledged. If S2 visual preparation fails after a
C1@S1, an independent S3 name edit updates logical metadata only. It neither
relabels C1/old P nor retries bad glyph/layout work. Visual repair/settle later
captures coherent current metadata. Surface loss stages cold metadata without
restoring authority; acknowledgement publishes it. Tests cover all these cuts.
A valid metadata update may advance P with the same scene token; native adapters
must observe presentation epoch as well as token and live interaction focus.

Direct fields still require the existing `Sources::direct` operand-only promise;
ordinary `field` declarations invalidate the owner conservatively. Coarse
annotation updates may scan/freeze the published topology. Exact direct changes
walk their packed fanout and sparse columns; first inspector annotations may
scan the published sheet, and inserting a new sparse entry may move its suffix.
The semantic columns contain no parallel parent/child tree.

No placeholder/label relationship, text selection/IME, live region, disabled-state
protocol, virtual-item provider/reveal capability, or native AT bridge is claimed
here. `list_item.index` is zero-based; platform adapters map it according to their
pinned schema, rather than assuming ARIA indexing applies to every API. Queries
show realized published rows; they do not expose offscreen items as live Targets.
The existing visual counter on coarse descriptions is not a complete semantic
diff log; native sparse-update journaling is a separate integration gate.
