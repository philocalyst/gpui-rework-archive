# Research, reviews and original requirements

These reports are dated evidence. Earlier critiques can describe bugs or contracts
that have since been corrected. [Current dispositions](../REVIEW.md) and
[CONTRACT revision 2](../CONTRACT.md) control the final proposal.

| Report | Scope |
| --- | --- |
| [Core](research-core.md) | JustRach NanoUI, MyGo, zgui, Bevy, Rust, data structures and PanGui |
| [Platform](research-platform.md) | Pinned Winit/Cephal, memory, threads and buffer release |
| [Frontier](frontier-research.md) | Succinct/shared trees, dynamic products, local support and incremental algebra |
| [Semantics](semantic-review.md) | Source/outcome/presentation transaction cuts and rollback limits |
| [Graphics](graphics-research.md) | Primary analytic/vector/field research, damage and native presentation |
| [Concurrency](concurrency-research.md) | Audited queues, borrows, weak-memory wake proof and reclamation |
| [Native startup and platform floor](cross-platform-startup-floor-luna.md) | Platform contracts, lazy resources and startup measurement |
| [Linux blank-window attribution](linux-blank-floor-luna.md) | Actual mapping/profile attribution and candidate experiments |
| [Hummingbird source audit](hummingbird-source-audit-luna.md) | Pinned real application requirements and reusable domain boundaries |
| [Virtual-list review](virtual-list-api-review-luna.md) | Bounded row realization, keyed lifetime, local coordinates and semantic authority |
| [Review dispositions](../REVIEW.md) | Links to all six adversarial reports and their final status |

[Input manifest](inputs/manifest.json) hashes the supplied original
[model/statutes](inputs/final/00-model.md), [quality gates](inputs/final/10-quality.md)
and runtime notes. These are archived design inputs: some API/atomicity claims
are explicitly replaced by CONTRACT v2, and their ignored design examples are
not compiled proof. Their M3 lab measurements are not inherited as local results.

The new packet and implementation evidence live one directory above. External
primary links are inline with claims; local unpublished implementations are
identified as such. No benchmark in these reports establishes a feature-equivalent
competitor win. Tiny-ELF primary discussion is in [MEMORY](../MEMORY.md).
