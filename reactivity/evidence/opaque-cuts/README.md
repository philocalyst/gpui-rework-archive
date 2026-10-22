# Opaque cuts and HDR signed zero

An opaque draw does not always erase the numerical effect of its backdrop.
With linear HDR output, a negative backdrop followed by opaque negative zero
produces half-float `0x8000`; starting that last draw over positive zero produces
`0x0000`. The external public-Canvas regression fails both fresh and cached-cut
cases against the frozen `05af5841e1` library. `control.log.gz`, the consumer,
build messages and `gpui-opaque-color-control.json` preserve that control and its
copied binary/library hashes. Those copies live outside Cargo's mutable target.

The integrated fix excludes negative zero and negative subnormal working RGB
from backdrop-discard certificates. A committed paint edit that changes this
eligibility marks a spare bit in the existing raster bounds. The next CPU repair
retires cached cut words once, retaining the geometry CSR. Both eligibility
directions revoke certificates, so ordinary colors can acquire a new cut later.
Dropped/rejected edits do not revoke anything. No header or allocation is added.

`checks.json` pins the actual integrated source, which differs from the isolated
`ff9072eb07` prototype. `parallel.log.gz` records 145 passing tests, four ignored;
`clippy.log.gz` records strict all-target GPUI/Canvas checks with parallel enabled.
`application.log.gz` records three passing ordinary application tests. The new
application test updates a registered color Signal, reads its typed property and
compares every HDR pixel to a freshly opened window, with zero paint walks and
view reruns. It uses no PaintEdit, private paint index or presentation token.

The identity admission helper in the same integration keeps the already checked
identity for identity-only callers instead of rereading it from Node. It shares
all cohort and logical-lifetime checks with the index-returning wrapper. No
timing claim is made for either change; earlier timings retain their source pins.
