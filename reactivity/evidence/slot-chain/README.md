# Bounded same-slot chain: correctness qualified, live cost pending

The actual production single-edit baseline already stages16B with zero full
validations/bin visits. This local experiment preserves that path and removes
the demonstrated full-publication fallback only for exact consecutive writes
to the same scene-qualified paint slot. No public API, registry, display-tree
representation, compression, A encoding or shared-memory protocol is introduced.

Final source **a10c29e6e0c62415609bf242e542f0778bceced7**; preregistration
3882dc9f964bea7bb7a64ebd7f109376fd9ce4c1; control live seam
b2d48370d75482e300befd81d4f0bcbbedd560c7. First successful cohort b83fb91e
is retained; final cohort additionally revokes summary authority at an incomplete
exclusive-borrow return. No timing or adoption verdict yet. B's failed overall
cost gate and A's withheld admission are unchanged.

## Result on the actual live path

Ordinary Win::set→existing private native decision→retained GPU output matches
all43 current CPU/fresh-Window/full-GPU pixel oracles (172 captured RGBA files)
in the final cohort. The preceding43-frame cohort is preserved separately.
Four chain/borrow unit tests and the allocation/header ledger pass; strict
Clippy all-targets, empty source guards, actual fresh executable and generated
shader-in-ELF checks pass. Actual foreign-slot and forged-across-geometry mutants
each change2,048 pixel bytes; their expected/actual images are preserved.

| Nodes | Control coalesced staging | Candidate coalesced staging | Control validations/bin visits | Candidate validations/bin visits |
| --- | ---: | ---: | ---: | ---: |
| 1 | 368B | 16B | 1 / 12 | 0 / 0 |
| 9 | 1,280B | 16B | 9 / 100 | 0 / 0 |
| 32 | 3,856B | 16B | 32 / 284 | 0 / 0 |
| 256 | 28,944B | 16B | 256 / 2,076 | 0 / 0 |
| 1,024 | 114,960B | 16B | 1,024 / 8,220 | 0 / 0 |

The already-cheap single-edit path remains16B/0/0 at every size. Shared64
contributors also use one16B slot. A1,000-update same-slot chain retains constant
summary storage, allocates zero additional bytes and stages16B on consumption.
An admitted chain returning to the GPU's existing color stages zero record bytes;
endpoint authority, not final-value equality alone, authorizes it. Retained repair
and full target copy still execute, so these are not constant total-frame claims.
The fixed single-target support repairs561 conservative pixels and copies4,096.

Geometry, alpha, distinct slots and replaced destinations retain full preparation;
foreign windows and missing predecessor/final sequence cannot extend the chain.
Stale acknowledgement does not clear current authority; latest acknowledgement
does. Failed newer preparation revokes the summary while retaining older eligible
complete pixels. Two already-submitted targets preserve their separate colors
through queue order. Deferred encoded commands across destructive writes remain
unsupported; no coherent shared-memory or generalized resource lifetime claim.

## Representation and exact costs

One SlotTransition holds an anchor PresentationToken, a final NonZeroU64 sequence
and one latest SlotEdit. It grows40→48B, with no allocation or length-dependent
log. Bound single-node mount retained bytes6,860→6,868; peak6,964→6,972;
allocation count45 unchanged. Unbound mount remains6,004 retained/6,108 peak,
35 allocations. Warm and1,000-write updates allocate0. Node24B, Presented64B,
Runtime1816B, Fanout32B, Metadata272B and Prepared40B remain unchanged. Repo
core_lines inventory38,044→38,077 (+33 shipping-library source lines; test code
excluded). These are local experimental library changes, not adoption.

Native update admission checks anchor, namespace and final sequence. Extension
also checks exact prior final sequence, same slot and checked successor. Full
preparation/description revoke the summary; the exclusive RuntimeMut return
additionally revokes it if source/complete epochs differ, dirty or logically
invalid. These checks and the extra8B are real single-edit costs awaiting live
timing. No work-count result substitutes for a complete endpoint measurement.

## Relation to the user's architecture target

The composable operation is `(C0→C1, slot s, v1) + (C1→C2, slot s, v2)` becoming
`(C0→C2, slot s, v2)` only under the same admitted immutable geometry/resource
meaning and exact endpoints. This transfers to a structural/dependency journal
as a requirement for explicit composition certificates and invalidation, not as
a ready-made journal implementation.

PaintSlot remains positional within a completed scene; it is not semantic subtree
identity. Arbitrary insertion/removal/move needs stable semantic identities,
extent/relocation accounting, ancestor/layout/clip closure, old/new damage and
resource lifetimes. One latest paint value cannot summarize those operations.
This experiment changes no display-tree layout and supplies no compressed GPU
subtree lookup or constant-time arbitrary replacement. Cold compression remains
separate, with expanded CPU mirrors, directories, scratch, raw compatibility
and decode cost fully charged. After this bounded experiment's live cost decision,
return to those structural/dependency questions rather than accumulating paint
fast paths indefinitely.

Next compare against the qualified live raw implementation, including the already
cheap single-edit endpoint and coalesced update. Time Source dispatch/preparation,
actual staging/render/GPU completion and acknowledgement under a prospectively
frozen paired protocol. This software Vulkan offscreen path excludes WSI/scanout;
B's Python0.98ms result is unrelated. Whole application/driver memory and hardware/
ZGX gates remain open. All changes remain local.

Verify: `PYTHONDONTWRITEBYTECODE=1 python3 reactivity/evidence/slot-chain/verify.py`.
