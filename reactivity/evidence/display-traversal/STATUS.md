CPU gate f5eab1717bfb6787ad7c60e048cab5095fb12b50 passes82 checks. Sparse point
record visits are512/4608/16384/32768/32768 at1/9/32/256/1024 nodes, preserving
full pixels with no spatial-index operation on paint. Staircase painter reversal
fails496 pixels; omitted contributing page16; stale-index/new-node mismatch512;
omitted old support512. Structural rebuild work is explicitly recorded. These
are CPU model counts, not GPU timings or production integration claims.

Next frozen GPU gate adds actual visit readbacks and immutable spatial metadata
audits, plus public Source paint and integer-translation edits with fresh full
GPUI Window pixel oracles. A root-background staircase has a visible pixel for
every sibling. Point/index, geometry, deferred-oldest/stale completion,97-node
move/remove/insert and fully uncompressed full-scan controls remain separate.
The new spatial-leaf lifetime mutant must be detected by metadata reads even
when stale rendering correctly produces no pixel mutation. Original record
encoding is unchanged; no hot A types/shader are used here.
