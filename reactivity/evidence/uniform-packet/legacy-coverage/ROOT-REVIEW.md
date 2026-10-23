# Root review of the legacy-packet coverage experiment

Root independently rehashed all 1,503 payloads, the embedded manifest and nine externally retained ELF artifacts. The source tree remains clean at `299c6aca30c1245c15c2da6a5ccabb41dd435d17`. This archive copies no production implementation into main.

The producer README is deliberately preserved as written before timing. It qualifies the ordinary five/six-word packet ABI with constant/opaque-prefix coverage and the borrowed whole-bounds certificate. The later frozen 11-pair comparison has now run: exact images and aggregate speed pass, but independent per-cell regression gates fail. The implementation remains unadopted. This earlier correctness archive does not override that result.

All 52 public SDR/HDR images match shipping; all 578 named inherited captures match the exact legacy control. Both real pixel-fault controls fail and recover after exact restoration. Default/fallback/offline and foreign source-compilation checks are recorded. Strict host IEEE implications and qualified software-driver readbacks do not establish universal WGSL arithmetic, altered host DAZ/FTZ, hardware or foreign runtime behavior.

Against the exact shipping GPU comparison, this branch adds 142 non-test noncomment core lines and 5,376 linked text bytes. Render and binning static frames each grow 32 and 16 bytes respectively. Full ordinary warm uploads remain charged: 1,108,272 bytes for runs32k and 3,076,272 for singleton32k. There are no new proof heap fields; this is not a measured RSS saving. These are historical branch-local costs, not current main's core total.
