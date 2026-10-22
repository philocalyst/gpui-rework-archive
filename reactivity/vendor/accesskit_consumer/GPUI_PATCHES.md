# Coordinated private text consumer

Complete crates.io `accesskit_consumer` 0.39.1, upstream commit
`ce8164ba92995cfa86005b6259115e08c8244253`, archive SHA-256
`8a45e2bb300bea6d5f33a82c3e051c3ddc6f41c209750f68a0acbe991a284344`.
Upstream Apache-2.0 and MIT licenses are retained.

This package depends on the adjacent private AccessKit fork. Text slicing and
UTF-8/Unicode scalar/UTF-16 offset conversions decode and validate its compact
exceptional selectable-unit lengths. Raw unit counts still index geometry and
positions. Invalid encoded runs and invalid selection endpoints are rejected
without panicking, including deserialized snapshots.

General navigation retains upstream interior-offset flooring. Explicit editing
adapters must additionally require exact round-trip equality before dispatching
a range action. See `../accesskit/GPUI_PATCHES.md` for the private schema and
compatibility boundary; upstream-only consumers cannot decode its escapes.
