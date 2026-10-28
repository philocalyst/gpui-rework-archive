# Stage A implementation boundary

`model/chunks.py` adds an authoritative bytes-only page store. Its identity
index maps stable id/generation to page/slot; parent columns hold stable ids,
not relocating physical ranks. Dirty pages decode into transaction-local scratch,
encode on commit, and discard scratch. Insertion/split/merge updates at most
local page rows and parent span paths; subtree moves explicitly enumerate and
copy their extent. Counters are algorithm visits/wire bytes; Python object
sizes are diagnostic prototype costs, never forecast Rust allocation sizes.
The preserved first-pair implementations remain the stable-slot comparison.

Stage A deliberately separates the first fence ownership model from the local
page store. Its publication directory is still a flat rebuild, charged as such;
Stage B must compare a bounded COW directory before claiming a constant leaf
publication. Resource byte patterns here are synthetic and not sufficient for
the preregistered text/image GPU lifetime gate. The test submits three roots,
processes completion notifications out of order, retains old payloads until
completion and visible release, and then checks reuse across1000 publications.
A missing submitted-root lease must make old bytes inaccessible prematurely.

Raw fallback is an explicit comparison variant for a single <=32-record page,
not an adopted adaptive policy. It removes padding/compression headers in that
page; its identity and page metadata remain charged. Publication descriptors
and in-flight copies are additional costs. The tests do not claim this variant
wins on every size or bounds total tree memory before all metadata is counted.

The direct public binding/GPU overlap/resource extraction stages have not run.
No application integration, shared host memory, performance or adoption claim.

Initial757ee25d model passes2820 structural/property checks and synthetic
lease/reuse assertions. Review found its upload diagnostic list retained all
historical payload bytes despite a stable physical arena: this invalidates a
bounded-total-storage interpretation. Corrected model drains uploads into a
separate simulated device memory, charges remaining journal/bookkeeping, and
checks old bytes there across overlaps. It caps submitted roots at3 and tests
40 rejected submissions before completion. Random field reads now access bytes
directly rather than unpacking a whole encoded page; exact word loads count.
Add true97-node cross-chunk move/removal and high-entropy exact-word cases.
This remains Stage A, not actual Vulkan resource qualification.
