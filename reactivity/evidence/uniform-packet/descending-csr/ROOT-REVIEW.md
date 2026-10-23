# Descending in-place cursor: correctness and static qualification

Root independently reviewed the production and test patch at
`1c97566cf0a7140d4f258deab136342a609d5755`, the live-count/borrow proof, and
all upload, failed-preparation, replay and paint-patch paths. Root reopened all
7,387 archive payloads, 133,678,753 bytes, and all sixteen external binary and
compiler records. Copied archive and manifest hashes match. No production source
is adopted by this evidence commit.

The existing two endpoint words temporarily encode the descending write cursor
and remaining count. Subtracting 2^23+1 advances the cursor and consumes its low
count field together; a borrow decrements only a live high count. Uniform tiles
are excluded before interpreting overlapping bits. Exhaustion directly produces
the original start/end words. The separate cursor vector, reverse ordinal cutoff
and final statistics traversal disappear. The entire shader, generated WGSL and
all eight SPIR-V modules remain byte-identical to shipping.

All 52 fixed and 584 named images match shipping, along with complete work
counters. All 574 eligible CPU tile/reference packets match byte for byte; ten
scratch frames remain explicitly ineligible for packet comparison. Actual wrong
count and order controls fail and recover after restoration. Integer checks,
maximum-count production packet, default/fallback/offline tests, strict lint,
formatting and Apple/Windows compilation pass. Vulkan execution uses llvmpipe;
foreign targets have compile coverage only.

The measured renderer/state headers fall by 24 bytes and the actual cursor
capacity disappears. Against shipping, linked text falls 400 bytes, default
rodata grows 128 bytes, and data.rel.ro falls 48 bytes. The reverse helper loses
21 code bytes and sixteen own-frame bytes. Core grows ten lines relative to its
own baseline; no projected line reduction or dynamic stack claim follows.

A fresh matched 26-cell timing campaign is separately preregistered. Memory/code
adoption requires the entire historical per-cell regression gate to pass, plus
the correctness and storage proof. The historical speed gate will also be
reported, independently of memory-slice acceptance. There is no timing result,
speed claim, RSS claim or universal performance claim in this archive. That
[subsequently completed campaign](../descending-timing/ROOT-REVIEW.md) fails the
entire per-cell regression gate, so memory-slice adoption fails. Its complete
failure is retained separately; this earlier correctness/static archive is unchanged.
