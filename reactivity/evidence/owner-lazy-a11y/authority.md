Publication-stamp deletion candidate: authority argument (not qualification)

Queued commands contain no publication-relative geometry pointer or raw text offset. Their authority is activation session + native node identity + normal owner admission, not global tree age.

Command algebra:
* Activate, Focus, Blur: target/intent only. Static IDs resolve the live logical site. Dynamic input roots additionally resolve the current exact registered FieldId and immutable text lease. Action support/current presentation/focus admission remains normal Win.perform behavior.
* SetValue: same dynamic root authority, owned bounded replacement bytes. No source-relative endpoints.
* SetTextSelection: target root must exist; each endpoint node must belong to the current cohort's never-reused run range. Input.position interprets its character index with that exact immutable source and geometry, then normal selection admission checks it.
* ReplaceText: same explicit endpoint proof plus bounded owned replacement bytes.
* ReplaceSelectedText: no old selection snapshot exists in the request. Its contract edits the current admitted logical selection; root lease and normal Win.perform still apply.
* Scroll (direction/unit), ScrollTo (physical offset), ScrollIntoView: current target action support and normal scroll authority apply. local_scroll_action uses current acknowledged basis, already the behavior for static IDs (the global stamp only guarded dynamic roots). Unsupported operations remain rejected by normal action admission. There is no position-bearing dynamic-root operation bypassing source/geometry checks.

Cohort root IDs survive only same logical input, registered field and immutable source allocation. Run ranges also require identical TextGeometry Arc; old ranges never recycle, including empty cohort/deactivation. Source change observed at publication retires the root forever. Source ABA before publication can preserve authority only when normal current_presentation + exact field/lease qualification accept the same source; changed bytes cannot reuse a live immutable allocation. An equal static/empty allocation means equal source bytes, not a resurrected different source. Rebinding/kind replacement retires logical identity and owner scope rejects old authority. Geometry-only change retires run IDs but deliberately preserves root-only position-free intent.

First real provider: owner projects cohort, installs receiver before sender in factory, then returns tree. senderNone callbacks drop before payload decoding; no legitimate placeholder platform action is advertised. After sender exists, requests are harmless without matching cohort IDs/current owner authority.

Old/new publication interleavings: an old provider can load the new global stamp after an increment but before new tree visibility. Therefore that stamp already cannot prove old-provider freshness. Old text root/run IDs must be rejected independently when retired. Conversely unchanged IDs express the same authority and need not be globally rejected solely for a focus/metadata publication. A new provider action must not be rejected just because external visibility preceded an owner-side post-return increment.

The deleted atomic is also not a data-publication barrier: model/cohort/P/C state remains owner-thread-only; Queued carries owned commands and IDs. Standard mpsc transfers payload ownership, OnceLock publishes the initialized Sender, and the separate session atomic retains lifecycle synchronization. No borrowed GPUI source crosses this boundary.

Deactivation changes the checked monotone session; queued requests from old sessions are discarded even after reactivation. Queue capacity64, apply budget16, overflow terminal closure and explicit Bridge drop revocation remain unchanged. Queue remains owned across deactivate/reactivate. No ID reuse, unchecked wrap, backend patch, callback initialization or public API change is proposed.

The explicit unpublished-empty-ABA test distinguishes a source epoch from source authority: an intermediate source never published under an ID does not retire that ID if the final acknowledged field and exact immutable empty lease are unchanged. A root-only intent remains valid; this is deliberate admission, not a promise that every source epoch retires a root. Observed intermediate publication retires the ID permanently.

All this is an argument to test, not a substitute for existing exact old-P/source/geometry/namespace/failed-C oracles. Keep b244 as the separately pinned queue-only control.
