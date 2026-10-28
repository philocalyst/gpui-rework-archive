# Changed-glyph diagnostic passes; no performance claim

Source 5c7bf163d78461ad096448cecfeadfa2ff9d4576. Two Canvas public tests and six
GPUI publication tests pass, plus strict all-target X11 Clippy. Exact Workload
stream and owner-stream each patch 80/80 updates; scroll, mixed and fractional
remain 0/80. Median bounding area 99495 versus exact support 2891 and 16px tile
support 11520; all 160 samples retained in stage-a/diagnostic-first/diagnostic.out.
60 separate final full GPU pixel/hash/epoch qualification processes pass across
the ten existing cases and corrected original control. All input guards clean.
Executed binaries preserved by SHA. No timings or allocations from these probes
are acceptance evidence. Whole-suite and native gates remain for the composed
Stage B candidate; this is an intermediate diagnostic, not adoption.
