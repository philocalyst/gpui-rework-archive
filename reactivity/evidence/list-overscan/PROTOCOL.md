Optional keyed overscan prerequisite, registered before implementation.
Base49f2221f8f2b9d448876b0cc650446b42188034e; unchanged ZGX reference
 a3678578980ef239058c557338ef9c544d356b0c. Unique local/list-overscan worktree
/home/user/gpui-list-overscan-lab and target /home/user/gpui-list-overscan-target.
No timing or competitor victory gate in this behavior slice.

Add El.overscan(usize) for uniform_list, default0, ignored for other elements
like existing list-specific row mapping. Preserve existing uniform_list signature.
Keep visible_range separate from realized_range; saturating/clamped expansion,
validate actual realized rows <=4096 before descriptions. Keep f64 row-height
admission semantics; no packing/precision change. First VISIBLE key is anchor.
Emit rebased rows from realized start. Existing clipping, pointer membership,
P/C authority and source coherence validation remain authoritative.

Opt-in overscan retains identities for all rows still in the realized buffer,
including offscreen rows; default0 preserves existing visible-only reuse policy.
Existing list authority requires candidate membership even for position-free
actions: buffered offscreen sites reject actions and visible queries/hits. Their
identity may become usable again when they return to visibility within the buffer. Leaving the realized buffer revokes
identity permanently. No historical key directory or source borrow is retained.
Charge cold ListSpec/ElementExtra and ListRow metadata, total shipping lines,
whole ELF and relevant optimized routine/stack costs; no unsafe/dependency changes.

Public tests: default/boundary/empty/end ranges; fractional offset; saturating
usize::MAX and actual4096 limit before row work; lazy250K/100K source; keys and
anchor across reorder/prepend; visible-to-buffer-to-visible target preservation,
removed-buffer target revocation; clipped queries/hit/focus; failed newer candidate
with eligible older ACK, recovery; exact pixels versus zero-overscan and cold
materialized oracle. Source key/index agreement covers overscan too. Actual native
list script with overscan exercises clipping, wheel, resize, ACK and accessibility.
Fresh negative: use visible start to materialize realized keys; ordinary public
oracle must fail. Freeze clean commits before every build, all-input before/after
guards, pinned nightly2026-10-23/content fingerprints, failures preserved. Full
default/X11 GPUI+Canvas, strict Clippy, native scripts. No timing during builds.
Controlled offset, reference wheel28, deferred controls and matched profiles remain
subsequent parity work before complete-path architecture performance experiments.

First gate found exact-boundary rows leaking through outward hit envelopes.
Correction: retain a logical buffered-slot flag (within existing ListRow padding)
and give slots outside visible_range empty paint/input clips before traversal.
The logical range is authoritative for overscan; do not epsilon-shrink shared
geometry or change the existing collapsed-span continuous-pointer contract.

Negative qualification refinement: the preregistered visible-start mutant keeps
correct pixels but associates them with wrong keys. The independent eager-image
oracle alone passes; preserve that limitation. The SAME mutant binary fails
existing public buffered-authority and keyed-bounds oracles. Qualification uses
those exact identity checks together with pixel equality, not images alone.
