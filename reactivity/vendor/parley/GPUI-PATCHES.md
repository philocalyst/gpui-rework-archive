# Parley 0.12.0 local repairs

Published crate: `https://static.crates.io/crates/parley/parley-0.12.0.crate`.
Archive SHA-256: `61bd0c0c1737f0b3d3726dc06b225083af213b61913e4fbae1670613a106c6ce`.
Upstream commit: `6e1143dda817360dd3a2a64f9133c6e5dfabd881`, directory `parley`.
MIT/Apache licenses, original/normalized manifests and VCS metadata accompany
the complete source. The workspace uses its root lock and path patches.

`CursorGeometry` remains a transient borrow over one layout. Its entries now
hold the 0.12 character-based ClusterPath and exact visual f32 prefix; a byte
table selects an entry. Capacity is 16 bytes per source scalar plus four bytes
per source byte, discarded after lowering. Resolving an entry's path uses the
engine's atom search; only byte-to-entry/prefix lookup is constant time. No field
is added to Layout, Run, Cluster, Cursor or Canvas's retained line/stop tables.

Direct Cursor geometry and the indexed helper share the source-affinity rule:
upstream uses the logical predecessor's trailing edge, downstream the logical
successor's leading edge, and a hard break resolves to the next line. A visual
predecessor cannot steal source ownership at bidi soft wraps. The byte11
regression for `abc אבג 123 xyz` retains its independent line oracle.

`Run::glyph_source_ranges` borrows the engine's finer shaped-cluster ranges.
Public 0.12 clusters span full graphemes and cannot alone preserve each glyph's
original source cluster. The iterator adds no retained map and follows the
existing visual glyph order, including RTL runs. Two glyph-count consumers
accept the widened engine count; see the engine's accompanying patch ledger.

Canvas lowers the union of new content/line-box bounds, exactly matching the
cursor's vertical bounds, and suppresses implicit variable-weight synthesis for
its explicit default font instances through Fontique's metadata override.
The removed 0.11 word-boundaries feature is not recreated: current upstream
analysis/editor behavior stays enabled. Old feature-comparison measurements
remain historical and do not describe this 0.12 binary.
