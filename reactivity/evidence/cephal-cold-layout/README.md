# Cephal performance branch integration

The requested upstream branch is actually named `perf/cold-layout` (the request
spelled it `col-dlayout`). Its pinned commit is
`20c4c494179078ddfde7e8532ffc93f28cf5b531`; package version remains 0.1.1.
The complete git archive, fixture licenses and provenance are retained. No claim
is made that upstream benchmark results transfer to GPUI.

The shared-tree adapter borrows interned `StylePlan` and dependency/kind metadata;
leaf observation remains conservative for arbitrary host measurements. One
preparation-local byte accumulates observed axes. No second owning layout tree
is introduced. Upstream's verify-cache suite and the core adapter oracle run
with shortcut recomputation and poisoned unrequested axes enabled.

The same public inspector tests exposed stale text measurement after caption
changes. Caption edits now invalidate the canonical layout cache, including
late fixed-box captions; the pending invalidation survives until another real
layout pass without requesting a follow-up frame. Public list tests also exposed
the new CSS containing-block semantics: rebased list rows now explicitly use
their own positioned viewport. Both losing logs are retained.

`checks.json` pins source and every log. Upstream tests retain their intentional
ignored cases; no ignored test is relabeled as run. Core and public verification
cover existing independent cold layout oracles, lists, scrolling, flex, editor
and inspector fixtures. Full combined dependency/native gates follow separately.
The adapter's initial extra box and partial storage counter are disclosed as a
control for the subsequent cache representation review. General non-parent
absolute contexts remain an explicit adapter gap before a full parity claim.
