# Semantic identity to actual emitted command extents

Parent cae48074c797af4f1bd204cd0d0c70175f934a7a. Ordered cold extent sharing
remains unadopted; no codec tuning, new paint optimization, timing or GPU
publication claim. Existing identity/remint rules, complete producer and raw
renderer stay authoritative. The 326-byte escaped-sibling damage and 704-byte
cold-equality/changed-pixel witnesses remain mandatory.

Source trace before implementation: Runtime::present_walk iterates logical
preorder, composes layout/inherited transforms and clips, then emits optional
background/gradient, text selection/composition/glyph/caret commands and image
commands. Invisible or clipped nodes may emit zero commands. Omitted presented
rows still occur after emission logic. Canvas admission can omit individual
commands. Canvas DisplayList.order is actual painter order; GPU groups may encode
inline six-word records or a five-word common plus two-word placements, with
paint-bank prefix and clip/resource suffixes. Thus neither one node/one command
nor one subtree/one physical GPU byte interval may be assumed.

Add test instrumentation at actual emission boundaries. A gated Canvas observer
returns the current order length and support of only the newly appended order
slice; it must not scan the preceding prefix. Enable through a development
feature, with all non-test library code charged. Runtime records existing
identity, own command start/end, logical subtree end and command subtree end.
Close extents using the existing preorder parent facts and an explicitly charged
ancestor stack. Keep resolved/inherited transform and clip diagnostics separate
from the minimal range record. Count every row, cursor/support visit, descriptor
write, stack allocation and retained current/previous mapping capacity.

Mappings are bound to the exact planned/committed PresentationToken and source
version. Stage locally; install only after successful complete scene commit.
Failed candidates preserve the old mapping. Other paint/text paths that do not
emit this mapping must decline lookup by exact version checks; do not infer
validity from equal cold records. Current semantic lookup uses the existing
IdentityIndex plus row identity/version checks, with no parallel identity map.
Old mapping metadata describes old support; it owns no Canvas/resource/GPU lease.
Do not use stale ClipIds or old positional indices against a new scene. Old/new
identity comparisons in diagnostics are charged analysis, not a journal adapter.

Retain existing structural fixture sizes4/32/256 and insertion/removal/reorder/
failed-newer checks with full CPU/fresh-CPU/GPU oracles. Add a bounded emission
variety fixture with zero-draw containers, multiple draws from text/background,
shared images/glyphs, inherited clip/transform, and a structural source edit.
Check command ownership partitions actual order exactly, subtree ranges are
contiguous only where established by the actual preorder emitter, and report
logical versus group/physical packet addressing separately. Shared resources
can escape those ranges and must be enumerated separately in diagnostics.

The first result is an executable mapping/counterexample trace, not output
reuse. Preserve full preparation and old/new damage. Include an intentionally
wrong one-node/one-command assumption and the existing subtree-only damage
witness. Report escaped dependencies and same cold/different output. Resource
keys/clip references in observations do not establish submitted GPU lifetime.
Charge ordinary Source allocations with instrumentation and identify diagnostic
walks outside that scope. No saved work, local structural update, shared memory,
production performance or ZGX win follows from observability alone.
