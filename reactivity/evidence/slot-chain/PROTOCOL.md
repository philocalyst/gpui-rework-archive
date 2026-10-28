# Bounded same-slot publication chain, live raw renderer

Parent b2d48370d75482e300befd81d4f0bcbbedd560c7 qualifies the actual native seam.
Production already stages16B with zero full validations/bin visits for one
eligible edit. Two same-slot edits before consumption instead stage114960B,
validate1024 draws and visit8220 bins at1024 nodes. Investigate this demonstrated
publication cost; no B adoption, compression choice, A encoding or new registry.

## Hypothesis and bounded authority

Extend the existing one-slot transition with one checked final sequence. Retain
only one anchor token, one final sequence and one latest SlotEdit: constant
storage independent of chain length; no log/Vec/hash index. Extend the anchor
only when the previous final sequence equals the exact current predecessor,
namespace matches, destination slot matches, and the newly completed token is
the checked successor. Latest-value equality alone is insufficient. Native
consumption must match both anchor and final complete token. Intermediate
packet consumption without matching anchor remains a conservative full fallback.

Successful latest acknowledgement clears the summary, so the next single edit
starts at that exact predecessor. Stale acknowledgements cannot clear it.
Description, dirty/full preparation and failed admitted patch preparation revoke
chain authority; replacement/geometry/alpha/resource changes keep existing full
preparation. Failed newer candidates preserve older eligible complete pixels,
not a certificate that the failed source was rendered. Different slots may use
the original single-transition behavior only; no multi-slot accumulation.

Same-slot source fanout shares the existing paint bank and support union. Old/new
support is identical only for the admitted equal-alpha, unchanged-geometry
class. Queue submission ordering and native image/token checks remain unchanged.
No deferred encoded-command or coherent shared-memory claim. Positional PaintSlot
is not semantic subtree identity.

## Bounded correctness and storage gates

Retain original raw/full renderer and fresh-Window CPU oracles. Adapt the live
Source test to require16B/zero full validations/bin visits for coalesced same-slot
updates at1/9/32/256/1024, plus shared64 contributors. Keep cheap single-edit path,
coalesced A→B→A, long chains (1000 writes), stale/latest acknowledgements, foreign
namespaces, replaced destinations, distinct slots, full geometry/alpha routes,
failed newer preparations and older eligible presentation. Existing overlapping
submitted-target pixel checks must still pass. Add negative chain-continuity and
namespace/slot witnesses; a forged anchor across geometry must produce wrong GPU
pixels. Latest-value equality cannot authorize crossing a lost predecessor.

Count exact source and GPU work, retained header growth and allocation counts;
no new allocations on admitted warm updates. Source freeze, owned target,
release checksum-freshness, before/after guards, actual executed ELF/generated
shader identity, relevant runtime tests, actual GPU gate and strict Clippy.
Preserve failed attempts. Header growth and single-edit overhead remain costs.
No performance admission from work counters. A later frozen live cost comparison
must include Source dispatch/preparation/staging/GPU completion/ack and the already
cheap single-edit control, with the current raw implementation as control. No
prototype Python p95 carries into that comparison.

## Required handoff back to the architecture target

What generalizes: a compact chain certificate can preserve exact update authority
across superseded intermediate states, with explicit rejection and full fallback.
What does not: one paint-bank destination neither describes semantic subtree
extent nor supplies ancestor/layout/clip/resource dependency closure, structural
relocation or arbitrary multi-slot transactions. This experiment does not change
the display-tree representation. After this bounded gate/cost decision, return
to those structural/dependency and storage requirements instead of extending an
indefinite family of paint-only paths. Cold compression remains separate and must
charge expanded mirrors, directories, scratch, raw compatibility and GPU decode.

The first frozen cohort b83fb91e passes chain/storage/live GPU/Clippy gates and
is preserved. Before sealing, strengthen revocation at RuntimeMut::drop whenever
source epoch is ahead of complete epoch, dirty or logically invalid, covering
early error returns independently of individual preparation helpers. Add an
explicit stale-final-token rejection and bounded early-error borrow witness.
No new publication class, relaxed oracle or performance inference.
