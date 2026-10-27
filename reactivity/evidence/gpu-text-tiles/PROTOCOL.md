# Changed-record tile repair

Base de8e4f6fea (rejected GPU packet trial). Isolate a second output-repair
formulation; this does not adopt the base or amend its fixed failed verdict.
The unchanged shader reads per-tile ordered references, compact glyph/common
words, correction/atlas resources and globals. Text packet admission already
holds every non-edited resource/global constant and keeps the opaque cutoff.
After gathering all replacement words and rebuilding surviving CSR, compare
old/new tile lists and test references against changed glyph/common records.
Any changed common word conservatively marks every glyph in that run. A tile
whose list and referenced records are identical has identical shader inputs;
it needs no compositing. Never infer identity solely from the text string.

For certified partial damage, combine adjacent dirty tiles into disjoint row
spans intersected with caller damage, and submit those scissored draws in one
retained render pass plus the existing full presentation copy. Cap spans at256;
overflow takes the original bounding-damage render. Explicit None still means
full repaint. No change to sample ordering, floating point arithmetic, shaders,
atlas lifetime, scene tokens, or public application APIs. Still charge complete
CSR reconstruction, word comparisons, spans/scratch and all full-preparation
costs. No custom async runtime or hardware-cache claim.

Use the prior identical 21-cell fixture and frozen full-preparation control
64523d173a / ELF8773b9f402d60b583ad96bba77ba20b98c4615e938e4f0114bb014b91ded4470.
Five alternating pairs,10 warmups60 measured queue-complete operations, same
font/features/compiler/affinity2-5/llvmpipe4. Primary1000-label stream completion
ratio<=.8; preserve earlier1000-label two/four-field primary<=.8. All full-scene
and short one-field controls<=1.05. Report every case/pair and cold/p50/p95/p99,
including full controls. Separately compare packet-only baseline11ad2fff8f on
stream0/25/1000 and short1000two/four, three alternating pairs. Do not time with
compilers/tests/allocators/source edits. Pin immutable binaries before tests.

Exact public GPU tests: no changed words (copy only), one glyph versus whole-run
change, same word but changed conservative memberships, moved old/new tiles,
opaque overlap, changed common numerical bounds, SDR/HDR/fractional transforms,
empty/clipped damage, explicit full and span-cap fallback. Exact fresh images
must match, and counters must demonstrate sparse compositing. A mutant omitting
old dirty membership must fail a moved-glyph image comparison. Preserve atomic
late-failure/replay/ACK tests. Full GPU suite/strict Clippy and native composition
plus six actual private-X11 scripts before claiming integrated correctness.
Separate allocator and complete shipping/code/stack/retained ledgers. Freeze
clean commits and full build-input guards for every gate. No new unsafe.

VM software Vulkan does not establish physical-GPU/scanout or ZGX superiority.
Equivalent native workloads, matched distribution profiles and two hardware
classes remain mandatory for the campaign objective. Keep all changes local.
