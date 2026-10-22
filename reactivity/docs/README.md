# Research, reviews and original requirements

These reports are dated evidence. Earlier critiques can describe bugs or contracts
that have since been corrected. [Current dispositions](../REVIEW.md) and
[CONTRACT revision 2](../CONTRACT.md) control the final proposal.

| Report | Scope |
| --- | --- |
| [Core](research-core.md) | JustRach NanoUI, MyGo, zgui, Bevy, Rust, data structures and PanGui |
| [Full feature audit](feature-parity.md) | Original GPUI behavior gaps, representative Hummingbird fixtures and conservative migration rules; full replacement scope retained |
| [Solid and Ripple async graph](async-graph-luna.md) | Pinned runtime and accessible author sources, typed lane fit and remaining Future/stream/optimistic ergonomics |
| [Bounded Future questions](future-questions.md) | Integrated typed executor API, physical-credit teardown, close barrier, costs and remaining stream/optimistic work |
| [Typed Future admission](async-admission-luna.md) | Injected exact-task cancellation, pinned Future teardown before completion, unchanged ordinary controller storage and adversarial lifecycle traces |
| [Static shader lifecycle](native-shader-lifecycle-luna.md) | Vendor-owned static SPIR-V recipes, scoped Vulkan module ownership, Core trace/error routing and separately gated inline-stage research |
| [Portable presenter boundary](portable-presenter-luna.md) | Vendor-owned hints/target proof/leases, source-review corrections and cross-platform fallback limits |
| [Remaining portable graphics owner](portable-graphics-boundary-next-luna.md) | Current vendor boundary, redundant configuration removal, backend leases and explicit legacy gaps |
| [Graphics work elimination](graphics-work-elimination-luna.md) | Device-owned resources, shader artifact safety, backend preservation contracts and separately gated first-window experiments |
| [Offline shader proof](offline-shader-proof-luna.md) | Exact six-binding ABI, Vulkan artifact generation, enabled robustness policies, host bounds and unsafe admission gates; proposed, not implemented |
| [Typed reflection and composition](typed-reflection-composition-luna.md) | Closed property traversal, shared validators, component-library controls and inspector ownership budgets |
| [Production API gaps](production-gaps-luna.md) | Concrete accessible editor actions, typed reflection/inspector and designer color operations |
| [Color formulation](color-formulation-luna.md) | SIMD-shaped fixed-lightness/hue cubic gamut limits, numerical proof obligations and separate CSS mapping semantics |
| [Designer palette interpolation](designer-color-next-luna.md) | Explicit domains, alpha/hue semantics, shared SIMD setup/sampling and corrected primary-basis equivalence |
| [Platform](research-platform.md) | Pinned Winit/Cephal, memory, threads and buffer release |
| [Frontier](frontier-research.md) | Succinct/shared trees, dynamic products, local support and incremental algebra |
| [Semantics](semantic-review.md) | Source/outcome/presentation transaction cuts and rollback limits |
| [Graphics](graphics-research.md) | Primary analytic/vector/field research, damage and native presentation |
| [Concurrency](concurrency-research.md) | Audited queues, borrows, weak-memory wake proof and reclamation |
| [Native startup and platform floor](cross-platform-startup-floor-luna.md) | Platform contracts, lazy resources and startup measurement |
| [Linux blank-window attribution](linux-blank-floor-luna.md) | Actual mapping/profile attribution and candidate experiments |
| [Hummingbird source audit](hummingbird-source-audit-luna.md) | Pinned real application requirements and reusable domain boundaries |
| [Virtual-list review](virtual-list-api-review-luna.md) | Bounded row realization, keyed lifetime, local coordinates and semantic authority |
| [Accessibility frontier](accessibility-frontier-luna.md) | Native activation, sparse semantic updates, virtual-item protocols, geometry contracts and primary framework/paper review |
| [Typed checkbox coverage](accessibility-checkbox-luna.md) | Ordinary controlled role/state/action integration, stable identity, sparse publication and native proof obligations |
| [Accessibility deltas](accessibility-incremental-luna.md) | Exact sparse projection without a second semantic tree, structural fallbacks, label/value schema and native proof boundaries |
| [Accessibility transition descriptor](accessibility-transition-descriptor-luna.md) | Acknowledged sequence/epoch authority, active-only bounded deltas, metadata publication and full-tree fallbacks |
| [Accessibility text and virtualization](accessibility-text-virtualization-luna.md) | Chromium/Compose/Qt comparisons, frozen row derivation, text offset contracts and focus across lost surfaces |
| [Acknowledged text geometry](acknowledged-text-geometry-luna.md) | Exact P/C geometry, public/native queries, immutable details versus arena costs, transformed hit policies and late activation |
| [Exact retained text compression](text-map-compression-luna.md) | Bit-exact stop reconstruction, measured-capacity controls and costed rank/template proposals |
| [Intrinsic text work elimination](intrinsic-text-measure-luna.md) | Existing Parley metric scan, Cephal axis/run-mode authority and pre-break admission gates |
| [Caret work before scoped parallel text](scoped-parallel-text-next-luna.md) | Exact shared-affinity recurrence, independent producer oracles and priced worker/planner ownership; isolated candidate |
| [Presented transform factorization](presented-transform-factorization-luna.md) | Exact translation/size carrier, epoch-local bases and audited query/ACK obligations; isolated implementation, no measured adoption yet |
| [Reader/cohort implementation seam](reader-cohort-implementation-luna.md) | Typed Library question, exact input-version admission, source replacement and bounded completion ownership; Salsa/Bevy/Adapton comparisons |
| [Direct reactive style ports](style-ports-luna.md) | Proposed typed sink/fanout integration, numeric promotion, sparse override bases, packed destinations and exact publication/impact gates |
| [Pointer/gesture authority](pointer-gesture-authority-luna.md) | Proposed shared native/test reducer, source and presentation stamps, origin/cancellation contracts and repeated hit work |
| [Paint-only source path](paint-only-command-patch-luna.md) | Source/complete-scene/presented cuts, sparse color edits, pending geometry, queue ordering and retained-renderer precedents |
| [Transactional paint substrate](paint-patch.md) | Implemented Canvas/GPU borrowed guards, positional locators, support/opacity proofs, active storage and remaining runtime coupling |
| [Field and immutable text ownership](text-ownership-luna.md) | Checked source namespace, thin text leases, exact Triomphe allocation comparison and dependency costs |
| [Lossless color packing](color-packing-luna.md) | Word-aligned Oklch, bounded Linear sRGB exponent codec and exact 16-byte author colors without narrowing HDR admission |
| [Style representation](style-core-representation-luna.md) | Actual allocator costs for sparse overrides, exact dimension encoding, authored/derived layout separation and conditional sharing |
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
