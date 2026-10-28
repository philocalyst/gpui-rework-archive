# Whole-pixel certified mask miss: preregistration

Parent mask-tiles productiond63782dd has exact GPU admission6d4d44a3 and actual
native selection audit68682a99,but native screenf0da94c8 fails: stream CPU
.923431477 versus.8; scroll/mixed ratios suppressed by baseline cadence failures.
All64 processes normal; rejection remains. This is a separate combined trial
against the qualified suffix baseline,not adoption of prior failed layers.

Hypothesis: many tile references touch pixels outside a glyph's actual mask
domain. For an existing LOWERED_MASK certificate,unit axes and quarter-grid
origin make the first/last sample positions exact and monotone. If the last
sample is before either domain start,or the first sample is at/after either
positive extent,all16 original sample_draw results are literal zero regardless
of clip membership. Evaluate the original sample_draw once at the first point
and reuse that exact source value for all16 original blends. Do not omit blends,
average colors,reassociate anchor/delta,or replace zero arithmetic with a no-op:
HDR signed zero/subnormal behavior must remain exact. No pending normalization
state or generic float-grouping certificate. Partial pixels keep current sampling.

Apply inside the existing ordered banked/marked-literal traversal. Avoid the
four-cell fetch preparation for a proven miss. Keep fallback/sample-major paths,
tile-selection semantics,publication epochs,atlas leases and all storage records
unchanged. No application API,dependency,unsafe,pipeline or retained-state change.
Charge one additional local source vector/flag and generated compiler/register
cost,plus the existing ordered16-color array. No claim of improved hardware
cache hits or BBTree async runtime; this is bounded operation reuse/early-exit
under an exact dependency certificate.

Early GPU gate: fresh GPU/canvas tests,strict Clippy,and all336 unchanged public
mask-lattice frames exact against independent pre-changeoracle6faae98a. Existing
proof-toggle,inline/compact,replay,HDR negative-zero/subnormal,clip and transform
checks stay unchanged. Bounded mutant removes only the whole-pixel-miss condition,
reusing the first sample for every lowered mask; the ordinary proof-toggle
fixture must then fail exact pixels. Preserve all failures,actual shader/executable
identities and source guards. A separate instrumented native audit must confirm
selected literal tiles and a nonzero planned whole-pixel-miss population on the
real workload,with unchanged shader/workload and exact initial0/190 images.
Only first-packet support enumeration is needed; no performance claim from logs.

Matched early native screen after independent admission/audit: opt3/fatLTO/CGU1,
nightly2026-10-23 and baseline executablecompiled2684821f;17 workload tests each,
10 preflights,64 eight-second processes (8 AB/BA pairs per idle/scroll/stream/both),
initial0,trace,shuffle seed20261117. Default ingress precise only for stream,
owner otherwise. Same font,960x720,X11:94,llvmpipe4. CPU visible+1..6s spans>=4.8s.
Active464–488 updates,<=2 first-second ACK gaps>25ms,zero later; idle0. Any
execution/work/cadence failure suppresses its whole mode's comparative ratio.
Paired median CPU<=.8 stream/both,<=1.05 scroll; idle observed median CPU<=
baseline with no zero-denominator ratio.10000 paired bootstrap/type7,seed reset
per mode. No retries/subsets/threshold changes. Freeze scripts/verifier before
observations; no build,test,edit,analysis or cleanup during timing. Minimum8GiB.

A pass admits full configuration/native/offline/actual-X11 gates,then unchanged
28-case4160-process complete cost matrix(seed20261118),then a fresh matched
ZGX trial. All cold,RSS,allocation,work,header,line,shader/ELF/stack and vendor
costs remain charged. Physical GPU,two hardware classes,scanout and quality
gates remain required. All changes local; earlier failures retain their verdicts.
