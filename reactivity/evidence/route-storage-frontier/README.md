# Route storage research

Research source: main `89aeabd53942c3a4643bcb6fd978e6a24703f6d2`.
The [reviewed report](../../docs/route-storage-frontier-luna.md) records safe hot/cold
route columns and a separate unsafe thin-owner alternative. Neither is adopted.
The exact original report is compressed here. The reviewed copy repairs GitHub
source anchors and rejects its base-pointing thin-owner sketch: a type-erased
base cannot locate a tail table at an unknown offset. A tail-slot handle is a
separate unimplemented address formulation, not a soundness result. The standalone layout
probe measures Rust layouts, not allocation classes, integrated behavior or RSS.
Its exact command/output and failed first linker invocation are in the report.
No Miri or soundness qualification is claimed.
