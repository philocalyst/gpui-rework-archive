The active checkout now includes the measured-width enclosure fix from
`dbe8a82755db81fc6853ecf1642c6c5eb44d760d` and its three public regressions.
The original unmodified Todo, 81 Unicode/font/padding/DPI combinations and
ULP-adjacent explicit widths pass. Automatic widths enclose their measured
content; explicit widths and min/max constraints retain their strict meaning.

The [original qualification](qualified-dbe/README.md) is preserved unchanged,
including its then-unintegrated status, failed controls and exact source bill.
The coordinator verified every archived uncompressed hash and confirmed both
production files and the public test match the qualified source exactly.
The integration does not install the ignored internal diagnostic module.

Active-checkout replay passes 27 GPUI tests, the complete 44-case core test
suite with layout enabled, and 24 Canvas Unicode/render tests. The initial
Canvas command named a nonexistent `unicode_text` target and ran no tests;
its error is preserved alongside the corrected `unicode` replay. Logs and
post-run source hashes are in `integration/`. This is a correctness fix with
15 additional noncomment vendor lines, no new retained state or dependency.
No timing, hardware-GPU or foreign-platform runtime claim is made.

The frozen Todo campaign keeps its explicit 56-pixel comparison control;
this later correction does not change the recorded benchmark inputs.
