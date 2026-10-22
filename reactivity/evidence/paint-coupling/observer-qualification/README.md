# Exact semantic collector authority follow-up

Source `ed8fea5f26` follows the reviewed coupling source `05690b91d4`.
Two independent Consumer regressions fail before the correction:

1. Extending pending C with an unchanged or masked color source advanced complete
   coverage but left the collector at its older epoch. Acknowledgement safely
   fell back to full projection instead of preserving its exact delta.
2. Enabling the observer after a full C existed, then changing color, could
   invent an empty P-to-C delta even though the unseen candidate had changed
   geometry. This was an actual missing authority check.

The correction compares the collector target with the exact preceding complete-C
stamp: token sequence, covered source epoch and actual completed dimensions.
Only that collector can carry its indices forward. Empty collection is valid
only when preceding complete C equals base P; otherwise full projection is
required. Actual size comes from Prepared dimensions or the canonical Canvas,
not potentially newer requested dimensions. No-op coverage extensions update
pending stamps without acknowledging them or losing earlier full-candidate
indices.

Both original failed logs are preserved. All 12 Consumer transition tests pass,
including pending full/paint C, consecutive colors and no-ops, masked lower-base
changes, late observer activation, independent full trees and live focus. The
five-policy actual native script with independent SDR/HDR full-GPU bridge
oracles, five public paint cases and strict all-target X11/Wayland Clippy also
pass. No retained field, allocation floor, shader arithmetic or paint conversion
changed. No timing run was performed.
