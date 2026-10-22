# Read-only property/basis integration audit

Source: immutable main f0bd5335ae. No builds, timing, shipping edits or guarded-main mutations.

## Integration

`integration-patch-ids.json` compares e5f848ca14433905185956495bd5f9c6ef0d51df..d8b26c1179296009b637cdb8adc1d25285d2751b against f0bd5335ae^..f0bd5335ae per intended code file. Twelve of thirteen stable patch IDs match. lib.rs alone differs to preserve the separately integrated checkbox export. Existing checkbox element changes precede B; no B machinery was dropped.

## Authority/lifecycle findings

No basis/P authority blocker found by source review.

* Radius Set/Inherit reaches canonical GeometryStyle Overrides; transforms reach Style Overrides. Property ID chooses destination, while Number is not assumed to imply Style. The callback runs only after validated current-L target resolution; no source/projection borrow crosses logical mutation. Coarse reconciliation then refreshes lower declarations using Overrides::resolve, preserving latest bases under Set. Inherit reveals that lower base. Equal default presence is retained independently of destination equality.
* General coefficients are emitted only into local C geometry_records; parent-index reuse refers only to that same C prefix. Placements and MapBasis are copied with the C rows. Geometry::freeze appends sorted identity-qualified radii, preserving basis indices. Frozen P queries resolve only P's own stream; they never borrow mutable current radii or current Style.
* A successful full preparation publishes rows, text leases, geometry column and latest token only after fallible lowering finishes. A failed preparation retains old complete C and its column. A later old-C acknowledgement swaps that exact complete geometry; current logical Set/Inherit is independent. The basis lifecycle tests already exercise this without B, while B tests exercise accepted singular transform plus repair.
* Empty geometry is a real candidate when old P owns records: existing Geometry makes geometry_sheet Some(empty), so ACK replaces old geometry and permits reclamation. Removing Geometry based only on current/default values would be wrong; unused correctly also requires presented empty and candidate None.
* Paint KEEP does not rebuild geometry and preserves prior rows/placement/basis and geometry stream. If a prior full C is pending, the bank change merges damage into that same full prepared candidate rather than inventing KEEP rows. If preparation failed, dirty stays true; the color fast path cannot admit a bank-only candidate. Metadata-only publication changes neither basis owner nor geometry candidate; its dirty/complete_epoch guard prevents relabelling a newer failed S as a completed visual state.
* Reply projector BindError after S restores the owned Handler then poisons the owner. This clears prepared/latest token and logical validity before another operation can resolve an index. The geometry column may remain allocated, but there is no surviving token that can ACK it or live owner query that can interpret it as new authority. Request/reply panics follow the same restoration/quarantine order.
* B's after_source(None) always performs ordinary coarse reconciliation, including virtual-list realization. Retained node identity qualifies overrides; removed/key-rebound nodes lose them. Geometry current is rebuilt from admitted nodes and frozen radii are filtered by actual published identity. No geometry index survives into a different sheet by list position alone.

## Uncovered diagnostic counterexample proposal

No test or shipping change was made. A property route with a no-op reply can under-report Commit.changed_nodes for an actual style edit:

1. Model renders target div.w(10) and Apply button.
2. Apply proposal is Width Set(Dimension(Some(20))); reply does nothing.
3. apply_property_value_at sets changed_nodes=1 and dirties the actual target.
4. after_source(None) calls describe; its previous_style is already 20 and the resolved override is also 20, so no declarative node is newly different and describe_inner finally overwrites changed_nodes with 0.
5. Preparation and width20 are correct, but Commit reports zero changed nodes. Public direct setter for the same edit reports one.

Suggested smallest ordinary regression: capture target into model with update; activate Apply; assert actual property20, source+1/one prepare, no reply model delta and changed_nodes1; then switch proposal to Inherit and repeat for10. A same-target reply changing visible text needs a union rather than blind addition to avoid double count. This is accounting, not a stale basis finding; owner interpretation of changed_nodes must be settled before repair.

## Checked-description failure qualification

A reply may commit a contribution and model change, then fail checked description (e.g. expose an unregistered text_input). This differs from a failed prepare: describe_with revokes logical_valid. Next repair deliberately remounts all identities; identity_recovery.rs explicitly requires pre-failure Targets to retire. Overrides bound to those retired nodes are then pruned. Thus B cannot promise that a contribution survives onto a replacement target after checked-description failure. Old acknowledged P and old complete C remain coherent; status/model changes and S were committed. A future ordinary test should explicitly qualify this boundary with radius and transform, but retaining an override across fresh identities would violate the existing target contract.

## Remaining coverage seams

The new combined campaign exercises B and basis cases separately. Strong follow-up public traces (not run in this review) would pair a no-op reply radius/general-transform action with: pending custom C followed by failed new L; an empty/default repair ACK; a paint KEEP source update after the action; a checked-description failure and fresh-target repair; and a virtual-list row reorder/removal in the reply. These would improve interaction coverage without new APIs. No native owner adoption/picker API implementation is included.
