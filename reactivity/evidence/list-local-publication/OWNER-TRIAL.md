# Owner-description text witness follow-up

Preregistered before implementation. Raster candidate
`9e6fd06e114d2fdc61e27beaea64ed08b7b9c01e` admitted 80/80 direct-source stream
updates, but 0/80 owner-stream updates. Scroll, both and fractional remained
0/80, as expected for changed geometry. The raster trial required admission
in both stream paths and therefore failed; no performance trial follows from
that result. Public pixel/semantic tests pass; the first focused Clippy attempt
failed a test-only constant-chunk lint, preserved with its correction.

`describe_inner` already compares the complete new description but discards
the exact single text destination. Only the direct-source `patch` path currently
sets `TextResources::dirty_text`. Recovering a witness during existing owner
reconciliation can avoid rebuilding the complete scene after that description;
it does not skip, reorder, or cache application `View::view` calls.

Candidate boundary: a transient per-description witness, with no retained
field or second reactive graph. Start only from a coherent acknowledged
predecessor and one new source epoch, no existing dirty work, property edit,
editing/inspector activity, or changed pre-description viewport offsets.
Use existing comparisons to invalidate the witness for topology/identity,
non-text node state, styles/bindings, image/background resources, handlers'
action eligibility, list membership/metrics, semantic annotations, or clip
geometry changes. Exactly one surviving Text node may change text. The existing
unchanged-layout and exact Canvas run/material/clip/lease checks remain required.
Unsupported or uncertain cases take ordinary complete publication.

A source binding or callback capture may be replaced only under existing owner
semantics; this witness must not preserve an obsolete callback or source bank.
Changing names/descriptions alongside text must publish both through the full
path. Current logical viewport state must not masquerade as old P after wheel
writes. Failed newer descriptions must preserve old P and older eligible C.

Compose the separately qualified image correction into both alternatives first.
Retain PROTOCOL.md's semantic/native/negative gates and timing thresholds, with
stream-owner now a second primary <=0.8 and all other controls <=1.05. Both stream
paths must admit at least one of 80 actual-workload updates before timing. Add
public owner adversaries for text plus names, style, radius, image, handler,
list changes, coalescing and failed newer descriptions; compare full pixels and
acknowledged semantics. Falsify both wrong-P-row identity and an omitted non-text
invalidation. Freeze every attempt and preserve failures. No cache-hit, ZGX,
physical-GPU or scanout claim follows from software admission or CPU-only wins.

First owner witness `1f75a5ec2b` passed six public regressions, the existing sparse
unit and focused Clippy. Both bounded mutants failed actual pixels/semantics.
Actual owner-stream admission still failed (0/80): the witness incorrectly
required every old list row to be visible, including intentionally omitted
overscan rows. The corrected attempt preserves old visibility while its witness
survives; a full paint continues to recompute membership. An actual Workload
probe checks retained row identities/visibility across all owner-stream edits.
This is a correctness repair to the witness, not a changed admission threshold.

The fixed 300-process timing manifest is PROCESS_ORDER.json, seed20261029,
15 pairs per ten cases, alternating pair order. The control is `6895a10440`,
production `4afe067fe3e` plus the unchanged complete-cost harness and the same
independently qualified image correction. Timing remains unauthorized until
both stream admission and all semantic/native/negative gates pass.
