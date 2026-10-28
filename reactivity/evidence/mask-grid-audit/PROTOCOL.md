# Fine mask grid: actual native audit

Prerequisite to mask-grid1c225400 native screen. Production39efefe5 plus optional
CPU packet logging only; shader and complete workload byte unchanged. Extend
mask-miss audit2520aeec's20 fields with actual grid edge. Decode range flags,
retain correct mask classifier and original Stats sample sum check. Enumerate
support only on submission1. Require every native packet edge8, literal bank0,
positive selected tiles; all lowered references in selected tiles. Require
first-packet planned samples strictly below matching mask-miss16x16 audit,
with supportcounts0<misses<loweredpixelrefs and later counts zero.

Fresh matchednative profile and17 workload tests; independently verified GPU
admission, generated/embedded shader/actual ELF/source guards before observations.
Fixed8 processes:initial0/190 x idle/scroll/stream/both,3s,trace,normalingress,
960x720,pinnedfont,X11:94,llvmpipe4. Both idle images must exactly match independent
uninstrumented native reference. Freeze analyzers/verifier before observations;
retain failures and8GiB reserve. No performance interpretation from diagnostics.
