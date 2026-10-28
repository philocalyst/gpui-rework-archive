# Finished allocation ownership with bounded metadata, isolated experiment

The standalone `0fc39c500c44f3059095975d0de4749815a3ef18` prototype stores a
NonNull pointer and separate u32 length/capacity fields. It retains the exact
Global Vec allocation without trimming, moving elements, adding a second cache
or reference counting. Counts must fit u32; failed admission returns the original
Vec unchanged. Safe shared/exclusive slice borrows cannot change those counts.
Drop reconstructs the original allocation layout and delegates element/unwind
cleanup to Vec. Into-Vec transfers that same destruction obligation back.

The owner and its Option occupy sixteen bytes on the tested 64-bit targets,
against Vec's twenty-four, and twelve on the tested 32-bit target, equal to Vec.
No pointer bits encode data and no target pointer-byte layout assumption is used.
Empty over-aligned buffers retain their original aligned dangling pointer. ZST
Vec capacity exceeds u32 on 64-bit and is returned unchanged; 32-bit admits it.
This is a bounded owner, not a drop-in replacement for arbitrary growable Vec.

Final normal tests and the compile-negative borrowed-lifetime example pass nine
cases. Strict all-target lint passes. Six strict-provenance/symbolic-alignment
Miri gates pass seven tests each: x86-64, i686 and big-endian s390x under both
Stacked and Tree Borrows. Cases cover allocation pointer/capacity preservation,
aligned empty buffers, independent cloning, partial-clone unwind, a panicking
element destructor, thread borrows and owned transfer. Normal allocation counting
finds zero requests for admission/return and the same single payload allocation
for the measured clone as Vec.

Two separately frozen broken implementations fail under Miri. Destroying a
17-u64 allocation with capacity sixteen reports an incorrect deallocation layout:
136 bytes were allocated but 128 were supplied. A shallow ownership clone reports
a dangling reference/use-after-free after the original owner drops. Both failures,
complete diagnostics and source patches are retained. These controls demonstrate
the checks execute; passing Miri is not a proof of all unsafe behavior.

Root independently checks all 26 recorded gate source maps against their Git
objects, then reopens all 240 archived payloads. The original strict-lint failure
on a test's constant assertion is preserved; only that assertion changed before
the repeated passing gates. The final destructor-unwind extension has its own pin
and six fresh Miri runs. The exact final normal test executable is frozen outside
Git with a hash in the manifest. Official Miri/compiler provisioning is recorded
in the earlier [word-text dossier](../word-text/ROOT-REVIEW.md); this experiment
uses ordinary allocation pointers and does not adopt its inline-byte encoding.

A separate Canvas integration is under qualification. It changes the actual
finished glyph owner while leaving the shared planner's temporary Vec in place.
Its initial forbid-unsafe/iterator and allocation-ledger fixture compilation
failures are retained. Actual text geometry, application allocation/peak/code,
source-line costs and backend qualification remain required. Standard boxed
slices are also a useful simpler control: they save the same inline words but
may trim spare capacity, changing allocation/copy work. No application speed,
RSS, whole-tree saving, production adoption or universal superiority is claimed.
