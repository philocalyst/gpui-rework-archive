# Bounded paragraph scratch: memory gate passes, CPU admission fails

Preregistered edf3632ed6; production candidate fefa519956. Baseline c7194c74e6
is the exclusively owned, unbounded text cache. The native fixture at 49f1327177
supplies the identical allocation example. No application API or dependency
changes; a private bit records whether a session saw over 1024 source bytes.
When returning state to its cache, such a session discards LayoutContext and
paragraph buffers while retaining immutable font registration. Returned text
layouts own their geometry/font leases and remain valid through trimming.

The independent allocation ledger processes short text, 31,200-byte text, short
text again, mixed scripts, failed shaping, a foreign font and the original font.
Peak **retained** requested planner bytes fall from 3,290,684 in the original
control to 45,046. Immediately after the long paragraph, only 4,364 bytes remain;
a following short label returns to 45,046. Every measured byte is reclaimed on
clear. The deliberately disabled trim (only two reset statements removed) retains
3,290,692 bytes and fails the preregistered 256 KiB gate. Its extra eight bytes
are the candidate's new private state flag/alignment. Preserve both controls.

This does not reduce the long operation's transient peak (~4.82 MB beyond its
starting retained state). The first short shape after trimming pays 202 allocations
and 105,258 requested bytes, versus 14 allocations / 1,184 bytes when retaining
oversized scratch. The fixture excludes caller-owned inputs/layouts/fonts from
retained planner accounting; allocator/RSS/driver overhead is not inferred.

Five interleaved processes per five sizes and four alternatives, 2000 measured
updates each: all 100 runs / 20000 batches / 200000 operations are preserved.
Same font, pinned compiler and default release/simd; libraries actually rebuilt.

| Static labels | Bounded/full median paired CPU | Bounded/sparse | Bounded/unbounded |
| ---: | ---: | ---: | ---: |
| 0 | 0.26914 | 0.28497 | 1.06004 |
| 25 | 0.18354 | 0.24770 | 1.00705 |
| 100 | 0.11667 | 0.26915 | 1.05649 |
| 1000 | 0.01568 | 0.25550 | 0.95445 |
| 10000 | 0.00213 | 0.26339 | 0.98710 |

**Not admitted:** zero-static and 100-static median regressions exceed 5% against
the unbounded cache; pair ranges also show substantial noise. The large wins
against full/sparse recording do not waive this experiment's stricter gate.
These are recording-plus-ACK operations, not rendering or a competitor ranking.
The scalar CPU gate fails, so no full platform adoption is attempted. Four public
cache tests pass, including held large layouts, exact glyph/line/caret geometry,
font identity, invalid input and panic recovery. The existing full suite passed
on the unbounded predecessor, not on this candidate. Do not carry its verdict
forward. Further long/repeated-shrink timing and native qualification are pending.

Shipping core 36595 lines: +17 versus the compatible cache, +404 versus the
full-recorder control. No new production unsafe or vendor changes. The likely
next CPU investigation is isolating the large-buffer reset's cold code from the
common return path; that is an untested hypothesis, not an adoption exception.
Run `python3 verify.py` to recompute every reported ratio, allocation verdict,
exact batch count and payload hash. Losing and failed controls remain intact.
