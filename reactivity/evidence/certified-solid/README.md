# Sample-certified solid packets

The adopted GPU source is exactly the three-file candidate
`7ccc65d2673a64499d805f41aaa0e423f15de2ce`. CPU admission already computes the
canonical accepted sample set for axis-aligned solid rectangles, including clip
and viewport membership. A private metadata bit now carries that proof into the
shader. Its certified branch needs four half-open bounds comparisons and returns
the existing paint color; it skips generic inverse, clip-residual, normalized
coordinate and material sampling work. Empty sample sets use zero extents.

Quarter-grid endpoints and eighth-grid sample sites are exactly representable
through the admitted 16,384-pixel viewport limit. The generic sample path,
source-over order and sample reduction stay byte-identical. The flag is separate
from the existing color-bank bit and lies above every admitted correction index.
No retained field, buffer binding or packet size changes. The now-unnecessary
host identity/viewport rewrites and special offscreen empty sentinel are deleted.

The producer's clean-source gates pass 65 all-feature GPU tests and 63 checked-WGSL
tests, plus native library/presentation checks. Actual negative control execution
rejects an incorrectly unconditional certificate at the pixel assertion. The
initial shared-target fault build had stale generated WGSL and was rejected;
its misleading binary and logs remain explicitly quarantined. The source and
four SPIR-V branch inspections are in
[source-and-ir-proof.json](source-and-ir-proof.json). Those are portable IR facts,
not hardware ISA or register-pressure measurements.

The independently audited [matched Todo campaign](../../comparisons/todo-shader-profiles/capture-2026-10-24/report.md)
changes only the two GPU implementation files over exact core `0062`/fixture `739c`.
All nine Busy windows and nine native controls qualify. The static positive
drawables are byte-identical. Certified packets submit 224/224/223 host receipts
versus original 182/179/182 in six-second animation windows; **all nine animation
windows still fail** the unchanged 358-receipt and model-delivery gates. No 30-second
promotion, equal-work animation CPU saving, hardware GPU or scanout claim follows.
The short Busy CPU pairs are noisy and are reported individually.

Linked CPU renderer code shrinks 10,293→10,022 bytes, whole `.text` by 416 bytes, and
the render function's maximum rsp-based CFA 1328→1296; WGSL grows 299 bytes. These
are actual matched ELF/CFI facts, not shader JIT stack measurements. The seven
ELFs in the source capsule include three measured targets and four quarantined
prior builds; the full manifest is authoritative. Root reread both archives and
reproduced the summary byte for byte; see
[the independent audit](../../comparisons/todo-shader-profiles/integration-review/independent-capsule-audit.json).

The four-row sample experiment also passed its functional and fault gates, but
its observed overloaded throughput 188/187/188 loses most of the certified path's
benefit. It is deliberately unadopted. Reducing apparent live shader state is
not enough to justify repeated draw loads.

The producer's six-library source inventory is 31,814→31,809 (-5). Main's updated
seven-library inventory and composed native/GPU qualification are recorded
separately after integration. Original producer logs/guards and selected IR are
stored here compactly; [external executable identities](external-executables.json)
retain the actual standalone artifacts without committing binary blobs.

Future complex clip chains must explicitly decline this certificate unless they
are first reduced by the same proven sample-set formulation. Their conservative
public bounding rectangle alone is insufficient. Gradient, glyph and image
sources remain on their material paths.
