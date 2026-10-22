# Immutable literal paint sharing

Production source is `2f70493566`, based on the reviewed bank-rebind fix
`570b4d9274`. Candidate fixture pins are `76b012be65` and `1e5d2b147f`;
the separate fixture-only control is `4681430fef`. All earlier handoff
worktrees and artifacts remain unchanged. There are no timing measurements.

## Ownership and admission

Discovery compares all four working-color bit patterns, first against implicit
constants, then the last row, then at most the first 32 rows. It never matches
mutable source rows or positionally edited exclusive rows. A joined literal row
becomes immutable. PaintIndex writes detach immutable/source rows even for equal
values; unique rows update in place and become exclusive. Exclusive rows never
rejoin discovery, so subsequent edits do not accumulate color history.

Two existing spare PaintSupport coordinate bits distinguish immutable and
exclusive rows. Shared/rectangle retain their existing bits. All four flags are
masked before geometry operations; only shared/rectangle are exported to GPU
bank flags. Maximum admitted coordinate 16,384 and empty-support tests cover this
domain. PaintValue remains 24 B, Columns 48 B, and no retained headers, counters,
reference counts, destination arrays, dependencies, or unsafe code are added.

Whole-list validation reserves every required detach before commit. Neither
validation nor a dropped guard changes bindings, colors or ownership flags;
capacity may grow as before. Commit performs no allocation. Positional damage
uses the addressed group's existing outward-rounded bounds or glyph clip, not
the palette's aggregate support. A full bank still admits empty/clipped draw
calls without discovering/reserving a literal. A required COW detach can report
the existing ResourceLimit if no row is available; it never partially commits.

Every color writer was audited: PaintCommit exclusively uses the centralized
literal writer; SlotCommit validates shared rows only; full scene construction
uses discovery; images bypass color-row interpretation. Mutable sources never
alias literals. GPU positional writes still address independent draw/group
words, while source writes address only bank rows marked shared. The GPU schema
and draw strides do not change. Literal GPU colors are still repeated in draw
records; no GPU upload-elimination claim is made for this sharing change.

The private append callers emit either one inline shape/image or one grouped
text call, so a literal reference starts with one positional group owner.
Discovery, rather than glyph placement count, establishes additional owners.
Old immutable rows can remain after every owner detaches, until scene replacement.
This is bounded by construction/groups, not the number of repeated edits.

## Complete allocation controls

Both variants run the identical public fixtures under default release, in
dedicated targets. Each owner CSV has 48 rows, each Canvas CSV 45 rows. Counts,
requests, retained/peak bytes and actual command-lane capacities are recorded.
The owner fixture retains the original five empty/default/source/unique/unique
space controls and adds repeated nondefault, late alternating misses, and
repeated color with unique bases.

44 of 48 owner rows are byte-identical, including all count-0/count-1 cases,
source slots, unique colors, and late alternating misses. The four differences
are the repeated nondefault 4,096-node cases:

| Case | Retained control → COW | Peak control → COW | Allocations |
| --- | ---: | ---: | ---: |
| Repeated literal mount | 2,562,724 → 2,464,516 B | 2,986,884 → 2,888,676 B | 1,239 → 1,229 |
| Repeated literal with pending C | 3,234,756 → 3,038,244 B | 5,348,228 → 5,250,020 B | 3,192 → 3,160 |
| Repeated literal, unique bases | 2,759,332 → 2,661,124 B | 3,167,108 → 3,068,900 B | 1,250 → 1,240 |
| Same with pending C | 3,431,364 → 3,234,852 B | 5,544,836 → 5,446,628 B | 3,225 → 3,193 |

The pending fixture adds one node and resizes while keeping acknowledged P;
its current command vectors cross a capacity boundary. The larger lane savings
must not be interpreted as two retained color banks. The unique-color/unique
basis owner remains 2,759,332 B, preserving the prior +81,920 B (+20 B/draw)
loss against the original pre-bank owner. This change does not fix that case.

The Canvas controls expose the cost after all aliases detach:

| 4,096 draws | Retained control → COW | Peak control → COW |
| --- | ---: | ---: |
| One repeated nondefault color, no edits | 344,064 → 245,856 B | 475,136 → 376,928 B |
| Same, equal or changed Set on every draw | 344,064 → 344,088 B | 475,136 → 426,104 B |
| 2,048 adjacent equal-color pairs, no edits | 344,064 → 294,912 B | 475,136 → 425,984 B |
| Same pairs, equal or changed Set on every draw | 344,064 → 393,216 B | 475,136 → 524,288 B |

The last case loses 49,152 B (12 B/draw): 2,048 old immutable palette rows remain
beside 4,096 exclusive rows. Requested bytes grow 786,096 → 835,248 B with the
same 35 allocations. The one-color case retains just one dead row (+24 B),
while allocations fall 35 → 26. Unique and late alternating Canvas cases are
unchanged. Private palette-only controls isolate one 96 B paint allocation for
4,096 repeats, versus 98,304 B retained for unique/late misses. Lookup remains
bounded, not complete interning: late alternating misses intentionally retain
4,096 separate rows. Admission and storage each perform a lookup.

## Emitted consumers and scope

Actual linked Canvas-consumer methods are saved, not inferred from source:
fill_shape stays 859 B; find_scope stays 558 B; admit changes 676 → 600 B,
store 430 → 443 B, support 333 → 331 B, and new find_literal is 293 B. These
sizes do not imply a latency win. Literal searches add bounded comparisons in
unique/miss cases. The public property getter and its earlier 112 B stack
reservation are not redesigned here.

| Consumer | `.text` control → COW | `.data` | `.bss` |
| --- | ---: | ---: | ---: |
| Canvas storage | 409,816 → 409,872 B | 14,424 → 14,448 B | 6,867 → 6,779 B |
| Owner storage | 7,965,713 → 7,964,753 B | 153,832 → 153,856 B | 4,051 → 4,987 B |
| Property consumer | 7,971,550 → 7,970,590 B | 154,888 → 154,912 B | 2,211 → 3,147 B |

These are linked, instrumented examples, not deployment sizes. Public headers
remain Canvas 488 B, PreparedScene 56 B, Style 88 B, El 176 B, Win 8 B.

The final Vulkan suite passes 40 tests, including queued A → positional B →
slot C without intermediate poll/readback, independent fresh GPU packets, and
exact HDR CPU bytes. Public COW tests cover equal detachment, local damage,
later discovery, source isolation, drop and rejection. Private tests cover
signed-zero distinction, 1,000 repeated writes without row history, support
flags/max coordinates and full-bank clipped/empty calls. Strict Canvas/GPU
all-target Clippy includes parallel and Vulkan features. Preliminary full
Canvas results and final focused counts are recorded separately and overlap;
they must not be added together. No new native, GPUI full-suite, documentation,
Miri, or hardware-performance result is claimed.

The first public fixture incorrectly expected exact rectangle rather than
existing outward-rounded damage; only that expectation was corrected. The first
GPU fixture omitted required opaque SDR clear; only the fixture was corrected.
Both failed logs are preserved. An early release build was canceled before use
to give the two package examples distinct executable names. Only the final
source/executable/fixture hashes in provenance are allocation controls.

The separate exceptional-color CPU cut fix is deliberately not included;
parent integration must preserve its class-transition invalidation hooks.
Recommendation: review the common repeated-color saving against the explicit
post-detach pair cost, then perform integrated qualification. No timing-based
adoption recommendation follows from this slice.
