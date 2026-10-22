# Local source patches

Parley 0.11.1 is a complete pinned substrate; licensing and package metadata
remain alongside the sources. The earlier `CursorGeometry` borrowed index
avoids repeated source-cluster and visual-prefix scans during one shaping pass.
It does not survive that pass or create another retained layout.

The selection integration corrects source-affinity geometry at bidi soft wraps.
Upstream uses the logically preceding cluster's trailing edge; downstream uses
the logically following cluster's leading edge. Both ordinary Cursor geometry
and the borrowed indexed helper call the same source-neighbour implementation.
Previously a visual predecessor on another line could attach the caret two
lines away and cause selection geometry to omit a whole selected line.

The independent regression fixes the known byte/line ownership for
`abc אבג 123 xyz` at width 55. Additional tests compare all legal subranges
against visual-cluster ownership without calling either cursor helper, as well
as Parley's selection geometry. No cursor/layout/cluster field is added.
See [the integration evidence](../../crates/canvas/evidence/text-selection.md)
for source pins, allocation/line ledgers and protocol work still outstanding.
