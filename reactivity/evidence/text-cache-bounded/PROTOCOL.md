# Bounded paragraph scratch: preregistration

Baseline production c7194c74e6, composed with the native comparison fixture at
49f1327177d76498d050122b52d8b1365f50f471. Previous cache capacity ledger observed
3,256,796 retained bytes after a 31,200-byte paragraph became a short label.
This is a separate experiment; preserve that cost and the original fast timings.

Hypothesis: keep immutable font registration but discard paragraph layout and
LayoutContext scratch after any session processes more than 1024 input bytes.
This fixed conservative cutoff is chosen before this campaign's measurements,
not claimed optimal. Short streaming labels up to 735 bytes remain reusable.
No new dependencies, unsafe, shared mutable owner or application API changes.
Scoped shaper remains the independent oracle. Font identity and panic rules stay.

Admission: cached planner retained requested bytes must stay <=256 KiB after
every capacity-ledger stage (cold, 31,200 ASCII, short, mixed-script, rejected
input, foreign font, original font), and return exactly to zero on clear/drop.
Exact glyph metrics and per-byte geometry must match fresh scoped shaping,
including layouts kept alive through trimming and font replacement. A mutant
that omits scratch trimming must fail the memory gate. The limit covers planner
allocations, not caller-owned strings/layouts/fonts, allocator or driver overhead.

Run five interleaved processes per 0/25/100/1000/10000 static-label cell against
full recording, sparse-only and unbounded cache controls. Same default release,
font and complete source-to-recording-plus-ACK fixture. Keep all raw batches and
source/binary/compiler receipts. Bounded cache must remain within 5% of unbounded
cache in every cell and preserve >=20% advantage over sparse-only at 0 and 1000
labels. Noise is inconclusive. Also report long-paragraph repeated/shrink CPU
and cold allocator costs; no claim of a universal text-cache speedup.

This remains a CPU/memory experiment. Equivalent native rendering, feature
coverage, physical GPUs and two hardware classes are separate unresolved gates.
